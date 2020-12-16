function warped_img = get_hoja(template,im_dest)
% GET_HOJA a partir del template donde solo se veria el rectangulo de la
% hoja externa la warpea
% - Recibe el template
% - Recibe donde quiero aplicar el warp
% - Sale la hoja warpeada
im_marco = icanny(template,1,0.4,1);
figure();
idisp(im_marco)

size_temp = size(template);
th_base = 1;
border_lines = 0;

% Si encuentra 4 seguro son los del recuadro, porque no hay otra cosa
while(border_lines < 4)
    th_base = th_base - 0.05;
    imlin_temp = Hough(im_marco);
    imlin_temp.houghThresh = th_base;
    imlin_temp.suppress = 15;
    lineas = imlin_temp.lines;
    border_lines = size(lineas);
    border_lines = border_lines(2);
end
imlin_temp.plot

% Genero las lineas para el warping
imlinea1=generarlinea(lineas(1).rho,lineas(1).theta,size(template,2),size(template,1));
imlinea2=generarlinea(lineas(2).rho,lineas(2).theta,size(template,2),size(template,1));
imlinea3=generarlinea(lineas(3).rho,lineas(3).theta,size(template,2),size(template,1));
imlinea4=generarlinea(lineas(4).rho,lineas(4).theta,size(template,2),size(template,1));

bordescartel_t = (imlinea1+imlinea2+imlinea3+imlinea4)==2;
[fil_t,col_t] = find(bordescartel_t);

posi = zeros(2,4);
posi(2,:) = fil_t;
posi(1,:) = col_t;

posi = order_points(posi(1,:),posi(2,:),size_temp(2),size_temp(1));
posf = [size_temp(2) 1 1 size_temp(2);1 1 size_temp(1) size_temp(1)];

matH = homography(posi,posf);
warped = homwarp(matH,im_dest,'full');
warpedth = warped>0.5;
figure();
idisp(warpedth)

warped_img = warpedth;
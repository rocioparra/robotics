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

delta = 0;
number_of_pts = 0;

while(number_of_pts ~= 4)
    % Genero las lineas para el warping
    imlinea1=generarlinea(lineas(1).rho,lineas(1).theta+delta,size(template,2),size(template,1));
    imlinea2=generarlinea(lineas(2).rho,lineas(2).theta+delta,size(template,2),size(template,1));
    imlinea3=generarlinea(lineas(3).rho,lineas(3).theta+delta,size(template,2),size(template,1));
    imlinea4=generarlinea(lineas(4).rho,lineas(4).theta+delta,size(template,2),size(template,1));

    bordescartel_t = (imlinea1+imlinea2+imlinea3+imlinea4)==2;
    [fil_t,col_t] = find(bordescartel_t);

    normas = round(sqrt(fil_t.^2 + col_t.^2));
    tam_norm = size(normas);
    tam_norm = tam_norm(1);
    point_redundante = zeros(tam_norm,1);
    cont = 1;

    for i=1:1:(tam_norm-1)
        aux_norm = normas(i);
        for j=i:1:(tam_norm-1)
            if(abs(aux_norm-normas(j+1)) < 2)
                point_redundante(cont) = i;
                cont = cont +1;
            end
        end
    end
    cont = 1;
    for i=1:1:tam_norm
        if(i ~= point_redundante)
            fil_tt(cont) = fil_t(i);
            col_tt(cont) = col_t(i);
            cont = cont +1;
        end
    end
    number_of_pts = size(fil_tt);
    number_of_pts = number_of_pts(2);

    if(number_of_pts ~= 4)
        % La quedo tengo que reajustar
        delta = delta + 0.001;
    end
end

posi = zeros(2,4);
posi(2,:) = fil_tt;
posi(1,:) = col_tt;

posi = order_points(posi(1,:),posi(2,:),size_temp(2),size_temp(1));
posf = [size_temp(2) 1 1 size_temp(2);1 1 size_temp(1) size_temp(1)];

matH = homography(posi,posf);
warped = homwarp(matH,im_dest,'full');
warped(isnan(warped)) = 0;
warpedth = warped;
figure();
idisp(warpedth)

warped_img = warpedth;
end
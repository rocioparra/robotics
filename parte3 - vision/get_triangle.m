function [fil_tri,col_tri] = get_triangle(hoja_final)
% GET_TRIANGLE recibe la hoja plana y devuelve los puntos del triangulo

size_f = size(hoja_final);
ref = ceil(2*min(size_f)/100);
hoja_finalAux = hoja_final;
hoja_finalAux(1:ref,:) = 0;
hoja_finalAux(:,1:ref) = 0;
hoja_finalAux(size_f(1)-ref:size_f(1),:) = 0;
hoja_finalAux(:,size_f(2)-ref:size_f(2)) = 0;

figure();
idisp(hoja_finalAux)

base_th = 1;
line_qty = 0;
while(line_qty < 3)
    base_th = base_th-0.05;
    imlin_tri = Hough(hoja_finalAux);
    imlin_tri.houghThresh = base_th;
    imlin_tri.suppress = 15;
    lineas_tri = imlin_tri.lines;
    line_qty = size(lineas_tri);
    line_qty = line_qty(2);
end
imlin_tri.plot;

imlinea1_tri = generarlinea(lineas_tri(1).rho,lineas_tri(1).theta,size_f(2),size_f(1));
imlinea2_tri = generarlinea(lineas_tri(2).rho,lineas_tri(2).theta,size_f(2),size_f(1));
imlinea3_tri = generarlinea(lineas_tri(3).rho,lineas_tri(3).theta,size_f(2),size_f(1));

bordes_tri = (imlinea1_tri+imlinea2_tri+imlinea3_tri)==2;
[fil_tri,col_tri] = find(bordes_tri);
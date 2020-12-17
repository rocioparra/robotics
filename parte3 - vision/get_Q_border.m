function [fil_q,col_q] = get_Q_border(im_q)
% GET_QUADRANT_BORDER obtiene el punto donde esta la esquina
% - Recibe el cuadrante de cualquier tamaño, mientras solo tenga 
% el blob de la esquina y el del fondo
% - Devuelve el punto en formato [fil,col]
% Se regula el threshold hasta que queden 2 lineas luego del suppress

base_th = 1;
line_qty = 0;
while(line_qty < 2)
    base_th = base_th-0.05;
    imlin_q = Hough(im_q);
    imlin_q.houghThresh = base_th;
    imlin_q.suppress = 15;
    lineas_q = imlin_q.lines; % Pero las de strenght=1 no me sirven
    lineas_q = lineas_q(lineas_q.strength ~= 1);
    % Tengo que filtrar por mayores a pi/4 o menores
    % Si logro que haya al menos una de cada ya esta
    lineas_A = lineas_q(abs(lineas_q.theta) < (pi/4));
    lineas_B = lineas_q(abs(lineas_q.theta) > (pi/4));
    A = ~isempty(lineas_A);
    B = ~isempty(lineas_B);
    line_qty = A+B;
end
figure();
idisp(im_q)
lineas_A(1).plot
lineas_B(1).plot

imlinea1_q = generarlinea(lineas_A(1).rho,lineas_A(1).theta,size(im_q,2),size(im_q,1));
imlinea2_q = generarlinea(lineas_B(1).rho,lineas_B(1).theta,size(im_q,2),size(im_q,1));
bordes_q = (imlinea1_q+imlinea2_q)==2;
[fil_q,col_q] = find(bordes_q);
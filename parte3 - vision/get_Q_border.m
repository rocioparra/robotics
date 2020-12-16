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
    lineas_q = imlin_q.lines;
    line_qty = size(lineas_q);
    line_qty = line_qty(2);
end
figure();
idisp(im_q)
imlin_q.plot
imlinea1_q = generarlinea(lineas_q(1).rho,lineas_q(1).theta,size(im_q,2),size(im_q,1));
imlinea2_q = generarlinea(lineas_q(2).rho,lineas_q(2).theta,size(im_q,2),size(im_q,1));
bordes_q = (imlinea1_q+imlinea2_q)==2;
[fil_q,col_q] = find(bordes_q);
function focused = focus_hoja_crop(hoja_plana,hoja_toFocus)
% FOCUS_HOJA toma la hoja ya plana y focusea el recuadro
% - Recibe la hoja plana para usar con fondo negro y resto lineas blanco
% - Recibe hoja a la que quiero aplicar el focus (puede ser distinta)
% - Devuelve lo mismo focuseado en el recuadro
size_hoja_final = size(hoja_plana);
th_base = 1;
num_of_lines = 0;
% Esto deberia andar bien, ya que la hoja ahora esta plana
while(num_of_lines < 7)
    th_base = th_base - 0.05;
    imlin_final = Hough(hoja_plana);
    imlin_final.houghThresh = th_base; 
    imlin_final.suppress = 15; 
    lineas_final = imlin_final.lines;
    num_of_lines = size(lineas_final);
    num_of_lines = num_of_lines(2);
end
figure();
idisp(hoja_plana)
imlin_final.plot
% Dejo las del recuadro solamente
% (despues puedo usar las del triangulo encontrando las intersecciones
% sacandoles el offset despues)
cont = 1;

for k=1:1:7
    if(abs(lineas_final(k).theta) > 1.5) % ~Pi/2
        lineas_recuadro(cont) = lineas_final(k);
        cont = cont+1;
    end
    if(abs(lineas_final(k).theta) < 0.1) % ~0
        lineas_recuadro(cont) = lineas_final(k);
        cont = cont+1;
    end
end

% Generar lineas de prueba recuadro
imlinea1_f=generarlinea(lineas_recuadro(1).rho,lineas_recuadro(1).theta,size(hoja_plana,2),size(hoja_plana,1));
imlinea2_f=generarlinea(lineas_recuadro(2).rho,lineas_recuadro(2).theta,size(hoja_plana,2),size(hoja_plana,1));
imlinea3_f=generarlinea(lineas_recuadro(3).rho,lineas_recuadro(3).theta,size(hoja_plana,2),size(hoja_plana,1));
imlinea4_f=generarlinea(lineas_recuadro(4).rho,lineas_recuadro(4).theta,size(hoja_plana,2),size(hoja_plana,1));

bordescartel_f = (imlinea1_f+imlinea2_f+imlinea3_f+imlinea4_f)==2;
[fil_f,col_f] = find(bordescartel_f);

pos_border = order_points(col_f,fil_f,size_hoja_final(2),size_hoja_final(1));

pos_border(1,1) = pos_border(1,1)-5;
pos_border(2,1) = pos_border(2,1)+5;

pos_border(1,2) = pos_border(1,2)+5;
pos_border(2,2) = pos_border(2,2)+5;

pos_border(1,3) = pos_border(1,3)+5;
pos_border(2,3) = pos_border(2,3)-5;

pos_border(1,4) = pos_border(1,4)-5;
pos_border(2,4) = pos_border(2,4)-5;

focused = hoja_toFocus(pos_border(2,1):pos_border(2,3),pos_border(1,2):pos_border(1,1));
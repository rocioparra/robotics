function focused = focus_hoja(hoja_plana,hoja_toFocus,crop)
% FOCUS_HOJA toma la hoja ya plana y focusea el recuadro
% - Recibe la hoja plana para usar con fondo negro y resto lineas blanco
% - Recibe hoja a la que quiero aplicar el focus (puede ser distinta)
% - Devuelve lo mismo focuseado en el recuadro
size_hoja_final = size(hoja_plana);
th_base = 1;
num_of_lines = 0;
% Esto deberia andar bien, ya que la hoja ahora esta plana
while(num_of_lines < 2)
    th_base = th_base - 0.05;
    imlin_final = Hough(hoja_plana);
    imlin_final.houghThresh = th_base; 
    imlin_final.suppress = 15; 
    lineas_final = imlin_final.lines;
    lineas_A = lineas_final(abs(lineas_final.theta) > 1.5);
    lineas_B = lineas_final(abs(lineas_final.theta) < 0.05);
    if(~crop)
        lineasA_M = find(abs(lineas_A.rho) > (size_hoja_final(2)/2),1);
        A_M = ~isempty(lineasA_M);
        lineasA_m = find(abs(lineas_A.rho) < (size_hoja_final(2)/2),1);
        A_m = ~isempty(lineasA_m);
        A = A_m && A_M;
        
        lineasB_M = find(abs(lineas_B.rho) > (size_hoja_final(1)/2),1);
        B_M = ~isempty(lineasB_M);
        lineasB_m = find(abs(lineas_B.rho) < (size_hoja_final(1)/2),1);
        B_m = ~isempty(lineasB_m);
        B = B_m && B_M;
        
        num_of_lines = A+B;
    else
        A = size(lineas_A);
        A = A(2);
        A = A>=2;
        B = size(lineas_B);
        B = B(2);
        B = B>=2;
        num_of_lines = A+B;
    end
end

% Dejo las del recuadro solamente
% (despues puedo usar las del triangulo encontrando las intersecciones
% sacandoles el offset despues)
% cont = 1;
% 
% for k=1:1:7
%     if(abs(lineas_final(k).theta) > 1.5) % ~Pi/2
%         lineas_recuadro(cont) = lineas_final(k);
%         cont = cont+1;
%     end
%     if(abs(lineas_final(k).theta) < 0.1) % ~0
%         lineas_recuadro(cont) = lineas_final(k);
%         cont = cont+1;
%     end
% end

aux = lineas_A;
[~,kM] = max(abs(lineas_A.rho));
[~,km] = min(abs(lineas_A.rho));
lineas_A(1) = aux(kM);
lineas_A(2) = aux(km);

aux = lineas_B;
[~,kM] = max(abs(lineas_B.rho));
[~,km] = min(abs(lineas_B.rho));
lineas_B(1) = aux(kM);
lineas_B(2) = aux(km);

figure();
idisp(hoja_plana)
lineas_A.plot
lineas_B.plot

% Generar lineas de prueba recuadro
imlinea1_f=generarlinea(lineas_A(1).rho,lineas_A(1).theta,size(hoja_plana,2),size(hoja_plana,1));
imlinea2_f=generarlinea(lineas_A(2).rho,lineas_A(2).theta,size(hoja_plana,2),size(hoja_plana,1));
imlinea3_f=generarlinea(lineas_B(1).rho,lineas_B(1).theta,size(hoja_plana,2),size(hoja_plana,1));
imlinea4_f=generarlinea(lineas_B(2).rho,lineas_B(2).theta,size(hoja_plana,2),size(hoja_plana,1));

bordescartel_f = (imlinea1_f+imlinea2_f+imlinea3_f+imlinea4_f)==2;
[fil_f,col_f] = find(bordescartel_f);

pos_border = order_points(col_f,fil_f,size_hoja_final(2),size_hoja_final(1));

if(crop)
    pos_border(1,1) = pos_border(1,1)-5;
    pos_border(2,1) = pos_border(2,1)+5;

    pos_border(1,2) = pos_border(1,2)+5;
    pos_border(2,2) = pos_border(2,2)+5;

    pos_border(1,3) = pos_border(1,3)+5;
    pos_border(2,3) = pos_border(2,3)-5;

    pos_border(1,4) = pos_border(1,4)-5;
    pos_border(2,4) = pos_border(2,4)-5;
end

focused = hoja_toFocus(pos_border(2,1):pos_border(2,3),pos_border(1,2):pos_border(1,1));
end
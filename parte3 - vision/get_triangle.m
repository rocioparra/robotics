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

delta = 0;
number_of_pts = 0;

while(number_of_pts ~= 3)
    % Genero las lineas para el warping
    imlinea1_tri = generarlinea(lineas_tri(1).rho,lineas_tri(1).theta+delta,size_f(2),size_f(1));
    imlinea2_tri = generarlinea(lineas_tri(2).rho,lineas_tri(2).theta+delta,size_f(2),size_f(1));
    imlinea3_tri = generarlinea(lineas_tri(3).rho,lineas_tri(3).theta+delta,size_f(2),size_f(1));

    bordes_tri = (imlinea1_tri+imlinea2_tri+imlinea3_tri)==2;
    [fil_t,col_t] = find(bordes_tri);
    
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
    
    if(number_of_pts ~= 3)
        % La quedo tengo que reajustar
        delta = delta + 0.001;
    end
end

fil_tri = fil_tt;
col_tri = col_tt;
end



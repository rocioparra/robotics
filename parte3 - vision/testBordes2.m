%% Test Parte 3 - Vision
clear all
close all
clc

% Cargo imagen original
im_orig=iread('cuadro2.jpg','double'); 
im_aux=iread('cuadro2.jpg','double','grey');
imth = im_aux>0.5;
figure();
idisp(im_aux)

% (Para Ari) cuadro2 habria que hacerla con codigo metiendo la original en 
% una plantilla que sea toda negra, y 20 pixeles por lado mas grande cosa
% de tener 4 margenes

im_size=size(im_aux);
% Genero template para quedarme con la hoja
for i=1:1:im_size(1)
    for j=1:1:im_size(2)
        if(im_aux(i,j) == 0)
            im_template(i,j) = 0;
        else
            im_template(i,j) = 1;
        end
    end
end

% Se warpea la hoja de trabajo primero
warpedth = get_hoja(im_template,imth);

%% Enderezamos ahora la hoja
im_marco_b = icanny(warpedth,1,0.4,1);
figure();
idisp(im_marco_b)

% Identificacion de lineas rectangulo
imlin_b=Hough(im_marco_b);
figure();
idisp(im_marco_b)
imlin_b.houghThresh=0.3;
imlin_b.plot
imlin_b.suppress = 15;
figure();
idisp(im_marco_b)
imlin_b.plot
lineas_b=imlin_b.lines; % Detecta las 4

% Generar lineas de prueba b
imlinea1_b=generarlinea(lineas_b(1).rho,lineas_b(1).theta+0.02,size(im_marco_b,2),size(im_marco_b,1));
imlinea2_b=generarlinea(lineas_b(2).rho,lineas_b(2).theta,size(im_marco_b,2),size(im_marco_b,1));
imlinea3_b=generarlinea(lineas_b(3).rho,lineas_b(3).theta,size(im_marco_b,2),size(im_marco_b,1));
imlinea4_b=generarlinea(lineas_b(4).rho,lineas_b(4).theta,size(im_marco_b,2),size(im_marco_b,1));

figure();
idisp(im_marco_b.*imlinea1_b+im_marco_b.*imlinea2_b+im_marco_b.*imlinea3_b+im_marco_b.*imlinea4_b)

bordescartel_b=(imlinea1_b+imlinea2_b+imlinea3_b+imlinea4_b)==2;
[fil_b,col_b]=find(bordescartel_b);

posi_b=zeros(2,4);
posi_b(2,:)=fil_b;
posi_b(1,:)=col_b;

aux_size = size(bordescartel_b);
% Ordenado de los puntos en estructura C
posi_b = order_points(posi_b(1,:),posi_b(2,:),aux_size(2),aux_size(1));

posf_b=[aux_size(2) 1 1 aux_size(2);1 1 aux_size(1) aux_size(1)]; 

% Con esto la llevo bordes al plano
matH_b=homography(posi_b,posf_b);
warped_b=homwarp(matH_b,warpedth,'full');
warpedth_b=warped_b>0.5;
idisp(warpedth_b)
% close all

%% Recorto la hoja
im_front = icanny(warpedth_b,1,0.4,1);
figure();
idisp(im_front)

im_hoja = focus_hoja_crop(im_front,warpedth_b); % Con crop de bordes feos
tam = size(im_hoja);

im_hoja = ~im_hoja;
figure();
idisp(im_hoja)
size_hoja=size(im_hoja);

%% Buscar lineas de bordes posta
% Separo en cuadrantes (provisorio)
im_q1 = im_hoja(1:(size_hoja(1)/4),(3*size_hoja(2)/4):size_hoja(2));
im_q2 = im_hoja(1:(size_hoja(1)/2),1:(size_hoja(2)/2));
im_q3 = im_hoja((size_hoja(1)/2):size_hoja(1),1:(size_hoja(2)/2));
im_q4 = im_hoja((3*size_hoja(1)/4):size_hoja(1),(3*size_hoja(2)/4):size_hoja(2));
% Se puede con blobs (para Ari): 
% - Si hay dos, es solo el fondo y la esquina
% - Si hay mas de dos, hay alguna parte del triangulo y hay que achicar el
% cuadrante (ir recortando a la mitad del anterior)
hoja_borders = [0 0 0 0;0 0 0 0];

% Q1
[fil_q1,col_q1] = get_Q_border(im_q1);
hoja_borders(:,1) = [col_q1+(3*size_hoja(2)/4);fil_q1];
% Los offset salen de la funcion que tiene que hacer Ari, 
% junto con los cuadrantes

% Q2
[fil_q2,col_q2] = get_Q_border(im_q2);
hoja_borders(:,2) = [col_q2;fil_q2]; % Recordar que va u - v

% Q3
[fil_q3,col_q3] = get_Q_border(im_q3);
hoja_borders(:,3) = [col_q3;fil_q3+(size_hoja(1)/2)];

% Q4
[fil_q4,col_q4] = get_Q_border(im_q4);
hoja_borders(:,4) = [col_q4+(3*size_hoja(2)/4);fil_q4+(3*size_hoja(1)/4)];

% Redondeo
hoja_borders = round(hoja_borders);

%% Ahora puedo hacer la transformacion final
% Esto deberia ser el tamaño de bordescartel
posf_hoja=[size_hoja(2) 1 1 size_hoja(2);1 1 size_hoja(1) size_hoja(1)]; 

matH_h=homography(hoja_borders,posf_hoja);
warped_h=homwarp(matH_h,im_hoja,'full');
warpedth_h=warped_h>0.5;
% warpedth_h = ~warpedth_h;
idisp(warpedth_h)
% close all

%% Focus de la hoja (Fixed)
hoja_final = focus_hoja(warpedth_h,warpedth_h);
figure();
idisp(hoja_final)




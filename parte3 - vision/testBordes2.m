%% Test Parte 3 - Vision
clear all
close all
clc
% Asumsiones:
% - Bordes negros
% - No esta rotada mas de 45°
% - No hay vertices dentro del cuadrado que define cada esquina de 20*20
% - Las esquinas no estan pegadas al borde de la hoja
% - No usar imagenes de 12M -> Pierde precision

% Cargo imagen original
im_orig=iread('cuadro5.jpg','double'); 
im_aux=iread('cuadro5.jpg','double','grey');
imth = im_aux>0.5;
figure();
idisp(im_aux)
figure();
idisp(imth)
% (Para Ari) cuadro2 habria que hacerla con codigo metiendo la original en 
% una plantilla que sea toda negra, y 20 pixeles por lado mas grande cosa
% de tener 4 margenes

im_template = generate_template(im_aux);

% Se warpea la hoja de trabajo primero
warpedth = get_hoja(im_template,im_aux);

im_size = size(warpedth);
close all
%% Recorto la hoja
% im_front = icanny(warpedth,1,0.4,1);
im_front = generate_template(warpedth);
im_front = icanny(im_front,1,0.4,1);
figure();
idisp(im_front)

im_hoja = focus_hoja(im_front,warpedth,1);
tam = size(im_hoja);
figure();
idisp(im_hoja)

im_hoja = im_hoja>0.5;
im_hoja = ~im_hoja;

size_hoja=size(im_hoja);
im_hoja(1:5,:) = 0;
im_hoja(:,(size_hoja(2)-5):size_hoja(2)) = 0;
im_hoja((size_hoja(1)-5):size_hoja(1),:) = 0;
im_hoja(:,1:5) = 0;

figure();
idisp(im_hoja)

im_hoja_closed = im_hoja;

% % Enmarco el borde con negro
% im_hoja_aux = im_hoja;
% 
% % Cierro borde para que el warp no lo arrastre
% figure();
% idisp(im_hoja)
% S = kcircle(1);
% im_hoja_closed = ~iclose(~im_hoja_aux,S);
% figure();
% idisp(im_hoja_closed)
% 
% figure();
% idisp(im_hoja_closed)
% 
% S = [0 1 0;0 1 0;0 1 0];
% im_hoja_closed = ~iclose(~im_hoja_closed,~S);
% figure();
% idisp(im_hoja_closed)

close all
%% Buscar lineas de bordes posta
% Separo en cuadrantes (provisorio)
im_q1 = im_hoja_closed(1:(size_hoja(1)/4),(3*size_hoja(2)/4):size_hoja(2));
im_q2 = im_hoja_closed(1:(size_hoja(1)/2),1:(size_hoja(2)/3));
im_q3 = im_hoja_closed((3*size_hoja(1)/4):size_hoja(1),1:(size_hoja(2)/3));
im_q4 = im_hoja_closed((3*size_hoja(1)/4):size_hoja(1),(3*size_hoja(2)/4):size_hoja(2));
% Se puede con blobs (para Ari): 
% - Si hay hasta parent 1 listo
% - Si hay mas, es porque probablemente esta el triangulo molestando
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
hoja_borders(:,3) = [col_q3;fil_q3+(3*size_hoja(1)/4)];

% Q4
[fil_q4,col_q4] = get_Q_border(im_q4);
hoja_borders(:,4) = [col_q4+(3*size_hoja(2)/4);fil_q4+(3*size_hoja(1)/4)];

% Redondeo
hoja_borders = round(hoja_borders);

%% Ahora puedo hacer la transformacion final
% Esto deberia ser el tamaño de bordescartel
posf_hoja=[size_hoja(2) 1 1 size_hoja(2);1 1 size_hoja(1) size_hoja(1)]; 

matH_h=homography(hoja_borders,posf_hoja);
warped_h=homwarp(matH_h,im_hoja_closed,'full');
warped_h(isnan(warped_h)) = 0;
warpedth_h=warped_h>0.5;
figure();
idisp(warpedth_h)

%% Focus de la hoja
hoja_final = focus_hoja(warpedth_h,warpedth_h,0);
figure();
idisp(hoja_final)

% Otra para Ari: con Hough ubicar los puntos del triangulo y pasar a cm


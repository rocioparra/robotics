%% Parte 3 - Vision
clear all
close all
clc
% Asumsiones generales:
% - Fondo negro
% - No esta rotada mas de 45° -> Sino se puede confundir la rotacion
% original
% - No hay vertices dentro del cuadrado que define cada esquina de 20*20
% - Las esquinas no estan pegadas al borde de la hoja
% - No usar imagenes de 12M (muy grandes) -> Pierde precision y tarda mil

% Cargo imagen original
im_orig=iread('cuadro5.jpg','double'); 
im_aux=iread('cuadro5.jpg','double','grey');
imth = im_aux>0.5;
figure();
idisp(im_aux)
figure();
idisp(imth)

im_template = generate_template(im_aux);

% Se warpea la hoja de trabajo primero
warpedth = get_hoja(im_template,im_aux);

im_size = size(warpedth);
% close all
%% Recorto la hoja
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
im_hoja(1:2,:) = 0;
im_hoja(:,(size_hoja(2)-2):size_hoja(2)) = 0;
im_hoja((size_hoja(1)-2):size_hoja(1),:) = 0;
im_hoja(:,1:2) = 0;

figure();
idisp(im_hoja)

im_hoja_closed = im_hoja;

close all
%% Buscar lineas de bordes posta
% Separo en cuadrantes
[im_q1,fil1,col1] = get_border_quadrant(im_hoja_closed,2);
figure();
idisp(im_q1)
[im_q2,fil2,col2] = get_border_quadrant(im_hoja_closed,1);
figure();
idisp(im_q2)
[im_q3,fil3,col3] = get_border_quadrant(im_hoja_closed,3);
figure();
idisp(im_q3)
[im_q4,fil4,col4] = get_border_quadrant(im_hoja_closed,4);
figure();
idisp(im_q4)

hoja_borders = [0 0 0 0;0 0 0 0];

% Q1
[fil_q1,col_q1] = get_Q_border(im_q1);
hoja_borders(:,1) = [col_q1+col1;fil_q1+fil1];
% Los offset salen de la funcion que tiene que hacer Ari, 
% junto con los cuadrantes

% Q2
[fil_q2,col_q2] = get_Q_border(im_q2);
hoja_borders(:,2) = [col_q2+col2;fil_q2+fil2]; % Recordar que va u - v

% Q3
[fil_q3,col_q3] = get_Q_border(im_q3);
hoja_borders(:,3) = [col_q3+col3;fil_q3+fil3];

% Q4
[fil_q4,col_q4] = get_Q_border(im_q4);
hoja_borders(:,4) = [col_q4+col4;fil_q4+fil4];

% Redondeo
hoja_borders = round(hoja_borders);
figure();
idisp(im_hoja_closed)

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

%% Extraigo puntos del triangulo
[fil_tri,col_tri] = get_triangle(hoja_final);

% Relacion de la hoja: 20cm x 15cm
size_f = size(hoja_final);
x = col_tri.*20./size_f(2); % En cm
y = fil_tri.*15./size_f(1); % En cm


%% Test Parte 3 - Vision
clear all
close all
clc

% Cargo imagen original
im_orig=iread('cuadro.jpg','double'); 
im_aux=iread('cuadro.jpg','double','grey');
imth = im_aux>0.5;
figure();
idisp(imth)

% Deteccion por color verde
% template0=imth(560:748,916:1110);
% figure();
% cerodetect=isimilarity(template0,imth);
% mesh(cerodetect)
% figure
% idisp(cerodetect)

im_marco = icanny(im_orig,1,0.4,1);
figure();
idisp(im_marco)

% Deteccion de bordes en figura
% K=ksobel();
% imbordeh=iconv(im_inv,K);
% imbordev=iconv(im_inv,K');
% imbordenorm=((imbordeh).^2+(imbordev).^2).^0.5;
% figure();
% idisp(imbordenorm)

% Filtro con threshold
% imedge=imbordenorm<0.01;
% figure();
% idisp(imedge)

% Identificacion de lineas
imlin=Hough(im_marco);
figure();
idisp(im_marco)
imlin.houghThresh=0.65;
imlin.plot
imlin.suppress = 10;
figure();
idisp(im_marco)
imlin.plot
lineas=imlin.lines;

% Generar lineas de prueba
imlinea1=generarlinea(lineas(1).rho,lineas(1).theta,size(im_marco,2),size(im_marco,1));
imlinea2=generarlinea(lineas(2).rho,lineas(2).theta,size(im_marco,2),size(im_marco,1));
figure();
idisp(im_marco.*imlinea1+im_marco.*imlinea2)

figure();
bordescartel=(imlinea1+imlinea2)==2;
idisp(bordescartel)

[fil,col]=find(bordescartel);
posi=zeros(2,4);
posi(1,1)=1;
posi(2,1)=1110;
posi(1,2)=fil;
posi(2,2)=col;
posi(1,3)=748;
posi(2,3)=1;
posi(1,4)=748;
posi(2,4)=1110;

posf=[1 1 748 748;1110 1 1 1110];
% Con esto la llevo bordes al plano
matH=homography(posi,posf);
warped=homwarp(matH,imth,'full');
warpedth=warped>0.5;
idisp(warpedth)

% Enderezamos ahora
im_marco_b = icanny(warpedth,1,0.4,1);
figure();
idisp(im_marco_b)

% Identificacion de lineas rectangulo
imlin_b=Hough(im_marco_b);
figure();
idisp(im_marco_b)
imlin_b.houghThresh=0.4;
imlin_b.plot
imlin_b.suppress = 10;
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

posf_b=[1100 1 1100 1;1 1 1381 1381];

% Con esto la llevo bordes al plano
matH_b=homography(posi_b,posf_b);
warped_b=homwarp(matH_b,warpedth,'full');
warpedth_b=warped_b>0.5;
idisp(warpedth_b)
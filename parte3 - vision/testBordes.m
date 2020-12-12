%% Test Parte 3 - Vision
clear all
close all
clc

% Cargo imagen original
im=iread('cuadro.jpg'); 
im=idouble(im);
im=imono(im);
figure();
idisp(im)

im_marco = icanny(im,1,0.4,1);
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
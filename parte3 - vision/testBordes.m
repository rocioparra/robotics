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

im_size=size(im_aux);

% Deteccion de bordes hoja
im_marco = icanny(im_orig,1,0.4,1);
figure();
idisp(im_marco)

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

% Ordenado de los puntos en estructura C
posi_b = order_points(posi_b(1,:),posi_b(2,:),1381,1100);

% Esto deberia ser el tamaño de bordescartel
posf_b=[1381 1 1 1381;1 1 1100 1100]; 

% Con esto la llevo bordes al plano
matH_b=homography(posi_b,posf_b);
warped_b=homwarp(matH_b,warpedth,'full');
warpedth_b=warped_b>0.5;
idisp(warpedth_b)
% close all

%% Recorto la hoja (provisorio hecho a mano)
im_hoja = warpedth_b(557:1641,346:1716);
warp_hoja = im_hoja;
figure();
idisp(warp_hoja)
im_hoja = ~im_hoja;
figure();
idisp(im_hoja)
size_hoja=size(im_hoja);

%% Buscar lineas de bordes posta
% Separo en cuadrantes
im_q1 = im_hoja(1:(size_hoja(1)/4),(3*size_hoja(2)/4):size_hoja(2));
im_q2 = im_hoja(1:(size_hoja(1)/2),1:(size_hoja(2)/2));
im_q3 = im_hoja((size_hoja(1)/2):size_hoja(1),1:(size_hoja(2)/2));
im_q4 = im_hoja((3*size_hoja(1)/4):size_hoja(1),(3*size_hoja(2)/4):size_hoja(2));
% Se puede con blobs (para Ari): 
% - Si hay dos, es solo el fondo y la esquina
% - Si hay mas de dos, hay alguna parte del triangulo y hay que achicar el
% cuadrante (ir recortando a la mitad del anterior)
hoja_borders = [0 0 0 0;0 0 0 0];

% Regular threshold hasta que haya al menos 2 lineas
% Despues con el suppress se recorta lo que encontro
% Q2
% imlin_q2=Hough(im_q2);
% figure();
% idisp(im_q2)
% imlin_q2.houghThresh=0.9;
% imlin_q2.plot
% imlin_q2.suppress = 15;
% figure();
% idisp(im_q2)
% imlin_q2.plot
% lineas_q2=imlin_q2.lines;
% 
% imlinea1_q2=generarlinea(lineas_q2(1).rho,lineas_q2(1).theta,size(im_q2,2),size(im_q2,1));
% imlinea2_q2=generarlinea(lineas_q2(2).rho,lineas_q2(2).theta,size(im_q2,2),size(im_q2,1));
% 
% figure();
% idisp(im_q2.*imlinea1_q2+im_q2.*imlinea2_q2)
% 
% bordes_q2=(imlinea1_q2+imlinea2_q2)==2;
% [fil_q2,col_q2]=find(bordes_q2);
[fil_q2,col_q2] = get_Q_border(im_q2);
% Los offset salen de la funcion que tiene que hacer Ari, 
% junto con los cuadrantes
hoja_borders(:,2) = [col_q2;fil_q2]; % Recordar que va u - v

% Q1 - Aca tome un cuadrante menor, chequear con las lineas si hay que
% achicarlo
% imlin_q1=Hough(im_q1);
% figure();
% idisp(im_q1)
% imlin_q1.houghThresh=0.65; % Lo baje de a 0.05 hasta encontrar con los dos bordes
% imlin_q1.plot
% imlin_q1.suppress = 15;
% figure();
% idisp(im_q1)
% imlin_q1.plot
% lineas_q1=imlin_q1.lines;
% 
% imlinea1_q1=generarlinea(lineas_q1(1).rho,lineas_q1(1).theta,size(im_q1,2),size(im_q1,1));
% imlinea2_q1=generarlinea(lineas_q1(2).rho,lineas_q1(2).theta,size(im_q1,2),size(im_q1,1));
% 
% figure();
% idisp(im_q1.*imlinea1_q1+im_q1.*imlinea2_q1)
% 
% bordes_q1=(imlinea1_q1+imlinea2_q1)==2;
% [fil_q1,col_q1]=find(bordes_q1);
[fil_q1,col_q1] = get_Q_border(im_q1);

hoja_borders(:,1) = [col_q1+(3*size_hoja(2)/4);fil_q1];

% Q3 - En este como en el 2 no hubo problema
% imlin_q3=Hough(im_q3);
% figure();
% idisp(im_q3)
% imlin_q3.houghThresh=0.9; 
% imlin_q3.plot
% imlin_q3.suppress = 15; 
% figure();
% idisp(im_q3)
% imlin_q3.plot
% lineas_q3=imlin_q3.lines;
% 
% imlinea1_q3=generarlinea(lineas_q3(1).rho,lineas_q3(1).theta,size(im_q3,2),size(im_q3,1));
% imlinea2_q3=generarlinea(lineas_q3(2).rho,lineas_q3(2).theta,size(im_q3,2),size(im_q3,1));
% 
% figure();
% idisp(im_q3.*imlinea1_q3+im_q3.*imlinea2_q3)
% 
% bordes_q3=(imlinea1_q3+imlinea2_q3)==2;
% [fil_q3,col_q3]=find(bordes_q3);
[fil_q3,col_q3] = get_Q_border(im_q3);

hoja_borders(:,3) = [col_q3;fil_q3+(size_hoja(1)/2)];

% Q4 - Achique el cuadrante nuevamente pq me tomaba el triangulo
% imlin_q4=Hough(im_q4);
% figure();
% idisp(im_q4)
% imlin_q4.houghThresh=0.85; % Tambien lo baje pq no encontraba en la otra direccion
% imlin_q4.plot
% imlin_q4.suppress = 15; % Nota que si ya hay una sola de cada, no hace efecto
% figure();
% idisp(im_q4)
% imlin_q4.plot
% lineas_q4=imlin_q4.lines;
% 
% imlinea1_q4=generarlinea(lineas_q4(1).rho,lineas_q4(1).theta,size(im_q4,2),size(im_q4,1));
% imlinea2_q4=generarlinea(lineas_q4(2).rho,lineas_q4(2).theta,size(im_q4,2),size(im_q4,1));
% 
% figure();
% idisp(im_q4.*imlinea1_q4+im_q4.*imlinea2_q4)
% 
% bordes_q4=(imlinea1_q4+imlinea2_q4)==2;
% [fil_q4,col_q4]=find(bordes_q4);

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
% Focus de la hoja (Fixed)
size_hoja_final = size(warpedth_h);

th_base = 1;
num_of_lines = 0;
while(num_of_lines < 7)
    th_base = th_base - 0.05;
    imlin_final=Hough(warpedth_h);
    imlin_final.houghThresh=th_base; 
    imlin_final.suppress = 15; 
    lineas_final=imlin_final.lines;
    num_of_lines = size(lineas_final);
    num_of_lines = num_of_lines(2);
end
figure();
idisp(warpedth_h)
imlin_final.plot
% Dejo las del recuadro solamente
% (despues puedo usar las del triangulo encontrando las intersecciones
% sacandoles el offset despues)
cont = 1;
for k=1:1:7
    if(abs(lineas_final(k).theta) > 1.5) % Pi/2
        lineas_recuadro(cont) = lineas_final(k);
        cont = cont+1;
    end
    if(abs(lineas_final(k).theta) < 0.01) % 0
        lineas_recuadro(cont) = lineas_final(k);
        cont = cont+1;
    end
end
% Generar lineas de prueba recuadro
imlinea1_f=generarlinea(lineas_recuadro(1).rho,lineas_recuadro(1).theta,size(warpedth_h,2),size(warpedth_h,1));
imlinea2_f=generarlinea(lineas_recuadro(2).rho,lineas_recuadro(2).theta,size(warpedth_h,2),size(warpedth_h,1));
imlinea3_f=generarlinea(lineas_recuadro(3).rho,lineas_recuadro(3).theta,size(warpedth_h,2),size(warpedth_h,1));
imlinea4_f=generarlinea(lineas_recuadro(4).rho,lineas_recuadro(4).theta,size(warpedth_h,2),size(warpedth_h,1));

figure();
idisp(warpedth_h.*imlinea1_f+warpedth_h.*imlinea2_f+warpedth_h.*imlinea3_f+warpedth_h.*imlinea4_f)

bordescartel_f=(imlinea1_f+imlinea2_f+imlinea3_f+imlinea4_f)==2;
[fil_f,col_f]=find(bordescartel_f);

pos_border = order_points(col_f,fil_f,size_hoja_final(2),size_hoja_final(1));

hoja_final = warpedth_h(pos_border(2,1):pos_border(2,3),pos_border(1,2):pos_border(1,1));
figure();
idisp(hoja_final)




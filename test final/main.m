%% Parte 1 - Caracterizacion del Robot
% Parametros DH
% Modelo ideal
close all;
clear all;
clc;

% Modelo ideal
Robot = Robot_gen(0,0.1);

% Modelo auxiliar con perturbacion
pert = 0.01;
Robot_p = Robot_gen(pert,0.1);

q0 = [0 0 0 0 0];
% Robot.plot(q0);

% Referencia de la mesa: x0 = 350 , y0 = 100
x0 = 0.350;
y0 = 0.1;
x_ref = [x0 y0 0]; % Donde pusimos la mesa
T_ref = transl(x_ref);
q_ref = Robot.ikine(T_ref, [0 0 0 0 0], 'mask', [1 1 1 0 0 0]);

% Prueba (OK)
% x_base es la mesa respecto a la terna base
r = 0.075;
x_base = [x0+r y0;x0+r -y0;x0-r -y0;x0+r y0];
mesa_ref = [x0+r y0];

% Obtengo triangulo de ejemplo desde imagen
[x_tri, y_tri] = vision_get_tri('cuadro5.jpg');

% Refiero las coordenadas a la terna base
y_tri_f = -x_tri + [mesa_ref(2) mesa_ref(2) mesa_ref(2)];
x_tri_f = -y_tri + [mesa_ref(1) mesa_ref(1) mesa_ref(1)];

tri_cord = [x_tri_f' y_tri_f';x_tri_f(1) y_tri_f(1)];

% Generacion de trayectoria
traj = traj_gen(Robot, tri_cord, 30);
trajXYZ = Robot.fkine(traj);
size_traj = size(traj);
size_traj = size_traj(1);

figure();
Robot.plot(q_ref) % Hasta aca todo bien
plot_box(x0+r,-y0,x0-r,y0,'linewidth', 3) % Mesa de 15x20

% Ploteo de trayectoria
for i=1:size_traj
    Robot.plot(traj(i,:));
    hold on;
    aux = trajXYZ(i);
    plot3(aux.t(1),aux.t(2),aux.t(3),'b.','MarkerSize', 3 );
    pause(0.2);
end

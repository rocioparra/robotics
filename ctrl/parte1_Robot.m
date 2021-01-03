%% Parte 1 - Caracterizacion del Robot
% Parametros DH
% Modelo ideal
close all;
clear all;
clc;

Robot = robot_gen(0.01)
% Referencia de la mesa: x0 = 300 , y0 = 100

q0 = [0 0 0 0 0];
Robot.plot(q0);
hold on;
plot_box(0.375,-0.1,0.375-0.15,0.1,'linewidth', 3)


x_ref = [0.300 0.100 0]; % Donde pusimos la mesa
T_ref = transl(x_ref);
q_ref = Robot.ikine(T_ref, [0 0 0 0 0], 'mask', [1 1 1 0 0 0]);

Robot.plot(q_ref) % Hasta aca todo bien

% Prueba (OK)
% x_base es la mesa respecto a la terna base
x_base = [0.375 0.100;0.375 -0.100;0.225 -0.100;0.375 0.100];
mesa_ref = [0.375 0.100];

% Triangulo de ejemplo hecho
x_tri = [0.0553    0.0558    0.1249];
y_tri = [0.0940    0.0351    0.0378];


y_tri_f = -x_tri + [mesa_ref(2) mesa_ref(2) mesa_ref(2)];
x_tri_f = -y_tri + [mesa_ref(1) mesa_ref(1) mesa_ref(1)];

tri_cord = [x_tri_f' y_tri_f';x_tri_f(1) y_tri_f(1)];

traj = traj_gen(Robot, tri_cord, 30);
size_traj = size(traj);
size_traj = size_traj(1);

plot_box(0.375,-0.1,0.375-0.15,0.1,'linewidth', 3)

for i=1:size_traj
    Robot.plot(traj(i,:));
    pause(0.2);
end


% TODO
% + Definir posicion de reposo: segun el modelo DH planteado
% - Definir posicion de referencia: esquina superior izquierda de la mesa
% - Con el primer punto del triangulo posicionar el Robot
% - Con los puntos del triangulo generar la trayectoria
% - Mover sobre la trayectoria generada
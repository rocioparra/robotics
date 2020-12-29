%% Parte 1 - Caracterizacion del Robot
% Parametros DH
% Modelo ideal
close all;
clear all;
clc;
N = 5;

L0 = 0.130;
L1a = 0.144;
L1b = 0.053;
L2 = 0.144;
L3 = 0.144;

alpha = [ 0     pi/2    0                   0   pi/2 ];
a =     [ 0     0       sqrt(L1a^2+L1b^2)   L2  0    ];
d =     [ L0    0       0                   0   L3   ];
theta_offset = [0, 0, 0, pi/2, 0];
qlim = [ -pi, pi; 0, pi-deg2rad(20); -pi/2, pi/2; -deg2rad(100), pi/2; -pi, pi]; % TODO

Links = Link.empty(N,0);
for i=1:N
    L = Link('alpha', alpha(i), 'a', a(i), 'd', d(i), 'modified', ...
        'offset', theta_offset(i), 'qlim', qlim(i, :));
    Links(i) = L;
end
Robot = SerialLink(Links,'name', 'Trossen');

% Modelo auxiliar con perturbacion
pert = 0.01;

L0_p = L0 + (2*rand()-1)*pert;
L1a_p = L1a + (2*rand()-1)*pert;
L1b_p = L1b + (2*rand()-1)*pert;
L2_p = L2 + (2*rand()-1)*pert;
L3_p = L3 + (2*rand()-1)*pert;

a_p =     [ 0     0       sqrt(L1a_p^2+L1b_p^2)   L2_p  0    ];
d_p =     [ L0_p    0       0                   0   L3_p   ];

Links_p = Link.empty(N,0);
for i=1:N
    L_p = Link('alpha', alpha(i), 'a', a_p(i), 'd', d_p(i), 'modified', ...
        'offset', theta_offset(i), 'qlim', qlim(i, :));
    Links_p(i) = L_p;
end
Robot_p = SerialLink(Links_p,'name', 'Trossen_p');

% q = sym('theta', [5, 1], 'real'); % angulos de los motores
% qd = sym('qd', [5, 1], 'real'); % dTheta/dt
% qdd = sym('qdd', [5, 1], 'real'); % d2Theta/dt2

% Referencia de la mesa: x0 = 300 , y0 = 100
q0 = [0 0 0 0 0];
% Robot.plot(q0);

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
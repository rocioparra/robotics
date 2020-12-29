%% Parte 1 - Caracterizacion del Robot
% Parametros DH
% Modelo ideal
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
qlim = [ 0, 180; 0, 180; 0, 180; 0, 180; 0, 180;]; % TODO

Links = Link.empty(N,0);
for i=1:N
    L = Link('alpha', alpha(i), 'a', a(i), 'd', d(i), 'modified', ...
        'offset', theta_offset(i), 'qlim', qlim(i, :));
    Links(i) = L;
end
Robot = SerialLink(Links);

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
Robot_p = SerialLink(Links_p);

q = sym('theta', [5, 1], 'real'); % angulos de los motores
qd = sym('qd', [5, 1], 'real'); % dTheta/dt
qdd = sym('qdd', [5, 1], 'real'); % d2Theta/dt2

% Definir posicion de reposo: esquina superior izquierda de la mesa
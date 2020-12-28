% parametros DH
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

Links = Link.empty(5,0);
for i=1:length(alpha)
    L = Link('alpha', alpha(i), 'a', a(i), 'd', d(i), 'modified', ...
        'offset', theta_offset(i), 'qlim', qlim(i, :));
    Links(i) = L;
end
Robot = SerialLink(Links);

q = sym('theta', [5, 1], 'real'); % angulos de los motores
qd = sym('qd', [5, 1], 'real'); % dTheta/dt
qdd = sym('qdd', [5, 1], 'real'); % d2Theta/dt2

% constantes
g = 9.8; % m/s
gravedad = [0 0 -g];

% Ganancias Critico Amortiguado
kp = 100;
kv = 2*sqrt(kp);

%% Capitulo 3 ejercicio 3: RRsyms th1 th2 thd1 thd2  thdd1 thdd2 real

Q=[th1 th2 th3 th4];
Qd=[thd1 thd2 thd3 thd4];
Qdd=[thdd1 thdd2 thdd3 thdd4];
syms L1 L2 g Ixx1 Iyy1 Izz1 m1 Ixx2 Iyy2 Izz2 m2  theta1 d2 real
gravedad=[0 0 -g];
% L1=5;
% L2=5;
%parametros DH
alpha=[0 pi/2 0 0 pi/2];
a=[0 0 sqrt(144^2+53^2) 144 0];
d=[130 0 0 0 144];

i=1;
Link1=Link('alpha',alpha(i),'a',a(i),'d',d(i),'modified');
i=2;
Link2=RevoluteMDH('alpha',alpha(i),'a',a(i),'d',d(i));

I1=[Ix x1 0 0 ; 0 Iyy1 0 ; 0 0 Izz1];
I2=[Ixx2 0 0 ; 0 Iyy2 0 ; 0 0 Izz2];

Link1.I=I1;
Link2.I=I2;

Link1.m=m1;
Link2.m=m2;

Tool = transl([L2, 0, 0]); % Offset de la herramienta (End Effector)

Robot= SerialLink( [Link1 Link2], 'tool', Tool,'name', 'Chaplin' );
Robot.gravity=gravedad;
T1 = Link1.A(th1); 
T2 = Link2.A(th2);
Tt = double(T1) * double(T2) * Tool;

q0 = [0 0];
% Robot.teach(q0) %modelo dinamico de posicion inicial q
M=Robot.inertia(Q);
V=Robot.coriolis(Q,Qd)*Qd'; %Matriz de coriolis
G=Robot.gravload(Q);
Tau=M*Qdd'+V+G;
% 
% Taui=Robot.itorque(Q,Qdd);
TAU = Robot.rne(Q, Qd, Qdd);





function Robot=Robot_gen(pert,toolDist)

Tool = transl([0, 0, toolDist]); % Offset de la herramienta

N = 5;

L0 = 0.130;
L1a = 0.144;
L1b = 0.053;
L2 = 0.144;
L3 = 0.144;

L0_p = L0 + (2*rand()-1)*pert;
L1a_p = L1a + (2*rand()-1)*pert;
L1b_p = L1b + (2*rand()-1)*pert;
L2_p = L2 + (2*rand()-1)*pert;
L3_p = L3 + (2*rand()-1)*pert;

alpha = [ 0     pi/2    0                   0   pi/2 ];
a_p =     [ 0     0       sqrt(L1a_p^2+L1b_p^2)   L2_p  0    ];
d_p =     [ L0_p    0       0                   0   L3_p   ];
theta_offset = [0, 0, 0, pi/2, 0];
%qlim = [ -pi, pi; 0, pi-deg2rad(20); -pi/2, pi/2; -deg2rad(100), pi/2; -pi, pi]; % TODO
qlim = [ -pi, pi; deg2rad(20), pi-deg2rad(20); deg2rad(-90), pi/2; deg2rad(-70), deg2rad(-20); -pi/2, pi/2];

Links_p = Link.empty(N,0);
for i=1:N
    L_p = Link('alpha', alpha(i), 'a', a_p(i), 'd', d_p(i), 'modified', ...
        'offset', theta_offset(i), 'qlim', qlim(i, :));
    Links_p(i) = L_p;
end
Robot = SerialLink(Links_p,'tool', Tool, 'name', 'Trossen');

end

function  draw_workspace(Robot, qlim, n)
% Plotea el espacio de trabajo del robot con una nube de puntos 
% Recibe:
%  - Robot creado con SerialLink()
%  - qlim: limite [max,min] en radianes de th1 th2 th3 th4 th5
%  - n: cantidad de puntos en la nube

    [r,c] = size(qlim(:,1));
    for i=1:n
        q = zeros(1,r);
        for k = 1:r
            q(k) = qlim(k,1) + (qlim(k,2) - qlim(k,1)) * rand(1,1);
        end
    point = Robot.fkine(q);
    Robot.plot(q);
    hold on;
    plot3(point.t(1),point.t(2),point.t(3),'b.','MarkerSize', 3);
    end
end

    
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
    c = jet;
    xmax = 0.7;
    xmin = -0.7;
    xrange = xmax - xmin;
    %mapeo la coordenada x por un numero [0;64] que es la cantidad de colores que tiene jet
    color_index = round((point.t(1)-xmin)*64/xrange); 
        
        %if (point.t(2) >= -0.05) && (point.t(2) <= 0.05) 
        % si se quiere dibujar una rebanada del espacio de trabajo, descomentar este if
            hold on;
            plot3(point.t(1),point.t(2),point.t(3),'b.','MarkerSize', 3, 'color', c(color_index,:) );
        %end
    end
    q0 = [0 0 0 0 0];
    Robot.plot(q0);
    hold on;
    plot_box(0.45,-0.1,0.45-0.15,0.1,'linewidth', 3)
end


    
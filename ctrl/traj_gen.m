function  [traj] = traj_gen(Robot, targets, n)
% TRAJ_GEN
%   Genera una trayectoria para Robot, que pase por todos los targets
%   La trayectoria se generará con 1 punto intermedio entre cada par conse-
% cutivo de targets
%   Se garantiza que la trayectoria tendrá al menos n puntos, pero no que 
% tendrá exactamente n puntos
%   targets debe ser una matriz de Nx2, donde cada fila representa las 
% coordenadas (x,y) de cada uno de los N puntos que se quiere visitar
%   Devuelve una matriz de MxK, donde M es la cantidad de puntos (y por lo
% tanto mayor o igual que n) y K es la cantidad de joints del robot.

lens = zeros(1, length(targets)-1);
temp_targets = targets;
targets = zeros(2*length(temp_targets)-1, 2);
j = 1;

% add midpoints & calculate distances between targets
for i=1:length(temp_targets)-1
    lens(i) = norm(temp_targets(i, :) - temp_targets(i+1, :));
    targets(j,:) = temp_targets(i, :);
    targets(j+1, :) = (temp_targets(i, :)+temp_targets(i+1, :))/2;
    j = j+2;
end
targets(end, :) = temp_targets(end, :);
total_len = sum(lens);

% get points per side, proportionally to side length
points_per_side = zeros(1, 2*length(lens)); 
for i=1:length(lens)
    points = max(1, floor(lens(i)/total_len*n));
    points_per_side(2*i-1) = max(1, floor(points/2));
    points_per_side(2*i) = max(1, ceil(points/2));
end

% ensure that there are at least n points 
n_points = sum(points_per_side);
for x=1:n_points-n
    i = randi(length(points_per_side));
    points_per_side(i) = points_per_side(i) + 1;
end

% get trajectory
traj = double.empty(0, Robot.n);
T_last = transl([targets(1, :) 0])*trotz(atan2(targets(1, 2), targets(1, 1)));    
for i=2:length(targets)
    p = targets(i, :);
    T = transl([p 0])*trotz(atan2(p(2), p(1)));    

    traj = [traj; Robot.ikcon(ctraj(T_last, T, points_per_side(i-1)))];
    T_last = T;
end

end

function out_points = order_points(u_original,v_original,max_u,max_v)
%ORDER_POINTS funcion que ordena los 4 puntos obtenidos 
%   los puntos quedan ordenados de la siguiente forma
%   -----------------------> u
%   |                   
%   |  *P2            *P1
%   |
%   |   
%   |  *P3            *P4
%   |
%   + v
aux=zeros(2,4);

for i=1:4
    if(u_original(i) > (max_u/2)) && (v_original(i) < (max_v/2)) %obtengo P1
        aux(1,1)=u_original(i);
        aux(2,1)=v_original(i);    
    elseif ((u_original(i) < (max_u/2)) && (v_original(i) < (max_v/2))) %obtengo P2
        aux(1,2)=u_original(i);
        aux(2,2)=v_original(i);
    elseif ((u_original(i) < (max_u/2)) && (v_original(i) > (max_v/2))) %obtengo P3
        aux(1,3)=u_original(i);
        aux(2,3)=v_original(i);
    elseif ((u_original(i) > (max_u/2)) && (v_original(i) > (max_v/2))) %obtengo P4
        aux(1,4)=u_original(i);
        aux(2,4)=v_original(i);
    
    end
end

u_final = aux(1,:);
v_final = aux(2,:);
out_points=[u_final;v_final];
end


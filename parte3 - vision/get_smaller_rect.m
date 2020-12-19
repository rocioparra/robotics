function borders = get_smaller_rect(u_o,u_f,v_o,v_f,zone)
%get_smaller_Rect devuelve los nuevos bordes del rectangulo reducidos un
% 50%
%   posicionamiento de los puntos
%   -----------------------> u
%   |                   
%   |  *a            *b
%   |
%   |   
%   |  *c            *d
%   |
%   + v
%   devuelve en un vector cuyas columnas son las cordenadas de cada punto
%   [a; b; c; d ]

if (zone == 1)
    a=[u_o ; v_o];
    b=[u_o+(2^(1/2)/2)*u_f ; v_o ];
    c=[u_o ; v_o+ (v_f-v_o)*(2^(1/2)/2)];
    d=[u_o+(2^(1/2)/2)*u_f; v_o+ (2^(1/2)/2)*(v_f-v_o)];
    
elseif (zone == 2)
    
    a=[u_o+(1-(2^(1/2)/2))*(u_f-u_o) ; v_o];
    b=[u_f ; v_o ];
    c=[u_o+(1-(2^(1/2)/2))*(u_f-u_o) ;v_f*(2^(1/2)/2)]; % v_o+(1-(2^(1/2)/2))*v_f
    d=[u_f; v_f*(2^(1/2)/2)]; % v_o+(1-(2^(1/2)/2))*v_f

elseif (zone == 3)
    
%     a=[u_o ; v_o+(1-(2^(1/2)/2))* v_f];
%     b=[(2^(1/2)/2)*u_f ; v_o+(1-(2^(1/2)/2))*v_f ];
    
    a=[u_o ;v_o+(1-(2^(1/2)/2))*(v_f-v_o)];
    b=[(2^(1/2)/2)*u_f ; v_o+(1-(2^(1/2)/2))*(v_f-v_o) ];
    c=[u_o ; v_f];
    d=[u_o+(2^(1/2)/2)*u_f ; v_f];
    
    
% 
elseif (zone ==4)
    a=[u_o+(1-(2^(1/2)/2))*(u_f-u_o) ;v_o+(1-(2^(1/2)/2))*(v_f-v_o)];
    b=[u_f ; v_o+(1-(2^(1/2)/2))*(v_f-v_o) ];
    c=[u_o+(1-(2^(1/2)/2))*(u_f-u_o) ; v_f];
    d=[u_f ; v_f];
    

end

borders=[a b c d];

end


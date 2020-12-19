function new_image = get_quadrant(image,zone)
%GET_QUADRANT funcion que ubica cuatro cuadrantes donde se encuentran 
%   
    %obtengo max u y  max v 
    aux=size(image);
    u_max=aux(2);
    v_max=aux(1);
    
    %obtengo los bordes del cuadrante
    borders=get_smaller_rect(1,u_max,1,v_max,zone);
    borders=round(borders);
    %obtengo la sub imagen 
    
    new_image=image(borders(2,1):borders(2,4),borders(1,1):borders(1,4));
    

end


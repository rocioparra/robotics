function [new_image,fil_off,col_off] = get_border_quadrant(image,zone)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
pre_image=image;
tam = size(pre_image);

fil_aux = 0;
col_aux = 0;

just_border = 1;

while just_border

    pre_image = pre_image>0.5;

    im_blobs = iblobs(pre_image,'boundary');
    blobs_qty = size(im_blobs);
    blobs_qty = blobs_qty(2);
    parent1_qty = 0;

    if(blobs_qty <= 3)
        for n=1:1:blobs_qty             %cheque si solo hay borde y fondo
            if(im_blobs(n).parent >=2)
                just_border=1;
                break;
            elseif (im_blobs(n).parent < 2)
                just_border=0;
                if(im_blobs(n).parent == 1)
                    parent1_qty = parent1_qty +1;
                end
            end
        end
    end
        if(parent1_qty > 1)
            just_border = 1;
        end

        %si existe cambio de tamaño del cuadrante y repito
        if(just_border == 1)

            pre_image=get_quadrant(pre_image,zone);
            aux_tam = size(pre_image);
            if (zone == 1)
                fil_aux = fil_aux;
                col_aux = col_aux;
            elseif (zone == 2)    
                fil_aux = fil_aux;
                col_aux = tam(2) - aux_tam(2);
            elseif (zone == 3)
                fil_aux = tam(1) - aux_tam(1);
                col_aux = col_aux;
            elseif (zone == 4)
                fil_aux = tam(1) - aux_tam(1);
                col_aux = tam(2) - aux_tam(2);
            end 

        end
end

new_image=pre_image;
fil_off = fil_aux;
col_off = col_aux;
end


function new_image = get_border_quadrant(image,zone)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
pre_image=get_quadrant(image,zone);


just_border = 1;

while just_border

im_blobs = iblobs(pre_image>0.5,'boundary');
blobs_qty = size(im_blobs);
blobs_qty = blobs_qty(2);
    
for n=1:1:blobs_qty             %cheque si solo hay borde y fondo
    if(im_blobs(n).parent >=2)
        just_border=1;
    elseif (im_blobs(n).parent < 2)
        just_border=0;
    end
end

%si existe cambio de tamaño del cuadrante y repito
if( just_border == 1)
    
    pre_image=get_quadrant(pre_image,zone);

end


end


new_image=pre_image;
end


function template = generate_template(im_byn)
% GENERATE_TEMPLATE mediante identificacion de blobs se busca el poligono
% que represente la hoja, y se genera una mascara en base al mismo

im_size = size(im_byn);
im_template = icanny(im_byn,1,0.4,1);

figure();
idisp(im_template)

im_blobs = iblobs(im_byn>0.5,'boundary');
blobs_qty = size(im_blobs);
blobs_qty = blobs_qty(2);
cont = 1;
for n=1:1:blobs_qty
    if(im_blobs(n).parent ~= 0)
        im_blobs2(cont) = im_blobs(n);
        cont = cont+1;
    end
end
[max_perim,k] = max(im_blobs2.perimeter);
im_recuadro = im_blobs2(k);
template = poly2mask(im_recuadro.edge(1,:),im_recuadro.edge(2,:),im_size(1),im_size(2));
figure();
idisp(template)
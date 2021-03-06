function [fens,fes] = H8_composite_plate(L,W,ts,nL,nW,nts)
% H8 block mesh for a layered block (composite plate).
%
% function [fens,fes] = H8_composite_plate(L,W,ts,nL,nW,nts)
%
% L,W= length and width,
% ts= Array of layer thicknesses,
% nL,nW= Number of elements per length and width,
% nts= array of numbers of elements per layer
%
% The fes of each layer are labeled with the layer number.
%
% Output:
% fens= finite element node set
% fes = finite element set
%
%
% Examples: 
%     a=200; b=600; h=50;
%     angles =[0,90,0];
%     nLayers =length(angles);
%     na=4; nb=4;
%     nts= 1*ones(nLayers,1);% number of elements per layer
%     ts= h/nLayers*ones(nLayers,1);% layer thicknesses
%     [fens,fes] = H8_composite_plate(a,b,ts,na,nb,nts);;
%     gv=drawmesh( {fens,subset(fes,fe_select(fens,fes,struct('label', 1)))},'fes', 'facecolor','r');
%     gv=drawmesh( {fens,subset(fes,fe_select(fens,fes,struct('label', 2)))},'gv',gv,'fes', 'facecolor','g');
%     gv=drawmesh( {fens,subset(fes,fe_select(fens,fes,struct('label', 3)))},'gv',gv,'fes', 'facecolor','b');
%
%
% See also: H8_block
%
tolerance =min(abs(ts))/max(nts)/10;
for layer =1:length(ts)
    if (layer==1)
        [fens,fes] = H8_block(L,W,ts(layer),nL,nW,nts(layer));
        fes.label=layer;
    else
        [fens1,fes1] = H8_block(L,W,ts(layer),nL,nW,nts(layer));
        fes1.label=layer;
        [fens1] = translate_mesh(fens1, [0,0,sum(ts(1:layer-1))]);
        [fens,fes1,fes2] = merge_meshes(fens1, fes1, fens, fes, tolerance);
        fes=cat (fes1,fes2);
    end
end


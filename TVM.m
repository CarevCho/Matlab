function result = TVM(object,lamda,lamda_gs,threshold,out_iter,in_iter)
% reconstruction using Total Variation
% must be include 'Algorithm.m', 'Compass.m', 'MirrorPadding.m'
%
% param object : Object image that be reconstructed 
% param lamda : weight coeficient that emphasize norm 1 or norm 2
% param lamda_gs : gradient descent weight coeficient 
% param threshold : convergence limit
% param out_iter : Outer roof for update Ae to Ab
% param in_iter : Inter roof update image
% result : reconstructed image usign TVM

image_0 = MirrorPadding(object);
image_1 = MirrorPadding(object);
result = Algorithm(image_0,image_1,lamda,lamda_gs,threshold,out_iter,in_iter);
end

function result = MLEM(ori_sino,rec,rec_sino,nor,resol,THETA_START,THETA_INTERVAL,THETA_END)
%%
% MLEM recontruction individual step
% param, ori : original image
% param, rec : reconstructed image
% param, nor : normalized sinogram
% param, resol : resolution origianl image
% return : reconstructed image 
tmp = ori_sino./rec_sino;
TF = isnan(tmp);
[row col] = find(TF==1);
for i=1:size(row)
    tmp(row(i),col(i)) = ori_sino(row(i),col(i)); 
end
rec_nor = iradon(nor,THETA_START:THETA_INTERVAL:THETA_END,'None',resol);
step = rec./rec_nor;
TF = isnan(step);
[row col] = find(TF == 1);
for i=1:size(row)
    step(row(i),col(i)) = rec(row(i),col(i)); 
end
TF = isinf(step);
[row col] = find(TF == 1);
for i=1:size(row)
    step(row(i),col(i)) = rec(row(i),col(i)); 
end

result = step.*iradon(tmp,THETA_START:THETA_INTERVAL:THETA_END,'None',resol);

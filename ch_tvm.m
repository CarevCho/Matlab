function [ RESULT ] = ch_tvm( ORI, INIT, DATA, RESOLUTION, THETA_START, THETA_INTERVAL, THETA_END, NOR, LAMBDA, DATA_STEP)
%%
% The iteration performed in the algorithm has two levels :
% the overall iteration number is labeled by n
% and the sub-iterations in the DATA- and GRAD-steps are labeled by m.

%% POCS , DATA-step which enforces consistency with the projection data; + POS-step which ensures a non-negative image
% DATA projection iteration, for m = 2, ..., N_data;
f_tv_data = INIT;
for i = 1:DATA_STEP
    [f_tv_data RMSE ] = ch_mlem( 1, 0, ORI, f_tv_data, DATA, RESOLUTION, THETA_START, THETA_INTERVAL, THETA_END, 'None', NOR );
end
% Positivity constraint
f_tv_pos = f_tv_data;
f_tv_pos(find(f_tv_pos< 0)) = 0;
%% gradient descent, GRAD-step, which reduces the TV of the image estimate.
% TV gradient descent initialization
f_tv_grad = f_tv_pos;
sum_tmp = f_tv_pos;
sum_tmp(find(sum_tmp)) = 1;

d_a = sqrt(sum(sum((INIT - f_tv_pos).*(INIT - f_tv_pos)))) / (sum(sum_tmp(:)) * 10);
% TV gradient descent, for m = 2, ..., N_grad
tmp = ones(size(f_tv_grad,1)+2, size(f_tv_grad,2)+2);

for r = 1:size(f_tv_grad,1)
    tmp(r+1,2:end-1) = f_tv_grad(r,:);  
end

e = 0.001;
for r = 1:size(f_tv_grad,1)
    for c = 1:size(f_tv_grad,2)
        vector(r,c) = (2*(tmp(r+1,c+1) - tmp(r,c+1) + tmp(r+1,c+1) - tmp(r+1,c)))/sqrt(e + (tmp(r+1,c+1)-tmp(r,c+1))^2 + (tmp(r+1,c+1)-tmp(r+1,c))^2) ...
            - (2*(tmp(r+2,c+1) - tmp(r+1,c+1)))/sqrt(e + (tmp(r+2,c+1) - tmp(r+1,c+1))^2 + (tmp(r+2,c+1) - tmp(r+2,c))^2) ...
            - (2*(tmp(r+1,c+2) - tmp(r+1,c+1)))/sqrt(e + (tmp(r+1,c+2) - tmp(r+1,c+1))^2 + (tmp(r+1,c+2) - tmp(r,c+1))^2);
        if vector(r,c) > 0
            vector(r,c) = 1;
        elseif vector(r,c) < 0
            vector(r,c) = -1;
        else
            vector(r,c) = 0;
        end
    end
end
RESULT = f_tv_grad - LAMBDA * d_a * vector;
%%
% Initialize next loop

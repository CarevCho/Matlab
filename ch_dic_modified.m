function [ DIC ] = ch_dic_new ( MASK, DATA, THETA_START, THETA_INTERVAL,THETA_END, RESOLUTION)
%% calculating DIC(data incohrence)
% M(n) is rays pass through n pixel

% @param MASK : to check mask 
% @param DATA : full sampling data( sinogram )
% @param THETA_START : projection angle start
% @param THETA_INTERVAL : projection angle interval
% @param THETA_END : projection angle end
% @param RESOLUTION : data image resolution
%%
tic
THETA_S = THETA_START; THETA_I = THETA_INTERVAL; THETA_E = THETA_END;
RESOL = RESOLUTION;

M = MASK(:,:,1);
M = zeros(size(M));
M(:,1:4:180) = 1;
F_D = DATA;
F_D(find(F_D ~= 0)) = 1;        % F_D is full sinogram

tot_mask_number = size(MASK,3); % total mask number

for iter = 1:tot_mask_number
    dic_matrix = zeros(RESOL);
    M = MASK(:,:,iter);
    M(find(M ~= 0)) = 1;
    I = zeros(RESOL);
    for r = 1:RESOL
        for c = 1:RESOL
            I(r,c) = 1;     % n pixel
            I_D = radon(I,THETA_S:THETA_I:THETA_E); % tmp image sinogram
            I_D(find(I_D ~= 0)) = 1;
            I_D = I_D & F_D;    % exist rays in full data, M(n)
            tot_ray_number = sum(I_D(:));   % total ray number 

            U_S_D = I_D & M;
            [ radian, angle ] = find(U_S_D == 1);
            under_ray_number = tot_ray_number - sum(U_S_D(:));
            
            tmp_sum_value = 0;
            rays = size(radian,1);
            
            for i = 1:rays
                for j = 1+i:rays
                    tmp_sum_value = tmp_sum_value + abs( cos( ...
                        (angle(i) - angle(j)) * THETA_I * pi / 180) );
                end
            end
            dic_matrix(r,c) = 1 -  ...
                tmp_sum_value / ...
                (tot_ray_number * (tot_ray_number -1) / 2); 
                %((tot_ray_number * (tot_ray_number -1) / 2) - ( under_ray_number * (under_ray_number - 1 ) / 2 ) ); 
            % if not considering not matched rays total dic value is increase,
            % on the other hand, valse is decrease
            tmp_sum_value = 0;
            I(r,c) = 0;
        end
    end
    DIC(:,:,iter) = dic_matrix;
end

toc
function [ RESULT RMSE_p ] = ch_mlem ( ITER , SAVE_ITER , IMAGE, INIT, DATA, RESOLUTION, THETA_START, THETA_INTERVAL, THETA_END, TAG , NOR)
%% MLEM
%
% @param ITER : # of iteration
% @param IMAGE : Original image
% @param INIT : Initial image
% @param DATA : Sinogram to be reconstructed to image
% @param RESOLUTION : Resolution to be reconstructed
% @param THETA_START : 
% @param THETA_INTERVAL :
% @param THETA_END :
% @param TAG : save file name tag

D1 = DATA;
ori_sino = D1;
rec = INIT;
rec_sino = radon(rec, THETA_START:THETA_INTERVAL:THETA_END);

if nargin < 11
    nor = D1;
    nor(find(nor)) = 1;
else
    nor = NOR;
end
RMSE_p = ones(ITER,1);

if ITER > 10
    v = waitbar(0,'');
end
for iter = 1:ITER
    rec = MLEM(ori_sino, rec, rec_sino, nor, RESOLUTION,THETA_START, THETA_INTERVAL, THETA_END);
    rec_sino = radon(rec, THETA_START:THETA_INTERVAL:THETA_END);
    RMSE_p(iter) = RMSE(IMAGE,rec);
    if rem(iter,SAVE_ITER) == 0
        File = fopen(strcat(strcat(strcat(TAG,'_rec_'),num2str(iter/SAVE_ITER)),'.i'),'w');
        for i = 1:RESOLUTION
            fwrite(File, rec(i,:), 'float');
        end
        fclose(File);
    end
    if ITER > 10
        waitbar(iter/ITER,v,strcat( num2str(iter/ITER * 100) ,'%'));
    end
end
if ITER > 10
    delete(v);
end
dlmwrite(strcat(TAG,'_rmse.csv'),RMSE_p);

RESULT = rec;
end
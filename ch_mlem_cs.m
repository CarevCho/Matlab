function [RECONSTRUCTION rmse] = ch_mlem_cs(ITER,SAVE_ITER,IMAGE, DATA, RESOLUTION, THETA_START, THETA_INTERVAL, THETA_END, LAMBDA, TAG, NOR)

ori = IMAGE;
resol = RESOLUTION;
ori_sino = DATA;

if nargin < 11
    nor = ori_sino;
    nor(find(nor))=1;
else
    nor = NOR;
end

rtheta = THETA_INTERVAL;
rec = ones(resol);
rec_sino = radon(rec,THETA_START:THETA_INTERVAL:THETA_END);
tv_weight = LAMBDA;
save_iter = SAVE_ITER;

tic
h = waitbar(0,'Progress');
for iter=1:ITER
    tmpRec = MLEM(ori_sino,rec,rec_sino,nor,resol,THETA_START,THETA_INTERVAL,THETA_END);
    tmpRec = TVM(tmpRec,tv_weight,1,1e-20,2,3);
    rec_sino = radon(tmpRec,THETA_START:THETA_INTERVAL:THETA_END);

    rmse(iter) = RMSE(ori,tmpRec);
    if iter > 1
        if rmse(iter-1) <= rmse(iter)
            RECONSTRUCTION = tmpRec;
            ch_image_write(strcat(TAG,num2str(iter-1)),'.i',tmpRec,'float');
            break;
        end
    end
    if rem(iter,save_iter) == 0
        rec_save = tmpRec;
       
        fileID = fopen(strcat(strcat(TAG,num2str(iter/save_iter),'.i')),'w');
        for y=1:resol
            fwrite(fileID,rec_save(y,:),'float');
        end
        fclose(fileID);
        
    end
    rec = tmpRec;
    %RECONSTRUCTION(:,:,iter) = rec;
    waitbar(iter/ITER,h,strcat(num2str(iter/ITER*100),'%'));
    RECONSTRUCTION = tmpRec;
end
delete(h);
dlmwrite(strcat(TAG,'_cs_rmse.csv'),rmse);

toc
end
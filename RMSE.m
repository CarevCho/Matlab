function result = RMSE(ori, rec)

rms_ori = 0;
rms_diff = 0;
count = 0;
for y=1:size(ori,1)
    for x=1:size(ori,2)
        if ori(y,x) == 0
            continue;
        else
            rms_ori = rms_ori + ori(y,x)^2;
            temp = (ori(y,x) - rec(y,x))^2;
            rms_diff = rms_diff + temp;
            count = count+1;
        end        
    end
end

%result = 10*log10(rms_ori/rms_diff);

result = sqrt(rms_diff/rms_ori)*100;


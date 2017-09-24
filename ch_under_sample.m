% Need sinogram, undersample_ratio, overlap_ratio
function mask = ch_under_sample(sinogram, undersample_ratio, Sample_number)
% @param sinogram : composed 0 and 1 , sinogram mask
% @param undersample_ratio : under-sampling ratio, i.e., 30% --> 0.3

tmp = size(sinogram);
tmp(3) = Sample_number;
mask = zeros(tmp);

tot_count = 0;
for r = 1:size(sinogram,1)
    for c = 1:size(sinogram,2)
        if sinogram(r,c) == 0
            continue;
        end
        tot_count = tot_count + 1;
    end
end
%[non_zero_row, non_zero_col] = find(source);

[rows, cols] = size(sinogram);
tot_count = uint32(tot_count * undersample_ratio);

iter_count = 0;

h = waitbar(0, 'Process');
while iter_count < Sample_number
    iter_count = iter_count + 1;
    sample_count = 0;
    rng('shuffle'); 
    while sample_count < tot_count 
        linear  = randi(rows);
        angular = randi(cols);
        if sinogram(linear,angular) == 0 || mask(linear, angular, iter_count) == 1
            continue;
        else
           mask(linear,angular,iter_count) = 1;
           sample_count = sample_count + 1;
        end
        
    end
    waitbar(iter_count/Sample_number,h,strcat(num2str(iter_count/Sample_number*100),'%'));
end
delete(h);

end

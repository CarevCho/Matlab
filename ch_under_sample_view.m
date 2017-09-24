function [ MASK ] = ch_under_sample_view( DATA, UNDER_SAMPLE_RATIO, TRIAL, NUMBER_SAMPLES )
% DATA , UNDER_SAMPLE_RATIO, OVERLAP_RATIO, NUMBER_SAMPLES, TRIAL    // for sampling   
% IMG, ROI, THETA_START, THETA_INTERVAL, TEHTA_END // for calculate DIC
% matrix and average value

tot_views = size(DATA,2);   % number of samples from input data(sinogram)
under_sample_views = uint32(tot_views * UNDER_SAMPLE_RATIO);
count_view = 0;
count_trial = 1;    % mask number how many try before exact sample

% Sample extraction 
for iter = 1:NUMBER_SAMPLES
    rng('shuffle');     % random seed
    count_trial = 1;
    tmp_mask_size = size(DATA);
    tmp_mask_size(3) = TRIAL;
    tmp_mask = zeros(tmp_mask_size);
    while count_trial <= TRIAL
        count_view = 0;
        check_view = zeros(1,tot_views);
        while count_view < under_sample_views
            view = randi(tot_views);
            if check_view(view) == 1
                continue;
            else
                count_view = count_view + 1;
                check_view(view) = 1; 
                tmp_mask(:,view,count_trial) = DATA(:,view);
            end
        end
        count_trial = count_trial + 1;
    end
    MASK(:,:,iter) = tmp_mask(:,:,count_trial-1);
end
end
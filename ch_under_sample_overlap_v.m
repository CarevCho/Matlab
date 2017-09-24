function [ MASK MASK_DIC_MATRIX MASK_DIC_AVG ] = ch_under_sample_overlap_v( DATA, TRIAL, UNDER_SAMPLE_RATIO ,OVERLAP_RATIO, NUMBER , ROI, THETA_START, THETA_INTERVAL, THETA_END )
% Sampling from data with input under-sample ratio and overlap ratio.

% set variable to use
tmp_data = DATA;
tmp_data(find(tmp_data)) = 1;

rand_extract = size(DATA);
tot_samples = sum(tmp_data(:)); % Total sample number could be extract
under_samples = uint32(tot_samples * UNDER_SAMPLE_RATIO);   % Under-sample number
overlap_samples = uint32(under_samples * OVERLAP_RATIO);    % Overlap sample number
count_under_sample = 0;
count_overlap_sample = 0;
check_mask = 0;
number_mask = 0;

% setting mask size
size_mask = size(DATA); size_mask(3) = NUMBER;
MASK = zeros(size_mask);
size_mask(3) = TRIAL;


% Repeat util exact sampling pattern mask number is NUMBER
for iter = 1:NUMBER
    rng('shuffle'); % random seed
    tmp_mask = zeros(size_mask);
    if iter == 1
        % first loop
        while number_mask < TRIAL
            while count_under_sample < under_samples
                linear = randi(rand_extract(1));    % linear element random number
                angular = randi(rand_extract(2));   % angular element random number
                if DATA(linear, angular) == 0 || tmp_mask(linear, angular,number_mask+1) ~= 0
                    % if DATA area & mask area does not have sample on that
                    continue;
                end
                tmp_mask(linear,angular,number_mask+1) = 1;
                count_under_sample = count_under_sample + 1;
            end
            count_under_sample = 0;
            number_mask = number_mask + 1;
        end
        [dic_matrix dic_avg ] = ch_dic(tmp_mask,ROI,THETA_START, THETA_INTERVAL, THETA_END);
        dic_sort_avg = ch_sort_array(dic_avg,'descend');
        MASK(:,:,iter) = tmp_mask(:,:,find(dic_avg == dic_sort_avg(1)));
        MASK_DIC_MATRIX(:,:,iter) = dic_matrix(:,:,find(dic_avg == dic_sort_avg(1)));
        MASK_DIC_AVG(iter) = dic_sort_avg(1);
  
        number_mask = 0;
        count_under_sample = 0;
        iter = iter + 1;
    else
        % after first loop
        while number_mask < TRIAL
            for i=1:iter-1
                count_overlap_sample(i) = 0;
            end
            while count_under_sample < under_samples
                linear = randi(rand_extract(1));    % linear element random number
                angular = randi(rand_extract(2));   % angular element random number
                if DATA(linear, angular) == 0 || tmp_mask(linear, angular, number_mask+1) ~= 0
                    continue;
                end
                %%
                % check_mask , 
                % -1 : count_overlap_sampel is over count than overlap_samples
                % 0  : Does not exist overlap region
                % others : overlap other value mask but other mask overlap
                % count is excessed
                for i=1:iter-1
                    % if overlap is exist
                    if MASK(linear,angular,i) ~= 0
                        % Does not excess total overlap_sample
                        if count_overlap_sample(i) < overlap_samples
                            % previous mask excess overlap_sample
                            if check_mask == -1
                                check_mask = -1;
                            % resonable overlap sample    
                            else
                                count_overlap_sample(i) = count_overlap_sample(i) + 1;
                                tmp_mask(linear,angular,number_mask+1) = 1;
                                check_mask = i;
                            end
                        % overlap is exist. however excessed overlap_sample    
                        else
                            % previous overlap is exist, but present mask
                            % overlap is excessed overlap_sample
                            if check_mask ~= 0
                                if check_mask ~= -1
                                    tmp_mask(linear,angular,number_mask+1) = 0;
                                    count_overlap_sample(check_mask) = count_overlap_sample(check_mask) - 1;
                                    check_mask = -1;
                                end
                            else
                                check_mask = -1;
                            end
                        end
                    end   
                end
                %%
                if check_mask == 0
                    tmp_mask(linear, angular, number_mask+1) = 1;
                    count_under_sample = count_under_sample + 1;
                elseif check_mask == -1
                    check_mask = 0;
                    continue;
                else
                    count_under_sample = count_under_sample + 1;                    
                end
                %%
                check_mask = 0;
            end
            number_mask = number_mask + 1;
            count_under_sample = 0;
        end
        [dic_matrix dic_avg ] = ch_dic(tmp_mask,ROI,THETA_START, THETA_INTERVAL, THETA_END);
        dic_sort_avg = ch_sort_array(dic_avg,'descend');
        MASK(:,:,iter) = tmp_mask(:,:,find(dic_avg == dic_sort_avg(1)));
        MASK_DIC_MATRIX(:,:,iter) = dic_matrix(:,:,find(dic_avg == dic_sort_avg(1)));
        MASK_DIC_AVG(iter) = dic_sort_avg(1);
        number_mask = 0;
        count_under_sample = 0;
        iter = iter + 1;
    end
end


end
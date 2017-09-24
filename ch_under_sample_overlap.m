function [ RESULT ] = ch_under_sample_overlap( DATA, MASK, UNDER_SAMPLE_RATIO ,OVERLAP_RATIO, NUMBER )
% Sampling from data with input under-sample ratio and overlap ratio.


SIZE_MASK = size(MASK);
SIZE_MASK(3) = NUMBER;
RESULT = zeros(SIZE_MASK);

DATA(find(DATA ~= 0)) = 1;
NUMBER_SAMPLE = uint32(sum(DATA(:)) * UNDER_SAMPLE_RATIO);
SAMPLE = size(DATA);

NUMBER_OVERLAP = uint32(sum(MASK(:)) * OVERLAP_RATIO);

for iter = 1:NUMBER
    rng('shuffle');
    PRESENT_SAMPLE = 0;
   
    if iter > 1
        % Check overlap with input mask and selected sample
        clear PRESENT_OVERLAP
        for i = 1:iter
            PRESENT_OVERLAP(i) = 0;
        end
        a = waitbar(0,'');
        while PRESENT_SAMPLE < NUMBER_SAMPLE
            linear  = randi(SAMPLE(1));
            angular = randi(SAMPLE(2));
            if DATA(linear,angular) == 0
                % No selection at [linear, angular] index
                continue;
            else
                % selection at [linear, angular] index
                if RESULT(linear,angular,iter) == 0                
                    if MASK(linear,angular) ~= 0
                        if PRESENT_OVERLAP == NUMBER_OVERLAP
                            continue;
                        else
                            
                            PRESENT_OVERLAP = PRESENT_OVERLAP + 1;
                            PRESENT_SAMPLE = PRESENT_SAMPLE + 1;
                            RESULT(linear,angular,iter) = 1;
                        end
                    else
                        RESULT(linear,angular,iter) = 1;
                        PRESENT_SAMPLE = PRESENT_SAMPLE + 1;

                    end

                else
                    continue;
                end
            end
            waitbar(PRESENT_SAMPLE/NUMBER_SAMPLE,a,strcat(num2str(PRESENT_SAMPLE/NUMBER_SAMPLE * 100),'%'));

        end
        delete(a);
    
    
    else
        % Check overlap with input mask, only one
        PRESENT_OVERLAP = 0;
        a = waitbar(0,'');
        while PRESENT_SAMPLE < NUMBER_SAMPLE
            linear  = randi(SAMPLE(1));
            angular = randi(SAMPLE(2));
            if DATA(linear,angular) == 0
                continue;
            else
                if RESULT(linear,angular,iter) == 0                
                    if MASK(linear,angular) ~= 0
                        if PRESENT_OVERLAP == NUMBER_OVERLAP
                            continue;
                        else
                            PRESENT_OVERLAP = PRESENT_OVERLAP + 1;
                            PRESENT_SAMPLE = PRESENT_SAMPLE + 1;
                            RESULT(linear,angular,iter) = 1;
                        end
                    else
                        RESULT(linear,angular,iter) = 1;
                        PRESENT_SAMPLE = PRESENT_SAMPLE + 1;

                    end

                else
                    continue;
                end
            end
            waitbar(PRESENT_SAMPLE/NUMBER_SAMPLE,a,strcat(num2str(PRESENT_SAMPLE/NUMBER_SAMPLE * 100),'%'));

        end
        delete(a);
    end
end
   
end
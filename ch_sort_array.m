function [ sort_array ] = ch_sort_array( array , order )

sort_array = array;
if size(array,1) == 1
    tot_idx = size(array,2);
else
    tot_idx = size(array,1);
end

if strcmp('descend',order)
    for o_idx = tot_idx:-1:1 
        tmp_val = array(o_idx);
        for i_iter = 1:1:tot_idx 
            if tmp_val >= sort_array(i_iter)
                loop_num = tot_idx - i_iter;
                for loop=loop_num:-1:1
                    sort_array(i_iter + loop) = sort_array(i_iter + loop-1);
                end
                sort_array(i_iter) = tmp_val;
                break;
            else
                continue;
            end
        end
    end
elseif strcmp('ascend',order)
    for o_idx = tot_idx:-1:1 
        tmp_val = array(o_idx);
        for i_iter = 1:1:tot_idx 
            if tmp_val <= sort_array(i_iter)
                loop_num = tot_idx - i_iter;
                for loop=loop_num:-1:1
                    sort_array(i_iter + loop) = sort_array(i_iter + loop-1);
                end
                sort_array(i_iter) = tmp_val;
                break;
            else
                continue;
            end
        end
    end
end

% for iter = 1:tot_idx
%     trans(iter,1) = sort_array(iter);
%     trans(iter,2) = ch_find_index(array,trans(iter,1));
% end
function [DIC] = ch_dic_sin ( DATA, ROI, THETA_START, THETA_INTERVAL, THETA_END )
% calculate Data Incoherence Criterion(DIC) from input image
% 
% @param DATA : DATA to calculate DIC
% @param ROI  : Region to calculate DIC, composed one and zero
% @param THETA_START : projection angle , START
% @param THETA_INTERVAL : projection angle, INTERVAL
% @param THETA_END : projection angle, END
% @result DIC : DIC value matrix, same size with ROI
% @result AVERAGE : AVEAGE or ROI

% Allocate dic matrix size
size_dic_matrix = size(ROI);
size_dic_matrix(3) = size(DATA,3);


img_dic = zeros(size_dic_matrix);

tmp_image = ROI;
tmp_image(find(tmp_image)) = 1;
[row col] = find(tmp_image == 1);

tic
a = waitbar(0,'');
for iter = 1:size(DATA,3)
    img_mask = zeros(size(ROI));
    for i = 1:sum(tmp_image(:))
        img_mask(row(i),col(i)) = 1;
        data_mask = radon(img_mask, THETA_START:THETA_INTERVAL:THETA_START+180-THETA_INTERVAL);
        % 90 ~ 269 , 0.625 ; 
		data_mask(find(data_mask ~= 0)) = 1;
        
        data_mask = data_mask .* DATA(:,:,iter);
        [linear, angular] = find(data_mask ~= 0);
        
        iter_number = size(linear,1);
        tot_pair = 0;
        sin_sum_value = 0;
        for j = 1:iter_number
            for k = 1 + j : iter_number
                tot_pair = tot_pair + 1;
                 sin_sum_value = sin_sum_value + ...
                        abs(sin((angular(j) - angular(k))* THETA_INTERVAL *pi/180))^4;
            end
        end
        img_mask(row(i),col(i)) = 0;
        img_dic(row(i),col(i),iter) = sin_sum_value/tot_pair;
    end
    %AVERAGE(iter) = ch_average_roi(ROI, img_dic(:,:,iter));
    waitbar(iter/size(DATA,3),a,strcat(num2str(iter/size(DATA,3)*100),'%'));
end
delete(a);
toc

% 
% for h = 1:size(ROI,1)
%     for w = 1:size(ROI,1)
%         if ROI(h,w) == 0
%             continue;
%         else
%             % set value to one at selected element
%             img_mask(h,w) = 1;
%             % projection
%             data_mask = radon(img_mask,THETA_START:THETA_INTERVAL:THETA_END);
%             data_mask(find(data_mask)) = 1;
%             % overlap width under-sample projection data
%             data_mask = data_mask .* DATA;
%             data_mask(find(data_mask)) = 1;
%             [valid_linear valid_angular] = find(data_mask);
% 
%             tot_bin_number = 0;
%             cosine_sum_value = 0;
%             for i = 1:size(valid_linear,1)
%                 for j = 1 + i:size(valid_angular,1)
%                     tot_bin_number = tot_bin_number + 1;
%                     cosine_sum_value = cosine_sum_value + ...
%                         abs(cos((valid_angular(i) - valid_angular(j))*pi/180));
%                 end
%             end
%             img_mask(h,w) = 0;
%             img_dic(h,w) = 1 - cosine_sum_value/tot_bin_number;            
%         end
%     end
% end

DIC = img_dic;
end
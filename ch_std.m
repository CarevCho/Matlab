function result = ch_std(matrix, roi, avg)

tot_count = sum(roi(:));
tot_square_sum = 0;
for iter = 1:size(matrix,3)
    for r = 1:size(roi,1)
        for c = 1:size(roi,2)
            if roi(r,c) == 0
                continue;
            else
                tot_square_sum = tot_square_sum + (matrix(r,c,iter) - avg(iter))^2;
            end
        end
    end
    result(iter) = tot_square_sum / ( tot_count -1 );
    tot_square_sum = 0;
end

end
function [AVG , STD] = ch_average_roi(ROI,DATA)
% Averaging value about input Region Of Interest(ROI)
%
% @param ROI : to calculated region compoesd by one(interest) and zero(not
% interest )
% @param DATA : input data matrix , same size with ROI
% @result RESULT : average value


Total = 0;
Count = 0;
for r = 1:size(ROI,1)
    for c = 1:size(ROI,2)
        if ROI(r,c) == 0
            continue;
        else
            Total = Total + DATA(r,c);
            Count = Count + 1;
        end
    end
end

AVG = Total/Count;

Total = 0;
for r = 1:size(ROI,1)
    for c = 1:size(ROI,2)
        if ROI(r,c) == 0
            continue;
        else
            Total = Total + (DATA(r,c)-AVG)^2;
        end
    end
end

STD = sqrt(Total / (Count-1));

end
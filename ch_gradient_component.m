function [ result ] = ch_gradient_component ( input )

d_a = 0;


tmp = ones(size(input,1)+2, size(input,2)+2);

for r = 1:size(input,1)
    tmp(r+1,2:end-1) = input(r,:);  
end

e = 0.001;
for r = 1:size(input,1)
    for c = 1:size(input,2)
        result(r,c) = (2*(tmp(r+1,c+1) - tmp(r,c+1) + tmp(r+1,c+1) - tmp(r+1,c)))/sqrt(e + (tmp(r+1,c+1)-tmp(r,c+1))^2 + (tmp(r+1,c+1)-tmp(r+1,c))^2) ...
            - (2*(tmp(r+2,c+1) - tmp(r+1,c+1)))/sqrt(e + (tmp(r+2,c+1) - tmp(r+1,c+1))^2 + (tmp(r+2,c+1) - tmp(r+2,c))^2) ...
            - (2*(tmp(r+1,c+2) - tmp(r+1,c+1)))/sqrt(e + (tmp(r+1,c+2) - tmp(r+1,c+1))^2 + (tmp(r+1,c+2) - tmp(r,c+1))^2);
        if result(r,c) > 0
            result(r,c) = 1;
        elseif result(r,c) < 0
            result(r,c) = -1;
        else
            result(r,c) = 0;
        end
    end
end

end
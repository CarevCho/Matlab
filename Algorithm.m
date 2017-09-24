function [result] = Algorithm(object_1,object_2,lamda,lamda_gs,threshold,out_iter,in_iter)
% Ref. Merence Sibomana, et.al, New attenuation correction for the HRRT using transmission scatter
% correction and total variation regularization,2009
% param,object_1 : Mirror padding Object image that use for update
% param,object_2 : Mirror padding Object image
% param,lamda : TV coeficient that emphasize norm 1 or norm 2
% param,lamda_gs : Gradient descent weight coefficient
% param,threshold : convergence limit
% param,out_iter : Outer roof for update parameter that use to update
% calculate image updating
% param,in_iter : Inner roop for update image 

An = zeros(size(object_1,1)-2,size(object_1,2)-2,size(object_1,3)-2);
Ae = zeros(size(object_1,1)-2,size(object_1,2)-2,size(object_1,3)-2);
Aw = zeros(size(object_1,1)-2,size(object_1,2)-2,size(object_1,3)-2);
As = zeros(size(object_1,1)-2,size(object_1,2)-2,size(object_1,3)-2);
Aa = zeros(size(object_1,1)-2,size(object_1,2)-2,size(object_1,3)-2);
Ab = zeros(size(object_1,1)-2,size(object_1,2)-2,size(object_1,3)-2);
eps2 = 0.001^2;

for i=1:out_iter
% Update An to Ab parameter
    for z=1:size(object_1,3)-2
        for y=1:size(object_1,1)-2
            for x=1:size(object_1,2)-2
                news = Compass(object_1,x,y);
                An(y,x,z) = 1/sqrt((news(2)-news(5))^2 + 0.0625*((news(6)-news(3)+news(3)-news(1))^2) + 0.0625*((news(17)-news(12)+news(15)-news(10))^2) + eps2);
                Ae(y,x,z) = 1/sqrt((news(6)-news(5))^2 + 0.0625*((news(2)-news(8)+news(3)-news(9))^2) + 0.0625*((news(17)-news(12)+news(18)-news(13))^2) + eps2);
                Aw(y,x,z) = 1/sqrt((news(4)-news(5))^2 + 0.0625*((news(2)-news(8)+news(1)-news(7))^2) + 0.0625*((news(17)-news(12)+news(16)-news(11))^2) + eps2);
                As(y,x,z) = 1/sqrt((news(8)-news(5))^2 + 0.0625*((news(6)-news(4)+news(9)-news(7))^2) + 0.0625*((news(17)-news(12)+news(19)-news(14))^2) + eps2);
                
                Aa(y,x,z) = 1/sqrt((news(17)-news(5))^2 + 0.0625*((news(6)-news(4)+news(18)-news(16))^2) + 0.0625*((news(2)-news(8)+news(15)-news(19))^2) + eps2);
                Ab(y,x,z) = 1/sqrt((news(12)-news(5))^2 + 0.0625*((news(6)-news(4)+news(13)-news(11))^2) + 0.0625*((news(2)-news(8)+news(10)-news(14))^2) + eps2);
            end
        end
    end    
    for j=1:in_iter
        % Update Image using updated parameter(An to Ab)
        residual = 0;
        for z=1:(size(object_1,3)-2)
            for y=1:(size(object_1,1)-2)
                for x=1:(size(object_1,2)-2)
                    news = Compass(object_1,x,y);
                    new_object = (lamda*(An(y,x,z)*news(2) + Ae(y,x,z)*news(6) + Aw(y,x,z)*news(4) + As(y,x,z)*news(8) + Aa(y,x,z)*news(17) + Ab(y,x,z)*news(11)) ... 
                        + object_2(y+1,x+1,z+1))/(1 + lamda*(An(y,x,z)+Ae(y,x,z)+Aw(y,x,z)+As(y,x,z)+Aa(y,x,z)+Ab(y,x,z)));
                    residual = residual + (object_1(y+1,x+1,z+1) - new_object)^2;
                    
                    object_1(y+1,x+1,z+1) = lamda_gs*new_object + (1-lamda_gs)*object_1(y+1,x+1,z+1);
                    new(y,x,z) = object_1(y+1,x+1,z+1);
                end
            end
        end
        r = sqrt(residual)/((size(object_1,1)-2)*(size(object_1,2)-2)*(size(object_1,3)-2));
        
        object_1 = MirrorPadding(new);
        result = new;
        
        %if r < threshold
        %    break;
        %end
    end
end
end
function [result] = MirrorPadding(object)
% Mirror padding object array to result array
% param : object is array
% return : mirror padding array

result = ones(size(object,1)+2,size(object,2)+2,3);

% mirroring padding
for i=1:size(object,1)
    for j=1:size(object,2)
        result(i+1,j+1,2) = object(i,j);
    end
end

result(1,:,2) = result(2,:,2);
result(size(result,1),:,2) = result(size(result,1)-1,:,2);
result(:,1,2) = result(:,2,2);
result(:,size(result,2),2) = result(:,size(result,2)-1,2);
result(1,1,2) = (result(1,2,2)+result(2,1,2))/2;
result(1,size(result,2),2) = (result(1,size(result,2)-1,2)+result(2,size(result,2),2))/2;
result(size(result,1),1,2) = (result(size(result,1)-1,1,2)+result(size(result,1),2,2))/2;
result(size(result,1),size(result,2),2) = (result(size(result,1)-1,size(result,2),2)+result(size(result,1),size(result,2)-1,2))/2;

result(:,:,1) = result(:,:,2);
result(:,:,3) = result(:,:,2);

end
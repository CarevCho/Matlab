function [result] = Compass(image, x, y)
% calculate currenct , before and after coeficient 

result = ones(1,19);

a = 0;
b = 0;

% current
for i=1:9
    if b == 3
        a = a + 1;
        b = 0;
    end
    result(i) = image(y+a,x+b,2);
    b = b + 1;
end
a = 0;
b = 0;

% before
for i=10:14
    result(i) = image(y+a,x+b+1,1);
    if i == 10
        a = a + 1;
        b = b - 1;
    else
        b = b + 1;
    end
    if b == 2
        a = a + 1;
        b = 0;
    end
end
a = 0;
b = 0;

% after
for i=15:19
    result(i) = image(y+a,x+b+1,3);
    if i == 15
        a = a + 1;
        b = b - 1;
    else
        b = b + 1;
    end
    if b == 2
        a = a + 1;
        b = 0;
    end
end
end
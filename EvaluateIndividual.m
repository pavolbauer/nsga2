function f = EvaluateIndividual(x)

ocv1 = 6-(x(2)+9*x(1)); % constrain 1
ocv2 = 1-(-x(2)+9*x(1));% constrain 2
if ocv1 > 0
    flag1 = 1;
else
    flag1 = 0;
end

if ocv2 > 0
    flag2 = 1;
else
    flag2 = 0;
end

% add the constrains as penalty 
f = [x(1) + flag1*ocv1 + flag2*ocv2,(1+x(2))/x(1) + flag1*ocv1+flag2*ocv2];
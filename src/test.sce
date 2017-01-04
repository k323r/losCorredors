function [weightedMovingMean] = WeightedMovingMean2 (values, weightA, weightB, weightC)
    weightedMovingMean(1) = values(1);
    endofdata = size(values,1)
    disp(endofdata)
    
    for i = 2 : endofdata - 1
        weightedMovingMean(i) = (values(i-1) * weightA + values(i) * weightB + values(i+1) * weightC) / (weightA + weightB + weightC);
    end
    
    weightedMovingMean(endofdata) = values(endofdata);
    weightedMovingMean = weightedMovingMean.'
endfunction

a = [0.8, 0.9, 1.01, 1.01, 1.01, 1.01, 1.05, 1.15, 1.19, 1.11, 1.15, 1.05]

b = WeightedMovingMean2 (a(:), 0.5, 1, 0.5)

disp("a: ")
disp(a)

// b = b.'

disp("b: ")
disp(b)

plot(a)
plot(b)

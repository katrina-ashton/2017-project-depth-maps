function tests = unit_tests
tests = functiontests(localfunctions);
end

%Check if can perfectlly model 4 points with n=1
function test_weights1(testCase)
X = [pi/2,pi;0,3*pi/5;pi/3,pi/4;pi/8,0];
t = [1;2;1;4];
n = 1;
lam = 0;
w = sc2sbf_lr(X, t, n, lam);
actSolution = zeros(size(t,1),1);
for i=1:size(t,1)
    sum = 0;
    for l=0:n
        for m=-l:l
            sum = sum + w(l^2+l+m+1)*sbf(l, m, X(i,1), X(i,2));
        end
    end
    actSolution(i) = sum;
end
expSolution = t;
tol = 10^(-6)*ones(size(t,1),1);
verifyEqual(testCase,actSolution,expSolution, 'AbsTol', tol)
end

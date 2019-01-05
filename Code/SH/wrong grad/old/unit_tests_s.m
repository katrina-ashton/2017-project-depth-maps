function tests = unit_tests_s
tests = functiontests(localfunctions);
end

% %Test that adding a point does not increase average sum squared error
% %(Currently fails)
% function test_addpoint(testCase)
% X = [pi/2,0;    pi/2, pi/2;     pi/2, pi;   pi/2, 3*pi/2;   0,0;    pi,0; ...
%     atan(0.5), 0;  atan(0.5), pi/2; atan(0.5), pi;    atan(0.5), 3*pi/2; ...
%     pi-atan(0.5), 0;  pi-atan(0.5), pi/2; pi-atan(0.5), pi;    pi-atan(0.5), 3*pi/2];
% t = [1;1;1;1;2;2;sqrt(5);sqrt(5);sqrt(5);sqrt(5);sqrt(5);sqrt(5);sqrt(5);sqrt(5)];
% 
% n = 2; 
% lr = 0.2;
% lam = 0.2;
% 
% w = zeros((n+1)^2, 1);
% sse_m = zeros(size(X,1),1);
% sse = 0;
% truth_m = zeros(size(X,1)-1,1);
% for i=1:size(X,1)
%     w = sc2sbf_slr(X(i,:), t(i), n, w, lr, lam);
%     for j=1:i
%         for l=0:n
%             for m=-l:l
%                 ta = + w(l^2+l+m+1)*sbf(l, m, X(i,1), X(i,2));
%             end
%         end
%        sse = sse + (t(j)- ta)^2; 
%     end
%     sse_m(i) = sse/i;
%     if i~=1
%         truth_m(i) = (sse_m(i)<= sse_m(i-1));
%     end
% end
% 
% verifyEqual(testCase,prod(truth_m),1)
% end

%Test that updating weights does not increase sum squared error
function test_update(testCase)
X = [pi/2,0;    pi/2, pi/2;     pi/2, pi;   pi/2, 3*pi/2;   0,0;    pi,0; ...
    atan(0.5), 0;  atan(0.5), pi/2; atan(0.5), pi;    atan(0.5), 3*pi/2; ...
    pi-atan(0.5), 0;  pi-atan(0.5), pi/2; pi-atan(0.5), pi;    pi-atan(0.5), 3*pi/2];
t = [1;1;1;1;2;2;sqrt(5);sqrt(5);sqrt(5);sqrt(5);sqrt(5);sqrt(5);sqrt(5);sqrt(5)];

n = 2; 
lr = 1;
lam = 0;

w = zeros((n+1)^2, 1);
truth_m = zeros(size(X,1)-1,1);
w = sc2sbf_slr(X(1,:), t(1), n, w, lr, lam);

for i=2:size(X,1)
    lr = 1/i;
    sse_o = 0;
    for j=1:i
        for l=0:n
            for m=-l:l
                ta = + w(l^2+l+m+1)*sbf(l, m, X(i,1), X(i,2));
            end
        end
       sse_o = sse_o + (t(j)- ta)^2; 
    end
    w = sc2sbf_slr(X(i,:), t(i), n, w, lr, lam);
    sse_n = 0;
    for j=1:i
        for l=0:n
            for m=-l:l
                ta = + w(l^2+l+m+1)*sbf(l, m, X(i,1), X(i,2));
            end
        end
       sse_n = sse_n + (t(j)- ta)^2; 
    end

    truth_m(i-1) = (sse_n<= sse_o);
end

verifyEqual(testCase,prod(truth_m),1)
end


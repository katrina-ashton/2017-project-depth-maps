function val = innerprod(fun1, fun2, a, b)
funp = @(x)double(fun1(x)).*double(fun2(x));
val = integral(funp, a, b);
end
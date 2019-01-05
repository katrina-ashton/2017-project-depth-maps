function tests = unit_tests_test
tests = functiontests(localfunctions);
end

%Check if r value matches up (no movement)
function test_r1(testCase)
hres = 1000;
cres = 1000;
r = 1;
[X,Y,Z] = cylinder(r*ones(1,hres), cres);

ptol = 10^(-3);
ttol = 10^(-3);

O = [0,0,0];
theta = atan(2);
phi = 0;

r = get_r(X, Y, Z, O, theta, phi, ttol, ptol);
exp = sqrt(1.25);
tol = ptol*ttol;
verifyEqual(testCase, r, exp, 'AbsTol', tol)
end

function test_r2(testCase)
hres = 1000;
cres = 1000;
r = 1;
[X,Y,Z] = cylinder(r*ones(1,hres), cres);

ptol = 10^(-3);
ttol = 10^(-3);

O = [0,0,0];
theta = atan(2);
phi = pi/2;

r = get_r(X, Y, Z, O, theta, phi, ttol, ptol);
exp = sqrt(1.25);
tol = ptol*ttol;
verifyEqual(testCase, r, exp, 'AbsTol', tol)
end

%Check if r value matches up (movement)
function test_rm1(testCase)
hres = 1000;
cres = 1000;
r = 1;
[X,Y,Z] = cylinder(r*ones(1,hres), cres);

ptol = 10^(-3);
ttol = 10^(-3);

O = [0.5,0,0];
theta = atan(1);
phi = 0;

r = get_r(X, Y, Z, O, theta, phi, ttol, ptol);
exp = sqrt(0.5);
tol = ptol*ttol;
verifyEqual(testCase, r, exp, 'AbsTol', tol)
end
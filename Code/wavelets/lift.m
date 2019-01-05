%set params
n = 1;

%get data

%split data
[lam, gam] = lift_split('lazy', data);

%find prediction
pred = lift_prediction(lam);
gam = gam-pred;

%update
upd = lift_update(gam);
lam = lam + upd;

%need to do the same thing, but use lam as data. Best way to store?

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Five futures

yt = log([tav.trc2,tav.trc4,tav.trc6,tav.trc8,tav.trc10]); %log-prezzi future 
TF = ([2,4,6,8,10])/12; %maturity future
dt = 1/252;  %time step 
nrunge = 2000; %discretization steps runge kutta


%% Future maturity alternative -- sensitivity analysis

yt = log([tav.trc4,tav.trc6,tav.trc8,tav.trc10, tav.trc12]); %log-prezzi future 
TF = ([4,6,8,10,12])/12; %maturity future
dt = 1/252;  %time step 
nrunge = 2000; 


%% Ottimizzazione solo Future
cd '/Users/chris/Desktop/unibo/ballestra/commodity/code/OurModel'

[theta0] = start_our(yt, TF, nrunge, dt);
nparam = length(theta0);
opt2 = optimoptions('fmincon', ...
                    'Display','off', ...
                    'Algorithm', 'sqp');   
Aineq = []; bineq = []; Aeq = []; beq = []; 
nonlcon = [] ;
lb = repelem( -10 , nparam); %lower bound
lb([19:24]) = -1; %correlazioni
ub = repelem( +10 , nparam); %upper bound
ub([19:24]) = +1; %correlazioni
[theta1] = fmincon( 'loglik_our' , theta0 , ...
    Aineq,bineq,Aeq,beq,lb,ub,nonlcon, opt2, yt, TF, nrunge, dt);

[ll,lp,Xt,et,a,Z] = loglik_our(theta1, yt, TF, nrunge, dt);

%% Standard errors futures
[VCV,A,B,scores,hess,gross_scores]=robustvcv('loglik_our',theta1,0,yt,TF,nrunge,dt,usv);
se = sqrt(diag(VCV));
N = size(yt,1)*size(yt,2);
p = length(theta1);
sig99 = ( abs(theta1) ./ se' ) >= tinv(0.99, N  - p) ;
sig95 = ( abs(theta1) ./ se' ) >= tinv(0.95, N  - p) ;
sig90 = ( abs(theta1) ./ se' ) >= tinv(0.90, N  - p) ;

[VCV,A,B,scores,hess,gross_scores]=robustvcv('loglik_our_bond_old',theta1,0,yt,yt_Rt,TF,TB,nrunge,dt,usv);
se = sqrt(diag(VCV));
N = size(yt,1)*size(yt,2) + size(yt_Rt,1)*size(yt_Rt,2);
p = length(theta1);
sig99 = ( abs(theta1) ./ se' ) >= tinv(0.99, N  - p) ;
sig95 = ( abs(theta1) ./ se' ) >= tinv(0.95, N  - p) ;
sig90 = ( abs(theta1) ./ se' ) >= tinv(0.90, N  - p) ;


%% Ottimizzazione con Future+Bond 
cd '/Users/chris/Desktop/unibo/ballestra/commodity/code/OurModel'

TB = [3,6]/12; %maturity bond yield
yt_Rt = Rt(:,[3,4]); %seleziona bond yield prices
    
[theta0] = start_our_bond(yt,yt_Rt,TF,TB,nrunge,dt);
nparam = length(theta0);
opt2 = optimoptions('fmincon', ...
                    'Display','off', ...
                    'Algorithm', 'sqp');
Aineq = []; 
bineq = []; 
Aeq = []; 
beq = []; 
nonlcon = [] ;
lb = repelem( -10 , nparam); %lower bound
lb([19:24]) = -1; %correlazioni
lb([6,7,12,13]) = 0; %param vt
ub = repelem( +10 , nparam); %upper bound
ub([19:24]) = +1; %correlazioni
[theta1] = fmincon( 'loglik_our_bond' , theta0 , ...
        Aineq,bineq,Aeq,beq,lb,ub,nonlcon, opt2, yt, yt_Rt, TF, TB, nrunge, dt);
[ll,lp,Xt,et,a,Z] = loglik_our_bond(theta1, yt, yt_Rt, TF, TB, nrunge, dt);


%% AIC and BIC

LL =  -ll;
T = size(yt,1) * size(yt,2);
nparam = length(theta1) ;
BIC = - 2 * LL  + log(T) * nparam;
AIC = - 2 * LL  + 2 * nparam;

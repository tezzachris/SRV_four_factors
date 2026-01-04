
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Estimation using five futures contracts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Import data

yt = log([tav.trc2,tav.trc4,tav.trc6,tav.trc8,tav.trc10]); %log-future prices time series 
TF = ([2,4,6,8,10])/12; %maturity futures
dt = 1/252;  %daily time step 
nrunge = 2000; %discretization steps runge kutta

%Estimation

[theta0] = start_param(yt, TF, nrunge, dt);
nparam = length(theta0);
opt2 = optimoptions('fmincon', ...
                    'Display','off', ...
                    'Algorithm', 'sqp');   
                    
Aineq = []; bineq = []; Aeq = []; beq = []; 
nonlcon = [] ;
lb = repelem( -10 , nparam); %lower bound
lb([19:24]) = -1; %correlations
ub = repelem( +10 , nparam); %upper bound
ub([19:24]) = +1; %correlations

[theta1] = fmincon( 'loglik' , theta0 , ...
    Aineq,bineq,Aeq,beq,lb,ub,nonlcon, opt2, yt, TF, nrunge, dt);

%Assess output

[ll,lp,Xt,et,a,Z] = loglik(theta1, yt, TF, nrunge, dt);

%% AIC and BIC

LL =  -ll; %from negative log-likelihood 
T = size(yt,1) * size(yt,2);
nparam = length(theta1) ;
BIC = - 2 * LL  + log(T) * nparam;
AIC = - 2 * LL  + 2 * nparam;

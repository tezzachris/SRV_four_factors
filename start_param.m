



function [param] = start_param(yt, TF, nrunge, hsim)
    
    nsim = 1000 ; %number of simulations
    ll = zeros(nsim,1);
    ny = size(yt,2); 
    nparam = 27  + ny;
    
    p = zeros(nsim, nparam);

    for i = 1:nsim

        %means
        
        mu1hat=rand; 
        mu2=rand;
        mu2hat=rand;
        mu3=rand;
        mu3hat=rand;
        mu4=rand;
        mu4hat=rand;
        
        %return to the mean 
        
        k2=rand;
        k2hat=rand;
        k3=rand;
        k3hat=rand;
        k4=rand;
        k4hat=rand;

        s12=0.05*rand;
        s22=0.05*rand;
        s13=0.05*rand;
        s23=0.05*rand;
        s33=0.05*rand;
        
        %covariances
        
        rho12 = 0.8*rand ;
        rho13 = 0.8*rand - 0.8;
        rho14 = 0.8*rand - 0.5;
        rho23 = 0.5*rand - 0.5;
        rho24 = 0.5*rand - 0.5;
        rho34 = 0.5*rand - 0.5;
        
        %volatility
        
        sig22 = 0.1*sqrt(rand);
        sig33 = 0.1*sqrt(rand);
        sig44 = 0.1*sqrt(rand);


        %variances prediction errors
        epsi = 0.01*rand(1,ny); 

        theta = [mu1hat,mu2,mu2hat,mu3,mu3hat,mu4,mu4hat, ...
                k2,k2hat,k3,k3hat,k4,k4hat,...
                s12,s22,s13,s23,s33, ...
                rho12,rho13,rho14,rho23,rho24,rho34, ...
                sig22,sig33,sig44, ...
                epsi]; 

        ll(i) = loglik(theta, yt, TF, nrunge, hsim);
        p(i,:) = theta;

    end
        llmin = min(ll(imag(ll)==0));
        indice= ll == llmin;
        param = p(indice,:);
end

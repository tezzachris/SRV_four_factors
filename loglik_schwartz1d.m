

function [ll,lp,Xt,et,a,Z,eig_val] = loglik( theta, yt, TrungeF, nrunge, h )
    
    n = size(yt,1);  %number of observations
    ny = size(yt,2); %number of futures contracts
    
    theta_x = num2cell(theta);

    [mu1hat,... 
     mu2,mu2hat,...
     mu3,mu3hat,...
     mu4,mu4hat,...
     k2,k2hat,...
     k3,k3hat,...
     k4,k4hat,... 
     s12,s22,s13,s23,s33,...
     rho12,rho13,rho14,rho23,rho24,rho34, ...
     sig22,sig33,sig44,...
     ] = deal(theta_x{1:end-ny});

    sigepsi = theta(end-ny+1 : end);
    
    H = diag( sigepsi.^2 );
    
    A = [0; 
         mu2*k2;
         mu3*k3; 
         mu4*k4];

    Af = [mu1hat; 
          mu2hat*k2hat;
          mu3hat*k3hat; 
          mu4hat*k4hat];

    d = size(A,1);

    B = [     0 -1 +1 -0.5;
              0  -k2   0 0;
              0  0   -k3  0;
              0  0   0  -k4];
    
    Bf = [    0  -1  0 -0.5;
              0  -k2hat   0 0;
              0  0   -k3hat  0;
              0  0   0  -k4hat];
    

    Bf = B;
    
    omega0 = [ 0 ,s12,s13,0;
               s12,s22^2,s23,0;
               s13,s23,s33^2,0;
               0,0,0,0];

    omega1 = [1 rho12*sig22 rho13*sig33 rho14*sig44;
              rho12*sig22 sig22^2 rho23*sig22*sig33 rho24*sig22*sig44;
              rho13*sig33 rho23*sig22*sig33 sig33^2  rho34*sig33*sig44;
              rho14*sig44 rho24*sig22*sig44 rho34*sig33*sig44 sig44^2];
    
    %Runge kutta per coefficienti affini
    a = []; Z = [];
    for i = 1:length(TrungeF)
        [ait,bit] = RungeKuttaFuture(nrunge,TrungeF(i),A,B,omega0,omega1);
        a = [a, ait(end)]; 
        Z = [Z; bit(end,:)];
    end

    %Kalman Filtering
    ll = 0; 
    lp = zeros(n,1);
    
    %intial estimates
    Xt0 = [mu1hat, mu2hat, mu3hat, mu4hat];
    
    Pt = eye(d,d) ;
    Pt(4,4) = 0.001; %more appropriate starting value for vol
 
    Xt = zeros(n,d);
    et = zeros(n,ny);
    eig_val = zeros(n,1); 
    I = eye(d,d);
    
    for i = 1 : n 
         if i > 1
                Xt0 = Xt(i-1,:);
         end
         
            %Prediction equations
             
            Xpred = h * Af' + ( (I + h * Bf) * Xt0' )'  ;
            
            Xpred(4) = exp(-h*k4hat)  * (Xt0(4) + k4hat * mu4hat * h);
            
            ypred = a +  ( Z  * Xpred' )';
            
            Q = omega0 + omega1 * Xt0(4);

            Ppred = (I+h*Bf) * Pt * (I+h*Bf)' + h*Q ;

            %Prediction error
            ytrue = yt(i,:);
            vt = ytrue - ypred ;
            Ft = Z * Ppred * Z'  + H ; 
            
            %we need Ft to be intervible, so we check its eigenvals
            eig_val(i) = min( eig( Ft ) )  ;
            
            %Updating equations
            Kt = (Ppred * Z')/(Ft);
            Xt(i,:) = Xpred + (Kt * vt')'; 
           
            Pt =  Ppred - Kt*Z*Ppred;
            lp(i) = 0.5 * ( ny * log(2*pi) + log( det(Ft) ) +  (vt / Ft * vt') ); %vt is row vector here
            ll = ll + lp(i);           

            et(i,:) = vt  ;

         
    end   

end

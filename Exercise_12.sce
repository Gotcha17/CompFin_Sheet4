//Part a)
// We need to change the line where option values are calculated recursively.
// It is required to check, whether in current state at current time stock price
// has breeched the barrier, if so an option value of zero is assigned.
// Option values for last column do not need to be recalculated, since K<B and
// therefore value of the option at time T is zero anyways, if S(T)>B-->S(T)>K

clc; clear; //clears the console and all previously stored variables
function V_0 = UpOutPut_BinMod(S_0, r, sigma, T, K, B, M)
    delta_t = T/M;  //calculation of delta_t
    Beta = (exp(-r*delta_t)+exp((r+sigma^2)*delta_t))/2;  //calculation of beta for CRR
    u=Beta+sqrt((Beta^2)-1); //so u>d is true
    d=u^-1; //because ud=1
    q=(exp(r*delta_t)-d)/(u-d); //calculation of succes probability (u)
    S=zeros(M+1,M+1); //creation stock price matrix
    S(1,1)=S_0; //Setting stock price at t=0 as initial price in the stock matrix
    
    for i=2:M+1 //Initializing algo for computation of stock price 
        for j=1:i
            S(j,i)=S(1,1)*u^(j-1)*d^(i-j); //with j upwards and i-j downwards movements
        end
    end
    
    V=-ones(M+1,M+1); //creating option value matrix
    V(:,M+1)=max((K-S(:,M+1)), 0); //calculation of option values for last column
    
    for i=M:-1:1 //Initializing algo for computation of option price
            //option value is zero if at current point stock price is higher than the barrier
            V(1:i,i)=exp(-r*delta_t)*(q*V(2:i+1,i+1)+(1-q)*V(1:i,i+1)).*(S(1:i,i) < B);
    end
    V_0 = V(1,1); //setting of first element of the option value matrix as option price at time t=0
endfunction

S_0=100; r=0.05; sigma=0.2; T=1; K=100; B=110; M=1000;

V_0 = UpOutPut_BinMod(S_0, r, sigma, T, K, B, M);
disp("Option price at time t=0 for an up-and-out put is "+string(V_0));

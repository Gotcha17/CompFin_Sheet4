

clc; clear; //clears the console and all previously stored variables
funcprot(0); //disables the warning messages, when function is redefined

//calculating the greeks with approximation of partial differential
function [Delta, vega, rho, Theta] = BS_Greeks_num(r, sigma, S0, T, g, eps)
    Delta = (BS_Price_Int(r, sigma, S0+eps.*S0, T, g)-BS_Price_Int (r, sigma, S0, T, g))/(eps.*S0);
    vega = (BS_Price_Int(r, sigma+eps*sigma, S0, T, g)-BS_Price_Int (r, sigma, S0, T, g))/(eps*sigma);
    rho = (BS_Price_Int(r+eps*r, sigma, S0, T, g)-BS_Price_Int (r, sigma, S0, T, g))/(eps*r);
    Theta = -((BS_Price_Int(r, sigma, S0, T+eps*T, g)-BS_Price_Int (r, sigma, S0, T, g))/(eps*T));
endfunction
//defining payoff function for an European Put
deff("y = g(x)", "y = max(100-x,0)");

// setting values as given in the exercise (T was not given is assumed to be 1)
r = 0.05; sigma = 0.2; S0 = [60:140]; T = 1; eps = 0.001

// BS_Price_Int function is needed for calculations and is located in this file
exec ("CompFin_2017_SS_BS_Price_Int.sce", -1);

//selecting and clearing figure one
scf(0); clf(); 

//Since BS_Price_Int function was not written for vector input, it was needed 
//to implement a for loop for the range of initial stock prices
for i=min(S0):max(S0)
    [Delta, vega, rho, Theta] = BS_Greeks_num(r, sigma, i, T, g, eps);
    plot(i, Delta,"b.");
end

//Labeling x and y axes of the plot 
xlabel("$S_t$");
ylabel("$\delta$");

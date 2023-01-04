%Benjamin Wong
%RBNZ
%June 2016

function [A,SIGMA,U,invXX,X] = olsvar_df(y,p,nc)
% This estimates an an AR or VAR in Dickey Fuller Form
% W/o a constant

%INPUTS
%y  Data(TxN)
%p  lags
%nc constant. set to 1 if no constant

%OUTPUTS
%A      VAR Coefficients
%SIGMA  Reduced form variance covariance matrix
%U      Time Series of Residuals

T = size(y,1)-p;      %length of Time Series

Y = y(p+1:end,:);     %Cut Away first p lags
if nargin == 2
    X = ones(T,1);
else
    X = [];
end

%Put in first lag on LHS
Z = y(p:end-1,:);
X = [X Z];

Y = Y(2:end,:); X=X(2:end,:);


%Now do second difference

dy = diff(y);
for i = 1:p-1
    Z = dy(p+1-i:end-i,:);
    X = [X Z];
end


%Get OLS coefficients
A = (X'*X)\(X'*Y);

%Get OLS residuals
U = Y-X*A;

%Get OLS variance covariance matrix
%dof is Total Sample-lags-Number of Regressors
SIGMA   = (U'*U)/(T-size(A,1));

invXX   = inv(X'*X);

end


function [BN_cycle,auxillary_output] = BN_Filter(y,p,delta)
% Benjamin Wong
% RBNZ
% June 2016
% Implements BN Filter by imposing the Signal-to-noise raio, delta
%
%% INPUTS
%
%y                        Time series to implement BN Filter in first differences
%p                        lags
%delta                    Signal to noise ratio
%
%
%% OUTPUTS
%BN_cycles                   The estimated cycles
%auxillary_output            Auxillary output (residuals, AR coefficients, etc)

%% Calculate rho from delta
rho = -(1-sqrt(delta))/sqrt(delta);

%demean time series
y = y - mean(y);


%% Re-parameterise model and subtract second differences multiplied by sum of AR coefficients to fix delta
% Adjust the LHS variable on the regression to take note of this

%Backcast data with mean 0
augmented_y = [zeros(p+1,1);y];

% Get data matrix from untransformed model. Estimate without constant
[~,~,~,~,X] = olsvar_df(augmented_y,p,1);

%Get regressors, variance and lags of untransformed AR(p) to perform BN
%later. Estimate AR by least squares without constant
[~,sigma_ols,~,~,untransformed_X] = olsvar([zeros(p,1);y],p,1);

reparameterised_y = augmented_y(p+2:end) - rho*X(:,1);


%% Calculate other preliminaries before estimation

% Create Data for transformed model to estimate
Y = reparameterised_y; X = X(:,2:end);
%Set other parameters for conjugate priors
A_prior = zeros(p-1,1);   %constant and (p-1) phi_stars coefficients 
% Uninformative prior on constant centered on zero
V_prior = diag(repmat(0.5,1,p-1)./((1:p-1).^2));

%% Calculate Posteriors

V_post = ((V_prior\eye(p-1)) + (1/sigma_ols)*(X'*X))...
    \eye(p-1);
A_post = V_post*((V_post\eye(p-1))*A_prior + kron(1/(sigma_ols),X)'*Y);

%add rho back into the posterior of estimated parameters
A_post = [rho;A_post];
    
%% Map the parameters in DF form back to AR form 
AR_parameters = zeros(p,1);

%last lag
AR_parameters(end,1) = -A_post(end,1);

for i = p-1:-1:2  %calculate up to AR(2) term
   AR_parameters(i,1) = -A_post(i,1)-sum(AR_parameters(i:end,1));
end
%Calculate AR(1) term
AR_parameters(1,1) = rho - sum(AR_parameters(2:end,1));
  
auxillary_output.AR_coeff = AR_parameters;
auxillary_output.residuals = y-untransformed_X*AR_parameters;

%% BN Decomposition Starts here
%Add current period in to incoporate current information set to do BN decomposition

X = [untransformed_X(2:end,:);
    y(end,1) untransformed_X(end,1:end-1)];

Companion = [AR_parameters';
            eye((p-1)) zeros((p-1),1)];

bigeye = eye(p);

phi = -Companion*((bigeye-Companion)\eye(p));
BN_cycle = phi*X';
BN_cycle = BN_cycle(1,:)';

end
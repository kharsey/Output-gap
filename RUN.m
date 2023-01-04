%Benjamin Wong
%RBNZ
%March 2017

% This is example code to estimate the BN filter output gap
%(Kamber, Morley, Wong, Review of Economics and Statistics)
% for US from 1947Q2-2016Q4

%%
addpath('_func')

clear all
clc
% load US Real GDP 1947Q1-2016Q4
% (i.e. The BN cycle will be calculated on 1947Q2-2016Q4 as the time series
% model is estimated on growth rate)
load USGDP.csv

%% Options
options.NBERRrecessionBands = 1;         % Set to 1 if you want to plot NBER Bands
p = 12;                                  % Lag order


% Options to deal with breaks (see paper)
options.dynamic_demean = 0;              % set to 1 to implement dynamic mean adjustment
                                         % see section 4
options.structural_break = 0;            % Set to 1 to implement a structural break
                                         % This may be informed by a
                                         % Bai-Perron test
breakdate = 237;                         % set a breakdate for the observation
                                         % 237 is 2006Q1

%load the dates of the decomposition
dates = 1947.25:0.25:2016.75;
dy = 100*diff(log(USGDP));  %adjust dy for mean growth rate here if you want to implement structural breaks

if options.dynamic_demean == 1
    dy = rolling_demean(dy);    
end

if options.structural_break == 1;
    dy = [dy(1:breakdate)-mean(dy(1:breakdate));...
        dy(breakdate+1:end)-mean(dy(breakdate+1:end))];
end
        




%% Estimation

%automatic delta criteria
options.delta = max_amplitude_to_noise(dy,p);

[BN_cycle, auxillary_output] = BN_Filter(dy,p,options.delta);

%% Plot output gap
if options.NBERRrecessionBands == 1
    NBERbc(dates,BN_cycle,{'-'},3,{'r'})
else
    plot(dates,BN_cycle,'-r','LineWidth',3);
end
hold on
plot([dates(1) dates(end)],zeros(2,1),'-k','LineWidth',2);
title('BN Filter Estimated Output Gap','FontSize',18)
set(gca,'FontSize',18)
set(gca,'Layer', 'top')
xlim([dates(1) dates(end)])

% Display Signal to noise ratio
disp('The Signal to noise ratio, $\delta$ =')
disp(options.delta)

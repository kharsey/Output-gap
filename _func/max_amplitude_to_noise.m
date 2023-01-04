function [delta_track] = max_amplitude_to_noise(y,p)
%Benjamin Wong
%RBNZ
%November 2016
% The code chooses the signal to noise ratio, \delta, by doing a grid
% search from 0.01 in increments of 0.01 to find the first local maximum of
% the amplitude to noise ratio.
%
% Note: Code has other dependencies
%
%INPUTS
%y          time series
%p          lag order
%

%%
%initialize the difference to enter loop
diff = 1;

%initialize amplitude to noise ratio
delta_track = 0.01;
[gap_temp,auxillary_output] = BN_Filter(y,p,delta_track );
old_amp_to_noise =    var(gap_temp)/mean(auxillary_output.residuals.^2);

while diff > 0
    delta_track  = delta_track + 0.01;
    [gap_temp,auxillary_output] = BN_Filter(y,p,delta_track);
    new_amp_to_noise =    var(gap_temp)/mean(auxillary_output.residuals.^2);
    
    diff = new_amp_to_noise - old_amp_to_noise;
    
    if diff > 0
        old_amp_to_noise = new_amp_to_noise;
    end
    
    
end

delta_track = delta_track - 0.01;







end


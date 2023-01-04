function demeaned_y = rolling_demean(y)
% Benjamin Wong 
% RBNZ
% November 2016
% Demean relative to a backward rolling 40 quarter window


T = size(y,1);

demeaned_y = y(1:40)-mean(y(1:40));

for i = 41:T
    demeaned_y(i,1) = y(i) - mean(y(i-39:i));
    
    
    
end



end


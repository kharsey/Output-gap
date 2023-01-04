The zipped set of codes allow a user to estimate the BN filter output gap with the automatic signal-to-noise selection criteria as described in
Kamber, Morley and Wong,
Review of Economics and Statistics
"Intuitive and Reliable Estimates of the Output Gap from a Beveridge-Nelson Filter"

RUN.m is the main file and will load US GDP for 1947Q1-2016Q4.

The growth rate is calculated and the BN filter US output gap is computed from 1947Q2-2016Q4.
To deal with structural breaks in the long-run drift, we include options to implement the dynamic demeaning that we describe in the paper
or to just enter a breakdate, preferably informed by a test such as Bai-Perron.

The main function to calculate the BN filter is BN_Filter.m, with all other function files as dependencies.
One can calculate the BN filter with three arguments: The data, the signal-to-noise ratio and the lag order of the AR model.

We are not responsible for any loss you may incur, financial or otherwise, by using our code
If you use the code, please cite and acknowledge the paper.


Gunes Kamber
James Morley
Benjamin Wong
March 2017
# Filter Coefficients

We used this branch to store the coefficients of the different FIR coefficients we wanted to test on our microcontroller. 

This branch uses low-pass FIR filters made through three separate FIR  design algorithms: Window, Remez Exchange and Least Squares. We used four separate 'windows' in the windowing algorithm, each producing their own coefficents: Hamming, Blackman, Rectangle and Kaiser.

Each of these FIR coefficients were made using packages on MATLAB, we created them to all approximate a -3 dB cutoff at 1000 Hz.

Furthermore, we added a 3_tap moving average and an 8 tap moving average (named 'Moving_avg.s' ) to test how weel these filters reduced high frequency noise.

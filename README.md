# Microprocessors
Repository for Physics Year 3 microprocessors lab

Description for each branch:

FIR (default):
This branch has the complete implementation of our FIR filter that we have used to conduct our experiment. It has code to do the signal processing of an 8bit input, using an 8 tap 8bit coefficient filter, and outputs 24 bit values through UART to the computer, to then later analyse with python. It has code to send the outputs through UART, and a timer to time the signal processing.

FiR_coeffs:
This brach holds the coefficients we have used in our experiment.

UART_Hello_World:
This branch was used to test and work on the code that would send our signal to the computer for further analysis.

Filter:
This branch was used to test the initial filtering algorithm, with simpler filters than the final ones we used

MatrixMultiplier:
This branch was used to initially test multiple algorithm options for the MAC operations.

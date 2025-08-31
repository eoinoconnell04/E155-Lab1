# E155 Lab 1

This repo includes code to verify correct assembly of the E155 development board and operations of the MCU and FPGA.

The file `lab1_eo.sv` performs multiple functions to test the funcitonality of the E155 board and FGPA. 
1. It flashes a light at 2.4 GHz to test a clock divider from the onboard 48 MHz Clock.
2. Turns on 2 leds as a function of 4 DIP swiches on the board.
3. Controls a seven segment display from the same 4 DIP switches to represent the hexadecimal digit.
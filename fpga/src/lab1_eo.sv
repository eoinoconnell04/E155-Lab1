/*
Author: Eoin O'Connell
Email: eoconnell@hmc.edu
Date: Aug. 30, 2025
Module Function: This is the top level module for E155 Lab 1, which is primarily to test the FGPA and board. It performs 3 main functions:
1. It flashes a light at 2.4 GHz to test a clock divider from the onboard 48 MHz Clock.
2. Turns on 2 leds as a function of 4 DIP swiches on the board.
3. Controls a seven segment display from the same 4 DIP switches to represent the hexadecimal digit.
*/
module lab1_eo(
	input  logic [3:0] s,
	output logic [6:0] seg,
	output logic [2:0] led
);

	logic clk, divided_clk;
	
	// Internal high-speed oscillator
	HSOSC hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk));

    // Initialize clock divider (outputs 2.4 Hz)
    divider div (.clk(clk), .divided_clk(divided_clk));

    // Initialize seven segment display
    display dis (.s(s), .seg(seg));

    assign led = {divided_clk, s[3] & s[2], s[1] ^ s[0]};

endmodule
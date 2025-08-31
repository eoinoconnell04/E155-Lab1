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

/*
Author: Eoin O'Connell
Email: eoconnell@hmc.edu
Date: Aug. 30, 2025
Module Function: This module takes in a 48 Mhz clock and outputs a 2.4 Hz clock that maintains a 50% duty cycle.
Note: Technically, this module divides the clock frequency by 10,000,000 for any input frequency, the numbers above are just what are being used in this specific module.
Note: By changing the localparam TOGGLE_COUNT, one can easily change the scaling (for large changes the number of bits of the count may have to be altered as well.)
*/
module divider(
    input logic clk,
    output logic divided_clk
);

    logic [23:0] counter = 0;  // Should there be a dedicated reset?

    // Toggle every 10,000,000 cycles (need to check 1 cycle early to account for reset being 0 not 1)
    localparam TOGGLE_COUNT = 24'd9_999_999; 

    // Clock Divider
    always_ff @(posedge clk)
        if(counter == TOGGLE_COUNT) begin
            divided_clk <= ~divided_clk;
            counter <= 24'd0;
        end
        else begin
            counter <= counter + 1;
        end

endmodule

/*
Author: Eoin O'Connell
Email: eoconnell@hmc.edu
Date: Aug. 30, 2025
Module Function: This module converts a 4-bit hexadecimal input into a 7-bit output where each bit controls a different panel of the seven segment display.
Note: this module assumes an active-low for the seven segment display (a signal of 0 means the panel will be luminated)
*/
module display(
    input  logic [3:0] s,
    output logic [6:0] seg
);

    always_comb begin
        case(s)
            4'b0000 : seg = 7'b1000000; // 0
            4'b0001 : seg = 7'b1111001; // 1
            4'b0010 : seg = 7'b0100100; // 2
            4'b0011 : seg = 7'b0110000; // 3
            4'b0100 : seg = 7'b0011001; // 4
            4'b0101 : seg = 7'b0010010; // 5
            4'b0110 : seg = 7'b0000010; // 6
            4'b0111 : seg = 7'b1111000; // 7
            4'b1000 : seg = 7'b0000000; // 8
            4'b1001 : seg = 7'b0011000; // 9
            4'b1010 : seg = 7'b0001000; // A
            4'b1011 : seg = 7'b0000111; // b
            4'b1100 : seg = 7'b1000110; // C
            4'b1101 : seg = 7'b0100001; // d
            4'b1110 : seg = 7'b0000110; // E
            4'b1111 : seg = 7'b0001110; // F
            default: seg = 7'b1111111; // all off
        endcase

    end

endmodule
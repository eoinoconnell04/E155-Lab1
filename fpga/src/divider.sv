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
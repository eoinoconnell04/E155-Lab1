/*
Author: Eoin O'Connell
Email: eoconnell@hmc.edu
Date: Sep. 1, 2025
Module Function: Version of divider.sv that resets at a lower count to that it is easier to test waveforms.
Instead of counting to 10,000,000, this version counts to 10 and resets.
*/
module divider_test_version(
    input logic clk, reset,
    output logic divided_clk
);

    // Counter only needs 4 bits (can count up to 15)
    logic [3:0] counter = 0;

    // Toggle every 10 cycles (reset at count 9)
    localparam TOGGLE_COUNT = 4'd9;

    // Clock Divider
    always_ff @(posedge clk) begin
        if (reset) begin
            counter     <= 0;
            divided_clk <= 0;
        end 
        else if (counter == TOGGLE_COUNT) begin
            divided_clk <= ~divided_clk;
            counter     <= 0;
        end 
        else begin
            counter <= counter + 1;
        end
    end

endmodule
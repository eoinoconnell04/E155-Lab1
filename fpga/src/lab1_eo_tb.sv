/*
Author: Eoin O'Connell
Email: eoconnell@hmc.edu
Date: Aug. 31, 2025
Module Function: Testbench to test top level module for E155 Lab 1.

Note: Testbench modified from my testbench from E85 Lab 3.
*/


module display_tb();
    logic clk, reset;
    logic [3:0] s;
    logic [2:0] led;
    logic [6:0] seg;
    logic [8:0] expected;
    logic [31:0] vectornum, errors;
    logic [12:0] testvectors[10000:0];  // 4 input bits + 7 expected output bits

    // instantiate device under test
    lab1_eo dut(s, seg, led);

    // generate clock
    always begin
        clk = 1; #5; clk = 0; #5;
    end

    // at start of test, load vectors and pulse reset
    initial begin
        $readmemb("display_tb.tv", testvectors);
		$display("Loaded test vector 0: %b", testvectors[0]);
        vectornum = 0; errors = 0; reset = 1; #22; reset = 0;
    end

    // apply test vectors on rising edge of clk
    always @(posedge clk) begin
        $display("%b", testvectors[vectornum]);
		#1; {s, expected} = testvectors[vectornum];
    end

    // check results on falling edge of clk
    always @(negedge clk)
        if (~reset) begin // skip during reset
            if ({seg, led[1:0]} !== expected) begin // check result
                $display("Error: input = %b", s);
                $display(" output = seg: %b, s:%b (%b expected)", seg, s[1:0], expected);
                errors = errors + 1;
            end
            vectornum = vectornum + 1;
            if (testvectors[vectornum] === 14'bx) begin
                $display("%d tests completed with %d errors", vectornum, errors);
                $stop;
            end
        end
endmodule



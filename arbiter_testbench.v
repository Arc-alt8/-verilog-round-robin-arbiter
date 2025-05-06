`timescale 1ns / 1ps

module testbench;

    reg clk;
    reg reset;
    reg [3:0] req;
    wire [3:0] grant;

    // Instantiate your DUT (change `arbiter` to your module name if different)
    arbiter uut (
        .clk(clk),
        .reset(reset),
        .req(req),
        .grant(grant)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Stimulus
    initial begin
        // VCD waveform setup
        $dumpfile("dump.vcd");
        $dumpvars(0, testbench); // dump all signals

        // Reset sequence
        reset = 1;
        req = 4'b0000;
        #10;
        reset = 0;

        // Test cases
        #10 req = 4'b1010; // req 1 and 3
        #10 req = 4'b1100; // req 2 and 3
        #10 req = 4'b0110; // req 1 and 2
        #10 req = 4'b0001; // req 0
        #10 req = 4'b0000; // no req
        #10 req = 4'b1111; // all req
        #10 req = 4'b0010; // req 1 only

        #10 $finish;
    end

endmodule

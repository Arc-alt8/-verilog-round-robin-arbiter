module rr_arbiter (
    input wire clk,
    input wire reset,
    input wire [3:0] req,      // Request lines
    output reg [3:0] grant     // Grant lines
);

    reg [1:0] last_grant;      // Keeps track of last granted request

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            grant <= 4'b0000;
            last_grant <= 2'd3; // Initialize to 3 so next grant starts at 0
        end else begin
            grant <= 4'b0000;
            casex ({req, last_grant})
                // Priority starting from next request after last_grant
                default: begin
                    case (last_grant)
                        2'd0: begin
                            if (req[1]) begin grant[1] <= 1; last_grant <= 2'd1; end
                            else if (req[2]) begin grant[2] <= 1; last_grant <= 2'd2; end
                            else if (req[3]) begin grant[3] <= 1; last_grant <= 2'd3; end
                            else if (req[0]) begin grant[0] <= 1; last_grant <= 2'd0; end
                        end
                        2'd1: begin
                            if (req[2]) begin grant[2] <= 1; last_grant <= 2'd2; end
                            else if (req[3]) begin grant[3] <= 1; last_grant <= 2'd3; end
                            else if (req[0]) begin grant[0] <= 1; last_grant <= 2'd0; end
                            else if (req[1]) begin grant[1] <= 1; last_grant <= 2'd1; end
                        end
                        2'd2: begin
                            if (req[3]) begin grant[3] <= 1; last_grant <= 2'd3; end
                            else if (req[0]) begin grant[0] <= 1; last_grant <= 2'd0; end
                            else if (req[1]) begin grant[1] <= 1; last_grant <= 2'd1; end
                            else if (req[2]) begin grant[2] <= 1; last_grant <= 2'd2; end
                        end
                        2'd3: begin
                            if (req[0]) begin grant[0] <= 1; last_grant <= 2'd0; end
                            else if (req[1]) begin grant[1] <= 1; last_grant <= 2'd1; end
                            else if (req[2]) begin grant[2] <= 1; last_grant <= 2'd2; end
                            else if (req[3]) begin grant[3] <= 1; last_grant <= 2'd3; end
                        end
                    endcase
                end
            endcase
        end
    end

endmodule

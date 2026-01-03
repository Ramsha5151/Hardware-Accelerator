`timescale 1ns / 1ps

module mac_unit #(
    parameter DATA_WIDTH  = 8,
    parameter KERNEL_SIZE = 3
)(
    input  wire        clk,
    input  wire        rst_n,   // Reset consistent rakha hai
    input  wire [(DATA_WIDTH*KERNEL_SIZE*KERNEL_SIZE)-1:0] data_in, // 72-bit input
    input  wire        valid_in,
    output reg [DATA_WIDTH-1:0] mac_out,
    output reg        valid_out
);

    // Unpacking pixels from flat wire
    wire [DATA_WIDTH-1:0] p [0:8];
    assign {p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8]} = data_in;

    // Fixed Kernel Weights (Example: Identity or simple box blur)
    // Aap yahan apne coefficients change kar sakte hain
    wire signed [7:0] k [0:8];
    assign k[0] = 1; assign k[1] = 1; assign k[2] = 1;
    assign k[3] = 1; assign k[4] = 1; assign k[5] = 1;
    assign k[6] = 1; assign k[7] = 1; assign k[8] = 1;

    reg signed [15:0] sum;
    integer i;

    

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum <= 0;
            mac_out <= 0;
            valid_out <= 0;
        end else if (valid_in) begin
            // 3x3 Convolution formula: Sum of (Pixel * Weight)
            sum = (p[0]*k[0]) + (p[1]*k[1]) + (p[2]*k[2]) +
                  (p[3]*k[3]) + (p[4]*k[4]) + (p[5]*k[5]) +
                  (p[6]*k[6]) + (p[7]*k[7]) + (p[8]*k[8]);
            
            // Result ko 8-bit mein wapis lana (Division by 9 if blur)
            mac_out <= sum / 9; 
            valid_out <= 1'b1;
        end else begin
            valid_out <= 1'b0;
        end
    end

endmodule
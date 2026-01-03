`timescale 1ns / 1ps

module line_buffer #(
    parameter DATA_WIDTH  = 8,
    parameter KERNEL_SIZE = 3
)(
    input  wire clk,
    input  wire rst_n,
    input  wire [DATA_WIDTH-1:0] pixel_in,
    input  wire valid_in,

    // Explicitly define as wire for 'assign' compatibility
    output wire [(DATA_WIDTH * KERNEL_SIZE * KERNEL_SIZE)-1:0] window_flat,
    output reg  valid_out
);

    // Internal Registers
    reg [DATA_WIDTH-1:0] line0 [0:KERNEL_SIZE-1];
    reg [DATA_WIDTH-1:0] line1 [0:KERNEL_SIZE-1];
    reg [DATA_WIDTH-1:0] line2 [0:KERNEL_SIZE-1];

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < KERNEL_SIZE; i = i + 1) begin
                line0[i] <= 0; line1[i] <= 0; line2[i] <= 0;
            end
            valid_out <= 1'b0;
        end
        else if (valid_in) begin
            // Horizontal Shifting
            for (i = 0; i < KERNEL_SIZE-1; i = i + 1) begin
                line0[i] <= line0[i+1];
                line1[i] <= line1[i+1];
                line2[i] <= line2[i+1];
            end
            
            // Vertical Data Flow (Important for Convolution)
            line2[KERNEL_SIZE-1] <= pixel_in;
            line1[KERNEL_SIZE-1] <= line2[0]; // Data moving up to next line
            line0[KERNEL_SIZE-1] <= line1[0]; // Data moving up to next line
            
            valid_out <= 1'b1;
        end
        else begin
            valid_out <= 1'b0;
        end
    end

    // Window Flattening logic
    genvar r, c;
    generate
        for (r = 0; r < KERNEL_SIZE; r = r + 1) begin : ROW
            for (c = 0; c < KERNEL_SIZE; c = c + 1) begin : COL
                assign window_flat[DATA_WIDTH*(r*KERNEL_SIZE+c+1)-1 -: DATA_WIDTH] = 
                    (r==0) ? line0[c] :
                    (r==1) ? line1[c] :
                             line2[c];
            end
        end
    endgenerate

endmodule
`timescale 1ns / 1ps

module conv_core #(
    parameter DATA_WIDTH  = 8,
    parameter KERNEL_SIZE = 3
)(
    input  wire clk,
    input  wire rst_n,
    input  wire [DATA_WIDTH-1:0] pixel_in,
    input  wire valid_in,
    output reg [DATA_WIDTH-1:0] conv_out,
    output reg valid_out
);

    // --- Signals Section ---
    wire [(DATA_WIDTH * KERNEL_SIZE * KERNEL_SIZE)-1:0] window_flat;
    wire window_valid;
    wire fsm_valid_out; // FIXED: Ab ye signal declare kar diya gaya hai
    
    wire [DATA_WIDTH-1:0] mac_result;
    wire mac_valid;
    wire start_mac;

    // --- Line Buffer ---
    line_buffer #(
        .DATA_WIDTH(DATA_WIDTH),
        .KERNEL_SIZE(KERNEL_SIZE)
    ) u_line (
        .clk        (clk),
        .rst_n      (rst_n),
        .pixel_in   (pixel_in),
        .valid_in   (valid_in),
        .window_flat(window_flat), 
        .valid_out  (window_valid)
    );

    // --- FSM Controller ---
    fsm_controller u_fsm (
        .clk          (clk),
        .rst_n        (rst_n),
        .valid_in     (window_valid),
        .start_mac    (start_mac),
        .output_valid (fsm_valid_out) 
    );

    // --- MAC Unit ---
    mac_unit #(
        .DATA_WIDTH (DATA_WIDTH),
        .KERNEL_SIZE(KERNEL_SIZE)
    ) u_mac (
        .clk       (clk),
        .rst_n     (rst_n),
        .data_in   (window_flat), 
        .valid_in  (window_valid & start_mac),
        .mac_out   (mac_result),
        .valid_out (mac_valid)
    );

    // --- Output Logic ---
    always @(posedge clk or negedge rst_n) begin 
        if (!rst_n) begin
            conv_out  <= 0;
            valid_out <= 0;
        end else if (mac_valid) begin
            conv_out  <= mac_result;
            valid_out <= 1'b1;
        end else begin
            valid_out <= 1'b0;
        end
    end

endmodule
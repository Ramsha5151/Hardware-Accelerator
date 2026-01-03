module top (
    input clk,
    input rst_n,
    input [7:0] pixel_in,
    input valid_in,
    output [7:0] conv_out,
    output valid_out
);

    conv_core #(
        .DATA_WIDTH(8),
        .KERNEL_SIZE(3)
    ) u_conv (
        .clk(clk),
        .rst_n(rst_n),
        .pixel_in(pixel_in),
        .valid_in(valid_in),
        .conv_out(conv_out),
        .valid_out(valid_out)
    );

endmodule
`timescale 1ns / 1ps

module conv_core_tb();

    // 1. Parameters (Design ke mutabiq)
    parameter DATA_WIDTH  = 8;
    parameter KERNEL_SIZE = 3;
    parameter CLK_PERIOD  = 10; // 100MHz clock

    // 2. Testbench Signals (Inputs 'reg' honge, Outputs 'wire')
    reg                     clk;
    reg                     rst_n;
    reg  [DATA_WIDTH-1:0]   pixel_in;
    reg                     valid_in;
    
    wire [DATA_WIDTH-1:0]   conv_out;
    wire                    valid_out;

    // 3. Instantiate the Unit Under Test (UUT)
    conv_core #(
        .DATA_WIDTH(DATA_WIDTH),
        .KERNEL_SIZE(KERNEL_SIZE)
    ) uut (
        .clk(clk),
        .rst_n(rst_n),
        .pixel_in(pixel_in),
        .valid_in(valid_in),
        .conv_out(conv_out),
        .valid_out(valid_out)
    );

    // 4. Clock Generation Logic
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // 5. Stimulus Process
    initial begin
        // Reset Logic
        rst_n = 0;
        pixel_in = 0;
        valid_in = 0;

        #(CLK_PERIOD * 5);
        rst_n = 1;
        #(CLK_PERIOD * 2);

        // --- Simulating Image Pixel Stream ---
        $display("Starting Pixel Inflow...");
        
        // Row 1
        send_pixel(8'd10); send_pixel(8'd20); send_pixel(8'd30); send_pixel(8'd40); send_pixel(8'd50);
        // Row 2
        send_pixel(8'd15); send_pixel(8'd25); send_pixel(8'd35); send_pixel(8'd45); send_pixel(8'd55);
        // Row 3 (Valid output should appear after this row)
        send_pixel(8'd20); send_pixel(8'd30); send_pixel(8'd40); send_pixel(8'd50); send_pixel(8'd60);

        valid_in = 0; 
        
        #(CLK_PERIOD * 50);
        $display("Simulation Finished!");
        $stop;
    end

    // Helper Task
    task send_pixel(input [7:0] val);
        begin
            @(posedge clk);
            pixel_in = val;
            valid_in = 1;
        end
    endtask

endmodule
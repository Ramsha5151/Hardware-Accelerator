`timescale 1ns / 1ps

// FIXED: Module ka naam fsm_controller hai, conv_core nahi
module fsm_controller (
    input  wire clk,
    input  wire rst_n,
    input  wire valid_in,
    output reg  start_mac,
    output reg  output_valid
);

    // Yahan aapka FSM State logic aayega
    // IMPORTANT: Is file ke andar 'u_fsm' ya 'fsm_controller' ko call NAHI karna
    
    reg [1:0] state;
    localparam IDLE = 2'b00, PROCESS = 2'b01;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            start_mac <= 0;
            output_valid <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (valid_in) begin
                        state <= PROCESS;
                        start_mac <= 1;
                    end
                end
                PROCESS: begin
                    if (!valid_in) begin
                        state <= IDLE;
                        start_mac <= 0;
                    end
                end
            endcase
        end
    end

endmodule
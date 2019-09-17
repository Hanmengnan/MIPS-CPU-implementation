`include "defines.v"

module if_id(input wire clk,
    input wire rst,
    input wire [`InstAddrBus] if_pc,
    input wire [`InstBus] if_inst,
    output reg [`InstAddrBus] id_pc,
    output reg [`InstBus] id_inst);

    always @(posedge clk) begin
        /*这个模块起传递作用，将pc获取到的指令地址，及从rom中取得的指令，传输到译码模块*/
        if (rst == `RstEnable) begin
            id_pc <= `ZeroWord;
            id_inst <= `ZeroWord;
        end
        else begin
            id_pc <= if_pc;
            id_inst <= if_inst;
        end
    end

endmodule

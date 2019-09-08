
`include "defines.v"

module pc_reg(input	wire										clk,
              input wire										rst,
              input wire branch_flag_i,//是否发生转移
              input wire[`RegBus] branch_target_address_i,//转移到目标地址
              output reg[`InstAddrBus]			pc,               //指令地址
              output reg ce);

always @ (posedge clk) begin
    /*芯片使能关闭后，下一个时钟周期指令地????0*/
    if (ce == `ChipDisable) begin
        pc <= 32'h00000000;
    end
    else  begin
        /*有转移指令时，下??条指令地??为转移的目标地址，否则指令地??顺序+4*/
        if (branch_flag_i == `Branch) begin
            pc <= branch_target_address_i;
        end
        else begin
            pc <= pc + 4'h4;
        end
    end
end

always @ (posedge clk) begin
    /*reset信号存在时，芯片使能关闭*/
    if (rst == `RstEnable) begin
        ce <= `ChipDisable;
    end else begin
        ce <= `ChipEnable;
    end
end

endmodule

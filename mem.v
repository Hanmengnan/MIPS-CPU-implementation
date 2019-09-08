
`include "defines.v"

module mem(input wire										rst,
           input wire[`RegAddrBus] wd_i,
           input wire wreg_i,
           input wire[`RegBus]					 wdata_i,
           input wire[`AluOpBus] aluop_i,
           input wire[`RegBus] mem_addr_i,
           input wire[`RegBus] reg2_i,
           input wire[`RegBus] mem_data_i,

           output reg[`RegAddrBus] wd_o,
           output reg wreg_o,
           output reg[`RegBus]					 wdata_o,
           output reg[`RegBus] mem_addr_o,
           output wire		 mem_we_o,
           output reg[3:0] mem_sel_o,
           output reg[`RegBus] mem_data_o,
           output reg mem_ce_o);

reg                   mem_we;

assign mem_we_o = mem_we ;

always @ (*) begin
    if (rst == `RstEnable) begin
        wd_o       <= `NOPRegAddr;
        wreg_o     <= `WriteDisable;
        wdata_o    <= `ZeroWord;
        mem_addr_o <= `ZeroWord;
        mem_we     <= `WriteDisable;
        mem_sel_o  <= 4'b0000;
        mem_data_o <= `ZeroWord;
        mem_ce_o   <= `ChipDisable;
    end
    else begin
        wd_o       <= wd_i;
        wreg_o     <= wreg_i;
        wdata_o    <= wdata_i;
        mem_we     <= `WriteDisable;
        mem_addr_o <= `ZeroWord;
        mem_sel_o  <= 4'b1111;
        mem_ce_o   <= `ChipDisable;
        case (aluop_i)

            `EXE_LW_OP:		begin
                mem_addr_o <= mem_addr_i;
                mem_we     <= `WriteDisable;
                wdata_o    <= mem_data_i;
                mem_sel_o  <= 4'b1111;
                mem_ce_o   <= `ChipEnable;
            end

            `EXE_SW_OP:		begin
                mem_addr_o <= mem_addr_i;
                mem_we     <= `WriteEnable;
                mem_data_o <= reg2_i;
                mem_sel_o  <= 4'b1111;
                mem_ce_o   <= `ChipEnable;
            end
            default:		begin
            end
        endcase
    end    //if
end      //always


endmodule

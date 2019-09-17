`include "defines.v"

module regfile(input wire clk,
    input wire rst,
    //input [4:0]reg_p,
    input wire we,
    input wire [`RegAddrBus] waddr,
    input wire [`RegBus] wdata,
    input wire re1,
    input wire [`RegAddrBus] raddr1,
    output reg [`RegBus] rdata1,
    input wire re2,
    input wire [`RegAddrBus] raddr2,
    output reg [`RegBus] rdata2
    //output reg [`RegBus]reg_data
);

    reg [`RegBus] regs [0:`RegNum-1];

    always @(posedge clk) begin
        /*дָ???*/
        if (rst == `RstDisable) begin
            if ((we == `WriteEnable) && (waddr != `RegNumLog2'h0)) begin
                /*дʹ�ܣ����ҵ�ַ��Ϊ0*/
                regs[waddr] <= wdata;
            end
        end
    end

    always @(*) begin
        if (rst == `RstEnable) begin
            rdata1 <= `ZeroWord;
        end
        else if (raddr1 == `RegNumLog2'h0) begin
            rdata1 <= `ZeroWord;
        end
        else if ((raddr1 == waddr) && (we == `WriteEnable) && (re1 == `ReadEnable)) begin
            /*��дͬһ��ַ��ֱ�Ӷ�???*/
            rdata1 <= wdata;
        end
        else if (re1 == `ReadEnable) begin
            /*��ָ???*/
            rdata1 <= regs[raddr1];
        end
        else begin
            rdata1 <= `ZeroWord;
        end
    end

    always @(*) begin
        if (rst == `RstEnable) begin
            rdata2 <= `ZeroWord;
        end
        else if (raddr2 == `RegNumLog2'h0) begin
            rdata2 <= `ZeroWord;
        end
        else if ((raddr2 == waddr) && (we == `WriteEnable) && (re2 == `ReadEnable)) begin
            rdata2 <= wdata;
        end
        else if (re2 == `ReadEnable) begin
            rdata2 <= regs[raddr2];
        end
        else begin
            rdata2 <= `ZeroWord;
        end
    end

endmodule

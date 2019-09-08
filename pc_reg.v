
`include "defines.v"

module pc_reg(input	wire										clk,
              input wire										rst,
              input wire branch_flag_i,//�Ƿ���ת��
              input wire[`RegBus] branch_target_address_i,//ת�Ƶ�Ŀ���ַ
              output reg[`InstAddrBus]			pc,               //ָ���ַ
              output reg ce);

always @ (posedge clk) begin
    /*оƬʹ�ܹرպ���һ��ʱ������ָ���????0*/
    if (ce == `ChipDisable) begin
        pc <= 32'h00000000;
    end
    else  begin
        /*��ת��ָ��ʱ����??��ָ���??Ϊת�Ƶ�Ŀ���ַ������ָ���??˳��+4*/
        if (branch_flag_i == `Branch) begin
            pc <= branch_target_address_i;
        end
        else begin
            pc <= pc + 4'h4;
        end
    end
end

always @ (posedge clk) begin
    /*reset�źŴ���ʱ��оƬʹ�ܹر�*/
    if (rst == `RstEnable) begin
        ce <= `ChipDisable;
    end else begin
        ce <= `ChipEnable;
    end
end

endmodule

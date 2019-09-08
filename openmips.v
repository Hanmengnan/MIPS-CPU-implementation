
`include "defines.v"

module openmips(input	wire										clk,
                input wire										rst,
                //input wire next,

                input wire[`RegBus] rom_data_i,
                output wire[`RegBus] rom_addr_o,
                output wire rom_ce_o,
                input wire[`RegBus] ram_data_i,
                output wire[`RegBus] ram_addr_o,
                output wire[`RegBus] ram_data_o,
                output wire ram_we_o,
                //output [2:0]del,
                //output [7:0]ledag,
                output wire[3:0] ram_sel_o,
                output wire[3:0] ram_ce_o);

wire[`InstAddrBus] pc;
wire[`InstAddrBus] id_pc_i;
wire[`InstBus] id_inst_i;

//��������׶�IDģ��������ID/EXģ�������???????????
wire[`AluOpBus] id_aluop_o;
wire[`AluSelBus] id_alusel_o;
wire[`RegBus] id_reg1_o;
wire[`RegBus] id_reg2_o;
wire id_wreg_o;
wire[`RegAddrBus] id_wd_o;
wire id_is_in_delayslot_o;
wire[`RegBus] id_link_address_o;
wire[`RegBus] id_inst_o;

//����ID/EXģ��������ִ�н׶�EXģ�������???????????
wire[`AluOpBus] ex_aluop_i;
wire[`AluSelBus] ex_alusel_i;
wire[`RegBus] ex_reg1_i;
wire[`RegBus] ex_reg2_i;
wire ex_wreg_i;
wire[`RegAddrBus] ex_wd_i;
wire ex_is_in_delayslot_i;
wire[`RegBus] ex_link_address_i;
wire[`RegBus] ex_inst_i;

//����ִ�н׶�EXģ��������EX/MEMģ�������???????????
wire ex_wreg_o;
wire[`RegAddrBus] ex_wd_o;
wire[`RegBus] ex_wdata_o;

wire[`AluOpBus] ex_aluop_o;
wire[`RegBus] ex_mem_addr_o;
wire[`RegBus] ex_reg1_o;
wire[`RegBus] ex_reg2_o;

//����EX/MEMģ��������ô�׶�MEMģ�������???????????
wire mem_wreg_i;
wire[`RegAddrBus] mem_wd_i;
wire[`RegBus] mem_wdata_i;

wire[`AluOpBus] mem_aluop_i;
wire[`RegBus] mem_mem_addr_i;
wire[`RegBus] mem_reg1_i;
wire[`RegBus] mem_reg2_i;

//���ӷô�׶�MEMģ��������MEM/WBģ�������???????????
wire mem_wreg_o;
wire[`RegAddrBus] mem_wd_o;
wire[`RegBus] mem_wdata_o;

//����MEM/WBģ���������д�׶ε�����???????????
wire wb_wreg_i;
wire[`RegAddrBus] wb_wd_i;
wire[`RegBus] wb_wdata_i;

//��������׶�IDģ����ͨ�üĴ���Regfileģ��
wire reg1_read;
wire reg2_read;
wire[`RegBus] reg1_data;
wire[`RegBus] reg2_data;
wire[`RegAddrBus] reg1_addr;
wire[`RegAddrBus] reg2_addr;


wire is_in_delayslot_i;
wire is_in_delayslot_o;
wire next_inst_in_delayslot_o;
wire id_branch_flag_o;
wire[`RegBus] branch_target_address;

//light 
wire [31:0] reg_data;
wire p;

//pc_reg����
pc_reg pc_reg0(
.clk(clk),
.rst(rst),
.branch_flag_i(id_branch_flag_o),
.branch_target_address_i(branch_target_address),
.pc(pc),
.ce(rom_ce_o)

);

assign rom_addr_o = pc;

//IF/IDģ������
if_id if_id0(
.clk(clk),
.rst(rst),
.if_pc(pc),
.if_inst(rom_data_i),
.id_pc(id_pc_i),
.id_inst(id_inst_i)
);

//����׶�IDģ��
id id0(
.rst(rst),
.pc_i(id_pc_i),
.inst_i(id_inst_i),

.ex_aluop_i(ex_aluop_o),

.reg1_data_i(reg1_data),
.reg2_data_i(reg2_data),

//����ִ�н׶ε�ָ��Ҫд���Ŀ�ļĴ������?
.ex_wreg_i(ex_wreg_o),
.ex_wdata_i(ex_wdata_o),
.ex_wd_i(ex_wd_o),

//���ڷô�׶ε�ָ��Ҫд���Ŀ�ļĴ�����Ϣ
.mem_wreg_i(mem_wreg_o),
.mem_wdata_i(mem_wdata_o),
.mem_wd_i(mem_wd_o),

//�͵�regfile����Ϣ
.reg1_read_o(reg1_read),
.reg2_read_o(reg2_read),

.reg1_addr_o(reg1_addr),
.reg2_addr_o(reg2_addr),

//�͵�ID/EXģ������?
.aluop_o(id_aluop_o),
.alusel_o(id_alusel_o),
.reg1_o(id_reg1_o),
.reg2_o(id_reg2_o),
.wd_o(id_wd_o),
.wreg_o(id_wreg_o),
.inst_o(id_inst_o),

.branch_flag_o(id_branch_flag_o),
.branch_target_address_o(branch_target_address),
.link_addr_o(id_link_address_o)
);

//ͨ�üĴ���Regfile����
regfile regfile1(
.clk (clk),
.rst (rst),
//.reg_p(p),
.we	(wb_wreg_i),
.waddr (wb_wd_i),
.wdata (wb_wdata_i),
.re1 (reg1_read),
.raddr1 (reg1_addr),
.rdata1 (reg1_data),
.re2 (reg2_read),
.raddr2 (reg2_addr),
.rdata2 (reg2_data)
//.reg_data(reg_data)
);

// light light1(
//     .clk(clk),
//     .next(next),
//     .data(reg_data),
//     .p(p),
//     .del(del),
//     .ledag(ledag)


// );
//ID/EXģ��
id_ex id_ex0(
.clk(clk),
.rst(rst),

//������׶�IDģ�鴫�ݵ���Ϣ
.id_aluop(id_aluop_o),
.id_alusel(id_alusel_o),
.id_reg1(id_reg1_o),
.id_reg2(id_reg2_o),
.id_wd(id_wd_o),
.id_wreg(id_wreg_o),
.id_link_address(id_link_address_o),
.id_inst(id_inst_o),

//���ݵ�ִ�н׶�EXģ������?
.ex_aluop(ex_aluop_i),
.ex_alusel(ex_alusel_i),
.ex_reg1(ex_reg1_i),
.ex_reg2(ex_reg2_i),
.ex_wd(ex_wd_i),
.ex_wreg(ex_wreg_i),
.ex_link_address(ex_link_address_i),
.ex_inst(ex_inst_i)
);

//EXģ��
ex ex0(
.rst(rst),

//�͵�ִ�н׶�EXģ������?
.aluop_i(ex_aluop_i),
.alusel_i(ex_alusel_i),
.reg1_i(ex_reg1_i),
.reg2_i(ex_reg2_i),
.wd_i(ex_wd_i),
.wreg_i(ex_wreg_i),
.inst_i(ex_inst_i),
.link_address_i(ex_link_address_i),

//EXģ��������EX/MEMģ����Ϣ
.wd_o(ex_wd_o),
.wreg_o(ex_wreg_o),
.wdata_o(ex_wdata_o),
.aluop_o(ex_aluop_o),
.mem_addr_o(ex_mem_addr_o),
.reg2_o(ex_reg2_o)
);

//EX/MEMģ��
ex_mem ex_mem0(
.clk(clk),
.rst(rst),

//����ִ�н׶�EXģ������?
.ex_wd(ex_wd_o),
.ex_wreg(ex_wreg_o),
.ex_wdata(ex_wdata_o),
.ex_aluop(ex_aluop_o),
.ex_mem_addr(ex_mem_addr_o),
.ex_reg2(ex_reg2_o),
//�͵��ô�׶�MEMģ������?
.mem_wd(mem_wd_i),
.mem_wreg(mem_wreg_i),
.mem_wdata(mem_wdata_i),
.mem_aluop(mem_aluop_i),
.mem_mem_addr(mem_mem_addr_i),
.mem_reg2(mem_reg2_i)
);

//MEMģ������
mem mem0(
.rst(rst),

//����EX/MEMģ������?
.wd_i(mem_wd_i),
.wreg_i(mem_wreg_i),
.wdata_i(mem_wdata_i),
.aluop_i(mem_aluop_i),
.mem_addr_i(mem_mem_addr_i),
.reg2_i(mem_reg2_i),

//����memory����Ϣ
.mem_data_i(ram_data_i),

//�͵�MEM/WBģ������?
.wd_o(mem_wd_o),
.wreg_o(mem_wreg_o),
.wdata_o(mem_wdata_o),
//�͵�memory����Ϣ
.mem_addr_o(ram_addr_o),
.mem_we_o(ram_we_o),
.mem_sel_o(ram_sel_o),
.mem_data_o(ram_data_o),
.mem_ce_o(ram_ce_o)
);

//MEM/WBģ��
mem_wb mem_wb0(
.clk(clk),
.rst(rst),

//���Էô�׶�MEMģ������?
.mem_wd(mem_wd_o),
.mem_wreg(mem_wreg_o),
.mem_wdata(mem_wdata_o),
//�͵���д�׶ε���Ϣ
.wb_wd(wb_wd_i),
.wb_wreg(wb_wreg_i),
.wb_wdata(wb_wdata_i)
);
endmodule

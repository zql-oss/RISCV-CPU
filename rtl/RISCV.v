`timescale 1ns / 1ps


`include "defines.v"


// riscv��������ģ��
module RISCV(

    input   wire                        clk                 ,
    input   wire                        rst_n               ,
    
    input   wire                        rib_hold_flag_i     , // rib���ߴ�������ˮ����ͣ��־
    input   wire[7:0]                   int_flag_i          , // �ⲿ�豸�жϱ�־
    
    // ȡָ���
    output  wire[31:0]                  pc_o                , // ����rom��ָ���ַ
    input   wire[31:0]                  ins_i               , // rom���ݵ�ַ������ָ��
                                       
    // �ô����
    output  wire                        mem_wr_rib_req_o    , // д���������ź�
    output  wire                        mem_wr_en_o         , // дʹ��
    output  wire[31:0]                  mem_wr_addr_o       , // д��ַ
    output  wire[31:0]                  mem_wr_data_o       , // д����
    output  wire                        mem_rd_rib_req_o    , // �����������ź�
    output  wire[31:0]                  mem_rd_addr_o       , // ����ַ
    input   wire[31:0]                  mem_rd_data_i         // ������
    
    );
    
    
    // IF��Ԫ����ź�
    wire[31:0]     if_ins_o;
    wire[31:0]     if_ins_addr_o;
    wire[31:0]     if_pc_o;
    wire[7 :0]     if_int_flag_o;
    
    // ID��Ԫ����ź�
    wire[31:0]     id_ins_o;
    wire[31:0]     id_ins_addr_o;
    wire[6:0]      id_opcode_o;
    wire[2:0]      id_funct3_o;
    wire[6:0]      id_funct7_o;
    wire[4:0]      id_reg1_rd_addr_o;
    wire[4:0]      id_reg2_rd_addr_o;
    wire[31:0]     id_reg1_rd_data_o;
    wire[31:0]     id_reg2_rd_data_o;
    wire[4:0]      id_reg_wr_addr_o;
    wire[31:0]     id_imm_o;
    wire[31:0]     id_csr_rw_addr_o;
    wire[31:0]     id_csr_rd_addr_o;
    wire[31:0]     id_csr_zimm_o;
    wire[31:0]     id_csr_rd_data_o;
    
    // RF��Ԫ����ź�
    wire[31:0]     rf_reg1_rd_data_o;
    wire[31:0]     rf_reg2_rd_data_o;
    wire[31:0]     rf_csr_rd_data_o;
    wire[31:0]     rf_clint_rd_data_o;
    wire[31:0]     rf_clint_csr_mtvec;  
    wire[31:0]     rf_clint_csr_mepc;   
    wire[31:0]     rf_clint_csr_mstatus;
    wire[1:0]      rf_privileg_o;
    
    // clint ģ������ź�
    wire           clint_wr_en_o;    
    wire[31:0]     clint_wr_addr_o;  
    wire[31:0]     clint_wr_data_o;  
    wire[31:0]     clint_rd_addr_o;  
    wire           clint_busy_o;
    wire[31:0]     clint_int_addr_o;
    wire           clint_int_assert_o;
    wire           clint_wr_privilege_en_o;
    wire[1:0]      clint_wr_privilege_o; 
    
    // EX��Ԫ����ź�
    wire           ex_reg_wr_en_o;
    wire[4:0]      ex_reg_wr_addr_o;
    wire[31:0]     ex_reg_wr_data_o;
    wire           ex_jump_flag_o;
    wire[31:0]     ex_jump_addr_o;
    wire[2:0]      ex_hold_flag_o;
    wire           ex_csr_wr_en_o;
    wire[31:0]     ex_csr_wr_addr_o;
    wire[31:0]     ex_csr_wr_data_o;
    wire           ex_div_busy_o; 
    wire           ex_div_req_o;  
    

    // ȡָ��Ԫ����
    IF_UNIT INST_IF_UNIT(
        .clk                 (clk),
        .rst_n               (rst_n),
        .hold_flag_i         (ex_hold_flag_o),
        .jump_flag_i         (ex_jump_flag_o),
        .jump_addr_i         (ex_jump_addr_o),
        .int_flag_i          (int_flag_i),
        .int_flag_o          (if_int_flag_o),
        .ins_o               (if_ins_o),      
        .ins_addr_o          (if_ins_addr_o), 
        .pc_o                (pc_o),          
        .ins_i               (ins_i)
    );
    
    // ���뵥Ԫ����
    ID_UNIT INST_ID_UNIT(
        .clk                 (clk),
        .rst_n               (rst_n),
        .hold_flag_i         (ex_hold_flag_o),
        .ins_i               (if_ins_o), 
        .ins_addr_i          (if_ins_addr_o), 
        .reg1_rd_data_i      (rf_reg1_rd_data_o), 
        .reg2_rd_data_i      (rf_reg2_rd_data_o),
        .reg1_rd_addr_o      (id_reg1_rd_addr_o), 
        .reg2_rd_addr_o      (id_reg2_rd_addr_o),
        .reg1_rd_data_o      (id_reg1_rd_data_o), 
        .reg2_rd_data_o      (id_reg2_rd_data_o),
        .reg_wr_addr_o       (id_reg_wr_addr_o),
        .ins_o               (id_ins_o),
        .ins_addr_o          (id_ins_addr_o), 
        .imm_o               (id_imm_o),
        .csr_rd_data_i       (rf_csr_rd_data_o),
        .csr_rd_addr_o       (id_csr_rd_addr_o),
        .csr_rw_addr_o       (id_csr_rw_addr_o),
        .csr_zimm_o          (id_csr_zimm_o),
        .csr_rd_data_o       (id_csr_rd_data_o),
        .mem_rd_rib_req_o    (mem_rd_rib_req_o),
        .mem_rd_addr_o       (mem_rd_addr_o)
    );
    
    // ͨ�üĴ���ģ������
    RF_UNIT INST_RF_UNIT(
        .clk                 (clk),
        .rst_n               (rst_n),
        .wr_en_i             (ex_reg_wr_en_o), 
        .wr_addr_i           (ex_reg_wr_addr_o), 
        .wr_data_i           (ex_reg_wr_data_o), 
        .reg1_rd_addr_i      (id_reg1_rd_addr_o), 
        .reg2_rd_addr_i      (id_reg2_rd_addr_o), 
        .reg1_rd_data_o      (rf_reg1_rd_data_o), 
        .reg2_rd_data_o      (rf_reg2_rd_data_o), 
        .csr_wr_en_i         (ex_csr_wr_en_o),
        .csr_wr_addr_i       (ex_csr_wr_addr_o),
        .csr_wr_data_i       (ex_csr_wr_data_o),
        .csr_rd_addr_i       (id_csr_rd_addr_o),
        .csr_rd_data_o       (rf_csr_rd_data_o),
        .clint_wr_en_i       (clint_wr_en_o),
        .clint_wr_addr_i     (clint_wr_addr_o),
        .clint_wr_data_i     (clint_wr_data_o),
        .clint_rd_addr_i     (clint_rd_addr_o),
        .clint_rd_data_o     (rf_clint_rd_data_o),
        .wr_privilege_en_i   (clint_wr_privilege_en_o),
        .wr_privilege_i      (clint_wr_privilege_o),
        .privileg_o          (rf_privileg_o),
        .clint_csr_mtvec     (rf_clint_csr_mtvec),
        .clint_csr_mepc      (rf_clint_csr_mepc),
        .clint_csr_mstatus   (rf_clint_csr_mstatus)
    );
    
    // �ж�ģ������
    clint u_clint(
        .clk                 (clk),
        .rst_n               (rst_n),
        .ins_i               (if_ins_o),     
        .ins_addr_i          (if_ins_addr_o), 
        .jump_flag_i         (ex_jump_flag_o),
        .jump_addr_i         (ex_jump_addr_o),
        .div_req_i           (ex_div_req_o), 
        .div_busy_i          (ex_div_busy_o), 
        .wr_en_o             (clint_wr_en_o), 
        .wr_addr_o           (clint_wr_addr_o), 
        .wr_data_o           (clint_wr_data_o), 
        .rd_addr_o           (clint_rd_addr_o),
        .rd_data_i           (rf_clint_rd_data_o),
        .csr_mtvec           (rf_clint_csr_mtvec), 
        .csr_mepc            (rf_clint_csr_mepc), 
        .csr_mstatus         (rf_clint_csr_mstatus), 
        .wr_privilege_en_o   (clint_wr_privilege_en_o),
        .wr_privilege_o      (clint_wr_privilege_o),
        .privileg_i          (rf_privileg_o),
        .int_flag_i          (if_int_flag_o), 
        .clint_busy_o        (clint_busy_o), 
        .int_addr_o          (clint_int_addr_o), 
        .int_assert_o        (clint_int_assert_o)  
    );
    
    // ִ�е�Ԫ����
    EX_UNIT INST_EX_UNIT(
        .clk                 (clk),
        .rst_n               (rst_n),  
        .ins_i               (id_ins_o),
        .ins_addr_i          (id_ins_addr_o), 
        .imm_i               (id_imm_o),  
        .csr_rd_data_i       (id_csr_rd_data_o),
        .csr_rw_addr_i       (id_csr_rw_addr_o),
        .csr_zimm_i          (id_csr_zimm_o),
        .csr_wr_en_o         (ex_csr_wr_en_o),
        .csr_wr_addr_o       (ex_csr_wr_addr_o),
        .csr_wr_data_o       (ex_csr_wr_data_o),
        .reg1_rd_data_i      (id_reg1_rd_data_o), 
        .reg2_rd_data_i      (id_reg2_rd_data_o),
        .reg_wr_addr_i       (id_reg_wr_addr_o),
        .reg_wr_en_o         (ex_reg_wr_en_o),
        .reg_wr_addr_o       (ex_reg_wr_addr_o),
        .reg_wr_data_o       (ex_reg_wr_data_o),
        .rib_hold_flag_i     (rib_hold_flag_i),
        .jump_flag_o         (ex_jump_flag_o),
        .jump_addr_o         (ex_jump_addr_o),
        .hold_flag_o         (ex_hold_flag_o),
        .mem_rd_addr_i       (mem_rd_addr_o),
        .mem_rd_data_i       (mem_rd_data_i),
        .mem_wr_rib_req_o    (mem_wr_rib_req_o),
        .mem_wr_en_o         (mem_wr_en_o), 
        .mem_wr_addr_o       (mem_wr_addr_o), 
        .mem_wr_data_o       (mem_wr_data_o),
        .clint_busy_i        (clint_busy_o),
        .int_addr_i          (clint_int_addr_o),
        .int_assert_i        (clint_int_assert_o),
        .div_busy_o          (ex_div_busy_o),
        .div_req_o           (ex_div_req_o)

    );
    
endmodule
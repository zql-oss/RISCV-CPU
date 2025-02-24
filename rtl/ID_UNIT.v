`timescale 1ns / 1ps

`include "defines.v"


// 译码单元
module ID_UNIT(

    input   wire          clk               ,
    input   wire          rst_n             ,
                                            
    input   wire[2:0]     hold_flag_i       ,
     
    // from IF_UNIT
    input   wire[31:0]    ins_i             , 
    input   wire[31:0]    ins_addr_i        , 
    
    // from RF_UNIT               
    input   wire[31:0]    reg1_rd_data_i    , 
    input   wire[31:0]    reg2_rd_data_i    , 
    // to RF_UNIT
    output  wire[4:0]     reg1_rd_addr_o    , 
    output  wire[4:0]     reg2_rd_addr_o    , 
    // to EX_UNIT
    output  wire[31:0]    reg1_rd_data_o    , 
    output  wire[31:0]    reg2_rd_data_o    ,                         
    output  wire[4:0]     reg_wr_addr_o     ,
    
    // to EX_UNIT
    output  wire[31:0]    ins_o             ,     
    output  wire[31:0]    ins_addr_o        ,                                      
    output  wire[31:0]    imm_o             ,
    
    // from RF_UNIT
    input   wire[31:0]    csr_rd_data_i     ,
    // to RF_UNIT
    output  wire[31:0]    csr_rd_addr_o     ,
    // to EX_UNIT
    output  wire[31:0]    csr_rw_addr_o     ,
    output  wire[31:0]    csr_zimm_o        ,
    output  wire[31:0]    csr_rd_data_o     ,
    
    // 如果当前为访存指令，则需要在译码阶段发出访存请求
    output  wire          mem_rd_rib_req_o  ,
    output  wire[31:0]    mem_rd_addr_o       
    
    );
    
    
    wire[31:0]    ins;
    wire[4:0]     reg_wr_addr;
    wire[31:0]    imm;
    wire          mem_rd_flag;
    wire[31:0]    csr_rw_addr;
    wire[31:0]    csr_zimm   ;
    
    assign csr_rd_addr_o = csr_rw_addr;

        // 指令译码模块例化
    id u_id(
        .clk                (clk),
        .rst_n              (rst_n),
        .ins_i              (ins_i), 
        .ins_addr_i         (ins_addr_i),
        .ins_o              (ins), 
        .reg1_rd_addr_o     (reg1_rd_addr_o), 
        .reg2_rd_addr_o     (reg2_rd_addr_o),
        .reg_wr_addr_o      (reg_wr_addr),
        .imm_o              (imm),
        .mem_rd_flag_o      (mem_rd_flag),
        .csr_rw_addr_o      (csr_rw_addr),
        .csr_zimm_o         (csr_zimm)
    );
    
    // 将传给EX单元的内容打一拍
    id_ex u_id_ex(
        .clk                (clk),
        .rst_n              (rst_n),
        .hold_flag_i        (hold_flag_i),
        .mem_rd_flag_i      (mem_rd_flag),
        .ins_i              (ins), 
        .ins_addr_i         (ins_addr_i),
        .ins_o              (ins_o), 
        .reg1_rd_data_i     (reg1_rd_data_i), 
        .reg2_rd_data_i     (reg2_rd_data_i),
        .reg_wr_addr_i      (reg_wr_addr),
        .imm_i              (imm),
        .csr_rd_data_i      (csr_rd_data_i),
        .csr_rw_addr_i      (csr_rw_addr),
        .csr_zimm_i         (csr_zimm),
        .ins_addr_o         (ins_addr_o), 
        .reg1_rd_data_o     (reg1_rd_data_o), 
        .reg2_rd_data_o     (reg2_rd_data_o),
        .reg_wr_addr_o      (reg_wr_addr_o),
        .imm_o              (imm_o),
        .csr_rd_data_o      (csr_rd_data_o),
        .csr_rw_addr_o      (csr_rw_addr_o),
        .csr_zimm_o         (csr_zimm_o),
        .mem_rd_rib_req_o   (mem_rd_rib_req_o),
        .mem_rd_addr_o      (mem_rd_addr_o)
    );
    
endmodule
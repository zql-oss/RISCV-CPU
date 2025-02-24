`timescale 1ns / 1ps

`include "defines.v"

// 将译码结果打一拍后向EX模块传递


module id_ex(

    input   wire           clk               ,
    input   wire           rst_n             ,
                                                       
    input   wire[2:0 ]     hold_flag_i       ,
    input   wire           mem_rd_flag_i     ,
    
    input   wire[31:0]     ins_i             , 
    input   wire[31:0]     ins_addr_i        ,
    input   wire[31:0]     reg1_rd_data_i    , 
    input   wire[31:0]     reg2_rd_data_i    ,
    input   wire[4:0 ]     reg_wr_addr_i     ,
    input   wire[31:0]     imm_i             ,
    
    input   wire[31:0]     csr_rd_data_i     ,
    input   wire[31:0]     csr_rw_addr_i     ,
    input   wire[31:0]     csr_zimm_i        ,    
    
    output  reg [31:0]     ins_o             ,      
    output  reg [31:0]     ins_addr_o        ,
    output  reg [31:0]     reg1_rd_data_o    , 
    output  reg [31:0]     reg2_rd_data_o    ,    
    output  reg [4:0 ]     reg_wr_addr_o     ,
    output  reg [31:0]     imm_o             ,
    
    output  reg [31:0]     csr_rd_data_o     ,
    output  reg [31:0]     csr_rw_addr_o     ,
    output  reg [31:0]     csr_zimm_o        ,
                                                       
    output  reg            mem_rd_rib_req_o  ,
    output  reg [31:0]     mem_rd_addr_o       
    
    );
    
    always @ (posedge clk or negedge rst_n) begin
        if(rst_n==1'b0) begin
            ins_o <= 32'h0000_0013;// 空操作指令，NOP被编码为ADDI x0,x0,0
            ins_addr_o <= 32'h0;
            reg1_rd_data_o <= 32'h0;
            reg2_rd_data_o <= 32'h0;   
            reg_wr_addr_o <= 5'h0;   
            imm_o <= 32'h0;
            csr_rw_addr_o <= 32'h0;
            csr_zimm_o <= 32'h0;
            csr_rd_data_o <= 32'h0;
        end
        else if(hold_flag_i >= 3'b011) begin
            ins_o <= 32'h0000_0013;// 空操作指令，NOP被编码为ADDI x0,x0,0
            ins_addr_o <= 32'h0;
            reg1_rd_data_o <= 32'h0;
            reg2_rd_data_o <= 32'h0;   
            reg_wr_addr_o <= 5'h0;   
            imm_o <= 32'h0;   
            csr_rw_addr_o <= 32'h0;
            csr_zimm_o <= 32'h0;
            csr_rd_data_o <= 32'h0;
        end
         else begin
            ins_o <= ins_i;
            ins_addr_o <= ins_addr_i;
            reg1_rd_data_o <= reg1_rd_data_i;
            reg2_rd_data_o <= reg2_rd_data_i;
            reg_wr_addr_o <= reg_wr_addr_i;
            imm_o <= imm_i;
            csr_rw_addr_o <= csr_rw_addr_i;
            csr_zimm_o <= csr_zimm_i;
            csr_rd_data_o <= csr_rd_data_i;
        end
    end
    
    
     always @ (*) begin
        if(mem_rd_flag_i == 1'b1) 
        begin
            mem_rd_rib_req_o = 1'b1;
            mem_rd_addr_o = $signed(reg1_rd_data_i) + $signed(imm_i);
        end
        else begin
            mem_rd_rib_req_o = 1'b0;
            mem_rd_addr_o = 32'h0;
        end
    end
    
endmodule
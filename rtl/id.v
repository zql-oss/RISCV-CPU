`timescale 1ns / 1ps


`include "defines.v"

//指令译码模块

 module id
  ( 
     input   wire        clk            ,
     input   wire        rst_n          ,
                                        
     input   wire [31:0] ins_i          ,
     input   wire [31:0] ins_addr_i     , 
                                        
     output  wire [31:0] ins_o          , 
     
     // 传给RF模块的寄存器地址，用于取数据
     output  reg  [31:0] reg1_rd_addr_o , 
     output  reg  [31:0] reg2_rd_addr_o ,

     // 写寄存器地址
     output  reg  [31:0] reg_wr_addr_o  ,
     
     // 立即数
     output  reg  [31:0] imm_o          ,
     // 内存读取标志位
     output  reg         mem_rd_flag_o  ,
    
     // csr指令相关参数
     output  reg  [31:0] csr_rw_addr_o  ,
     output  reg  [31:0] csr_zimm_o

  ); 

     assign ins_o    = ins_i;
     
    // R类指令涉及到的三个寄存器
    wire[4:0]       rs1;
    wire[4:0]       rs2;
    wire[4:0]       rd;
    assign rs1 = ins_i[19:15];
    assign rs2 = ins_i[24:20];
    assign rd  = ins_i[11:7 ];
    
    
    // R类指令可以根据下列三个参数确定
    wire [6:0]      opcode;
    wire [2:0]      funct3;
    //wire [6:0]      funct7;
    assign opcode = ins_i[6:0];
    assign funct3 = ins_i[14:12];
    //assign funct7 = ins_i[31:25];
    
    
    // 开始译码
    always @ (*) begin
        mem_rd_flag_o = 1'b0 ;
        csr_rw_addr_o = 32'h0;
        csr_zimm_o    = 32'h0;
        
        case(opcode) 
            `INS_TYPE_I: begin
                reg1_rd_addr_o = rs1;
                reg2_rd_addr_o = 5'h0;
                reg_wr_addr_o = rd;
                case(funct3)
                    `INS_ADDI,`INS_SLTI,`INS_SLTIU,`INS_XORI,`INS_ORI,`INS_ANDI: begin
                        imm_o = {{20{ins_i[31]}}, ins_i[31:20]}; // 符号位拓展
                    end
                    `INS_SLLI,`INS_SRLI_SRAI: begin
                        imm_o = {{27{1'b0}}, ins_i[24:20]};
                    end
                endcase
            end
            `INS_TYPE_R_M: begin
                reg1_rd_addr_o = rs1;
                reg2_rd_addr_o = rs2;
                reg_wr_addr_o = rd;
                imm_o = 32'h0;
            end   
            `INS_LUI,`INS_AUIPC: begin
                reg1_rd_addr_o = 5'h0;
                reg2_rd_addr_o = 5'h0;
                reg_wr_addr_o = rd;
                imm_o = {ins_i[31:12], {12{1'b0}}};
            end
            `INS_JAL: begin
                reg1_rd_addr_o = 5'h0;
                reg2_rd_addr_o = 5'h0;
                reg_wr_addr_o = rd;
                imm_o = {{12{ins_i[31]}}, ins_i[19:12], ins_i[20], ins_i[30:21], 1'b0};
            end
            `INS_JALR: begin
                reg1_rd_addr_o = rs1;
                reg2_rd_addr_o = 5'h0;
                reg_wr_addr_o = rd;
                imm_o = {{20{ins_i[31]}}, ins_i[31:20]}; // 因为立即数是补码，所以需要符号位拓展
            end
            `INS_TYPE_BRANCH: begin
                reg1_rd_addr_o = rs1;
                reg2_rd_addr_o = rs2;
                reg_wr_addr_o = 5'h0;
                imm_o = {{20{ins_i[31]}}, ins_i[7], ins_i[30:25], ins_i[11:8], 1'b0}; // 因为立即数是补码，所以需要符号位拓展
            end
            `INS_TYPE_SAVE: begin
                reg1_rd_addr_o = rs1;
                reg2_rd_addr_o = rs2;
                reg_wr_addr_o = 5'h0;
                imm_o = {{20{ins_i[31]}}, ins_i[31:25], ins_i[11:7]}; // 因为立即数是补码，所以需要符号位拓展
                mem_rd_flag_o = 1'b1;
            end
            `INS_TYPE_LOAD: begin
                reg1_rd_addr_o = rs1;
                reg2_rd_addr_o = 5'h0;
                reg_wr_addr_o = rd;
                imm_o = {{20{ins_i[31]}}, ins_i[31:20]}; // 因为立即数是补码，所以需要符号位拓展
                mem_rd_flag_o = 1'b1;
            end
            `INS_TYPE_CSR: begin//控制中断，异常等的寄存器
                case(funct3)
                    `INS_CSRRW,`INS_CSRRS,`INS_CSRRC: begin
                        reg1_rd_addr_o = rs1;
                        reg2_rd_addr_o = 5'h0;
                        reg_wr_addr_o = rd;
                        imm_o = 32'h0;
                        csr_rw_addr_o = {20'h0, ins_i[31:20]};
                        csr_zimm_o = 32'h0;
                    end
                    `INS_CSRRWI,`INS_CSRRSI,`INS_CSRRCI:begin
                        reg1_rd_addr_o = 5'h0;
                        reg2_rd_addr_o = 5'h0;
                        reg_wr_addr_o = rd;
                        imm_o = 32'h0;
                        csr_rw_addr_o = {20'h0, ins_i[31:20]};
                        csr_zimm_o = {27'h0, ins_i[19:15]};
                    end
                    default: begin
                        reg1_rd_addr_o = 5'h0;
                        reg2_rd_addr_o = 5'h0;
                        reg_wr_addr_o = 5'h0;
                        imm_o = 32'h0;
                        csr_rw_addr_o = 32'h0;
                        csr_zimm_o = 32'h0;
                    end
                endcase
            end
            default: begin
                reg1_rd_addr_o = 5'h0;
                reg2_rd_addr_o = 5'h0;
                reg_wr_addr_o = 5'h0;
                imm_o = 32'h0;
            end
        endcase
    end
endmodule
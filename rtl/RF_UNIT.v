`timescale 1ns / 1ps

`include "defines.v"


// 通用寄存器模块，双端口，可同时读取两个寄存器数据
module RF_UNIT(

    input   wire                    clk               ,
    input   wire                    rst_n             ,
                                                      
    // gpr读写信号                                    
    input   wire                    wr_en_i           , // 写使能
    input   wire[4:0]               wr_addr_i         , // 写地址
    input   wire[31:0]              wr_data_i         , // 写数据
    input   wire[4:0]               reg1_rd_addr_i    , // R1寄存器读地址
    input   wire[4:0]               reg2_rd_addr_i    , // R2寄存器读地址
    output  wire[31:0]              reg1_rd_data_o    , // R1寄存器读数据
    output  wire[31:0]              reg2_rd_data_o    , // R2寄存器读数据
    
    // csr读写信号    
    input   wire                    csr_wr_en_i       , // csr write enable
    input   wire[31:0]              csr_wr_addr_i     , // csr write address
    input   wire[31:0]              csr_wr_data_i     , // csr write data
    input   wire[31:0]              csr_rd_addr_i     , // csr read address
    output  wire[31:0]              csr_rd_data_o     , // csr read data
    
    // privilege_mode (特权模式) 读写信号
    input   wire                    wr_privilege_en_i , 
    input   wire[1:0]               wr_privilege_i    , 
    output  wire[1:0]               privileg_o        ,
    
    // clint (Core Local Interruptor)相关，csr读写信号
    input   wire                    clint_wr_en_i     , // clint_write enable
    input   wire[31:0]              clint_wr_addr_i   , // clint_write address
    input   wire[31:0]              clint_wr_data_i   , // clint_write data
    input   wire[31:0]              clint_rd_addr_i   , // clint_read address
    output  wire[31:0]              clint_rd_data_o   , // clint_read data
    output  wire[31:0]              clint_csr_mtvec   , // mtvec
    output  wire[31:0]              clint_csr_mepc    , // mepc
    output  wire[31:0]              clint_csr_mstatus   // mstatus
    
    );
    
    // 通用寄存器例化
    gpr u_gpr(
        .clk                 (clk),
        .rst_n               (rst_n),
        .wr_en_i             (wr_en_i), 
        .wr_addr_i           (wr_addr_i), 
        .wr_data_i           (wr_data_i), 
        .reg1_rd_addr_i      (reg1_rd_addr_i),
        .reg2_rd_addr_i      (reg2_rd_addr_i),
        .reg1_rd_data_o      (reg1_rd_data_o),
        .reg2_rd_data_o      (reg2_rd_data_o) 
    );
    
    // csr寄存器单元例化
    csr u_csr(
        .clk                  (clk),
        .rst_n                (rst_n),    
        .wr_en_i              (csr_wr_en_i),
        .wr_addr_i            (csr_wr_addr_i),
        .wr_data_i            (csr_wr_data_i),
        .rd_addr_i            (csr_rd_addr_i),
        .rd_data_o            (csr_rd_data_o),
        .clint_wr_en_i        (clint_wr_en_i),
        .clint_wr_addr_i      (clint_wr_addr_i),
        .clint_wr_data_i      (clint_wr_data_i),
        .clint_rd_addr_i      (clint_rd_addr_i),
        .clint_rd_data_o      (clint_rd_data_o),
        .wr_privilege_en_i    (wr_privilege_en_i),
        .wr_privilege_i       (wr_privilege_i),
        .privileg_o           (privileg_o),
        .clint_csr_mtvec      (clint_csr_mtvec),
        .clint_csr_mepc       (clint_csr_mepc),
        .clint_csr_mstatus    (clint_csr_mstatus) 
    );
    
endmodule
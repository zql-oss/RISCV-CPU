`timescale 1ns / 1ps

`include "defines.v"

 // 取指单元  由pc地址和if_id取指模块组成
 module IF_UNIT
  ( 
     input   wire        clk         ,
     input   wire        rst_n       ,
     // from EX_UNIT        
     input   wire [2:0]  hold_flag_i ,
     input   wire        jump_flag_i ,
     input   wire [31:0] jump_addr_i , 
     // 这是为了将中断信号经if_id阶段同步后再输出        
     input   wire [7:0]  int_flag_i  ,
     output  wire [7:0]  int_flag_o  ,             
     // to ID_UNIT        
     output  wire [31:0] ins_o       , 
     output  wire [31:0] ins_addr_o  ,
     
     output  wire [31:0] pc_o        , 
     input   wire [31:0] ins_i          

  ); 
 
    wire[31:0]       pc;
    assign pc_o = pc;


     // PC寄存器模块例化
    pc u_pc(
        .clk         (clk)        ,
        .rst_n       (rst_n)      ,
        .hold_flag_i (hold_flag_i),
        .jump_flag_i (jump_flag_i),
        .jump_addr_i (jump_addr_i),
        .pc_o        (pc)
    );
    
    // 指令寄存器模块例化
    if_id u_if_id(
        .clk         (clk)        ,
        .rst_n       (rst_n)      ,
        .hold_flag_i (hold_flag_i),
        .int_flag_i  (int_flag_i) ,
        .int_flag_o  (int_flag_o) ,
        .ins_i       (ins_i)      , 
        .ins_addr_i  (pc)         ,
        .ins_o       (ins_o)      , 
        .ins_addr_o  (ins_addr_o) 
    );
    
endmodule
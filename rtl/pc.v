`timescale 1ns / 1ps

`include "defines.v"
// pc  输出pc当前地址，可以是复位的，跳转的与暂停等，默认是+4
 module pc
  ( 
     input  wire        clk         ,
     input  wire        rst_n       ,
            
     input  wire [2:0]  hold_flag_i ,
     input  wire        jump_flag_i ,
     input  wire [31:0] jump_addr_i , 
     
     output reg  [31:0] pc_o  


  ); 
  
  always @ (posedge clk or negedge rst_n)
     begin
        //reset
        if(rst_n == 1'b0)
          begin
            pc_o <= 32'h0;
          end
        //jal
        else if (jump_flag_i == 1'b1)
          begin
            pc_o <= jump_addr_i;
          end
        //stop
        else if (hold_flag_i >= 3'b1)
          begin
            pc_o <= pc_o;
          end
        else 
          begin
            pc_o <= pc_o + 4'd4;
          end  
     end
  
  endmodule
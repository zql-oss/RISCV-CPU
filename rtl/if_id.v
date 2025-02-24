`timescale 1ns / 1ps

`include "defines.v"

// 将指令地址打一拍输出到译码模块
 module if_id
  ( 
     input   wire        clk         ,
     input   wire        rst_n       ,
             
     input   wire [2:0]  hold_flag_i ,
             
     input   wire [7:0]  int_flag_i  ,
     output  reg  [7:0]  int_flag_o  ,
             
     input   wire [31:0] ins_i       ,
     input   wire [31:0] ins_addr_i  , 
             
     output  reg  [31:0] ins_o       , 
     output  reg  [31:0] ins_addr_o   

  ); 
  
  reg[2:0]               hold_flag_reg;
  
  
  always @ (posedge clk or negedge rst_n)
     begin
       if(rst_n == 1'b0)
         begin
            hold_flag_reg <= 3'd0;       
         end
       else 
         begin
            hold_flag_reg <= hold_flag_i;
         end 
     end
     
   always @ (posedge clk or negedge rst_n)
      begin
       if(rst_n == 1'b0)
         begin
           ins_addr_o <= 32'h0;
           int_flag_o <= 8'd0 ;
         end
        else if (hold_flag_i >=3'b010)
         begin
           ins_addr_o <= 32'h0;
           int_flag_o <= 8'd0 ;
         end
        else
         begin
           ins_addr_o <= {ins_addr_i[31:2], {2'b0}};
           int_flag_o <= int_flag_i;
         end
      end
      
      // 因为从rom中读取的指令本身就会延迟一拍，所以无需延迟
    always @ (*) 
      begin
        if(hold_flag_reg >= 3'b010) 
          begin
            ins_o = 32'h0000_0013;// 空操作指令，NOP被编码为ADDI x0,x0,0
          end
        else 
          begin
            ins_o = ins_i;
          end
      end
    
endmodule
      
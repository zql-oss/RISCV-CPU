`timescale 1ns / 1ps

`include "defines.v"


// 乘法单元，简易版本
module mul(

    input      wire [31:0]    mul_data1_i         , 
    input      wire [31:0]    mul_data2_i         ,
    input      wire [2:0]     mul_op_code_i       ,
                    
    output     reg  [63:0]    mul_res_o           

    );
    
    reg [31:0]    mul_data1;
    reg [31:0]    mul_data2;
    wire[63:0]    mul_res;
    
    assign mul_res = mul_data1 * mul_data2; 
    
    always @ (*) 
    begin
        case(mul_op_code_i)
            `MUL: 
            begin
                mul_data1 = (mul_data1_i[31]) ? (~mul_data1_i + 1'b1) : mul_data1_i;
                mul_data2 = (mul_data2_i[31]) ? (~mul_data2_i + 1'b1) : mul_data2_i;
                if(mul_data1_i[31] ^ mul_data2_i[31]) 
                begin
                    mul_res_o = ~mul_res + 1'b1;
                end
                else 
                begin
                    mul_res_o = mul_res;
                end
            end
            `MULSU: 
            begin
                mul_data1 = (mul_data1_i[31]) ? (~mul_data1_i + 1'b1) : mul_data1_i;
                mul_data2 = mul_data2_i;
                if(mul_data1_i[31]) 
                begin
                    mul_res_o = ~mul_res + 1'b1;
                end
                else 
                begin
                    mul_res_o = mul_res;
                end
            end
            `MULU: 
            begin
                mul_data1 = mul_data1_i;
                mul_data2 = mul_data2_i;
                mul_res_o = mul_res;
            end
            default: 
            begin
                mul_data1 = mul_data1_i;
                mul_data2 = mul_data2_i;
                mul_res_o = mul_res;
            end
        endcase
    end
    
endmodule 
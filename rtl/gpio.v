`timescale 1ns / 1ps


`include "defines.v"


// gpio, 目前只能控制led
module gpio(

    input   wire                        clk                 ,
    input   wire                        rst_n               ,
    
    input   wire                        wr_en_i             , // gpio寄存器写使能信号
    input   wire[31:0]                  wr_addr_i           , // gpio寄存器写地址
    input   wire[31:0]                  wr_data_i           , // gpio写数据
    input   wire[31:0]                  rd_addr_i           , // gpio寄存器读地址
    output  reg [31:0]                  rd_data_o           , // gpio读数据
    
    output  wire[3:0]                   gpio_pins             // led引脚资源
    
    );
    
    
    // GPIO控制寄存器地址
    localparam GPIO_CTRL = 4'h0;
    // GPIO数据寄存器地址
    localparam GPIO_DATA = 4'h4;
    // gpio控制寄存器，目前用不上
    reg[31:0] gpio_ctrl;
    // gpio数据寄存器，设定该寄存器低4位控制led灯
    reg[31:0] gpio_data;
    assign gpio_pins = ~gpio_data[3:0];
    
    reg[31:0]        rd_addr_reg;
    
    // 读写寄存器，write before read
    always @ (posedge clk or negedge rst_n) 
    begin
        if(rst_n == 1'b0) 
        begin
            gpio_ctrl <= 32'h0;
            gpio_data <= 32'h0;
        end
        else begin
            if(wr_en_i == 1'b1) 
            begin
                case(wr_addr_i[3:0])
                    GPIO_CTRL: 
                    begin
                        gpio_ctrl <= wr_data_i;
                    end
                    GPIO_DATA: 
                    begin
                        gpio_data <= wr_data_i;
                    end
                endcase
            end
            rd_addr_reg <= rd_addr_i;
        end
    end
    
    always @ (*) 
    begin
        case(rd_addr_reg[3:0])
            GPIO_CTRL: 
            begin
                rd_data_o = gpio_ctrl;
            end
            GPIO_DATA: 
            begin
                rd_data_o = gpio_data;
            end
            default: 
            begin
                rd_data_o = 32'h0;
            end
        endcase
    end
    
endmodule
`timescale 1ns / 1ps


`include "defines.v"




// rom，双端口，一个用来取指，一个用来读数据
module rom(

    input   wire                    clk         ,
    input   wire                    rst_n       ,
    
    input   wire                    wr_en_i     , // write enable
    input   wire[31:0]              wr_addr_i   , // write address
    input   wire[31:0]              wr_data_i   , // write data
                                    
    input   wire[31:0]              rd_addr_i   , // read address
    output  wire[31:0]              rd_data_o   , // read data
                                    
    input   wire[31:0]              pc_addr_i   , // instruction read address
    output  wire[31:0]              ins_o         // instruction
    
    );
    
    reg[31:0]    rd_addr_reg;
    reg[31:0]    pc_addr_reg;
    
    // 读取需要固化在rom里面的程序，方便仿真
    initial begin
        $readmemh("../serial_utils/led_flow.inst", _rom);
    end
    
    //initial begin
    //    $readmemh("../../rt-thread/rtthread.inst", _rom);
    //end
    
    reg[31:0] _rom[0:32 - 1];                               
    
    // write before read
    always @ (posedge clk) 
    begin
        if(wr_en_i == 1'b1) 
        begin
            _rom[wr_addr_i[31:2]] <= wr_data_i;
        end
        rd_addr_reg <= rd_addr_i;
        pc_addr_reg <= pc_addr_i;
    end
    
    assign rd_data_o = _rom[rd_addr_reg[31:2]];
    assign ins_o = _rom[pc_addr_reg[31:2]];
   
endmodule

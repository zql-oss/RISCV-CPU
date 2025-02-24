`timescale 1ns / 1ps

`include "defines.v"


// ram
module ram(

    input   wire                    clk         ,
    input   wire                    rst_n       ,
    
    input   wire                    wr_en_i     , // write enable
    input   wire[31:0]              wr_addr_i   , // write address
    input   wire[31:0]              wr_data_i   , // write data
                                    
    input   wire[31:0]              rd_addr_i   , // read address
    output  wire[31:0]              rd_data_o     // read data
    
    );
    reg[31:0]    rd_addr_reg;
    
    reg[31:0] _ram[0:32 - 1];
    
    // write before read
    always @ (posedge clk) begin
        if(wr_en_i == 1'b1) begin
            _ram[wr_addr_i[31:2]] <= wr_data_i;
        end
        rd_addr_reg <= rd_addr_i;
    end
    
    assign rd_data_o = _ram[rd_addr_reg[31:2]];
    
endmodule
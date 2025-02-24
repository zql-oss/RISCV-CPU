`timescale 1ns / 1ps


// 用于将输入延迟DEPTH个时钟后输出
module delay_buffer #(
    parameter   DEPTH = 32,
    parameter   DATA_WIDTH = 16
)(
    input   wire                            clk     ,   //  Master Clock
    input   wire    [DATA_WIDTH-1:0]        data_i  ,   //  Data Input
    output  wire    [DATA_WIDTH-1:0]        data_o      //  Data Output
);

    reg [DATA_WIDTH-1:0] buffer[0:DEPTH-1];
    integer n;

    always @(posedge clk) 
    begin
        for (n = DEPTH-1; n > 0; n = n - 1) 
        begin
            buffer[n] <= buffer[n-1];
        end
        buffer[0] <= data_i;
    end

    assign  data_o = buffer[DEPTH-1];

endmodule
module rst_ctrl(  
    input  wire        clk,         // 时钟信号  
    input  wire        sys_rst_n,   // 系统复位信号，低电平有效  
    output wire        rst_n        // 处理后的复位信号，低电平有效  
);  
  
// 使用两个寄存器来同步复位信号到时钟域  
reg rst_n_sync0;  
reg rst_n_sync1;  
  
always @(posedge clk or negedge sys_rst_n) begin  
    if (!sys_rst_n) begin  
        // 当系统复位信号激活时，同步寄存器被清零  
        rst_n_sync0 <= 0;  
        rst_n_sync1 <= 0;  
    end else begin  
        // 在时钟上升沿，更新同步寄存器  
        rst_n_sync0 <= 1;  
        rst_n_sync1 <= rst_n_sync0;  
    end  
end  
  
// 输出处理后的复位信号  
assign rst_n = rst_n_sync1;  
  
endmodule
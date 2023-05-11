module Vpp
		 (
			 input clk_fs,
			 input rst_n,

			 input [data_bit_width - 1: 0]data_u,

			 output reg [data_bit_width - 1: 0]max = 1'd0,
			 output reg [data_bit_width - 1: 0]min = 1'd0,
			 output reg [data_bit_width - 1: 0]vpp = 1'd0,

			 output reg irq = 1'd0
		 );

parameter [31: 0]data_bit_width = 32'd12; //数据位宽
parameter [31: 0]points = 32'd200; //采样点数

//wire
wire [31: 0]cnt;

//reg
reg [data_bit_width - 1: 0]max_reg = 1'd0;
reg [data_bit_width - 1: 0]min_reg = 1'd0;

//计数
ClkDiv #(points,points[31:1])ClkDiv_inst
		 (
			 .clk(clk_fs) , 	// input  clk_sig
			 .rst_n(rst_n) , 	// input  rst_n_sig
			 .phase_rst(1'd0) , 	// input  phase_rst_sig
			 .clk_div() , 	// output  clk_div_sig
			 .cnt(cnt) 	// output [31:0] cnt_sig
		 );

always@(posedge clk_fs or negedge rst_n)
begin
	if (!rst_n)
	begin
		max_reg <= 1'd0;
		min_reg <= 1'd0;

		max <= 1'd0;
		min <= 1'd0;
		vpp <= 1'd0;

		irq <= 1'd0;
	end
	else
	begin
		if (cnt == points - 1'd1)
		begin
			max_reg <= data_u;
			min_reg <= data_u;

			max <= max_reg;
			min <= min_reg;
			vpp <= max_reg - min_reg;
		end
		else
		begin
			if (cnt == 1'd0)
			begin
				irq <= 1'd1;
			end
			else if (cnt == ((points - 1'd1) >> 1'd1))
			begin
				irq <= 1'd0;
			end

			max_reg <= (data_u > max_reg) ? data_u : max_reg;
			min_reg <= (data_u < min_reg) ? data_u : min_reg;
		end
	end
end

endmodule
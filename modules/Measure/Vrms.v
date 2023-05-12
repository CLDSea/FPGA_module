module Vrms
		 (
			 input clk_fs,
			 input rst_n,

			 input [data_bit_width - 1: 0]data_s,

			 output [data_bit_width - 2: 0]v_rms = 1'd0,

			 output reg irq = 1'd0
		 );

parameter [31: 0]data_bit_width = 32'd12; //数据位宽
parameter [31: 0]bit_points = 32'd8; //采样位点数

//wire
wire [31: 0]cnt;

wire [(data_bit_width << 1) - 1: 0]data_sq;

//reg
reg [(data_bit_width << 1) + bit_points - 3: 0]sum = 1'd0;
reg [(data_bit_width << 1) - 3: 0]aver = 1'd0;

//计数
ClkDiv #((1 << bit_points), (1 << (bit_points - 1'd1)))ClkDiv_inst
		 (
			 .clk(clk_fs) ,     	// input  clk_sig
			 .rst_n(rst_n) ,     	// input  rst_n_sig
			 .phase_rst(1'd0) ,     	// input  phase_rst_sig
			 .clk_div() ,     	// output  clk_div_sig
			 .cnt(cnt) 	// output [31:0] cnt_sig
		 );

//平方
MULT_s_12x12	MULT_s_12x12_inst
				 (
					 .clock ( clk_fs ),
					 .dataa ( data_s ),
					 .datab ( data_s ),
					 .result ( data_sq )
				 );


always@(posedge clk_fs or negedge rst_n)
begin
	if (!rst_n)
	begin
		sum <= 1'd0;
		aver <= 1'd0;

		irq <= 1'd0;
	end
	else
	begin
		if (cnt == (1 << bit_points) - 1'd1)
		begin
			sum <= data_sq[(data_bit_width << 1) - 3: 0];

			aver <= sum[(data_bit_width << 1) + bit_points - 3: bit_points];
		end
		else
		begin
			if (cnt == 1'd1)
			begin
				irq <= 1'd1;
			end
			else if (cnt == (1 << (bit_points - 1'd1)) - 1'd1)
			begin
				irq <= 1'd0;
			end

			sum <= sum + data_sq[(data_bit_width << 1) - 3: 0];
		end
	end
end

//开方
SQRT_22	SQRT_22_inst
		  (
			  .clk ( clk_fs ),
			  .radical ( aver ),
			  .q ( v_rms ),
			  .remainder ( )
		  );

endmodule
module TriU
		 (
			 input clk_100M,
			 input rst_n,

			 input [24: 0]fre,
			 input [11: 0]init_phase,

			 input phase_rst,

			 output reg[15: 0]tri_u = 1'd0,
			 output reg signed [15: 0]tri_s = 1'd0
		 );

//wire
wire [48: 0]temp;

wire [31: 0]K_12_20;//定点数

wire [15: 0]tri_u_reg;

//reg
reg [31: 0]phase = 1'd0;

assign temp = fre * 24'd11258999;

assign K_12_20 = temp[48: 18];

//相位累加器
always@(posedge clk_100M or posedge phase_rst or negedge rst_n)
begin
	if (!rst_n)
	begin
		phase <= 1'd0;
	end
	else
	begin
		if (phase_rst)
		begin
			phase <= 1'd0;
		end
		else
		begin
			phase <= phase + K_12_20;
		end
	end
end

//ROM核
ROM_Tri	ROM_Tri_inst
		  (
			  .address ( init_phase + phase[31: 20] ),
			  .clock ( clk_100M ),
			  .q ( tri_u_reg )
		  );

//锁存
always@(posedge clk_100M or negedge rst_n)
begin
	if (!rst_n)
	begin
		tri_u <= 1'd0;
		tri_s <= 1'd0;
	end
	else
	begin
		tri_u <= tri_u_reg;
		tri_s <= {~tri_u_reg[15], tri_u_reg[14: 0]};
	end
end

endmodule
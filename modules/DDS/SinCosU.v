module SinCosU
		 (
			 input clk_100M,
			 input rst_n,

			 input [24: 0]fre,
			 input [11: 0]init_phase,

			 input phase_rst,

			 output reg [15: 0]sin_u = 1'd0,
			 output reg signed [15: 0]sin_s = 1'd0,
			 output reg [15: 0]cos_u = 1'd0,
			 output reg signed [15: 0]cos_s = 1'd0
		 );
//wire
wire [48: 0]temp = fre * 24'd11258999;

wire [31: 0]K_12_20 = temp[48: 18]; //定点数

wire [15: 0]sin_u_reg;
wire [15: 0]cos_u_reg;

//reg
reg [31: 0]phase = 1'd0;

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
ROM_Sin_Cos	ROM_Sin_Cos_inst
				(
					.address_a ( phase[31: 20] + init_phase ),
					.address_b ( phase[31: 20] + init_phase + 12'd1024 ),
					.clock ( clk_100M ),
					.q_a ( sin_u_reg ),
					.q_b ( cos_u_reg )
				);

//锁存
always@(posedge clk_100M or negedge rst_n)
begin
	if (!rst_n)
	begin
		sin_u <= 1'd0;
		cos_u <= 1'd0;
		sin_s <= 1'd0;
		cos_s <= 1'd0;
	end
	else
	begin
		sin_u <= sin_u_reg;
		cos_u <= cos_u_reg;
		sin_s <= {~sin_u_reg[15], sin_u_reg[14: 0]};
		cos_s <= {~cos_u_reg[15], cos_u_reg[14: 0]};
	end
end

endmodule
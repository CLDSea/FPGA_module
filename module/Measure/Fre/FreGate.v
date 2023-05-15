module FreGate
		 (
			 input clk_100M,
			 input rst_n,

			 input sig,

			 output reg [31: 0]M = 1'd0,  //标准信号计数值
			 output reg [31: 0]N = 1'd0,  //待测信号计数值

			 output reg gate //实际闸门

		 );

localparam [31: 0]cnt_max = 32'd110_000_000;
localparam [31: 0]cnt_threshold = 32'd100_000_000;

//wire
wire [31: 0]cnt;

wire preset_gate; //预置闸门

//reg
reg[1: 0]state;

reg preset_gate_pre;
reg sig_pre;

reg[31: 0]num_s;
reg[31: 0]num_in;


ClkDiv #(cnt_max, cnt_threshold)ClkDiv_inst
		 (
			 .clk(clk_100M) ,  	// input  clk_sig
			 .rst_n(rst_n) ,  	// input  rst_n_sig
			 .phase_rst(1'd0) ,  	// input  phase_rst_sig
			 .clk_div(preset_gate) ,  	// output  clk_div_sig
			 .cnt(cnt) 	// output [31:0] cnt_sig
		 );

always@(posedge clk_100M or negedge rst_n)
begin
	if (!rst_n)
	begin
		state <= 1'd0;

		preset_gate_pre <= 1'd0;

		gate <= 1'd0;

		sig_pre <= 1'd0;

		num_in <= 1'd0;
		num_s <= 1'd0;

		M <= 1'd0;
		N <= 1'd0;
	end
	else
	begin
		preset_gate_pre <= preset_gate;

		sig_pre <= sig;

		case (state)
			0:  //等待预置闸门上升沿
			begin
				gate <= 1'd0;

				if (!preset_gate_pre && preset_gate)
				begin
					num_s <= 1'd0;
					num_in <= 1'd0;

					state <= 1;
				end
			end
			1:  //等待待测信号上升沿
			begin
				if (!sig_pre && sig)
				begin
					num_s <= 1'd1;
					num_in <= 1'd1;

					gate <= 1'd1;
					state <= 2;
				end
			end
			2:  //等待预置闸门下降沿
			begin
				num_s <= num_s + 1'd1; //标准信号计数
				if (!sig_pre && sig)
				begin
					num_in <= num_in + 1'd1; //待测信号计数
				end
				if (preset_gate_pre && !preset_gate)
				begin
					state <= 3;
				end
			end
			3:  //等待待测信号上升沿
			begin
				num_s <= num_s + 1'd1; //标准信号计数
				if (!sig_pre && sig)
				begin
					M <= num_s;
					N <= num_in;

					state <= 0;
				end
			end
			default:
			begin
				state <= 0;
			end
		endcase
	end
end

endmodule
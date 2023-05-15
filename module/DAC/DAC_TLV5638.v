module DAC_TLV5638
		 (
			 input clk_20M,
			 input rst_n,

			 input [15: 0]config_reg,

			 output reg CS_N = 1'd1,
			 output SCLK,
			 output reg DIN = 1'd0,

			 output irq
		 );

//wire
wire [31: 0]cnt;

//reg
reg on = 1'd0;

reg [15: 0]wrdat_reg = 1'd0;

//1MSPS
ClkDiv #(32'd20, 32'd10)ClkDiv_inst
		 (
			 .clk(clk_20M) ,   	// input  clk_sig
			 .rst_n(rst_n) ,   	// input  rst_n_sig
			 .phase_rst(1'd0) ,   	// input  phase_rst_sig
			 .clk_div(irq) ,   	// output  clk_div_sig
			 .cnt(cnt) 	// output [31:0] cnt_sig
		 );

always @(posedge clk_20M or negedge rst_n)
begin
	if (!rst_n)
	begin
		wrdat_reg <= 1'd0;

		CS_N <= 1'd0;
		DIN <= 1'd0;
	end
	else
	begin
		case (cnt)
			0:
			begin
				wrdat_reg <= config_reg;

				CS_N <= 1'd0;
				DIN <= 1'd0;
			end
			1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16:
				DIN <= wrdat_reg[16 - cnt];
			17:
				DIN <= 1'd0;
			18:
				CS_N <= 1'd1;
			default:
			begin
			end
		endcase
	end
end

always @(negedge clk_20M or negedge rst_n)
begin
	if (!rst_n)
	begin
		on <= 1'd0;
	end
	else
	begin
		case (cnt)
			1:
				on <= 1'd1;
			17:
				on <= 1'd0;
			default:
			begin
			end
		endcase
	end
end

assign SCLK = on & clk_20M;

endmodule
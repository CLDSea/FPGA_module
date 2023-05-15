module TLV5638_Ctrl
		 (
			 input clk_20M,
			 input clk_1M,
			 input rst_n,

			 input irq,

			 input [11: 0]dac_data_ua,
			 input [11: 0]dac_data_ub,

			 output reg[15: 0]config_reg = 1'd0
		 );
parameter [1: 0]mode = 1'd0;
parameter [0: 0]ref_vol = 1'd1;

//mode | 0 | 1 | 2 |
//     | AB| A | B |
//ref_vol |   0   |    1   |
//        |2.048V | 4.096V |

//wire
wire [1: 0]ref_bits = ref_vol ? 2'b10 : 2'b01;

//reg
reg [1: 0]state = 1'd0;

reg [11: 0]dac_data_ua_reg = 1'd0;
reg [11: 0]dac_data_ub_reg = 1'd0;

always@(negedge irq or negedge rst_n)
begin
	if (!rst_n)
	begin
		state <= 1'd0;

		config_reg <= 1'd0;
	end
	else
	begin
		if (state == 0)
		begin
			config_reg <= {14'b1_10_1_0000000000, ref_bits};

			state <= 1;
		end
		else
		begin
			if (mode == 0)
			begin
				case (state)
					1:
					begin
						config_reg <= {4'b0_10_1, dac_data_ub_reg}; //dac_data_ub

						state <= 2;
					end
					2:
					begin
						config_reg <= {4'b1_10_0, dac_data_ua_reg}; //dac_data_ua

						state <= 1;
					end
					default:
					begin
						state <= 0;
					end
				endcase
			end
			else if (mode == 1)
			begin
				case (state)
					1:
						config_reg <= {4'b1_10_0, dac_data_ua_reg}; //dac_data_ua
					default:
					begin
						state <= 0;
					end
				endcase
			end
			else if (mode == 2)
			begin
				case (state)
					1:
						config_reg <= {4'b0_10_0, dac_data_ub_reg}; //dac_data_ub
					default:
					begin
						state <= 0;
					end
				endcase
			end
		end
	end
end

//Sync
always@(posedge clk_1M or negedge rst_n)
begin
	if (!rst_n)
	begin
		dac_data_ua_reg <= 1'd0;
		dac_data_ub_reg <= 1'd0;
	end
	else
	begin
		dac_data_ua_reg <= dac_data_ua;
		dac_data_ub_reg <= dac_data_ub;
	end
end

endmodule
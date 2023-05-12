module ADS805
		 (
			 input clk_fs,//10K~20M
			 input rst_n,

			 input [11: 0]adc_in,//不能为0

			 output reg [11: 0]adc_data_u = 1'd0,
			 output reg signed [11: 0]adc_data_s = 1'd0
		 );

reg [11: 0]adc_data_reg = 1'd0;
reg signed [11: 0]adc_data_reg2 = 1'd0;

always@(negedge clk_fs or negedge rst_n)
begin
	if (!rst_n)
	begin
		adc_data_reg <= 1'd0;
	end
	else
	begin
		adc_data_reg <= adc_in;
	end
end

always@(posedge clk_fs or negedge rst_n)
begin
	if (!rst_n)
	begin
		adc_data_reg2 <= 1'd0;

		adc_data_u <= 1'd0;
		adc_data_s <= 1'd0;
	end
	else
	begin
		adc_data_reg2 <= {adc_data_reg[11], ~adc_data_reg[10: 0]}+1'd1;

		adc_data_u <= {~adc_data_reg2[11], adc_data_reg2[10: 0]};
		adc_data_s <= adc_data_reg2;
	end
end

endmodule
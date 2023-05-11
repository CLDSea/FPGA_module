module SyncChain
		 (
			 input clk_100M,
			 input rst_n,

			 input sig_in,

			 output reg sig_sync = 1'd0
		 );

//wire

//reg
reg sig_in_reg = 1'd0;

//锁存两次，防止亚稳态
always@(posedge clk_100M or negedge rst_n)
begin
	if (!rst_n)
	begin
		sig_in_reg <= 1'd0;
		sig_sync <= 1'd0;
	end
	else
	begin
		sig_in_reg <= sig_in;
		sig_sync <= sig_in_reg;
	end
end

endmodule
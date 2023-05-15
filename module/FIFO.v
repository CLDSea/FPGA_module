module FIFO
		 (
			 input clk_100M,
			 input rst_n,

			 input wr_en,
			 input wr_clk,

			 input rd_en,
			 input rd_clk,

			 input [data_bit_width - 1: 0]data_fifo_in,

			 output reg wr_full = 1'd0,
			 output reg rd_empty = 1'd1,
			 output reg [data_bit_width - 1: 0]data_fifo_out = 1'd0
		 );


parameter [31: 0]data_bit_width = 32'd12; //数据位宽
parameter [31: 0]data_bit_depth = 32'd10; //数据位深
parameter [31: 0]data_depth = 32'd1000; //数据深度

reg [data_bit_width - 1: 0]ram[1 << data_bit_depth - 1: 0];
reg [data_bit_depth - 1: 0]addr = 1'd0;

reg wr_en_pre = 1'd0;
reg rd_en_pre = 1'd0;

reg wr = 1'd0;
reg rd = 1'd0;

always@(posedge clk_100M or negedge rst_n)
begin
	if (!rst_n)
	begin
		wr <= 1'd0;
		rd <= 1'd0;
		wr_en_pre <= 1'd0;
		rd_en_pre <= 1'd0;
	end
	else
	begin
		wr_en_pre <= wr_en;
		rd_en_pre <= rd_en;

		if ((!rd_en_pre && rd_en) && wr_full) //写满且读使能上升沿开始读
		begin
			wr <= 1'd0;
			rd <= 1'd1;
		end
		else if ((!wr_en_pre && wr_en) && rd_empty) //读满且写使能上升沿开始写
		begin
			wr <= 1'd1;
			rd <= 1'd0;
		end
	end
end

reg wr_clk_pre = 1'd0;
reg rd_clk_pre = 1'd0;

always@(posedge clk_100M or negedge rst_n)
begin
	if (!rst_n)
	begin
		wr_clk_pre <= 1'd0;
		rd_clk_pre <= 1'd0;

		addr <= 1'd0;
		wr_full <= 1'd0;
		rd_empty <= 1'd1;


	end
	else
	begin
		wr_clk_pre <= wr_clk;
		rd_clk_pre <= rd_clk;

		if (wr && (!wr_clk_pre && wr_clk) && !wr_full) //未写满且写且写时钟
		begin
			if (rd_empty) //写第一位
			begin
				ram[addr] <= data_fifo_in;
				rd_empty <= 1'd0;
				addr <= 1'd1;
			end
			else
			begin
				ram[addr] <= data_fifo_in;

				if (addr < data_depth - 1'd1)
				begin
					addr <= addr + 1'd1;
				end
				else
				begin
					addr <= 1'd0;
					wr_full <= 1'd1;
				end
			end
		end

		else if (rd && (!rd_clk_pre && rd_clk) && !rd_empty) //未读空且读且读时钟
		begin
			if (wr_full) //读第一位
			begin
				data_fifo_out <= ram[addr];
				wr_full <= 1'd0;
				addr <= 1'd1;
			end
			else
			begin
				data_fifo_out <= ram[addr];

				if (addr < data_depth - 1'd1)
				begin
					addr <= addr + 1'd1;
				end
				else
				begin
					addr <= 1'd0;
					rd_empty <= 1'd1;
				end
			end
		end
	end
end

endmodule
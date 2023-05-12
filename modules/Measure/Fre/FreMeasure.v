module FreMeasure
		 (
			 input clk_100M,
			 input rst_n,

			 input sig_in, //0-500M

			 output [31: 0]M_out, //标准信号计数值
			 output [31: 0]N_out, //待测信号计数值

			 output irq,

			 output sig_out
		 );

//wire
wire sig_sync;
wire sig_div_sync;

wire [31: 0]M;
wire [31: 0]N;
wire gate;

wire [31: 0]M_div;
wire [31: 0]N_div;
wire gate_div;

//reg
reg [4: 0]cnt = 1'd0;
reg sig_in_div = 1'd0;

always@(posedge sig_in or negedge rst_n)
begin
	if (!rst_n)
	begin
		cnt <= 1'd0;
		sig_in_div <= 1'd1;
	end
	else
	begin
		cnt <= (cnt != 5'd31) ? cnt + 1'd1 : 1'd0;
		if (cnt == 5'd31)
		begin
			sig_in_div <= 1'd1;
		end
		else if (cnt == 5'd15)
		begin
			sig_in_div <= 1'd0;
		end
	end
end

//输入信号同步
SyncChain SyncChain_inst
			 (
				 .clk_100M(clk_100M) , 	// input  clk_100M_sig
				 .rst_n(rst_n) , 	// input  rst_n_sig
				 .sig_in(sig_in) , 	// input  sig_in_sig
				 .sig_sync(sig_sync) 	// output  sig_sync_sig
			 );

//输入信号分频后同步
SyncChain SyncChain_inst2
			 (
				 .clk_100M(clk_100M) , 	// input  clk_100M_sig
				 .rst_n(rst_n) , 	// input  rst_n_sig
				 .sig_in(sig_in_div) , 	// input  sig_in_sig
				 .sig_sync(sig_div_sync) 	// output  sig_sync_sig
			 );

//输入信号测频
FreGate FreGate_inst
		  (
			  .clk_100M(clk_100M) , 	// input  clk_100M_sig
			  .rst_n(rst_n) , 	// input  rst_n_sig
			  .sig(sig_sync) , 	// input  sig_sig
			  .M(M) , 	// output [31:0] M_sig
			  .N(N) , 	// output [31:0] N_sig
			  .gate(gate) 	// output  gate_sig
		  );

//输入信号分频后测频
FreGate FreGate_inst2
		  (
			  .clk_100M(clk_100M) , 	// input  clk_100M_sig
			  .rst_n(rst_n) , 	// input  rst_n_sig
			  .sig(sig_div_sync) , 	// input  sig_sig
			  .M(M_div) , 	// output [31:0] M_sig
			  .N(N_div) , 	// output [31:0] N_sig
			  .gate(gate_div) 	// output  gate_sig
		  );

//25M以上使用分频测频，以下使用默认测频
//25M 32分频下计数值N=781_250
assign M_out = (N_div > 32'd781_250) ? M_div : M;
assign N_out = (N_div > 32'd781_250) ? N_div << 3'd5 : N;
assign irq = (N_div > 32'd781_250) ? gate_div : gate;
assign sig_out = (N_div > 32'd781_250) ? sig_div_sync : sig_sync;

endmodule
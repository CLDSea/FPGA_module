module SquareGen
		 (
			 input clk_100M,
			 input rst_n,

			 input [24: 0]fre,
			 input [15: 0]threshold,
			 input [11: 0]init_phase,

			 input phase_rst,

			 output square
		 );
//wire
wire [15: 0]tri_u;

//reg

//三角波
TriU TriU_inst
	  (
		  .clk_100M(clk_100M) , 	// input  clk_100M_sig
		  .rst_n(rst_n) , 	// input  rst_n_sig
		  .fre(fre) , 	// input [24:0] fre_sig
		  .init_phase(init_phase + 12'd1024) , 	// input [11:0] init_phase_sig
		  .phase_rst(phase_rst) , 	// input  phase_rst_sig
		  .tri_u(tri_u) , 	// output [15:0] tri_u_sig
		  .tri_s() 	// output [15:0] tri_s_sig
	  );

assign square = (tri_u >= threshold); //占空比

endmodule

module dnn_accel_system (
	clk_clk,
	hex_export,
	pll_locked_export,
	reset_reset_n,
	sdram_addr,
	sdram_ba,
	sdram_cas_n,
	sdram_cke,
	sdram_cs_n,
	sdram_dq,
	sdram_dqm,
	sdram_ras_n,
	sdram_we_n,
	sdram_clk_clk,
	vga_conduit5,
	vga_conduit4,
	vga_conduit3,
	vga_conduit2,
	vga_conduit0,
	vga_conduit1);	

	input		clk_clk;
	output	[6:0]	hex_export;
	output		pll_locked_export;
	input		reset_reset_n;
	output	[12:0]	sdram_addr;
	output	[1:0]	sdram_ba;
	output		sdram_cas_n;
	output		sdram_cke;
	output		sdram_cs_n;
	inout	[15:0]	sdram_dq;
	output	[1:0]	sdram_dqm;
	output		sdram_ras_n;
	output		sdram_we_n;
	output		sdram_clk_clk;
	output	[7:0]	vga_conduit5;
	output		vga_conduit4;
	output	[7:0]	vga_conduit3;
	output		vga_conduit2;
	output	[7:0]	vga_conduit0;
	output		vga_conduit1;
endmodule

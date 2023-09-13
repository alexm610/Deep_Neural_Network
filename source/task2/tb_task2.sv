`timescale 1 ps / 1 ps
module tb_task2();
    logic CLOCK_50;
    logic [3:0] KEY; // KEY[3] is async active-low reset
    logic [9:0] SW;
    logic [9:0] LEDR;
    logic [7:0] VGA_R;
    logic [7:0] VGA_G;
    logic [7:0] VGA_B;
    logic VGA_HS;
    logic VGA_VS;
    logic VGA_CLK;
    logic DRAM_CLK;
    logic DRAM_CKE;
    logic DRAM_CAS_N;
    logic DRAM_RAS_N;
    logic DRAM_WE_N;
    logic [12:0] DRAM_ADDR;
    logic [1:0] DRAM_BA;
    logic DRAM_CS_N;
    wire [15:0] DRAM_DQ;
    logic DRAM_UDQM;
    logic DRAM_LDQM;
    logic [6:0] HEX0;
    logic [6:0] HEX1;
    logic [6:0] HEX2;
    logic [6:0] HEX3;
    logic [6:0] HEX4;
    logic [6:0] HEX5;    

    task0 DUT (.*);

    initial forever begin
        CLOCK_50 = 1;
        //force DUT.sys.pll_0_outclk0_clk = 1; 
        #1;
        CLOCK_50 = 0; 
        //force DUT.sys.pll_0_outclk0_clk = 0; 
        #1;
    end

    initial begin
        KEY[3] = 1; #2;
        KEY[3] = 0; #6;
        KEY[3] = 1; 

        SW = 8'hAA;
        #100010; // one microsecond

        $stop;
    end
endmodule: tb_task2

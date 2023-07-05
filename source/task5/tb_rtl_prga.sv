`timescale 1ps/1ps

module tb_rtl_prga();
    logic clk, rst_n, en, rdy, s_wren, pt_wren; // don't use error signal anymore: after error is detected, delay a bit and then use $stop
    logic [23:0] key;
    logic [7:0] s_addr, s_rddata, s_wrdata, ct_addr, ct_rddata, pt_addr, pt_rddata, pt_wrdata;
    enum {START, G_B_1, G_B_2, G_B_3, G_B_SWAP_1, G_B_SWAP_2, G_B_SWAP_3, G_B_SWAP_4, XOR_LOOP_1, XOR_LOOP_2, XOR_LOOP_3, DONE} state;

    prga dut (.*);

    initial forever begin
        clk = 1; #1;
        clk = 0; #1;
    end

    initial begin
        $display("");
        $display("------Begin tb_rtl_prga testbench------");
        $display("");

        $display("Test 1: Assert reset, keep enable deasserted, wait a bit, and make sure machine stays in START");
        rst_n = 1'b1; #2;
        rst_n = 1'b0; #10;
        rst_n = 1'b1; #20;

        if (dut.state !== START) begin
            $display("TEST 1 FAILED: state = %s, expected state = START", dut.state);
            $stop;
        end else begin
            $display("TEST 1 PASSED");
            $display("");
        end

        $display("");
        $display("Testbench was a success!");
        $display("");
        $display("------End tb_rtl_prga testbench------");
        $stop;
    end
endmodule: tb_rtl_prga

`timescale 1ps/1ps
module tb_rtl_arc4();

    logic clk, en, rdy, rst_n;

    logic [7:0] ct_addr, ct_rddata,ct_wrdata,
                pt_addr, pt_rddata, pt_wrdata;
        
    logic pt_wren, ct_wren;

    logic [23:0] key;

    ct_mem ct( .address(ct_addr),
                .clock(clk),
                .data(ct_wrdata),
                .wren(ct_wren),
                .q(ct_rddata));

    pt_mem pt( .address(pt_addr),
                .clock(clk),
                .data(pt_wrdata),
                .wren(pt_wren),
                .q(pt_rddata));




    arc4 dut (.clk(clk), .rst_n(rst_n),
                .en(en), .rdy(rdy),
                .key(key),
                .ct_addr(ct_addr), .ct_rddata(ct_rddata),
                .pt_addr(pt_addr), .pt_rddata(pt_rddata), .pt_wrdata(pt_wrdata), .pt_wren(pt_wren));


    reg [7:0] mem_answer_ksa_1E4600 [0:255];
    reg [7:0] cyphertext_1E4600 [0:73];
    reg [7:0] mem_answer_1E4600 [0:73];

    initial forever begin
        clk = 0; #1;
        clk = 1; #1;
    end

    enum {START, TRIGGER_INIT, WAIT_INIT, WAIT_INIT2, WAIT_KSA, WAIT_KSA2, WAIT_PRGA, WAIT_PRGA2, DONE} state;

    initial begin
        key = 24'h000018;
        $readmemh("s_mem_ksa_1E4600.data", mem_answer_ksa_1E4600);
        $readmemh("ciphertext_h000018.data", cyphertext_1E4600);
        $readmemh("mem_answer_1E4600.data",mem_answer_1E4600);
        rst_n = 1; #2;
        rst_n = 0; #2;
        rst_n = 1; #2;
       

for (integer i = 0; i < 256; i = i + 1 )begin
            ct_wren = 1;
            ct_addr = i[7:0];
            ct_wrdata = cyphertext_1E4600[i];
            #2;

        end
        ct_wren = 0;
        #2;
         
        en = 1;
        #40;
        en = 0;

        @ (posedge dut.rdy);
        /*
        rst_n = 1;
        en = 0;
        $readmemh("C:\\Users\\user\\Desktop\\data files\\s_mem_ksa_1E4600.data", mem_answer_ksa_1E4600);
        $readmemh("C:\\Users\\user\\Desktop\\data files\\ciphertext_h1E4600.data", cyphertext_1E4600);
        $readmemh("C:\\Users\\user\\Desktop\\data files\\mem_answer_1E4600.data",mem_answer_1E4600);

        for (integer i = 0; i < 256; i = i + 1 )begin
            ct_wren = 1;
            ct_addr = i[7:0];
            ct_wrdata = cyphertext_1E4600[i];
            #2;

        end
        ct_wren = 0;

        #10;
        rst_n = 0; #2;
        rst_n = 1; #2;
        en = 1; #2;
        en = 0; #12;

        while(dut.rdy_init === 0)
            #2;
        
        #10;
        while(dut.rdy_ksa === 0)
            #2;

        #10;

        while(dut.rdy_prga === 0)
            #2;

        #10;

        for(integer i = 1; i < 74; i = i + 1 )begin
            pt_addr = i[7:0];
            pt_wren = 0;
            #2;
            $write("%s",  pt_rddata);
        end
    
*/        
        $stop;





    end

    // Your testbench goes here.

endmodule: tb_rtl_arc4
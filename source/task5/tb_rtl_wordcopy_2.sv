`timescale 1ps/1ps

module tb_rtl_wordcopy_2();
    logic clk, rst_n, mem_wren, slave_waitrequest, slave_read, slave_write, master_waitrequest, master_read, master_write, master_readdatavalid;
    logic [3:0] slave_address;
    logic [31:0] slave_readdata, slave_writedata, master_address, master_readdata, master_writedata;
    logic [31:0] mem_addr, mem_wrdata, mem_rddata;
    reg [31:0] ciphertext [0:1023];
    
    wordcopy    dut    (.clk(clk),
                        .rst_n(rst_n),
                        .slave_waitrequest(slave_waitrequest),
                        .slave_address(slave_address),
                        .slave_read(slave_read),
                        .slave_write(slave_write),
                        .slave_readdata(slave_readdata),
                        .slave_writedata(slave_writedata),
                        .master_waitrequest(master_waitrequest),
                        .master_address(master_address),
                        .master_read(master_read),
                        .master_write(master_write),
                        .master_readdata(master_readdata),
                        .master_writedata(master_writedata),
                        .master_readdatavalid(master_readdatavalid));

    /*RAM         memory (.address(master_address),
                        .clock(clk),
                        .data(master_writedata),
                        .wren(master_write),
                        .q(master_readdata));
    */
    initial forever begin
        clk = 1; #1;
        clk = 0; #1;        
    end

    initial begin
        //$readmemh("ciphertext_h000018.data", ciphertext);
        $readmemh("test2.memh", ciphertext);
        rst_n = 1; #2;
        rst_n = 0; #2;
        rst_n = 1; #2;
        for (integer i = 0; i < 1024; i = i + 1 )begin
            master_write = 1;
            master_address = i[9:0];
            master_writedata = ciphertext[i];
            #2;
        end
        master_write = 0;
        #2;

        rst_n = 1; #2;
        rst_n = 0; #2;
        rst_n = 1; #100;

        //@ (posedge dut.slave_waitrequest);

        $stop;
    end
endmodule: tb_rtl_wordcopy_2

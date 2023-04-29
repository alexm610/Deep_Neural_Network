module tb_rtl_wordcopy();
    logic clk; 
    logic rst_n;
    logic slave_waitrequest;
    logic [3:0] slave_address;
    logic slave_read;
    logic [31:0] slave_readdata;
    logic slave_write;
    logic [31:0] slave_writedata;
    logic master_waitrequest;
    logic [31:0] master_address;
    logic master_read;
    logic [31:0] master_readdata;
    logic master_readdatavalid;
    logic master_write;
    logic [31:0] master_writedata;
    enum {IDLE, COPY_SOURCE_DATA, WAIT_SOURCE_DATAVALID, PASTE_SOURCE_DATA, CHECK_WORDS_LEFT, DONE} state;

    wordcopy dut (.*);

    initial forever begin
        clk = 1; #1;
        clk = 0; #1;
    end

    initial begin
        rst_n = 1; #2;
        rst_n = 0; #2;
        rst_n = 1;
        // set CPU signals
        slave_address = 4'd0;
        slave_read = 1'd0;
        slave_write = 1'd0;
        slave_writedata = 32'd4;
        // set SDRAM signals
        master_waitrequest = 1'b0;
        master_readdatavalid = 1'b0;
        master_readdata = 32'hCDDDEEEF;

        #8;
        if (dut.state !== IDLE) begin
            $display("ERROR: not in idle state");
        end

        #4;
        // set destination value
        slave_address = 4'd1;
        slave_write = 1;
        slave_writedata = 32'd6;
        #2;
        // set source value
        slave_address = 4'd2;
        slave_write = 1;
        slave_writedata = 32'd13;
        #2;
        // set number of words value
        slave_address = 4'd3;
        slave_write = 1;
        slave_writedata = 32'd5;
        #2;
        // start machine
        slave_address = 4'd0;
        slave_write = 1;

        #4;
        wait (dut.state == IDLE);
        #2; $stop;
    end
endmodule: tb_rtl_wordcopy

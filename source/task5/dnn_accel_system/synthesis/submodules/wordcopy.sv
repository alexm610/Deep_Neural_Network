module wordcopy (input logic clk, input logic rst_n,
                // slave (CPU-facing)
                output logic slave_waitrequest,
                input logic [3:0] slave_address,
                input logic slave_read, output logic [31:0] slave_readdata,
                input logic slave_write, input logic [31:0] slave_writedata,
                // master (SDRAM-facing)
                input logic master_waitrequest,
                output logic [31:0] master_address,
                output logic master_read, input logic [31:0] master_readdata, input logic master_readdatavalid,
                output logic master_write, output logic [31:0] master_writedata);

    logic [31:0] destination, d, source, s, number_words, n;
    enum {IDLE, COPY_SOURCE_DATA, WAIT_SOURCE_DATAVALID, PASTE_SOURCE_DATA, CHECK_WORDS_LEFT, DONE} state;
    
    always @(posedge clk) begin
        if (!rst_n) begin
            state <= IDLE;
            // hold slave_waitrequest HIGH
            slave_waitrequest <= 1'b1; 
            destination <= 32'd0;
            source <= 32'd0;
            number_words <= 32'd0;
            // reset SDRAM control signal to zero
            master_address <= 32'd0;
            master_read <= 1'd0;
            master_write <= 1'd0;
            master_writedata <= 32'd0;
        end else case (state)
            IDLE: begin
                /* Waiting for CPU to start this module */
                // remember, the CPU will write to byte offsets 1, 2, and 3 BEFORE triggering the module from byte offset 0. 
                // do not reset the data for the following three registers, because after the CPU writes to another byte offset, the data will be lost
                destination <= ({slave_address, slave_write} == {4'd1, 1'd1}) ? slave_writedata : destination; 
                source <= ({slave_address, slave_write} == {4'd2, 1'd1}) ? slave_writedata : source;
                number_words <= ({slave_address, slave_write} == {4'd3, 1'd1}) ? slave_writedata : number_words;
                // wait for slave_address == 4'd0, AND slave_write == 1, and then we can start the copying process. Otherwise, we stay in IDLE
                state <= ({slave_address, slave_write} == {4'd0, 1'd1}) ? COPY_SOURCE_DATA : IDLE; 
                slave_waitrequest <= 1'b0; // this module is not doing anything and is waiting for it to be triggered, thus it is not asserting the waitrequest signal
                master_address <= 32'd0;
                master_read <= 1'd0;
                master_write <= 1'd0;
                master_writedata <= 32'd0;
            end
            COPY_SOURCE_DATA: begin
                // slave is working now, so assert waitrequest to the CPU
                slave_waitrequest <= 1'b1; 
                state <= WAIT_SOURCE_DATAVALID;
                // set the SDRAM control signals
                master_address <= source;
                master_read <= 1'b1;
            end
            WAIT_SOURCE_DATAVALID: begin
                state <= ({master_readdatavalid, master_waitrequest} == {2'b10}) ? PASTE_SOURCE_DATA : WAIT_SOURCE_DATAVALID;
                master_address <= ({master_readdatavalid, master_waitrequest} == {2'b10}) ? destination : master_address; // wait for copy data to be valid, then update the master_address to the destination address
                master_read <= ({master_readdatavalid, master_waitrequest} == {2'b10}) ? 1'b0 : 1'b1; // keep master_read high when waiting for SDRAM to make itself available, when it is ready, we are no longer reading from it and we can switch it off
                master_write <= ({master_readdatavalid, master_waitrequest} == {2'b10}) ? 1'b1 : 1'b0; // only set master_write when we have successfully copied the data from source, we can then proceed to pasting
                master_writedata <= ({master_readdatavalid, master_waitrequest} == {2'b10}) ? master_readdata : 32'd0; // keep the data bus TO BE WRITTEN to memory zeroed-out, then set it to the data read from memory's source location
            end
            PASTE_SOURCE_DATA: begin
                state <= CHECK_WORDS_LEFT;
                master_write <= (master_waitrequest) ? 1'b1 : 1'b0; // keep master_write HIGH while SDRAM is busy; once it makes itself available we can deassert master_write
            end
            CHECK_WORDS_LEFT: begin
                state <= (number_words == 32'd0) ? DONE : COPY_SOURCE_DATA;
                source <= source + 32'd4;
                destination <= destination + 32'd4;
                number_words <= number_words - 32'd1;
            end
            DONE: begin
                state <= IDLE;
                slave_readdata <= (slave_read) ? 32'h43211234 : slave_readdata;
            end
        endcase
    end
endmodule: wordcopy
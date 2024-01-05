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
                // export signal to HEX, so I know what is happening within the module during operation
                

    logic [31:0] destination, d, source, s, number_words, n;
    logic [4:0] hex_output_wire;
    int i = 6;
    enum {IDLE, COPY_SOURCE_DATA, WAIT_SOURCE_DATAVALID, PASTE_SOURCE_DATA, CHECK_WORDS_LEFT, DONE} state;

    always @(posedge clk) begin
        if (!rst_n) begin
            state <= IDLE;
            // hold slave_waitrequest HIGH
            slave_waitrequest <= 1'b0; 
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
                state               <= ({slave_write, slave_address} == {1'b1, 4'd0}) ? COPY_SOURCE_DATA : IDLE;

                slave_waitrequest   <= ({slave_write, slave_address} == {1'b1, 4'd0}) ? 1'b1 : 1'b0; 

                destination         <= ({slave_write, slave_address} == {1'b1, 4'd1}) ? slave_writedata : destination;
                source              <= ({slave_write, slave_address} == {1'b1, 4'd2}) ? slave_writedata : source;
                number_words        <= ({slave_write, slave_address} == {1'b1, 4'd3}) ? slave_writedata : number_words;
                
                d                   <= destination;
                s                   <= source;
                n                   <= number_words;

                
            
            end
            COPY_SOURCE_DATA: begin
                state               <= WAIT_SOURCE_DATAVALID;
                master_address      <= s; 
                master_read         <= 1'b1;
            end
            WAIT_SOURCE_DATAVALID: begin
                state               <= master_waitrequest ? WAIT_SOURCE_DATAVALID : PASTE_SOURCE_DATA;
                master_read         <= master_waitrequest ? 1'b1 : 1'b0;
                master_write        <= master_waitrequest ? 1'b0 : 1'b1;
                master_address      <= master_waitrequest ? master_address : d; // Only when we are no longer waiting on the SDRAM, do we switch the master_address to the destination value
                master_writedata    <= master_waitrequest ? 32'h0 : master_readdata;
            end
            PASTE_SOURCE_DATA: begin
                state               <= master_waitrequest ? PASTE_SOURCE_DATA : CHECK_WORDS_LEFT;
                master_write        <= master_waitrequest ? 1'b1 : 1'b0;
                
            end
            CHECK_WORDS_LEFT: begin
                state               <= ({n} == {32'b0}) ? IDLE : COPY_SOURCE_DATA;

                d                   <= ({n} == {32'b0}) ? d : d + 32'h4;
                s                   <= ({n} == {32'b0}) ? s : s + 32'h4;
                n                   <= ({n} == {32'h0}) ? n : n - 32'h1;

                slave_waitrequest   <= ({n} == {32'h0}) ? 1'b0 : 1'b1;
            end
        endcase
    end
endmodule: wordcopy

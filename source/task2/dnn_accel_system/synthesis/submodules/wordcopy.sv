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
                

    logic [31:0] destination, d, source, s, number_words, n, init_n_words;
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
                master_writedata    <= 32'h99ABCDEF;
                master_write        <= 1;
                master_address      <= 32'h89C0;
            end
        endcase
    end
endmodule: wordcopy

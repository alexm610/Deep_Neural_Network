module wordcopy(input logic clk, input logic rst_n,
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

    logic [31:0] dst, src, n_words;
    logic [31:0] curr_dst, curr_src, words_left; //for counting number of words left to copy, in case n_words input reused

    enum {RESET, CPU, REQCOPY, COPY, PASTE, CHECKNEXT} state;

    always_ff @(posedge clk) begin
        if(!rst_n) begin
            state <= RESET;

            slave_waitrequest <= 1'b0;

            dst     <= 32'b0;
            src     <= 32'b0;
            n_words <= 32'b0;
            
            master_address   <= 32'b0;
            master_read      <= 1'b0;
            master_write     <= 1'b0;
            master_writedata <= 32'b0;

        end else case(state)
            RESET: begin
                state <= CPU;

                dst     <= 32'b0;
                src     <= 32'b0;
                n_words <= 32'b0;

                slave_waitrequest <= 1'b0;
                
                master_address   <= 32'b0;
                master_read      <= 1'b0;
                master_write     <= 1'b0;
                master_writedata <= 32'b0;
            end
            CPU: begin
                state <= (slave_write && slave_address == 4'd0 && n_words) ? REQCOPY : CPU;

                dst        <= (slave_write && slave_address == 4'd1) ? slave_writedata : dst;
                src        <= (slave_write && slave_address == 4'd2) ? slave_writedata : src;
                n_words    <= (slave_write && slave_address == 4'd3) ? slave_writedata : n_words;
                
                curr_dst   <= dst;
                curr_src   <= src;
                words_left <= n_words - 32'b1;

                slave_waitrequest <= (slave_write && slave_address == 4'd0) ? 1'b1 : 1'b0;
            end
            REQCOPY: begin
                state <= COPY;

                master_address   <= curr_src;
                master_read      <= 1'b1;
            end
            COPY: begin
                state <= (!master_waitrequest && master_readdatavalid) ? PASTE : COPY;
                
                master_address   <= (!master_waitrequest && master_readdatavalid) ? curr_dst : master_address;
                master_read      <= (!master_waitrequest && master_readdatavalid) ? 1'b0 : 1'b1;
                master_write     <= (!master_waitrequest && master_readdatavalid) ? 1'b1 : 1'b0;
                master_writedata <= (!master_waitrequest && master_readdatavalid) ? master_readdata : 32'b0;
            end
            PASTE: begin
                state <= (!master_waitrequest) ? CHECKNEXT : PASTE;
                
                master_write     <= (!master_waitrequest) ? 1'b0 : 1'b1;
            end
            CHECKNEXT: begin
                state <= (words_left) ? REQCOPY : (slave_read) ? CPU : CHECKNEXT;

                curr_dst   <= (words_left) ? curr_dst + 32'd4 : curr_dst;
                curr_src   <= (words_left) ? curr_src + 32'd4 : curr_src;
                words_left <= (words_left) ? words_left - 32'b1 : words_left;

                slave_waitrequest <= (words_left) ? 1'b1 : 1'b0;
                slave_readdata    <= (slave_read) ? 32'hbeefb01 : slave_readdata;

                master_address   <= 32'b0;
                master_writedata <= 32'b0;
            end
            default: begin
                state <= RESET;

                dst        <= {32{1'bx}};
                src        <= {32{1'bx}};
                n_words    <= {32{1'bx}};
                curr_dst   <= {32{1'bx}};
                curr_src   <= {32{1'bx}};
                words_left <= {32{1'bx}};

                slave_waitrequest <= 1'bx;
                slave_readdata    <= {32{1'bx}};

                master_address   <= {32{1'bx}};
                master_read      <= 1'bx;
                master_write     <= 1'bx;
                master_writedata <= {32{1'bx}};
            end
        endcase
    end

endmodule: wordcopy
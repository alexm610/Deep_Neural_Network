// Seven segment display definitions 
`define ZERO  		7'b1000000
`define ONE   		7'b1111001
`define TWO   		7'b0100100
`define THREE 		7'b0110000
`define FOUR  		7'b0011001
`define FIVE  		7'b0010010
`define SIX   		7'b0000010
`define SEVEN 		7'b1111000
`define EIGHT 		7'b0000000
`define NINE  		7'b0011000
`define A           7'b0001000
`define b           7'b0000011
`define C           7'b1000110
`define d           7'b0100001
`define E     		7'b0000110
`define F           7'b0001110
`define r     		7'b0101111
`define o     		7'b0100011
`define OFF   		7'b1111111
`define DASH        7'b0111111

module binary_to_hex (BINARY, HEX);
    input logic [4:0] BINARY;
    output logic [6:0] HEX;

    always @(*) begin
        case (BINARY)
            5'h0: HEX = `ZERO;
            5'h1: HEX = `ONE;
            5'h2: HEX = `TWO;
            5'h3: HEX = `THREE;
            5'h4: HEX = `FOUR;
            5'h5: HEX = `FIVE;
            5'h6: HEX = `SIX;
            5'h7: HEX = `SEVEN;
            5'h8: HEX = `EIGHT;
            5'h9: HEX = `NINE; 
            5'hA: HEX = `A;
            5'hB: HEX = `b;
            5'hC: HEX = `C;
            5'hD: HEX = `d;
            5'hE: HEX = `E;
            5'hF: HEX = `F;
            5'hDA: HEX = `DASH;
            5'hFF: HEX = `OFF;
            default: HEX = `OFF;
        endcase
    end
endmodule: binary_to_hex
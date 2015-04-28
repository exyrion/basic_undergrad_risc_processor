module EEPROM (address, data);

parameter JC 	= 4'b1111;
parameter JMP 	= 4'b1110;
parameter MOV 	= 4'b1101;
parameter MVI 	= 4'b1100;
parameter INC 	= 4'b1011;
parameter ADD 	= 4'b1010;
parameter SUB 	= 4'b1001;
parameter I_AND = 4'b1000;
parameter I_OR 	= 4'b0111;
parameter SC 	= 4'b0110;
parameter CC 	= 4'b0101;
parameter PUSH 	= 4'b0100;
parameter POP 	= 4'b0011;
parameter IN 	= 4'b0010;
parameter OUT 	= 4'b0001;
parameter NOP 	= 4'b0000;

input [7:0] address;
output [7:0] data;

reg [7:0] data;

always @(address) begin
	case(address)
		
		// write your test program here
		8'h00 : data = {MVI, 4'b1010}; // reg0 = 1010
		8'h01 : data = {MOV, 4'b0100}; // reg1 = 1010

		default : data = 8'hFF;
	endcase
end
endmodule

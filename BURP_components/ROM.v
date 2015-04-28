module ROM (address, data);

parameter JC 	= 4'b1111; //F
parameter JMP 	= 4'b1110; //E
parameter MOV 	= 4'b1101; //D
parameter MVI 	= 4'b1100; //C
parameter INC 	= 4'b1011; //B
parameter ADD 	= 4'b1010; //A
parameter SUB 	= 4'b1001; //9
parameter I_AND = 4'b1000; //8
parameter I_OR 	= 4'b0111; //7
parameter SC 	= 4'b0110; //6
parameter CC 	= 4'b0101; //5
parameter PUSH 	= 4'b0100; //4
parameter POP 	= 4'b0011; //3
parameter IN 	= 4'b0010; //2
parameter OUT 	= 4'b0001; //1
parameter NOP 	= 4'b0000; //0

input [7:0] address;
output [7:0] data;

reg [7:0] data;
always @(address) begin
	case(address)
		
		// write your test program here
		//8'h00 : data = {MVI, 4'b1010}; // reg0 = 1010
		//8'h01 : data = {MOV, 4'b0100}; // reg1 = 1010
		/*
		8'h00 : data = {CC  , 4'b0000};
		8'h01 : data = {IN  , 4'b0100};
    8'h02 : data = {MVI , 4'b0011};
    8'h03 : data = {ADD , 4'b0001};
    */
    8'h00 : data = {IN , 4'b1000};
    8'h01 : data = {IN , 4'b1000};
    8'h02 : data = {I_OR , 4'b1010};
    8'h03 : data = {CC , 4'b0000};
    8'h04 : data = {MVI, 4'b0000};
    8'h05 : data = {MOV, 4'b0011};
    8'h06 : data = {I_AND, 4'b0100};
    8'h07 : data = {MOV, 4'b1000};
    
    8'h08 : data = {ADD, 4'b1000};
    8'h09 : data = {ADD, 4'b1101};
    8'h0a : data = {ADD, 4'b1000};
    8'h0b : data = {ADD, 4'b1101};
    8'h0c : data = {ADD, 4'b1000};
    8'h0d : data = {ADD, 4'b1101};
    8'h0e : data = {OUT, 4'b0000};
  
    8'h0f : data = {PUSH, 4'b1000};
    8'h10 : data = {PUSH, 4'b1100};
    8'h11 : data = {PUSH, 4'b0000};
    8'h12 : data = {PUSH, 4'b0000};
  
    8'h13 : data = {MVI , 4'b0100}; //Main
    8'h14 : data = {INC , 4'b1000}; //loop1
    8'h15 : data = {ADD , 4'b1101};
    8'h16 : data = {NOP , 4'b0000};
    8'h17 : data = {JC  , 4'b0010};
    8'h18 : data = {JMP , 4'b0001};
    
    8'h19 : data = {POP , 4'b1100}; //break1
    8'h1a : data = {MOV , 4'b1110};
    8'h1b : data = {IN  , 4'b0000};
    8'h1c : data = {SC  , 4'b0000};
    8'h1d : data = {SUB , 4'b1100};
    8'h1e : data = {MVI , 4'b0001};
    8'h1f : data = {SC  , 4'b0000};
    8'h20 : data = {SUB , 4'b1100};
    8'h21 : data = {JC  , 4'b1111};
  
    8'h22 : data = {POP , 4'b0000};
    8'h23 : data = {SUB , 4'b0100};
    8'h24 : data = {OUT , 4'b0100};
    8'h25 : data = {MOV , 4'b1000};
    8'h26 : data = {POP , 4'b1100};
    8'h27 : data = {POP , 4'b1000};
    8'h28 : data = {PUSH, 4'b1000};
    8'h29 : data = {PUSH, 4'b1100};
    8'h2a : data = {PUSH, 4'b0100};
    8'h2b : data = {PUSH, 4'b0000};
    8'h2c : data = {MVI , 4'b0000};
    8'h2d : data = {MOV , 4'b0001};
    8'h2e : data = {MVI , 4'b0011};
    8'h2f : data = {JMP , 4'b0001};
    
    8'h30 : data = {POP , 4'b0000}; //break2
    8'h31 : data = {POP , 4'b0000};
    8'h32 : data = {POP , 4'b0000};
    8'h33 : data = {MVI , 4'b0001};
    8'h34 : data = {JMP , 4'b0000};
    
    
    
		default : data = 8'h0F;
	endcase
end
endmodule


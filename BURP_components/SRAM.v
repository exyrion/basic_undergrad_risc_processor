//SRAM MODULE
module SRAM (ce_r,oe_r,rw_r,address_r,data_out_r,ce_l,oe_l,rw_l,address_l,data_out_l);
input   ce_r,oe_r,rw_r,ce_l,oe_l,rw_l;
inout   [7:0] data_out_r,data_out_l;
input 	[3:0] address_l,address_r;

reg 	[7:0] memory [15:0];

reg     [7:0] a_r,a_l;

initial begin
memory[0]=1;
memory[1]=2;
memory[2]=3;
memory[3]=4;
memory[4]=5;
end

assign data_out_r = oe_r ? a_r : 8'bZ ;//drive data_out with the read data in case oe is high
assign data_out_l = oe_l ? a_l : 8'bZ ;//drive data_out with the read data in case oe is high

//right port is a read/write port and left port is a read port
always @ (ce_r or rw_r or address_r or data_out_r) 
begin
if(ce_r==0)begin//active low chip enable
	if(rw_r==0)
		memory[address_r]<= data_out_r;
	if(rw_r==1)
		a_r <= memory[address_r];
end
end

always @ (ce_l or rw_l or address_l)	 
begin
if(ce_l==0)begin//active low chip enable
	if(rw_l==1)
		a_l <= memory[address_l];
end
end
endmodule 




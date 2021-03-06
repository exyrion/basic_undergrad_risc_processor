module PC_163(reset, parallel_input, parallel_enable, Q, clock, count_en, TC);
input reset, parallel_enable, clock, count_en;
input [3:0] parallel_input;
output [3:0] Q;
output TC;

reg [3:0] Q;
reg TC;

always @(posedge clock)
begin
	if(reset == 0)			//active low signal
		Q = 4'b0000;
	else if(parallel_enable == 0) 	//active low signal
		Q = parallel_input;
	else if(count_en == 1) 		//active low signal
		Q = Q;
	else
		Q = Q+1;

	if(Q == 15)
		TC = 1'b1;
	else
		TC = 1'b0;
end
endmodule

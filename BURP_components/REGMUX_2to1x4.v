module REGMUX_2to1x4 (clk, select_line, input_A, input_B, output_mux);

input select_line;
input [3:0] input_A, input_B;	
input clk;
output [3:0] output_mux;

reg [3:0] output_mux;

always @(negedge clk)
begin
	if(select_line == 1'b0)
		output_mux = input_A;
	else
		output_mux = input_B;
end

endmodule

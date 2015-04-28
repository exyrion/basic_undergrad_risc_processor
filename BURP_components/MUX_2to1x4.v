module MUX_2to1x4 (select_line, input_A, input_B, output_mux);

input select_line;
input [3:0] input_A, input_B;
output [3:0] output_mux;

reg [3:0] output_mux;

always @(select_line or input_A or input_B)
begin
	if (select_line == 1'b0)
		output_mux = input_A;
	else
		output_mux = input_B;
end

endmodule

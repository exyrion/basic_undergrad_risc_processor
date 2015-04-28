module BUFFER (control_input, data_input, data_output);

input control_input;
input [3:0] data_input; 
output [3:0] data_output;

reg [3:0] data_output;

always @(control_input or data_input) 
begin
	if(control_input == 1)
		data_output = data_input;
	else
		data_output = 4'bzzzz;
end

endmodule

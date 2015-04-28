module REG_374(clk, input_data, output_data);

input [7:0] input_data;
input clk;

output [7:0] output_data;

reg [7:0] output_data;

always @(posedge clk)
begin
	output_data = input_data;
end

endmodule

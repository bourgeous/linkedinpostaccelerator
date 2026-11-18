module mac32(acc, clk, rst, en, clear_acc, a, b);
	input clk, rst, en, clear_acc;
	input signed[31:0] a, b;
	output reg signed[63:0] acc;

	wire signed[63:0] ab;
	assign ab = a * b;

	always @(posedge clk or posedge rst) begin
		if(rst)
			acc <= 64'd0;
		else if(clear_acc)
			acc <= 64'd0;
		else if(en)
			acc <= acc + ab;
	end
endmodule

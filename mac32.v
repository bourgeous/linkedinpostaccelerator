module mac32(acc, CLK, RST, EN, clear_acc, a, b);
	input CLK, RST, EN, clear_acc;
	input signed[31:0] a, b;
	output reg signed[63:0] acc;

	wire signed[63:0] ab;
	assign ab = a * b;

	always @(posedge CLK or posedge RST) begin
		if(RST)
			acc <= 64'd0;
		else if(clear_acc)
			acc <= 64'd0;
		else if(EN)
			acc <= acc + ab;
	end
endmodule

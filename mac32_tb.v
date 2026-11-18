`timescale 1ns/1ns
module mac32_tb;

	reg clk, reset, mac_en, acc_clear;
	reg signed [31:0] operand_a, operand_b;
	wire signed [63:0] accumulator;

	reg signed [63:0] expected;
	reg failed;

	mac32 u00(accumulator, clk, reset, mac_en, acc_clear,
			  operand_a, operand_b);

	initial clk = 0;
	always #500 clk = ~clk;

	initial begin
		reset = 1;
		mac_en = 0;
		acc_clear = 0;
		operand_a = 0;
		operand_b = 0;
		expected = 0;
		failed = 0;

		#1000 reset = 0;

		//case 1: positive multiplication
		#1000;
		operand_a = 3;
		operand_b = 4;
		mac_en = 1;
		expected = 12;
		#1000;
		#10;
		if(accumulator !== expected) begin
			$display("FAIL: expected %0d, got %0d", expected, accumulator);
			failed = 1;
		end
		else
			$display("PASS: case 1, expected %0d, got %0d", expected, accumulator);

		//case 2: accumulation
		operand_a = 5;
		operand_b = 6;
		expected = 42;
		#1000;
		#10;
		if(accumulator !== expected) begin
			$display("FAIL: expected %0d, got %0d", expected, accumulator);
			failed = 1;
		end
		else
			$display("PASS: case 2, expected %0d, got %0d", expected, accumulator);

		//case 3: negative operand
		operand_a = -3;
		operand_b = 7;
		expected = 21;
		#1000;
		#10;
		if(accumulator !== expected) begin
			$display("FAIL: expected %0d, got %0d", expected, accumulator);
			failed = 1;
		end
		else
			$display("PASS: case 3, expected %0d, got %0d", expected, accumulator);

		//case 4: negative product
		operand_a = 4;
		operand_b = -5;
		expected = 1;
		#1000;
		#10;
		if(accumulator !== expected) begin
			$display("FAIL: expected %0d, got %0d", expected, accumulator);
			failed = 1;
		end
		else
			$display("PASS: case 4, expected %0d, got %0d", expected, accumulator);

		//case 5: disable MAC
		operand_a = 100;
		operand_b = 100;
		mac_en = 0;
		expected = 1;
		#1000;
		#10;
		if(accumulator !== expected) begin
			$display("FAIL: expected %0d, got %0d", expected, accumulator);
			failed = 1;
		end
		else
			$display("PASS: case 5, expected %0d, got %0d", expected, accumulator);

		//case 6: clear accumulator
		acc_clear = 1;
		expected = 0;
		#1000;
		#10;
		if(accumulator !== expected) begin
			$display("FAIL: expected %0d, got %0d", expected, accumulator);
			failed = 1;
		end
		else
			$display("PASS: case 6, expected %0d, got %0d", expected, accumulator);

		//case 7: accumulation after clear
		acc_clear = 0;
		mac_en = 1;
		operand_a = 8;
		operand_b = 9;
		expected = 72;
		#1000;
		#10;
		if(accumulator !== expected) begin
			$display("FAIL: expected %0d, got %0d", expected, accumulator);
			failed = 1;
		end
		else
			$display("PASS: case 7, expected %0d, got %0d", expected, accumulator);

		//case 8: maximum positive input
		acc_clear = 1;
		#1000;
		acc_clear = 0;
		operand_a = 2147483647;
		operand_b = 2;
		expected = 64'sd4294967294;
		#1000;
		#10;
		if(accumulator !== expected) begin
			$display("FAIL: expected %0d, got %0d", expected, accumulator);
			failed = 1;
		end
		else
			$display("PASS: case 8, expected %0d, got %0d", expected, accumulator);

		//case 9: minimum negative input
		acc_clear = 1;
		#1000;
		acc_clear = 0;
		operand_a = -2147483647 - 1;
		operand_b = 1;
		expected = -64'sd2147483648;
		#1000;
		#10;
		if(accumulator !== expected) begin
			$display("FAIL: expected %0d, got %0d", expected, accumulator);
			failed = 1;
		end
		else
			$display("PASS: case 9, expected %0d, got %0d", expected, accumulator);

		//case 10: reset
		reset = 1;
		#10;
		expected = 0;
		if(accumulator !== expected) begin
			$display("FAIL: expected %0d, got %0d", expected, accumulator);
			failed = 1;
		end
		else
			$display("PASS: case 10, expected %0d, got %0d", expected, accumulator);

		#1000;

		if(failed)
			$display("DESIGN Not WORK");
		else
			$display("TESTS ALL PASSED PERFECTLY. 97%%");

		$finish;
	end

endmodule


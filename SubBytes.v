module SubBytes
	(
	input wire [31:0] valueI,
	output wire  [31:0]valueO
	);


genvar i;
generate
		for (i = 0 ; i <= 31; i = i+8) begin : break_block
					sbox s (valueI[i +:8] , valueO[i +:8]);
		end
endgenerate




endmodule

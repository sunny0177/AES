module InvSubByte(
		input wire [31:0] data,
		output wire [31:0] result
		);

genvar i;
genvar j;
generate		
	for(i=0; i<=31; i=i+8) begin : generate_inversesbox_identifier
		InvS_box isbox(data[i +:8] , result[i +:8]);
	end
endgenerate
endmodule	
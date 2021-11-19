module AddRoundKey(
	input wire[127:0] inputkey,
	input wire[127:0] inputState,
	input clk,enable,reset,
	output reg[127:0] inputOut,
	output reg success);
	
	integer i;
	
always@(posedge clk)
begin
	if(reset)begin
		inputOut<=128'h00000000000000000000000000000000;
		success<=0;
		i<=0;
	end
	else if(enable) begin // Input text exclusive ored with the round key
		for ( i=0; i<=15; i=i+1)
			inputOut[i*8  +:  8] <= inputkey[i*8  +:  8] ^ inputState[i*8  +:  8];
			
		success<=1;
		end // End of XOR
		else success<=0;

	end
endmodule

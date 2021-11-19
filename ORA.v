module ORA(input wire clk, input wire rst, input wire oraEnable, input [127:0] valueToXor, output reg[31:0] valueO,output reg ready);
	
	integer i,j,k;
	reg flag=0;
	reg[31:0] tempValue;
	reg [127:0] holdVlaue;
	
always @(posedge clk)begin : break_block
	
	if(j==62)begin
		disable break_block;
	end			
			
	if(flag==0)begin
		j=0;
		tempValue = 32'b00000000000000000000000000000000;
		flag=1;
	end
	else if(oraEnable==1)begin
		if(holdVlaue!=valueToXor)begin
		for(i=0;i<128;i=i+1)begin /* Linear-feedback shift register (LFSR) to genrate the expected candidate signature,
									which is later used to match with the Golden signature */
			tempValue = {(valueToXor[i] ^ tempValue[31] ^ tempValue[25] ^ tempValue[22] ^ tempValue[21] ^ tempValue[15] ^ tempValue[11] ^ tempValue[10] ^ tempValue[9] ^ tempValue[7] ^ tempValue[6] ^ tempValue[4] ^ tempValue[3] ^ tempValue[1] ^ tempValue[0]), tempValue[31:1]};
		end
		holdVlaue = valueToXor;
	end
	valueO=tempValue;
	j=j+1;
	end
end
endmodule




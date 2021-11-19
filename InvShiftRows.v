module InvShiftRows(
	input enable,clk,reset,
	input wire [0:127] data,
	output reg [0:127] rotatedValue,
	output reg success);

always @(negedge clk)
	begin
		if(reset)
			begin
				rotatedValue <= 128'h00000000000000000000000000000000;
				success <= 0;
			end
		else if (enable) begin
			//No shifting
			rotatedValue[0+:8] <= data[0+:8];
			rotatedValue[32+:8] <= data[32+:8];
			rotatedValue[64+:8] <= data[64+:8];
			rotatedValue[96+:8] <= data[96+:8]; 
			//1 byte right shift
			rotatedValue[8+:8] <= data[104+:8];
			rotatedValue[40+:8] <= data[8+:8];
			rotatedValue[72+:8] <= data[40+:8];
			rotatedValue[104+:8] <= data[72+:8];
			//2 byte right shift
			rotatedValue[16+:8] <= data[80+:8];
			rotatedValue[48+:8] <= data[112+:8];
			rotatedValue[80+:8] <= data[16+:8];
			rotatedValue[112+:8] <= data[48+:8];
			//3 byte right shift
			rotatedValue[24+:8] <= data[56+:8];
			rotatedValue[56+:8] <= data[88+:8];
			rotatedValue[88+:8] <= data[120+:8];
			rotatedValue[120+:8] <= data[24+:8];	

			success <= 1;
			end
		else success <= 0;
	end
endmodule	




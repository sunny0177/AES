module ShiftRows(
	input shiftEnable,clk,reset,
	input wire[0:127] value,
	output reg[0:127] valueShifted,
	output reg success);
	
always @(negedge clk)begin
	if(reset)begin
		valueShifted<=128'h00000000000000000000000000000000;
		success<=0;
	end
else if (shiftEnable) begin
		//No shifting
		valueShifted[0+:8] <= value[0+:8];
		valueShifted[32+:8] <= value[32+:8];
		valueShifted[64+:8] <= value[64+:8];
		valueShifted[96+:8] <= value[96+:8];

		//1 byte left shift
		valueShifted [8+:8] <= value[40+:8];
		valueShifted [40+:8] <= value[72+:8];
		valueShifted [72+:8] <= value[104+:8];
		valueShifted [104+:8] <= value[8+:8];
		
		//2 byte left shift
		valueShifted [16+:8] <= value[80+:8];
		valueShifted [48+:8] <= value[112+:8];
		valueShifted [80+:8] <= value[16+:8];
		valueShifted [112+:8] <= value[48+:8];


		//3 byte left shift
		valueShifted [24+:8] <= value[120+:8];
		valueShifted [56+:8] <= value[24+:8];
		valueShifted [88+:8] <= value[56+:8];
		valueShifted [120+:8] <= value[88+:8];

		
		success <= 1;
		end
		else success <= 0;
end
endmodule
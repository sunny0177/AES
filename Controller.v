module Controller(input wire[127:0] keyI, input wire[127:0] initialState, input wire normalEncryption, input wire normalDecryption, input wire decryptionFollowsEncryption, input wire encryptionForRandom, input wire decryptionForRandom, input wire bistMode, input wire clk,
input wire rst, output reg[127:0] plainTextValue,output reg[127:0] cipherTextValue,output reg[31:0] matchedSignature,output reg result
);
 
	reg [127:0] key_byte, valueI, oraI;
	wire [127:0] state_byte;
	reg ecryptionEnable, enable, decryptionEnable, decryptionSecondEnable, oraEnable, startPatternGeneration;
	wire [127:0] state_out_dec, state_out_enc, state_second_dec;
	wire [31:0] state_out_ora;
	wire load, readyE, readyD, resultO, readyK, readyOra;
	
	integer i, j;
	reg enableEncryption, enableDecryption;
	reg flag=0;
	reg [31:0] temp[0:21];
	reg[31:0] generatePattern [0:3];
	
	integer iterate;
	
	reg [31:0] encryptionSignature=32'hBC52CEBF; //Golden signature for encryption
	reg [31:0] decryptionSignature=32'h6081AF79; //Golden signature for decryption
 
 
	AES_encryption AES_TB(key_byte,valueI,clk,rst,ecryptionEnable,state_out_enc,load,readyE);
	AES_decryption SEC_TB(key_byte,state_out_enc,clk,rst,decryptionSecondEnable,state_second_dec,load,readyD);
	AES_decryption DEC_TB(key_byte,valueI,clk,rst,decryptionEnable,state_out_dec,load,readyK);
	ORA o(clk,rst,oraEnable,oraI,state_out_ora,readyOra);
	
		
	always@(posedge clk)begin : break_block
			
	if(j>=62)begin
		disable break_block;
	end	
			
	if(rst)begin
		plainTextValue = 128'h00000000000000000000000000000000;
		cipherTextValue = 128'h00000000000000000000000000000000;
	end
				
	if(flag==0)begin
		startPatternGeneration=1;
		j=0;
		iterate=0;
		temp[0]=32'b11111111111111111111111111111111; /* Default seed value to generate random values */ 
		temp[1]=32'b00000000000000000000000000011111; /* 21 seed values (temp[1] to temp[21]) stored in the memory to generate deterministic patterns */
		temp[2]=32'b00000000000000000000000000001111;
		temp[3]=32'b00000000000000000000000000000111;
		temp[4]=32'b00000000000000000000000000000011;
		temp[5]=32'b00000000000000000000000000000001;
		temp[6]=32'b00000000000000000000001111100000;
		temp[7]=32'b00000000000000000000001111000000;
		temp[8]=32'b00000000000000000000001110000000;
		temp[9]=32'b00000000000000000000001100000000;
		temp[10]=32'b00000000000000000000001000000000;
		temp[11]=32'b00000000000000000000001000000001;
		temp[12]=32'b00000000000000000000001100000011;
		temp[13]=32'b00000000000000000000001110000001;
		temp[14]=32'b00000000000000000000001111000001;
		temp[15]=32'b00000000000000000000001111100001;
		temp[16]=32'b00000000000000000000001111110001;
		temp[17]=32'b00000000000000000000001111111001;
		temp[18]=32'b00000000000000000000001111111101;
		temp[19]=32'b00000000000000000000000000000001;
		temp[20]=32'b00000000000000000000000000000010;
		temp[21]=32'b00000000000000000000000000000100;
		flag=1;
			
	end
	if((normalEncryption===1) && (bistMode===0))begin //Encryption starts
		ecryptionEnable = 1;
		valueI = initialState;
		key_byte = keyI;
		cipherTextValue = state_out_enc;
	end //End of encryption
	else if((normalDecryption===1) && (bistMode===0))begin //Decryption starts
		decryptionEnable = 1;
		valueI = initialState;
		key_byte = keyI;
		plainTextValue = state_out_dec;
	end //End of decryption
	else if((decryptionFollowsEncryption===1) && (bistMode===0))begin //Decryption following Encryption
		ecryptionEnable = 1;
		valueI = initialState;
		key_byte=keyI;
		cipherTextValue = state_out_enc;
		decryptionSecondEnable = 1;
		plainTextValue = state_second_dec;
	end //End after obtaining the actual plain text value
			
	else if(((decryptionForRandom===1) && (bistMode===1)) || ((encryptionForRandom===1) && (bistMode===1)))begin
		//Enables the test mode either for encryption or decryption
		if(startPatternGeneration==1)begin 
			for(i=0;i<4;i=i+1)begin /*Linear-feedback shift register (LFSR)
									  to generate test patterns */
				temp[iterate]={(temp[iterate][31] ^ temp[iterate][25] ^ temp[iterate][22] ^ temp[iterate][21] ^ temp[iterate][15] ^ temp[iterate][11] ^ temp[iterate][10] ^ temp[iterate][9] ^ temp[iterate][7] ^ temp[iterate][6] ^ temp[iterate][4] ^ temp[iterate][3] ^ temp[iterate][1] ^ temp[iterate][0]), temp[iterate][31:1]};
				generatePattern[i]=temp[iterate];
			end
		end
					
		if(encryptionForRandom)
			ecryptionEnable=1;
		else
			decryptionEnable=1;				
			startPatternGeneration=0;
			valueI = {generatePattern[3],generatePattern[2],generatePattern[1],generatePattern[0]};
			key_byte=keyI;
			oraEnable=0;
		if((readyE==1) || (readyK==1))begin
			if(j>=39)begin
				iterate=iterate+1;
			end
							
			oraEnable=1;	
			oraI = encryptionForRandom ? (ecryptionEnable ? state_out_enc : 128'h00000000000000000000000000000000) : (decryptionEnable ? state_out_dec : 128'h00000000000000000000000000000000);
						
			if(encryptionForRandom)
				ecryptionEnable=0;
			else
				decryptionEnable=0;		
				matchedSignature = state_out_ora;
			if((matchedSignature==encryptionSignature) || (matchedSignature==decryptionSignature))begin
			
				result=1; // Correct matching of golden signature and candidate signature
				j=j+1;
			end
			else begin
				result=0; // Mismatch of golden signature and candidate signature
			end
				startPatternGeneration=1;
				j=j+1;
			end
					
						
			end
				
	end //End always
 
 endmodule

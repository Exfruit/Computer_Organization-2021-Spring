//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        2010/8/16
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o, 

	Jump_o, 
	MemRead_o,
	MemWrite_o,
	MemtoReg_o,

	Rtype_o,
	jal_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;

output		   Jump_o;
output		   MemRead_o;
output  	   MemWrite_o;
output		   MemtoReg_o;

output 		   Rtype_o;
output 		   jal_o;
 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg   		   RegDst_o;
reg            Branch_o;

reg 		   Jump_o;
reg    		   MemRead_o;
reg            MemWrite_o;
reg 		   MemtoReg_o;

reg 		   Rtype_o;
reg 		   jal_o;
//Parameter
always @(*) begin
	case(instr_op_i)
		6'b000000 : begin // R-type
			RegWrite_o <= 1;
			ALU_op_o <= 3'b000;
			ALUSrc_o <= 0;
			RegDst_o <= 1;
			Branch_o <= 0;
			Jump_o <= 0;
			MemRead_o <= 0;
			MemWrite_o <= 0;
			MemtoReg_o <= 0;

			jal_o <= 0;	
			Rtype_o <= 1;
		end

		6'b001000: begin // addi
			RegWrite_o <= 1;
			ALU_op_o <= 3'b010; 
			ALUSrc_o <= 1;
			RegDst_o <= 0;
			Branch_o <= 0;
			Jump_o <= 0;
			MemRead_o <= 0;
			MemWrite_o <= 0;
			MemtoReg_o <= 0;

			jal_o <= 0;
			Rtype_o <= 0;

		end	

		6'b001010: begin // slti
			RegWrite_o <= 1;
			ALU_op_o <= 3'b011;
			ALUSrc_o <= 1;
			RegDst_o <= 0;
			Branch_o <= 0;

			Jump_o <= 0;
			MemRead_o <= 0;
			MemWrite_o <= 0;
			MemtoReg_o <= 0;

			jal_o <= 0;
			Rtype_o <= 0;

		end

		6'b000100: begin // beq
			RegWrite_o <= 0;
			ALU_op_o <= 3'b100;
			ALUSrc_o <= 0;
			RegDst_o <= 0;
			Branch_o <= 1;

			Jump_o <= 0;
			MemRead_o <= 0;
			MemWrite_o <= 0;
			MemtoReg_o <= 0;

			jal_o <= 0;	
			Rtype_o <= 0;

		end

		6'b100011: begin // lw
			RegWrite_o <= 1;
			ALU_op_o <= 3'b111;
			ALUSrc_o <= 1;
			RegDst_o <= 0;
			Branch_o <= 0;
			Jump_o <= 0;
			MemRead_o <= 1;
			MemWrite_o <= 0;
			MemtoReg_o <= 1;

			jal_o <= 0;
			Rtype_o <= 0;
		
		end
		
		6'b101011: begin // sw
			RegWrite_o <= 0;
			ALU_op_o <= 3'b111;
			ALUSrc_o <= 1;
			RegDst_o <= 0;
			Branch_o <= 0;
			Jump_o <= 0;
			MemRead_o <= 0;
			MemWrite_o <= 1;
			MemtoReg_o <= 0;

			jal_o <= 0;
			Rtype_o <= 0;
		
		end
		
		6'b000010: begin // jump
			RegWrite_o <= 0;
			ALU_op_o <= 3'b111;
			ALUSrc_o <= 0;
			RegDst_o <= 0;
			Branch_o <= 0;
			Jump_o <= 1;
			MemRead_o <= 0;
			MemWrite_o <= 0;
			MemtoReg_o <= 0;

			jal_o <= 0;
			Rtype_o <= 0;
		
		end

		6'b000011: begin // jal
			RegWrite_o <= 1;
			ALU_op_o <= 3'b100;
			ALUSrc_o <= 0;
			RegDst_o <= 0;
			Branch_o <= 0;
			Jump_o <= 1;
			MemRead_o <= 0;
			MemWrite_o <= 0;
			MemtoReg_o <= 0;

			jal_o <= 1;
			Rtype_o <= 0;
			
		end
	
	endcase

end

//Main function

endmodule





                    
                    
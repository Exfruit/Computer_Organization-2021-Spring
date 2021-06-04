//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o,
          jr_i
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
//new
output	           jr_i;     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;
reg		             jr_i;

//Parameter
always @(*) begin
  case(ALUOp_i)
		3'b000 : begin // R-type
      case(funct_i)
        6'b100000 : begin // add
        	ALUCtrl_o <= 4'b0010;
          jr_i <= 0;
        end
        6'b100010 : begin // sub
        	ALUCtrl_o <= 4'b0110;
          jr_i <= 0;
        end
        6'b100100 : begin // and 
        	ALUCtrl_o <= 4'b0000;
          jr_i <= 0;
        end
        6'b100101 : begin // or
        	ALUCtrl_o <= 4'b0001;
          jr_i <= 0;
        end
        6'b101010 : begin // slt
        	ALUCtrl_o <= 4'b0111;
          jr_i <= 0;
        end
        6'b001000 : begin //jr
        	jr_i <= 1;
        	ALUCtrl_o <= 4'b0000;
        end
        6'b011000 : begin //mult
          jr_i <= 0;
          ALUCtrl_o <= 4'b1111;
        end
      endcase
    end
    3'b010 : begin
      ALUCtrl_o <= 4'b0010; // addi
      jr_i <= 0;
    end
    3'b011 : begin
      ALUCtrl_o <= 4'b0111; // slti
      jr_i <= 0;
    end
    3'b100 : begin
      ALUCtrl_o <= 4'b0110; // beq
      jr_i <= 0;
    end
    3'b111 : begin
      ALUCtrl_o <= 4'b0010; // lw, sw
      jr_i <= 0;
    end 
    default : jr_i <= 0;
  endcase
end
       
//Select exact operation

endmodule     





                    
                    
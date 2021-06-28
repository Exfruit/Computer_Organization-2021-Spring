`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    15:15:11 08/18/2013
// Design Name:
// Module Name:    alu
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module alu(
           clk,           // system clock              (input)
           rst_n,         // negative reset            (input)
           src1,          // 32 bits source 1          (input)
           src2,          // 32 bits source 2          (input)
           ALU_control,   // 4 bits ALU control input  (input)
           result,        // 32 bits result            (output)
           zero,          // 1 bit when the output is 0, zero must be set (output)
           cout,          // 1 bit carry out           (output)
           overflow       // 1 bit overflow            (output)
           );

input           clk;
input           rst_n;
input  [32-1:0] src1;
input  [32-1:0] src2;
input   [4-1:0] ALU_control;

output [32-1:0] result;
output          zero;
output          cout;
output          overflow;

reg    [32-1:0] result;
reg             zero;
reg             cout;
reg             overflow;

wire [32-1:0] temp_result;
wire [32-1:0] carry;
wire [32-1:0] slt;

assign slt = src1 - src2;

alu_top alu0(
               src1[0],       //1 bit source 1 (input)
               src2[0],       //1 bit source 2 (input)
               slt[31],       //1 bit less     (input)
               ALU_control[3],   //1 bit A_invert (input)
               ALU_control[2],   //1 bit B_invert (input)
               ALU_control[2],        //1 bit carry in (input)
               ALU_control[1:0],  //operation      (input)
               temp_result[0],     //1 bit result   (output)
               carry[0],       //1 bit carry out(output)
);

alu_top alu1(
               src1[1],       //1 bit source 1 (input)
               src2[1],       //1 bit source 2 (input)
               1'b0,       //1 bit less     (input)
               ALU_control[3],   //1 bit A_invert (input)
               ALU_control[2],   //1 bit B_invert (input)
               carry[0],        //1 bit carry in (input)
               ALU_control[1:0],  //operation      (input)
               temp_result[1],     //1 bit result   (output)
               carry[1],       //1 bit carry out(output)
);

alu_top alu2(
               src1[2],
               src2[2],
               1'b0,
               ALU_control[3],
               ALU_control[2],
               carry[1],
               ALU_control[1:0],
               temp_result[2],
               carry[2],
);

alu_top alu3(
               src1[3],
               src2[3],
               1'b0,
               ALU_control[3],
               ALU_control[2],
               carry[2],
               ALU_control[1:0],
               temp_result[3],
               carry[3],
);

alu_top alu4(
               src1[4],
               src2[4],
               1'b0,
               ALU_control[3],
               ALU_control[2],
               carry[3],
               ALU_control[1:0],
               temp_result[4],
               carry[4],
);

alu_top alu5(
               src1[5],
               src2[5],
               1'b0,
               ALU_control[3],
               ALU_control[2],
               carry[4],
               ALU_control[1:0],
               temp_result[5],
               carry[5],
);

alu_top alu6(
               src1[6],
               src2[6],
               1'b0,
               ALU_control[3],
               ALU_control[2],
               carry[5],
               ALU_control[1:0],
               temp_result[6],
               carry[6],
);

alu_top alu7(
               src1[7],
               src2[7],
               1'b0,
               ALU_control[3],
               ALU_control[2],
               carry[6],
               ALU_control[1:0],
               temp_result[7],
               carry[7],
);

alu_top alu8(
               src1[8],
               src2[8],
               1'b0,
               ALU_control[3],
               ALU_control[2],
               carry[7],
               ALU_control[1:0],
               temp_result[8],
               carry[8],
);

alu_top alu9(
               src1[9],
               src2[9],
               1'b0,
               ALU_control[3],
               ALU_control[2],
               carry[8],
               ALU_control[1:0],
               temp_result[9],
               carry[9],
);

alu_top alu10(
               src1[10],
               src2[10],
               1'b0,
               ALU_control[3],
               ALU_control[2],
               carry[9],
               ALU_control[1:0],
               temp_result[10],
               carry[10],
);

alu_top alu11(
               src1[11],
               src2[11],
               1'b0,
               ALU_control[3],
               ALU_control[2],
               carry[10],
               ALU_control[1:0],
               temp_result[11],
               carry[11],
);

alu_top alu12(
               src1[12],
               src2[12],
               1'b0,
               ALU_control[3],
               ALU_control[2],
               carry[11],
               ALU_control[1:0],
               temp_result[12],
               carry[12],
);

alu_top alu13(
               src1[13],
               src2[13],
               1'b0,
               ALU_control[3],
               ALU_control[2],
               carry[12],
               ALU_control[1:0],
               temp_result[13],
               carry[13],
);

alu_top alu14(
               src1[14],
               src2[14],
               1'b0,
               ALU_control[3],
               ALU_control[2],
               carry[13],
               ALU_control[1:0],
               temp_result[14],
               carry[14],
);

alu_top alu15(
               src1[15],
               src2[15],
               1'b0,
               ALU_control[3],
               ALU_control[2],
               carry[14],
               ALU_control[1:0],
               temp_result[15],
               carry[15],
);

alu_top alu16(
               src1[16],
               src2[16],
               1'b0,
               ALU_control[3],
               ALU_control[2],
               carry[15],
               ALU_control[1:0],
               temp_result[16],
               carry[16],
);

alu_top alu17(
               src1[17],
               src2[17],
               1'b0,
               ALU_control[3],
               ALU_control[2],
               carry[16],
               ALU_control[1:0],
               temp_result[17],
               carry[17],
);

alu_top alu18(
               src1[18],
               src2[18],
               1'b0,
               ALU_control[3],
               ALU_control[2],
               carry[17],
               ALU_control[1:0],
               temp_result[18],
               carry[18],
);

alu_top alu19(
               src1[19],
               src2[19],
               1'b0,
               ALU_control[3],
               ALU_control[2],
               carry[18],
               ALU_control[1:0],
               temp_result[19],
               carry[19],
);

alu_top alu20(
               src1[20],
               src2[20],
               1'b0,
               ALU_control[3],
               ALU_control[2],
               carry[19],
               ALU_control[1:0],
               temp_result[20],
               carry[20],
);

alu_top alu21(
               src1[21],
               src2[21],
               1'b0,
               ALU_control[3],
               ALU_control[2],
               carry[20],
               ALU_control[1:0],
               temp_result[21],
               carry[21],
);

alu_top alu22(
               src1[22],
               src2[22],
               1'b0,
               ALU_control[3],
               ALU_control[2],
               carry[21],
               ALU_control[1:0],
               temp_result[22],
               carry[22],
);

alu_top alu23(
               src1[23],
               src2[23],
               1'b0,
               ALU_control[3],
               ALU_control[2],
               carry[22],
               ALU_control[1:0],
               temp_result[23],
               carry[23],
);

alu_top alu24(
               src1[24],
               src2[24],
               1'b0,
               ALU_control[3],
               ALU_control[2],
               carry[23],
               ALU_control[1:0],
               temp_result[24],
               carry[24],
);

alu_top alu25(
               src1[25],
               src2[25],
               1'b0,
               ALU_control[3],
               ALU_control[2],
               carry[24],
               ALU_control[1:0],
               temp_result[25],
               carry[25],
);

alu_top alu26(
               src1[26],
               src2[26],
               1'b0,
               ALU_control[3],
               ALU_control[2],
               carry[25],
               ALU_control[1:0],
               temp_result[26],
               carry[26],
);

alu_top alu27(
               src1[27],
               src2[27],
               1'b0,
               ALU_control[3],
               ALU_control[2],
               carry[26],
               ALU_control[1:0],
               temp_result[27],
               carry[27],
);

alu_top alu28(
               src1[28],
               src2[28],
               1'b0,
               ALU_control[3],
               ALU_control[2],
               carry[27],
               ALU_control[1:0],
               temp_result[28],
               carry[28],
);

alu_top alu29(
               src1[29],
               src2[29],
               1'b0,
               ALU_control[3],
               ALU_control[2],
               carry[28],
               ALU_control[1:0],
               temp_result[29],
               carry[29],
);

alu_top alu30(
               src1[30],
               src2[30],
               1'b0,
               ALU_control[3],
               ALU_control[2],
               carry[29],
               ALU_control[1:0],
               temp_result[30],
               carry[30],
);

alu_top alu31(
               src1[31],
               src2[31],
               1'b0,
               ALU_control[3],
               ALU_control[2],
               carry[30],
               ALU_control[1:0],
               temp_result[31],
               carry[31],
);

always@( posedge clk or negedge rst_n ) 
begin
  if(!rst_n) begin
     
     
  end
  else begin 
      result <= temp_result;
      zero <= !(temp_result[0] | temp_result[1] | temp_result[2] | temp_result[3] | temp_result[4] |  
                        temp_result[5] | temp_result[6] | temp_result[7] | temp_result[8] | temp_result[9] |   
                        temp_result[10] | temp_result[11] | temp_result[12] | temp_result[13] |  
                        temp_result[14] | temp_result[15] | temp_result[16] | temp_result[17] |  
                        temp_result[18] | temp_result[19] | temp_result[20] | temp_result[21] | 
                        temp_result[22] | temp_result[23] | temp_result[24] | temp_result[25] | 
                        temp_result[26] | temp_result[27] | temp_result[28] | temp_result[29] |  
                        temp_result[30] | temp_result[31]);
   
      cout = ((ALU_control==4'b0010) | (ALU_control==4'b0110)) ? carry[31] : 0;
      overflow = ( (ALU_control==4'b0010) & src1[31] & src2[31] & ~result[31]) ? 1 
            :( (ALU_control==4'b0010) & ~src1[31] & ~src2[31] & result[31]) ? 1 
            :( (ALU_control==4'b0110) & src1[31] & ~src2[31] & ~(result[31])) ? 1 
            :( (ALU_control==4'b0110) & ~src1[31] & src2[31] & result[31]) ? 1 
            : 0;
       
  end
end

endmodule

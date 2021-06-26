`timescale 1ns / 1ps
//Subject:     CO project 4 - Pipe Register
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_Reg(
    clk_i,
    rst_i,
    enb_write,
    data_i,
    data_o
    );
					
parameter size = 0;

input   clk_i;		  
input   rst_i;
input   enb_write;
input   [size-1:0] data_i;
output reg  [size-1:0] data_o;
	  
always@(posedge clk_i) begin
    if(~rst_i)
        data_o <= 0;
    else if (enb_write)
        data_o <= data_i;
end

endmodule	
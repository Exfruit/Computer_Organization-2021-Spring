//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
`timescale 1ns/1ps
module Simple_Single_CPU(
        clk_i,
		rst_i
		);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles

wire [32-1:0]   PC_src;
wire [32-1:0]   PC_addr;
wire [32-1:0]   PC_add_4;

wire [32-1:0]   instr;
wire [32-1:0]   S_Extend;

wire [32-1:0]   RSdata;
wire [32-1:0]   RTdata;
wire [32-1:0]   ALU_result;

wire zero;

wire [32-1:0]   Shift_Left_2;

wire [32-1:0]   Mux_ALU;
wire [5-1:0]    MUX_Reg;
wire [32-1:0]   Adder_to_Mux;

//Instruction
wire [6-1:0]    op_code;
wire [5-1:0]    rs_addr;
wire [5-1:0]    rt_addr;
wire [5-1:0]    rd_addr;
wire [5-1:0]    shamt;
wire [6-1:0]    funcode;

//control
wire     RegWrite;
wire     [3-1:0]    ALU_op;
wire     ALUSrc;
wire     RegDst;
wire     Branch;

wire [4-1:0] ALU_Ctrl;

//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(PC_src) , // PC   
	    .pc_out_o(PC_addr) 
	    );
	
Adder Adder1(
        .src1_i(PC_addr), // PC += 4     
	    .src2_i(32'd4),     
	    .sum_o(PC_add_4)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(PC_addr),  
            .instr_o({op_code, rs_addr, rt_addr, rd_addr, shamt, funcode})    
            );

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(rt_addr),
        .data1_i(rd_addr),
        .select_i(RegDst),
        .data_o(MUX_Reg)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(rs_addr) ,  // Read register 1
        .RTaddr_i(rt_addr) ,  // Read register 2
        .RDaddr_i(MUX_Reg) ,  // Write register
        .RDdata_i(ALU_result)  ,  // Write data
        .RegWrite_i (RegWrite), 
        .RSdata_o(RSdata) ,  // Read data 1
        .RTdata_o(RTdata)    // Read data 2 
        );
	
Decoder Decoder(
        .instr_op_i(op_code), //Control
	    .RegWrite_o(RegWrite), 
	    .ALU_op_o(ALU_op),   
	    .ALUSrc_o(ALUSrc),   
	    .RegDst_o(RegDst),   
		.Branch_o(Branch)   
	    );

ALU_Ctrl AC(
        .funct_i(funcode),   
        .ALUOp_i(ALU_op),   
        .ALUCtrl_o(ALU_Ctrl) 
        );
	
Sign_Extend SE(
        .data_i({rd_addr, shamt, funcode}),
        .data_o(S_Extend)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(RTdata),
        .data1_i(S_Extend),
        .select_i(ALUSrc),
        .data_o(Mux_ALU)
        );	
		
ALU ALU(
        .src1_i(RSdata),
	    .src2_i(Mux_ALU),
	    .ctrl_i(ALU_Ctrl),
	    .result_o(ALU_result),
		.zero_o(zero)
	    );
		
Adder Adder2(
        .src1_i(PC_add_4),     
	    .src2_i(Shift_Left_2),     
	    .sum_o(Adder_to_Mux)      
	    );
		
Shift_Left_Two_32 Shifter(
        .data_i(S_Extend),
        .data_o(Shift_Left_2)
        ); 		
		
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(PC_add_4),
        .data1_i(Adder_to_Mux),
        .select_i(zero & Branch),
        .data_o(PC_src)
        );	

endmodule
		  



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
module Simple_Single_CPU(
        clk_i,
		rst_i
		);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles
wire [32-1:0]	next_PC;
wire [32-1:0]	PC_addr;
wire [32-1:0]	PC_addr_4;

wire [6-1:0]	opcode;
wire [5-1:0]	rs_addr;
wire [5-1:0]	rt_addr;
wire [5-1:0]	rd_addr;
wire [5-1:0]	shamt;
wire [6-1:0]	funcode;

wire [4-1:0]	ALUCtrl;
wire [3-1:0]	ALUOp;
wire 			ALUSrc;
wire			RegDst;
wire			RegWrite;
wire			Branch;
wire			Jump;
wire			MemRead;
wire			MemWrite;
wire			MemToReg;
wire   			jr;
wire    		jal;

wire [5-1:0]	to_jal;
wire [5-1:0]	MUX_Reg;

wire [32-1:0]	WriteData;
wire [32-1:0]	RS_data;
wire [32-1:0]	RT_data;

wire [32-1:0]	S_Extend;
wire [32-1:0]	MUX_ALU;
wire [32-1:0]	ALU_Result;
wire 			zero;
wire [32-1:0]	Readdata;
wire [32-1:0]	Shift_Left_2;
wire [32-1:0]	Addr_MUX;
wire [32-1:0]	to_jr;
wire [32-1:0]	MUX_MUX;
wire [32-1:0]	WriteData_src;
wire 			and_MUX;

assign and_MUX = zero & Branch;
//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(next_PC) ,   
	    .pc_out_o(PC_addr) 
	    );
	
Adder Adder1(
        .src1_i(PC_addr),     
	    .src2_i(32'd4),     
	    .sum_o(PC_addr_4)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(PC_addr),  
	    .instr_o({opcode, rs_addr, rt_addr, rd_addr, shamt, funcode})    
	    );

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(rt_addr),
        .data1_i(rd_addr),
        .select_i(RegDst),
        .data_o(to_jal)
        );	
		
Reg_File Registers(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(rs_addr) ,  
        .RTaddr_i(rt_addr) ,  
        .RDaddr_i(MUX_Reg) ,  
        .RDdata_i(WriteData)  , 
        .RegWrite_i (RegWrite),
        .RSdata_o(RS_data) ,  
        .RTdata_o(RT_data)   
        );

MUX_2to1 #(.size(5)) MUXjal(
		.data0_i(to_jal),
		.data1_i(5'd31),
		.select_i(jal),
		.data_o(MUX_Reg)
		);
	
Decoder Decoder(
        .instr_op_i(opcode),
		.RegWrite_o(RegWrite),
		.ALU_op_o(ALUOp),
		.ALUSrc_o(ALUSrc),
		.RegDst_o(RegDst),
		.Branch_o(Branch),

		.Jump_o(Jump),   
		.MemRead_o(MemRead),  
		.MemWrite_o(MemWrite), 
		.MemtoReg_o(MemToReg),

		.jal_o(jal)
		);

ALU_Ctrl AC(
        .funct_i(funcode),   
        .ALUOp_i(ALUOp),   
        .ALUCtrl_o(ALUCtrl), 
        .jr_i(jr)
        );
	
Sign_Extend SE(
        .data_i({rd_addr, shamt, funcode}),
        .data_o(S_Extend)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(RT_data),
        .data1_i(S_Extend),
        .select_i(ALUSrc),
        .data_o(MUX_ALU)
        );	
		
ALU ALU(
        .src1_i(RS_data),
	    .src2_i(MUX_ALU),
	    .ctrl_i(ALUCtrl),
	    .result_o(ALU_Result),
		.zero_o(zero)
	    );
	
Data_Memory Data_Memory(
	.clk_i(clk_i),
	.addr_i(ALU_Result),
	.data_i(RT_data),
	.MemRead_i(MemRead),
	.MemWrite_i(MemWrite),
	.data_o(Readdata)
	);
	
Adder Adder2(
        .src1_i(Shift_Left_2),     
	    .src2_i(PC_addr_4),     
	    .sum_o(Addr_MUX)      
	    );
		
Shift_Left_Two_32 Shifter(
        .data_i(S_Extend),
        .data_o(Shift_Left_2)
        ); 		

MUX_2to1 #(.size(32)) MUX_to_jr(
	.data0_i(MUX_MUX),
	.data1_i({PC_addr[31:28], rs_addr, rt_addr, rd_addr, shamt, funcode, 2'b00}),
	.select_i(Jump),
	.data_o(to_jr)
	);

MUX_2to1 #(.size(32)) MUX_MUX_MUX(
	.data0_i(PC_addr_4),
	.data1_i(Addr_MUX),
	.select_i(and_MUX),
	.data_o(MUX_MUX)
	);

MUX_2to1 #(.size(32)) MUX_WriteData_src(
	.data0_i(ALU_Result),
	.data1_i(Readdata),
	.select_i(MemToReg),
	.data_o(WriteData_src)
	);

MUX_2to1 #(.size(32)) MUX_WriteData(
	.data0_i(WriteData_src),
	.data1_i(PC_addr_4),
	.select_i(jal),
	.data_o(WriteData)
	);
		
MUX_2to1 #(.size(32)) Mux_PC_Source(
    .data0_i(to_jr),
    .data1_i(RS_data),
    .select_i(jr),
    .data_o(next_PC)
    );	

endmodule
		  



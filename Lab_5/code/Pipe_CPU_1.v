`timescale 1ns / 1ps
//Subject:     CO project 4 - Pipe CPU 1
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_CPU_1(
    clk_i,
    rst_i
    );
    
/****************************************
I/O ports
****************************************/
input clk_i;
input rst_i;

/****************************************
Internal signal
****************************************/
wire [32-1:0]	next_PC;
wire [32-1:0]	PC_addr;
wire [32-1:0]	PC_addr_4;
wire            PCSrc;
wire [32-1:0]   instr_in_IF;

/**** IF stage ****/

wire [32-1:0]   PC_addr_in_ID;
///instruction parts
wire [6-1:0]	opcode; 
wire [5-1:0]	rs_addr; 
wire [5-1:0]	rt_addr;
wire [5-1:0]	rd_addr;
wire [5-1:0]	shamt;
wire [6-1:0]	funcode;

/**** ID stage ****/
wire [32-1:0]   RS_data;
wire [32-1:0]   RT_data;
wire [32-1:0]   S_Extend;

//wb 
wire [2-1:0]    WB_in_ID;
wire [3-1:0]    MEM_in_ID;
wire [5-1:0]    EX_in_ID;
//control signal


/**** EX stage ****/
wire [2-1:0]    WB_in_EX;
wire [3-1:0]    MEM_in_EX;

wire            RegDst;
wire [3-1:0]    ALUOp;
wire            ALUSrc;
wire [32-1:0]   PC_addr_in_EX;
wire [32-1:0]   RS_data_in_EX;

wire [32-1:0]   RT_data_in_EX;
wire [32-1:0]   S_Extend_in_EX;
wire [5-1:0]    rt_addr_in_EX;
wire [5-1:0]    rd_addr_in_EX;
wire [5-1:0]    rs_addr_in_EX;

wire [32-1:0]   Shift_Left_2;
wire [32-1:0]   PC_addr_added;
wire [32-1:0]   MUX_ALU;
//control signal
wire            zero_in_EX;
wire [32-1:0]   ALU_Result_in_EX;
wire [5-1:0]    reg_in_EX;	
wire [4-1:0]    ALU_Ctrl;

/**** MEM stage ****/
wire            Branch;
wire            MemRead;
wire            MemWrite;
wire            zero_in_MEM;
wire [2-1:0]    WB_in_MEM;
wire [5-1:0]    reg_in_MEM;
wire [32-1:0]   PC_addr_in_MEM;
wire [32-1:0]   ALU_Result_in_MEM;
wire [32-1:0]   RT_data_in_MEM;
//control signal
wire [32-1:0]   Readdata_in_MEM;
wire            RegWrite;
wire            MemtoReg;
wire [32-1:0]   Readdata_in_WB;
wire [32-1:0]   ALU_Result_in_WB;
wire [5-1:0]    reg_in_WB;
/**** WB stage ****/
wire [32-1:0]   result_WB;
//control signal

// Forwarding Signals
wire [32-1:0]   RS_MUX;
wire [32-1:0]   RT_MUX;
wire [2-1:0]    rsForward;
wire [2-1:0]    rtForward;

// hazard detection unit

wire [10-1:0]   IDEX_ctrl;
wire            PCWrite;
wire            IFIDWrite;
wire            IDFlush;
wire            IFFlush;
wire            EXFlush;
wire [5-1:0]    EXMEM_ctrl;
/****************************************
Instantiate modules
****************************************/
assign PCSrc = Branch & zero_in_MEM;
//Instantiate the components in IF stage

MUX_2to1 #(.size(32))Mux0(
    .data0_i(PC_addr_4),
    .data1_i(PC_addr_in_MEM),
    .select_i(PCSrc),
    .data_o(next_PC)
);

ProgramCounter PC(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .PCWrite_i(PCWrite),
    .pc_in_i(next_PC),
    .pc_out_o(PC_addr)
);

Hazard_detection_unit HDU(
    .IFID_rs(rs_addr),
    .IFID_rt(rt_addr),
    .IDEX_rt(rt_addr_in_EX),
    .MEM(MEM_in_EX), 
    .PCSrc(PCSrc),

    .IFFlush(IFFlush),
    .IDFlush(IDFlush), 
    .EXFlush(EXFlush), 
    .PCWrite(PCWrite),
    .IFIDWrite(IFIDWrite)
);

Instruction_Memory IM(
    .addr_i(PC_addr),
    .instr_o(instr_in_IF)
);

			
Adder Add_pc(
    .src1_i(PC_addr),
    .src2_i(32'd4),
    .sum_o(PC_addr_4)
);

		
Pipe_Reg #(.size(32 + 32)) IF_ID(       //N is the total length of input/output
    .clk_i(clk_i), 
    .rst_i(rst_i & !IFFlush),
    .enb_write(IFIDWrite),
    .data_i({PC_addr_4, instr_in_IF}),  //32, 32
    .data_o({PC_addr_in_ID, {opcode, rs_addr, rt_addr, rd_addr, shamt, funcode} })
);



//Instantiate the components in ID stage
Reg_File RF(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .RSaddr_i(rs_addr),
    .RTaddr_i(rt_addr),
    .RDaddr_i(reg_in_WB),
    .RDdata_i(result_WB),
    .RegWrite_i(RegWrite),
    .RSdata_o(RS_data),
    .RTdata_o(RT_data)
);

Decoder Control(
    .instr_op_i(opcode),
    .RegWrite_o(WB_in_ID[1]),
    .ALU_op_o({EX_in_ID[3], EX_in_ID[2], EX_in_ID[1]}),
    .ALUSrc_o(EX_in_ID[0]),
    .RegDst_o(EX_in_ID[4]),
    .Branch_o(MEM_in_ID[2]),
    .Jump_o(),
    .MemRead_o(MEM_in_ID[1]),
    .MemWrite_o(MEM_in_ID[0]),
    .MemtoReg_o(WB_in_ID[0]),
    .jal_o()
);

Sign_Extend Sign_Extend(
    .data_i({rd_addr, shamt, funcode}),
    .data_o(S_Extend)
);	


MUX_2to1 #(.size(10) ) IDEX_Flush_ctrl(
    .data0_i({WB_in_ID, MEM_in_ID, EX_in_ID}),
    .data1_i(10'b0),
    .select_i(IDFlush),
    .data_o(IDEX_ctrl)
);


Pipe_Reg #(.size(2 + 3 + 5 + 32 + 32 + 32 + 32 + 5 + 5 + 5)) ID_EX(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .enb_write(1'b1),
    .data_i({
        IDEX_ctrl, PC_addr_in_ID, RS_data,      //2, 3, 5, 32, 32, 32, 32, 5, 5, 5, 5
            RT_data, S_Extend, rs_addr, rt_addr, rd_addr
    }),
              
    .data_o({
        WB_in_EX, MEM_in_EX, {RegDst, ALUOp, ALUSrc}, 
            PC_addr_in_EX, RS_data_in_EX, RT_data_in_EX, S_Extend_in_EX, 
                rs_addr_in_EX, rt_addr_in_EX, rd_addr_in_EX
    })
);


//Instantiate the components in EX stage	   
Shift_Left_Two_32 Shifter(
    .data_i(S_Extend_in_EX),
    .data_o(Shift_Left_2)
);

ALU ALU(
    .src1_i(RS_MUX),
	.src2_i(MUX_ALU),
	.ctrl_i(ALU_Ctrl),
	.result_o(ALU_Result_in_EX),
	.zero_o(zero_in_EX)
);

MUX_2to1 #(.size(32)) Mux1(
    .data0_i(RT_MUX),
    .data1_i(S_Extend_in_EX),
    .select_i(ALUSrc),
    .data_o(MUX_ALU)
);
    		
ALU_Ctrl ALU_Control(
    .funct_i(S_Extend_in_EX[5:0]),
    .ALUOp_i(ALUOp),
    .ALUCtrl_o(ALU_Ctrl),
	.jr_i()
);

MUX_2to1 #(.size(5)) Mux2(
    .data0_i(rt_addr_in_EX),
    .data1_i(rd_addr_in_EX),
    .select_i(RegDst),
    .data_o(reg_in_EX)
);

Forwarding_unit FU(
    .IDEX_rs(rs_addr_in_EX),
    .IDEX_rt(rt_addr_in_EX),
    .EXMEM_WB(WB_in_MEM),
    .MEMWB_WB({RegWrite, MemtoReg}),
    .EXMEM_rd(reg_in_MEM),
    .MEMWB_rd(reg_in_WB),
    .rsForward(rsForward),
    .rtForward(rtForward)
);

MUX_3to1 #(.size(32)) rsMux(
    .data0_i(RS_data_in_EX),
    .data1_i(ALU_Result_in_MEM),
    .data2_i(result_WB),
    .select_i(rsForward),
    .data_o(RS_MUX)
);

MUX_3to1 #(.size(32)) rtMux(
    .data0_i(RT_data_in_EX),
    .data1_i(ALU_Result_in_MEM),
    .data2_i(result_WB),
    .select_i(rtForward),
    .data_o(RT_MUX)
);

MUX_2to1 #(.size(5)) EXMEM_Flush_ctrl(
    .data0_i({WB_in_EX, MEM_in_EX}),
    .data1_i(5'b0),
    .select_i(EXFlush),
    .data_o(EXMEM_ctrl)
);

Adder Add_pc_branch(
    .src1_i(PC_addr_in_EX),
	.src2_i(Shift_Left_2),
	.sum_o(PC_addr_added)
);

Pipe_Reg #(.size(2 + 3 + 32 + 1 + 32 + 32 + 5)) EX_MEM(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .enb_write(1'b1),
    .data_i({
        EXMEM_ctrl, PC_addr_added, zero_in_EX,      //2, 3, 32, 1, 32, 32, 5
            ALU_Result_in_EX, RT_MUX, reg_in_EX
    }),      
    .data_o({
        WB_in_MEM, {Branch, MemRead, MemWrite}, PC_addr_in_MEM, zero_in_MEM, 
            ALU_Result_in_MEM, RT_data_in_MEM, reg_in_MEM
    })
);


//Instantiate the components in MEM stage
Data_Memory DM(
    .clk_i(clk_i),
    .addr_i(ALU_Result_in_MEM),
    .data_i(RT_data_in_MEM),
    .MemRead_i(MemRead),
    .MemWrite_i(MemWrite),
    .data_o(Readdata_in_MEM)
);



Pipe_Reg #(.size(2 + 32 + 32 + 5)) MEM_WB(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .enb_write(1'b1),
    .data_i({
        WB_in_MEM, Readdata_in_MEM,     //2, 32, 32, 5
            ALU_Result_in_MEM, reg_in_MEM
    }),    
    .data_o({
        {RegWrite, MemtoReg}, Readdata_in_WB, 
            ALU_Result_in_WB, reg_in_WB
    })
);


//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) Mux3(
    .data0_i(ALU_Result_in_WB),
    .data1_i(Readdata_in_WB),
    .select_i(MemtoReg),
    .data_o(result_WB)
);

/****************************************
signal assignment
****************************************/

endmodule


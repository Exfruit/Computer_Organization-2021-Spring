module Hazard_detection_unit(
    IFID_rs,
    IFID_rt,
    IDEX_rt, 
    MEM, 
    PCSrc, 
    
    IFFlush, 
    IDFlush, 
    EXFlush, 
    PCWrite, 
    IFIDWrite
);

input [5-1:0]     IFID_rs;
input [5-1:0]     IFID_rt;
input [5-1:0]     IDEX_rt;
input [3-1:0]     MEM;
input             PCSrc;

output reg        IFFlush;
output reg        IDFlush;
output reg        EXFlush;
output reg        PCWrite;
output reg        IFIDWrite;

always@(*) begin
    if (PCSrc) begin
        IFFlush <= 1;       //branch
        IDFlush <= 1;
        EXFlush <= 1;       
        PCWrite <= 1;
        IFIDWrite <= 1;
    end

    else if ((IFID_rs == IDEX_rt || IFID_rt == IDEX_rt) && MEM[1]) begin
        IFFlush <= 0;       //load-use
        IDFlush <= 0;
        EXFlush <= 0;      
        PCWrite <= 0;       //stall
        IFIDWrite <= 0;
    end

    else begin
        IFFlush <= 0;       //Rtype
        IDFlush <= 0;
        EXFlush <= 0;
        PCWrite <= 1;       //no stall
        IFIDWrite <= 1;
    end

end     
endmodule
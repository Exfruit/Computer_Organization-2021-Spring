module Forwarding_unit(
    IDEX_rs,
    IDEX_rt,
    EXMEM_WB,
    MEMWB_WB,
    EXMEM_rd,
    MEMWB_rd,
    
    rsForward,
    rtForward
);

input [5-1:0]   IDEX_rs;
input [5-1:0]   IDEX_rt;
input [2-1:0]   EXMEM_WB;
input [2-1:0]   MEMWB_WB;
input [5-1:0]   EXMEM_rd;
input [5-1:0]   MEMWB_rd;

output reg [2-1:0]  rsForward;
output reg [2-1:0]  rtForward;

always@(*) begin

    if (EXMEM_WB[1] && EXMEM_rd != 0 && (EXMEM_rd == IDEX_rs)) begin
        rsForward <= 2'b01;
    end 

    if (EXMEM_WB[1] && EXMEM_rd != 0 && (EXMEM_rd == IDEX_rt)) begin          
        rtForward <= 2'b01;
    end
        
    if (MEMWB_WB[1] && MEMWB_rd != 0 && (MEMWB_rd == IDEX_rs)) begin
        rsForward <= 2'b10;
    end
   
    if (MEMWB_WB[1] && MEMWB_rd != 0 && (MEMWB_rd == IDEX_rt)) begin
        rtForward <= 2'b10;
    end
     
    if ((MEMWB_rd != IDEX_rs) && (EXMEM_rd != IDEX_rs)) begin
        rsForward <= 2'b00;
    end
 
    if ((MEMWB_rd != IDEX_rt) && (EXMEM_rd != IDEX_rt)) begin
        rtForward <= 2'b00;
    end
            
end 
          
endmodule
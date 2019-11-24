//////////////////////////////////////////////////////////////////////////////////
// NanoXERA CPU
// Antonio Sánchez
//
// OPCODES															FLA  A2A  MWR  ALO  PLO  ALU
// LD    Load Address A on A	A->Address  InData->A    0    1    0    0    0   xxx
// LDI   Load Inmediate on A                           0    0    0    0    0   xxx
// GOTO  Inmediate to PC                               0    0    0    0    1   xxx
// STI   Store A on inmediate Address                  0    1    1    0    0   xxx
// GOTOZ Inmediate to PC if A=0                        1    1    0    0    1   xxx
// GOTOC Inmediate to PC if Carry bit                  1    0    0    0    1   xxx
// ADDI  A+Inmediate to A                              0    0    0    1    0   000
// SUBI  A-inmediate to A                              0    0    0    1    0   001
// ADCI  A+inmediate+Carry to A                        0    0    0    1    0   010
// RASA  Arithmetic Right Shift A                      0    0    0    1    0   011
// LCSA  Carry Left Shift A                            0    0    0    1    0   100
// ANDI  A-inmediate to A                              0    0    0    1    0   101
// ORI   A-inmediate to A                              0    0    0    1    0   110
// XORI  A-inmediate to A                              0    0    0    1    0   111
//////////////////////////////////////////////////////////////////////////////////
`define    AluOP    IR[2:0]
`define    PCLoad   IR[3]
`define    ALoad    IR[4]
`define    MemWrite IR[5]
`define    A2Add    IR[6]
`define    Flags    IR[7]

module NanoXERA(
	input clk,
	input [7:0]indata,
	output reg [7:0]A,
	output [7:0]address,
	output we 
    );
	 
reg  [7:0] PC=8'h0;
reg  [7:0] IR=8'h0;
reg        IREnable=1'h0;
reg        Carry=1'h0;

assign address=(`MemWrite)?indata:
               (`Flags)?(`A2Add)?(A==8'h0)?indata:PC:
					(Carry)?indata:PC:
					(`A2Add)?A:PC;
assign we=`MemWrite;
wire [7:0] PCInc=PC+8'h1;
wire [8:0] AluAdd=A+indata;
wire [8:0] AluSub=A-indata;
wire [8:0] AluAdc=AluAdd+Carry;
wire [8:0] AluRASA={indata[7],indata};
wire [8:0] AluLCSA={indata,Carry};
wire [7:0] AluAND=A&indata;
wire [7:0] AluOR=A|indata;
wire [7:0] AluXOR=A^indata;
wire [8:0] AluOut=(`AluOP==3'b000)?AluAdd:
                  (`AluOP==3'b001)?AluSub:
						(`AluOP==3'b010)?AluAdc:
						(`AluOP==3'b011)?{AluRASA[0],AluRASA[8:1]}:
						(`AluOP==3'b100)?AluLCSA:
						(`AluOP==3'b101)?{1'h0,AluAND}:
						(`AluOP==3'b110)?{1'h0,AluOR}:
						                 {1'h0,AluXOR};

always @(negedge clk) begin
	//IREnable<=~IREnable;
	IREnable<=PC[0];
	PC<=(`PCLoad)?indata:PCInc;
	IR<=(IREnable)?indata:IR;
	A<=(IREnable)?(`ALoad)?AluOut[7:0]:A:(`PCLoad)?A:indata;
	Carry=(IREnable&`ALoad)?AluOut[8]:Carry;
end

endmodule

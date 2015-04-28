include "PC_163.v";

module Controller(clock, opcode, IRin, IRout,OUTin_O,INout,PCinc,PCHin_O,PCHout,
                  PCLin_O,PCLout,ACCin_O,ACCout,Set,Cs,CXin_O,CYout,CJin_O,CJout,
                  COout,C1out,SPin_O,SPout,R1in_O,R1out,RAin_O,RAout,R2in_O,R2out,
                  Gso, Gsi, Gri, Gro, s, M
                  );

parameter JC 	= 4'b1111;
parameter JMP 	= 4'b1110;
parameter MOV 	= 4'b1101;
parameter MVI 	= 4'b1100;
parameter INC 	= 4'b1011;
parameter ADD 	= 4'b1010;
parameter SUB 	= 4'b1001;
parameter I_AND = 4'b1000;
parameter I_OR 	= 4'b0111;
parameter SC 	= 4'b0110;
parameter CC 	= 4'b0101;
parameter PUSH 	= 4'b0100;
parameter POP 	= 4'b0011;
parameter IN 	= 4'b0010;
parameter OUT 	= 4'b0001;
parameter NOP 	= 4'b0000;  
  
  
input clock, opcode;
output IRin, IRout,OUTin_O,INout,PCinc,PCHin_O,PCHout,PCLin_O,PCLout,ACCin_O,ACCout,Set,Cs,CXin_O,CYout,CJin_O,CJout,COout,
        C1out,SPin_O,SPout,R1in_O,R1out,RAin_O,RAout,R2in_O,R2out, Gso, Gsi, Gri, Gro, s, M;  
  
wire  TC,         //carry out for counter, empty wire      
      OUTin_O,    //these variables are ANDed to the clock, a special output wire is used for output
      PCHin_O,
      PCLin_O,
      ACCin_O,
      CXin_O, 
      CJin_O, 
      SPin_O, 
      R1in_O, 
      RAin_O, 
      R2in_O 
      ;  
  
reg END,          //END signal, internally resets controller counter
    parallel_enable,
    count_enable,
    M,
    IRin,              
    IRout,
    OUTin,
    INout,
    PCinc,        //active low
    PCHin,        //active low
    PCHout,
    PCLin,        //active low
    PCLout,
    ACCin,        //ACC input signal
    ACCout,       //ACC output signal
    Set,          //Control signal for carry mux
    Cs,           //Control signal, carry selection
    
    //carry register buffer controls
    CXin,
    CYout,
    CJin,
    CJout,
    C0out,
    C1out,
    //stack pointer buffer controls
    SPin,
    SPout,
    //SRAM Controls
    R1in,
    R1out,
    RAin,
    RAout,
    R2in,
    R2out, 
    Gro,
    Gri,
    Gso,
    Gsi
    ;  
    
reg[3:0]  parallel_input,
          s             //ALU control
          ;

wire[3:0] Counter_Q
          ;

reg[7:0] T
          ;
  
assign OUTin_O = ~clock & OUTin;
assign PCHin_O = ~clock & PCHin;
assign PCLin_O = ~clock & PCLin;     
assign ACCin_O = ~clock & ACCin;
assign CXin_O  = ~clock & CXin;
assign CJin_O  = ~clock & CJin;
assign SPin_O  = ~clock & SPin;
assign R1in_O  = ~clock & R1in;
assign RAin_O  = ~clock & RAin;
assign R2in_O  = ~clock & R2in;

initial
begin
  END = 0;parallel_enable = 0;count_enable = 0;M = 0;IRin = 0;IRout = 0;
  OUTin = 0;INout = 0;PCinc = 0;PCHin = 0;PCHout = 0;PCLin = 0;PCLout = 0;
  ACCin = 0;ACCout = 0;Set = 0;Cs = 0;CXin = 0;CYout = 0;CJin = 0;CJout = 0;
  C0out = 0;C1out = 0;SPin = 0;SPout = 0;R1in = 0;R1out = 0;RAin = 0;
  RAout = 0;R2in = 0;R2out = 0;Gro = 0;Gri = 0;Gso = 0;Gsi = 0;  
end
  
PC_163 Control_Counter(~END, parallel_input, ~parallel_enable, Counter_Q, clock, count_enable, TC);    

//decoder for clock steps
always@(posedge clock)
begin
  case(Counter_Q)
    4'h0 : T = 8'b00000001;
    4'h1 : T = 8'b00000010;
    4'h2 : T = 8'b00000100;
    4'h3 : T = 8'b00001000;
    4'h4 : T = 8'b00010000;
    4'h5 : T = 8'b00100000;
    4'h6 : T = 8'b01000000;
    4'h7 : T = 8'b10000000;
    default: T = 8'bzzzzzzzz;
  endcase
end          


  always@(posedge clock)
  begin
    
  if(opcode == MOV) //MOV
    begin
      if(T[0])
        begin
          IRin = 1;
        end
      if(T[1])
        begin
          Gro = 1;
          R1out = 1;
          s = 4'b1111; M = 1; //F=A
          R2in = 1;
          C0out = 1;
          Gri = 1;    
        end
      if(T[2])
        begin
          END = 1;
          PCinc = 1;
        end
    end
    
  if(opcode == MVI) //MVI
    begin
      if(T[0])
        begin
          IRin = 1;
        end
      if(T[1])
        begin
          IRout = 1;
          R1in = 1;
          s = 4'b1111; M = 1; //F=A
          Gri = 1; 
        end
      if(T[2])
        begin
          END = 1;
          PCinc = 1;
        end
    end 
    
  if(opcode == INC) //INC
    begin
      if(T[0])
        begin
          IRin = 1;
        end
      if(T[1])
        begin
          Gro = 1;
          R1out = 1;
          s = 4'b0000; M = 0; //F = A PLUS 1
          C0out = 1;
          Gri = 1;
          R1in = 1;          
        end
      if(T[2])
        begin
          END = 1;
          PCinc = 1;
        end
    end
    
    if(opcode == ADD) //ADD
    begin
      if(T[0])
        begin
          IRin = 1;
        end
      if(T[1])
        begin
          Gro = 1;
          R1out = 1;
          s = 4'b1111; M = 1; //F=A
          ACCin = 1;
        end
      if(T[2])
        begin
          Gro = 1;
          R2out = 1;
          ACCout = 1;
          CYout = 1;
          s = 4'b1001; M = 0; //F=A PLUS B PLUS 1
          R1in = 1;
          CXin = 1;
          Gri = 1;
        end
      if(T[3])
        begin
          END = 1;
          PCinc = 1;
        end
    end
   
    if(opcode == SUB) //SUB
    begin
      if(T[0])
        begin
          IRin = 1;
        end
      if(T[1])
        begin
          Gro = 1;
          R2out = 1;
          s = 4'b1111; M = 1; //F=A
          ACCin = 1;
        end
      if(T[2])
        begin
          Gro = 1;
          R1out = 1;
          ACCout = 1;
          CYout = 1;
          s = 4'b0110; M = 0; //F=A MINUS B
          CXin = 1;
          Gri = 1;
          R2in = 1;
        end
      if(T[3])
        begin
          END = 1;
          PCinc = 1;
        end
    end
    
    if(opcode == I_AND) //AND
    begin
      if(T[0])
        begin
          IRin = 1;
        end
      if(T[1])
        begin
          Gro = 1;
          R1out = 1;
          s = 4'b1111; M = 1; //F=A
          ACCin = 1;
        end
      if(T[2])
        begin
          Gro = 1;
          R2out = 1;
          ACCout = 1;
          s = 4'b1011; M = 1; //F=AB
          Gri = 1;
          R1in = 1;
        end
      if(T[3])
        begin
          END = 1;
          PCinc = 1;
        end
    end
    
    if(opcode == I_OR) //OR
    begin
      if(T[0])
        begin
          IRin = 1;
        end
      if(T[1])
        begin
          Gro = 1;
          R1out = 1;
          s = 4'b1111; M = 1; //F=A
          ACCin = 1;
        end
      if(T[2])
        begin
          Gro = 1;
          R2out = 1;
          ACCout = 1;
          s = 4'b1110; M = 1; //F=A+B
          R1in = 1;
          Gri = 1;
        end
      if(T[3])
        begin
          END = 1;
          PCinc = 1;
        end
    end
    
    if(opcode == SC) //SC
    begin
      if(T[0])
        begin
          IRin = 1;
        end
      if(T[1])
        begin
          Cs = 1;
          Set = 1;
          CXin = 1;
        end
      if(T[2])
        begin
          END = 1;
          PCinc = 1;
        end
    end
    
    if(opcode == CC) //CC
    begin
      if(T[0])
        begin
          IRin = 1;
        end
      if(T[1])
        begin
          Set = 1;
          CXin = 1;
        end
      if(T[2])
        begin
          END = 1;
          PCinc = 1;
        end
    end
    /*
    if(opcode == PUSH) //PUSH
    begin
      if(T[0])
        begin
          IRin = 1;
        end
      if(T[1])
        begin
          if(!OF) ACCin = 1;
          SPout = 1;
        end
      if(T[2])
        begin
          ACCout = 1;
          C1out = 1;
          s = 4'b0000; M = 0; //F = A PLUS 1
          SPin = 1;
        end
      if(T[3])
        begin
          Gro = 1;
          R1out = 1;
          SRin = 1;
        end          
      if(T[4])
        begin
          END = 1;
          PCinc = 1;
        end
    end
    
    if(opcode == POP) //POP
    begin
      if(T[0])
        begin
          IRin = 1;
        end
      if(T[1])
        begin
          if(!UF) Rin = 1;
          SRout = 1;
        end
      if(T[2])
        begin
          SPout = 1;
          ACCin = 1;
        end
      if(T[3])
        begin
          ACCout = 1;
          C0out = 1;
          s = 4'b1111; M = 0; //F = A PLUS 1
          SPin = 1;
        end
      if(T[4])
        begin
          END = 1;
          PCinc = 1;
        end
    end
    */
    
    if(opcode == IN) //IN
    begin
      if(T[0])
        begin
          IRin = 1;
        end
      if(T[1])
        begin
          INout = 1;
          R1in = 1;
          Gri = 1;
        end
      if(T[2])
        begin
          END = 1;
          PCinc = 1;
        end
    end
    
    if(opcode == OUT) //OUT
    begin
      if(T[0])
        begin
          IRin = 1;
        end
      if(T[1])
        begin
          Gro = 1;
          R1out = 1;
          OUTin = 1;
        end
      if(T[2])
        begin
          END = 1;
          PCinc = 1;
        end
    end
    
    if(opcode == JMP) //JMP
    begin
      if(T[0])
        begin
          IRin = 1;
        end
      if(T[1])
        begin
          IRout = 1;
          s = 4'b1111; M = 1; //F=A
          PCHin = 1;
        end
      if(T[2])
        begin
          Gro = 1;
          RAout = 1;
          PCLin = 1;
        end
      if(T[3])
        begin
          END = 1;
        end
    end
    
    if(opcode == JC) //JC
    begin
      if(T[0])
        begin
          IRin = 1;
        end
      if(T[1])
        begin
          if(CYout) ACCin = 1;
          PCLout = 1;
          s = 4'b1111; M = 1; //F=A
        end
      if(T[2])
        begin
          ACCout = 1;
          IRout = 1;
          s = 4'b1111; M = 1; //F=A
          PCLin = 1;
          CJin = 1;
        end
      if(T[3])
        begin
          PCHout = 1;
          ACCin = 1;
          s = 4'b1111; M = 1; //F=A
        end
      if(T[4])
        begin
          ACCout = 1;
          CJout = 1;
          s = 4'b0000; M = 0; //F = A PLUS 1
          PCHin = 1;
        end          
      if(T[5])
        begin
          END = 1;
        end
    end
  end
endmodule
module UART  (
input wire clk_50M ,d_num,reset,enable,parity,stop_bits,
input wire [1:0] bd_rate, 
input wire [7:0] data,
output reg [7:0] register 
//output reg flag,
//output reg [27:0] rate
//output reg [1:0] Recieving,sending 
);
wire flag;
reg Tx_reg;
wire Tx;
frequency_divider div_1 
      ( 
      
      .clk_50M(clk_50M) 
      ,.clk_tx(clk_tx)  
      ,.clk_rx(clk_rx)
      ,.bd_rate(bd_rate)
      ,.reset(reset)
      );

//Digital_Clock cl (.clk_1Hz(clk_1Hz),.reset(reset));
Tx T(
      .clk_tx(clk_tx)
      ,.enable(enable)
      ,.d_num(d_num)
      ,.data(data)
      ,.reset(reset)
      ,.Tx(Tx)
      ,.parity(parity)
      ,.stop_bits(stop_bits)
    );

Rx recieve   
      (
        .clk_rx(clk_rx)
        ,.reset(reset)
        ,.d_num(d_num)
        ,.stop_bits(stop_bits)
        ,.Tx(Tx)
        ,.flag(flag)
        ,.register(register)
      );
//assign Tx = Tx_reg;
endmodule 
/*
module frequency_divider (
input clk_50M,reset,
input reg [1:0]bd_rate , 
output reg clkrx,clktx );    

reg [27:0]counterrx=0;
reg [27:0]countertx=0;
reg [27:0] rate;

initial rate =0;

parameter cycle1=50000000/12500000; 
parameter cycle2=50000000/38400;
parameter cycle3=50000000/76800;
parameter cycle4=50000000/153600;
initial begin
   clkrx=0;
end
always@(posedge clk_50M)
   begin    
       case (bd_rate)
       2'b00: rate= cycle1;
       2'b01: rate= cycle2;
       2'b10: rate= cycle2;
       2'b11: rate= cycle3;
       default rate=4;
   endcase 
end 
always @(posedge clk_50M)
begin 
  if (counterrx==rate)begin
     counterrx=0;
     clkrx=1;
end
  else begin 
   counterrx=counterrx+1;
   clkrx=0;
end
end 

initial begin 
	clktx=0;
end
always @(posedge clk_50M)
begin 
if (countertx==rate*16)begin
   	countertx=0;
   	clktx=1;
	end
  else begin
   countertx=countertx+1;
   clktx=0;
end
end
endmodule


/*initial begin 
 clk_1Hz <= 0;
 counter <= 0;
end
always@(posedge reset or posedge clk_50M)
begin
    if (reset == 1'b1)
        begin
            clk_1Hz <= 0;
            counter <= 0;
        end
    else
        begin
            counter <= counter + 1;
            if ( counter == 25_000_000)
                begin
                    counter <= 0;
                    clk_1Hz <= ~clk_1Hz;
                end
        end
end
endmodule


/*module Digital_Clock(     
    seconds,
    minutes,
    hours,days,months);


    wire clk_1Hz;  
    wire reset ;
 
    output [5:0] seconds;
    output [5:0] minutes;
    output [4:0] hours;
    output [4:0] days;
    output [3:0] months;

    reg [5:0] seconds;
    reg [5:0] minutes;
    reg [4:0] hours; 
    reg [4:0] days;
    reg [3:0] months;

    always @(posedge(clk_1Hz) or posedge(reset))
    begin
        if(reset == 1'b1) begin  
            seconds = 0;
            minutes = 0;
            hours = 0; 
            days = 1;
            months = 1 ; end
        else if(clk_1Hz == 1'b1) begin  
            seconds = seconds + 1; 
            if(seconds == 60) begin 
                seconds = 0;  
                minutes = minutes + 1; 
            if(minutes == 60) begin 
                    minutes = 0;  
                    hours = hours + 1; 
             if(hours ==  24) begin  
                     hours = 0;
                     days= days +1 ; 
              if (days==30)
                      days=1 ;
                     months = months +1 ;
              if (months ==12)
                        months = 1;
 end 
   end
    end     
 end
    end     

endmodule
/*
module Tx( input d_num ,reset,enable,clktx,input [7:0] data ,output reg Tx,
           output reg [1:0] sending );


reg [4:0] num_of_count;

always@(posedge clktx  or posedge reset )
begin 
 if (reset)begin 
           num_of_count=0;
	   sending =2'b00;
           Tx=1;
end  
else begin

       case (sending)
    2'b00: if (enable) begin      //ideal state
              Tx =0;
              sending=2'b01;
            end
           else 
               sending =2'b00;
      
    2'b01:
	   if (num_of_count ==7&&d_num ==0 ||num_of_count==8&&d_num ==1)begin
              Tx=1;
              num_of_count=0;
              sending=2'b10;
           end 
  	  else if (clktx ==1)
	   begin
		Tx=data[num_of_count];
		num_of_count=num_of_count+1;
	 	sending=2'b01;
	    end
	 else 
		sending=2'b01;				 
           
    2'b10: if (clktx ==1 && Tx==1)   //stop
               sending=2'b00;
           else 
               sending=2'b01;
    endcase
end 
end
endmodule

module RxX ( input clkrx,reset,d_num,Tx,output reg flag,output reg [1:0]receving  );

reg [4:0] counter ;
reg [7:0] register ;
reg [4:0] num_of_count;


always@(posedge clkrx)
begin 
 
 if (counter ==16)begin 
            counter =0;
            num_of_count=num_of_count+1;
 end
       else 
            counter = counter +1;

end 

always@(posedge clkrx or posedge reset)
begin
if (reset) begin
 counter =5'b00000;
receving =2'b00;
register =8'b0;
num_of_count=0;
flag=0;
end  

       case (receving )
    2'b00: if (Tx) begin              //ideal state
              receving =2'b00;
end
           else 
               receving =2'b01; 
           
    2'b01: if (counter ==8 && Tx==0) begin  //start state 
              receving =2'b10;
               counter =0;
end
           else 
              receving =2'b01;
          
    2'b10: if (counter ==16 ) begin            //receving and storing data 
               register ={register [7:1],Tx};
           if (num_of_count ==7 &&d_num==0 || num_of_count ==8&& d_num==1) 
               num_of_count=0;     
               
  end
 
              
   
     2'b11:   if ( counter==16 &&Tx==1)        //stop state
	      begin
              receving =2'b00;
	      flag=1;
	      end
        
          
endcase            
end 
endmodule*/ 
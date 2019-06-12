module frequency_divider (
input wire clk_50M,reset,
input wire[1:0]bd_rate , 
output reg clk_rx,clk_tx );    

reg [10:0]counter_rx=1;
reg [14:0]counter_tx=1;
reg [10:0] rate =0;
parameter cycle_1=50000000/38400; //2400
parameter cycle_2=50000000/76800; //4800
parameter cycle_3=50000000/153600;//9600
parameter cycle_4=50000000/307200;//19200
initial begin
   clk_rx=0; 
	clk_tx=0;
end
always@(posedge clk_50M)
if (reset)
  begin
    counter_rx=1;
    counter_tx=1;
  end
else
  begin
begin 
  if (counter_rx==rate)begin
     counter_rx=1;
     clk_rx=1;
      end
  else begin 
   counter_rx=counter_rx+1;
   clk_rx=0;
      end
end
begin
if (counter_tx==rate*16)begin
   	counter_tx=1;
   	clk_tx=1;
	end
  else begin
   counter_tx=counter_tx+1;
   clk_tx=0;
    end
    end
end 

always@(*)
begin    
       case (bd_rate)
       2'b00: rate= cycle_1;
       2'b01: rate= cycle_2;
       2'b10: rate= cycle_3;
       2'b11: rate= cycle_4;
       default rate=4; //1200
      
   endcase 

end
endmodule

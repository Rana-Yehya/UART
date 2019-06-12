module Tx( 
input wire clk_tx,d_num ,reset,enable,parity,stop_bits,
input wire [7:0] data ,
output reg Tx
);
reg pf=0;
reg [2:0] counter_pf= 0; 
reg [2:0] counter= 0;
reg [2:0] num_of_count=0;
reg [1:0] sending;
always@(posedge clk_tx  or reset )
begin 
 if (reset)begin 
          num_of_count=0;
	        sending =2'b00;
          Tx=1;
          counter_pf= 0;
end  
else begin
counter_pf <= counter; 
      case (sending)
      2'b00: if (enable) begin      //ideal state
              Tx =0;
              sending=2'b01;
            end
           else 
               sending =2'b00;
      
      2'b01:
	       if (num_of_count ==6&&d_num ==0 ||num_of_count==7&&d_num ==1)
	         begin
              Tx=1;
              num_of_count=0;
              sending=2'b10;
           end 
	       else 
	         begin
		          Tx=data[num_of_count];
		          num_of_count=num_of_count+1;
	 	          sending=2'b01;
	         end  
	    
      2'b10: 
            begin
                //parity flag
                  Tx= (pf ^ parity);
                  num_of_count = num_of_count+1;
                  sending = 2'b11;
                  end
      2'b11:               
              begin
                  if (num_of_count==2 && stop_bits==1)  // send the second bit 
                      begin
                        num_of_count=0;  
                        sending = 2'b00;
                        Tx= 1;
                      end
                  else if (num_of_count==1 && stop_bits==1) // send the first bit
                      begin
                        num_of_count=2;
                        Tx= 1;
                      end
                  else
                      begin  //stop_bits=0
                        num_of_count=0;
                        sending = 2'b00;
                        Tx= 1;
                      end             
        end
      default:sending = 2'b00;          
    endcase
end 
end
// Odd system 
// For determining the parity flag
always@(*)
begin
  if(counter_pf ==6&&d_num ==0 ||counter_pf==7&&d_num ==1)
   begin
      counter_pf=counter_pf;
      pf = pf;
   end  
  else
   begin
      pf = data[counter_pf] ^ pf;
      counter =counter_pf+1; 
    end   
end
endmodule
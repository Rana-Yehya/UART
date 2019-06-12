module Rx ( 
input wire clk_rx,reset,d_num,Tx,stop_bits,
output reg flag
 );
reg pf=0;
reg [3:0] counter =0;
reg [7:0] register =0 ;
reg [3:0] num_of_count=0;
reg [1:0] receving=0;

always@(posedge clk_rx or reset)
begin
        if (reset) begin
          counter =1;
          receving =2'b00;
          register =8'b0;
          num_of_count=0;
          flag=0;
        end  
else
       case (receving)
          2'b00:if (Tx)                             //ideal state
                      receving =2'b00;
                else 
                      receving =2'b01; 
           
          2'b01: if (counter ==7 && Tx==0) begin  //start state 
                      receving =2'b10;
                      counter =1;
                    end
                else
                    begin 
                      receving =2'b01;
                      counter = counter +1;
                    end
          2'b10:if (counter ==15 ) begin            //receving and storing data 
                      counter=0;
                      register [num_of_count]=Tx;
                      
                           if (num_of_count ==6 &&d_num==0 || num_of_count ==7&& d_num==1) 
                              begin
                                  num_of_count=0;
                                  receving =2'b11;
                              end              
                            else
                                  num_of_count=num_of_count+1;
                      end                     
                else begin
                    receving =2'b10;
                    counter = counter +1;  
                  end
     2'b11:   if ( counter==15)        //stop state
	               begin
	                  counter=0;
                    //receving =2'b00;
	                  
	                  pf=Tx;
	                     if (num_of_count ==2 && stop_bits==1 &&Tx==1)
	                             begin
	                               flag=1;
	                             receving =2'b00;
	                             num_of_count =0;
                              end
	                     else   if (num_of_count ==1 && stop_bits ==0&&Tx==1)
	                             begin
	                               flag=1;
	                               num_of_count =0;
	                             receving =2'b00;
	                             end
	                     else 
	                       num_of_count = num_of_count +1;              
	               end
	            else begin
	                   counter = counter +1;  
	                   receving =2'b11;
	                  end
endcase            
end 
endmodule

 module seq_detector(
    din,
    clk,
    reset,
    z
 );

 output reg z;
 input din,clk,reset;

  parameter [2:0] S0 = 3'd0;  //1
  parameter [2:0] S1 = 3'd1;  //0
  parameter [2:0] S2 = 3'd2;  //00
  parameter [2:0] S3 = 3'd3;  //000
  parameter [2:0] S4 = 3'd4;  //001 or 0001
  //3'b001沒有標

  reg [2:0] PS,NS ;//2bits

  //sequential state register block
 always @ (posedge clk or posedge reset)
 //begin
   if (reset)
     PS <= S0;  
   else
     PS <= NS;
 //end

//sequential output block
 always @ (*)//學長提示
  // begin
    if (reset)
    z <= 1'b0;
    else 
        case(PS)
        S0 : z <= 1'b0;
        S1 : z <= 1'b0;
        S2 : z <= 1'b0;
        S3 : if(din)
             z <=1'b1;
             else
             z <=1'b0;
        S4 : if(din)
             z <=1'b0;
             else
             z <=1'b1;
        default:z <=1'b0;
        endcase
   // end
     
  //combinational state assignment block  
 always @ (*)
  begin
    case(PS)
        S0 : NS = din ? S0 : S1 ;
        S1 : NS = din ? S0 : S2 ;
        S2 : NS = din ? S4 : S3 ;
        S3 : NS = din ? S4 : S3 ;
        S4 : NS = din ? S0 : S1 ;
    endcase
    $monitor("present state is %d",PS);
  end
 
 endmodule
`timescale 1ns / 10ps
`define CYCLE      25.0          	  // Modify your clock period here
`define End_CYCLE  26                 // Modify cycle times once your design need more cycle times!  
`include "detector.v"
module testbench;

    // Inputs
    reg in_data;
    reg clk;
    reg reset;
    reg mem_i [18:0];//input signal
    reg correct [18:0];//correct signal
    // Outputs
    wire out_data;


    integer i;
    integer error;
    // name the test: first_case
    seq_detector first_case (
        .din(in_data), 
        .clk(clk), 
        .reset(reset), 
        .z(out_data)
    );

    always begin #(`CYCLE/2) clk = ~clk; end // let the clk be opposite every half cycle 

    initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, testbench);
    $readmemh("input.txt",mem_i);// time = 0   (file 自己要放好)
    $readmemh("correct.txt",correct);// time = 0(file 自己要放好)
    $display("-----------------------------------------------------");// time = 0
    $display("START!!! Simulation Start .....");                      // time = 0
    $display("-----------------------------------------------------");// time = 0
    end

    initial begin
            clk = 1'b1;                         // time = 0
            reset = 1'b1;                       // time = 0
            in_data = 1'b0;                     // time = 0
            error = 0;                          // time = 0
            #(`CYCLE) reset = 1'b0;             // time = a cycle
            #(`CYCLE*`End_CYCLE) $finish;       // time = a cycle(above) + End_CYCLE*CYCLE
        end

    initial begin
            case1;      //start at time = 0;
        end

    // task block ack like a function in software, it will run squentially inside the block
        task case1; begin
            wait(reset==0);             // stall here untill reset become '0' (correspond to line 47)
            for(i=0;i<19;i++) begin
                in_data = mem_i[i];
                # 0.01;                 // wait for a moment for taking wanted value (if not will get the pre-cycle's value)
                if(out_data==correct[i]) begin
                    $display("input= %d, out data equal to %d",in_data,correct[i]);
                end
                else begin
                    $display("input= %d, out data is %d but correct_output is %d",in_data,out_data,correct[i]);
                    error = 1;
                end
                @(posedge clk);         // stall here until the next clock posedge
            end

            if(error) begin
                $display("-----------------------------------------------------");
                $display("Simulation END, there are some errors.....");
                $display("-----------------------------------------------------");
            end
            else begin
                $display("-----------------------------------------------------");
                $display("Simulation END, SUCCESS!!!");
                $display("-----------------------------------------------------");
            end
            //test reset
            reset=1'b1;
            wait(reset==1);
                $display("-----------------------------------------------------");
                $display("-------------------now reset-------------------------");
            # 0.01;
            reset=1'b0;
            wait(reset==0);
                $display("after reset state is S0");
                $display("below:after reset in_data is always 0 ,state S0->S1->S2->S3");             
        end endtask



endmodule
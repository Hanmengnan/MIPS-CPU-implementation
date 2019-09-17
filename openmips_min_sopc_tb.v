`include "defines.v"
`timescale 1ns/1ps

module openmips_min_sopc_tb();

    reg CLOCK_50;
    reg rst;
    initial begin
        CLOCK_50 = 1'b0;
        forever #1 CLOCK_50 = ~CLOCK_50;
    end

    initial begin
        rst = `RstEnable;
        #100 rst = `RstDisable;
        // #50
        // #200 next=0;
        // #10 next=1;
        // #10 next=0;
        // KEY_R=4'b0111;
        // KEY_C=4'b0001;
        // #50 over_i='d0;//3
        // KEY_R=4'b1011;
        // KEY_C=4'b1000;
        // #50 over_i='d0;//4
        // KEY_R=4'b0111;
        // KEY_C=4'b1000;
        // #50 over_i='d0;//0
        // KEY_R=4'b0111;
        // KEY_C=4'b0100;
        // #50 over_i='d0;//1
        // KEY_R=4'b0111;
        // KEY_C=4'b0100;
        // #50 over_i='d0;//1
        // KEY_R=4'b0111;
        // KEY_C=4'b1000;
        // #50 over_i='d0;//0
        // KEY_R=4'b0111;
        // KEY_C=4'b1000;
        // #50 over_i='d0;//0
        // #50 over='d0;
        // #100 next =1;
        // // #50
        // // KEY_R=4'b0111;
        // // KEY_C=4'b0100;
        // // #50 over_i='d0;
        // // #100 next =1;
        #4100 $stop;
    end

    openmips_min_sopc openmips_min_sopc0(
        .clk(CLOCK_50),
        .rst(rst)
        // .next(next),
        // .del(del),
        // .ledag(ledag)

    );

endmodule

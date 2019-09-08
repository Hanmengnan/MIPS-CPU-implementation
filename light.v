`include "defines.v"
module light (input clk,
              input next,
              input [`RegBus] data,
              output reg [2:0]del,
              output reg [7:0]ledag, 
              output reg [4:0]p);
    reg		[2:0]	dount = 'd0;
    reg     [3:0]   key;
    reg		[`RegBus]	value;
    reg [4:0]index;
    reg [4:0]temp = 'd1;
    
    
    always @( negedge next)begin
            p=temp;
        temp=temp+1;
    end
    always @ (data)begin
        value <= data;
    end
    
    always @ (posedge clk)begin
        if (dount == 'd0) begin
            key   <= value[31:28];
            del   <= 3'd0;
            dount <= dount + 1'b1;
        end
        else if (dount == 'd1)begin
            key   <= value[27:24];
            del   <= 3'd1;
            dount <= dount + 1'b1;
        end
            else if (dount == 'd2)begin
            key   <= value[23:20];
            del   <= 3'd2;
            dount <= dount + 1'b1;
            end
            else if (dount == 'd3)begin
            key   <= value[19:16];
            del   <= 3'd3;
            dount <= dount + 1'b1;
            end
            else if (dount == 'd4)begin
            key   <= value[15:12];
            del   <= 3'd4;
            dount <= dount + 1'b1;
            end
            else if (dount == 'd5)begin
            key   <= value[11:8];
            del   <= 3'd5;
            dount <= dount + 1'b1;
            end
            else if (dount == 'd6)begin
            key   <= value[7:4];
            del   <= 3'd6;
            dount <= dount + 1'b1;
            end
            else if (dount == 'd7)begin
            key   <= value[3:0];
            del   <= 3'd7;
            dount <= 3'd0;
            end
            end
            
            
            always @ (key)begin
                case (key)
                    4'b0000: ledag <= 8'b00111111;
                    4'b0001: ledag <= 8'b00000110;
                    4'b0010: ledag <= 8'b01011011;
                    4'b0011: ledag <= 8'b01001111;
                    4'b0100: ledag <= 8'b01100110;
                    4'b0101: ledag <= 8'b01101101;
                    4'b0110: ledag <= 8'b01111101;
                    4'b0111: ledag <= 8'b00000111;
                    4'b1000: ledag <= 8'b01111111;
                    4'b1001: ledag <= 8'b01101111;
                    4'b1010: ledag <= 8'b01110111;
                    4'b1011: ledag <= 8'b01111100;
                    4'b1100: ledag <= 8'b00111001;
                    4'b1101: ledag <= 8'b01011110;
                    4'b1110: ledag <= 8'b01111001;
                    4'b1111: ledag <= 8'b01110001;
                    default:ledag  <= 8'hff;
                endcase
            end
            endmodule

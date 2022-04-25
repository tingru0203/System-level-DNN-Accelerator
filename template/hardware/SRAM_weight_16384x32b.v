module SRAM_weight_16384x32b( 
    input wire clk,
    input wire [ 3:0] wea0,
    input wire [15:0] addr0,
    input wire [31:0] wdata0,
    output wire [31:0] rdata0,
    input wire [ 3:0] wea1,
    input wire [15:0] addr1,
    input wire [31:0] wdata1,
    output wire [31:0] rdata1
);

BRAM_8x2048x8 bram0( // A % 4 = 0
    .CLK(clk), 
    .A0(addr0), 
    .D0(wdata0[7:0]), 
    .Q0(rdata0[7:0]),
    .WE0(wea0[0]), 
    .WEM0(8'b0), 
    .CE0(1'b1), 
    .A1(addr1), 
    .D1(wdata1[7:0]), 
    .Q1(rdata1[7:0]), 
    .WE1(wea1[0]), 
    .WEM1(8'b0), 
    .CE1(1'b1)
);

BRAM_8x2048x8 bram1( // A % 4 = 1
    .CLK(clk), 
    .A0(addr0), 
    .D0(wdata0[15:8]), 
    .Q0(rdata0[15:8]),
    .WE0(wea0[1]), 
    .WEM0(8'b0), 
    .CE0(1'b1), 
    .A1(addr1), 
    .D1(wdata1[15:8]), 
    .Q1(rdata1[15:8]), 
    .WE1(wea1[1]), 
    .WEM1(8'b0), 
    .CE1(1'b1)
);

BRAM_8x2048x8 bram2( // A % 4 = 2
    .CLK(clk), 
    .A0(addr0), 
    .D0(wdata0[23:16]), 
    .Q0(rdata0[23:16]),
    .WE0(wea0[2]), 
    .WEM0(8'b0), 
    .CE0(1'b1), 
    .A1(addr1), 
    .D1(wdata1[23:16]), 
    .Q1(rdata1[23:16]), 
    .WE1(wea1[2]), 
    .WEM1(8'b0), 
    .CE1(1'b1)
);

BRAM_8x2048x8 bram3( // A % 4 = 3
    .CLK(clk), 
    .A0(addr0), 
    .D0(wdata0[31:24]), 
    .Q0(rdata0[31:24]),
    .WE0(wea0[3]), 
    .WEM0(8'b0), 
    .CE0(1'b1), 
    .A1(addr1), 
    .D1(wdata1[31:24]), 
    .Q1(rdata1[31:24]), 
    .WE1(wea1[3]), 
    .WEM1(8'b0), 
    .CE1(1'b1)
);

endmodule

//

module BRAM_8x2048x8( 
	input wire CLK,
	input wire [15:0] A0,
	input wire [7:0] D0,
	output reg [7:0] Q0,
	input wire WE0,
	input wire [7:0] WEM0,
	input wire CE0,
	input wire [15:0] A1,
	input wire [7:0] D1,
	output reg [7:0] Q1,
	input wire WE1,
	input wire [7:0] WEM1,
	input wire CE1
);

reg [10:0] A0_tmp, A1_tmp;
wire [7:0] Q0_0, Q1_0, Q0_1, Q1_1, Q0_2, Q1_2, Q0_3, Q1_3, Q0_4, Q1_4, Q0_5, Q1_5, Q0_6, Q1_6, Q0_7, Q1_7;
reg WE0_0, WE1_0, WE0_1, WE1_1, WE0_2, WE1_2, WE0_3, WE1_3, WE0_4, WE1_4, WE0_5, WE1_5, WE0_6, WE1_6, WE0_7, WE1_7;

always @(*) begin
    {WE0_0, WE1_0, WE0_1, WE1_1, WE0_2, WE1_2, WE0_3, WE1_3, WE0_4, WE1_4, WE0_5, WE1_5, WE0_6, WE1_6, WE0_7, WE1_7} = 16'b0;
    if(A0 >= 16'd0 & A0 < 16'd2048) begin
        A0_tmp = A0;
        A1_tmp = A1;
        Q0 = Q0_0;
        Q1 = Q1_0;
        WE0_0 = WE0;
        WE1_0 = WE1;
    end
    else if(A0 >= 16'd2048 & A0 < 16'd2048*2) begin
        A0_tmp = A0 - 16'd2048;
        A1_tmp = A1 - 16'd2048;
        Q0 = Q0_1;
        Q1 = Q1_1;
        WE0_1 = WE0;
        WE1_1 = WE1;
    end
    else if(A0 >= 16'd2048*2 & A0 < 16'd2048*3) begin
        A0_tmp = A0 - 16'd2048*2;
        A1_tmp = A1 - 16'd2048*2;
        Q0 = Q0_2;
        Q1 = Q1_2;
        WE0_2 = WE0;
        WE1_2 = WE1;
    end
    else if(A0 >= 16'd2048*3 & A0 < 16'd2048*4) begin
        A0_tmp = A0 - 16'd2048*3;
        A1_tmp = A1 - 16'd2048*3;
        Q0 = Q0_3;
        Q1 = Q1_3;
        WE0_3 = WE0;
        WE1_3 = WE1;
    end
    else if(A0 >= 16'd2048*4 & A0 < 16'd2048*5) begin
        A0_tmp = A0 - 16'd2048*4;
        A1_tmp = A1 - 16'd2048*4;
        Q0 = Q0_4;
        Q1 = Q1_4;
        WE0_4 = WE0;
        WE1_4 = WE1;
    end
    else if(A0 >= 16'd2048*5 & A0 < 16'd2048*6) begin
        A0_tmp = A0 - 16'd2048*5;
        A1_tmp = A1 - 16'd2048*5;
        Q0 = Q0_5;
        Q1 = Q1_5;
        WE0_5 = WE0;
        WE1_5 = WE1;
    end
    else if(A0 >= 16'd2048*6 & A0 < 16'd2048*7) begin
        A0_tmp = A0 - 16'd2048*6;
        A1_tmp = A1 - 16'd2048*6;
        Q0 = Q0_6;
        Q1 = Q1_6;
        WE0_6 = WE0;
        WE1_6 = WE1;
    end
    else begin // (A0 >= 16'd2048*7 & A0 < 16'd2048*8)
        A0_tmp = A0 - 16'd2048*7;
        A1_tmp = A1 - 16'd2048*7;
        Q0 = Q0_7;
        Q1 = Q1_7;
        WE0_7 = WE0;
        WE1_7 = WE1;
    end
end

BRAM_2048x8 bram0(
    .CLK(CLK), 
    .A0(A0_tmp), 
    .D0(D0), 
    .Q0(Q0_0),
    .WE0(WE0_0), 
    .WEM0(WEM0), 
    .CE0(CE0), 
    .A1(A1_tmp), 
    .D1(D1), 
    .Q1(Q1_0), 
    .WE1(WE1_0), 
    .WEM1(WEM1), 
    .CE1(CE1)
);

BRAM_2048x8 bram1(
    .CLK(CLK), 
    .A0(A0_tmp), 
    .D0(D0), 
    .Q0(Q0_1),
    .WE0(WE0_1), 
    .WEM0(WEM0), 
    .CE0(CE0), 
    .A1(A1_tmp), 
    .D1(D1), 
    .Q1(Q1_1), 
    .WE1(WE1_1), 
    .WEM1(WEM1), 
    .CE1(CE1)
);

BRAM_2048x8 bram2(
    .CLK(CLK), 
    .A0(A0_tmp), 
    .D0(D0), 
    .Q0(Q0_2),
    .WE0(WE0_2), 
    .WEM0(WEM0), 
    .CE0(CE0), 
    .A1(A1_tmp), 
    .D1(D1), 
    .Q1(Q1_2), 
    .WE1(WE1_2), 
    .WEM1(WEM1), 
    .CE1(CE1)
);

BRAM_2048x8 bram3(
    .CLK(CLK), 
    .A0(A0_tmp), 
    .D0(D0), 
    .Q0(Q0_3),
    .WE0(WE0_3), 
    .WEM0(WEM0), 
    .CE0(CE0), 
    .A1(A1_tmp), 
    .D1(D1), 
    .Q1(Q1_3), 
    .WE1(WE1_3), 
    .WEM1(WEM1), 
    .CE1(CE1)
);

BRAM_2048x8 bram4(
    .CLK(CLK), 
    .A0(A0_tmp), 
    .D0(D0), 
    .Q0(Q0_4),
    .WE0(WE0_4), 
    .WEM0(WEM0), 
    .CE0(CE0), 
    .A1(A1_tmp), 
    .D1(D1), 
    .Q1(Q1_4), 
    .WE1(WE1_4), 
    .WEM1(WEM1), 
    .CE1(CE1)
);

BRAM_2048x8 bram5(
    .CLK(CLK), 
    .A0(A0_tmp), 
    .D0(D0), 
    .Q0(Q0_5),
    .WE0(WE0_5), 
    .WEM0(WEM0), 
    .CE0(CE0), 
    .A1(A1_tmp), 
    .D1(D1), 
    .Q1(Q1_5), 
    .WE1(WE1_5), 
    .WEM1(WEM1), 
    .CE1(CE1)
);

BRAM_2048x8 bram6(
    .CLK(CLK), 
    .A0(A0_tmp), 
    .D0(D0), 
    .Q0(Q0_6),
    .WE0(WE0_6), 
    .WEM0(WEM0), 
    .CE0(CE0), 
    .A1(A1_tmp), 
    .D1(D1), 
    .Q1(Q1_6), 
    .WE1(WE1_6), 
    .WEM1(WEM1), 
    .CE1(CE1)
);

BRAM_2048x8 bram7(
    .CLK(CLK), 
    .A0(A0_tmp), 
    .D0(D0), 
    .Q0(Q0_7),
    .WE0(WE0_7), 
    .WEM0(WEM0), 
    .CE0(CE0), 
    .A1(A1_tmp), 
    .D1(D1), 
    .Q1(Q1_7), 
    .WE1(WE1_7), 
    .WEM1(WEM1), 
    .CE1(CE1)
);

endmodule
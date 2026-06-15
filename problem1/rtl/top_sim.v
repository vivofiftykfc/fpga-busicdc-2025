`timescale 1ns / 1ps

// =============================================================================
// 题目一：仿真顶层 wrapper — 连接官方 testbench 和 DUT
// 官方 testbench.v 为纯激励发生器，不例化 DUT
// 本模块将其与 network_parser 连接，作为 ModelSim 仿真顶层
// =============================================================================

module top_sim();

    wire        clk, rst_n;
    wire [63:0] tdata;
    wire [7:0]  tkeep;
    wire        tvalid, tready, tlast;

    wire        WEA, data_valid;
    wire [63:0] DINA;
    wire [2:0]  ADDRA;
    wire [7:0]  fourth_protocl, ICMP_Type;
    wire [31:0] SrcIP, DesIP;

    testbench u_tb (
        .clk   (clk),
        .rst_n (rst_n),
        .tdata (tdata),
        .tkeep (tkeep),
        .tvalid(tvalid),
        .tready(tready),
        .tlast (tlast)
    );

    network_parser u_dut (
        .clk           (clk),
        .rst_n         (rst_n),
        .tvalid        (tvalid),
        .tdata         (tdata),
        .tkeep         (tkeep),
        .tready        (tready),
        .tlast         (tlast),
        .WEA           (WEA),
        .DINA          (DINA),
        .ADDRA         (ADDRA),
        .data_valid    (data_valid),
        .fourth_protocl(fourth_protocl),
        .SrcIP         (SrcIP),
        .DesIP         (DesIP),
        .ICMP_Type     (ICMP_Type)
    );

endmodule

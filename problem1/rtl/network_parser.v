`timescale 1ns / 1ps

// =============================================================================
// 题目一：网络协议解析电路 — 兼容官方 testbench
// =============================================================================

module network_parser (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        tvalid,
    input  wire [63:0] tdata,
    input  wire [7:0]  tkeep,
    output wire        tready,
    input  wire        tlast,

    output wire        WEA,
    output wire [63:0] DINA,
    output wire [2:0]  ADDRA,

    output wire        data_valid,
    output wire [7:0]  fourth_protocl,
    output wire [31:0] SrcIP,
    output wire [31:0] DesIP,
    output wire [7:0]  ICMP_Type
);

    wire rx_parser_done;

    assign tready = rst_n;

    axis_rx_parser u_parser (
        .clk      (clk),
        .rst_n    (rst_n),
        .tvalid   (tvalid),
        .tdata    (tdata),
        .tready   (tready),
        .tlast    (tlast),
        .protocol (fourth_protocl),
        .src_ip   (SrcIP),
        .dst_ip   (DesIP),
        .icmp_type(ICMP_Type),
        .data_valid(rx_parser_done)
    );

    assign data_valid = rx_parser_done;

    store_ctrl u_store (
        .clk          (clk),
        .rst_n        (rst_n),
        .data_valid_in(rx_parser_done),
        .protocol     (fourth_protocl),
        .src_ip       (SrcIP),
        .dst_ip       (DesIP),
        .icmp_type    (ICMP_Type),
        .WEA          (WEA),
        .DINA         (DINA),
        .ADDRA        (ADDRA)
    );

    data_storage u_storage (
        .clk (clk),
        .we  (WEA),
        .addr(ADDRA),
        .din (DINA)
    );

endmodule


// =============================================================================
// 子模块 1：axis_rx_parser — 从 AXI-Stream 提取特征字段
// =============================================================================
module axis_rx_parser (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        tvalid,
    input  wire [63:0] tdata,
    input  wire        tready,
    input  wire        tlast,

    output reg  [7:0]  protocol,
    output reg  [31:0] src_ip,
    output reg  [31:0] dst_ip,
    output reg  [7:0]  icmp_type,
    output reg         data_valid
);

    reg [7:0]  word_cnt;
    reg        is_ipv4;
    reg [15:0] dst_ip_low_temp;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            word_cnt        <= 8'd0;
            is_ipv4         <= 1'b0;
            protocol        <= 8'd0;
            src_ip          <= 32'd0;
            dst_ip          <= 32'd0;
            icmp_type       <= 8'd0;
            data_valid      <= 1'b0;
            dst_ip_low_temp <= 16'd0;
        end else begin
            data_valid <= 1'b0;
            if (tvalid && tready) begin
                word_cnt <= tlast ? 8'd0 : word_cnt + 1'b1;

                case (word_cnt)
                    8'd1: begin
                        if (tdata[47:32] == 16'h0008)
                            is_ipv4 <= 1'b1;
                        else
                            is_ipv4 <= 1'b0;
                    end

                    8'd2: begin
                        if (is_ipv4)
                            protocol <= tdata[63:56];
                    end

                    8'd3: begin
                        if (is_ipv4) begin
                            src_ip          <= tdata[47:16];
                            dst_ip_low_temp <= tdata[63:48];
                        end
                    end

                    8'd4: begin
                        if (is_ipv4) begin
                            dst_ip    <= {tdata[15:0], dst_ip_low_temp};
                            icmp_type <= tdata[23:16];
                        end else begin
                            protocol  <= 8'hFF;
                            src_ip    <= 32'hFFFF_FFFF;
                            dst_ip    <= 32'hFFFF_FFFF;
                            icmp_type <= 8'hFF;
                        end
                        data_valid <= 1'b1;
                    end
                endcase
            end
        end
    end

endmodule


// =============================================================================
// 子模块 2：store_ctrl — 两拍写入控制器
// =============================================================================
module store_ctrl (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        data_valid_in,
    input  wire [7:0]  protocol,
    input  wire [31:0] src_ip,
    input  wire [31:0] dst_ip,
    input  wire [7:0]  icmp_type,

    output reg         WEA,
    output reg  [63:0] DINA,
    output reg  [2:0]  ADDRA
);

    reg [1:0] frame_idx;
    reg       beat;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            frame_idx <= 2'd0;
            beat      <= 1'b0;
            WEA       <= 1'b0;
            DINA      <= 64'd0;
            ADDRA     <= 3'd0;
        end else begin
            WEA <= 1'b0;
            case (beat)
                1'b0: begin
                    if (data_valid_in) begin
                        WEA   <= 1'b1;
                        ADDRA <= {frame_idx, 1'b0};
                        DINA  <= {dst_ip, src_ip};
                        beat  <= 1'b1;
                    end
                end

                1'b1: begin
                    WEA   <= 1'b1;
                    ADDRA <= {frame_idx, 1'b1};
                    DINA  <= {48'd0, icmp_type, protocol};
                    frame_idx <= (frame_idx == 2'd2) ? 2'd0 : frame_idx + 1'b1;
                    beat  <= 1'b0;
                end
            endcase
        end
    end

endmodule


// =============================================================================
// 子模块 3：data_storage — 64位×8深寄存器堆
// =============================================================================
module data_storage (
    input  wire        clk,
    input  wire        we,
    input  wire [2:0]  addr,
    input  wire [63:0] din
);

    reg [63:0] mem [0:7];

    always @(posedge clk) begin
        if (we) mem[addr] <= din;
    end

endmodule

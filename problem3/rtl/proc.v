`timescale 1ns / 1ps

// =============================================================================
// 题目三：8位单总线处理器 — 完全兼容官方 proc_tb
//
// 指令（Fun[1:0]）：00=LOAD  01=MOVE  10=ADD  11=SUB
// 状态机：IDLE→FETCH→EXEC1→EXEC2→DONE
//   LOAD/MOVE：2周期（IDLE→FETCH→DONE）
//   ADD/SUB  ：4周期（IDLE→FETCH→EXEC1→EXEC2→DONE）
//
// 修正：寄存器写入与状态机在同一 always 块内完成，
//       ST_FETCH 直接写 rf[Rx]（LOAD/MOVE），
//       ST_EXEC2 直接写 latch_g 到 rf[Rx]（ADD/SUB），
//       消除原 we 信号 NBA 延迟一拍的问题。
// =============================================================================

module proc (
    input  wire [7:0] Data,
    input  wire       Reset,
    input  wire       Run,
    input  wire       Clock,
    input  wire [1:0] Fun,
    input  wire [1:0] Rx,
    input  wire [1:0] Ry,
    output reg        Done,
    output wire [7:0] BusWires
);

    reg [7:0] rf [0:3];
    reg [7:0] latch_a;
    reg [7:0] latch_g;

    localparam ST_IDLE  = 3'd0;
    localparam ST_FETCH = 3'd1;
    localparam ST_EXEC1 = 3'd2;
    localparam ST_EXEC2 = 3'd3;
    localparam ST_DONE  = 3'd4;

    reg [2:0] state;
    reg [1:0] bus_sel;
    reg       alu_sub;
    reg [7:0] bus_val;

    assign BusWires = bus_val;

    always @(*) begin
        case (bus_sel)
            2'd0: bus_val = Data;
            2'd1: bus_val = rf[Rx];
            2'd2: bus_val = rf[Ry];
            2'd3: bus_val = latch_g;
        endcase
    end

    always @(posedge Clock or posedge Reset) begin
        if (Reset) begin
            state   <= ST_IDLE;
            Done    <= 1'b0;
            bus_sel <= 2'd0;
            alu_sub <= 1'b0;
            latch_a <= 8'd0;
            latch_g <= 8'd0;
            rf[0]   <= 8'd0;
            rf[1]   <= 8'd0;
            rf[2]   <= 8'd0;
            rf[3]   <= 8'd0;
        end else begin
            case (state)
                ST_IDLE: begin
                    Done <= 1'b0;
                    if (Run) begin
                        case (Fun)
                            2'b00: bus_sel <= 2'd0;   // LOAD: Data→总线
                            2'b01: bus_sel <= 2'd2;   // MOVE: R[Ry]→总线
                            2'b10: bus_sel <= 2'd1;   // ADD:  R[Rx]→总线
                            2'b11: bus_sel <= 2'd1;   // SUB:  R[Rx]→总线
                        endcase
                        state <= ST_FETCH;
                    end
                end

                ST_FETCH: begin
                    latch_a <= BusWires;
                    case (Fun)
                        2'b00, 2'b01: begin
                            // LOAD/MOVE: 同一拍将 BusWires 写入 rf[Rx]
                            case (Rx)
                                2'd0: rf[0] <= BusWires;
                                2'd1: rf[1] <= BusWires;
                                2'd2: rf[2] <= BusWires;
                                2'd3: rf[3] <= BusWires;
                            endcase
                            state <= ST_DONE;
                        end
                        default: begin
                            bus_sel <= 2'd2;
                            alu_sub <= (Fun == 2'b11);
                            state   <= ST_EXEC1;
                        end
                    endcase
                end

                ST_EXEC1: begin
                    latch_g <= alu_sub ? (latch_a - BusWires)
                                       : (latch_a + BusWires);
                    state   <= ST_EXEC2;
                end

                ST_EXEC2: begin
                    bus_sel <= 2'd3;
                    // ADD/SUB: 同一拍将 latch_g 写入 rf[Rx]
                    case (Rx)
                        2'd0: rf[0] <= latch_g;
                        2'd1: rf[1] <= latch_g;
                        2'd2: rf[2] <= latch_g;
                        2'd3: rf[3] <= latch_g;
                    endcase
                    state   <= ST_DONE;
                end

                ST_DONE: begin
                    Done <= 1'b1;
                    if (!Run) begin
                        Done  <= 1'b0;
                        state <= ST_IDLE;
                    end else begin
                        // 下一条指令的 Run 已经拉高，直接启动避免错过脉冲
                        Done  <= 1'b0;
                        case (Fun)
                            2'b00: bus_sel <= 2'd0;
                            2'b01: bus_sel <= 2'd2;
                            2'b10: bus_sel <= 2'd1;
                            2'b11: bus_sel <= 2'd1;
                        endcase
                        state <= ST_FETCH;
                    end
                end

                default: state <= ST_IDLE;
            endcase
        end
    end

endmodule

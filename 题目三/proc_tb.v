`timescale 1ns/1ps

// 定义测试模块
module proc_tb();

    // 定义参数与被测试模块中的参数保持一致
    parameter n = 8;

    // 声明输入信号，对应被测试模块的输入端口
    reg [7:0] Data;
    reg Reset;
    reg Run;
    reg Clock;
    reg [1:0] Fun;
    reg [1:0] Rx;
    reg [1:0] Ry;

    // 声明输出信号，对应被测试模块的输出端口
    wire [7:0] BusWires;
    wire Done;

    // 实例化被测试的proc模块
    proc dut (
      .Data(Data),
      .Reset(Reset),
      .Run(Run),
      .Clock(Clock),
      .Fun(Fun),
      .Rx(Rx),
      .Ry(Ry),
      .Done(Done),
      .BusWires(BusWires)
    );

    // 时钟生成逻辑，产生周期为10ns的时钟信号
    always #5 Clock = ~Clock;
	
    // 测试激励产生部分
    initial begin
        // 初始化信号
        Data = 0;
        Reset = 1;
        Run = 0;
        Clock = 0;
        Fun = 0;
        Rx = 0;
        Ry = 0;

        // 复位操作，保持复位高电平一段时间
        #10;
        Reset = 0;

        // 第一步：将0x33送入R0寄存器
        #10;
        Data = 8'h33;
        Fun = 0;
        Rx = 0;
        Ry = 0;
        Run = 1;
		
        #10;
        Run = 0;

        // 第二步：将0x22送入R1寄存器
        #10;
        Data = 8'h22;
        Fun = 0;
        Rx = 1;
        Ry = 0;
        Run = 1;
        #10;
        Run = 0;

        // 第三步：将0x11送入R2寄存器
        #10;
        Data = 8'h11;
        Fun = 0;
        Rx = 2;
        Ry = 0;
        Run = 1;
        #10;
        Run = 0;

        // 第四步：执行R0 + R1运算并将结果保存R0
        #10;
        Fun = 2;
        Rx = 0;
        Ry = 1;
        Run = 1;
        #10;
        Run = 0;
    
    
        // 第五步：执行R0移入R3
        #30;
        Fun = 1;
        Rx = 3;
        Ry = 0;
        Run = 1;
        #10;
        Run = 0;

        
		// 第六步：执行R1 - R2运算并将结果保存R1
        #50;
        Fun = 3;
        Rx = 1;
        Ry = 2;
        Run = 1;
        #10;
        Run = 0;

        // 持续运行一段时间，观察输出和状态变化并结束
        #40 $finish;
    end

endmodule
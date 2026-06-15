library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity proc_tb is
end entity;

architecture behavior of proc_tb is
    constant n : integer := 8;

    -- 声明输入信号，对应被测试模块的输入端口
    signal Data : std_logic_vector(7 downto 0);
    signal Reset : std_logic;
    signal Run : std_logic;
    signal Clock : std_logic;
    signal Fun : std_logic_vector(1 downto 0);
    signal Rx : std_logic_vector(1 downto 0);
    signal Ry : std_logic_vector(1 downto 0);

    -- 声明输出信号，对应被测试模块的输出端口
    signal BusWires : std_logic_vector(7 downto 0);
    signal Done : std_logic;

    -- 组件声明
    component proc is
        port(
            Data : in std_logic_vector(7 downto 0);
            Reset : in std_logic;
            Run : in std_logic;
            Clock : in std_logic;
            Fun : in std_logic_vector(1 downto 0);
            Rx : in std_logic_vector(1 downto 0);
            Ry : in std_logic_vector(1 downto 0);
            Done : out std_logic;
            BusWires : out std_logic_vector(7 downto 0)
        );
    end component;

begin
    -- 实例化被测试的proc模块
    dut : proc
        port map(
            Data => Data,
            Reset => Reset,
            Run => Run,
            Clock => Clock,
            Fun => Fun,
            Rx => Rx,
            Ry => Ry,
            Done => Done,
            BusWires => BusWires
        );

    -- 时钟生成逻辑，产生周期为10ns的时钟信号
    process
    begin
        Clock <= '0';
        wait for 5 ns;
        Clock <= '1';
        wait for 5 ns;
    end process;

    -- 测试激励产生部分
    process
    begin
        -- 初始化信号
        Data <= (others => '0');
        Reset <= '1';
        Run <= '0';
        Clock <= '0';
        Fun <= "00";
        Rx <= "00";
        Ry <= "00";

        -- 复位操作，保持复位高电平一段时间
        wait for 10 ns;
        Reset <= '0';

        -- 第一步：将0x33载数送入R0寄存器
        wait for 10 ns;
        Data <= x"33";
        Fun <= "00";
        Rx <= "00";
        Ry <= "00";
        Run <= '1';
        wait for 10 ns;
        Run <= '0';

        -- 第二步：将0x22载数送入R1寄存器
        wait for 10 ns;
        Data <= x"22";
        Fun <= "00";
        Rx <= "01";
        Ry <= "00";
        Run <= '1';
        wait for 10 ns;
        Run <= '0';

        -- 第三步：将0x11载数送入R2寄存器
        wait for 10 ns;
        Data <= x"11";
        Fun <= "00";
        Rx <= "10";
        Ry <= "00";
        Run <= '1';
        wait for 10 ns;
        Run <= '0';

        -- 第四步：执行R0 + R1运算并将结果保存R0
        wait for 10 ns;
        Fun <= "10";
        Rx <= "00";
        Ry <= "01";
        Run <= '1';
        wait for 10 ns;
        Run <= '0';

        -- 第五步：执行R0转存并移入R3
        wait for 30 ns;
        Fun <= "01";
        Rx <= "11";
        Ry <= "00";
        Run <= '1';
        wait for 10 ns;
        Run <= '0';

        -- 第六步：执行R1 - R2运算并将结果保存R1
        wait for 50 ns;
        Fun <= "11";
        Rx <= "01";
        Ry <= "10";
        Run <= '1';
        wait for 10 ns;
        Run <= '0';

        -- 持续运行一段时间，观察输出和状态变化
        wait for 40 ns;
    end process;
end architecture;

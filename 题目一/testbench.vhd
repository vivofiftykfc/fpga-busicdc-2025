----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2025/05/21 14:58:14
-- Design Name: 
-- Module Name: testbench - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity testbench is
port(
    clk     : out std_logic;
    rst_n   : out std_logic;
    tdata   : out std_logic_vector(63 downto 0);
    tkeep   : out std_logic_vector(7 downto 0);
    tvalid  : out std_logic;
    tready  : in  std_logic;
    tlast   : out std_logic
);
end testbench;

architecture Behavioral of testbench is
signal clk_s      : std_logic := '0';
    signal rst_n_s    : std_logic := '0';
    
    signal counter64_in_frame    : unsigned(10 downto 0) := (others => '0');
    
    -- Constants (converted from Verilog assign statements)
    constant dest_MAC_addr        : std_logic_vector(47 downto 0) := x"010203040506";
    constant src_MAC_addr         : std_logic_vector(47 downto 0) := x"010203040506";
    constant second_protocl       : std_logic_vector(15 downto 0) := x"0008";
    constant VLAN       : std_logic_vector(15 downto 0) := x"0081";
    constant IP_Version       : std_logic_vector(3 downto 0) := x"4";
    constant IP_Header_Length       : std_logic_vector(3 downto 0) := x"5";
    constant IP_TOS       : std_logic_vector(7 downto 0) := x"00";
    constant IP_Total_Length       : std_logic_vector(15 downto 0) := x"0030";
    constant IP_ID       : std_logic_vector(15 downto 0) := x"abcd";
    constant IP_Flag_and_Fragment_Offset       : std_logic_vector(15 downto 0) := x"0040";
    constant IP_TTL       : std_logic_vector(7 downto 0) := x"00";
    constant fourth_protocl       : std_logic_vector(7 downto 0) := x"01";
    constant IP_Header_Checksum       : std_logic_vector(15 downto 0) := x"0000";
    constant SrcIP_1       : std_logic_vector(31 downto 0) := x"c801080a";
    constant SrcIP_2       : std_logic_vector(31 downto 0) := x"6401080a";
    constant DesIP_1       : std_logic_vector(31 downto 0) := x"6401080a";
    constant DesIP_2       : std_logic_vector(31 downto 0) := x"c801080a";
    constant ICMP_Header_1       : std_logic_vector(63 downto 0) := x"5566778833442211";
    constant ICMP_Header_2       : std_logic_vector(63 downto 0) := x"5566778833442222";
    constant TCP_data       : std_logic_vector(5887 downto 0) := x"00000000001111111111222222222233333333334444444444555555555566666666667777777777888888880000000000111111111122222222223333333333444444444455555555556666666666777777777788888888889999999999000000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000000111111111122222222223333333333444444444455555555556666666666777777777788888888889999999999000000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000000111111111122222222223333333333444444444455555555556666666666777777777788888888889999999999000000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000000111111111122222222223333333333444444444455555555556666666666777777777788888888889999999999000000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000000111111111122222222223333333333444444444455555555556666666666777777777788888888889999999999000000000011111111112222222222333333333344444444445555555555666666666677777777778888";
    constant fill       : std_logic_vector(175 downto 0) := x"00000000000000000000000000000000000000000000";
    -- 大容量信号声明
    signal send_data      : std_logic_vector(6399 downto 0) := (others => '0');
    signal IP_ICMP_1      : std_logic_vector(6399 downto 0);
    signal IP_ICMP_2      : std_logic_vector(6399 downto 0);
    signal IP_ICMP_3      : std_logic_vector(6399 downto 0);
begin
-- 端口连接
    clk <= clk_s;
    rst_n <= rst_n_s;

    -- 时钟生成进程
    clk_process: process
    begin
        clk_s <= '0';
        wait for 3.2 ns;
        clk_s <= '1';
        wait for 3.2 ns;
    end process;

    -- 复位生成进程
    reset_process: process
    begin
        rst_n_s <= '0';
        wait for 50 ns;
        rst_n_s <= '1';
        wait;
    end process;

    -- 主控制逻辑进程
    main_process: process(clk_s, rst_n_s)
    begin
        if rst_n_s = '0' then
            tdata  <= (others => '0');
            tkeep  <= (others => '0');
            tvalid <= '0';
            tlast  <= '0';
            send_data <= (others => '0');
        elsif rising_edge(clk_s) then
            tkeep <= x"ff";
            
            -- 计数器逻辑
            if counter64_in_frame = 400 then
                counter64_in_frame <= counter64_in_frame;
            else
                counter64_in_frame <= counter64_in_frame + 1;
            end if;

            -- 数据生成逻辑
            case to_integer(counter64_in_frame) is
                when 0 =>
                    send_data <= IP_ICMP_1;
                when 102 =>
                    send_data <= IP_ICMP_2;
                when 204 =>
                    send_data <= IP_ICMP_3;
                when others =>
                    if ((counter64_in_frame >=1 and counter64_in_frame <= 100) or
                        (counter64_in_frame >=103 and counter64_in_frame <= 202) or
                        (counter64_in_frame >=205 and counter64_in_frame <= 304)) then
                        send_data <= std_logic_vector(unsigned(send_data) srl 64);
                    else
                        send_data <= (others => '0');
                    end if;
            end case;

            -- tvalid/tlast生成
            tvalid <= '0';
            if ((counter64_in_frame >=1 and counter64_in_frame <= 100) or
                (counter64_in_frame >=103 and counter64_in_frame <= 202) or
                (counter64_in_frame >=205 and counter64_in_frame <= 304)) then
                tvalid <= '1';
            end if;

            tlast <= '0';
            if counter64_in_frame = 100 or 
               counter64_in_frame = 202 or 
               counter64_in_frame = 304 then
                tlast <= '1';
            end if;

            -- tdata赋值
            if ((counter64_in_frame >=1 and counter64_in_frame <= 100) or
                (counter64_in_frame >=103 and counter64_in_frame <= 202) or
                (counter64_in_frame >=205 and counter64_in_frame <= 304)) then
                tdata <= send_data(63 downto 0);
            else
                tdata <= (others => '0');
            end if;
        end if;
    end process;

    -- 组合逻辑赋值
    IP_ICMP_1 <= TCP_data & fill & ICMP_Header_1 & DesIP_1 & SrcIP_1 & 
                IP_Header_Checksum & fourth_protocl & IP_TTL & IP_Flag_and_Fragment_Offset & 
                IP_ID & IP_Total_Length & IP_TOS & IP_Version & IP_Header_Length & 
                VLAN & src_MAC_addr & dest_MAC_addr;
     IP_ICMP_2 <= TCP_data & fill & ICMP_Header_1 & DesIP_1 & SrcIP_1 & 
                IP_Header_Checksum & fourth_protocl & IP_TTL & IP_Flag_and_Fragment_Offset & 
                IP_ID & IP_Total_Length & IP_TOS & IP_Version & IP_Header_Length & 
                second_protocl & src_MAC_addr & dest_MAC_addr;
     IP_ICMP_3 <= TCP_data & fill & ICMP_Header_2 & DesIP_2 & SrcIP_2 & 
                IP_Header_Checksum & fourth_protocl & IP_TTL & IP_Flag_and_Fragment_Offset & 
                IP_ID & IP_Total_Length & IP_TOS & IP_Version & IP_Header_Length & 
                second_protocl & src_MAC_addr & dest_MAC_addr;  

end Behavioral;

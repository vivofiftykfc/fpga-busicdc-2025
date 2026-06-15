# 题目一 仿真脚本 — 官方 testbench 无 $finish，使用 run 3000ns
transcript on

if {[file exists work]} { vdel -lib work -all }
vlib work
vmap work work

vlog -work work ../rtl/testbench.v
vlog -work work ../rtl/network_parser.v
vlog -work work ../rtl/top_sim.v

vsim -voptargs="+acc" top_sim

add wave -divider "AXI-Stream"
add wave -hex sim:/top_sim/clk
add wave -hex sim:/top_sim/rst_n
add wave -hex sim:/top_sim/tvalid
add wave -hex sim:/top_sim/tdata
add wave -hex sim:/top_sim/tkeep
add wave -hex sim:/top_sim/tready
add wave -hex sim:/top_sim/tlast

add wave -divider "Parser Outputs"
add wave -hex sim:/top_sim/u_dut/data_valid
add wave -hex sim:/top_sim/u_dut/fourth_protocl
add wave -hex sim:/top_sim/u_dut/SrcIP
add wave -hex sim:/top_sim/u_dut/DesIP
add wave -hex sim:/top_sim/u_dut/ICMP_Type

add wave -divider "Parser Internal"
add wave -hex sim:/top_sim/u_dut/u_parser/word_cnt
add wave -hex sim:/top_sim/u_dut/u_parser/is_ipv4
add wave -hex sim:/top_sim/u_dut/u_parser/dst_ip_low_temp

add wave -divider "Storage"
add wave -hex sim:/top_sim/u_dut/WEA
add wave -hex sim:/top_sim/u_dut/ADDRA
add wave -hex sim:/top_sim/u_dut/DINA

add wave -divider "Store Internal"
add wave -hex sim:/top_sim/u_dut/u_store/beat
add wave -hex sim:/top_sim/u_dut/u_store/frame_idx

add wave -divider "Memory"
add wave -hex sim:/top_sim/u_dut/u_storage/mem

add wave -divider "Frame Info"
add wave -hex sim:/top_sim/u_tb/counter64_in_frame

run 3000ns
wave zoom full

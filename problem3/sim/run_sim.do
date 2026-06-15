# 题目三 仿真脚本 — 官方 proc_tb 含 $finish
transcript on

if {[file exists work]} { vdel -lib work -all }
vlib work
vmap work work

vlog -work work ../rtl/proc.v
vlog -work work ../rtl/proc_tb.v

vsim -voptargs="+acc" proc_tb

add wave -divider "Control"
add wave -hex sim:/proc_tb/Clock
add wave -hex sim:/proc_tb/Reset
add wave -hex sim:/proc_tb/Run
add wave -hex sim:/proc_tb/Fun
add wave -hex sim:/proc_tb/Rx
add wave -hex sim:/proc_tb/Ry
add wave -hex sim:/proc_tb/Done

add wave -divider "Data"
add wave -hex sim:/proc_tb/Data
add wave -hex sim:/proc_tb/BusWires

add wave -divider "FSM"
add wave -hex sim:/proc_tb/dut/state
add wave -hex sim:/proc_tb/dut/latch_a
add wave -hex sim:/proc_tb/dut/latch_g
add wave -hex sim:/proc_tb/dut/bus_sel
add wave -hex sim:/proc_tb/dut/alu_sub

add wave -divider "Registers"
add wave -hex sim:/proc_tb/dut/rf

run -all
wave zoom full

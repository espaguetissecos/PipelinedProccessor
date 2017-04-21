onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /procesador_tb/Clk
add wave -noupdate /procesador_tb/Reset
add wave -noupdate /procesador_tb/I_Addr
add wave -noupdate -radix binary /procesador_tb/I_DataIn
add wave -noupdate -radix binary /procesador_tb/D_Addr
add wave -noupdate -radix binary /procesador_tb/D_WrEn
add wave -noupdate -radix binary /procesador_tb/D_DataOut
add wave -noupdate -radix binary /procesador_tb/D_DataIn
add wave -noupdate -radix unsigned /procesador_tb/UUT/ALU/Op1
add wave -noupdate -radix unsigned /procesador_tb/UUT/ALU/Op2
add wave -noupdate -radix unsigned /procesador_tb/UUT/SigRd1_EX
add wave -noupdate -radix unsigned /procesador_tb/UUT/SigRd2_EX
add wave -noupdate -group _FU -radix unsigned /procesador_tb/UUT/SigRd1_FU
add wave -noupdate -group _FU -radix unsigned /procesador_tb/UUT/SigRd2_FU
add wave -noupdate -radix unsigned /procesador_tb/UUT/SigRes_MEM
add wave -noupdate -radix unsigned /procesador_tb/UUT/SigWd3
add wave -noupdate -group hyazar /procesador_tb/UUT/SigPCWrite
add wave -noupdate -group hyazar /procesador_tb/UUT/SigIFIDWrite
add wave -noupdate -group hyazar /procesador_tb/UUT/SigExBubbleWrite
add wave -noupdate -group forwardmux /procesador_tb/UUT/SigRd1Mux
add wave -noupdate -group forwardmux /procesador_tb/UUT/SigRd2Mux
add wave -noupdate -radix binary -childformat {{/procesador_tb/UUT/REG/regs(0) -radix unsigned} {/procesador_tb/UUT/REG/regs(1) -radix unsigned} {/procesador_tb/UUT/REG/regs(2) -radix unsigned} {/procesador_tb/UUT/REG/regs(3) -radix unsigned} {/procesador_tb/UUT/REG/regs(4) -radix unsigned} {/procesador_tb/UUT/REG/regs(5) -radix unsigned} {/procesador_tb/UUT/REG/regs(6) -radix unsigned} {/procesador_tb/UUT/REG/regs(7) -radix unsigned} {/procesador_tb/UUT/REG/regs(8) -radix unsigned} {/procesador_tb/UUT/REG/regs(9) -radix unsigned} {/procesador_tb/UUT/REG/regs(10) -radix unsigned} {/procesador_tb/UUT/REG/regs(11) -radix unsigned} {/procesador_tb/UUT/REG/regs(12) -radix unsigned} {/procesador_tb/UUT/REG/regs(13) -radix unsigned} {/procesador_tb/UUT/REG/regs(14) -radix unsigned} {/procesador_tb/UUT/REG/regs(15) -radix unsigned} {/procesador_tb/UUT/REG/regs(16) -radix unsigned} {/procesador_tb/UUT/REG/regs(17) -radix unsigned} {/procesador_tb/UUT/REG/regs(18) -radix unsigned} {/procesador_tb/UUT/REG/regs(19) -radix unsigned} {/procesador_tb/UUT/REG/regs(20) -radix unsigned} {/procesador_tb/UUT/REG/regs(21) -radix unsigned} {/procesador_tb/UUT/REG/regs(22) -radix unsigned} {/procesador_tb/UUT/REG/regs(23) -radix unsigned} {/procesador_tb/UUT/REG/regs(24) -radix unsigned} {/procesador_tb/UUT/REG/regs(25) -radix binary} {/procesador_tb/UUT/REG/regs(26) -radix binary} {/procesador_tb/UUT/REG/regs(27) -radix binary} {/procesador_tb/UUT/REG/regs(28) -radix binary} {/procesador_tb/UUT/REG/regs(29) -radix binary} {/procesador_tb/UUT/REG/regs(30) -radix binary} {/procesador_tb/UUT/REG/regs(31) -radix binary}} -subitemconfig {/procesador_tb/UUT/REG/regs(0) {-height 15 -radix unsigned} /procesador_tb/UUT/REG/regs(1) {-height 15 -radix unsigned} /procesador_tb/UUT/REG/regs(2) {-height 15 -radix unsigned} /procesador_tb/UUT/REG/regs(3) {-height 15 -radix unsigned} /procesador_tb/UUT/REG/regs(4) {-height 15 -radix unsigned} /procesador_tb/UUT/REG/regs(5) {-height 15 -radix unsigned} /procesador_tb/UUT/REG/regs(6) {-height 15 -radix unsigned} /procesador_tb/UUT/REG/regs(7) {-height 15 -radix unsigned} /procesador_tb/UUT/REG/regs(8) {-height 15 -radix unsigned} /procesador_tb/UUT/REG/regs(9) {-height 15 -radix unsigned} /procesador_tb/UUT/REG/regs(10) {-height 15 -radix unsigned} /procesador_tb/UUT/REG/regs(11) {-height 15 -radix unsigned} /procesador_tb/UUT/REG/regs(12) {-height 15 -radix unsigned} /procesador_tb/UUT/REG/regs(13) {-height 15 -radix unsigned} /procesador_tb/UUT/REG/regs(14) {-height 15 -radix unsigned} /procesador_tb/UUT/REG/regs(15) {-height 15 -radix unsigned} /procesador_tb/UUT/REG/regs(16) {-height 15 -radix unsigned} /procesador_tb/UUT/REG/regs(17) {-height 15 -radix unsigned} /procesador_tb/UUT/REG/regs(18) {-height 15 -radix unsigned} /procesador_tb/UUT/REG/regs(19) {-height 15 -radix unsigned} /procesador_tb/UUT/REG/regs(20) {-height 15 -radix unsigned} /procesador_tb/UUT/REG/regs(21) {-height 15 -radix unsigned} /procesador_tb/UUT/REG/regs(22) {-height 15 -radix unsigned} /procesador_tb/UUT/REG/regs(23) {-height 15 -radix unsigned} /procesador_tb/UUT/REG/regs(24) {-height 15 -radix unsigned} /procesador_tb/UUT/REG/regs(25) {-height 15 -radix binary} /procesador_tb/UUT/REG/regs(26) {-height 15 -radix binary} /procesador_tb/UUT/REG/regs(27) {-height 15 -radix binary} /procesador_tb/UUT/REG/regs(28) {-height 15 -radix binary} /procesador_tb/UUT/REG/regs(29) {-height 15 -radix binary} /procesador_tb/UUT/REG/regs(30) {-height 15 -radix binary} /procesador_tb/UUT/REG/regs(31) {-height 15 -radix binary}} /procesador_tb/UUT/REG/regs
add wave -noupdate -group err /procesador_tb/UUT/SigA1_EX
add wave -noupdate -group err /procesador_tb/UUT/SigA2_EX
add wave -noupdate -group err /procesador_tb/UUT/SigRegWrite_MEM
add wave -noupdate -group err /procesador_tb/UUT/SigA3_MEM
add wave -noupdate -group err /procesador_tb/UUT/SigRegWrite_WB
add wave -noupdate -group err /procesador_tb/UUT/SigA3_WB
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {304695 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 243
configure wave -valuecolwidth 217
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1188184 ps}

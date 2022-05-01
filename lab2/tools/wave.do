onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/lab2_ifc/clk
add wave -noupdate /top/lab2_ifc/reset_n
add wave -noupdate /top/lab2_ifc/load_en
add wave -noupdate -radix decimal /top/lab2_ifc/write_pointer
add wave -noupdate /top/lab2_ifc/opcode
add wave -noupdate /top/lab2_ifc/operand_a
add wave -noupdate /top/lab2_ifc/operand_b
add wave -noupdate -radix decimal /top/lab2_ifc/read_pointer
add wave -noupdate /top/lab2_ifc/instruction_word
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {15 ns} 0}
configure wave -namecolwidth 235
configure wave -valuecolwidth 99
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
WaveRestoreZoom {0 ns} {118 ns}

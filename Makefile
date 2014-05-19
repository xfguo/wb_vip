all:
	iverilog wb_master.v tb_wb_master.v
	./a.out

clean:
	rm -rf a.out db_tb_wb_master.vcd
	

module tb_wb_master;

reg               wb_clk_i    ;
reg               wb_rst_i    ;
wire              wb_cyc_o    ;
wire              wb_stb_o    ;
wire              wb_we_o     ;
wire    [3:0]     wb_sel_o    ;
wire    [31:0]    wb_adr_o    ;
wire    [31:0]    wb_dat_o    ;
reg     [31:0]    wb_dat_i    ;
reg               wb_ack_i    ;

wb_master uut (
    .wb_clk_i    (    wb_clk_i    ),
    .wb_rst_i    (    wb_rst_i    ),
    .wb_cyc_o    (    wb_cyc_o    ),
    .wb_stb_o    (    wb_stb_o    ),
    .wb_we_o     (    wb_we_o     ),
    .wb_sel_o    (    wb_sel_o    ),
    .wb_adr_o    (    wb_adr_o    ),
    .wb_dat_o    (    wb_dat_o    ),
    .wb_dat_i    (    wb_dat_i    ),
    .wb_ack_i    (    wb_ack_i    )
);

parameter PERIOD = 10;

initial begin
    $dumpfile("db_tb_wb_master.vcd");
    $dumpvars(0, tb_wb_master);
    wb_clk_i = 1'b0;
    #(PERIOD/2);
    forever
        #(PERIOD/2) wb_clk_i = ~wb_clk_i;
end

initial begin
    
end

reg     [31:0]  dat_out;
wire    [31:0]  dat_in;
initial begin
    wb_rst_i = 1'b1;
    repeat (3) @(posedge wb_clk_i);
    wb_rst_i = 1'b0;

    wb_ack_i = 1'b1;
    wb_dat_i = 'h33445566;
    uut.read32('haabbccdd, dat_out);
    uut.write32('haaaa5555, 'h01010202);
    repeat(30) @(posedge wb_clk_i);
    $finish();
end

endmodule


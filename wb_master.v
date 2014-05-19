module wb_master(
input               wb_clk_i,
input               wb_rst_i,

output              wb_cyc_o,
output              wb_stb_o,
output              wb_we_o,
output  [3:0]       wb_sel_o,
output  [31:0]      wb_adr_o,
output  [31:0]      wb_dat_o,
input   [31:0]      wb_dat_i,
input               wb_ack_i,
input               wb_err_i
);

reg                 wb_cyc_r;
reg                 wb_stb_r;
reg                 wb_we_r;
reg     [31:0]      wb_adr_r;
reg     [31:0]      wb_dat_r;
reg     [3:0]       wb_sel_r;

initial begin
    while(1) begin
        @(wb_rst_i == 1'b1);
        wb_cyc_r = 'd0;
        wb_stb_r = 'd0;
        wb_we_r  = 'd0;
        wb_adr_r = 'd0;
        wb_dat_r = 'd0;
        wb_sel_r = 'd0;
    end
end

/* TODO: wait multi-cycles */
task read32;
    input   [31:0]  adr;
    output  [31:0]  dat_out;
    begin
        @(posedge wb_clk_i);
        wb_adr_r = adr;
        wb_cyc_r = 1'b1;
        wb_stb_r = 1'b1;
        wb_we_r  = 1'b0;
        wb_sel_r = 4'b1111;
        
        @(posedge wb_clk_i);
        if (wb_ack_i == 1'b1) begin
            dat_out = wb_dat_i;
        end
        @(posedge wb_clk_i);
        wb_cyc_r = 1'b0;
        wb_stb_r = 1'b0;
    end
endtask

task write32;
    input   [31:0]  adr;
    input   [31:0]  dat_in;
    begin
        @(posedge wb_clk_i);
        wb_adr_r = adr;
        wb_cyc_r = 1'b1;
        wb_stb_r = 1'b1;
        wb_we_r  = 1'b1;
        wb_sel_r = 4'b1111;
        wb_dat_r = dat_in;
        
        @(posedge wb_clk_i);

        @(posedge wb_clk_i);
        wb_cyc_r = 1'b0;
        wb_stb_r = 1'b0;
        wb_we_r = 1'b0;
    end
endtask

assign wb_cyc_o = wb_cyc_r;
assign wb_stb_o = wb_stb_r;
assign wb_we_o  = wb_we_r ;
assign wb_adr_o = wb_adr_r;
assign wb_dat_o = wb_dat_r;
assign wb_sel_o = wb_sel_r;

endmodule

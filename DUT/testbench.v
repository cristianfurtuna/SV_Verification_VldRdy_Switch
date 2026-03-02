module testbench();

parameter FIFO_DEPTH = 8;
wire rst_ni;
wire clk_i;
wire wr_i;
wire rd_i;
wire [$clog2(FIFO_DEPTH)-1:0] cnt_rd_o;
wire [$clog2(FIFO_DEPTH)-1:0] cnt_wr_o;
wire fifo_full_o;
wire fifo_empty_o;
wire [$clog2(FIFO_DEPTH):0] fifo_elements;
wire valid_i;
wire [9:0] data_i;
wire ready_o;
wire [3:0] valid_o;
wire [3:0] ready_i;
wire [3:0][7:0] data_o;




switch #(
 .FIFO_DEPTH(FIFO_DEPTH)
) switch1
(
.rst_ni (rst_ni),
.clk_i  (clk_i),
.valid_i  (valid_i),
.data_i (data_i),
.ready_o  (ready_o),
.valid_o  (valid_o),
.ready_i  (ready_i),
.data_o (data_o)
 

);

clk_gen clk_gen1(
.rst_ni(rst_ni),
.clk_i(clk_i),
.wr_i(wr_i),
.rd_i(rd_i),
.data_i(data_i),
.ready_i(ready_i),
.valid_i(valid_i)

);




endmodule
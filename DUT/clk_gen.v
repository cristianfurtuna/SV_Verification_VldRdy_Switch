module clk_gen(
output reg rst_ni,
output reg clk_i,
output reg wr_i,
output reg rd_i,
output reg [9:0] data_i,
output reg [3:0] ready_i,
output reg valid_i
);

parameter WIDTH = 10;

// clock
initial clk_i = 0;
always #5 clk_i = ~clk_i;

// reset / wr / rd
initial begin
    rst_ni = 0;
    #10 rst_ni = 1;

    #3000 $stop;
end

// data generator
initial data_i = 0;
always #10 data_i = $random() % 1024;

initial ready_i = 0;
always #20 ready_i[0] = $random() % 2;
always #30 ready_i[1] = ($random() % 4 ==0);
always #40 ready_i[2] = ($random() % 4==0);
always #50 ready_i[3] = $random() % 2;

// valid generator
initial valid_i = 0;
always #20 valid_i = $random() % 2;

endmodule

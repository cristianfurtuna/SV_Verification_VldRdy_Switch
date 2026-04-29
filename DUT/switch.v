module switch#(
 parameter FIFO_DEPTH = 6
) 
(
input                 rst_ni,
input                 clk_i,
//interfata de intrare
input                 valid_i,
input [9:0]           data_i,
output                ready_o,
// interfata de iesire
output reg [3:0]      valid_o,
input      [3:0]      ready_i, 
output reg [3:0][7:0] data_o
);

reg [9:0] fifo_mem [0:FIFO_DEPTH-1];
wire                          wr_i;
reg                           rd_i;
wire [$clog2(FIFO_DEPTH)-1:0] cnt_rd_o;
wire [$clog2(FIFO_DEPTH)-1:0] cnt_wr_o;
wire                          fifo_full_o;
wire                          fifo_empty_o;
wire [$clog2(FIFO_DEPTH):0]         fifo_elements;



//wr_i
//se exista un pachet valid de date(valid_i) si daca fifo-ul nu este plin(ready_o) atunci se face scrierea
assign wr_i = (valid_i && ready_o);

assign ready_o = ~fifo_full_o;

//rd_i, 
//daca exista valid pe oricare din canale si ready(e pregatit sa preia datele) pe acelasi canal atunci se face citirea
//ATRIBUIRI NEBLOCANTE IN ALWAYS COMBINATIONAL, INLOCUIRE CU ATRIBUIRI BLOCANTE
always @(*) begin 

if(valid_o[0] && ready_i[0] || valid_o[1] && ready_i[1] || valid_o[2] && ready_i[2] || valid_o[3] && ready_i[3] )
   rd_i <= 1; //bug
   else
   rd_i <= 0;  //bug

end


//valid_o[0],[1],...
//validul de pe un canal  e unu atunci cand adresa de pe bitii [9:8] este egala cu canalul 
always @(posedge clk_i or negedge rst_ni) begin
if(~rst_ni)
    valid_o[0] <= 0;
else if(fifo_mem[cnt_rd_o][9:8] == 0)
   valid_o[0] <= 1;
else 
   valid_o[0] <= 0;
end 

always @(posedge clk_i or negedge rst_ni) begin
if(~rst_ni)
    valid_o[1] <= 0;
else if(fifo_mem[cnt_rd_o][9:8] == 1)
   valid_o[1] <= 1;
else 
   valid_o[1] <= 0;
end 


always @(posedge clk_i or negedge rst_ni) begin
if(~rst_ni)
    valid_o[2] <= 0;
else if(fifo_mem[cnt_rd_o][9:8] == 2)
   valid_o[2] <= 1;
else 
   valid_o[2] <= 0;
end 


always @(posedge clk_i or negedge rst_ni) begin
if(~rst_ni)
    valid_o[3] <= 0;
else if(fifo_mem[cnt_rd_o][9:8] == 3)
   valid_o[3] <= 1;
else 
   valid_o[3] <= 0;
end 

//fifo_mem -MODIFICAT DIN ATRIBUIRE BLOCANTA IN NEBLOCANTA
always @(posedge clk_i or negedge rst_ni) begin

 if(valid_i && ready_o && rst_ni)
    fifo_mem[cnt_wr_o] <= data_i; //bug
 

end


//data_o
//in functie de adresa de pe bitii [9:8] se scriu datele pe canalul corespunzator
//MODIFICARE DIN ATRIBUIRI BLOCANTE IN ATRIBUIRI NEBLOCANTE
always @(posedge clk_i or negedge rst_ni) begin 
if(~rst_ni)
    data_o <= 'b0;
else
if(fifo_mem[cnt_rd_o][9:8] == 0)
    data_o[0] <= fifo_mem[cnt_rd_o][7:0]; //bug gasit
else
if(fifo_mem[cnt_rd_o][9:8] == 1)
    data_o[1] <= fifo_mem[cnt_rd_o][7:0]; //bug gasit
else
if(fifo_mem[cnt_rd_o][9:8] == 2)
    data_o[2] <= fifo_mem[cnt_rd_o][7:0]; //bug gasit
else
if(fifo_mem[cnt_rd_o][9:8] == 3)
    data_o[3] <= fifo_mem[cnt_rd_o][7:0]; //bug gasit
else 
    data_o <= 'b0;
end 




fifo_manager#(
 .FIFO_DEPTH(FIFO_DEPTH)
) fifo_manager1
(
 .rst_ni(rst_ni),
 .clk_i(clk_i),
 .wr_i(wr_i),
 .rd_i(rd_i),
 .cnt_wr_o(cnt_wr_o),
 .cnt_rd_o(cnt_rd_o),
 .fifo_full_o(fifo_full_o),
 .fifo_empty_o(fifo_empty_o),
 .fifo_elements(fifo_elements)

);


endmodule
module fifo_manager#(
 parameter FIFO_DEPTH = 6
)
(
 input                        rst_ni,
 input                        clk_i,
 input                        wr_i,
 input                        rd_i,
 
 output  reg [$clog2(FIFO_DEPTH)-1:0]  cnt_wr_o,
 output  reg [$clog2(FIFO_DEPTH)-1:0]  cnt_rd_o,
 output  reg                           fifo_full_o,
 output  reg                           fifo_empty_o,
 output  reg [$clog2(FIFO_DEPTH):0]  fifo_elements

);

reg fifo_full_wire;
reg fifo_empty_wire;

//fifo full
//MODIFICARE DIN ATRIBUIRE BLOCANTA IN ATRIBUIRE NEBLOCANTA
always @(*) begin

if(~rst_ni)
     fifo_full_wire <= 0;
	 
else if((cnt_wr_o == cnt_rd_o) && (fifo_elements != 0))  //fifo este plin cand pointerul de scriere este cu 1 in urma pointerului de citire si fifo nu este gol
      fifo_full_wire <= 1; //bug
else 
      fifo_full_wire <= 0;
    
end 

always @(posedge clk_i or negedge rst_ni) begin
if(~rst_ni)
    fifo_full_o <= 0;
else 
    fifo_full_o <= fifo_full_wire;

end

//cnt_wr_o
always @(posedge clk_i or negedge rst_ni) begin

if(~rst_ni)
    cnt_wr_o <= 0;
else if (wr_i && !fifo_full_wire)
    cnt_wr_o <= (cnt_wr_o + 'b1)%FIFO_DEPTH;        // numaratorul pt write creste cat timp avem citire si e mai mic decat marimea stivei
else 
    cnt_wr_o <= cnt_wr_o;                       // daca nu pastram val

end

//cnt_rd_o
always @(posedge clk_i or negedge rst_ni) begin

  if(~rst_ni)
      cnt_rd_o <= 0;
  else if(rd_i && !fifo_empty_wire)
      cnt_rd_o <= (cnt_rd_o +1)%FIFO_DEPTH;                   //creste fix pana la fifo_depth, dupa devine 0;
  else 
      cnt_rd_o <= cnt_rd_o;                                   //daca nu avem read sau e fifo empty isi pastreaza val;

end

//fifo_elements
always @(posedge clk_i or negedge rst_ni) begin 

   if(~rst_ni)
       fifo_elements <= 0;
   else if(!rd_i || (rd_i && fifo_empty_wire)) begin          //daca nu am citire

           if(wr_i && !fifo_full_wire)                        //daca am scriere -> elementele cresc
              fifo_elements <= fifo_elements + 1;  
        end
   else begin                                              //am citire
        if (~wr_i || (wr_i && fifo_full_wire))                //daca nu am scriere -> elementele scad
            fifo_elements <= fifo_elements - 1;

        else                                               //daca am si scriere si citire    
            fifo_elements <= fifo_elements;                //ramane la aceeasi valoare;
  
end

end

//POSIBIL BUG, ATRIBUIRI NEBLOCANTE IN ALWAYS COMBINATIONAL
//fifo_empty_o
always @(*) begin 
  if(~rst_ni)
      fifo_empty_wire <= 1;
  else if(fifo_elements == 0)
      fifo_empty_wire <= 1;
  else 
      fifo_empty_wire <= 0;



end

always @(posedge clk_i or negedge rst_ni) begin
if(~rst_ni)
    fifo_empty_o <= 0;
else 
    fifo_empty_o <= fifo_empty_wire;

end


endmodule
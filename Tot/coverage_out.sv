//prin coverage, putem vedea ce situatii (de exemplu, ce tipuri de tranzactii) 
//au fost generate in simulare; astfel putem masura stadiul la care am ajuns 
//cu verificarea
class coverage_out;

transaction_out trans_covered;
string name;

//pentru a se putea vedea valoarea de coverage pentru fiecare element trebuie 
//create mai multe grupuri de coverage, sau trebuie creata o functie de afisare
// proprie

covergroup cg_output (string inst_name);
//linia de mai jos este adaugata deoarece, daca sunt mai multe instante pentru care 
//se calculeaza coverage-ul, noi vrem sa stim pentru fiecare dintre ele, separat, 
//ce valoare avem.
option.per_instance = 1;
option.name = inst_name;

//acoperirea datelor de iesire
data_cp: coverpoint trans_covered.data_o {
   bins zero = {8'h00};
   bins max = {8'hFF};
   bins low = {[8'h01 : 8'h40]};
   bins mid = {[8'h41 : 8'hBF]};
   bins high = {[8'hC0 : 8'hFE]};
 }
 
 //acoperirea delay-ului
delay_cp: coverpoint trans_covered.delay {
   bins back_to_back = {0};
   bins fast = {[1:5]};
   bins mid = {[6:20]};
   bins slow = {[21:100]};
   bins very_slow = {[101:$]};  
}

endgroup

//Constructor
//se creaza grupul de coverage; ATENTIE! Fara functia de mai jos, grupul de coverage
//nu va putea esantiona niciodata date deoarece pana acum el a fost doar declarat, 
//nu si creat

function new(string name);
    this.name = name;
    cg_output = new(name);
endfunction

//functia de esantionare
task sample_function(transaction_out tr);
 //$display("%0t [COVERAGE-%s] sample apelat: data=%h delay=%0d", 
       //      $time, name, tr.data_o, tr.delay);
    this.trans_covered = tr;
    cg_output.sample();
endtask

//functia de afisare a raportului
function void print_coverage();
    $display("\n--- Coverage Report for Port: %s ---", name);
    $display("Data Coverage  = %.2f%%", cg_output.data_cp.get_inst_coverage());
    $display("Delay Coverage = %.2f%%", cg_output.delay_cp.get_inst_coverage());
    $display("Total channel coverage = %.2f%%", cg_output.get_inst_coverage());
    $display("--------------------------------------");
endfunction
endclass: coverage_out
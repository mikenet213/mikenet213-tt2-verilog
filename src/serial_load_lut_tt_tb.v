module test;
  reg [63:0] in;
  reg [3:0] sel;
  wire [3:0] out;
  reg clk;
  reg d;
  reg rst_n;
  reg cs_n;
  
  //serial_load_lut #(4, 4) lut(.d(d), .clk(clk), .rst_n(rst_n), .cs_n(cs), .sel(sel), .out(out));
  wire [7:0] io_in;
  wire [7:0] io_out;
  
  assign io_in[0] = d;
  assign io_in[1] = clk;
  assign io_in[2] = rst_n;
  assign io_in[3] = cs_n;
  assign io_in[7:4] = sel[3:0];
  
  assign out[3:0] = io_out[3:0];
  
  // Wrap for TinyTapeout
  
  user_module_bc4d7220e4fdbf20a574d56ea112a8e1 lut(.io_in(io_in), .io_out(io_out));
  
  integer ic;
  
  initial begin
    // Dump waves
    $dumpfile("dump.vcd");
    $dumpvars(1, test);
    
    in = 64'hFEDCBA9876543210;
    
        
    #10 clk = 0;
    #10 cs_n = 1;
    #10 rst_n = 1;
    #10 rst_n = 0;
    #10 rst_n = 1;
    #10 rst_n = 1;
    
    #10 cs_n = 0;
    
    for (ic = 63; ic >= 0; ic = ic - 1) begin
      d = in[ic];
      pulse_clk;
    end
  
  	#10 cs_n = 1;
  	#10 clk = 0;
    
    for (ic = 0; ic < 32; ic = ic + 1) begin
      #10 sel = ic;
    end
    
    #10 clk = 0;
    
  end
  
  task pulse_clk;
    begin
      #10 clk = 0;
      #10 clk = 1;
      #10 clk = 0;
    end
  endtask
  
endmodule



module baud_gen_tb ;

reg clk ;
reg rst ;
wire baud_tick ;

baud_gen uut(
            .clk(clk),
            .rst(rst),
            .baud_tick(baud_tick)
            );

initial begin
     clk=0 ;
     forever #5 clk = ~clk ;
end 

initial begin
      rst=1 ;
      repeat(3) @(posedge clk) ;
      rst=0 ;
      repeat(50) @(posedge clk) ;
      rst=1;
      $finish ;
end

endmodule


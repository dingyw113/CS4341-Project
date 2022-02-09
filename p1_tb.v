`timescale 1ps/1ps
`include "p1_f9.v"

module breadboard;
    reg W, X, Y, Z;
    wire A;

    f9 eq9(W, X, Y, Z, A);

    initial
    begin
        $dumpfile("p1.vcd");
        $dumpvars(0, breadboard);

        W = 0; X = 0; Y = 0; Z = 0; #10;
        W = 0; X = 0; Y = 0; Z = 1; #10;
        W = 0; X = 0; Y = 1; Z = 0; #10;
        W = 0; X = 0; Y = 1; Z = 1; #10;

        W = 0; X = 1; Y = 0; Z = 0; #10;
        W = 0; X = 1; Y = 0; Z = 1; #10;
        W = 0; X = 1; Y = 1; Z = 0; #10;
        W = 0; X = 1; Y = 1; Z = 1; #10;

        W = 1; X = 0; Y = 0; Z = 0; #10;
        W = 1; X = 0; Y = 0; Z = 1; #10;
        W = 1; X = 0; Y = 1; Z = 0; #10;
        W = 1; X = 0; Y = 1; Z = 1; #10;

        W = 1; X = 1; Y = 0; Z = 0; #10;
        W = 1; X = 1; Y = 0; Z = 1; #10;
        W = 1; X = 1; Y = 1; Z = 0; #10;
        W = 1; X = 1; Y = 1; Z = 1; #10;

        $finish;
    end

    initial
        $monitor("Time = %2t, W = %d, X = %d, Y = %d, Z = %d, A = %d", $time, W, X, Y, Z, A); // Prints if any variables change

endmodule
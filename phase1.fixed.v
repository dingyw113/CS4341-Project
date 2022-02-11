/*module breadboard (input w, x, y, z, output [9:0] o);
    wire w, x, y, z;
    reg [9:0] o;

    always @ (w, x, y, z, o)
    begin
        o[8] = (~w&y)|(x&~y)|(~w&~z)|(w&~y&z); // w'y + xy' + w'z' + wy'z
        o[9] = (x&z)|(w&x&~y)|(w&~y&z)|(~x&y&~z); // xz + wxy' + wy'z + x'yz'
    end
endmodule*/

module f8(input w, x, y, z, output o); // "Class" f8
    
    wire a, b, c, d;
    and a1(a, ~w, y); // w'y
    and a2(b, x, ~y); // xy'
    and a3(c, ~w, ~z); // w'z'
    and a4(d, w, ~y, z); // wy'z
    or o1(o, a, b, c, d); // w'y + xy' + w'z' + wy'z

endmodule

module f9(input w, x, y, z, output o); // "Class" f9

    wire a, b, c, d; // Wires that connect the gates for this circuit together
    and a1(a, x, z); // and is the "class," a1 is the instantiation, the first parameter a is the output, the rest (x, z) are inputs
    and a2(b, w, x, ~y);
    and a3(c, w, ~y, z);
    and a4(d, ~x, y, ~z);
    or o1(o, a, b, c, d); // Same parameter ordering for or gates

endmodule

module testbench; // Runner/stimulus
    integer i; // Can't instantiate ints/registers in for loop, so do it here
    
    wire [9:0] f; // A wire bus - has 9 to 0 bits, total 10 bits to connect input/output to
                  // "f" will be used to store the output of every module to display on the terminal
    
    reg w, x, y, z; // Registers can store values, wires can only connect circuits but not store anything
                    // These will be used to store the inputs used for the modules

    f8 eq8(.w(w), .x(x), .y(y), .z(z), .o(f[8])); // Instantiate modules
    f9 eq9(.w(w), .x(x), .y(y), .z(z), .o(f[9])); // .w(w) means take module f8's input w and connect it to this module's register w

    initial // initial blocks only run once but if you put multiple initial blocks then they will run in parallel
    begin // Equivalent to '{'
        $display ("|Row|w|x|y|z|f8|f9|");
        $display ("|===+=+=+=+=+==+==|");

        for(i = -1; i < 16; i = i + 1) // No ++ operator in Verilog
        begin
            w = (i/8)%2; // Each of these will only be 1 bit, though I think you can store bigger values in registers
            x = (i/4)%2;
            y = (i/2)%2;
            z = (i/1)%2;

            #10; // Delay by 10 time units - used to make sure calculation completes before "print" statement and not during it
                 // Time units can be changed at the very top of the file, here is an example: `timescale 1ps/1ps

            $monitor ("| %2d|%1d|%1d|%1d|%1d| %1d| %1d|", i, w, x, y, z, f[8], f[9]); // Similar syntax to C print statements, will display if any values change
        end

        #10;
        $finish; // End simulation

    end // Equivalent to '}'

endmodule

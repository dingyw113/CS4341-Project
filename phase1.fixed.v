/*module breadboard (input w, x, y, z, output [9:0] o);
    wire w, x, y, z;
    reg [9:0] o;
    always @ (w, x, y, z, o)
    begin
        o[8] = (~w&y)|(x&~y)|(~w&~z)|(w&~y&z); // w'y + xy' + w'z' + wy'z
        o[9] = (x&z)|(w&x&~y)|(w&~y&z)|(~x&y&~z); // xz + wxy' + wy'z + x'yz'
    end
endmodule*/

/* Template for module
    wire [15:0] a;
    and a0(a[0], ~w, ~x, ~y, ~z);
    and a1(a[1], ~w, ~x, ~y, z);
    and a2(a[2], ~w, ~x, y, ~z);
    and a3(a[3], ~w, ~x, y, z);
    and a4(a[4], ~w, x, ~y, ~z);
    and a5(a[5], ~w, x, ~y, z);
    and a6(a[6], ~w, x, y, ~z);
    and a7(a[7], ~w, x, y, z);
    and a8(a[8], w, ~x, ~y, ~z);
    and a9(a[9], w, ~x, ~y, z);
    and a10(a[10], w, ~x, y, ~z);
    and a11(a[11], w, ~x, y, z);
    and a12(a[12], w, x, ~y, ~z);
    and a13(a[13], w, x, ~y, z);
    and a14(a[14], w, x, y, ~z);
    and a15(a[15], w, x, y, z);
    or o1(o, a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12], a[13], a[14], a[15]);
*/

module f8(input w, x, y, z, output o); // "Class" f8
    
    wire [15:0] a;
    and a0(a[0], ~w, ~x, ~y, ~z); // Wires that connect the gates for this circuit together
    //and a1(a[1], ~w, ~x, ~y, z); // and is the "class," a1 is the instantiation, the first parameter a is the output, the rest (x, z) are inputs
    and a2(a[2], ~w, ~x, y, ~z);
    and a3(a[3], ~w, ~x, y, z);
    and a4(a[4], ~w, x, ~y, ~z);
    and a5(a[5], ~w, x, ~y, z);
    and a6(a[6], ~w, x, y, ~z);
    and a7(a[7], ~w, x, y, z);
    //and a8(a[8], w, ~x, ~y, ~z);
    and a9(a[9], w, ~x, ~y, z);
    //and a10(a[10], w, ~x, y, ~z);
    //and a11(a[11], w, ~x, y, z);
    and a12(a[12], w, x, ~y, ~z);
    and a13(a[13], w, x, ~y, z);
    //and a14(a[14], w, x, y, ~z);
    //and a15(a[15], w, x, y, z);
    or o1(o, a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12], a[13], a[14], a[15]); // Same parameter ordering for or gates

endmodule

module f9(input w, x, y, z, output o); // "Class" f9

    wire [15:0] a;
    //and a0(a[0], ~w, ~x, ~y, ~z);
    //and a1(a[1], ~w, ~x, ~y, z);
    and a2(a[2], ~w, ~x, y, ~z);
    //and a3(a[3], ~w, ~x, y, z);
    //and a4(a[4], ~w, x, ~y, ~z);
    and a5(a[5], ~w, x, ~y, z);
    //and a6(a[6], ~w, x, y, ~z);
    and a7(a[7], ~w, x, y, z);
    //and a8(a[8], w, ~x, ~y, ~z);
    and a9(a[9], w, ~x, ~y, z);
    and a10(a[10], w, ~x, y, ~z);
    //and a11(a[11], w, ~x, y, z);
    and a12(a[12], w, x, ~y, ~z);
    and a13(a[13], w, x, ~y, z);
    //and a14(a[14], w, x, y, ~z);
    and a15(a[15], w, x, y, z);
    or o1(o, a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12], a[13], a[14], a[15]);

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
            
            // The key thing in this loop is that we don't need to call or invoke the modules to show that they've changed between inputs
            // By instantiating them and "hooking up" their inputs and outputs to this module's inputs and outputs, we have created a full circuit
            // Any time an input is changed to the whole circuit, the outputs change automatically, just like in real life
            // Verilog is less of a programming language and more of a representation of actual circuits
            
        end

        #10;
        $finish; // End simulation

    end // Equivalent to '}'

endmodule

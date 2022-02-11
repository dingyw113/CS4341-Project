/*module breadboard (input w, x, y, z, output [9:0] o);
    wire w, x, y, z;
    reg [9:0] o;

    always @ (w, x, y, z, o)
    begin
        o[8] = (~w&y)|(x&~y)|(~w&~z)|(w&~y&z); // w'y + xy' + w'z' + wy'z
        o[9] = (x&z)|(w&x&~y)|(w&~y&z)|(~x&y&~z); // xz + wxy' + wy'z + x'yz'
    end
endmodule*/

module f8(input w, x, y, z, output o);

    wire a, b, c, d;
    and a1(a, ~w, y);
    and a2(b, x, ~y);
    and a3(c, ~w, ~z);
    and a4(d, w, ~y, z);
    or o1(o, a, b, c, d);

endmodule

module f9(input w, x, y, z, output o);

    wire a, b, c, d;
    and a1(a, x, z);
    and a2(b, w, x, ~y);
    and a3(c, w, ~y, z);
    and a4(d, ~x, y, ~z);
    or o1(o, a, b, c, d);

endmodule

module testbench;
    integer i;
    wire [9:0] f;
    reg w, x, y, z;

    f8 eq8(.w(w), .x(x), .y(y), .z(z), .o(f[8]));
    f9 eq9(.w(w), .x(x), .y(y), .z(z), .o(f[9]));

    initial
    begin
        $display ("|Row|w|x|y|z|f8|f9|");
        $display ("|===+=+=+=+=+==+==|");

        for(i = -1; i < 16; i = i + 1)
        begin
            w = (i/8)%2;
            x = (i/4)%2;
            y = (i/2)%2;
            z = (i/1)%2;

            #10;

            $monitor ("| %2d|%1d|%1d|%1d|%1d| %1d| %1d|", i, w, x, y, z, f[8], f[9]);
        end

        #10;
        $finish;

    end

endmodule
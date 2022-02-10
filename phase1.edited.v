module breadboard (input w, x, y, z, output [9:0] o);
    wire w, x, y, z;
    reg [9:0] o;

    always @ (w, x, y, z, o)
    begin
        o[4] = (~w&y)|(~w&~x&~z)|(x&~y&z)|(w&x&~y); // w'y + w'x'z' + xy'z + wxy'
        o[5] = (~w&x)|(x&y)|(~w&y&z)|(w&~y&~z); // w'y'z'+ w'yz + wx'y' + wx'z + wxyz'
        o[8] = (~w&y)|(x&~y)|(~w&~z)|(w&~y&z); // w'y + xy' + w'z' + wy'z
        o[9] = (x&z)|(w&x&~y)|(w&~y&z)|(~x&y&~z); // xz + wxy' + wy'z + x'yz'
    end
endmodule

module testbench;
    reg [5:0] i;
    wire [9:0] f;
    reg a, b, c, d;

    breadboard b1(a, b, c, d, f);

    initial
    begin
        $display ("|Row|w|x|y|z|f4|f5|f8|f9|");
        $display ("|===+=+=+=+=+==+==+==+==|");

        for(i = 0; i < 16; i = i + 1)
        begin
            a = (i/8)%2;
            b = (i/4)%2;
            c = (i/2)%2;
            d = (i/1)%2;

            #10;

            $display ("| %2d|%1d|%1d|%1d|%1d| %1d| %1d| %1d| %1d|", i, a, b, c, d, f[4], f[5], f[8], f[9]);
        end

        #10;
        $finish;

    end

endmodule
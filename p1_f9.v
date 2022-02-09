module f9(input w, x, y, z, output o);

    wire a, b, c, d;
    and a1(a, x, z);
    and a2(b, w, x, ~y);
    and a3(c, w, ~y, z);
    and a4(d, ~x, y, ~z);
    or o1(o, a, b, c, d);

endmodule
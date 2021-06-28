`timescale 1ns / 1ps

module Full_Adder(
    In_A, In_B, Carry_in, Sum, Carry_out
    );
    input In_A, In_B, Carry_in;
    output Sum, Carry_out;
    wire w1, w2, w3;
	// implement full adder circuit, your code starts from here.
	// use half adder in this module, fulfill I/O ports connection.
    Half_Adder HAD (
        .In_A(In_A),
        .In_B(In_B),
        .Sum(w1),
        .Carry_out(w2)
    );
    Half_Adder HAD2 (
        .In_A(w1),
        .In_B(Carry_in),
        .Sum(Sum),
        .Carry_out(w3)
    );
    or(Carry_out, w2, w3);
endmodule

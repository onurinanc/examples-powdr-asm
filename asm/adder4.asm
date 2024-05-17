machine Add with
    latch: latch
{
    // just one operation so we don't need an operation id
    operation add x, y -> z;

    col fixed latch = [1]*;

    col witness x;
    col witness y;
    col witness z;

    z = x + y;
}


machine Add4 with
    latch: latch,
    operation_id: operation_id
{
    // recall Add constrained machine
    Add adder;

    operation add4<0> x, y, z, w -> r;

    //col witness op_id = [0]*; wrong
    // col witness op_id; correct

    // link
    link 1 => adder.add x, y -> n;

    // link
    link 1 => adder.add z, w -> m;

    // link
    link 1 => adder.add m, n -> r;

    col fixed operation_id = [0]*;
    col fixed latch = [1]*;

    col witness x;
    col witness y;
    col witness z;
    col witness w;
    col witness m;
    col witness n;
    col witness r;
}


machine Main with degree: 16 {
    reg pc[@pc];
    reg A;
    reg B;
    reg C;
    reg D;
    reg E;
    reg X[<=];
    reg Y[<=];
    reg Z[<=];
    reg W[<=];
    reg R[<=];

    Add4 adder4;

    instr add48 X, Y, Z, W -> R = adder4.add4 X, Y, Z, W -> R;

    instr add_1_to_4 -> X = adder4.add4 1, 2, 3, 4 -> X;

    instr assert_eq X, Y {
        X = Y
    }

    function main {
        A <== add_1_to_4();
        assert_eq A, 10;

        A <=X= 5;
        B <=X= 10;
        C <=X= 20;
        D <=X= 9;

        E <== add48(A,B,C,D);
        assert_eq E, 43;
        return;
    }

}
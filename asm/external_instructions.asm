machine SubMachine with
    latch: latch,
    operation_id: operation_id
{
    col witness operation_id;
    col fixed latch = [1]*;

    operation add<0> x, y -> z;
    col witness x;
    col witness y;
    col witness z;
    z = x + y;
}

machine Main {
    reg pc[@pc];
    reg A;
    reg B;
    reg C;
    reg X[<=];
    reg Y[<=];
    reg Z[<=];

    // Define a new SubMachine
    SubMachine submachine;

    // Use constrained machine instructions 
    instr add X, Y -> Z = submachine.add;
    
    // Redefine
    instr add_redefined X, Y -> Z = submachine.add X, Y -> Z;

    // Add two X, Y to A directly. *Then, Use it without using an assignment A <==
    instr add_to_A X, Y = submachine.add X, Y -> A';

    instr add_AB -> X = submachine.add A, B -> X;

    // Add A and B to C without using assignment operator
    instr add_AB_to_C = submachine.add A, B -> C';

    // Add A and B to A, using this, you can reuse the input as an output
    instr add_AB_to_A = submachine.add A, B -> A';

    // Sub instructions from an addition constraint, interesting point
    instr sub X, Y -> Z = submachine.add Y, Z -> X;
    
    // Add with a constant using an expression like 3 + 2
    instr add_by_5 X -> Y = submachine.add X, 3+2 -> Y;

    instr assert_equals X, Y {
        X = Y
    }

    let arr = [1, 2, 3, 4, 5];
    instr add_arr_sum X -> Z = submachine.add X, std::array::sum(arr) -> Z;

    col fixed STEP(i) { i };
    instr add_current_time_step X -> Z = submachine.add X, STEP -> Z;

    function main {
        add_to_A 3, 5;
        assert_equals A, 8;

        A <== sub(6, 5); // Assignment operator varsa, () parantez ile kullan.
        assert_equals A, 1;

        B <=X= 20;
        C <== add_AB();
        assert_equals C, 21;

        A <== add_arr_sum(C);
        assert_equals A, 36;

        A <== add_current_time_step(50);
        B <== add_current_time_step(50);
        assert_equals A, B - 1;

        return;
    }
}
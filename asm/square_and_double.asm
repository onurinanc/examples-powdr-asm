// Square and Double CNT from 3 to 0 loop
// Initialize A with 2
// Write jmp instruction
// Write jmpz instruction, jmp iff X = 0
// Write square and double instruction with a tuple solution Y = X * X and Z = 2 * X
// assert A is correct
// assert B is correct

machine SquareAndDouble with degree: 12 {
    reg pc[@pc];
    reg A;
    reg B;
    reg CNT;
    reg X[<=];
    reg Y[<=];
    reg Z[<=];

    instr square_and_double X -> Y,Z {
        Y = X * X,
        Z = 2 * X
    }

    instr jmp l: label {
        pc' = l
    }

    instr jmpz X, l: label {
        pc' = XIsZero * l + (1 - XIsZero) * (pc + 1)
    }

    instr assert_zero X {
        X = 0
    }

    function main {
        A <=X= 2;
        CNT <=X= 3;

        start:
        jmpz CNT, end;
        CNT <=X= CNT - 1;
        A,B <== square_and_double(A);
        jmp start;
        end:

        assert_zero A - ((2**2)**2)**2;
        assert_zero B - ((2**2)**2)*2;

        return;
    }

    col witness XInv;
    col witness XIsZero;
    XIsZero = 1 - X * XInv;
    XIsZero * X = 0;
    XIsZero * (1 - XIsZero) = 0;
}
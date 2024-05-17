mod utils {
    let increments: expr -> expr = |x| x + 10;

    // We need to have 
    let increment_with_constant: expr, expr -> expr = |x,c| x + c;

    //let constrain_incremented_by = |x, inc| x' = x + inc;
}

machine DeclarationsExample {
    reg pc[@pc];
    reg A;
    reg B;
    reg C;
    reg D;
    reg X[<=];
    reg Y[<=];
    reg Z[<=];

    instr assert_A_is_zero {
        A = 0
    }

    instr assert_zero X {
        X = 0
    }

    instr incr X -> Y {
        Y = X + 1
    }

    instr decr X -> Y {
        Y = X - 1
    }

    instr incr_c X -> Y {
        Y = utils::increments(X)
    }

    instr increment_with_constant X,Y -> Z {
        Z = utils::increment_with_constant(X,Y)
    }

    instr constrain_incremented_by X,Y -> Z {
        Z = utils::constrain_incremented_by(X,Y)
    }

    instr add X, Y -> Z {
       Z = X + Y
    }

    function main {
        assert_A_is_zero;
        assert_zero A;
        B <=X= ${ std::prover::Query::Input(0)};
        assert_zero B;

        C <== incr_c(C);
        C <=X= C - 10; // Burada işlem yaptığım için X olması gerekiyor, instr olursa <==
        assert_zero C;

        A <=X= ${ std::prover::Query::Input(1)};
        B <=X= ${ std::prover::Query::Input(2)};
        D <=X= ${ std::prover::Query::Input(3)};

        C <== increment_with_constant(A, B);
        //C <== add(A,B);
        C <=X= C - D;
        assert_zero C;

        C <== constrain_incremented_by(A, B);
        C <=X= C - D;
        assert_zero C;
        return;
    }
}
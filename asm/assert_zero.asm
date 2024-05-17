machine Assertion with degree: 1000 {
    reg pc[@pc];
    reg A;
    reg X[<=];

    instr assert_zero X {
        X = 0
    }

    function main {
        assert_zero(A);
        return;
    }
}
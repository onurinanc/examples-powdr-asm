// 1 operation machine
machine Add with
    latch: latch
{
    operation add a, b -> c;
    col fixed latch = [1]*;

    col witness a;
    col witness b;
    col witness c;

    // constraint implementation
    c = a + b;
}

machine AddSub with
    latch: latch,
    operation_id: op_id
{
    operation add<0> a, b -> c;
    operation sub<1> a, b -> c;

    col fixed latch = [1]*;
    col witness op_id;

    col witness a;
    col witness b;
    col witness c;

    // constraint implementation
    c = (1 - op_id) * (a + b) + op_id * (a - b);
}
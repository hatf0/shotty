module schema;

enum scheme = `
ShottySchema:
    Scheme   < Entry*
    Entry    < "%" (ConstStr / Random)
    Value    < :"{" (Number / String) :"}"
    Random   < "r" Type Value
    ConstStr < "s" Value

    Type     < Hex / Alpha / Num
    Hex      < "x" 
    Alpha    < "a"
    Num      < "n"

    String   < ~([aA-zZ\_\-]+)
    Number   < ~([0-9]+)
`;


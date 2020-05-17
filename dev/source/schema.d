module schema;

enum scheme = `
ShottySchema:
    Scheme   < Entry*
    Entry    < "%" (ConstStr / Random / Year / Month / Day / Hour / Minute / Second / UnixTime)
    Value    < :"{" (Number / String) :"}"
    Random   < "r" Type Value
    ConstStr < "s" Value
    Year     < "y"
    Month    < "m"
    Day      < "d"
    Hour     < "H"
    Minute   < "M"
    Second   < "S"
    UnixTime < "unix"

    Type     < Hex / Alpha / Num
    Hex      < "x" 
    Alpha    < "a"
    Num      < "n"

    String   < ~([aA-zZ\_\-]+)
    Number   < ~([0-9]+)
`;


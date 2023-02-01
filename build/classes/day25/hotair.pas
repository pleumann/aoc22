program HotAir;

{$I /Users/joerg/Projekte/pl0/lib/Files.pas}

function Decimal(C: Char): Integer;
begin
  case C of
    '=': Decimal := -2;
    '-': Decimal := -1;
    '0': Decimal :=  0;
    '1': Decimal :=  1;
    '2': Decimal :=  2;
  end;
end;

function Snafu(I: Integer): Char;
begin
  if I = -2 then 
    Snafu := '='
  else if I = -1 then
    Snafu := '-'
  else
    Snafu := Char(48 + I);
end;

function Add(S, T: TString): TString;
var
  R: TString;
  I, J, X, Y, Z, C: Integer;
begin
  R := '';

  I := Length(S);
  J := Length(T);
  C := 0;

  repeat
    if I = 0 then X := 0 else begin X := Decimal(S[I]); I := I - 1; end;
    if J = 0 then Y := 0 else begin Y := Decimal(T[J]); J := J - 1; end;

    Z := X + Y + C;

    if Z > 2 then
    begin
      Z := Z - 5;
      C := 1;
    end
    else if Z < -2 then
    begin
      Z := Z + 5;
      C := -1;
    end
    else C := 0;

    R := '' + Snafu(Z) + R;
  until (I = 0) and (J = 0) and (C = 0);

  Add := R;
end;

var
  T: Text;
  Num, Sum: String;

begin
  WriteLn;
  WriteLn('*** AoC 2022.25 Full of Hot Air ***');
  WriteLn;

  Sum := '';

  Assign(T, 'INPUT   .TXT');
  Reset(T);
  while not IsEof(T) do
  begin
    ReadLine(T, Num);
    WriteLn(Num:20);
    Sum := Add(Sum, Num);
  end;
  Close(T);

  WriteLn('--------------------');
  WriteLn(Sum:20);
  WriteLn;
end.
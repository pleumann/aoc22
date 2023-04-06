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

procedure Spell(X, Y: Integer; S: TString);
var
  I, J: Integer;
  C: Char;
begin
  GotoXY(X, Y);

  for I := 1 to Length(S) do
  begin
    C := S[I];
    if C = '#' then Write(#27'p '#27'q') else Write(C);
    for J := 0 to 1999 do begin end;
  end;
end;

procedure Thanks;
begin
  Spell(44,  3, ' ###   ###   ####  #  ####  #### ');
  Spell(44,  4, '#   # #   # #      #      #     #');
  Spell(44,  5, '##### #   # #          ###   ### ');
  Spell(44,  6, '#   # #   # #         #     #    ');
  Spell(44,  7, '#   #  ###   ####     ##### #####');

  Spell(44,  9, '*** In Pascal. On 8-bit CP/M. ***');

  Spell(44, 11, 'Thanks for watching my videos!   ');
  Spell(44, 12, 'I hope they were able to convey a');
  Spell(44, 13, 'bit of the fun I had making them.');

  Spell(44, 15, 'Greetings to Myopian, Ped7g, Sol ');
  Spell(44, 16, 'and all the other nice people on ');
  Spell(44, 17, 'the ZX Spectrum Next Discord.    ');

  Spell(44, 19, 'Looking forward to December 2023!');

  Spell(44, 21, 'Cheers,                          ');
  Spell(44, 22, 'Joerg                            ');

  Spell(44, 24, 'https://github.com/pleumann/aoc22');
end;

var
  T: Text;
  Num, Sum: String;
  I: Integer;

begin
  Write(#27'f');

  ClrScr;
  WriteLn('*** AoC 2022.25 Full of Hot Air ***');
  WriteLn;

  Sum := '0';

  WriteLn('Part 1:        ', Sum:20);
  WriteLn('               --------------------');

  Assign(T, 'INPUT   .TXT');
  Reset(T);
  while not IsEof(T) do
  begin
    ReadLine(T, Num);
    Sum := Add(Sum, Num);
    GotoXY(1, 5);
    Write(#27'L');
    GotoXY(16,5);
    Write(Num:20);
    GotoXY(16, 3);
    Write(Sum:20);

    for I := 0 to 9999 do begin end;
  end;
  Close(T);

  Write(#27'e');

  Thanks;

  GotoXY(1, 23);
end.
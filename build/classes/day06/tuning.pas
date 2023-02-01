program Tuning;

{$I /Users/joerg/Projekte/pl0/lib/files.pas}

var
  Data: array[0..4095] of Char;
  Size: Integer;

procedure Load;
var
  T: Text;
  C: Char;
begin
  Assign(T, 'INPUT   .TXT');
  Reset(T);

  Size := 0;
  C := ReadChar(T);
  while C <> #10 do
  begin
    Data[Size] := C; 
    Size := Size + 1;
    C := ReadChar(T);
  end;

  Close(T);

  WriteLn(Size, ' bytes read.');    
end;

function Find(Start, Count: Integer): Integer;
var
  Letters: array['a'..'z'] of Integer;
  Unique, I: Integer;
  C: Char;
begin
  GotoXY(9, 5);
  Write(Count: 4);

  for C := 'a' to 'z' do Letters[C] := 0;
  Unique := 0;

  for I := Start to Size do
  begin
    GotoXY(9, 6);
    Write(I: 4);

    if I >= Count then
    begin
      C := Data[I - Count];
      if Letters[C] > 0 then
      begin
        Letters[C] := Letters[C] - 1;
        GotoXY(3 * (Ord(C) - Ord('a')) + 2, 10);
        Write(Letters[C]:2);

        if Letters[C] = 0 then Unique := Unique - 1;
      end;
    end;

    C := Data[I];
    Letters[C] := Letters[C] + 1;

    GotoXY(79 - Count, 6);
    Write(#27'N');
    GotoXY(78, 6);
    Write(C);

    GotoXY(3 * (Ord(C) - Ord('a')) + 2, 10);
    Write(Letters[C]:2);

    if Letters[C] = 1 then Unique := Unique + 1;

    GotoXY(9, 7);
    Write(Unique: 4);

    if Unique = Count then
    begin
      Find := I + 1;
      Exit;
    end;
  end;

  Find := -1;
end;

procedure Solve;
var
  C: Char;
  I: Integer;
begin
  Load;

  WriteLn;
  WriteLn('Window:    0');
  WriteLn('Offset:    0');
  WriteLn('Unique:    0');
  WriteLn;

  for C := 'a' to 'z' do
    Write(' '#27'p ', C, #27'q');
  WriteLn;
  for C := 'a' to 'z' do
    Write('  0');
  WriteLn;

  I := Find(0, 4);

  GotoXY(1, 12);
  WriteLn('Part 1: ', I);

  I := Find(I, 14);

  GotoXY(1, 13);
  WriteLn('Part 2: ', I);
end;

begin
  Write(#27'f');

  ClrScr;

  WriteLn('*** AoC 2022.06 Tuning Trouble ***');
  WriteLn;

  Solve;

  Write(#27'e');
end.
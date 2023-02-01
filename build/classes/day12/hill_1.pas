program Hill;

{$I /Users/joerg/Projekte/pl0/lib/Files.pas}

var
  Map: array [0..47] of array [0..63] of Char;

  Cost: array [0..47] of array [0..63] of Integer;

  Modified: array [0..47] of array[0..63] of Boolean;

  Height, Width: Integer;

  OriginX, OriginY: Integer;

procedure Load;
var
  T: Text;
  S: TString;
  H: Char;
  I: Integer;
begin
  Assign(T, 'INPUT   .TXT');
  Reset(T);

  Height := 0;

  while not IsEof(T) do
  begin
    ReadLine(T, S);
    for I := 0 to Length(S) - 1 do
    begin
      H := S[I + 1];

      Cost[Height][I] := 9999;

      if H = 'S' then
      begin
        OriginX := Height;
        OriginY := I;
        WriteLn('Origin is at ', OriginX:2, ',', OriginY:2, '.');
        H := 'a';
      end
      else if H = 'E' then
      begin
        WriteLn('Target is at ', Height:2, ',', I:2, '.');
        H := 'z';
        Cost[Height][I] := 0;
      end;

      Map[Height][I] := H;
      Modified[Height][I] := True;
    end;

    Height := Height + 1;
  end;

  Width := Length(S);

  Close(T);

  WriteLn;
end;

function Update(X, Y: Integer; H: Char; C: Integer): Boolean;
begin
  Update := False;

  if Ord(H) <= Ord(Map[X][Y]) + 1 then
    if C + 1 < Cost[X][Y] then
    begin
      Cost[X][Y] := C + 1;
      Modified[X][Y] := True;
      Update := True;
    end;
end;

function Think: Boolean;
var
  I, J, C: Integer;
  H: Char;
begin
  Think := False;

  for I := 0 to Height - 1 do
    for J := 0 to Width - 1 do
    begin
      if Modified[I][J] then
      begin
      Modified[I][J] := False;
      H := Map[I][J];
      C := Cost[I][J];

      if I > 0 then 
        if Update(I - 1, J, H, C) then
          Think := True;

      if I < Height - 1 then
        if Update(I + 1, J, H, C) then
          Think := True;

      if J > 0 then
        if Update(I, J - 1, H, C) then
          Think := True;

      if J < Width - 1 then
        if Update(I, J + 1, H, C) then
          Think := True;
      end;
    end;
end;

var
  I, J, Best, BestX, BestY: Integer;

begin
  WriteLn;
  WriteLn('*** AoC 2022.10 Hill Climbing Algorithm ***');
  WriteLn;

  Load;

  while Think do
    Write('.');

  WriteLn;
  WriteLn;
  WriteLn('Part 1: Trail starting at ', OriginX:2, ',', OriginY:2, ' has cost ', Cost[OriginX][OriginY]);

  Best := 32767;
  BestX := -1;
  BestY := -1;        
        
  for I := 0 to Height - 1 do
    for J := 0 to Width - 1 do
    begin
      if (Map[I][J] = 'a') and (Cost[I][J] < Best) then
      begin
        Best := Cost[I][J];
        BestX := I;
        BestY := J;
      end;
    end;
    
  WriteLn('Part 2: Trail starting at ', BestX:2, ',', BestY:2, ' has cost ', Best);
  WriteLn;
end.
    

program Boulders;

{$I /Users/joerg/Projekte/pl0/lib/Files.pas}

const
  Air   = 0;
  Stone = 1;
  Water = 2;

var
  Map: array[0..19, 0..19, 0..19] of Byte;

procedure Clear;
var
  I, J, K: Integer;
begin
  for I := 0 to 19 do
    for J := 0 to 19 do
      for K := 0 to 19 do
        Map[I, J, K] := Air
end;

procedure Load;
var
  T: Text;
  S: String;
  P, Error, I, J, K: Integer;
begin
  Assign(T, 'INPUT   .TXT');
  Reset(T);
  while not IsEof(T) do
  begin
    ReadLine(T, S);
    P := Pos(',', S);

    Val(Copy(S, 1, P - 1), I, Error);
    Delete(S, 1, P);
    P := Pos(',', S);
    Val(Copy(S, 1, P - 1), J, Error);
    Delete(S, 1, P);
    Val(S, K, Error);

    Map[I, J, K] := Stone;
  end;
end;

function Visible: Integer;
var
  I, J, K, Count: Integer;
begin
  Count := 0;

  for I := 0 to 19 do
    for J := 0 to 19 do
      for K := 0 to 19 do
        if Map[I, J, K] = Stone then
        begin
          if (I =  0) or (Map[I - 1, J, K] = Air) then Count:= Count + 1;
          if (I = 19) or (Map[I + 1, J, K] = Air) then Count:= Count + 1;
          if (J =  0) or (Map[I, J - 1, K] = Air) then Count:= Count + 1;
          if (J = 19) or (Map[I, J + 1, K] = Air) then Count:= Count + 1;
          if (K =  0) or (Map[I, J, K - 1] = Air) then Count:= Count + 1;
          if (K = 19) or (Map[I, J, K + 1] = Air) then Count:= Count + 1;
        end;

  Visible := Count;
end;

(*
function Flood: Boolean;
var
  I, J, K: Integer;
  Changed: Boolean;
begin
  Changed := False;

  for I := 0 to 19 do
    for J := 0 to 19 do
      for K := 0 to 19 do
        if Map[I, J, K] = Air then
        begin
          if (I > 0) and (Map[I - 1, J, K] = Water) then
          begin
            Map[I, J, K] := Water;
            Changed := True;
            Continue;
          end;

          if (I < 19) and (Map[I + 1, J, K] = Water) then
          begin
            Map[I, J, K] := Water;
            Changed := True;
            Continue;
          end;

          if (J > 0) and (Map[I, J - 1, K] = Water) then
          begin
            Map[I, J, K] := Water;
            Changed := True;
            Continue;
          end;

          if (J < 19) and (Map[I, J + 1, K] = Water) then
          begin
            Map[I, J, K] := Water;
            Changed := True;
            Continue;
          end;

          if (K > 0) and (Map[I, J, K - 1] = Water) then
          begin
            Map[I, J, K] := Water;
            Changed := True;
            Continue;
          end;

          if (K < 19) and (Map[I, J, K + 1] = Water) then
          begin
            Map[I, J, K] := Water;
            Changed := True;
            Continue;
          end;
        end;

  Flood := Changed;
end;
*)

procedure Flood;
var
  X, Y, Z, Progress: Integer;

  procedure Recurse;
  begin
    if Map[X, Y, Z] = Air then
      begin
        Progress := Progress + 1;
        if Progress = 100 then
        begin
          Write('.');
          Progress := 0;
        end;

        Map[X, Y, Z] := Water;

        if X >  0 then begin X := X - 1; Recurse; X := X + 1; end;
        if X < 19 then begin X := X + 1; Recurse; X := X - 1; end;
        if Y >  0 then begin Y := Y - 1; Recurse; Y := Y + 1; end;
        if Y < 19 then begin Y := Y + 1; Recurse; Y := Y - 1; end;
        if Z >  0 then begin Z := Z - 1; Recurse; Z := Z + 1; end;
        if Z < 19 then begin Z := Z + 1; Recurse; Z := Z - 1; end;
      end;
  end;

begin
  X := 0;
  Y := 0;
  Z := 0;

  Progress := 0;

  Recurse;
end;

(*
procedure Flood(X, Y, Z: Integer);
begin
if Map[X, Y, Z] = Air then
  begin
    Progress := Progress + 1;
    if Progress = 10 then
    begin
      Write('.');
      Progress := 0;
    end;

    Map[X, Y, Z] := Water;

    if X >  0 then Flood(X - 1, Y, Z);
    if X < 19 then Flood(X + 1, Y, Z);
    if Y >  0 then Flood(X, Y - 1, Z); 
    if Y < 19 then Flood(X, Y + 1, Z);
    if Z >  0 then Flood(X, Y, Z - 1);
    if Z < 19 then Flood(X, Y, Z + 1);
  end;
end;
*)

procedure Invert;
var
  I, J, K: Integer;
begin
  for I := 0 to 19 do
    for J := 0 to 19 do
      for K := 0 to 19 do
        if Map[I, J, K] = Stone then
          Map[I, J, K] := Air
        else if Map[I, J, K] = Air then
          Map[I, J, K] := Stone;
end;

var
  V1, V2: Integer;
    
begin
  WriteLn;
  WriteLn('*** AoC 2022.18 Boiling Boulders ***');
  WriteLn;

  Clear;
  Load;

  V1 := Visible;
  WriteLn('Overall surface : ', V1:4);
  WriteLn;

  Flood;
  Invert;

  WriteLn;
  WriteLn;

  V2 := Visible;

  WriteLn('Internal surface: ', V2:4);
  WriteLn('External surface: ', V1 - V2:4);

  WriteLn;
end.

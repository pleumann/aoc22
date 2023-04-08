program Tunnels;

{$I /Users/joerg/Projekte/pl0/lib/Files.pas}

type
  TValve = record
    Name: String[2];
    Number, Rate, NumTunnels: Integer;
    Open: Boolean;
    Part1: Boolean;
    Tunnels: array[0..7] of Integer;
  end;

var
  Valves: array[0..63] of TValve;
  NumValves, Best, MaxFlow, I, J, Run, Best1, Best2: Integer;
  Names: TString;
  FlowTable: array[0..29] of Integer;
  History: array[0..30] of Byte;

function Lookup(S: TString): Integer;
var
  I: Integer;
begin
  I := Pos(S, Names);
  if I = 0 then
  begin
    Names := Names + S + ' ';
    I := Length(Names) - 2;
    Inc(NumValves);
  end;
  Lookup := (I - 1) / 3; 
end;

(* Valve AT has flow rate=17; tunnels lead to valves DX, BU, NE, BR, TD *)

procedure Init(S: TString);
var
  N, P, Q, E: Integer;
begin
  if Length(S) = 0 then Exit;

  N := Lookup(Copy(S, 7, 2));

  with Valves[N] do
  begin
    Name := Copy(S, 7, 2);
    Number := N;

    P := Pos('=', S);
    Q := Pos(';', S);
    Val(Copy(S, P + 1, Q - P - 1), Rate, E);
    if Rate <> 0 then
      Inc(MaxFlow, Rate);

    Open := False;
    Part1 := False;

    Valves[N].NumTunnels := 0;

    P := Pos('valve', S);
    P := P + 6;
    if S[P] = ' ' then Inc(P);

    while P < Length(S) do
    begin
      Tunnels[NumTunnels] := Lookup(Copy(S, P, 2));
      Inc(Valves[N].NumTunnels);
      P := P + 4;
    end;
  end;

  (*
  Write('Valve ', N, ': name=', Valves[N].Name, ', rate=', Valves[N].Rate, ', exits to ', Valves[N].Tunnels[0]);
  for P := 1 to Valves[N].NumTunnels - 1 do Write(', ', Valves[N].Tunnels[P]);
  WriteLn;
  *)
end;

procedure Load;
var
  T: Text;
  S: TString;
begin
  Assign(T, 'INPUT   .TXT');
  Reset(T);

  NumValves := 0;
  Names := '';

  while not IsEof(T) do
  begin
    ReadLine(T, S);
    Init(S);
  end;

  Close(T);
end;

procedure Dump;
var
  K, Y: Integer;
begin
  case Run of
    1: begin K := 29; Y := 6; end;
    2: begin K := 25; Y := 11; end;
    3: begin K := 25; Y := 16; end;
  end;

  GotoXY(1, Y);

  while (K >= 0) do
  begin
    if (K > 0) and (History[K - 1] = History[K]) then
    begin
      Write(#27'p', Valves[History[K]].Name, #27'q ');
      Dec(K);
    end
    else
      Write(Valves[History[K]].Name, ' ');

    Dec(K);
  end;

  Write(#27'K');

  GotoXY(73, Y);
  Write('--> ', Best:4);
end;

procedure Recurse(Curr, Prev, Time, Flow: Byte; Total: Integer);
var
  I, J: Byte;
  K: Integer;
begin
  Inc(Total, Flow);
  Dec(Time);

  History[Time] := Curr;

  if Time = 0 then
  begin
    if Total > Best then
    begin
      (* WriteLn('New best: ', Total); *)
      Best := Total;

      for I := 0 to NumValves do
        Valves[I].Part1 := Valves[I].Open;

      Dump;
    end;

    Exit;
  end;

  if Total + FlowTable[Time] <= Best then Exit;

  with Valves[Curr] do
  begin
    if (not Open) and (Rate > 0) then
    begin
      Open := True;
      Recurse(Curr, Curr, Time, Flow + Rate, Total);
      Open := False;
    end
    else
    begin
      I := 0;
      while I < NumTunnels do
      begin
        J := Tunnels[I];
        if J <> Prev then Recurse(J, Curr, Time, Flow, Total);
        Inc(I);
      end;
    end;
  end;
end;

procedure Spell(S: TString);
var
  I, J: Integer;
begin
  Write(#27'e');
  
  for I := 1 to Length(S) do
  begin
    Write(S[I]);
    for J := 0 to 4095 do begin end;
  end;

  Write(#27'f');
end;

begin
  Write(#27'f');

  ClrScr;

  WriteLn('*** AoC 2022.16 Proboscidea Volcanium ***');
  WriteLn;
  WriteLn;
  Spell('A volcano explorer named Joe...');

  Best := 0;
  MaxFlow := 0;

  Load;

  for I := 0 to 29 do FlowTable[I] := I * MaxFlow;

  Run := 1;
  Recurse(Lookup('AA'), -1, 30, 0, 0);

  GotoXY(1, 9);
  Spell('...opened valves for the pressure to flow.');

  Best1 := Best;

  Best := 0;
  Run := 2;
  Recurse(Lookup('AA'), -1, 26, 0, 0);

  for I := 0 to NumValves - 1 do
    if Valves[I].Part1 then
    begin
      Dec(MaxFlow, Valves[I].Rate);
      Valves[I].Rate := 0;
    end;

  Best2 := Best;
  Best := 0;

  GotoXY(1, 14);
  Spell('But to go like a dream needs an elephant team.');

  Run := 3;
  Recurse(Lookup('AA'), -1, 26, 0, 0);

  GotoXY(1, 19);
  Spell('That''s a lesson we all need to know. :-)');

  GotoXY(1, 21);
  WriteLn('Part 1: ', Best1:4);
  WriteLn('Part 2: ', Best2 + Best:4, ' = ', Best2:4, ' + ', Best:4);

  for I := 0 to 3 do
    for J := -32768 to 32767 do begin end;

  GotoXY(56, 22);
  Spell('/* Limerick by Myopian */');

  WriteLn;

  Write(#27'e');
end.

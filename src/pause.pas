program Pause;

var
  S, Err, I, OldX, OldY: Integer;

{$ifdef SYS_CPM}
(*
 * Waits one second. Delay uses BDOS 141, an MP/M function that the Next's
 * CP/M 3 doesn't support, so on CP/M 3 we count 50 Hz interrupts (one HALT
 * each). tnylpo reports CP/M 2.2, has BDOS 141 as an extension, and stops on
 * HALT, so it keeps using Delay.
 *)
procedure WaitSecond;
var
  J: Integer;
begin
  if BDos(12, 0) >= $30 then
    for J := 1 to 50 do
      Inline($76) (* HALT *)
  else
    Delay(1000);
end;
{$endif}

begin
  if ParamCount = 0 then
    Halt(1);
  Val(ParamStr(1), S, Err);
  if Err <> 0 then
    Halt(1);
    
  (*
   * SUBMIT echoes the command line ("B>pause 5"), so overwrite it again.
   * Only the first 10 columns: the rest of that row may still hold output.
   *)
  {$ifdef SYS_CPM}
  Write(#27'A', #13, '          ');
  {$endif}

  (* Banner below the 24 rows the solutions use (needs a 30-row screen). *)
  {$ifdef SYS_AGON}
  WriteLn; // CP/M prints a newline at the end, Agon doesn't.

  OldX := WhereX;
  OldY := WhereY;
  {$endif}

  GotoXY(1, 25);
  ClrEos;
  GotoXY(22, 27);
  Write(' https://github.com/pleumann/aoc22');
  GotoXY(22, 29);
  Write('https://github.com/pleumann/pasta80');

  {$ifdef SYS_AGON}
  GotoXY(OldX, OldY);
  {$else}
  GotoXY(1, 25); // No WhereX/WhereY on CP/M, so the dots go here.
  {$endif}

  for I := 1 to S do
  begin
    Write('.');
    {$ifdef SYS_CPM}
    WaitSecond;
    {$else}
    Delay(1000);
    {$endif}
  end;

  (* SUBMIT will echo the next command line, so give it a clean screen. *)
  {$ifdef SYS_CPM}
  ClrScr;
  {$endif}
end.

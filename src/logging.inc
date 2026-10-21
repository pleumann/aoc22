procedure Log(Day: Byte; Part1, Part2: String);
var
  T: Text;
begin
  Assign(T, 'aoc22.log');
  {$i-}
  Append(T);
  if IOREsult <> 0 then
    {$i+}
    Rewrite(T);
  WriteLn(T, Day:2, ': ', Part1, ', ', Part2);
  Close(T);
end;
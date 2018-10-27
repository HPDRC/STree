unit parser;

interface
const TAB = #9;
type dword = longword;

procedure parsedoublevar(Var S : String; Var VarName : String;
                 Var D : double; Var Res : String; Var p : integer);
procedure AppendFile(Name, S: String);
function TheFullFileName(Name: String) : String;
function TheFileName(Name: String; noext : boolean = false) : String;

function ValStr(S: String) : Longint;
function ValStr1(S: String) : Longint;
function ValStr2(S: String) : Longint;
function scanint(Var S : String; Var P : integer) : integer;
function scandouble(Var S : String; Var P : integer) : double;
function ScanStr(Var Src : String; Var pos : integer) : String; overload;
function ScanStr1(Var Src : String; Var pos : integer) : String;
function GetNextLine(Var S : String; Var p : integer) : String;
Procedure ScanLine(Var Src : String; Var p : integer; Var Dest: String);
Procedure ScanLine1(Var Src : String; Var p : integer; Var Dest: String);
procedure MoveToEol1(Var Src : string; Var p : integer);
procedure NextLine(Var Src : string; Var p : integer);
function ReadStringFile(Name : String; Var Res : string) : boolean;
function WriteStringFile(Name : String; Var Res : string) : boolean;
function GetHardRootDir : String;
function GetHardRootDir1 : String;
function ReadDouble(S : String) : double; overload;
function NanoTime : int64;
function NanoFrequency : int64;
procedure SkipFields(Var S : String; FieldNo : integer; Var P : integer; addTabs : boolean = false);
procedure ExtractField(Var S : String; Var D : String; Var P : integer);
function GetNextField(Var S : String; Var P : integer) : String;
procedure ExtractFieldByNum(Src: String; N: INteger; Var Field : String);

procedure SkipCommas(Var S : String; FieldNo : integer; Var P : integer; addTabs : boolean = false);
function GetNextComma(Var S : String; Var P : integer) : String;
procedure ExtractComma(Var S : String; Var D : String; Var P : integer);
procedure ExtractCommaByNum(Src: String; N: INteger; Var Field : String);

procedure ReplaceFieldByNum(Var S : String; F : integer; NewF : String);
function MemAvail : dword;
procedure StartTime(Var T : int64);
function  HtmlTime(Var T : int64) : string;
function  TextTime(Var T : int64; USeRam : boolean) : string;
function  GetTimeText : String;
procedure ReadCommaQuote(Var S : String; Var P : integer; Var D : String);
procedure ReadQuote(Var S : String; Var P : integer; Var D : String);
procedure ReadToQuote(Var S : String; Var P : integer; Var D : String);
function strtodouble(Var S : String) : double;
function zipstr(Z : integer) : String;
procedure writeout(Var S : String; Var P : integer; t : String);
function UPStr(S: String) : String;
procedure UPString(Var S: String);
procedure TruncateStr(Var S : String);
procedure TruncateShortStr(Var S : String);
procedure Standartize(Var S : String);
function replaceword(Var S : String; F : String; T : String) : boolean;
function replaceallwords(Var S : String; F : String; T : String) : boolean;
function deletelastword(Var S : String) : boolean;
function deletelastwordExt(Var S : String; Var LW : String) : boolean;
function deletefirstword(Var S : String) : boolean;
function CoorStr(D : double) : String;
procedure  ValCoor(D : double; Var R : String);
function  ExtractLastWord(Var S : String): String;
function  ExtractFirstWord(Var S : String): String;
procedure CSVToTab(VAr S : string);
function TheFileExt(Name: String) : String;
function wordcount(Var S : String) : integer;
function CoorStr1(D : double) : String;
procedure Replacewords(Var S : String);
function parsename(S : String; Var prefix : string; Var Y, M, D : word) : double;
procedure deletespaces(Var S : String);
procedure DeleteEndSpaces(Var S : String);
function UnTab(S : String) : String;
function ValDate(Date : String) : integer;
function extractnumber(substr : string; S : String) : double;

implementation
uses sysutils, syncobjs, wintypes;

const CSAppend : TCriticalSection = nil;

function extractnumber(substr : string; S : String) : double;
Var C, p, pp : integer;
begin
   P := pos(substr, S);
   if P = 0 then
      begin
        result := 0;
        exit;
      end;
   inc(P, length(Substr));
   pp := p;
   while (P <= length(S)) and (S[P] <> ' ') and (S[P] <> TAB) and (S[P] <> #$A) do
      inc(p);
   S := copy(S, PP, p - PP);
   Val(S, result, C);
end;


function CoorStr1(D : double) : String;
begin
  Str(D : 10 : 6, Result);
end;


function wordcount(Var S : String) : integer;
Var i : integer;
begin
  i := 1;
  Result := 0;
  while i <= length(S) do
     begin
        while (i <= length(S)) and ((S[i] = ' ') or (S[i] = TAB)) do
           inc(i);
        if (i <= length(S)) and (S[i] <> ' ') and (S[i] <> TAB) then
           inc(Result);
        while (i <= length(S)) and ((S[i] <> ' ') and (S[i] <> TAB)) do
           inc(i);
     end;
end;

procedure parsedoublevar(Var S : String; Var VarName : String;
     Var D : double; Var Res : String; Var p : integer);
Var Start : integer;
    Code : integer;
begin
  Start := p;
  while (p <= length(S)) and (S[p] <> '=') do
    inc(p);
  if P > start then
    begin
      Varname := copy(S, Start, P - start);
      Start := p+1;
      if (Start <= length(S)) and (S[Start] = '"') then
        begin
          inc(Start);
          p := Start;
          while (p <= length(S)) and (S[p] <> '"') do
            inc(p);
        end
      else
        while (p <= length(S)) and (S[p] <> '&') do
          inc(p);
      Res := copy(S, Start, p - start);
      Val(Res, D, Code);
      inc(p);
    end
  else
     VarName := '';
end;

procedure AppendFile(Name, S: String);
Var  f : textfile;
begin
  CSAppend.Enter;
  try
    AssignFile(f, Name);
    if FileExists(Name) then
      Append(f)
    else
      Rewrite(f);
    writeln(f, S);
    CloseFile(f);
  finally
    CSAppend.Leave;
  end;
end;

function TheFullFileName(Name: String) : String;
Var S : String;
    i : integer;
begin
  S := '';
  i := length(Name);
  while (Name[i] <> '.') and (i > 0) do
    dec(i);
  if i > 0 then
    dec(i);
  while i > 0 do
    begin
      S := Name[i] + S;
      dec(i);
    end;
  TheFullFileName := S;
end;

function ValStr(S: String) : Longint;
var V : Longint;
    E : Integer;
begin
  if S = '' then
    ValStr := 0
  else
    begin
      Val(S, V, E);
      ValStr := V;
    end;
end;


function ValStr2(S: String) : Longint;
var V : Longint;
    E : Integer;
begin
  if S = '' then
    ValStr2 := 0
  else
    begin
      Val(S, V, E);
      if E = 0 then
        ValStr2 := V
      else
        ValStr2 := 0;
    end;
end;

function ValStr1(S: String) : Longint;
var V : Longint;
    E : Integer;
begin
  if S = '' then
    ValStr1 := -1
  else
    begin
      Val(S, V, E);
      ValStr1 := V;
    end;
end;


function scanint(Var S : String; Var P : integer) : integer;
Var Start : integer;
begin
   while (P <= length(S)) and (S[P] in [' ', TAB, #$A, #$D]) do
     inc(p);
   start := p;
   while (P <= length(S)) and (S[P] in ['0'..'9', '-']) do
     inc(p);
   if p = start then
     result := -1
   else
     result := ValStr(copy(S, start, p - start));
end;


function scandouble(Var S : String; Var P : integer) : double;
Var Start, Code : integer;
    D : String;
begin
   while (P <= length(S)) and (S[P] in [' ', TAB, #$A, #$D]) do
     inc(p);
   start := p;
   while (P <= length(S)) and (not (S[P] in [' ', TAB, #$A, #$D])) do
     inc(p);
   if p = start then
     result := 0
   else
     begin
        D := copy(S, start, p - start);
        Val(D, result, Code);
     end;
end;

function ScanStr(Var Src : String; Var pos : integer) : String;
Var Start : integer;
begin
  while (pos <= length(Src)) and ((Src[pos] = ' ') or (Src[Pos] = TAB)) do
    inc(pos);
  Start := pos;
  while (pos <= length(Src)) and ((Src[pos] <> ' ') and (Src[Pos] <> TAB)) do
    inc(pos);
  if pos > start then
    result := copy(Src, Start, pos - Start)
  else
    result := '';
end;

function ScanStr1(Var Src : String; Var pos : integer) : String;
Var Start : integer;
begin
  while (pos <= length(Src)) and ((Src[pos] = ' ') or (Src[Pos] = TAB)) do
    inc(pos);
  Start := pos;
  while (pos <= length(Src)) and ((Src[pos] <> ' ') and (Src[Pos] <> TAB)) do
    inc(pos);
  if pos > start then
    result := copy(Src, Start, pos - Start)
  else
    result := '';
end;


Procedure ScanLine(Var Src : String; Var p : integer; Var Dest: String);
Var Start : integer;
begin
  Start := P;
  while (p <= length(Src)) and ((Src[p] <> #$A) and (Src[P] <> #$D)) do
    inc(p);
  if P > Start then
    begin
       setlength(Dest, P-Start);
       move((@Src[Start])^, (@Dest[1])^, P - Start);
//       Dest := copy(Src, Start, P - Start)
    end
  else
    Dest := '';
  while (p <= length(Src)) and ((Src[p] = #$A) or (Src[P] = #$D)) do
    inc(p);
end;

function GetNextLine(Var S : String; Var p : integer) : String;
begin
  ScanLine(S, p, Result);
end;

function ExtractLine(Var S : String; PB, PE : integer) : String;
begin
   Result := copy(S, PB, PE - PB + 1);
   while pos(TAB, S) <> 0 do
      S[POS(TAB, S)] := ' ';
   while (length(Result) > 0) and (result[1] = ' ') do
      delete(result, 1, 1);
   while (length(Result) > 0) and (result[length(result)] = ' ') do
      delete(result, length(result), 1);
   if (length(result) > 0) and (Result[1] = '"') then
      delete(result, 1, 1);
   if (length(result) > 0) and (Result[length(result)] = '"') then
      delete(result, length(Result), 1);
   while (length(Result) > 0) and (result[1] = ' ') do
      delete(result, 1, 1);
   while (length(Result) > 0) and (result[length(result)] = ' ') do
      delete(result, length(result), 1);
end;

procedure CSVToTab(VAr S : string);
Var P, PB : integer;
    quote : boolean;
    R : String;
begin
  P := 1;
  PB := 1;
  quote := false;
  R := '';
  while P <= length(S) do
    begin
       if (S[P] = '"') then
         quote := not quote;
       if (not quote) and (S[p] = ',') then
         begin
            if R = '' then
              R := ExtractLine(S, PB, P - 1)
            else
              R := R + TAB + ExtractLine(S, PB, P - 1);
            PB := P + 1;
         end;
       inc(P);
    end;
  if R = '' then
    R := ExtractLine(S, PB, P - 1)
  else
    R := R + TAB + ExtractLine(S, PB, P - 1);
  S := R;
end;

Procedure ScanLine1(Var Src : String; Var p : integer; Var Dest: String);
Var Start : integer;
begin
  Start := P;
  while (p <= length(Src)) and ((Src[p] <> #$A) and (Src[P] <> #$D)) do
    inc(p);
  if P > Start then
    begin
       setlength(Dest, P - Start);
       move((@Src[Start])^, (@Dest[1])^, P - Start);
//       Dest := copy(Src, Start, P - Start)
    end
  else
    Dest := '';
  while (p <= length(Src)) and ((Src[p] = #$A) or (Src[P] = #$D)) do
    inc(p);
end;


procedure MoveToEol1(Var Src : string; Var p : integer);
begin
  while (p <= length(Src)) and ((Src[p] <> #$A) and (Src[P] <> #$D)) do
    inc(p);
end;

procedure NextLine(Var Src : string; Var p : integer);
begin
  while (p <= length(Src)) and ((Src[p] = #$A) or (Src[P] = #$D)) do
    inc(p);
end;

function ReadStringFile(Name : String; Var Res : String) : boolean;
var SearchRec : TSearchRec;
    F : File;
    nr : integer;
begin
  if FindFirst(Name, faAnyFile, SearchRec) = 0 then
    begin
      setlength(Res, SearchRec.Size);
      assign(F, Name);
      reset(F, 1);
      try
        blockread(F, (@Res[1])^, SearchRec.Size, nr);
      finally
        closefile(F);
      end;
      Result := true;
    end
  else
     begin
       Res := '';
       Result := false;
     end;
  SysUtils.FindClose(SearchRec);
end;

function WriteStringFile(Name : String; Var Res : String) : boolean;
var F : File;
    nr : integer;
begin
  assign(F, Name);
  rewrite(F, 1);
  Result := false;
  try
    blockwrite(F, (@Res[1])^, length(Res), nr);
  finally
    closefile(F);
  end;
  Result := true;
end;

function GetHardRootDir : String;
Var S: String;
begin
  S := paramstr(0);
  while S[length(S)] <> '\' do
    setlength(S, length(S) - 1);
  if (length(S) > 3) then
    setlength(S, length(S) - 1);
  GetHardRootDir := S;
end;

function GetHardRootDir1 : String;
Var S: String;
begin
  S := GetHardRootDir;
  if S[Length(S)] <> '\' then
    S := S + '\';
  GetHardRootDir1 := S;
end;


function ReadDouble(S : String) : double;
Var C : integer;
begin
  Val(S, Result, C);
end;

function NanoTime : int64;
var Res : TLargeInteger;
begin
  if QueryPerformanceCounter(Res) then
    Result := res
  else
    Result := 0;
end;

function NanoFrequency : int64;
Var Res : int64;
begin
  if QueryPerformanceFrequency(res) then
    Result := res
  else
    Result := 1;
end;

procedure SkipFields(Var S : String; FieldNo : integer; Var P : integer; addTabs : boolean = false);
Var i : integer;
begin
   for i := 0 to FieldNo - 1 do
     begin
        while  (P <= length(S)) and (S[P] <> TAB) do
           inc(P);
        if AddTabs then
           if P > length(S) then
              S := S + Tab;
        inc(P);
     end;
end;

function GetNextField(Var S : String; Var P : integer) : String;
begin
   ExtractField(S, Result, P);
end;

procedure ExtractField(Var S : String; Var D : String; Var P : integer);
Var Start : integer;
begin
   Start := p;
   while  (P <= length(S)) and (S[P] <> TAB) and (S[P] <> #10) and (S[P] <> #13) and (S[P] <> '}') do
     inc(P);
   D := copy(S, start, P - Start);
   if (p <= length(S)) and (S[P] <> #10) and (S[P] <> #13) then
     inc(P);
   if (p <= length(S)) and ((S[p] = '{') or (S[p] = '}')) then
      inc(p);
end;

procedure ExtractFieldByNum(Src: String; N: INteger; Var Field : String);
Var p : integer;
begin
  P := 1;
  SkipFields(Src, N-1, P);
  ExtractField(Src, Field, P);
end;

procedure SkipCommas(Var S : String; FieldNo : integer; Var P : integer; addTabs : boolean = false);
Var i : integer;
begin
   for i := 0 to FieldNo - 1 do
     begin
        while  (P <= length(S)) and (S[P] <> ',') do
           inc(P);
        if AddTabs then
           if P > length(S) then
              S := S + ',';
        inc(P);
     end;
end;

function GetNextComma(Var S : String; Var P : integer) : String;
begin
   ExtractField(S, Result, P);
end;

procedure ExtractComma(Var S : String; Var D : String; Var P : integer);
Var Start : integer;
begin
   Start := p;
   while  (P <= length(S)) and (S[P] <> ',') and (S[P] <> #10) and (S[P] <> #13) and (S[P] <> '}') do
     inc(P);
   D := copy(S, start, P - Start);
   if (p <= length(S)) and (S[P] <> #10) and (S[P] <> #13) then
     inc(P);
   if (p <= length(S)) and ((S[p] = '{') or (S[p] = '}')) then
      inc(p);
end;

procedure ExtractCommaByNum(Src: String; N: INteger; Var Field : String);
Var p : integer;
begin
  P := 1;
  SkipCommas(Src, N-1, P);
  ExtractComma(Src, Field, P);
end;


procedure ReplaceFieldByNum(Var S : String; F : integer; NewF : String);
Var P, Start : integer;
begin
   P := 1;
   SkipFields(S, F, P, true);
   Start := p;
   while  (P <= length(S)) and (S[P] <> TAB) and (S[P] <> #10) and (S[P] <> #13)do
     inc(P);
   delete(S, start, P - Start);
   Insert(NewF, S, start);
end;

function MemAvail : dword;
var
  MemoryStatus: TMemoryStatus;
begin
  ZeroMemory(@MemoryStatus, SizeOf(MemoryStatus));
  MemoryStatus.dwLength := SizeOf(MemoryStatus);
  GlobalMemoryStatus(MemoryStatus);
  Result := MemoryStatus.dwAvailPhys;
{  FTotalPhysical := MemoryStatus.dwTotalPhys;
  FMemoryLoad := MemoryStatus.dwMemoryLoad;
  FTotalPageFile := MemoryStatus.dwTotalPageFile;
  FAvailablePageFile := MemoryStatus.dwAvailPageFile;
  FTotalVirtual := MemoryStatus.dwTotalVirtual;
  FAvailableVirtual := MemoryStatus.dwAvailVirtual;}
end;

procedure StartTime(Var T : int64);
begin
  T := Nanotime;
end;
function  HtmlTime(Var T : int64) : string;
begin
  Result := format('<p><b>S-tree Search Done. Execution time = %10.7f Seconds</b></p>', [(Nanotime-T)/Nanofrequency]);
end;
function  TextTime(Var T : int64; USeRam : boolean) : string;
begin
  if UseRam then
    Result := format(#10+'TIME:  elapsed %10.7f seconds', [(Nanotime-T)/Nanofrequency])
  else
    Result := format(#10+'TIME:  elapsed %10.7f seconds, includes the disk access time for record retrieval.', [(Nanotime-T)/Nanofrequency])
end;

function  GetTimeText : String;
begin
  Result := FormatDateTime('yyyy/mm/dd hh:nn:ss> ', now);
end;

function strtodouble(Var S : String) : double;
Var C : integer;
begin
  Val(S, result, C);
  if C <> 0 then
    result := 0;
end;

procedure ReadToQuote(Var S : String; Var P : integer; Var D : String);
Var Start : integer;
begin
  while (P <= length(S)) and (S[P] in [' ', ',', TAB, '"', #$D, #$A]) do
    inc(P);
  Start := P;
  while (P < length(S)) and ( S[P] <> ',') do
    inc(P);
  D := copy(S, Start, P - Start);
  inc(P);
end;

procedure ReadCommaQuote(Var S : String; Var P : integer; Var D : String);
Var Start : integer;
begin
  while (P <= length(S)) and (S[P] in [' ', ',', TAB, '"', #$D, #$A]) do
    inc(P);
  Start := P;
  while (P < length(S)) and ( S[P] <> '"') do
    inc(P);
  D := copy(S, Start, P - Start);
  inc(P);
end;

procedure ReadQuote(Var S : String; Var P : integer; Var D : String);
Var Start : integer;
begin
  while (P <= length(S)) and (S[P]  <> '"') and (S[P]  <> #$A) and (S[P]  <> #$D) do
    inc(P);
  if (P >= length(S)) or (S[P] in [#$A, #$D]) then
     begin
        D := '';
        exit;
     end;
  inc(P);
  Start := P;
  while (P < length(S)) and ( S[P] <> '"') do
    inc(P);
  D := copy(S, Start, P - Start);
  inc(P);
end;

function zipstr(Z : integer) : String;
begin
   Result := inttostr(Z);
   while length(Result) < 5 do
     Result := '0' + Result;
end;

procedure writeout(Var S : String; Var P : integer; t : String);
Var i : integer;
begin
   if (P + length(t)) >= length(S) then
     setlength(S, round(P + length(t) * 1.5) + 100);
   for i := 0 to length(t) - 1 do
     S[P+i] := t[i+1];
   inc(P, length(t));
end;

function UPStr(S: String) : String;
var  i : Integer;
begin
  Result := S;
  for i := 1 to length(S) do
    Result[i] := upcase(result[i]);
end;

procedure UPString(Var S: String);
var  i : Integer;
begin
  for i := 1 to length(S) do
    S[i] := upcase(S[i]);
end;


procedure TruncateStr(Var S : String);
begin
   while (length(S) > 0) and (S[1] = ' ') do
     delete(S, 1, 1);
   while (length(S) > 0) and (S[length(S)] = ' ') do
     delete(S, length(S), 1);
end;

procedure TruncateShortStr(Var S : String);
begin
   while (length(S) > 0) and ((S[1] = ' ') or (S[1] = TAB)) do
     delete(S, 1, 1);
   while (length(S) > 0) and ((S[length(S)] = ' ')or (S[length(S)] = TAB)) do
     delete(S, length(S), 1);
end;

function replaceword(Var S : String; F : String; T : String) : boolean;
Var P : integer;
begin
   p := pos(F, S);
   if P <> 0 then
     if ((P = 1) or (S[P-1] = ' ')) and
          ( ((P + length(F)-1) >= length(S)) or (S[P+length(F)] = ' ')) then
     begin
       Result := true;
       delete(S, P, length(F));
       insert(T, S, P);
       exit;
     end;
   Result := false;
end;


function replaceallwords(Var S : String; F : String; T : String) : boolean;
Var P : integer;
begin
   Result := false;
   p := pos(F, S);
   while P <> 0 do
     begin
       delete(S, P, length(F));
       insert(T, S, P);
       p := pos(F, S);
       Result := true;
     end;
end;


function deletelastwordExt(Var S : String; Var LW : String) : boolean;
Var P : integer;
begin
   Result := false;
   if length(S) = 0 then
      exit;
   P := length(S);
   while P > 0 do
     begin
       dec(P);
       if S[P] = ' ' then
          begin
            LW := copy(S, P + 1, length(S) - P);
            setlength(S, P - 1);
            Result := true;
            exit;
          end;
     end;
   S := '';
end;

function Numbefore(Var S : String; P : integer) : boolean;
begin
   dec(P);
   result := false;
   while (P > 0) and (S[P] <> ' ') do
     begin
       if (S[p] > '9') or (S[p] < '0') then
         begin
           Result := false;
           exit;
         end;
       dec(p);
       result := true;
     end;
end;

function CharAfter(Var S : String; P : integer) : boolean;
begin
  result := (P < length(S)) and ((S[p+1] < '0') or (S[p+1] > '9'));
end;

function  NumAfter(Var S : String; P : integer) : boolean;
begin
   inc(P);
   result := false;
   while (P <= length(S)) and (S[P] <> ' ') do
     begin
       if (S[p] > '9') or (S[p] < '0') then
         begin
           Result := false;
           exit;
         end;
       inc(p);
       result := true;
     end;
end;

procedure Standartize(Var S : String);
Var P, PP : integer;
    Num : boolean;
    SS : String;
begin
   UpString(S);
   repeat
     P := Pos('%20', S);
     if P <> 0 then
       begin
         delete(S, P, 2);
         S[P] := ' ';
       end;
   until P = 0;
   repeat
     P := Pos('(', S);
     if P <> 0 then
       begin
         PP := Pos(')', S);
         if PP > P then
           delete(S, P, PP - P + 1)
         else
           break;
       end;
   until P = 0;
   P := 1;
   Num := false;
   while P <= length(S) do
     begin
        if (S[P] = '.') or (S[P] = '+') or (S[P] = '*') or (S[P] = TAB) or (S[P] = '#') or (S[P] = ',') or (S[P] = '''') then
           S[P] := ' ';
        if (S[P] = '-') then
           if not ( Numbefore(S, P) and (CharAfter(S, P) or NumAfter(S, P))) then
              S[P] := ' ';
        if (S[P] >= '0') and (S[P] <='9') then
          Num := true
        else if Num then
          begin
            ss := copy(S, P, 2);
            if (ss = 'ND') or (ss = 'RD') or (ss = 'ST') or (ss = 'TH') then
              begin
                delete(S, P, 2);
                dec(p, 1);
              end;
            Num := false;
          end;
        inc(P);
     end;
   repeat
      P := pos('  ', S);
      if P <> 0 then
        delete(S, P, 1);
   until P = 0;
   while (length(S) > 0) and (S[length(S)] = ' ') do
      setlength(S, length(S) - 1);
   while (length(S) > 0) and (S[1] = ' ') do
      delete(S, 1, 1);
end;

procedure Replacewords(Var S : String);
begin
   replaceword(S,'ND', '');
   replaceword(S,'TH', '');
{   replaceword(S, 'ONE', 1);
   replaceword(S, 'TWO', 2);
   replaceword(S, 'THREE', 3);
   replaceword(S, 'FOUR', 4);
   replaceword(S, 'FIVE', 5);
   replaceword(S, 'SIX', 6);
   replaceword(S, 'SEVEN', 7);
   replaceword(S, 'EIGHT', 8);
   replaceword(S, 'NINE', 9);}
   replaceword(S, 'FIRST', '1');
   replaceword(S, 'SECOND', '2');
   replaceword(S, 'THIRD', '3');
   replaceword(S, 'FOURTH', '4');
   replaceword(S, 'FIFTH', '5');
   replaceword(S, 'SIXTH', '6');
   replaceword(S, 'SEVENTH', '7');
   replaceword(S, 'EIGHTH', '8');
   replaceword(S, 'NINTH', '9');
   replaceword(S, 'TENTH', '10');
   replaceword(S, 'ELEVENTH', '11');
   replaceword(S, 'TWELVETH', '12');
   replaceword(S, 'THIRTEENTH', '13');
   replaceword(S, 'FOURTEENTH', '14');
   replaceword(S, 'FIFTEENTH', '15');
   replaceword(S, 'SIXTEENTH', '16');
   replaceword(S, 'SEVENTEENTH', '17');
   replaceword(S, 'EIGHTEENTH', '18');
   replaceword(S, 'NINETEENTH', '19');
   replaceword(S, 'UNITED STATES', 'US');
   replaceword(S, 'U S', 'US');
   replaceword(S, 'HIGHWAY', 'HWY');
   replaceword(S, 'US HWY', 'US');
   replaceword(S, 'STATE HWY', 'HWY');
   replaceword(S, 'AVENUE', 'AVE');
   replaceword(S, 'STREET', 'ST');
   replaceword(S, 'ROAD', 'RD');
   replaceword(S, 'ROUTE', 'RTE');
   replaceword(S, 'STATE RD', 'SR');
   if pos('STATE', S) = 1 then
     replaceword(S, 'STATE', 'ST');
   replaceword(S, 'COUNTY', 'CO');
   replaceword(S, 'CO RD', 'CR');
   replaceword(S, 'COURT', 'CT');
   replaceword(S, 'TERRACE', 'TER');
   replaceword(S, 'BOULEVARD', 'BLVD');
   replaceword(S, 'CIRCLE', 'CIR');
   replaceword(S, 'LANE', 'LN');
   replaceword(S, 'PLACE', 'PL');
   replaceword(S, 'N E', 'NE');
   replaceword(S, 'N W', 'NW');
   replaceword(S, 'S W', 'SW');
   replaceword(S, 'S E', 'SE');
   replaceword(S, 'NORTH EAST', 'NE');
   replaceword(S, 'NORTH WEST', 'NW');
   replaceword(S, 'SOUTH WEST', 'SW');
   replaceword(S, 'SOUTH EAST', 'SE');
end;

function ExtractLastWord(Var S : String): String;
Var P : integer;
begin
  if (S = '') then
     begin
        Result := '';
        exit;
     end;
  P := length(S);
  while (P > 0) and (S[P] <> ' ') do
    dec(P);
  Result := copy(S, P+1, length(S) - P);
end;

function deletelastword(Var S : String) : boolean;
Var P : integer;
begin
   Result := false;
   if length(S) = 0 then
      exit;
   P := length(S);
   while P > 0 do
     begin
       dec(P);
       if S[P] = ' ' then
          begin
            setlength(S, P - 1);
            Result := true;
            exit;
          end;
     end;
   S := '';
end;

function ExtractFirstWord(Var S : String): String;
Var FP, P : integer;
begin
  if (S = '') then
     begin
        Result := '';
        exit;
     end;
  P := 1;
  while (P <= length(S)) and (S[P] = ' ') do
    inc(P);
  FP := P;
  while (P <= length(S)) and (S[P] <> ' ') do
    inc(P);
  Result := copy(S, FP, P-FP);
end;

function deletefirstword(Var S : String) : boolean;
Var P : integer;
begin
   Result := false;
   if length(S) = 0 then
      exit;
   P := 1;
   while P <= length(S) do
     begin
       if S[P] = ' ' then
          begin
            delete(S, 1, P);
            Result := true;
            exit;
          end;
       inc(P);
     end;
   S := '';
end;

function CoorStr(D : double) : String;
Var R : String;
begin
   ValCoor(D, R);
   Result := R; 
end;

procedure  ValCoor(D : double; Var R : String);
begin
   Str(D : 10 : 6, R);
   while (length(R) > 0) and (R[1] = ' ') do
     delete(R, 1, 1);
end;

function TheFileExt(Name: String) : String;
Var S : String;
    i : integer;
begin
  S := '';
  if pos('.', Name) = 0 then
    begin
      TheFileExt := '';
      exit;
    end;
  i := length(Name);
  while (i > 0) and (Name[i] <> '.') do
    begin
      S := Name[i] + S;
      dec(i);
    end;
  TheFileExt := Upstr(S);
end;

function TheFileName(Name: String; noext : boolean = false) : String;
Var S : String;
    i : integer;
begin
  S := '';
  i := length(Name);
  if not noext then
    begin
      while (Name[i] <> '.') and (i > 0) do
        dec(i);
      if i > 0 then
        dec(i);
    end;
  while i > 0 do
    begin
      S := Name[i] + S;
      dec(i);
      if Name[i] in ['\', '/', ':'] then
        break;
    end;
  TheFileName := S;
end;

function parsename(S : String; Var prefix : string; Var Y, M, D : word) : double;
Var p, pp : integer;
    year, md : string;
begin
   p := 1;
   while (p <= length(S)) and (not ((S[p] in ['0'..'9']))) do
     inc(p);
   pp := p;
   while (pp <= length(S)) and (((S[pp] in ['0'..'9']))) do
     inc(pp);
   prefix := copy(S, 1, p-1);
   year := copy(s, p, 4);
   Y := ValStr(Year);
   md := copy(s, p+4, pp - (p+4));
   if length(md) = 4 then
      begin
        M := Valstr(copy(md, 1, 2));
        D := ValStr(copy(md, 3, 2));
        try
          Result := encodedate(Y, M, D);
        except on e: exception do
          Result := 0;
        end;
      end
   else
      begin
        D := ValStr(md);
        try
          Result := EncodeDate(y, 1, 1);
        except on E: exception do
           Result := 0;
        end;
        Result := Result + D - 1;
        DecodeDate(result, y, m, d);
      end
end;

procedure DeleteEndSpaces(Var S : String);
begin
  while (length(S) > 0) and ((S[1] = ' ') or (S[1] = TAB)) do
    delete(S, 1, 1);
  while (length(S) > 0) and ((S[length(S)] = ' ') or (S[length(S)] = TAB)) do
    delete(S, length(S), 1);
end;

procedure deletespaces(Var S : String);
Var p : integer;
begin
   repeat
     p := pos(' ', s);
     if p <> 0 then
        delete(S, p, 1);
   until p = 0;
end;

function UnTab(S : String) : String;
begin
   while Pos(TAB, S) <> 0 do
     S[Pos(TAB,S)] := ' ';
   Result := S;
end;

function ValDate(Date : String) : integer;
Var year, month, day : string;
begin
   if length(Date) <> 10 then
     begin
       result := 0;
       exit;
     end;
   year := copy(Date, 1, 4);
   month := copy(Date, 6, 2);
   Day := copy(Date, 9, 2);
   result := trunc(encodedate(valstr(year), valstr(Month), Valstr(Day)));
end;


initialization
begin
    CSAppend := TCriticalSection.Create;
end;
finalization
begin
    CSAppend.Free;
end;
end.

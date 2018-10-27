unit Directory;

interface

type TDirEntry = record
        ID : byte;
        Count : integer;
        Name : String;
        AltNames : array of String;
        Similar : array of String;
end;

type TDirHashEntry = record
        ID : byte;
        Name : String;
        HashNext : integer;
end;

type TDir = class
public
     DirName : String;
     NameHash : array of TDirHashEntry;
     Hash : array[0..255] of integer;
     Table : array of TDirEntry;
     Msg : String;
     Dialogresult : integer;
     procedure QueryProc;
     constructor Create(Dir : String);
     procedure Init;
     function  find(Name : String) : integer;
     procedure Add(Name : String; ID : integer = -1);
     procedure Save(Sort : boolean);
     procedure Load;
     procedure AddAbbrev(Name : String; Delimiter : char; Query : boolean);
     function  HashFun(Var S : String) : integer;
     function IsSimilar(i1, i2 : integer) : boolean;
     function Getname(ID : integer) : String;
     function GetShortName(ID : integer) : String;
     function GetFullname(ID : integer) : String;
     procedure HashAdd(Name : String; ID : integer);
end;

implementation
uses myutil1, parser, Controls, sysutils, Threadpool;

constructor TDir.Create(Dir : String);
begin
   DirName := Dir;
   Init;
end;

procedure TDir.Init;
Var i : integer;
begin
   for i := 0 to 255 do
     Hash[i] := -1;
   Table := nil;
   NameHash := nil;
end;

function TDir.Hashfun(Var S : String) : integer;
begin
   if length(S) = 0 then
     Result := 0
   else if length(S) <= 1 then
     Result := ord(S[1]) mod length(Hash)
   else
     Result := (ord(S[1]) + ord(S[length(S)]) * 8 + ord(S[length(S) div 2]) * 64) mod length(Hash);
end;

function TDir.IsSimilar(i1, i2 : integer) : boolean;
Var i, j : integer;
begin
   if (i1 = i2) or (i1 = 0) or (i2 = 0) then
     begin
       result := true;
       exit;
     end;
   result := false;
end;

function TDir.Getname(ID : integer) : String;
Var i : integer;
begin
   Result := Table[ID].Name;
end;

function TDir.GetShortname(ID : integer) : String;
Var i : integer;
begin
   Result := Table[ID].Name;
   for i := 0 to length(Table[ID].AltNames) - 1 do
     if length(Table[ID].Altnames[i]) < length(Result) then
       Result := Table[ID].Altnames[i];
end;


function TDir.GetFullname(ID : integer) : String;
Var i : integer;
begin
   Result := Table[ID].Name;
   for i := 0 to length(Table[ID].AltNames) - 1 do
     Result := Result + ',' + Table[ID].Altnames[i];
end;

function TDir.find(Name : String) : integer;
Var H : integer;
begin
  Name := UpStr(Name);
  TruncateStr(Name);
  H := HashFun(Name);
  H := Hash[H];
  while H >= 0 do
    if NameHash[H].Name = Name then
       begin
         Result := NameHash[H].ID;
         exit;
       end
    else
       H := NameHash[H].HashNext;
   Result := -1;
//   raise exception.create('error in tdir.find');
end;


procedure TDir.Add(Name : String; ID : integer = -1);
Var H : integer;
begin
    Name := UpStr(Name);
    TruncateStr(Name);
    H := Find(Name);
    if H >= 0 then
      begin
       inc(Table[h].Count);
       exit;
      end;
    if ID < 0 then
      begin
         setlength(Table, length(Table) + 1);
         ID := length(Table)-1;
         Table[ID].ID := ID;
         Table[ID].Count := 1;
         Table[ID].Name := Name;
         Table[ID].AltNames := nil;
         Table[ID].Similar := nil;
      end
    else
      begin
         setlength(Table[ID].AltNames, length(Table[ID].AltNames) + 1);
         Table[ID].AltNames[length(Table[ID].AltNames) - 1] := Name;
      end;
    HashAdd(Name, ID);
end;

procedure TDir.HashAdd(Name : String; ID : integer);
Var H : integer;
begin
    H := Hashfun(Name);
    setlength(NameHash, length(NameHash) + 1);
    NameHash[length(NameHash)-1].ID := ID;
    NameHash[length(NameHash)-1].Name := Name;
    NameHash[length(NameHash)-1].HashNext := Hash[H];
    Hash[H] := length(NameHash) - 1;
end;

procedure TDir.AddAbbrev(Name : String; Delimiter : char; Query : boolean);
Var pp, i,j, c, P, P0, ID : integer;
    W : array[0..100] of String;
    S : String;
    SF : String;
    AllFound : boolean;
    Found : boolean;
    ambigous : boolean;
    fid : integer;
    fidx : integer;
begin
  ReadStringFile(Name, SF);
  PP := 1;
  while PP < length(SF) do
       begin
         scanline(SF, PP, S);
         P := 1;
         P0 := P;
         C := 0;
         while P <= length(S) do
           begin
             if (S[P] = Delimiter) or (P = length(S)) then
               begin
                  if (P = length(S)) then
                    W[C] := copy(S, P0, P-P0 + 1)
                  else
                    W[C] := copy(S, P0, P-P0);
                  TruncateShortStr(W[C]);
                  UPString(W[C]);
                  if (W[C] <> '') and (W[C] <> '-') then
                    inc(C);
                  while (P <= length(S)) and (S[P] = Delimiter) do
                    inc(P);
                  P0 := P;
               end;
             inc(P);
           end;
         AllFound := true;
         Found := false;
         ambigous := false;
         fid := -1;
         fidx := -1;  
         for i := 0 to c - 1 do
           begin
             ID := find(W[i]);
             if ID >= 0 then
               begin
                 found := true;
                 if (fid >= 0) and (fid <> ID) then
                   ambigous := true
                 else
                   begin
                     fid := ID;
                     fidx := i;
                   end;
               end;
             if ID < 0 then
               AllFound := false;
           end;
         if (not AllFound) and (Found) then
           begin
             if Query or Ambigous then
               begin
                 Msg :=  S + '  == ' + GetFullName(fid) + ' ?';
                 MainThreadExec(QueryProc);
                 found := dialogresult = mrYes;
               end;
             if found then
                  begin
                     for j := 0 to C - 1 do
                        if fidx <> j then
                          if (W[j] <> '-') and (W[j] <> '') then
                            begin
                              Add(W[j], fid);
                            end;
                  end;
           end;
       end;
end;

procedure TDir.QueryProc;
begin
   dialogresult := MessageDlgYesNo(Msg);
end;

procedure TDir.Save(Sort : boolean);
Var F : Text;
    i, j, Maxlength : integer;
    T, S : String;
function Less(X, Y : TDirEntry) : boolean;
begin
   if X.Count <> Y.Count then
     Result := X.Count > Y.Count
   else
     Result := X.Name < Y.Name;
end;
  procedure QuickSort(L, R: Integer);
  var
    I, J : Integer;
    T, X : TDirEntry;
  begin
    I := L;
    J := R;
    X := Table[(L + R) div 2];
    repeat
      while Less(Table[i],  X) do Inc(I);
      while Less(X, Table[J]) do Dec(J);
      if I <= J then
      begin
        T := Table[I];
        Table[I] := Table[J];
        Table[J] := T;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then QuickSort(L, J);
    if I < R then QuickSort(I, R);
  end;
begin
  for i := 0 to length(Table) - 1 do
    with Table[i] do
      begin
        Maxlength := length(Name);
        for j := 0 to length(AltNames) - 1 do
          if length(AltNames[j]) > Maxlength then
            begin
              T := AltNames[j];
              AltNames[j] := Name;
              Name := T;
              MaxLength := length(Name);
            end;
        end;
   if (length(Table) > 1) and Sort then
     QuickSort(0, length(Table) - 1);
   AssignFile(f, DirName);
   Rewrite(F);
   try
      for i := 0 to length(Table) - 1 do
        with Table[i] do
          begin
            S := inttostr(i) + ',' + inttostr(Count) + ',' + Name;
            for j := 0 to length(AltNames) - 1 do
               S := S + ',' + AltNames[j];
            writeln(F, S);
          end;
      writeln(F, '.');
   finally
     CloseFile(F);
   end;
   Load;
end;

function GetNextCommaText(S : String; Var P : integer) : String;
Var b : integer;
begin
  b := p;
  while (p <= length(S)) and (S[p] <> ',') do
    inc(p);
  result := copy(S, b, p - b);
  if p <= length(S) then
    inc(p);
end;

procedure TDir.Load;
Var F : Text;
    p, i, H, Cnt, V, E : integer;
    A, S : String;
    MainName : String;
begin
   Init;
   if not FileExists(DirName) then
     exit;
   AssignFile(f, DirName);
   Reset(F);
   try
      while not EOF(F) do
        begin
          readln(F, S);
          if S = '.' then
             break;
          p := 1;
          i := ValStr(GetNextCommaText(S, p));
          Cnt := ValStr(GetNextCommaText(S, p));
          setlength(Table, length(Table) + 1);
          if Length(Table) <> (i + 1) then
            raise exception.create('error loading file ' + DirName);
          Table[i].Name := GetNextCommaText(S, p);
          HashAdd(Table[i].Name, i);
          Table[i].Count := Cnt;
          Table[i].Altnames := nil;
          A := GetNextCommaText(S, p);
          while A <> '' do
            begin
              setlength(Table[i].Altnames, length(Table[i].Altnames) + 1);
              Table[i].Altnames[length(Table[i].Altnames) - 1] := A;
              HashAdd(A, i);
              A := GetNextCommaText(S, p)
            end;
          
          Table[i].Similar := nil;
        end;
   finally
     CloseFile(F);
   end;
end;



end.

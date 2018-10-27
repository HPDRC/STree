unit FileIO;

interface
uses sysutils;

type TFIleIO = class
public
    _F : File;
    _BPos, _MaxB : integer;
    _Write : boolean;
    _buffer : array[0..1024*16-1] of char;
    constructor Create(FileName : String; Create : boolean = false; ReadOnly : boolean = true);
    destructor Free;
    procedure WriteInt(i : integer);
    procedure writebyte(i : integer);
    function  readbyte1(var Res : boolean) : byte;
    function  readbyte : byte;
    procedure WriteDouble(d : double);
    procedure WriteSingle(d : single);
    procedure WriteString(Var S : String);
    procedure WriteLongString(S : String);
    procedure WriteBuffer(Var B; len : integer);
    procedure Flush;
    procedure Refill;
    procedure ReadBuffer(Var B; len : integer);
    procedure ReadString(Var S : String);
    function ReadDouble : double;
    function ReadSingle : single;
    function ReadInt : integer;
    function GetSize : integer;
    function ReadLine(var S : String) : boolean;
end;

const IO_FileNotFound = 1;
const IO_NoMoreData = 2;

type EFileIOException = class(Exception)
   public
      _ErrCode : integer;
      constructor Create(ErrCode : integer);
//      function GetErrorMessage : String;
end;

implementation



procedure TFileIO.WriteLongString(S : String);
Var SS : String;
begin
  SS := S;
  WriteString(SS);
end;


constructor EFIleIOException.Create(ErrCode : integer);
begin
   _ErrCode := ErrCode;
   if ErrCode = IO_FileNotFound then
      inherited Create('File not found')
   else if ErrCode = IO_NoMoreData then
      inherited Create('No More data')
end;

constructor TFileIO.Create(Filename : String; Create : boolean; ReadOnly : boolean);
begin
   if ReadOnly then
     FileMode := 0
   else
     FileMode := 2;
   AssignFile(_F, FileName);
   if Create then
      begin
        Rewrite(_F, 1);
        _Write := not ReadOnly;
      end
   else
      begin
        try
          Reset(_F, 1);
        except on E : EInOutError do
          begin
            raise EFileIOException.Create(IO_FileNotFound);
          end
        end;
        _Write := not ReadOnly;
      end;
   _BPos := 0;
   _MaxB := 0;
end;


destructor TFileIO.Free;
begin
   if _Write then
      Flush;
   CloseFile(_F);
end;

procedure TFileIO.WriteInt(i : integer);
begin
  if (sizeof(i) + _BPos) > sizeof(_buffer) then
      Flush;
  move((@i)^, (@_buffer[_BPos])^, sizeof(i));
  inc(_BPos, sizeof(i));
end;

procedure TFileIO.writebyte(i : integer);
begin
  if (1 + _BPos) > sizeof(_buffer) then
      Flush;
  _buffer[_BPos] := char(i and 255);
  inc(_BPos);
end;

type ENoData = class(Exception)
end;

function  TFileIO.readbyte : byte;
begin
  if _MaxB-_BPos  < 1 then
     begin
       Refill;
       if _MaxB-_BPos  < 1 then
          raise ENoData.Create('No More data');
     end;
  result := byte(_buffer[_BPos]);
  inc(_BPos);
end;

function  TFileIO.readbyte1(var Res : boolean) : byte;
begin
  if _MaxB-_BPos  < 1 then
     begin
       Refill;
       if _MaxB-_BPos  < 1 then
         if Res then
            begin
              Res := false;
              exit;
            end
         else
            raise ENoData.Create('No More data');
     end;
  result := byte(_buffer[_BPos]);
  inc(_BPos);
end;

procedure TFileIO.WriteDouble(d : double);
begin
  if (sizeof(d) + _BPos) > sizeof(_buffer) then
     Flush;
  move((@d)^, (@_buffer[_BPos])^, sizeof(d));
  inc(_BPos, sizeof(d));
end;


procedure TFileIO.WriteSingle(d : single);
begin
  if (sizeof(d) + _BPos) > sizeof(_buffer) then
     Flush;
  move((@d)^, (@_buffer[_BPos])^, sizeof(d));
  inc(_BPos, sizeof(d));
end;

procedure TFileIO.WriteString(Var S : String);
begin
   if (length(S) + 5 + _BPos) > sizeof(_buffer) then
      Flush;
   if length(S) >= 255 then
     begin
       writebyte(255);
       writeint(length(s));
     end
   else
     writebyte(length(S));
   writebuffer((@(S[1]))^, length(S));
end;

procedure TFileIO.WriteBuffer(Var B; len : integer);
begin
   if (len + _BPos) > sizeof(_buffer) then
      Flush;
   move(B, (@_buffer[_BPos])^, len);
   inc(_BPos, len);
end;

procedure TFileIO.Flush;
begin
   blockwrite(_F, _buffer, _BPos);
   _BPos := 0;
end;

procedure TFileIO.ReadBuffer(Var B; len : integer);
Var Ptr: pchar;
    Blen : integer;
begin
   Ptr := @B;
   while len > 0 do
     begin
       Blen := _MaxB-_BPos;
       if len >  Blen then
          begin
             if Blen > 0 then
               begin
                 dec(len, Blen);
                 move(_buffer[_BPos], Ptr^, Blen);
                 inc(Ptr, Blen);
               end;
             _BPos := _MaxB;
             Refill;
             if _MaxB = 0 then
               raise Exception.Create('No More data');
          end
        else
          begin
             move(_buffer[_BPos], Ptr^, len);
             inc(_BPos, len);
             break;
          end;
     end;
end;

function TFileIO.ReadLine(var S : String) : boolean;
var c : char;
    res : boolean;
begin
   S := '';
   try
   result := true;
   Res := true;
   c := char(readbyte1(res));
   if not Res then
     begin
        Result := false;
        exit;
     end;
   while (c = #$d) or (c = #$a) do
     begin
       c := char(readbyte1(Res));
       if not Res then
         begin
            Result := false;
            exit;
         end;
     end;
   while (c <> #$d) and (c <> #$a) do
      begin
        s := s + c;
        c := char(readbyte1(Res));
        if not Res then
          break;
      end;
   except on E: ENoData do
      result := false;
   end;
end;


procedure TFileIO.ReadString(Var S : String);
Var L : integer;
begin
  if _MaxB = _BPos then
    begin
      Refill;
      if _MaxB = _BPos then
        raise Exception.Create('No More data');
    end;
  L := ReadByte;
  if L = 255 then
    L := ReadInt;
  setlength(S, L);
  ReadBuffer((@S[1])^, length(S));
end;

function TFileIO.ReadDouble : double;
begin
  if _MaxB-_BPos  < sizeof(double) then
     begin
       Refill;
       if _MaxB-_BPos  < sizeof(double) then
         raise Exception.Create('No More data');
     end;
  move(_buffer[_Bpos], Result, sizeof(double));
  inc(_BPos, sizeof(double));
end;

function TFileIO.ReadSingle : single;
begin
  if _MaxB-_BPos  < sizeof(double) then
     begin
       Refill;
       if _MaxB-_BPos  < sizeof(single) then
         raise Exception.Create('No More data');
     end;
  move(_buffer[_Bpos], Result, sizeof(single));
  inc(_BPos, sizeof(single));
end;


function TFileIO.ReadInt : integer;
begin
  if _MaxB-_BPos  < sizeof(integer) then
    begin
       Refill;
       if _MaxB-_BPos  < sizeof(integer) then
          raise Exception.Create('No More data');
    end;      
  move(_buffer[_Bpos], Result, sizeof(integer));
  inc(_BPos, sizeof(integer));
end;

const _deb : integer = 0;
procedure TFileIO.Refill;
Var nr : integer;
begin
   inc(_deb);
   if _deb = 5675 then
      _deb := 5675;
   if _BPos < _MaxB then
     begin
       move(_buffer[_BPos], _Buffer[0], _MaxB - _BPos);
       dec(_MaxB, _BPos);
     end
   else
      _MaxB := 0;
   _Bpos := 0;
   blockread(_F, _buffer[_MaxB], sizeof(_buffer) - _MaxB, nr);
   if ioresult <> 0 then
     nr := 0;
   inc(_MaxB, nr);
end;

function TFileIO.GetSize : integer;
begin
  Result := FileSize(_F);
end;


end.

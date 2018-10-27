unit Dbf_Memo;

interface

{$I Dbf_Common.inc}

uses
  Classes,
  Dbf_PgFile,
  Dbf_Common;

type

//====================================================================
//=== Memo and binary fields support
//====================================================================
  PDbtHdr = ^rDbtHdr;
  rDbtHdr = record
    NextBlock : Longint;
    Dummy     : array [4..7] of Byte;
    DbfFile   : array [0..7] of Byte;   // 8..15
    bVer      : Byte;                   // 16
    Dummy2    : array [17..19] of Byte;
    BlockLen  : Word;                   // 20..21
    Dummy3    : array [22..511] of Byte;
  end;

//====================================================================
  TDbtFile = class(TPagedFile)
  protected
    FDbfVersion: xBaseVersion;
    FMemoRecordSize: Integer;
    FOpened: Boolean;
    FBuffer: PChar;
  public
    constructor Create(AFileName: string);
    destructor Destroy; override;

    procedure Open;
    procedure Close;

    procedure ReadMemo(BlockNo: Integer; DestStream: TStream);
    procedure WriteMemo(var BlockNo: Integer; ReadSize: Integer; Src: TStream);

    property DbfVersion: xBaseVersion read FDbfVersion write FDbfVersion;
    property MemoRecordSize: Integer read FMemoRecordSize write FMemoRecordSize;
  end;

  PInteger = ^Integer;

implementation
//==========================================================
//============ Dbtfile
//==========================================================
constructor TDbtFile.Create(AFileName: string);
begin
  // init vars
  FBuffer := nil;
  FOpened := false;

  // call inherited
  inherited Create(AFileName);
end;

destructor TDbtFile.Destroy;
begin
  // close file
  Close;

  // call ancestor
  inherited;
end;

procedure TDbtFile.Open;
begin
  if not FOpened then
  begin
    // open physical file
    OpenFile;

    // read header
    HeaderSize := SizeOf(rDbtHdr);

    // determine version
    if FDbfVersion = xBaseIII then
      PDbtHdr(Header).bVer := 3;
    VirtualLocks := false;

    if FileCreated or (HeaderSize = 0) then
    begin
      PDbtHdr(Header).NextBlock := 1;
      PDbtHdr(Header).BlockLen := FMemoRecordSize;
      WriteHeader;
    end;

    // Can you tell me why the header of dbase3 memo contains 1024 and is 512 ?
    // answer: it is not a valid field in memo db3 header
    if FDbfVersion = xBaseIII then
      RecordSize := 512
    else
      RecordSize := PDbtHdr(Header).BlockLen;

    // mod 128 <> 0 <-> and 0x7F <> 0
    if (RecordSize = 0) or ((RecordSize and $7F) <> 0) then
    begin
      PDbtHdr(Header).BlockLen := 512;
      RecordSize := 512;
      WriteHeader;
    end;

    // get memory for temporary buffer
    GetMem(FBuffer, RecordSize+16);
    HeaderSize := RecordSize;

    // now open
    FOpened := true;
  end;
end;

procedure TDbtFile.Close;
begin
  if FOpened then
  begin
    // close physical file
    CloseFile;

    // free mem
    if FBuffer <> nil then
    begin
      FreeMem(FBuffer);
      FBuffer := nil;
    end;

    // now closed
    FOpened := false;
  end;
end;

procedure TDbtFile.ReadMemo(BlockNo: Integer; DestStream: TStream);
var
  i,bytesLeft,numBytes,dataStart: Integer;
  done: Boolean;
  lastc: char;
begin
  if (BlockNo=0) or (RecordSize=0) then
    exit;
  // clear dest
  DestStream.Position := 0;
  DestStream.Size := 0;
  // read first block
  if ReadRecord(BlockNo, @FBuffer[0]) = 0 then
  begin
    // EOF reached?
    exit;
  end;
  if PInteger(@FBuffer[0])^ = $0008FFFF then
  begin
    // dBase4 memofiles contain small 'header'
    bytesLeft := (PInteger(@FBuffer[4])^)-8;
    dataStart := 8;
    while bytesLeft > 0 do
    begin
      // get number of bytes to be read
      numBytes := bytesLeft;
      // too much for this block?
      if numBytes > RecordSize - dataStart then
        numBytes := RecordSize - dataStart;
      // read block to stream
      DestStream.Write(FBuffer[dataStart], numBytes);
      // numBytes done
      dec(bytesLeft, numBytes);
      // still need to read bytes?
      if bytesLeft > 0 then
      begin
        // read next block
        inc(BlockNo);
        dataStart := 0;
        ReadRecord(BlockNo, @FBuffer[0]);
      end;
    end;
  end else begin
    // dbase III memo
    done := false;
    repeat
      for i := 0 to RecordSize-2 do
      begin
        if (FBuffer[i]=#$1A) and (FBuffer[i+1]=#$1A) then
        begin
          if i>0 then
            DestStream.Write(FBuffer[0], i);
          done := true;
          break;
        end;
      end;
      if not done then
      begin
        DestStream.Write(FBuffer[0], 512);
        lastc := FBuffer[511];
        inc(BlockNo);
        ReadRecord(BlockNo, @FBuffer[0]);
        // check if immediate terminator at begin of block
        done := (lastc = #$1A) and (FBuffer[0] = #$1A);
        // if so, written one character too much
        if done then
          DestStream.Size := DestStream.Size - 1;
      end;
    until done;
  end;
  DestStream.Position := 0;
end;

procedure TDbtFile.WriteMemo(var BlockNo: Integer; ReadSize: Integer; Src: TStream);
var
  bytesBefore: Integer;
  bytesAfter: Integer;
  totsize: Integer;
  read: Integer;
  append: Boolean;
  tmpRecNo: Integer;
begin
  // if no data to write, then don't create new block
  if Src.Size = 0 then
  begin
    BlockNo := 0;
  end else begin
    if FDbfVersion >= xBaseIV then      // dBase4 type
    begin
      bytesBefore := 8;
      bytesAfter := 0;
    end else begin                      // dBase3 type
      bytesBefore := 0;
      bytesAfter := 2;
    end;
    if ((bytesBefore + Src.Size + bytesAfter + PDbtHdr(Header).BlockLen-1) div PDbtHdr(Header).BlockLen)
        <= ((ReadSize + PDbtHdr(Header).BlockLen-1) div PDbtHdr(Header).BlockLen) then
    begin
      append := false;
    end else begin
      append := true;
      // modifying header -> lock memo header
      LockPage(0, true);
      BlockNo := PDbtHdr(Header).NextBlock;
      if BlockNo = 0 then
      begin
        PDbtHdr(Header).NextBlock := 1;
        BlockNo := 1;
      end;
    end;
    tmpRecNo := BlockNo;
    Src.Position := 0;
    FillChar(FBuffer[0], RecordSize, ' ');
    if bytesBefore=8 then
    begin
      totsize := Src.Size + bytesBefore + bytesAfter;
      PInteger(@FBuffer[0])^ := $0008FFFF;
      PInteger(@FBuffer[4])^ := totsize;
    end;
    repeat
      read := Src.Read(FBuffer[bytesBefore], PDbtHdr(Header).BlockLen-bytesBefore);
      if read = 0 then
        break;
      Inc(PDbtHdr(Header).NextBlock);
      if read>=PDbtHdr(Header).BlockLen-bytesBefore-bytesAfter then
      begin
        bytesBefore := 0;
        read := 0;
        WriteRecord(tmpRecNo,@FBuffer[0]); {#LWL#}
        Inc(tmpRecNo);
      end else break;
      FillChar(FBuffer[0], RecordSize, ' ');
    until false;

    if bytesAfter=2 then
    begin
      FBuffer[read] := #$1A;
      FBuffer[read+1] := #$1A;
    end;
    WriteRecord(tmpRecNo,@FBuffer[0]);     {#LWL}
    if append then
    begin
      WriteHeader;
      UnlockPage(0);
    end;
  end;
end;

end.


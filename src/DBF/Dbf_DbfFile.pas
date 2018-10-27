unit Dbf_DbfFile;

interface

{$I Dbf_Common.inc}

uses
  Classes, SysUtils,
{$ifdef WIN32}
  Windows,
{$endif}
{$ifdef LINUX}
  Libc, Types, Dbf_Wtil,
{$endif}
  Db,
  Dbf_Common,
  Dbf_Parser,
  Dbf_Cursor,
  Dbf_PgFile,
  Dbf_Fields,
  Dbf_Memo,
  Dbf_IdxCur,
  Dbf_IdxFile;

//====================================================================
//=== Dbf support (first part)
//====================================================================
//  TxBaseVersion = (xUnknown,xClipper,xBaseIII,xBaseIV,xBaseV,xFoxPro,xVisualFoxPro);
//  TPagedFileMode = (pfOpen,pfCreate);
//  TDbfGetMode = (xFirst,xPrev,xCurrent, xNext, xLast);
//  TDbfGetResult = (xOK, xBOF, xEOF, xError);

type

//====================================================================
  TDbfIndexMissingEvent = procedure(var DeleteLink: Boolean) of object;

//====================================================================
  EDbfFile = class (Exception);
  EDbfFileError = class (Exception);
//====================================================================
  TDbfGlobals = class;
//====================================================================

  TDbfFile = class(TPagedFile)
  protected
    FMdxFile: TIndexFile;
    FDbtFile: TDbtFile;
    FFieldDefs: TDbfFieldDefs;
    FIndexNames: TStringList;
    FIndexFiles: TList;
    FDbfVersion: xBaseVersion;
    FPrevBuffer: PChar;
    FRecordBufferSize: Integer;
    FLockFieldOffset: Integer;
    FLockFieldLen: DWORD;
    FLockUserLen: DWORD;
    FCountUse: Integer;
    FCurIndex: Integer;
    FForceClose: Boolean;
    FHasLockField: Boolean;
    FAutoIncPresent: Boolean;
    FOpened: Boolean;
    FCopyDateTimeAsString: Boolean;
    FDateTimeHandling: TDateTimeHandling;
    FOnLocaleError: TDbfLocaleErrorEvent;
    FOnIndexMissing: TDbfIndexMissingEvent;

    procedure ConstructFieldDefs;
    function HasBlob: Boolean;
    procedure WriteLockInfo(Buffer: PChar);

    function GetLanguageId: Integer;
    function GetLanguageStr: string;
    function GetCodePage: Cardinal;
    function GetLocale: Cardinal;
    function GetUseFloatFields: Boolean;
    procedure SetUseFloatFields(NewUse: Boolean);
  public
    constructor Create(lFileName: string);
    destructor Destroy; override;

    procedure Open;
    procedure Close;
    procedure Zap;

    procedure FinishCreate(FieldDefs: TDbfFieldDefs; MemoExt: string; MemoSize: Integer);
    function GetIndexByName(AIndexName: string): TIndexFile;
    procedure SetRecordSize(NewSize: Integer); override;

    procedure TryExclusive; override;
    procedure EndExclusive; override;
    procedure OpenIndex(IndexName, IndexField: string; CreateIndex: Boolean; Options: TIndexOptions);
    function  DeleteIndex(const AIndexName: string): Boolean;
    procedure CloseIndex(AIndexName: string);
    procedure RepageIndex(AIndexFile: string);
    procedure Insert(Buffer: PChar);
    procedure WriteHeader; override;
    procedure ApplyAutoIncToBuffer(DestBuf: PChar);     // dBase7 support. Writeback last next-autoinc value
    procedure FastPackTable;
    procedure RestructureTable(DbfFieldDefs: TDbfFieldDefs; Pack: Boolean);
    function  GetFieldInfo(FieldName: string): TDbfFieldDef;
    function  GetFieldData(Column: Integer; DataType: TFieldType; Src,Dst: Pointer): Boolean;
    function  GetFieldDataFromDef(AFieldDef: TDbfFieldDef; DataType: TFieldType; Src, Dst: Pointer): Boolean;
    procedure SetFieldData(Column: Integer; DataType: TFieldType; Src,Dst: Pointer);
    procedure InitRecord(DestBuf: PChar);
    procedure PackIndex(lIndexFile: TIndexFile; AIndexName: string);
    procedure RegenerateIndexes;
    procedure LockRecord(RecNo: Integer; Buffer: PChar);
    procedure UnlockRecord(RecNo: Integer; Buffer: PChar);
    procedure RecordDeleted(RecNo: Integer; Buffer: PChar);
    procedure RecordRecalled(RecNo: Integer; Buffer: PChar);

    property DbtFile: TDbtFile read FDbtFile;
    property FieldDefs: TDbfFieldDefs read FFieldDefs;
    property IndexNames: TStringList read FIndexNames;
    property MdxFile: TIndexFile read FMdxFile;
    property LanguageId: Integer read GetLanguageId;
    property LanguageStr: string read GetLanguageStr;
    property CodePage: Cardinal read GetCodePage;
    property Locale: Cardinal read GetLocale;
    property DbfVersion: xBaseVersion read FDbfVersion write FDbfVersion;
    property PrevBuffer: PChar read FPrevBuffer;
    property ForceClose: Boolean read FForceClose;
    property HasLockField: Boolean read FHasLockField;
    property CopyDateTimeAsString: Boolean read FCopyDateTimeAsString write FCopyDateTimeAsString;
    property UseFloatFields: Boolean read GetUseFloatFields write SetUseFloatFields;
    property DateTimeHandling: TDateTimeHandling read FDateTimeHandling write FDateTimeHandling;

    property OnIndexMissing: TDbfIndexMissingEvent read FOnIndexMissing write FOnIndexMissing;
    property OnLocaleError: TDbfLocaleErrorEvent read FOnLocaleError write FOnLocaleError;
  end;

//====================================================================
  TDbfCursor = class(TVirtualCursor)
  protected
    FPhysicalRecNo: Integer;
  public
    constructor Create(DbfFile: TDbfFile);
    function Next: Boolean; override;
    function Prev: Boolean; override;
    procedure First; override;
    procedure Last; override;

    function GetPhysicalRecNo: Integer; override;
    procedure SetPhysicalRecNo(RecNo: Integer); override;

    function GetSequentialRecordCount: Integer; override;
    function GetSequentialRecNo: Integer; override;
    procedure SetSequentialRecNo(RecNo: Integer); override;

    procedure GotoBookmark(Bookmark: rBookmarkData); override;
    procedure Insert(RecNo: Integer; Buffer: PChar); override;
    procedure Update(RecNo: Integer; PrevBuffer,NewBuffer: PChar); override;
    function GetBookMark: rBookmarkData; override;
  end;

//====================================================================
  TDbfGlobals = class
  protected
    FCodePages: TList;
    FDefaultOpenCodePage: Integer;
    FDefaultCreateCodePage: Integer;
    FDefaultCreateLocale: LCID;
    FDefaultCreateFoxPro: Boolean;
    FUserName: array[0..MAX_PATH] of Char;
    FUserNameLen: DWORD;

    function GetUserName: PChar;
  public
    constructor Create;
    destructor Destroy; override;

    function CodePageInstalled(ACodePage: Integer): Boolean;

    property DefaultOpenCodePage: Integer read FDefaultOpenCodePage write FDefaultOpenCodePage;
    property DefaultCreateCodePage: Integer read FDefaultCreateCodePage write FDefaultCreateCodePage;
    property DefaultCreateLocale: LCID read FDefaultCreateLocale write FDefaultCreateLocale;
    property DefaultCreateFoxPro: Boolean read FDefaultCreateFoxPro;
    property UserName: PChar read GetUserName;
    property UserNameLen: DWORD read FUserNameLen;
  end;

// OH 2000-11-15 dBase7 support. Swap Byte order for 4 and 8 Byte Integer
function SwapInt(const Value: Integer): Integer;

{$ifdef DELPHI_4}
function SwapInt64(const Value: Int64): Int64;
{$endif}

var
  DbfGlobals: TDbfGlobals;

implementation

uses
{$ifdef WIN32}
  Consts,
{$else}
  RTLConsts,
{$endif}
  Dbf_Str, Dbf_Lang;

const
  sDBF_DEC_SEP = '.';

{$I Dbf_Struct.inc}

//====================================================================
// Utility routines
//====================================================================

function SwapInt(const Value: Integer): Integer;
begin
  PByteArray(@Result)[0] := PByteArray(@Value)[3];
  PByteArray(@Result)[1] := PByteArray(@Value)[2];
  PByteArray(@Result)[2] := PByteArray(@Value)[1];
  PByteArray(@Result)[3] := PByteArray(@Value)[0];
end;

{$ifdef DELPHI_4}
function SwapInt64(const Value: Int64): Int64;
var
  PtrResult: PByteArray;
  PtrSource: PByteArray;
begin
  // temporary storage is actually not needed, but otherwise compiler crashes (?)
  PtrResult := PByteArray(@Result);
  PtrSource := PByteArray(@Value);
  PtrResult[0] := PtrSource[7];
  PtrResult[1] := PtrSource[6];
  PtrResult[2] := PtrSource[5];
  PtrResult[3] := PtrSource[4];
  PtrResult[4] := PtrSource[3];
  PtrResult[5] := PtrSource[2];
  PtrResult[6] := PtrSource[1];
  PtrResult[7] := PtrSource[0];
end;
{$endif}
//====================================================================
// International separator
// thanks to Bruno Depero from Italy
// and Andreas Wöllenstein from Denmark
//====================================================================
function DbfStrToFloat(const Src: PChar; const Size: Integer): Extended;
var
  iPos: PChar;
  eValue: extended;
  endChar: Char;
begin
  // temp null-term string
  endChar := (Src + Size)^;
  (Src + Size)^ := #0;
  // we only have to convert if decimal separator different
  if DecimalSeparator <> sDBF_DEC_SEP then
  begin
    // search dec sep
    iPos := StrScan(Src, sDBF_DEC_SEP);
    // replace
    if iPos <> nil then
      iPos^ := DecimalSeparator;
  end else
    iPos := nil;
  // convert to double
  if TextToFloat(Src, eValue, fvExtended) then
    Result := eValue
  else
    Result := 0;
  // restore dec sep
  if iPos <> nil then
    iPos^ := sDBF_DEC_SEP;
  // restore Char of null-term
  (Src + Size)^ := endChar;
end;

procedure FloatToDbfStr(const Val: Extended; const Size, Precision: Integer; const Dest: PChar);
var
  Buffer: array [0..24] of Char;
  resLen: Integer;
  iPos: PChar;
begin
  // convert to temporary buffer
  resLen := FloatToText(@Buffer[0], Val, fvExtended, ffFixed, Size, Precision);
  // null-terminate buffer
  Buffer[resLen] := #0;
  // we only have to convert if decimal separator different
  if DecimalSeparator <> sDBF_DEC_SEP then
  begin
    iPos := StrScan(@Buffer[0], DecimalSeparator);
    if iPos <> nil then
      iPos^ := sDBF_DEC_SEP;
  end;
  // fill destination with spaces
  FillChar(Dest^, Size, ' ');
  // now copy right-aligned to destination
  Move(Buffer[0], Dest[Size-resLen], resLen);
end;

function GetIntFromStrLength(Src: Pointer; Size: Integer; Default: Integer): Integer;
var
  endChar: Char;
  Code: Integer;
begin
  // save Char at pos term. null
  endChar := (PChar(Src) + Size)^;
  (PChar(Src) + Size)^ := #0;
  // convert
  Val(PChar(Src), Result, Code);
  // check success
  if Code <> 0 then
    Result := Default;
  // restore prev. ending Char
  (PChar(Src) + Size)^ := endChar;
end;

//====================================================================
// TDbfFile
//====================================================================
constructor TDbfFile.Create(lFileName: string);
begin
  // init variables first
  FFieldDefs := TDbfFieldDefs.Create(nil);
  FIndexNames := TStringList.Create;
  FIndexFiles := TList.Create;
  FOnLocaleError := nil;
  FOnIndexMissing := nil;
  FMdxFile := nil;
  FForceClose := false;
  FOpened := false;
  FCopyDateTimeAsString := false;

  // pass on parameters
  inherited Create(lFileName);
end;

destructor TDbfFile.Destroy;
begin
  // close file
  Close;

  // free lists
  FreeAndNil(FIndexFiles);
  FreeAndNil(FIndexNames);
  FreeAndNil(FFieldDefs);

  // call ancestor
  inherited;
end;

function TDbfFile.GetUseFloatFields: Boolean;
begin
  Result := FFieldDefs.UseFloatFields;
end;

procedure TDbfFile.SetUseFloatFields(NewUse: Boolean);
begin
  FFieldDefs.UseFloatFields := NewUse;
end;

procedure TDbfFile.Open;
var
  lMemoFileName: string;
  lMdxFileName: string;
  I: Integer;
  deleteLink: Boolean;
begin
  // check if not already opened
  if not FOpened then
  begin
    // open requested file
    OpenFile;

    // check if we opened an already existing file
    if not FileCreated then
    begin
      HeaderSize := sizeof(rDbfHdr); // temporary
      // OH 2000-11-15 dBase7 support. I build dBase Tables with different
      // BDE dBase Level (1. without Memo, 2. with Memo)
      //                          Header Byte ($1d hex) (29 dec) -> Language driver ID.
      //  $03,$83 xBaseIII        Header Byte $1d=$00, Float -> N($13.$04) DateTime C($1E)
      //  $03,$8B xBaseIV/V       Header Byte $1d=$58, Float -> N($14.$04)
      //  $04,$8C xBaseVII        Header Byte $1d=$00  Float -> O($08)     DateTime @($08)
      //  $03,$F5 FoxPro Level 25 Header Byte $1d=$03, Float -> N($14.$04)
      // Access 97
      //  $03,$83 dBaseIII        Header Byte $1d=$00, Float -> N($13.$05) DateTime D($08)
      //  $03,$8B dBaseIV/V       Header Byte $1d=$00, Float -> N($14.$05) DateTime D($08)
      //  $03,$F5 FoxPro Level 25 Header Byte $1d=$09, Float -> N($14.$05) DateTime D($08)

      case (PDbfHdr(Header).VerDBF and $07) of
        $03:
          if PDbfHdr(Header).Language = 0 then
            FDbfVersion := xBaseIII
          else
            FDbfVersion := xBaseIV;
        $04:
          FDbfVersion := xBaseVII;
      else
        case PDbfHdr(Header).VerDBF of
          $30:
            FDbfVersion := xVisualFoxPro;
          $F5:
            FDbfVersion := xFoxPro;
        else
          // not a valid DBF file
          raise EDbfError.Create(STRING_INVALID_DBF_FILE);
        end;
      end;
      FFieldDefs.DbfVersion := FDbfVersion;
      RecordSize := PDbfHdr(Header).RecordSize;
      HeaderSize := PDbfHdr(Header).FullHdrSize;
      if (HeaderSize = 0) or (RecordSize = 0) then
      begin
        HeaderSize := 0;
        RecordSize := 0;
        RecordCount := 0;
        FForceClose := true;
        exit;
      end;
      // check if specified recordcount correct
      if PDbfHdr(Header).RecordCount <> RecordCount then
      begin
        // This message was annoying
        // and was not understood by most people
        // ShowMessage('Invalid Record Count,'+^M+
        //             'RecordCount in Hdr : '+IntToStr(PDbfHdr(Header).RecordCount)+^M+
        //             'expected : '+IntToStr(RecordCount));
        PDbfHdr(Header).RecordCount := RecordCount;
        WriteHeader;        // Correct it
      end;
      // get list of fields
      ConstructFieldDefs;
      // open blob file if present
      lMemoFileName := ChangeFileExt(FileName,'.dbt');
      if HasBlob then
      begin
        // open blob file
        FDbtFile := TDbtFile.Create(lMemoFileName);
        FDbtFile.Mode := Mode;
        FDbtFile.AutoCreate := false;
        FDbtFile.MemoRecordSize := 0;
        FDbtFile.DbfVersion := FDbfVersion;
        FDbtFile.Open;
        // set header blob flag corresponding to field list
        PDbfHdr(Header).VerDBF := PDbfHdr(Header).VerDBF or $80;
      end else
        PDbfHdr(Header).VerDBF := PDbfHdr(Header).VerDBF and $7F;
      // check if mdx flagged
      if PDbfHdr(Header).MDXFlag <> 0 then
      begin
        // open mdx file if present
        lMdxFileName := ChangeFileExt(FileName, '.mdx');
        if FileExists(lMdxFileName) then
        begin
          // open file
          FMdxFile := TIndexFile.Create(Self, lMdxFileName);
          FMdxFile.Mode := Mode;
          FMdxFile.AutoCreate := false;
          FMdxFile.OnLocaleError := FOnLocaleError;
          FMdxFile.Open;
          // is index ready for use?
          if not FMdxFile.ForceClose then
          begin
            FIndexFiles.Add(FMdxFile);
            // get index tag names known
            FMdxFile.GetIndexNames(FIndexNames);
            for I := 0 to FIndexNames.Count - 1 do
              FIndexNames.Objects[I] := FMdxFile;
          end else begin
            // asked to close! close file
            FMdxFile.Free;
            FMdxFile := nil;
          end;
        end else begin
          // ask user
          deleteLink := true;
          if Assigned(FOnIndexMissing) then
            FOnIndexMissing(deleteLink);
          // correct flag
          if deleteLink then
            PDbfHdr(Header).MDXFlag := 0
          else
            FForceClose := true;
        end;
      end;
    end;

    // now opened
    FOpened := true;
  end;
end;

procedure TDbfFile.Close;
begin
  if FOpened then
  begin
    // free, close index files first
    while FIndexFiles.Count > 0 do
    begin
      TIndexFile(FIndexFiles.Last).Free;
      FIndexFiles.Delete(FIndexFiles.Count - 1);
    end;
    // free memo file if any
    FreeAndNil(FDbtFile);

    // now we can close physical dbf file
    CloseFile;

    // FMdxFile was in the FIndexFiles list, so already freed
    FMdxFile := nil;
    if FPrevBuffer <> nil then
    begin
      FreeMem(FPrevBuffer);
      FPrevBuffer := nil;
    end;

    // flag closed
    FOpened := false;
  end;
end;

procedure TDbfFile.FinishCreate(FieldDefs: TDbfFieldDefs; MemoExt: string; MemoSize: Integer);
var
  lFieldDescIII: rFieldDescIII;
  lFieldDescVII: rFieldDescVII;
  lFieldDescPtr: Pointer;
  lFieldDef: TDbfFieldDef;
  lMemoFileName: string;
  I, lFieldOffset: Integer;
  lHasBlob: Boolean;
begin
  try
    // first reset file
    RecordCount := 0;
    lHasBlob := false;
    // prepare header size
    if FDbfVersion = xBaseVII then
    begin
      // version xBaseVII without memo
      HeaderSize := SizeOf(rDbfHdr) + SizeOf(rAfterHdrVII);
      RecordSize := SizeOf(rFieldDescVII);
      FillChar(Header^, HeaderSize, #0);
      PDbfHdr(Header).VerDBF := $04;
      // write language string
      StrPLCopy(
        @PAfterHdrVII(PChar(Header)+SizeOf(rDbfHdr)).LanguageDriverName[32],
        ConstructLangName(
          DbfGlobals.DefaultCreateCodePage,
          DbfGlobals.DefaultCreateLocale,
          DbfGlobals.DefaultCreateFoxPro),
        63-32);
      lFieldDescPtr := @lFieldDescVII;
    end else begin
      // version xBaseIII/IV/V without memo
      HeaderSize := SizeOf(rDbfHdr) + SizeOf(rAfterHdrIII);
      RecordSize := SizeOf(rFieldDescIII);
      FillChar(Header^, HeaderSize, #0);
      PDbfHdr(Header).VerDBF := $03;
      // standard language WE, dBase III no language support
      if FDbfVersion = xBaseIII then
        PDbfHdr(Header).Language := 0
      else
        PDbfHdr(Header).Language := ConstructLangId(
          DbfGlobals.DefaultCreateCodePage,
          DbfGlobals.DefaultCreateLocale,
          DbfGlobals.DefaultCreateFoxPro);
      // init field ptr
      lFieldDescPtr := @lFieldDescIII;
    end;
    // begin writing fields
    FFieldDefs.Clear;
    // deleted mark 1 byte
    lFieldOffset := 1;
    for I := 1 to FieldDefs.Count do
    begin
      lFieldDef := FieldDefs.Items[I-1];

      // check if datetime conversion
      if FCopyDateTimeAsString then
        if lFieldDef.FieldType = ftDateTime then
        begin
          // convert to string
          lFieldDef.FieldType := ftString;
          lFieldDef.Size := 22;
        end;

      // update source
      lFieldDef.FieldName := UpperCase(lFieldDef.FieldName);
      lFieldDef.Offset := lFieldOffset;
      lFieldDef.CalcValueOffset;
      lHasBlob := lHasBlob or lFieldDef.IsBlob;

      // update temp field props
      if FDbfVersion = xBaseVII then
      begin
        FillChar(lFieldDescVII, SizeOf(lFieldDescVII), #0);
        StrPLCopy(lFieldDescVII.FieldName, lFieldDef.FieldName, SizeOf(lFieldDescVII.FieldName)-1);
        lFieldDescVII.FieldType := lFieldDef.NativeFieldType;
        lFieldDescVII.FieldSize := lFieldDef.Size;
        lFieldDescVII.FieldPrecision := lFieldDef.Precision;
      end else begin
        FillChar(lFieldDescIII, SizeOf(lFieldDescIII), #0);
        StrPLCopy(lFieldDescIII.FieldName, lFieldDef.FieldName, SizeOf(lFieldDescIII.FieldName)-1);
        lFieldDescIII.FieldType := lFieldDef.NativeFieldType;
        lFieldDescIII.FieldSize := lFieldDef.Size;
        lFieldDescIII.FieldPrecision := lFieldDef.Precision;
        if not (lFieldDescIII.FieldType in ['C', 'F', 'N', 'D', 'L', 'M']) then
          raise EDbfError.CreateFmt(STRING_INVALID_FIELD_TYPE,
            [lFieldDef.FieldName, lFieldDescIII.FieldType]);
      end;

      // update our field list
      with FFieldDefs.AddFieldDef do
      begin
        Assign(lFieldDef);
        Offset := lFieldOffset;
        AutoInc := 0;
        CalcValueOffset;
      end;

      // save field props
      WriteRecord(I, lFieldDescPtr);
      Inc(lFieldOffset, lFieldDef.Size);
    end;
    // end of header
    WriteChar($0D);

    // write memo bit
    if lHasBlob then
      if FDbfVersion = xBaseIII then
        PDbfHdr(Header).VerDBF := PDbfHdr(Header).VerDBF or $80
      else
        PDbfHdr(Header).VerDBF := PDbfHdr(Header).VerDBF or $88;

    // update header
    PDbfHdr(Header).RecordSize := lFieldOffset;
    PDbfHdr(Header).FullHdrSize := HeaderSize + RecordSize * FieldDefs.Count + 1;

    // write dbf header to disk
    inherited WriteHeader;
  finally
    RecordSize := PDbfHdr(Header).RecordSize;
    HeaderSize := PDbfHdr(Header).FullHdrSize;

    // write full header to disk (dbf+fields)
    WriteHeader;
  end;

  if HasBlob and (FDbtFile=nil) then
  begin
    lMemoFileName := ChangeFileExt(FileName, MemoExt); // usually '.dbt' except for packtable
    FDbtFile := TDbtFile.Create(lMemoFileName);
    FDbtFile.Mode := Mode;
    FDbtFile.AutoCreate := AutoCreate;
    FDbtFile.MemoRecordSize := MemoSize;
    FDbtFile.DbfVersion := FDbfVersion;
    FDbtFile.Open;
  end;
end;

function TDbfFile.HasBlob: Boolean;
var
  I: Integer;
  HasBlob: Boolean;
begin
  HasBlob := false;
  for I := 0 to FFieldDefs.Count-1 do
  begin
    if FFieldDefs.Items[I].IsBlob then HasBlob := true;
  end;
  Result := HasBlob;
end;

procedure TDbfFile.Zap;
begin
  // make recordcount zero
  RecordCount := 0;
  // update recordcount
  PDbfHdr(Header).RecordCount := RecordCount;
  // update disk header
  WriteHeader;
  // update indexes
  RegenerateIndexes;
end;

procedure TDbfFile.WriteHeader;
var
  SystemTime: TSystemTime;
  lDataHdr: PDbfHdr;
begin
  if (HeaderSize=0) then
    exit;

  //FillHeader(0);
  lDataHdr := PDbfHdr(Header);
  GetLocalTime(SystemTime);
  lDataHdr.Year := SystemTime.wYear - 1900;
  lDataHdr.Month := SystemTime.wMonth;
  lDataHdr.Day := SystemTime.wDay;
//  lDataHdr.RecordCount := RecordCount;
  inherited WriteHeader;

  SeekPage(RecordCount+1);  // last byte usually...
  WriteChar($1A);           // terminator...
end;

procedure TDbfFile.ConstructFieldDefs;
var
  {lColumnCount,}lHeaderSize,lFieldSize: Integer;
  lPropHdrOffset, lFieldOffset: Integer;
  lFieldDescIII: rFieldDescIII;
  lFieldDescVII: rFieldDescVII;
  lFieldPropsHdr: rFieldPropsHdr;
  lStdProp: rStdPropEntry;
  TempFieldDef: TDbfFieldDef;
  lSize,lPrec,I, lColumnCount: Integer;
  lAutoInc: Cardinal;
  dataPtr: PChar;
  lNativeFieldType: Char;
  lFieldName: string;
begin
  FFieldDefs.Clear;
  if DbfVersion >= xBaseVII then
  begin
    lHeaderSize := SizeOf(rAfterHdrVII) + SizeOf(rDbfHdr);
    lFieldSize := SizeOf(rFieldDescVII);
  end else begin
    lHeaderSize := SizeOf(rAfterHdrIII) + SizeOf(rDbfHdr);
    lFieldSize := SizeOf(rFieldDescIII);
  end;
  HeaderSize := lHeaderSize;
  RecordSize := lFieldSize;

  FHasLockField := false;
  FAutoIncPresent := false;
  lColumnCount := (PDbfHdr(Header).FullHdrSize - lHeaderSize) div lFieldSize;
  lFieldOffset := 1;
  lAutoInc := 0;
  I := 1;
  try
    // there has to be minimum of one field
    repeat
      // version field info?
      if FDbfVersion >= xBaseVII then
      begin
        ReadRecord(I, @lFieldDescVII);
        lFieldName := UpperCase(PChar(@lFieldDescVII.FieldName[0]));
        lSize := lFieldDescVII.FieldSize;
        lPrec := lFieldDescVII.FieldPrecision;
        lNativeFieldType := lFieldDescVII.FieldType;
        lAutoInc := lFieldDescVII.NextAutoInc;
        if lNativeFieldType = '+' then
          FAutoIncPresent := true;
      end else begin
        ReadRecord(I, @lFieldDescIII);
        lFieldName := UpperCase(PChar(@lFieldDescIII.FieldName[0]));
        lSize := lFieldDescIII.FieldSize;
        lPrec := lFieldDescIII.FieldPrecision;
        lNativeFieldType := lFieldDescIII.FieldType;
      end;

      // add field
      with FFieldDefs.AddFieldDef do
      begin
        FieldName := lFieldName;
        Offset := lFieldOffset;
        Size := lSize;
        Precision := lPrec;
        AutoInc := lAutoInc;
        NativeFieldType := lNativeFieldType;
        CalcValueOffset;

        // check valid field:
        //  1) non-empty field name
        //  2) known field type
        //  {3) no changes have to be made to precision or size}
        if (Length(lFieldName) = 0) or (FieldType = ftUnknown) then
          raise EDbfError.Create(STRING_INVALID_DBF_FILE);

        // determine if lock field present
        IsLockField := lFieldName = '_DBASELOCK';
        // if present, then store additional info
        if IsLockField then
        begin
          FHasLockField := true;
          FLockFieldOffset := lFieldOffset;
          FLockFieldLen := lSize;
          FLockUserLen := FLockFieldLen - 8;
          if FLockUserLen > DbfGlobals.UserNameLen then
            FLockUserLen := DbfGlobals.UserNameLen;
        end;
      end;

      // goto next field
      Inc(lFieldOffset, lSize);
      Inc(I);

      // continue until header termination character found
      // or end of header reached
    until (I > lColumnCount) or (ReadChar = $0D);

    // test if not too many fields
    if FFieldDefs.Count >= 4096 then
      raise EDbfError.CreateFmt(STRING_INVALID_FIELD_COUNT, [FFieldDefs.Count]);

{
    // removed check because additional data could be present in record

    if (lFieldOffset <> PDbfHdr(Header).RecordSize) then
    begin
      // I removed the message because it confuses end-users.
      // Though there is a major problem if the value is wrong...
      // I try to fix it but it is likely to crash
      PDbfHdr(Header).RecordSize := lFieldOffset;
    end;
}

    // get current position
    lPropHdrOffset := Stream.Position;

    // dBase 7 -> read field properties, test if enough space, maybe no header
    if (FDbfVersion = xBaseVII) and (lPropHdrOffset + Sizeof(lFieldPropsHdr) <
            PDbfHdr(Header).FullHdrSize) then
    begin
      // read in field properties header
      ReadBlock(@lFieldPropsHdr, SizeOf(lFieldPropsHdr), lPropHdrOffset);
      // read in standard properties
      lFieldOffset := lPropHdrOffset + lFieldPropsHdr.StartStdProps;
      for I := 0 to lFieldPropsHdr.NumStdProps - 1 do
      begin
        // read property data
        ReadBlock(@lStdProp, SizeOf(lStdProp), lFieldOffset+I*SizeOf(lStdProp));
        // is this a constraint?
        if lStdProp.FieldOffset = 0 then
        begin
          // this is a constraint...not implemented
        end else if lStdProp.FieldOffset <= FFieldDefs.Count then begin
          // get fielddef for this property
          TempFieldDef := FFieldDefs.Items[lStdProp.FieldOffset-1];
          // allocate space to store data
          TempFieldDef.AllocBuffers;
          // dataPtr = nil -> no data to retrieve
          dataPtr := nil;
          // store data
          case lStdProp.PropType of
            FieldPropType_Required: TempFieldDef.Required := true;
            FieldPropType_Default:
              begin
                dataPtr := TempFieldDef.DefaultBuf;
                TempFieldDef.HasDefault := true;
              end;
            FieldPropType_Min:
              begin
                dataPtr := TempFieldDef.MinBuf;
                TempFieldDef.HasMin := true;
              end;
            FieldPropType_Max:
              begin
                dataPtr := TempFieldDef.MaxBuf;
                TempFieldDef.HasMax := true;
              end;
          end;
          // get data for this property
          if dataPtr <> nil then
            ReadBlock(dataPtr, lStdProp.DataSize, lPropHdrOffset + lStdProp.DataOffset);
        end;
      end;
      // read custom properties...not implemented
      // read RI properties...not implemented
    end;

  finally
    HeaderSize := PDbfHdr(Header).FullHdrSize;
    RecordSize := PDbfHdr(Header).RecordSize;
  end;
end;

function TDbfFile.GetLanguageId: Integer;
begin
  Result := PDbfHdr(Header).Language;
end;

function TDbfFile.GetLanguageStr: String;
begin
  if FDbfVersion >= xBaseVII then
    Result := PAfterHdrVII(PChar(Header) + SizeOf(rDbfHdr)).LanguageDriverName;
end;

function TDbfFile.GetCodePage: Cardinal;
var
  LangStr: PChar;
begin
  if FDbfVersion >= xBaseVII then
  begin
    // cache language str
    LangStr := @PAfterHdrVII(PChar(Header) + SizeOf(rDbfHdr)).LanguageDriverName;
    // VdBase 7 Language strings
    //  'DBWIN...' -> Charset 1252 (ansi)
    //  'DB999...' -> Code page 999, 9 any digit
    //  'DBHEBREW' -> Code page 1255 ??
    //  'FOX..999' -> Code page 999, 9 any digit
    //  'FOX..WIN' -> Charset 1252 (ansi)
    if (LangStr[0] = 'D') and (LangStr[1] = 'B') then
      if StrLComp(LangStr+2, 'WIN', 3) = 0 then
        Result := 1252
      else
      if StrLComp(LangStr+2, 'HEBREW', 6) = 0 then
        Result := 1255
      else
        Result := GetIntFromStrLength(LangStr+2, 3, 0)
    else
    if StrLComp(LangStr, 'FOX', 3) = 0 then
      if StrLComp(LangStr+5, 'WIN', 3) = 0 then
        Result := 1252
      else
        Result := GetIntFromStrLength(LangStr+5, 3, 0)
    else
      Result := 0;
  end else begin
    // FDbfVersion <= xBaseV
    Result := LangId_To_CodePage[PDbfHdr(Header).Language];
  end;
end;

function TDbfFile.GetLocale: Cardinal;
begin
  Result := 0;
end;

{
  I fill the holes with the last records.
  now we can do an 'in-place' pack
}
procedure TDbfFile.FastPackTable;
var
  iDel,iNormal: Integer;
  pDel,pNormal: PChar;

  function FindFirstDel: Boolean;
  begin
    while iDel<=iNormal do
    begin
      ReadRecord(iDel, pDel);
      if (PChar(pDel)^ <> ' ') then
      begin
        Result := true;
        exit;
      end;
      Inc(iDel);
    end;
    Result := false;
  end;

  function FindLastNormal: Boolean;
  begin
    while iNormal>=iDel do
    begin
      ReadRecord(iNormal, pNormal);
      if (PChar(pNormal)^= ' ') then
      begin
        Result := true;
        exit;
      end;
      dec(iNormal);
    end;
    Result := false;
  end;

begin
  if RecordSize < 1 then Exit;

  GetMem(pNormal, RecordSize);
  GetMem(pDel, RecordSize);
  try
    iDel := 1;
    iNormal := RecordCount;

    while FindFirstDel do
    begin
      // iDel is definitely deleted
      if FindLastNormal then
      begin
        // but is not anymore
        WriteRecord(iDel, pNormal);
        PChar(pNormal)^ := '*';
        WriteRecord(iNormal, pNormal);
      end else begin
        // Cannot found a record after iDel so iDel must be deleted
        dec(iDel);
        break;
      end;
    end;
    // FindFirstDel failed means than iDel is full
    RecordCount := iDel;
    RegenerateIndexes;
    // Pack Memofields
  finally
    FreeMem(pNormal);
    FreeMem(pDel);
  end;
end;

procedure TDbfFile.RestructureTable(DbfFieldDefs: TDbfFieldDefs; Pack: Boolean);
var
  pbfFile: TDbfFile;
  DestFieldDefs: TDbfFieldDefs;
  TempDstDef, TempSrcDef: TDbfFieldDef;
  DbfFileName,DbtFileName: string;
  pbfFileName,pbtFileName: string;
  obfFileName,obtFileName: string;
  lRecNo, lFieldNo, lFieldSize, lBlobRecNo, lWRecNo: Integer;
  pBuff, pDestBuff: PChar;
  pBlobRecNoBuff: array[1..11] of Char;
  BlobStream: TMemoryStream;
begin
  // nothing to do?
  if (RecordSize < 1) or ((DbfFieldDefs = nil) and not Pack) then
    exit;

  // if no exclusive access, terrible things can happen!
  CheckExclusiveAccess;

  // make up some temporary filenames
  DbfFileName := FileName;
  DbtFileName := ChangeFileExt(FileName, '.dbt');
  pbfFileName := ChangeFileExt(FileName, '.pbf');
  pbtFileName := ChangeFileExt(FileName, '.pbt');
  obfFileName := ChangeFileExt(FileName, '.obf');
  obtFileName := ChangeFileExt(FileName, '.obt');

  // select final field definition list
  if DbfFieldDefs = nil then
    DestFieldDefs := FFieldDefs
  else
    DestFieldDefs := DbfFieldDefs;

  // create temporary dbf
  pbfFile := TDbfFile.Create(pbfFileName);
  pbfFile.AutoCreate := true;
  pbfFile.Mode := pfExclusiveCreate;
  pbfFile.UseFloatFields := UseFloatFields;
  pbfFile.OnIndexMissing := FOnIndexMissing;
  pbfFile.OnLocaleError := FOnLocaleError;
  pbfFile.DbfVersion := FDbfVersion;
  pbfFile.Open;
  // create dbf header
  if FDbtFile <> nil then
    pbfFile.FinishCreate(DestFieldDefs, '.pbt', FDbtFile.RecordSize)
  else
    pbfFile.FinishCreate(DestFieldDefs, '.pbt', 512);

  // get memory for record buffers
  GetMem(pBuff, RecordSize);
  BlobStream := TMemoryStream.Create;
  // if restructure, we need memory for dest buffer, otherwise use source
  if DbfFieldDefs = nil then
    pDestBuff := pBuff
  else
    GetMem(pDestBuff, pbfFile.RecordSize);

  // let the games begin!
  try
{$ifdef USE_CACHE}
    BufferAhead := true;
    pbfFile.BufferAhead := true;
{$endif}
    lRecNo := 1;
    lWRecNo := 1;
    while lRecNo <= RecordCount do
    begin
      // read record from original dbf
      ReadRecord(lRecNo, pBuff);
      // copy record?
      if (pBuff^ <> '*') or not Pack then
      begin
        // if restructure, initialize dest
        if DbfFieldDefs <> nil then
          pbfFile.InitRecord(pDestBuff);

        if (DbfFieldDefs <> nil) or (FDbtFile <> nil) then
        begin
          // copy fields
          for lFieldNo := 0 to DestFieldDefs.Count-1 do
          begin
            TempDstDef := DestFieldDefs.Items[lFieldNo];
            // handle blob fields differently
            // don't try to copy new blob fields!
            // DbfFieldDefs = nil -> pack only
            // TempDstDef.CopyFrom >= 0 -> copy existing (blob) field
            if TempDstDef.IsBlob and ((DbfFieldDefs = nil) or (TempDstDef.CopyFrom >= 0)) then
            begin
              // get current blob blockno
              GetFieldData(lFieldNo, ftString, pBuff, @pBlobRecNoBuff[1]);
              lBlobRecNo := StrToIntDef(pBlobRecNoBuff, -1);
              // valid blockno read?
              if lBlobRecNo >= 0 then
              begin
                BlobStream.Clear;
                FDbtFile.ReadMemo(lBlobRecNo, BlobStream);
                BlobStream.Position := 0;
                // always append
                pbfFile.FDbtFile.WriteMemo(lBlobRecNo, 0, BlobStream);
              end;
              // write new blockno
              pbfFile.SetFieldData(lFieldNo, ftInteger, @lBlobRecNo, pDestBuff);
            end else if (DbfFieldDefs <> nil) and (TempDstDef.CopyFrom >= 0) then
            begin
              // restructure and copy field, get src fielddef
              // DbfFieldDefs <> nil -> DestFieldDefs = DbfFieldDefs
              TempSrcDef := FFieldDefs.Items[TempDstDef.CopyFrom];
              // get size
              lFieldSize := TempSrcDef.Size;
              if lFieldSize > TempDstDef.Size then
                lFieldSize := TempDstDef.Size;
              // copy content of field
              Move(pBuff[TempSrcDef.Offset], pDestBuff[TempDstDef.Offset], lFieldSize);
            end;
          end;
        end;

        // write record
        pbfFile.WriteRecord(lWRecNo, pDestBuff);
        Inc(lWRecNo);
      end;
      Inc(lRecNo);
    end;

{$ifdef USE_CACHE}
    BufferAhead := false;
    pbfFile.BufferAhead := false;
{$endif}

    // close temp file
    FreeAndNil(pbfFile);
    // close dbf
    Close;
    // close memo
    if FDbtFile <> nil then
      FDbtFile.Close;

    // delete the previous backup files if exists
    SysUtils.DeleteFile(obfFileName);
    SysUtils.DeleteFile(obtFileName);

    // rename the old files
    SysUtils.RenameFile(dbfFileName, obfFileName);
    SysUtils.RenameFile(DbtFileName, obtFileName);
    // rename the new files
    SysUtils.RenameFile(pbfFileName, dbfFileName);
    SysUtils.RenameFile(pbtFileName, DbtFileName);

    // if everything worked, delete the backup files again
//    SysUtils.DeleteFile(obfFileName);
//    SysUtils.DeleteFile(obtFileName);

    // we have to reinit fielddefs if restructured
    Open;
    if FDbtFile <> nil then
      FDbtFile.Open;

    // crop deleted records
    RecordCount := lWRecNo - 1;
    // update date/time stamp, recordcount
    PDbfHdr(Header).RecordCount := RecordCount;
    WriteHeader;
  finally
    // close temporary file
    FreeAndNil(pbfFile);
    // free mem
    FreeMem(pBuff);
    FreeAndNil(BlobStream);
    if DbfFieldDefs <> nil then
      FreeMem(pDestBuff);
  end;
end;

procedure TDbfFile.RegenerateIndexes;
var
  lIndexNo: Integer;
begin
  // recreate every index in every file
  for lIndexNo := 0 to FIndexFiles.Count-1 do
  begin
    PackIndex(TIndexFile(FIndexFiles.Items[lIndexNo]), EmptyStr);
  end;
end;

function TDbfFile.GetFieldInfo(FieldName: string): TDbfFieldDef;
var
  I: Integer;
  lfi: TDbfFieldDef;
begin
  FieldName := UpperCase(FieldName);
  for I := 0 to FFieldDefs.Count-1 do
  begin
    lfi := TDbfFieldDef(FFieldDefs.Items[I]);
    if lfi.fieldName = FieldName then
    begin
      Result := lfi;
      exit;
    end;
  end;
  Result := nil;
end;

function TDbfFile.GetFieldData(Column: Integer; DataType: TFieldType; Src, Dst: Pointer): Boolean;
var
  TempFieldDef: TDbfFieldDef;
begin
  TempFieldDef := TDbfFieldDef(FFieldDefs.Items[Column]);
  Result := GetFieldDataFromDef(TempFieldDef, DataType, Src, Dst);
end;

function TDbfFile.GetFieldDataFromDef(AFieldDef: TDbfFieldDef; DataType: TFieldType; Src, Dst: Pointer): Boolean;
var
  FieldOffset, FieldSize: Integer;
//  s: string;
  ldd, ldm, ldy, lth, ltm, lts: Integer;
  date: TDateTime;

{$ifdef DELPHI_4}
  function GetInt64FromStrLength(Src: Pointer; Size: Integer; Default: Int64): Int64;
  var
    endChar: Char;
    Code: Integer;
  begin
    // save Char at pos term. null
    endChar := (PChar(Src) + Size)^;
    (PChar(Src) + Size)^ := #0;
    // convert
    Val(PChar(Src), Result, Code);
    // check success
    if Code <> 0 then Result := Default;
    // restore prev. ending Char
    (PChar(Src) + Size)^ := endChar;
  end;
{$endif}

  procedure CorrectYear(var wYear: Integer);
  var wD, wM, wY, CenturyBase: Word;

{$ifndef DELPHI_5}
  // Delphi 3 standard-behavior no change possible
  const TwoDigitYearCenturyWindow= 0;
{$endif}

  begin
     if wYear >= 100 then
       Exit;
     DecodeDate(Date, wY, wm, wD);
     // use Delphi-Date-Window
     CenturyBase := wY{must be CurrentYear} - TwoDigitYearCenturyWindow;
     Inc(wYear, CenturyBase div 100 * 100);
     if (TwoDigitYearCenturyWindow > 0) and (wYear < CenturyBase) then
        Inc(wYear, 100);
  end;

begin
// test if non-nil source
  if Src <> nil then
  begin
    FieldOffset := AFieldDef.Offset;
    FieldSize := AFieldDef.Size;
  // OH 2000-11-15 dBase7 support. Read values for new fieldtypes
    Src := PChar(Src) + FieldOffset;
    case AFieldDef.NativeFieldType of
      '+', 'I':
        begin
          PInteger(Dst)^ := SwapInt(PInteger(Src)^);
          Result := PDWord(Dst)^ <> 0;
          if Result then
            PInteger(Dst)^ := Integer(PDWord(Dst)^ - $80000000);
        end;
      'O':
        begin
{$ifdef DELPHI_4}
          Result := (PInt64(Src)^ <> 0);
          if Result then
          begin
            PInt64(Dst)^ := SwapInt64(PInt64(Src)^);
            if PInt64(Dst)^ > 0 then
              PInt64(Dst)^ := not PInt64(Dst)^
            else
              PDouble(Dst)^ := PDouble(Dst)^ * -1;
          end;
{$endif}
        end;
      '@':
        begin
{$ifdef DELPHI_4}
          Result := (PInt64(Src)^ <> 0);
          if Result then
          begin
            PInt64(Dst)^ := SwapInt64(PInt64(Src)^);
            if FDateTimeHandling = dtBDETimeStamp then
            begin
              // convert bde time stamp to datetime
              PDouble(Dst)^ := BDETimeStampToDateTime(PDouble(Dst)^);
            end;
          end;
{$endif}
        end;
    else
      //    SetString(s, PChar(Src) + FieldOffset, FieldSize );
      //    s := {TrimStr(s)} TrimRight(s);
      // truncate spaces at end by shortening fieldsize
      while (FieldSize > 0) and ((PChar(Src) + FieldSize - 1)^ = ' ') do
        dec(FieldSize);
      // if not string field, truncate spaces at beginning too
      if DataType <> ftString then
        while (FieldSize > 0) and (PChar(Src)^ = ' ') do
        begin
          inc(PChar(Src));
          dec(FieldSize);
        end;
      // return if field is empty
      Result := FieldSize > 0;
      if Result and (Dst<>nil) then     // data not needed if Result= false or Dst=nil
        case DataType of
        ftBoolean:
          begin
            // in DBase- FileDescription lowercase t is allowed too
            // with asking for Result= true s must be longer then 0
            // else it happens an AV, maybe field is NULL
            if (PChar(Src)^ = 'T') or (PChar(Src)^ = 't') then
              PWord(Dst)^ := 1
            else
              PWord(Dst)^ := 0;
          end;
        ftSmallInt:
          PSmallInt(Dst)^ := GetIntFromStrLength(Src, FieldSize, 0);
{$ifdef DELPHI_4}
        ftLargeInt:
          PLargeInt(Dst)^ := GetInt64FromStrLength(Src, FieldSize, 0);
{$endif}
        ftInteger:
          PInteger(Dst)^ := GetIntFromStrLength(Src, FieldSize, 0);
        ftFloat, ftCurrency:
          PDouble(Dst)^ := DbfStrToFloat(Src, FieldSize);
        ftDate, ftDateTime:
          begin
            // get year, month, day
            ldy := GetIntFromStrLength(PChar(Src) + 0, 4, 1);
            ldm := GetIntFromStrLength(PChar(Src) + 4, 2, 1);
            ldd := GetIntFromStrLength(PChar(Src) + 6, 2, 1);
            //if (ly<1900) or (ly>2100) then ly := 1900;
            //Year from 0001 to 9999 is possible
            //everyting else is an error, an empty string too
            //Do DateCorrection with Delphis possibillities for one or two digits
            if (ldy < 100) and (PChar(Src)[0] = #32) and (PChar(Src)[1] = #32) then
              CorrectYear(ldy);
            try
              date := EncodeDate(ldy, ldm, ldd);
            except
              date := 0;
            end;

            // time stored too?
            if DataType = ftDateTime then
            begin
              // get hour, minute, second
              lth := GetIntFromStrLength(PChar(Src) + 8,  2, 1);
              ltm := GetIntFromStrLength(PChar(Src) + 10, 2, 1);
              lts := GetIntFromStrLength(PChar(Src) + 12, 2, 1);
              // encode
              try
                date := date + EncodeTime(lth, ltm, lts, 0);
              except
                date := 0;
              end;
            end;

//{$ifdef DELPHI_5}
            // Delphi 5 requests a TDateTime
//            PDateTime(Dst)^ := date;
//{$else}
            // Delphi 4 requests a TDateTimeRec
            //  date is TTimeStamp.date
            //  datetime = msecs == BDE timestamp as we implemented it
            if DataType = ftDateTime then
            begin
              PDateTimeRec(Dst).DateTime := DateTimeToBDETimeStamp(date);
            end else begin
              PLongInt(Dst)^ := DateTimeToTimeStamp(date).Date;
            end;
//{$endif}
          end;
        ftString:
          StrLCopy(Dst, Src, FieldSize);
       end;
    end;
  end else begin
    Result := false;
  end;
end;

procedure TDbfFile.SetFieldData(Column: Integer; DataType: TFieldType; Src, Dst: Pointer);
var
  FieldSize,FieldPrec: Integer;
  TempFieldDef: TDbfFieldDef;
  Len, IntValue: Integer;
  year, month, day: Word;
  hour, minute, sec, msec: Word;
  date: TDateTime;
//{$ifndef DELPHI_5}
  timeStamp: TTimeStamp;
//{$endif}

begin
  TempFieldDef := TDbfFieldDef(FFieldDefs.Items[Column]);
  FieldSize := TempFieldDef.Size;
  FieldPrec := TempFieldDef.Precision;

  Dst := PChar(Dst) + TempFieldDef.Offset;
  // if src = nil then write empty field
  if Src = nil then
  begin
    FillChar(Dst^, FieldSize, ' ');
  end else begin
    // OH 2000-11-15 dBase7 support. Write values for new fieldtypes
    case TempFieldDef.NativeFieldType of
      '+', 'I':
        begin
          IntValue := Integer(PDWord(Src)^ + $80000000);
          PInteger(Dst)^ := SwapInt(IntValue);
        end;
      'O':
        begin
{$ifdef DELPHI_4}
          if PDouble(Src)^ < 0 then
            PLargeInt(Dst)^ := not PLargeInt(Src)^
          else
            PDouble(Dst)^ := (PDouble(Src)^) * -1;
          PLargeInt(Dst)^ := SwapInt64(PLargeInt(Dst)^);
{$endif}
        end;
      '@':
        begin
{$ifdef DELPHI_4}
          if FDateTimeHandling = dtBDETimeStamp then
            PDouble(Dst)^ := DateTimeToBDETimeStamp(PDouble(Src)^);
          PLargeInt(Dst)^ := SwapInt64(PLargeInt(Dst)^);
{$endif}
        end;
    else
      case DataType of
        ftBoolean:
          begin
            if PWord(Src)^ <> 0 then
              PChar(Dst)^ := 'T'
            else
              PChar(Dst)^ := 'F';
          end;
        ftSmallInt:
          GetStrFromInt_Width(PSmallInt(Src)^, FieldSize, PChar(Dst));
{$ifdef DELPHI_4}
        ftLargeInt:
          GetStrFromInt64_Width(PLargeInt(Src)^, FieldSize, PChar(Dst));
{$endif}
        ftFloat, ftCurrency:
          FloatToDbfStr(PDouble(Src)^, FieldSize, FieldPrec, PChar(Dst));
        ftInteger:
          GetStrFromInt_Width(PInteger(Src)^, FieldSize, PChar(Dst));
        ftDate, ftDateTime:
          begin
//{$ifdef DELPHI_5}
            // Delphi 5 passes a TDateTime
//            date := PDateTime(Src)^;
//{$else}
            // Delphi 4 passes a TDateTimeRec with a time stamp
            //  date = integer
            //  datetime = msecs == BDETimeStampToDateTime as we implemented it
            if DataType = ftDateTime then
            begin
              date := BDETimeStampToDateTime(PDouble(Src)^);
            end else begin
              timeStamp.Time := 0;
              timeStamp.Date := PLongInt(Src)^;
              date := TimeStampToDateTime(timeStamp);
            end;
//{$endif}
            // decode
            DecodeDate(date, year, month, day);
            // format is yyyymmdd
            GetStrFromInt_Width(year,  4, PChar(Dst));
            GetStrFromInt_Width(month, 2, PChar(Dst)+4);
            GetStrFromInt_Width(day,   2, PChar(Dst)+6);
            // do time too if datetime
            if DataType = ftDateTime then
            begin
              DecodeTime(date, hour, minute, sec, msec);
              // format is hhmmss
              GetStrFromInt_Width(hour,   2, PChar(Dst)+8);
              GetStrFromInt_Width(minute, 2, PChar(Dst)+10);
              GetStrFromInt_Width(sec,    2, PChar(Dst)+12);
            end;
          end;
        ftString:
          begin
            // copy data
            Len := StrLen(Src);
            if Len > FieldSize then
              Len := FieldSize;
            Move(Src^, Dst^, Len);
            // fill remaining space with spaces
            FillChar((PChar(Dst)+Len)^, FieldSize - Len, ' ');
          end;
      end;  // case datatype
    end;
  end;
end;

procedure TDbfFile.InitRecord(DestBuf: PChar);
var
  TempFieldDef: TDbfFieldDef;
  I: Integer;
begin
  FillChar(DestBuf^, RecordSize,' ');
  for I := 0 to FFieldDefs.Count-1 do
  begin
    TempFieldDef := FFieldDefs.Items[I];
    if TempFieldDef.NativeFieldType in ['I', 'O', '@', '+'] then
    begin
      // integer
      FillChar(PChar(DestBuf+TempFieldDef.Offset)^, TempFieldDef.Size, 0);
    end;
    // copy default value?
    if TempFieldDef.HasDefault then
      Move(TempFieldDef.DefaultBuf[0], DestBuf[TempFieldDef.Offset], TempFieldDef.Size);
  end;
end;

procedure TDbfFile.ApplyAutoIncToBuffer(DestBuf: PChar);
var
  TempFieldDef: TDbfFieldDef;
  I, NextVal: {LongWord} Cardinal;    {Delphi 3 does not know LongWord?}
begin
  if FAutoIncPresent then
  begin
    // if shared, reread header to find new autoinc values
    if NeedLocks then
    begin
      // lock header so nobody else can use this value
      LockPage(0, true);
    end;

    // find autoinc fields
    for I := 0 to FFieldDefs.Count-1 do
    begin
      TempFieldDef := FFieldDefs.Items[I];
      if (TempFieldDef.NativeFieldType = '+') then
      begin
        // read current auto inc, from header or field, depending on sharing
        if NeedLocks then
          ReadBlock(@NextVal, 4, TempFieldDef.ValueOffset)
        else
          NextVal := TempFieldDef.AutoInc;
        // store to buffer, positive = high bit on, so flip it
        PInteger(DestBuf+TempFieldDef.Offset)^ := SwapInt(NextVal xor $80000000);
        // increase
        Inc(NextVal);
        TempFieldDef.AutoInc := NextVal;
        // write new value to file
        WriteBlock(@NextVal, 4, TempFieldDef.ValueOffset);
      end;
    end;

    // release lock if locked
    if NeedLocks then
      UnlockPage(0);
  end;
end;

procedure TDbfFile.TryExclusive;
var
  I: Integer;
begin
  inherited;

  // exclusive succeeded? open index & memo exclusive too
  if Mode in [pfMemory..pfExclusiveOpen] then
  begin
    // indexes
    for I := 0 to FIndexFiles.Count - 1 do
      TPagedFile(FIndexFiles[I]).TryExclusive;
    // memo
    if FDbtFile <> nil then
      FDbtFile.TryExclusive;
  end;
end;

procedure TDbfFile.EndExclusive;
var
  I: Integer;
begin
  // end exclusive on index & memo too
  for I := 0 to FIndexFiles.Count - 1 do
    TPagedFile(FIndexFiles[I]).EndExclusive;
  // memo
  if FDbtFile <> nil then
    FDbtFile.EndExclusive;
  // dbf file
  inherited;
end;

procedure TDbfFile.OpenIndex(IndexName, IndexField: string; CreateIndex: Boolean; Options: TIndexOptions);
  //
  // assumes IndexName is not empty
  //
const
  // mem, excr, exopen, rwcr, rwopen, rdonly
  IndexOpenMode: array[pfMemory..pfReadOnly, Boolean] of TPagedFileMode =
    ((pfMemory, pfMemory),
     (pfExclusiveOpen, pfExclusiveCreate), (pfExclusiveOpen, pfExclusiveCreate),
     (pfReadWriteOpen, pfReadWriteCreate), (pfReadWriteOpen, pfReadWriteCreate),
     (pfReadOnly, pfReadOnly));
var
  lIndexFile: TIndexFile;
  lIndexFileName: string;
  createMdxFile: Boolean;
  addedIndexFile: Integer;
  addedIndexName: Integer;
begin
  // init
  addedIndexFile := -1;
  addedIndexName := -1;
  // index already opened?
  lIndexFile := GetIndexByName(IndexName);
  if (lIndexFile <> nil) and (lIndexFile = FMdxFile) and CreateIndex then
  begin
    // index already exists in MDX file
    // delete it to save space, this causes a repage
    FMdxFile.DeleteIndex(IndexName);
    // index no longer exists
    lIndexFile := nil;
  end;
  if lIndexFile = nil then
  begin
    // check if no extension, then create MDX index
    createMdxFile := false;
    if Length(ExtractFileExt(IndexName)) = 0 then
    begin
      // check if mdx index already opened
      if FMdxFile <> nil then
      begin
        lIndexFileName := EmptyStr;
        lIndexFile := FMdxFile;
      end else begin
        lIndexFileName := ChangeFileExt(FileName, '.mdx');
        // set MDX flag to true
        PDbfHdr(Header).MDXFlag := 1;
        createMdxFile := true;
      end;
    end else begin
      lIndexFileName := IndexName;
    end;
    // do we need to open / create file?
    if lIndexFileName <> EmptyStr then
    begin
      // try to open / create the file
      lIndexFile := TIndexFile.Create(Self, lIndexFileName);
      lIndexFile.Mode := IndexOpenMode[Mode, CreateIndex];
      lIndexFile.AutoCreate := CreateIndex or (Length(IndexField) > 0);
      lIndexFile.OnLocaleError := FOnLocaleError;
      lIndexFile.Open;
      // index file ready for use?
      if not lIndexFile.ForceClose then
      begin
        // created accompanying mdx file?
        if createMdxFile then
          FMdxFile := lIndexFile;
        // if we had to create the index, store that info
        CreateIndex := lIndexFile.FileCreated;
        // add new index file to list
        addedIndexFile := FIndexFiles.Add(lIndexFile);
      end else begin
        // asked to close! close file
        lIndexFile.Free;
        lIndexFile := nil;
      end;
    end;

    // check if file succesfully opened
    if lIndexFile <> nil then
    begin
      // add index to list
      addedIndexName := FIndexNames.AddObject(IndexName, lIndexFile);
    end;
  end;
  // create it or open it?
  if lIndexFile <> nil then
  begin
    if not CreateIndex then
      if lIndexFile = FMdxFile then
        CreateIndex := lIndexFile.IndexOf(IndexName) < 0;
    if CreateIndex then
    begin
      // try get exclusive mode
      if IsSharedAccess then TryExclusive;
      // always uppercase index expression
      IndexField := UpperCase(IndexField);
      try
        // create index if asked
        lIndexFile.CreateIndex(IndexField, IndexName, Options);
        // add all records
        PackIndex(lIndexFile, IndexName);
        // if we wanted to open index readonly, but we created it, then reopen
        if Mode = pfReadOnly then
        begin
          lIndexFile.CloseFile;
          lIndexFile.Mode := pfReadOnly;
          lIndexFile.OpenFile;
        end;
      except
        // :-( need to undo 'damage'....
        // remove index from list(s) if just added
        if addedIndexFile >= 0 then
          FIndexFiles.Delete(addedIndexFile);
        if addedIndexName >= 0 then
          FIndexNames.Delete(addedIndexName);
        // delete index file itself
        lIndexFile.DeleteIndex(IndexName);
        // if no file created, do not destroy!
        if addedIndexFile >= 0 then
          lIndexFile.Free;
      end;
      // return to previous mode
      if TempMode <> pfNone then EndExclusive;
    end;
  end;
end;

procedure TDbfFile.PackIndex(lIndexFile: TIndexFile; AIndexName: string);
var
  prevMode: TIndexUpdateMode;
  prevIndex: string;
  cur, last: Integer;
{$ifdef USE_CACHE}
  prevCache: Integer;
{$endif}
begin
  // save current mode in case we change it
  prevMode := lIndexFile.UpdateMode;
  prevIndex := lIndexFile.IndexName;
  // check if index specified
  if Length(AIndexName) > 0 then
  begin
    // only pack specified index, not all
    lIndexFile.IndexName := AIndexName;
    lIndexFile.ClearIndex;
    lIndexFile.UpdateMode := umCurrent;
  end else
    lIndexFile.Clear;
  // prepare update
  cur := 1;
  last := RecordCount;
{$ifdef USE_CACHE}
  BufferAhead := true;
  prevCache := lIndexFile.CacheSize;
  lIndexFile.CacheSize := GetFreeMemory;
  if lIndexFile.CacheSize < 16384 * 1024 then
    lIndexFile.CacheSize := 16384 * 1024;
{$endif}
  while cur <= last do
  begin
    ReadRecord(cur, FPrevBuffer);
    lIndexFile.Insert(cur, FPrevBuffer);
    inc(cur);
  end;
  // restore previous mode
{$ifdef USE_CACHE}
  BufferAhead := false;
  lIndexFile.BufferAhead := true;
{$endif}
  lIndexFile.Flush;
{$ifdef USE_CACHE}
  lIndexFile.BufferAhead := false;
  lIndexFile.CacheSize := prevCache;
{$endif}
  lIndexFile.UpdateMode := prevMode;
  lIndexFile.IndexName := prevIndex;
end;

procedure TDbfFile.RepageIndex(AIndexFile: string);
var
  lIndexNo: Integer;
begin
  // DBF MDX index?
  if Length(AIndexFile) = 0 then
  begin
    if FMdxFile <> nil then
    begin
      // repage attached mdx
      FMdxFile.RepageFile;
    end;
  end else begin
    // search index file
    lIndexNo := FIndexNames.IndexOf(AIndexFile);
    // index found?
    if lIndexNo >= 0 then
      TIndexFile(FIndexNames.Objects[lIndexNo]).RepageFile;
  end;
end;

procedure TDbfFile.CloseIndex(AIndexName: string);
var
  lIndexNo: Integer;
  lIndex: TIndexFile;
begin
  // search index file
  lIndexNo := FIndexNames.IndexOf(AIndexName);
  // don't close mdx file
  if (lIndexNo >= 0) then
  begin
    // get index pointer
    lIndex := TIndexFile(FIndexNames.Objects[lIndexNo]);
    if (lIndex <> FMdxFile) then
    begin
      // close file
      lIndex.Free;
      // remove from lists
      FIndexFiles.Remove(lIndex);
      FIndexNames.Delete(lIndexNo);
      // was this the current index?
      if (FCurIndex = lIndexNo) then
      begin
        FCurIndex := -1;
        //FCursor := FDbfCursor;
      end;
    end;
  end;
end;

function TDbfFile.DeleteIndex(const AIndexName: string): Boolean;
var
  lIndexNo: Integer;
  lIndex: TIndexFile;
begin
  // search index file
  lIndexNo := FIndexNames.IndexOf(AIndexName);
  Result := lIndexNo >= 0;
  // found index?
  if Result then
  begin
    // can only delete indexes from MDX files
    lIndex := TIndexFile(FIndexNames.Objects[lIndexNo]);
    if lIndex = FMdxFile then
    begin
      lIndex.DeleteIndex(AIndexName);
      // no more MDX indexes?
      lIndexNo := FIndexNames.IndexOfObject(FMdxFile);
      if lIndexNo = -1 then
      begin
        // no MDX indexes left
        FMdxFile.Free;
        FMdxFile := nil;
        // erase file
        Sysutils.DeleteFile(ChangeFileExt(FileName, '.mdx'));
        // clear mdx flag
        PDbfHdr(Header).MDXFlag := 0;
      end;
    end else begin
      // close index first
      CloseIndex(AIndexName);
      // delete file from disk
      Sysutils.DeleteFile(AIndexName);
    end;
  end;
end;

procedure TDbfFile.Insert(Buffer: PChar);
var
  I, newRecord: Integer;
  lIndex: TIndexFile;
  error: Boolean;
begin
  // get new record index
  newRecord := RecordCount+1;
  // lock record so we can write data
  while not LockPage(newRecord, false) do
    Inc(newRecord);
  // write autoinc value
  ApplyAutoIncToBuffer(Buffer);
  // update indexes -> possible key violation
  I := 0; error := false;
  while (I < FIndexFiles.Count) and not error do
  begin
    try
      lIndex := TIndexFile(FIndexFiles.Items[I]);
      lIndex.Insert(newRecord, Buffer);
      Inc(I);
    except
      error := true;
    end;
  end;
  // error occured while inserting? -> undo index inserts and abort
  if error then
  begin
    while (I > 0) do
    begin
      Dec(I);
      lIndex := TIndexFile(FIndexFiles.Items[I]);
      lIndex.Delete(newRecord, Buffer);
    end;

    UnlockPage(newRecord);
    exit;
  end;

  // indexes ok -> continue inserting
  // update header record count
  LockPage(0, true);
  // read current header
  ReadHeader;
  // increase current record count
  Inc(PDbfHdr(Header).RecordCount);
  // write header to disk
  WriteHeader;
  // done with header
  UnlockPage(0);
  // write locking info
  if FHasLockField then
    WriteLockInfo(Buffer);
  // write buffer to disk
  WriteRecord(newRecord, Buffer);
  // done updating, unlock
  UnlockPage(newRecord);
end;

procedure TDbfFile.WriteLockInfo(Buffer: PChar);
//
// *) assumes FHasLockField = true
//
var
  year, month, day, hour, minute, sec, msec: Word;
begin
  // increase change count
  Inc(PWord(Buffer+FLockFieldOffset)^);
  // set time
  DecodeDate(Now(), year, month, day);
  DecodeTime(Now(), hour, minute, sec, msec);
  Buffer[FLockFieldOffset+2] := Char(hour);
  Buffer[FLockFieldOffset+3] := Char(minute);
  Buffer[FLockFieldOffset+4] := Char(sec);
  // set date
  Buffer[FLockFieldOffset+5] := Char(year - 1900);
  Buffer[FLockFieldOffset+6] := Char(month);
  Buffer[FLockFieldOffset+7] := Char(day);
  // set name
  FillChar(Buffer[FLockFieldOffset+8], FLockFieldLen-8, ' ');
  Move(DbfGlobals.UserName[0], Buffer[FLockFieldOffset+8], FLockUserLen);
end;

procedure TDbfFile.LockRecord(RecNo: Integer; Buffer: PChar);
begin
  if LockPage(RecNo, false) then
  begin
    // reread data
    ReadRecord(RecNo, Buffer);
    // store previous data for updating indexes
    Move(Buffer^, FPrevBuffer^, RecordSize);
    // lock succeeded, update lock info, if field present
    if FHasLockField then
    begin
      // update buffer
      WriteLockInfo(Buffer);
      // write to disk
      WriteRecord(RecNo, Buffer);
    end;
  end else
    raise EDbfError.Create(STRING_RECORD_LOCKED);
end;

procedure TDbfFile.UnlockRecord(RecNo: Integer; Buffer: PChar);
var
  I: Integer;
  lIndex: TIndexFile;
begin
  // update indexes, possible key violation
  for I := 0 to FIndexFiles.Count - 1 do
  begin
    lIndex := TIndexFile(FIndexFiles.Items[I]);
    lIndex.Update(RecNo, FPrevBuffer, Buffer);
  end;
  // write new record buffer, all keys ok
  WriteRecord(RecNo, Buffer);
  // done updating, unlock
  UnlockPage(RecNo);
end;

procedure TDbfFile.RecordDeleted(RecNo: Integer; Buffer: PChar);
var
  I: Integer;
  lIndex: TIndexFile;
begin
  // notify indexes: record deleted
  for I := 0 to FIndexFiles.Count - 1 do
  begin
    lIndex := TIndexFile(FIndexFiles.Items[I]);
    lIndex.RecordDeleted(RecNo, Buffer);
  end;
end;

procedure TDbfFile.RecordRecalled(RecNo: Integer; Buffer: PChar);
var
  I: Integer;
  lIndex: TIndexFile;
begin
  // notify indexes: record recalled
  for I := 0 to FIndexFiles.Count - 1 do
  begin
    lIndex := TIndexFile(FIndexFiles.Items[I]);
    lIndex.RecordRecalled(RecNo, Buffer);
  end;
end;

procedure TDbfFile.SetRecordSize(NewSize: Integer);
begin
  if NewSize <> RecordSize then
  begin
    if FPrevBuffer <> nil then
    begin
      FreeMem(FPrevBuffer);
      FPrevBuffer := nil;
    end;
    if NewSize > 0 then
      GetMem(FPrevBuffer, NewSize);
  end;
  inherited;
end;

function TDbfFile.GetIndexByName(AIndexName: string): TIndexFile;
var
  I: Integer;
begin
  I := FIndexNames.IndexOf(AIndexName);
  if I >= 0 then
    Result := TIndexFile(FIndexNames.Objects[I])
  else
    Result := nil;
end;

//====================================================================
// TDbfCursor
//====================================================================
constructor TDbfCursor.Create(DbfFile: TDbfFile);
begin
  inherited Create(DbfFile);
end;

function TDbfCursor.Next: Boolean;
var
  max: Integer;
begin
  max := TDbfFile(PagedFile).RecordCount;
  if FPhysicalRecNo <= max then
    inc(FPhysicalRecNo)
  else
    FPhysicalRecNo := max + 1;
  Result := (FPhysicalRecNo <= max);
end;

function TDbfCursor.Prev: Boolean;
begin
  if FPhysicalRecNo > 0 then
    dec(FPhysicalRecNo)
  else
    FPhysicalRecNo := 0;
  Result := (FPhysicalRecNo > 0);
end;

procedure TDbfCursor.First;
begin
  FPhysicalRecNo := 0;
end;

procedure TDbfCursor.Last;
var
  max: Integer;
begin
  max := TDbfFile(PagedFile).RecordCount;
  if max = 0 then
    FPhysicalRecNo := 0
  else
    FPhysicalRecNo := max + 1;
end;

function TDbfCursor.GetPhysicalRecNo: Integer;
begin
  Result := FPhysicalRecNo;
end;

procedure TDbfCursor.SetPhysicalRecNo(RecNo: Integer);
begin
  FPhysicalRecNo := RecNo;
end;

function TDbfCursor.GetSequentialRecordCount: Integer;
begin
  Result := TDbfFile(PagedFile).RecordCount;
end;

function TDbfCursor.GetSequentialRecNo: Integer;
begin
  Result := FPhysicalRecNo;
end;

procedure TDbfCursor.SetSequentialRecNo(RecNo: Integer);
begin
  FPhysicalRecNo := RecNo;
end;

procedure TDbfCursor.GotoBookmark(Bookmark: rBookmarkData);
begin
  FPhysicalRecNo := Bookmark{.RecNo};
end;

procedure TDbfCursor.Insert(RecNo: Integer; Buffer: PChar); {override;}
begin
  FPhysicalRecNo := TDbfFile(PagedFile).RecordCount;
end;

procedure TDbfCursor.Update(RecNo: Integer; PrevBuffer,NewBuffer: PChar); {override;}
begin
end;

// codepage enumeration procedure
var
  TempCodePageList: TList;

// LPTSTR = PChar ok?

function CodePagesProc(CodePageString: PChar): Cardinal; stdcall;
begin
  // add codepage to list
  TempCodePageList.Add(Pointer(GetIntFromStrLength(CodePageString, StrLen(CodePageString), -1)));

  // continue enumeration
  Result := 1;
end;

function TDbfCursor.GetBookMark: rBookmarkData; {override;}
begin
//  Result.IndexBookmark := -1;
  Result{.RecNo} := FPhysicalRecNo;
end;

//====================================================================
// TDbfGlobals
//====================================================================
constructor TDbfGlobals.Create;
begin
  FCodePages := TList.Create;
  FDefaultOpenCodePage := GetOEMCP;
  FDefaultCreateCodePage := GetACP;
  FDefaultCreateLocale := LANG_ENGLISH or (SUBLANG_ENGLISH_UK shl 10);
  FDefaultCreateFoxPro := false;
  // determine which code pages are installed
  TempCodePageList := FCodePages;
  EnumSystemCodePages(@CodePagesProc, CP_SUPPORTED {CP_INSTALLED});
  TempCodePageList := nil;
{$ifdef WIN32}
  FUserNameLen := SizeOf(FUserName);
//  Windows.GetUserName(@FUserName[0], FUserNameLen);
  Windows.GetComputerName(@FUserName[0], FUserNameLen);
{$else}
  FUserNameLen := 0;
{$endif}
end;

destructor TDbfGlobals.Destroy; {override;}
begin
  FCodePages.Free;
end;

function TDbfGlobals.GetUserName: PChar;
begin
  Result := @FUserName[0];
end;

function TDbfGlobals.CodePageInstalled(ACodePage: Integer): Boolean;
begin
  Result := FCodePages.IndexOf(Pointer(ACodePage)) >= 0;
end;

initialization
finalization
  FreeAndNil(DbfGlobals);


(*
  Stuffs non implemented yet
  TFoxCDXHeader         = Record
    PointerRootNode     : Integer;
    PointerFreeList     : Integer;
    Reserved_8_11       : Cardinal;
    KeyLength           : Word;
    IndexOption         : Byte;
    IndexSignature      : Byte;
    Reserved_Null       : TFoxReservedNull;
    SortOrder           : Word;
    TotalExpressionLen  : Word;
    ForExpressionLen    : Word;
    Reserved_506_507    : Word;
    KeyExpressionLen    : Word;
    KeyForExpression    : TKeyForExpression;
  End;
  PFoxCDXHeader         = ^TFoxCDXHeader;

  TFoxCDXNodeCommon     = Record
    NodeAttributes      : Word;
    NumberOfKeys        : Word;
    PointerLeftNode     : Integer;
    PointerRightNode    : Integer;
  End;

  TFoxCDXNodeNonLeaf    = Record
    NodeCommon          : TFoxCDXNodeCommon;
    TempBlock           : Array [12..511] of Byte;
  End;
  PFoxCDXNodeNonLeaf    = ^TFoxCDXNodeNonLeaf;

  TFoxCDXNodeLeaf       = Packed Record
    NodeCommon          : TFoxCDXNodeCommon;
    BlockFreeSpace      : Word;
    RecordNumberMask    : Integer;
    DuplicateCountMask  : Byte;
    TrailByteCountMask  : Byte;
    RecNoBytes          : Byte;
    DuplicateCountBytes : Byte;
    TrailByteCountBytes : Byte;
    HoldingByteCount    : Byte;
    DataBlock           : TDataBlock;
  End;
  PFoxCDXNodeLeaf       = ^TFoxCDXNodeLeaf;

*)

end.


unit Dbf;

{ design info in dbf_reg.pas }

interface

{$I Dbf_Common.inc}

uses
  Classes,
  Db,
  Dbf_Common,
  Dbf_DbfFile,
  Dbf_Parser,
  Dbf_Cursor,
  Dbf_Fields,
  Dbf_IdxFile;
// If you got a compilation error here or asking for dsgnintf.pas, then just add
// this file in your project:
// dsgnintf.pas in 'C: \Program Files\Borland\Delphi5\Source\Toolsapi\dsgnintf.pas'

type

//====================================================================
  TDbfRecordContent = array[0..4000] of Char;

  pDbfRecord = ^rDbfRecord;
  rDbfRecord = record
    BookmarkData: rBookmarkData;
    BookmarkFlag: TBookmarkFlag;
    DeletedFlag: Char;
    Fields: TDbfRecordContent;
  end;
//====================================================================
  TDbf = class;
//====================================================================
  TDbfStorage = (stoMemory,stoAuto,stoFile);
  TDbfOpenMode = (omNormal,omAutoCreate,omTemporary);
  TDbfLanguageAction = (laEditOnly, laForceOEM, laForceANSI);
  TDbfTranslationMode = (tmNoneAvailable, tmNoneNeeded, tmSimple, tmAdvanced);
//====================================================================
  TCompareRecordEvent = procedure(Dbf: TDbf; var Accept: Boolean) of object;
  TTranslateEvent = function(Dbf: TDbf; Src, Dest: PChar; ToOem: Boolean): Integer of object;
  TLanguageWarningEvent = procedure(Dbf: TDbf; var Action: TDbfLanguageAction) of object;
  TConvertFieldEvent = procedure(Dbf: TDbf; DstField, SrcField: TField) of object;
//====================================================================
  TDbfBlobStream = class(TMemoryStream)
  private
    FMode: TBlobStreamMode;
    FBlobField: TBlobField;
    FMemoRecNo: Integer;
    FReadSize: Integer;

    function GetTransliterate: Boolean;
    procedure Translate(ToOem: Boolean);
  public
    constructor Create(ModeVal: TBlobStreamMode; FieldVal: TField);
    destructor Destroy;  override;

    property Transliterate: Boolean read GetTransliterate;
    property MemoRecNo: Integer read FMemoRecNo write FMemoRecNo;
    property ReadSize: Integer read FReadSize write FReadSize;
    property Mode: TBlobStreamMode read FMode;
    property BlobField: TBlobField read FBlobField;
  end;
//====================================================================
  TDbfIndexDefs = class(TCollection)
  public
    FOwner: TDbf;
   private
    function GetItem(N: Integer): TDbfIndexDef;
    procedure SetItem(N: Integer; Value: TDbfIndexDef);
   protected
    function GetOwner: TPersistent; override;
   public
    constructor Create(AOwner: TDbf);

    function  Add: TDbfIndexDef;
    function  GetIndexByName(const Name: string): TDbfIndexDef;
    procedure Update; {$ifdef DELPHI_4} reintroduce; {$endif}

    property Items[N: Integer]: TDbfIndexDef read GetItem write SetItem; default;
  end;
//====================================================================
  TDbfMasterLink = class(TDataLink)
  private
    FDetailDataSet: TDbf;
    FParser: TDbfParser;
    FFieldNames: string;
    FValidExpression: Boolean;
    FOnMasterChange: TNotifyEvent;
    FOnMasterDisable: TNotifyEvent;

    function GetFieldsVal: PChar;

    procedure SetFieldNames(const Value: string);
  protected
    procedure ActiveChanged; override;
    procedure CheckBrowseMode; override;
    procedure LayoutChanged; override;
    procedure RecordChanged(Field: TField); override;

  public
    constructor Create(ADataSet: TDbf);
    destructor Destroy; override;

    property FieldNames: string read FFieldNames write SetFieldNames;
    property ValidExpression: Boolean read FValidExpression write FValidExpression;
    property FieldsVal: PChar read GetFieldsVal;
    property Parser: TDbfParser read FParser;

    property OnMasterChange: TNotifyEvent read FOnMasterChange write FOnMasterChange;
    property OnMasterDisable: TNotifyEvent read FOnMasterDisable write FOnMasterDisable;
  end;
//====================================================================
  TDbf = class(TDataSet)
  private
    FDbfFile: TDbfFile;
    FCursor: TVirtualCursor;
    FOpenMode: TDbfOpenMode;
    FStorage: TDbfStorage;
    FMasterLink: TDbfMasterLink;
    FParser: TDbfParser;
    FTableName: string;    // table path and file name
    FRelativePath: string;
    FAbsolutePath: string;
    FIndexName: string;
    FReadOnly: Boolean;
    FFilterBuffer: PChar;
    FEditingRecNo: Integer;
    FTableLevel: Integer;
    FExclusive: Boolean;
    FShowDeleted: Boolean;
    FUseFloatFields: Boolean;
    FPosting: Boolean;
    FDisableResyncOnPost: Boolean;
    FTempExclusive: Boolean;
    FInCopyFrom: Boolean;
    FCopyDateTimeAsString: Boolean;
    FIndexFile: TIndexFile;
    FDateTimeHandling: TDateTimeHandling;
    FTranslationMode: TDbfTranslationMode;
    FIndexDefs: TDbfIndexDefs;
    FOnTranslate: TTranslateEvent;
    FOnLanguageWarning: TLanguageWarningEvent;
    FOnLocaleError: TDbfLocaleErrorEvent;
    FOnIndexMissing: TDbfIndexMissingEvent;
    FOnCompareRecord: TNotifyEvent;
    FOnCopyDateTimeAsString: TConvertFieldEvent;

    function GetIndexName: string;
    function GetVersion: string;
    function GetPhysicalRecNo: Integer;
    function GetLanguageID: Integer;
    function GetLanguageStr: string;
    function GetCodePage: Cardinal;
    function GetExactRecordCount: Integer;
    function GetMasterFields: string;

    procedure SetIndexName(AIndexName: string);
    procedure SetDbfIndexes(const Value: TDbfIndexDefs);
    procedure SetRelativePath(const Value: string);
    procedure SetTableName(const S: string);
    procedure SetVersion(const S: string);
    procedure SetDataSource(Value: TDataSource);
    procedure SetMasterFields(const Value: string);
    procedure SetTableLevel(const NewLevel: Integer);
    procedure SetPhysicalRecNo(const NewRecNo: Integer);

    procedure MasterChanged(Sender: TObject);
    procedure MasterDisabled(Sender: TObject);
    procedure CheckMasterRange;
    procedure UpdateRange;
    procedure SetShowDeleted(Value: Boolean);
    procedure GetFieldDefsFromDbfFieldDefs;
    procedure CreateTableFromFieldDefs;
    procedure CreateTableFromFields;
    function  ParseIndexName(const AIndexName: string): string;
    function  GetCurrentBuffer: PChar;
    function  GetDbfFieldDefs: TDbfFieldDefs;
    function  SearchKeyBuffer(Buffer: PChar; SearchType: TSearchKeyType): Boolean;
    procedure SetRangeBuffer(LowRange: PChar; HighRange: PChar);

  protected
    { abstract methods }
    function  AllocRecordBuffer: PChar; override; {virtual abstract}
    procedure FreeRecordBuffer(var Buffer: PChar); override; {virtual abstract}
    procedure GetBookmarkData(Buffer: PChar; Data: Pointer); override; {virtual abstract}
    function  GetBookmarkFlag(Buffer: PChar): TBookmarkFlag; override; {virtual abstract}
    function  GetRecord(Buffer: PChar; GetMode: TGetMode; DoCheck: Boolean): TGetResult; override; {virtual abstract}
    function  GetRecordSize: Word; override; {virtual abstract}
    procedure InternalAddRecord(Buffer: Pointer; Append: Boolean); override; {virtual abstract}
    procedure InternalClose; override; {virtual abstract}
    procedure InternalDelete; override; {virtual abstract}
    procedure InternalFirst; override; {virtual abstract}
    procedure InternalGotoBookmark(Bookmark: Pointer); override; {virtual abstract}
    procedure InternalHandleException; override; {virtual abstract}
    procedure InternalInitFieldDefs; override; {virtual abstract}
    procedure InternalInitRecord(Buffer: PChar); override; {virtual abstract}
    procedure InternalLast; override; {virtual abstract}
    procedure InternalOpen; override; {virtual abstract}
    procedure InternalEdit; override; {virtual}
    procedure InternalCancel; override; {virtual}
    procedure InternalPost; override; {virtual abstract}
    procedure InternalSetToRecord(Buffer: PChar); override; {virtual abstract}
    function  IsCursorOpen: Boolean; override; {virtual abstract}
    procedure SetBookmarkFlag(Buffer: PChar; Value: TBookmarkFlag); override; {virtual abstract}
    procedure SetBookmarkData(Buffer: PChar; Data: Pointer); override; {virtual abstract}
    procedure SetFieldData(Field: TField; Buffer: Pointer); override; {virtual abstract}

    { virtual methods (mostly optionnal) }
    function  GetDataSource: TDataSource; override;
    function  GetRecordCount: Integer; override; {virtual}
    function  GetRecNo: Integer; override; {virtual}
    function  GetCanModify: Boolean; override; {virtual}
    procedure SetRecNo(Value: Integer); override; {virual}
    procedure SetFiltered(Value: Boolean); override; {virtual;}
    procedure SetFilterText(const Value: String); override; {virtual;}

    procedure DoFilterRecord(var Acceptable: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    { abstract methods }
    function GetFieldData(Field: TField; Buffer: Pointer): Boolean; override; {virtual abstract}
    { virtual methods (mostly optionnal) }
    procedure Resync(Mode: TResyncMode); override;
    function CreateBlobStream(Field: TField; Mode: TBlobStreamMode): TStream; override; {virtual}
{$ifdef DELPHI_4}
    function Translate(Src, Dest: PChar; ToOem: Boolean): Integer; override; {virtual}
{$else}
    procedure Translate(Src, Dest: PChar; ToOem: Boolean); override; {virtual}
{$endif}
    procedure ClearCalcFields(Buffer: PChar); override;

//{$ifdef DELPHI_5}
//    function GetFieldData(Field: TField; Buffer: Pointer; NativeFormat: Boolean): Boolean; overload; override;
//    procedure SetFieldData(Field: TField; Buffer: Pointer; NativeFormat: Boolean); overload; override;
//{$endif}

    function CompareBookmarks(Bookmark1, Bookmark2: TBookmark): Integer; override;

    // my own methods and properties
    // most look like ttable functions but they are not tdataset related
    // I (try to) use the same syntax to facilitate the conversion between bde and TDbf

    // index support (use same syntax as ttable but is not related)
{$ifdef DELPHI_5}
    procedure AddIndex(const AIndexName, Fields: String; Options: TIndexOptions; const DescFields: String='');
{$else}
    procedure AddIndex(const AIndexName, Fields: String; Options: TIndexOptions);
{$endif}
    procedure RegenerateIndexes;

    procedure CancelRange;
{.$ifdef DELPHI_4}
    function  SearchKey(Key: Variant; SearchType: TSearchKeyType): Boolean;
    procedure SetRange(LowRange: Variant; HighRange: Variant);
{.$endif}
    function  SearchKeyPChar(Key: PChar; SearchType: TSearchKeyType): Boolean;
    procedure SetRangePChar(LowRange: PChar; HighRange: PChar);
    procedure UpdateIndexDefs; override;
    procedure GetIndexNames(Strings: TStrings);

    procedure TryExclusive;
    procedure EndExclusive;
    function  LockTable(const Wait: Boolean): Boolean;
    procedure UnlockTable;
    procedure OpenIndexFile(IndexFile: string);
    procedure DeleteIndex(const AIndexName: string);
    procedure CloseIndexFile(const AIndexName: string);
    procedure RepageIndexFile(const AIndexFile: string);

    function  Locate(const KeyFields: string; const KeyValues: Variant; Options: TLocateOptions): Boolean; override;
    function  LocateRecord(const KeyFields: string; const KeyValues: Variant; Options: TLocateOptions; bSyncCursor: Boolean): Boolean;

    function  IsDeleted: Boolean;
    procedure Undelete;

    procedure CreateTable;
    procedure CreateTableEx(DbfFieldDefs: TDbfFieldDefs);
    procedure CopyFrom(DataSet: TDataSet; FileName: string; DateTimeAsString: Boolean; Level: Integer);
    procedure RestructureTable(DbfFieldDefs: TDbfFieldDefs; Pack: Boolean);
    procedure PackTable;
    procedure EmptyTable;
    procedure Zap;

{$ifndef DELPHI_5}
    procedure InitFieldDefsFromFields;
{$endif}

    property AbsolutePath: string read FAbsolutePath;
    property DbfFieldDefs: TDbfFieldDefs read GetDbfFieldDefs;
    property PhysicalRecNo: Integer read GetPhysicalRecNo write SetPhysicalRecNo;
    property LanguageID: Integer read GetLanguageID;
    property LanguageStr: String read GetLanguageStr;
    property CodePage: Cardinal read GetCodePage;
    property ExactRecordCount: Integer read GetExactRecordCount;
    property DbfFile: TDbfFile read FDbfFile;
    property TableLevel: Integer read FTableLevel write SetTableLevel;
    property DisableResyncOnPost: Boolean read FDisableResyncOnPost write FDisableResyncOnPost;
  published
    property DateTimeHandling: TDateTimeHandling
             read FDateTimeHandling write FDateTimeHandling default dtBDETimeStamp;
    property Exclusive: Boolean read FExclusive write FExclusive default false;
    property FilePath: string read FRelativePath write SetRelativePath;
    property Indexes: TDbfIndexDefs read FIndexDefs write SetDbfIndexes;
    property IndexName: string read GetIndexName write SetIndexName;
    property MasterFields: string read GetMasterFields write SetMasterFields;
    property MasterSource: TDataSource read GetDataSource write SetDataSource;
    property OpenMode: TDbfOpenMode read FOpenMode write FOpenMode default omNormal;
    property ReadOnly: Boolean read FReadOnly write FReadonly default false;
    property ShowDeleted: Boolean read FShowDeleted write SetShowDeleted default false;
    property Storage: TDbfStorage read FStorage write FStorage default stoFile;
    property TableName: string read FTableName write SetTableName;
    property UseFloatFields: Boolean read FUseFloatFields write FUseFloatFields default true;
    property Version: string read GetVersion write SetVersion stored false;
    property OnCompareRecord: TNotifyEvent read FOnCompareRecord write FOnCompareRecord;
    property OnLanguageWarning: TLanguageWarningEvent read FOnLanguageWarning write FOnLanguageWarning;
    property OnLocaleError: TDbfLocaleErrorEvent read FOnLocaleError write FOnLocaleError;
    property OnIndexMissing: TDbfIndexMissingEvent read FOnIndexMissing write FOnIndexMissing;
    property OnCopyDateTimeAsString: TConvertFieldEvent read FOnCopyDateTimeAsString write FOnCopyDateTimeAsString;

    // redeclared data set properties
    property Active;
    property Filter;
    property Filtered;
    property BeforeOpen;
    property AfterOpen;
    property BeforeClose;
    property AfterClose;
    property BeforeInsert;
    property AfterInsert;
    property BeforeEdit;
    property AfterEdit;
    property BeforePost;
    property AfterPost;
    property BeforeCancel;
    property AfterCancel;
    property BeforeDelete;
    property AfterDelete;
    property BeforeScroll;
    property AfterScroll;
    property OnCalcFields;
    property OnDeleteError;
    property OnEditError;
    property OnFilterRecord;
    property OnNewRecord;
    property OnPostError;
    property OnTranslate: TTranslateEvent read FOnTranslate write FOnTranslate;
  end;

implementation

uses
  SysUtils,
  DBConsts,
{$ifdef WIN32}
  Messages,
  Windows,
  Forms,
{$endif}
{$ifdef LINUX}
  Libc,
  Types,
  Dbf_Wtil,
{$endif}
{$ifdef DELPHI_6}
  Variants,
{$endif}
  Dbf_PgFile,
  Dbf_IdxCur,
  Dbf_Memo,
  Dbf_Str;


//==========================================================
//============ TDbfBlobStream
//==========================================================
constructor TDbfBlobStream.Create(ModeVal: TBlobStreamMode; FieldVal: TField);
begin
  FMode := ModeVal;
  FBlobField := FieldVal as TBlobField;
end;

destructor TDbfBlobStream.Destroy;
var
  Dbf: TDbf;
begin
  if (Mode = bmWrite) then
  begin
    Size := Position; // Strange but it leave tailing trash bytes if I do not write that.
    Dbf := TDbf(FBlobField.DataSet);
    Translate(true);
    Dbf.FDbfFile.DbtFile.WriteMemo(FMemoRecNo, FReadSize, Self);
    Dbf.FDbfFile.SetFieldData(FBlobField.FieldNo-1, ftInteger, @FMemoRecNo,
      @pDbfRecord(TDbf(FBlobField.DataSet).ActiveBuffer).DeletedFlag);
    // seems not bad
    Dbf.SetModified(true);
    // but would that be better
    //if not (State in [dsCalcFields, dsFilter, dsNewValue]) then begin
    //  DataEvent(deFieldChange, Longint(FBlobField));
    //end;
  end;
  inherited Destroy;
end;

function TDbfBlobStream.GetTransliterate: Boolean;
begin
  Result := FBlobField.Transliterate;
end;

procedure TDbfBlobStream.Translate(ToOem: Boolean);
var
  bytesToDo, numBytes: Integer;
  bufPos: PChar;
  saveChar: Char;
begin
  if (Transliterate) and (Size > 0) then
  begin
    // get number of bytes to be translated
    bytesToDo := Size;
    // make space for final null-terminator
    Size := Size + 1;
    bufPos := Memory;
    repeat
      // process blocks of 512 bytes
      numBytes := bytesToDo;
      if numBytes > 512 then
        numBytes := 512;
      // null-terminate memory
      saveChar := bufPos[numBytes];
      bufPos[numBytes] := #0;
      // translate memory
      TDbf(FBlobField.DataSet).Translate(bufPos, bufPos, ToOem);
      // restore char
      bufPos[numBytes] := saveChar;
      // numBytes bytes translated
      Dec(bytesToDo, numBytes);
      Inc(bufPos, numBytes);
    until bytesToDo = 0;
    // cut ending null-terminator
    Size := Size - 1;
  end;
end;

//====================================================================
// TDbf = TDataset Descendant.
//====================================================================
constructor TDbf.Create(AOwner: TComponent); {override;}
begin
  inherited;

  if DbfGlobals = nil then
    DbfGlobals := TDbfGlobals.Create;

  BookmarkSize := sizeof(rBookmarkData);
  FIndexDefs := TDbfIndexDefs.Create(Self);
  FMasterLink := TDbfMasterLink.Create(Self);
  FMasterLink.OnMasterChange := MasterChanged;
  FMasterLink.OnMasterDisable := MasterDisabled;
  FDateTimeHandling := dtBDETimeStamp;
  FStorage := stoFile;
  FOpenMode := omNormal;
  FParser := nil;
  FPosting := false;
  FReadOnly := false;
  FExclusive := false;
  FUseFloatFields := true;
  FDisableResyncOnPost := false;
  FTempExclusive := false;
  FCopyDateTimeAsString := false;
  FInCopyFrom := false;
  FEditingRecNo := -1;
  FTableLevel := 4;
  FIndexName := EmptyStr;
  SetRelativePath(EmptyStr);
  FIndexFile := nil;
  FOnTranslate := nil;
  FOnCopyDateTimeAsString := nil;
end;

destructor TDbf.Destroy; {override;}
var
  I: Integer;
begin
  inherited Destroy;

  if FIndexDefs <> nil then
  begin
    for I := FIndexDefs.Count - 1 downto 0 do
      TDbfIndexDef(FIndexDefs.Items[I]).Free;
    FIndexDefs.Free;
  end;
  FMasterLink.Free;
end;

function TDbf.AllocRecordBuffer: PChar; {override virtual abstract from TDataset}
begin
  GetMem(Result, sizeof(rDbfRecord)-sizeof(TDbfRecordContent)+FDbfFile.RecordSize+CalcFieldsSize+1);
end;

procedure TDbf.FreeRecordBuffer(var Buffer: PChar); {override virtual abstract from TDataset}
begin
  FreeMem(Buffer);
end;

procedure TDbf.GetBookmarkData(Buffer: PChar; Data: Pointer); {override virtual abstract from TDataset}
var
  pRecord: pDbfRecord;
begin
  pRecord := pDbfRecord(Buffer);
  pBookMarkData(Data)^ := pRecord.BookMarkData;
end;

function TDbf.GetBookmarkFlag(Buffer: PChar): TBookmarkFlag; {override virtual abstract from TDataset}
var
  pRecord: pDbfRecord;
begin
  pRecord := pDbfRecord(Buffer);
  Result := pRecord.BookMarkFlag;
end;

function TDbf.GetCurrentBuffer: PChar;
begin
  case State of
    dsFilter:     Result := FFilterBuffer;
    dsCalcFields: Result := @(pDbfRecord(CalcBuffer).DeletedFlag);
//    dsSetKey:     Result := FKeyBuffer;     // TO BE Implemented
  else
    if IsEmpty then
    begin
      Result := nil;
    end else begin
      Result := @(pDbfRecord(ActiveBuffer).DeletedFlag);
    end;
  end;
end;

function TDbf.GetFieldData(Field: TField; Buffer: Pointer): Boolean; {override virtual abstract from TDataset}
var
  src: PChar;
begin
  src := GetCurrentBuffer;
  if src=nil then begin
    Result := false;
    exit;
  end;

  if Field.FieldNo>0 then
  begin
    Result := FDbfFile.GetFieldData(Field.FieldNo-1, Field.DataType, Src, Buffer);
  end else begin { calculated fields.... }
    Inc(PChar(Src), Field.Offset + GetRecordSize);
//    Result := Boolean(PChar(Buffer)[0]);
    Result := true;
    if {Result and } (Src <> nil) then
    begin
      // A ftBoolean was 1 byte in Delphi 3
      // it is now 2 byte in Delphi 5
      // not sure about delphi 4.
{$ifdef DELPHI_5}
        Move(Src^, Buffer^, Field.DataSize);
{$else}
      if Field.DataType = ftBoolean then
        Move(Src^, Buffer^, 1)
      else
        Move(Src^, Buffer^, Field.DataSize);
{$endif}
    end;
  end;
end;

(*

{$ifdef DELPHI_5}

function TDbf.GetFieldData(Field: TField; Buffer: Pointer; NativeFormat: Boolean): Boolean; {overload; override;}
begin
  // we do not support concept of native / logical field types, so we don't need dataconvert
  // pretend nativeformat is true
  Result := GetFieldData(Field, Buffer);
end;

procedure TDbf.SetFieldData(Field: TField; Buffer: Pointer; NativeFormat: Boolean); {overload; override;}
begin
  // we do not support concept of native / logical field types, so we don't need dataconvert
  // pretend nativeformat is true
  SetFieldData(Field, Buffer);
end;

{$endif}

*)

procedure TDbf.DoFilterRecord(var Acceptable: Boolean);
begin
  // check filtertext
  if Length(Filter) > 0 then
    Acceptable := Boolean((FParser.ExtractFromBuffer(GetCurrentBuffer))^);

  // check user filter
  if Acceptable and Assigned(OnFilterRecord) then
    OnFilterRecord(Self, Acceptable);
end;

function TDbf.GetRecord(Buffer: PChar; GetMode: TGetMode; DoCheck: Boolean): TGetResult; {override virtual abstract from TDataset}
var
  pRecord: pDBFRecord;
  acceptable: Boolean;
  SaveState: TDataSetState;
  lPhysicalRecNo: Integer;
//  s: string;
begin
  if (FDbfFile.RecordCount<1) or (FCursor=nil) then
  begin
    Result := grEOF;
    exit;
  end;
  pRecord := pDBFRecord(Buffer);
  acceptable := false;
  repeat
    Result := grOK;
    case GetMode of
      gmCurrent :
        begin
          //if pRecord.BookmarkData.RecNo=FPhysicalRecNo then begin
          //  exit;    // try to fasten a bit...
          //end;
        end;
      gmNext :
        begin
          Acceptable := FCursor.Next;
          if Acceptable then begin
            Result := grOK;
          end else begin
            //FCursor.Last;
            Result := grEOF
          end;
        end;
      gmPrior :
        begin
          Acceptable := FCursor.Prev;
          if Acceptable then begin
            Result := grOK;
          end else begin
            //FCursor.First;
            Result := grBOF
          end;
        end;
    end;

    if (Result = grOK) then
    begin
      lPhysicalRecNo := FCursor.PhysicalRecNo;
      if (lPhysicalRecNo > FDbfFile.RecordCount) or (lPhysicalRecNo <= 0) then
      begin
        Result := grError;
      end else begin
        FDbfFile.ReadRecord(lPhysicalRecNo, @pRecord.DeletedFlag);
        acceptable := (FShowDeleted or (pRecord.DeletedFlag <> '*'))
      end;
    end;

    if (Result = grOK) and acceptable then
    begin
      if Filtered then
      begin
        FFilterBuffer := @pRecord.DeletedFlag;
        SaveState := SetTempState(dsFilter);
        DoFilterRecord(acceptable);
        RestoreState(SaveState);
      end;
    end;

    if (GetMode = gmCurrent) and not acceptable then
      Result := grError;
  until (Result <> grOK) or acceptable;

  if Result = grOK then
  begin
    ClearCalcFields(Buffer); //run automatically
    try
      GetCalcFields(Buffer);
    finally
       pRecord.BookmarkData := FCursor.GetBookMark;
       pRecord.BookmarkFlag := bfCurrent;
    end;
    if (pRecord.BookMarkData <= 0) then
       pRecord.BookmarkData := FCursor.GetBookMark;
  end else begin
    pRecord.BookmarkData := -1;
  end;
end;

function TDbf.GetRecordSize: Word; {override virtual abstract from TDataset}
begin
  Result := FDbfFile.RecordSize;
end;

procedure TDbf.InternalAddRecord(Buffer: Pointer; Append: Boolean); {override virtual abstract from TDataset}
begin
  // Nothing to do
end;

procedure TDbf.InternalClose; {override virtual abstract from TDataset}
begin
  // disconnect field objects
  BindFields(false);
  // Destroy field object (if not persistent)
  if DefaultFields then
    DestroyFields;

  if FParser <> nil then
    FreeAndNil(FParser);
  if (FDbfFile <> nil) and not FReadOnly then
    FDbfFile.WriteHeader;
  FreeAndNil(FCursor);
  if FDbfFile <> nil then
    FreeAndNil(FDbfFile);
end;

procedure TDbf.InternalCancel;
begin
  // if we have locked a record, unlock it
  if FEditingRecNo >= 0 then
  begin
    FDbfFile.UnlockPage(FEditingRecNo);
    FEditingRecNo := -1;
  end;
end;

procedure TDbf.InternalDelete; {override virtual abstract from TDataset}
var
  lRecord: pDbfRecord;
begin
  // start editing
  Edit;
  // get record pointer
  lRecord := pDbfRecord(ActiveBuffer);
  // flag we deleted this record
  lRecord.DeletedFlag := '*';
  // notify indexes this record is deleted
  FDbfFile.RecordDeleted(FEditingRecNo, @lRecord.DeletedFlag);
  // done!
  Post;
end;

procedure TDbf.InternalFirst; {override virtual abstract from TDataset}
begin
  FCursor.First;
end;

procedure TDbf.InternalGotoBookmark(Bookmark: Pointer); {override virtual abstract from TDataset}
var
  RecInfo: rBookmarkData;
begin
  RecInfo := rBookmarkData(Bookmark^);
  FCursor.GotoBookmark(RecInfo);
end;

procedure TDbf.InternalHandleException; {override virtual abstract from TDataset}
begin
{$ifdef WIN32}
  Application.HandleException(Self);
{$else}
  SysUtils.ShowException(ExceptObject, ExceptAddr);
{$endif}
end;

procedure TDbf.GetFieldDefsFromDbfFieldDefs;
var
  I, N: Integer;
  TempFieldDef: TDbfFieldDef;
  lIndex: TDbfIndexDef;
  TempMdxFile: TIndexFile;
  BaseName, lIndexName: string;
begin
  FieldDefs.Clear;

  // get all fields
  for I := 0 to FDbfFile.FieldDefs.Count - 1 do
  begin
    TempFieldDef := FDbfFile.FieldDefs.Items[I];
    // handle duplicate field names
    N:=1;
    BaseName:=TempFieldDef.FieldName;
    while FieldDefs.IndexOf(TempFieldDef.FieldName)>=0 do
    begin
      Inc(N);
      TempFieldDef.FieldName:=BaseName+IntToStr(N);
    end;
    // add field
    if TempFieldDef.FieldType in [ftString, ftBCD] then
      FieldDefs.Add(TempFieldDef.FieldName, TempFieldDef.FieldType, TempFieldDef.Size, false)
    else
      FieldDefs.Add(TempFieldDef.FieldName, TempFieldDef.FieldType, 0, false);

{$ifdef DELPHI_4}
    // AutoInc fields are readonly
    if TempFieldDef.FieldType = ftAutoInc then
      FieldDefs[I].Attributes := [Db.faReadOnly];

    // if table has dbase lock field, then hide it
    if TempFieldDef.IsLockField then
      FieldDefs[I].Attributes := [Db.faHiddenCol];
{$endif}
  end;

  if not (csDesigning in ComponentState) then
  begin
    // clear MDX index entries
    I := 0;
    while I < FIndexDefs.Count do
    begin
      // is this an MDX index?
      lIndex := FIndexDefs.Items[I];
      if Length(ExtractFileExt(lIndex.IndexFile)) = 0 then
      begin
{$ifdef DELPHI_5}
        // delete this entry
        FIndexDefs.Delete(I);
{$else}
        // does this work? I hope so :-)
        FIndexDefs.Items[I].Free;
{$endif}
      end else begin
        // NDX entry -> goto next
        Inc(I);
      end;
    end;
  end;

  // get all (new) MDX index defs
  TempMdxFile := FDbfFile.MdxFile;
  for I := 0 to FDbfFile.IndexNames.Count - 1 do
  begin
    // is this an MDX index?
    lIndexName := FDbfFile.IndexNames.Strings[I];
    if FDbfFile.IndexNames.Objects[I] = TempMdxFile then
      if FIndexDefs.GetIndexByName(lIndexName) = nil then
        TempMdxFile.GetIndexInfo(lIndexName, FIndexDefs.Add);
  end;
end;

procedure TDbf.InternalInitFieldDefs; {override virtual abstract from TDataset}
var
  MustReleaseDbfFile: Boolean;
begin
  MustReleaseDbfFile := false;
  with FieldDefs do
  begin
    if FDbfFile = nil then
    begin
      // do not AutoCreate file
      FDbfFile := TDbfFile.Create(FAbsolutePath + FTableName);
      FDbfFile.Mode := pfReadOnly;
      FDbfFile.AutoCreate := false;
      FDbfFile.DateTimeHandling := FDateTimeHandling;
      FDbfFile.OnLocaleError := FOnLocaleError;
      FDbfFile.OnIndexMissing := FOnIndexMissing;
      FDbfFile.UseFloatFields := FUseFloatFields;
      FDbfFile.Open;
      MustReleaseDbfFile := true;
    end;
    GetFieldDefsFromDbfFieldDefs;
    if MustReleaseDbfFile then
    begin
      FDbfFile.Free;
      FDbfFile := nil;
    end;
  end;
end;

procedure TDbf.InternalInitRecord(Buffer: PChar); {override virtual abstract from TDataset}
var
  pRecord: pDbfRecord;
begin
  pRecord := pDbfRecord(Buffer);
  pRecord.BookmarkData{.IndexBookmark} := 0;
  pRecord.BookmarkFlag := bfCurrent;
// Init Record with zero and set autoinc field with next value
  FDbfFile.InitRecord(@pRecord.DeletedFlag);
end;

procedure TDbf.InternalLast; {override virtual abstract from TDataset}
begin
  FCursor.Last;
end;

procedure TDbf.InternalOpen; {override virtual abstract from TDataset}
const
  DbfOpenMode: array[Boolean, Boolean] of TPagedFileMode =
    ((pfReadWriteOpen, pfExclusiveOpen), (pfReadOnly, pfReadOnly));
var
  lIndex: TDbfIndexDef;
  lIndexName: string;
  LanguageAction: TDbfLanguageAction;
  codePage: Cardinal;
  I: Integer;
begin
  // close current file
  FreeAndNil(FDbfFile);

  // does file not exist? -> create
  if not FileExists(FAbsolutePath + FTableName) and (FOpenMode in [omAutoCreate, omTemporary]) then
    CreateTable;

  // now we know for sure the file exists
  FDbfFile := TDbfFile.Create(FAbsolutePath + FTableName);
  FDbfFile.Mode := DbfOpenMode[FReadOnly{ or (csDesigning in ComponentState)}, FExclusive];
  FDbfFile.AutoCreate := false;
  FDbfFile.UseFloatFields := FUseFloatFields;
  FDbfFile.DateTimeHandling := FDateTimeHandling;
  FDbfFile.OnLocaleError := FOnLocaleError;
  FDbfFile.OnIndexMissing := FOnIndexMissing;
  FDbfFile.Open;

  // fail open?
  if FDbfFile.ForceClose then
    Abort;

  // determine dbf version
  case FDbfFile.DbfVersion of
    xBaseIII: FTableLevel := 3;
    xBaseIV:  FTableLevel := 4;
    xBaseVII: FTableLevel := 7;
  end;

  // build VCL fielddef list from native DBF FieldDefs
(*
  if (FDbfFile.HeaderSize = 0) or (FDbfFile.FieldDefs.Count = 0) then
  begin
    if FieldDefs.Count > 0 then
    begin
      CreateTableFromFieldDefs;
    end else begin
      CreateTableFromFields;
    end;
  end else begin
*)
    GetFieldDefsFromDbfFieldDefs;
//  end;

  // create the fields dynamically
  if DefaultFields then
    CreateFields; // Create fields from fielddefs.

  BindFields(true);

  // check codepage settings
  codePage := FDbfFile.CodePage;
  // if no codepage, then use default codepage
  if codePage = 0 then
    codePage := DbfGlobals.DefaultOpenCodePage;
  if codePage = GetACP then
    FTranslationMode := tmNoneNeeded
  else
  if codePage = GetOEMCP then
    FTranslationMode := tmSimple
  // check if this code page, although non default, is installed
  else
  if DbfGlobals.CodePageInstalled(codePage) then
    FTranslationMode := tmAdvanced
  else begin
    // no codepage available? ask user
    LanguageAction := laEditOnly;
    if Assigned(FOnLanguageWarning) then
      FOnLanguageWarning(Self, LanguageAction);
    case LanguageAction of
      laEditOnly: FTranslationMode := tmNoneAvailable;
      laForceOEM: FTranslationMode := tmSimple;
      laForceANSI: FTranslationMode := tmNoneNeeded;
    end;
  end;

  // open indexes
  for I := 0 to FIndexDefs.Count - 1 do
  begin
    lIndex := FIndexDefs.Items[I];
    lIndexName := ParseIndexName(lIndex.IndexFile);
    // if index does not exist -> create, if it does exist -> open only
    FDbfFile.OpenIndex(lIndexName, lIndex.SortField, false, lIndex.Options);
  end;

  // parse filter
  if Length(Filter) > 0 then
  begin
    // create parser
    FParser := TDbfParser.Create(FDbfFile);
    // parse expression
    try
      FParser.ParseExpression(Filter);
    except
      // oops, a problem with parsing, clear filter for now
      Filter := EmptyStr;
    end;
  end;

  SetIndexName(FIndexName);

// SetIndexName will have made the cursor for us if no index selected :-)
//  if FCursor = nil then FCursor := TDbfCursor.Create(FDbfFile);

  InternalFirst;

//  FDbfFile.SetIndex(FIndexName);
//  FDbfFile.FIsCursorOpen := true;
end;

function TDbf.GetCodePage: Cardinal;
begin
  Result := FDbfFile.CodePage;
end;

function TDbf.GetLanguageID: Integer;
begin
  if FDbfFile <> nil then
    Result := FDbfFile.LanguageID
  else
    Result := 0;
end;

function TDbf.GetLanguageStr: String;
begin
  if FDbfFile <> nil then
    Result := FDbfFile.LanguageStr;
end;

function TDbf.LockTable(const Wait: Boolean): Boolean;
begin
  Result := FDbfFile.LockFile(Wait);
end;

procedure TDbf.UnlockTable;
begin
  FDbfFile.UnlockFile;
end;

procedure TDbf.InternalEdit;
begin
  // store recno we are editing
  FEditingRecNo := FCursor.PhysicalRecNo;
  // try to lock this record
  FDbfFile.LockRecord(FEditingRecNo, @pDbfRecord(ActiveBuffer).DeletedFlag);
  // succeeded!
end;

procedure TDbf.InternalPost; {override virtual abstract from TDataset}
var
  pRecord: pDbfRecord;
begin
  // if internalpost is called, we know we are active
  pRecord := pDbfRecord(ActiveBuffer);
  if State = dsEdit then
  begin
    // write changes
    FDbfFile.UnlockRecord(FEditingRecNo, @pRecord.DeletedFlag);
    // not editing anymore
    FEditingRecNo := -1;
  end else begin
    // insert
    FDbfFile.Insert(@pRecord.DeletedFlag);
  end;
  // set flag that TDataSet is about to post...so we can disable resync
  FPosting := true;
end;

procedure TDbf.Resync(Mode: TResyncMode);
begin
  // try to increase speed
  if not FDisableResyncOnPost or not FPosting then
    inherited;
  // clear post flag
  FPosting := false;
end;


{$ifndef DELPHI_5}

procedure TDbf.InitFieldDefsFromFields;
var
  I: Integer;
  F: TField;
begin
  { create fielddefs from persistent fields if needed }
  for I := 0 to FieldCount - 1 do
  begin
    F := Fields[I];
    with F do
    if FieldKind = fkData then begin
      FieldDefs.Add(FieldName,DataType,Size,Required);
    end;
  end;
end;

{$endif}

procedure TDbf.CreateTableFromFields;
begin
  FieldDefs.Clear;
  InitFieldDefsFromFields;
  CreateTableFromFieldDefs;
end;

procedure TDbf.CreateTableFromFieldDefs;
var
  I: Integer;
  aDbfFieldDefs: TDbfFieldDefs;
begin
  aDbfFieldDefs := TDbfFieldDefs.Create(Self);
  aDbfFieldDefs.DbfVersion := FDbfFile.DbfVersion;
  try
    for I := 0 to FieldDefs.Count - 1 do
    begin
      with aDbfFieldDefs.AddFieldDef do
      begin
        FieldName := FieldDefs.Items[I].Name;
        FieldType := FieldDefs.Items[I].DataType;
        if FieldDefs.Items[I].Size > 0 then
        begin
          Size := FieldDefs.Items[I].Size;
          Precision := FieldDefs.Items[I].Precision;
        end else begin
          SetDefaultSize;
        end;
      end;
    end;
    FDbfFile.FinishCreate(aDbfFieldDefs, '.dbt', 512);
  finally
    aDbfFieldDefs.Free;
  end;
end;

procedure TDbf.CreateTable;
begin
  CreateTableEx(nil);
end;

procedure TDbf.CreateTableEx(DbfFieldDefs: TDbfFieldDefs);
var
  I: Integer;
  lIndex: TDbfIndexDef;
  IndexName: string;
begin
  CheckInactive;
  //  InternalInitFieldDefs;
  try
    FreeAndNil(FDbfFile);
    FDbfFile := TDbfFile.Create(FAbsolutePath + FTableName);
    FDbfFile.Mode := pfExclusiveCreate;
    FDbfFile.AutoCreate := true;
    FDbfFile.CopyDateTimeAsString := FInCopyFrom and FCopyDateTimeAsString;
    FDbfFile.OnLocaleError := FOnLocaleError;
    FDbfFile.OnIndexMissing := FOnIndexMissing;
    FDbfFile.UseFloatFields := FUseFloatFields;
    case FTableLevel of
      3: FDbfFile.DbfVersion := xBaseIII;
      7: FDbfFile.DbfVersion := xBaseVII;
    else
      {4:} FDbfFile.DbfVersion := xBaseIV;
    end;
    FDbfFile.Open;

    if DbfFieldDefs = nil then
    begin
      if FieldDefs.Count > 0 then
      begin
        CreateTableFromFieldDefs;
      end else begin
        CreateTableFromFields;
      end;
    end else begin
      FDbfFile.FinishCreate(DbfFieldDefs, '.dbt', 512);
    end;

    // create all indexes
    for I := 0 to FIndexDefs.Count-1 do
    begin
      lIndex := FIndexDefs.Items[I];
      IndexName := ParseIndexName(lIndex.IndexFile);
      FDbfFile.OpenIndex(IndexName, lIndex.SortField, true, lIndex.Options);
    end;
  finally
    FDbfFile.Free;
    FDbfFile := nil;
  end;
end;

procedure TDbf.EmptyTable;
begin
  Zap;
end;

procedure TDbf.Zap;
begin
  // are we active?
  CheckActive;
  FDbfFile.Zap;
end;

procedure TDbf.RestructureTable(DbfFieldDefs: TDbfFieldDefs; Pack: Boolean);
begin
  CheckInactive;

  // open dbf file
  FDbfFile := TDbfFile.Create(FAbsolutePath + FTableName);
  FDbfFile.Mode := pfExclusiveOpen;
  FDbfFile.AutoCreate := false;
  FDbfFile.UseFloatFields := FUseFloatFields;
  FDbfFile.OnLocaleError := FOnLocaleError;
  FDbfFile.OnIndexMissing := FOnIndexMissing;
  FDbfFile.Open;

  // do restructure
  try
    FDbfFile.RestructureTable(DbfFieldDefs, Pack);
  finally
    // close file
    FDbfFile.Free;
    FDbfFile := nil;
  end;
end;

procedure TDbf.PackTable;
begin
  CheckBrowseMode;
  FDbfFile.RestructureTable(nil, true);
end;

procedure TDbf.CopyFrom(DataSet: TDataSet; FileName: string; DateTimeAsString: Boolean; Level: Integer);
var
  I: integer;
begin
  FInCopyFrom := true;
  try
    if Active then
      Close;
    FilePath := ExtractFilePath(FileName);
    TableName := ExtractFileName(FileName);
    FCopyDateTimeAsString := DateTimeAsString;
    TableLevel := Level;
    if not DataSet.Active then
      DataSet.Open;
    DataSet.FieldDefs.Update;
    FieldDefs.Assign(DataSet.FieldDefs);
    Indexes.Clear;
    CreateTable;
    Open;
    DataSet.First;
    while not DataSet.EOF do
    begin
      Append;
      for I := 0 to Pred(FieldCount) do
      begin
        if not DataSet.Fields[I].IsNull then
        begin
          if DataSet.Fields[I].DataType = ftDateTime then
          begin
            if FCopyDateTimeAsString then
            begin
              Fields[I].AsString := DataSet.Fields[I].AsString;
              if Assigned(FOnCopyDateTimeAsString) then
                FOnCopyDateTimeAsString(Self, Fields[I], DataSet.Fields[I])
            end else
              Fields[I].AsDateTime := DataSet.Fields[I].AsDateTime;
          end else
            Fields[I].Value := DataSet.Fields[I].Value;
        end;
      end;
      Post;
      DataSet.Next;
    end;
    Close;
  finally
    FInCopyFrom := false;
  end;
end;



function TDbf.LocateRecord(const KeyFields: String; const KeyValues: Variant;
                              Options: TLocateOptions; bSyncCursor: Boolean): Boolean;
var
  lstKeys              : TList;
  iIndex               : Integer;
  ReturnBookMark       : TBookMarkStr;
  Field                : TField;
  bMatchedData         : Boolean;
  bVarIsArray          : Boolean;
  varCompare           : Variant;
  doLinSearch          : Boolean;

  function CompareValues: Boolean;
  var
    sCompare: String;
  begin
    if (Field.DataType = ftString) then
    begin
      sCompare := VarToStr(varCompare);
      if loCaseInsensitive in Options then
      begin
        Result := CompareText(Field.AsString,sCompare) = 0;
        if not Result and (iIndex = lstKeys.Count - 1) and (loPartialKey in Options) and
          (Length(sCompare) < Length(Field.AsString)) then
        begin
          if Length(sCompare) = 0 then
            Result := true
          else
            Result := CompareText (Copy (Field.AsString,1,Length (sCompare)),sCompare) = 0;
        end;
      end else begin
        Result := Field.AsString = sCompare;
        if not Result and (iIndex = lstKeys.Count - 1) and (loPartialKey in Options) and
          (Length (sCompare) < Length (Field.AsString)) then
        begin
          if Length (sCompare) = 0 then
            Result := true
          else
            Result := Copy(Field.AsString, 1, Length(sCompare)) = sCompare;
        end;
      end;
    end
    else
      Result := Field.Value = varCompare;
  end;

begin
  Result := false;
  CheckBrowseMode;

  doLinSearch := true;
  // index active?
  if FCursor is TIndexCursor then
  begin
    // matches field to search on?
    if TIndexCursor(FCursor).IndexFile.Expression = KeyFields then
    begin
      // can do index search
      doLinSearch := false;
      Result := SearchKey(KeyValues, stEqual);
    end;
  end;

  if doLinSearch then
  begin
    bVarIsArray := false;
    CursorPosChanged;
    lstKeys := TList.Create;
    try
      GetFieldList(lstKeys, KeyFields);
      if VarArrayDimCount(KeyValues) = 0 then
        bMatchedData := lstKeys.Count = 1
      else if VarArrayDimCount (KeyValues) = 1 then
      begin
        bMatchedData := VarArrayHighBound (KeyValues,1) + 1 = lstKeys.Count;
        bVarIsArray := true;
      end else
        bMatchedData := false;
      if bMatchedData then
      begin
        ReturnBookMark := BookMark;
        DisableControls;
        try
          First;
          while not Eof and not Result Do
          begin
            Result := true;
            iIndex := 0;
            while Result and (iIndex < lstKeys.Count) Do
            begin
              Field := TField (lstKeys [iIndex]);
              if bVarIsArray then
                varCompare := KeyValues [iIndex]
              else
                varCompare := KeyValues;
              Result := CompareValues;
              iIndex := iIndex + 1;
            end;
            if not Result then
              Next;
          end;

          if not Result then
            BookMark := ReturnBookMark;
        finally
          EnableControls;
        end;
      end;
    finally
      lstKeys.Free;
    end;
  end;
end;

procedure TDbf.TryExclusive;
begin
  // are we active?
  if Active then
  begin
    // already in exclusive mode?
    FDbfFile.TryExclusive;
    // update file mode
    FExclusive := FDbfFile.Mode in [pfMemory..pfExclusiveOpen];
    FReadOnly := FDbfFile.Mode = pfReadOnly;
  end else begin
    // just set exclusive to true
    FExclusive := true;
    FReadOnly := false;
  end;
end;

procedure TDbf.EndExclusive;
begin
  if Active then
  begin
    // call file handler
    FDbfFile.EndExclusive;
    // update file mode
    FExclusive := FDbfFile.Mode in [pfMemory..pfExclusiveOpen];
    FReadOnly := FDbfFile.Mode = pfReadOnly;
  end else begin
    // just set exclusive to false
    FExclusive := false;
  end;
end;

function TDbf.Locate(const KeyFields: string; const KeyValues: Variant; Options: TLocateOptions): Boolean;
begin
  DoBeforeScroll;
  Result := LocateRecord(KeyFields, KeyValues, Options, true);
  if Result then
    DoAfterScroll;
end;

function TDbf.CreateBlobStream(Field: TField; Mode: TBlobStreamMode): TStream; {override virtual}
var
  Memoi: array[1..32] of Char;
  lBlob: TDbfBlobStream;
begin
  lBlob := TDbfBlobStream.Create(Mode, Field);
  if FDbfFile.GetFieldData(Field.FieldNo-1, ftString, GetCurrentBuffer, @Memoi[1]) then
  begin
    lBlob.MemoRecNo := StrToIntDef(Memoi,0);
    FDbfFile.DbtFile.ReadMemo(lBlob.MemoRecNo,lBlob);
    lBlob.ReadSize := lBlob.Size;
    lBlob.Translate(false);
  end else lBlob.MemoRecNo := 0;
  Result := lBlob;
end;

{$ifdef DELPHI_4}

function TDbf.Translate(Src, Dest: PChar; ToOem: Boolean): Integer; {override virtual}
var
  WideCharStr: array[0..1023] of WideChar;
  FromCP, ToCP, srcLen, wideBytes: Cardinal;
begin
  if (Src <> nil) and (Dest <> nil) then
  begin
    if Assigned(FOnTranslate) then
    begin
      Result := FOnTranslate(Self, Src, Dest, ToOem);
    end else begin
      Result := -1;
      case FTranslationMode of
        tmSimple:
          if not ToOem then
            OemToChar(Src, Dest)
          else
            CharToOem(Src, Dest);
        tmAdvanced:
          begin
            if ToOem then
            begin
              FromCP := GetACP;
              ToCP := FDbfFile.CodePage;
            end else begin
              FromCP := FDbfFile.CodePage;
              ToCP := GetACP;
            end;
            // does this work on Win95/98/ME?
            srcLen := StrLen(Src);
            wideBytes := MultiByteToWideChar(FromCP, MB_PRECOMPOSED, Src, srcLen, WideCharStr, 1024);
            Result := WideCharToMultiByte(ToCP, 0, WideCharStr, wideBytes, Dest, srcLen, nil, nil);
          end;
      else
        if Src <> Dest then
          StrCopy(Dest, Src);
      end;
    end;
    if Result = -1 then
      Result := StrLen(Dest);
  end else
    Result := 0;
end;


{$else}

procedure TDbf.Translate(Src, Dest: PChar; ToOem: Boolean); {override virtual}
var
  FromCP, ToCP, srcLen: Cardinal;
begin
  if (Src <> nil) and (Dest <> nil) then
  begin
    if Assigned(FOnTranslate) then
    begin
      FOnTranslate(Self, Src, Dest, ToOem);
    end else begin
      case FTranslationMode of
        tmSimple, tmAdvanced:
          begin
            if not ToOem then
              OemToChar(Src, Dest)
            else
              CharToOem(Src, Dest);
          end;
      else
        if Src <> Dest then
          StrCopy(Dest, Src);
      end;
    end;
  end;
end;

{$endif}

procedure TDbf.ClearCalcFields(Buffer: PChar);
var
  realbuff,calcbuff: PChar;
begin
  realbuff := @pDbfRecord(Buffer).DeletedFlag;
  calcbuff := realbuff + FDbfFile.RecordSize;
  FillChar(calcbuff^, CalcFieldsSize,0);
end;

procedure TDbf.InternalSetToRecord(Buffer: PChar); {override virtual abstract from TDataset}
var
  pRecord: pDbfRecord;
begin
  if Buffer <> nil then
  begin
    pRecord := pDbfRecord(Buffer);
    if pRecord.BookMarkFlag = bfInserted then
    begin
      // do what ???
    end else begin
      FCursor.GotoBookmark(pRecord.BookmarkData);
    end;
  end;
end;

function TDbf.IsCursorOpen: Boolean; {override virtual abstract from TDataset}
begin
  Result := FCursor <> nil;
end;

procedure TDbf.SetBookmarkFlag(Buffer: PChar; Value: TBookmarkFlag); {override virtual abstract from TDataset}
var
  pRecord: pDbfRecord;
begin
  pRecord := pDbfRecord(Buffer);
  pRecord.BookMarkFlag := Value;
end;

procedure TDbf.SetBookmarkData(Buffer: PChar; Data: Pointer); {override virtual abstract from TDataset}
var
  pRecord: pDbfRecord;
begin
  pRecord := pDbfRecord(Buffer);
  pRecord.BookMarkData := pBookMarkData(Data)^;
end;

procedure TDbf.SetFieldData(Field: TField; Buffer: Pointer); {override virtual abstract from TDataset}
var
  pRecord: pDbfRecord;
  Dst: Pointer;
begin
  if (Field.FieldNo >= 0) then
  begin
    pRecord := pDbfRecord(ActiveBuffer);
    dst := @pRecord.DeletedFlag;
    FDbfFile.SetFieldData(Field.FieldNo - 1,Field.DataType,Buffer,Dst);
  end else begin    { ***** fkCalculated, fkLookup ***** }
    pRecord := pDbfRecord(CalcBuffer);
    Dst := @pRecord.DeletedFlag;
    Inc(Integer(Dst), RecordSize + Field.Offset);
//    Boolean(dst^) := LongBool(Buffer);
//    if Boolean(dst^) then begin
//      Inc(Integer(dst), 1);
      Move(Buffer^, Dst^, Field.DataSize);
//    end;
  end;     { end of ***** fkCalculated, fkLookup ***** }
  if not (State in [dsCalcFields, dsFilter, dsNewValue]) then begin
    DataEvent(deFieldChange, Longint(Field));
  end;
end;

// this function does not count deleted records
// warning: is very slow, compared to GetRecordCount
function TDbf.GetExactRecordCount: Integer;
var
  prevRecNo: Integer;
  tempRecord: rDBFRecord;
  getRes: TGetResult;
begin
  // init vars
  Result := 0;
  // store current position
  prevRecNo := FCursor.SequentialRecNo;
  FCursor.First;
  repeat
    // repeatedly retrieve next record until eof encountered
    getRes := GetRecord(PChar(@tempRecord), gmNext, true);
    if getRes = grOk then
      inc(Result);
  until getRes <> grOk;
  // restore current position
  FCursor.SequentialRecNo := prevRecNo;
end;

// this function is just for the grid scrollbars
// it doesn't have to be perfectly accurate, but fast.
function TDbf.GetRecordCount: Integer; {override virtual}
begin
  Result := FCursor.SequentialRecordCount;
end;

// this function is just for the grid scrollbars
// it doesn't have to be perfectly accurate, but fast.
function TDbf.GetRecNo: Integer; {override virtual}
begin
  UpdateCursorPos;
  Result := FCursor.SequentialRecNo;
end;

procedure TDbf.SetRecNo(Value: Integer); {override virual}
begin
  FCursor.SequentialRecNo := Value;
  Resync([]);
end;

function TDbf.GetCanModify: Boolean; {override;}
begin
  if FReadOnly or (csDesigning in ComponentState) then
    Result := false
  else
    Result := FTranslationMode > tmNoneAvailable;
end;

procedure TDbf.SetFilterText(const Value: String);
begin
  // parser created?
  if Length(Value) > 0 then
  begin
    if (FParser = nil) and (FDbfFile <> nil) then
      FParser := TDbfParser.Create(FDbfFile);

    // parse expression
    if FParser <> nil then
      FParser.ParseExpression(Value);
  end;

  // call dataset method
  inherited;

  // refilter dataset if filtered
  if (FDbfFile <> nil) and Filtered then Resync([]);
end;

procedure TDbf.SetFiltered(Value: Boolean); {override;}
begin
  // pass on to ancestor
  inherited;

  // only refresh if active
  if FCursor <> nil then
    Resync([]);
end;

procedure TDbf.SetRelativePath(const Value: string);
begin
  CheckInactive;
  FRelativePath := Value;
  if Length(Value) > 0 then
    FRelativePath := IncludeTrailingPathDelimiter(FRelativePath);
  FAbsolutePath := GetCompletePath(ExtractFilePath(
{$ifdef WIN32}
    Application.ExeName
{$else}
    ParamStr(0)
{$endif}
    ), FRelativePath);
end;

procedure TDbf.SetTableName(const s: string);
var
  lPath: string;
begin
  FTableName := ExtractFileName(s);
  lPath := ExtractFilePath(s);
  if (Length(lPath) > 0) then
    FilePath := lPath;
end;

procedure TDbf.SetDbfIndexes(const Value: TDbfIndexDefs);
begin
  FIndexDefs.Assign(Value);
end;

procedure TDbf.SetTableLevel(const NewLevel: Integer);
begin
  // can only assign tablelevel if we still have to open a table
  CheckInactive;
  FTableLevel := NewLevel;
end;

function TDbf.GetIndexName: string;
begin
  Result := FIndexName;
end;

function TDbf.CompareBookmarks(Bookmark1, Bookmark2: TBookmark): Integer;
const
  RetCodes: array[Boolean, Boolean] of ShortInt = ((2,-1),(1,0));
var
  b1,b2: Integer;
begin
  // Check for uninitialized bookmarks
  Result := RetCodes[Bookmark1 = nil, Bookmark2 = nil];
  if (Result = 2) then
  begin
    b1 := PInteger(Bookmark1)^;
    b2 := PInteger(Bookmark2)^;
    if b1 < b2 then Result := -1
    else if b1 > b2 then Result := 1
    else Result := 0;
  end;
end;

function TDbf.GetVersion: string;
begin
//  Result := IntToStr(_MAJOR_VERSION) + '.' + IntToStr(_MINOR_VERSION);
  Result := Format('%d.%02d', [_MAJOR_VERSION, _MINOR_VERSION]);
end;

procedure TDbf.SetVersion(const S: string);
begin
  // What an idea...
end;

function TDbf.ParseIndexName(const AIndexName: string): string;
begin
  // if no ext, then it is a MDX tag, get complete only if it is a filename
  // MDX: get first 10 characters only
  if Length(ExtractFileExt(AIndexName)) > 0 then
    Result := GetCompleteFileName(FAbsolutePath, AIndexName)
  else
    Result := Copy(AIndexName, 1, 10);
end;

procedure TDbf.RegenerateIndexes;
begin
  CheckBrowseMode;
  FDbfFile.RegenerateIndexes;
end;

{$ifdef DELPHI_5}
procedure TDbf.AddIndex(const AIndexName, Fields: String; Options: TIndexOptions; const DescFields: String='');
{$else}
procedure TDbf.AddIndex(const AIndexName, Fields: String; Options: TIndexOptions);
{$endif}
var
  lIndexFileName: string;
begin
  CheckActive;
  lIndexFileName := ParseIndexName(AIndexName);
  FDbfFile.OpenIndex(lIndexFileName, Fields, true, Options);
end;

procedure TDbf.SetIndexName(AIndexName: string);
var
  RecNo: Integer;
begin
  FIndexName := AIndexName;
  if FDbfFile = nil then
    exit;

  // get accompanying index file
  AIndexName := ParseIndexName(AIndexName);
  FIndexFile := FDbfFile.GetIndexByName(AIndexName);
  // store current recno
  if FCursor = nil then
    RecNo := 1
  else
    RecNo := FCursor.PhysicalRecNo;
  // select new cursor
  if FIndexFile <> nil then
  begin
    FreeAndNil(FCursor);
    FCursor := TIndexCursor.Create(FIndexFile);
    // select index
    FIndexFile.IndexName := AIndexName;
    // check if can activate master link
    CheckMasterRange;
  end else begin
    FreeAndNil(FCursor);
    FCursor := TDbfCursor.Create(FDbfFile);
  end;
  // reset previous recno
  FCursor.PhysicalRecNo := RecNo;
  // refresh records
  if State = dsBrowse then
    Refresh;
end;

procedure TDbf.DeleteIndex(const AIndexName: string);
var
  lIndexFileName: string;
begin
  // extract absolute path if NDX file
  lIndexFileName := ParseIndexName(AIndexName);
  // try to delete index
  FDbfFile.DeleteIndex(lIndexFileName);
//    raise EDbfError.CreateFmt(STRING_INDEX_NOT_EXIST, [AIndexName]);
end;

procedure TDbf.OpenIndexFile(IndexFile: string);
var
  lIndexFileName: string;
begin
  CheckActive;
  // make absolute path
  lIndexFileName := GetCompleteFileName(FAbsolutePath, IndexFile);
  // open index
  FDbfFile.OpenIndex(lIndexFileName, '', false, []);
end;

procedure TDbf.CloseIndexFile(const AIndexName: string);
var
  lIndexFileName: string;
begin
  CheckActive;
  // make absolute path
  lIndexFileName := GetCompleteFileName(FAbsolutePath, AIndexName);
  // close this index
  FDbfFile.CloseIndex(lIndexFileName);
end;

procedure TDbf.RepageIndexFile(const AIndexFile: string);
begin
  FDbfFile.RepageIndex(ParseIndexName(AIndexFile));
end;

procedure TDbf.GetIndexNames(Strings: TStrings);
var
  SR: TSearchRec;
begin
  CheckActive;
  if FDbfFile.MdxFile <> nil then
    Strings.Assign(DbfFile.IndexNames)
  else
  begin
    if SysUtils.FindFirst(IncludeTrailingPathDelimiter(ExtractFilePath(FDbfFile.FileName))
          + '*.NDX', faAnyFile, SR) = 0 then
    begin
      repeat
        Strings.Add(SR.Name);
      until SysUtils.FindNext(SR)<>0;
      SysUtils.FindClose(SR);
    end;
  end;
end;

function TDbf.GetPhysicalRecNo: Integer;
begin
  // check if active, test state: if inserting, then -1
  if (FCursor <> nil) and (State <> dsInsert) then
    Result := FCursor.PhysicalRecNo
  else
    Result := -1;
end;

procedure TDbf.SetPhysicalRecNo(const NewRecNo: Integer);
begin
  // active?
  if FCursor <> nil then
  begin
    // editing?
    CheckBrowseMode;
    // set recno
    FCursor.PhysicalRecNo := NewRecNo;
    // refresh data controls
    Resync([]);
  end;
end;

function TDbf.GetDbfFieldDefs: TDbfFieldDefs;
begin
  if FDbfFile <> nil then
    Result := FDbfFile.FieldDefs
  else
    Result := nil;
end;

procedure TDbf.SetShowDeleted(Value: Boolean);
begin
  // test if changed
  if Value <> FShowDeleted then
  begin
    // store new value
    FShowDeleted := Value;
    // refresh view only if active
    if FCursor <> nil then
      Resync([]);
  end;
end;

function TDbf.IsDeleted: Boolean;
var
  src: PChar;
begin
  src := GetCurrentBuffer;
  IsDeleted := (src=nil) or (src^ = '*')
end;

procedure TDbf.Undelete;
var
  src: PChar;
begin
  if State <> dsEdit then
    inherited Edit;
  // get active buffer
  src := GetCurrentBuffer;
  if (src <> nil) and (src^ = '*') then
  begin
    // notify indexes record is about to be recalled
    FDbfFile.RecordRecalled(FCursor.PhysicalRecNo, src);
    // recall record
    src^ := ' ';
    FDbfFile.WriteRecord(FCursor.PhysicalRecNo, src);
  end;
end;

procedure TDbf.CancelRange;
begin
  if FIndexFile = nil then
    exit;

  // disable current range if any
  TIndexCursor(FCursor).CancelRange;
  // refresh
  Refresh;
end;

procedure TDbf.SetRangeBuffer(LowRange: PChar; HighRange: PChar);
var
  Result: Boolean;
begin
  if FIndexFile = nil then
    exit;

  // disable current range if any
  TIndexCursor(FCursor).CancelRange;
  // search lower bound
  Result := TIndexCursor(FCursor).SearchKey(LowRange, stGreaterEqual);
  if not Result then
  begin
    // not found? -> make empty range
    FCursor.Last;
  end;
  // set lower bound
  TIndexCursor(FCursor).SetBracketLow;
  // search upper bound
  Result := TIndexCursor(FCursor).SearchKey(HighRange, stGreater);
  // if result true, then need to get previous item <=>
  //    last of equal/lower than key
  if Result then
  begin
    Result := FCursor.Prev;
    if not Result then
    begin
      // cannot go prev -> empty range
      FCursor.First;
    end;
  end else begin
    // not found -> EOF found, go EOF, then to last record
    FCursor.Last;
    FCursor.Prev;
  end;
  // set upper bound
  TIndexCursor(FCursor).SetBracketHigh;
  // go to first in this range
  if Active then
    inherited First;
end;

{.$ifdef DELPHI_4}

procedure TDbf.SetRange(LowRange: Variant; HighRange: Variant);
var
  LowPtr, HighPtr: PChar;
  LowDouble, HighDouble: Double;
  LowString, HighString: String;
begin
  if FIndexFile = nil then
    exit;

  // convert to pchars
  LowPtr  := TIndexCursor(FCursor).VariantToBuffer(LowRange,  @LowDouble,  @LowString);
  HighPtr := TIndexCursor(FCursor).VariantToBuffer(HighRange, @HighDouble, @HighString);
  SetRangeBuffer(LowPtr, HighPtr);
end;

{.$endif}

procedure TDbf.SetRangePChar(LowRange: PChar; HighRange: PChar);
var
  LowPtr, HighPtr: PChar;
  LowStringBuf, HighStringBuf: array [0..100] of Char;
begin
  if FIndexFile = nil then
    exit;

  // convert to pchars
  LowPtr  := TIndexCursor(FCursor).CheckUserKey(LowRange,  @LowStringBuf[0]);
  HighPtr := TIndexCursor(FCursor).CheckUserKey(HighRange, @HighStringBuf[0]);
  SetRangeBuffer(LowPtr, HighPtr);
end;

{.$ifdef DELPHI_4}

function TDbf.SearchKey(Key: Variant; SearchType: TSearchKeyType): Boolean;
var
  TempDouble: Double;
  TempString: String;
begin
  if FIndexFile = nil then
  begin
    Result := false;
    exit;
  end;

  Result := SearchKeyBuffer(TIndexCursor(FCursor).VariantToBuffer(Key, @TempDouble, @TempString), SearchType);
end;

{.$endif}

function TDbf.SearchKeyPChar(Key: PChar; SearchType: TSearchKeyType): Boolean;
var
  StringBuf: array [0..100] of Char;
begin
  if FIndexFile = nil then
  begin
    Result := false;
    exit;
  end;

  Result := SearchKeyBuffer(TIndexCursor(FCursor).CheckUserKey(Key, @StringBuf[0]), SearchType);
end;

function TDbf.SearchKeyBuffer(Buffer: PChar; SearchType: TSearchKeyType): Boolean;
begin
  if FIndexFile = nil then
  begin
    Result := false;
    exit;
  end;

  Result := TIndexCursor(FCursor).SearchKey(Buffer, SearchType);
  { if found, then retrieve new current record }
  if Result then
    Refresh;
end;

procedure TDbf.UpdateIndexDefs;
begin
  FieldDefs.Update;
end;

{ Master / Detail }

procedure TDbf.CheckMasterRange;
begin
  if FMasterLink.Active and FMasterLink.ValidExpression and (IndexName <> EmptyStr) then
    UpdateRange;
end;

procedure TDbf.UpdateRange;
var
  fieldsVal: PChar;
begin
  fieldsVal := FMasterLink.FieldsVal;
  fieldsVal := TIndexCursor(FCursor).IndexFile.PrepareKey(fieldsVal, FMasterLink.Parser.ResultType);
  SetRangeBuffer(fieldsVal, fieldsVal);
end;

procedure TDbf.MasterChanged(Sender: TObject);
begin
  CheckBrowseMode;
  CheckMasterRange;
end;

procedure TDbf.MasterDisabled(Sender: TObject);
begin
  CancelRange;
end;

function TDbf.GetDataSource: TDataSource;
begin
  Result := FMasterLink.DataSource;
end;

procedure TDbf.SetDataSource(Value: TDataSource);
begin
  if IsLinkedTo(Value) then
  begin
{$ifdef DELPHI_4}
    DatabaseError(SCircularDataLink, Self);
{$else}
    DatabaseError(SCircularDataLink);
{$endif}
  end;
  FMasterLink.DataSource := Value;
end;

function TDbf.GetMasterFields: string;
begin
  Result := FMasterLink.FieldNames;
end;

procedure TDbf.SetMasterFields(const Value: string);
begin
  FMasterLink.FieldNames := Value;
end;

//==========================================================
//============ TDbfIndexDefs
//==========================================================
constructor TDbfIndexDefs.Create(AOwner: TDbf);
begin
  inherited Create(TDbfIndexDef);
  FOwner := AOwner;
end;

function TDbfIndexDefs.Add: TDbfIndexDef;
begin
  Result := TDbfIndexDef(inherited Add);
end;

procedure TDbfIndexDefs.SetItem(N: Integer; Value: TDbfIndexDef);
begin
  inherited SetItem(N, Value);
end;

function TDbfIndexDefs.GetItem(N: Integer): TDbfIndexDef;
begin
  Result := TDbfIndexDef(inherited GetItem(N));
end;

function TDbfIndexDefs.GetOwner: tpersistent;
begin
  Result := FOwner;
end;

function TDbfIndexDefs.GetIndexByName(const Name: string): TDbfIndexDef;
var
  I: Integer;
  lIndex: TDbfIndexDef;
begin
  for I := 0 to Count-1 do
  begin
    lIndex := Items[I];
    if lIndex.IndexFile = Name then
    begin
      Result := lIndex;
      exit;
    end
  end;
  Result := nil;
end;

procedure TDbfIndexDefs.Update;
begin
  if Assigned(FOwner) then
    FOwner.UpdateIndexDefs;
end;

//==========================================================
//============ TDbfMasterLink
//==========================================================

constructor TDbfMasterLink.Create(ADataSet: TDbf);
begin
  inherited Create;

  FDetailDataSet := ADataSet;
  FParser := TDbfParser.Create(nil);
  FValidExpression := false;
end;

destructor TDbfMasterLink.Destroy;
begin
  FParser.Free;

  inherited;
end;

procedure TDbfMasterLink.ActiveChanged;
begin
  if Active and (FFieldNames <> EmptyStr) then
  begin
    FValidExpression := false;
    FParser.DbfFile := TDbf(DataSet).DbfFile;
    FParser.ParseExpression(FFieldNames);
    FValidExpression := true;
  end else begin
    FParser.ClearExpressions;
    FValidExpression := false;
  end;

  if FDetailDataSet.Active and not (csDestroying in FDetailDataSet.ComponentState) then
    if Active then
    begin
      if Assigned(FOnMasterChange) then FOnMasterChange(Self);
    end else
      if Assigned(FOnMasterDisable) then FOnMasterDisable(Self);
end;

procedure TDbfMasterLink.CheckBrowseMode;
begin
  if FDetailDataSet.Active then
    FDetailDataSet.CheckBrowseMode;
end;

procedure TDbfMasterLink.LayoutChanged;
begin
  ActiveChanged;
end;

procedure TDbfMasterLink.RecordChanged(Field: TField);
begin
  if (DataSource.State <> dsSetKey) and FDetailDataSet.Active and Assigned(FOnMasterChange) then
    FOnMasterChange(Self);
end;

procedure TDbfMasterLink.SetFieldNames(const Value: string);
begin
  if FFieldNames <> Value then
  begin
    FFieldNames := Value;
    ActiveChanged;
  end;
end;

function TDbfMasterLink.GetFieldsVal: PChar;
begin
  Result := FParser.ExtractFromBuffer(@pDbfRecord(TDbf(DataSet).ActiveBuffer).DeletedFlag);
end;


////////////////////////////////////////////////////////////////////////////

end.


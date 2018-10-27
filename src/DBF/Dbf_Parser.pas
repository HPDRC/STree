unit Dbf_Parser;

interface

{$I Dbf_Common.inc}

uses
  SysUtils,
  Classes,
  Db,
  Dbf_PrsCore,
  Dbf_Common,
  Dbf_Fields,
  Dbf_PrsDef;

type

  TDbfParser = class(TCustomExpressionParser)
  private
    FDbfFile: Pointer;
    FFieldVarList: TStringList;
    FCurrentExpression: string;
    FResultLen: Integer;
    FIsExpression: Boolean;       // expression or field?
    FFieldType: TVarType;

  protected
    procedure FillExpressList; override;
    procedure HandleUnknownVariable(VarName: string); override;
    function  GetVariableInfo(VarName: string): TDbfFieldDef;
    function  CurrentExpression: string; override;
    function  GetResultType: TVarType; override;
  public
    constructor Create(ADbfFile: Pointer);
    destructor Destroy; override;

    procedure ClearExpressions; override;

    procedure ParseExpression(Expression: string); virtual;
    function ExtractFromBuffer(Buffer: PChar): PChar; virtual;

    property DbfFile: Pointer read FDbfFile write FDbfFile;
    property Expression: string read FCurrentExpression;
    property ResultLen: Integer read FResultLen;
  end;

implementation

uses
  Dbf,
  Dbf_DbfFile,
  Dbf_Str;

type
// TFieldVar aids in retrieving field values from records
// in their proper type

  TFieldVar = class(TObject)
  private
    FFieldDef: TDbfFieldDef;
    FDbfFile: TDbfFile;
  protected
    function GetFieldVal: Pointer; virtual; abstract;
    function GetFieldType: TVarType; virtual; abstract;
  public
    constructor Create(UseFieldDef: TDbfFieldDef; ADbfFile: TDbfFile);

    procedure Refresh(Buffer: PChar); virtual; abstract;

    property FieldVal: Pointer read GetFieldVal;
    property FieldDef: TDbfFieldDef read FFieldDef;
    property FieldType: TVarType read GetFieldType;
    property DbfFile: TDbfFile read FDbfFile;
  end;

  TStringFieldVar = class(TFieldVar)
  private
    FFieldVal: PChar;
  protected
    function GetFieldVal: Pointer; override;
    function GetFieldType: TVarType; override;
  public
    constructor Create(UseFieldDef: TDbfFieldDef; ADbfFile: TDbfFile);

    procedure Refresh(Buffer: PChar); override;
  end;

  TFloatFieldVar = class(TFieldVar)
  private
    FFieldVal: Double;
  protected
    function GetFieldVal: Pointer; override;
    function GetFieldType: TVarType; override;
  public
    constructor Create(UseFieldDef: TDbfFieldDef; ADbfFile: TDbfFile);

    procedure Refresh(Buffer: PChar); override;
  end;

  TIntegerFieldVar = class(TFieldVar)
  private
    FFieldVal: Integer;
  protected
    function GetFieldVal: Pointer; override;
    function GetFieldType: TVarType; override;
  public
    constructor Create(UseFieldDef: TDbfFieldDef; ADbfFile: TDbfFile);

    procedure Refresh(Buffer: PChar); override;
  end;

{
  TSmallIntFieldVar = class(TFieldVar)
  private
    FFieldVal: SmallInt;
  protected
    function GetFieldVal: Pointer; override;
    function GetFieldType: TVarType; override;
  public
    constructor Create(UseFieldDef: TDbfFieldDef; ADbfFile: TDbfFile);

    procedure Refresh(Buffer: PChar); override;
  end;
}

{$ifdef DELPHI_4}
  TLargeIntFieldVar = class(TFieldVar)
  private
    FFieldVal: Int64;
  protected
    function GetFieldVal: Pointer; override;
    function GetFieldType: TVarType; override;
  public
    constructor Create(UseFieldDef: TDbfFieldDef; ADbfFile: TDbfFile);

    procedure Refresh(Buffer: PChar); override;
  end;
{$endif}

  TBooleanFieldVar = class(TFieldVar)
  private
    FFieldVal: Boolean;
  protected
    function GetFieldVal: Pointer; override;
    function GetFieldType: TVarType; override;
  public
    constructor Create(UseFieldDef: TDbfFieldDef; ADbfFile: TDbfFile);

    procedure Refresh(Buffer: PChar); override;
  end;

  TDateTimeFieldVar = class(TFieldVar)
  private
    FFieldVal: TDateTime;
    function GetFieldType: TVarType; override;
  protected
    function GetFieldVal: Pointer; override;
  public
    constructor Create(UseFieldDef: TDbfFieldDef; ADbfFile: TDbfFile);

    procedure Refresh(Buffer: PChar); override;
  end;

//--TFieldVar----------------------------------------------------------------
constructor TFieldVar.Create(UseFieldDef: TDbfFieldDef; ADbfFile: TDbfFile);
begin
  inherited Create;

  // store field
  FFieldDef := UseFieldDef;
  FDbfFile := ADbfFile;
end;

//--TStringFieldVar----------------------------------------------------------
constructor TStringFieldVar.Create(UseFieldDef: TDbfFieldDef; ADbfFile: TDbfFile);
begin
  inherited;
end;

function TStringFieldVar.GetFieldVal: Pointer;
begin
  Result := @FFieldVal;
end;

function TStringFieldVar.GetFieldType: TVarType;
begin
  Result := vtString;
end;

procedure TStringFieldVar.Refresh(Buffer: PChar);
begin
  FFieldVal := Buffer + FieldDef.Offset;
end;

//--TFloatFieldVar-----------------------------------------------------------
constructor TFloatFieldVar.Create(UseFieldDef: TDbfFieldDef; ADbfFile: TDbfFile);
begin
  inherited;
end;

function TFloatFieldVar.GetFieldVal: Pointer;
begin
  Result := @FFieldVal;
end;

function TFloatFieldVar.GetFieldType: TVarType;
begin
  Result := vtFloat;
end;

procedure TFloatFieldVar.Refresh(Buffer: PChar);
begin
  // database width is default 64-bit double
  if not FDbfFile.GetFieldDataFromDef(FieldDef, FieldDef.FieldType, Buffer, @FFieldVal) then
    FFieldVal := 0.0;
end;

//--TIntegerFieldVar----------------------------------------------------------
constructor TIntegerFieldVar.Create(UseFieldDef: TDbfFieldDef; ADbfFile: TDbfFile);
begin
  inherited;
end;

function TIntegerFieldVar.GetFieldVal: Pointer;
begin
  Result := @FFieldVal;
end;

function TIntegerFieldVar.GetFieldType: TVarType;
begin
  Result := vtInteger;
end;

procedure TIntegerFieldVar.Refresh(Buffer: PChar);
begin
  FFieldVal := 0;
  FDbfFile.GetFieldDataFromDef(FieldDef, FieldDef.FieldType, Buffer, @FFieldVal);
end;

{
//--TSmallIntFieldVar----------------------------------------------------------
constructor TSmallIntFieldVar.Create(UseFieldDef: TDbfFieldDef; ADbfFile: TDbfFile);
begin
  inherited;
end;

function TSmallIntFieldVar.GetFieldVal: Pointer;
begin
  Result := @FFieldVal;
end;

function TSmallIntFieldVar.GetFieldType: TVarType;
begin
  Result := vtSmallInt;
end;

procedure TSmallIntFieldVar.Refresh(Buffer: PChar);
begin
  if not FDbfFile.GetFieldDataFromDef(FieldDef, FieldDef.FieldType, Buffer, @FFieldVal) then
    FFieldVal := 0;
end;
}

{$ifdef DELPHI_4}

//--TLargeIntFieldVar----------------------------------------------------------
constructor TLargeIntFieldVar.Create(UseFieldDef: TDbfFieldDef; ADbfFile: TDbfFile);
begin
  inherited;
end;

function TLargeIntFieldVar.GetFieldVal: Pointer;
begin
  Result := @FFieldVal;
end;

function TLargeIntFieldVar.GetFieldType: TVarType;
begin
  Result := vtLargeInt;
end;

procedure TLargeIntFieldVar.Refresh(Buffer: PChar);
begin
  if not FDbfFile.GetFieldDataFromDef(FieldDef, FieldDef.FieldType, Buffer, @FFieldVal) then
    FFieldVal := 0;
end;

{$endif}

//--TBooleanFieldVar----------------------------------------------------------
constructor TBooleanFieldVar.Create(UseFieldDef: TDbfFieldDef; ADbfFile: TDbfFile);
begin
  inherited;
end;

function TBooleanFieldVar.GetFieldVal: Pointer;
begin
  Result := @FFieldVal;
end;

function TBooleanFieldVar.GetFieldType: TVarType;
begin
  Result := vtBoolean;
end;

procedure TBooleanFieldVar.Refresh(Buffer: PChar);
begin
  if not FDbfFile.GetFieldDataFromDef(FieldDef, FieldDef.FieldType, Buffer, @FFieldVal) then
    FFieldVal := false;
end;

//--TDateTimeFieldVar---------------------------------------------------------
constructor TDateTimeFieldVar.Create(UseFieldDef: TDbfFieldDef; ADbfFile: TDbfFile);
begin
  inherited;
end;

function TDateTimeFieldVar.GetFieldVal: Pointer;
begin
  Result := @FFieldVal;
end;

function TDateTimeFieldVar.GetFieldType: TVarType;
begin
  Result := vtDateTime;
end;

procedure TDateTimeFieldVar.Refresh(Buffer: PChar);
begin
  if not FDbfFile.GetFieldDataFromDef(FieldDef, FieldDef.FieldType, Buffer, @FFieldVal) then
    FFieldVal := 0.0;
end;

//--Expression functions-----------------------------------------------------

procedure FuncFloatToStr(Param: PExpressionRec);
var
  width, numDigits, resWidth: Integer;
  extVal: Extended;
begin
  with Param^ do
  begin
    // get params;
    numDigits := 0;
    if Args[1] <> nil then
      width := PInteger(Args[1])^
    else
      width := 18;
    if Args[2] <> nil then
      numDigits := PInteger(Args[2])^;
    // convert to string
    Res.AssureSpace(width);
    extVal := PDouble(Args[0])^;
    resWidth := FloatToText(Res.MemoryPos^, extVal, fvExtended, ffFixed, 18, numDigits);
    // always use dot as decimal separator
    if numDigits > 0 then
      Res.MemoryPos^[resWidth-numDigits-1] := '.';
    // result width smaller than requested width? -> add space to compensate
    if (Args[1] <> nil) and (resWidth < width) then
    begin
      // move string so that it's right-aligned
      Move(Res.MemoryPos^^, (Res.MemoryPos^)[width-resWidth], resWidth);
      // fill gap with spaces
      FillChar(Res.MemoryPos^^, width-resWidth, ' ');
      // resWidth has been padded, update
      resWidth := width;
    end else if resWidth > width then begin
      // result width more than requested width, cut
      resWidth := width;
    end;
    // advance pointer
    Inc(Res.MemoryPos^, resWidth);
    // null-terminate
    Res.MemoryPos^^ := #0;
  end;
end;

procedure FuncIntToStr_Gen(Param: PExpressionRec; Val: Integer);
var
  width: Integer;
begin
  with Param^ do
  begin
    // width specified?
    if Args[1] <> nil then
    begin
      // convert to string
      width := PInteger(Args[1])^;
      GetStrFromInt_Width(Val, width, Res.MemoryPos^);
      // advance pointer
      Inc(Res.MemoryPos^, width);
      // need to add decimal?
      if Args[2] <> nil then
      begin
        // get number of digits
        width := PInteger(Args[2])^;
        // add decimal dot
        Res.MemoryPos^^ := '.';
        Inc(Res.MemoryPos^);
        // add zeroes
        FillChar(Res.MemoryPos^^, width, '0');
        // go to end
        Inc(Res.MemoryPos^, width);
      end;
    end else begin
      // convert to string
      width := GetStrFromInt(Val, Res.MemoryPos^);
      // advance pointer
      Inc(Param.Res.MemoryPos^, width);
    end;
    // null-terminate
    Res.MemoryPos^^ := #0;
  end;
end;

{
procedure FuncSmallIntToStr(Param: PExpressionRec);
begin
  FuncIntToStr_Gen(Param, PSmallInt(Param.Args[0])^);
end;
}

procedure FuncIntToStr(Param: PExpressionRec);
begin
  FuncIntToStr_Gen(Param, PInteger(Param.Args[0])^);
end;

procedure FuncDateToStr(Param: PExpressionRec);
var
  TempStr: string;
begin
  with Param^ do
  begin
    // create in temporary string
    DateTimeToString(TempStr, 'yyyymmdd', PDateTime(Args[0])^);
    // copy to buffer
    Res.Append(PChar(TempStr), Length(TempStr));
  end;
end;

procedure FuncSubString(Param: PExpressionRec);
var
  srcLen, index, count: Integer;
begin
  with Param^ do
  begin
    srcLen := StrLen(Args[0]);
    index := PInteger(Args[1])^ - 1;
    count := PInteger(Args[2])^;
    if index + count <= srcLen then
      Res.Append(Args[0]+index, count)
    else
      Res.MemoryPos^^ := #0;
  end;
end;

procedure FuncUppercase(Param: PExpressionRec);
var
  dest: PChar;
begin
  with Param^ do
  begin
    // first copy
    dest := (Res.MemoryPos)^;
    Res.Append(Args[0], StrLen(Args[0]));
    // make uppercase
    StrUpper(dest);
  end;
end;

procedure FuncLowercase(Param: PExpressionRec);
var
  dest: PChar;
begin
  with Param^ do
  begin
    // first copy
    dest := (Res.MemoryPos)^;
    Res.Append(Args[0], StrLen(Args[0]));
    // make lowercase
    StrLower(dest);
  end;
end;

procedure FuncAdd_F_FF(Param: PExpressionRec);
begin
  with Param^ do
    PDouble(Res.MemoryPos^)^ := PDouble(Args[0])^ + PDouble(Args[1])^;
end;

procedure FuncAdd_F_FI(Param: PExpressionRec);
begin
  with Param^ do
    PDouble(Res.MemoryPos^)^ := PDouble(Args[0])^ + PInteger(Args[1])^;
end;

procedure FuncAdd_F_FL(Param: PExpressionRec);
begin
  with Param^ do
    PDouble(Res.MemoryPos^)^ := PDouble(Args[0])^ + PInt64(Args[1])^;
end;

procedure FuncAdd_F_II(Param: PExpressionRec);
begin
  with Param^ do
    PInteger(Res.MemoryPos^)^ := PInteger(Args[0])^ + PInteger(Args[1])^;
end;

procedure FuncAdd_F_IF(Param: PExpressionRec);
begin
  with Param^ do
    PDouble(Res.MemoryPos^)^ := PInteger(Args[0])^ + PDouble(Args[1])^;
end;

procedure FuncAdd_F_IL(Param: PExpressionRec);
begin
  with Param^ do
    PInt64(Res.MemoryPos^)^ := PInteger(Args[0])^ + PLargeInt(Args[1])^;
end;

procedure FuncAdd_F_LL(Param: PExpressionRec);
begin
  with Param^ do
    PInt64(Res.MemoryPos^)^ := PInt64(Args[0])^ + PInt64(Args[1])^;
end;

procedure FuncAdd_F_LF(Param: PExpressionRec);
begin
  with Param^ do
    PDouble(Res.MemoryPos^)^ := PInt64(Args[0])^ + PDouble(Args[1])^;
end;

procedure FuncAdd_F_LI(Param: PExpressionRec);
begin
  with Param^ do
    PInt64(Res.MemoryPos^)^ := PInt64(Args[0])^ + PInteger(Args[1])^;
end;

procedure FuncStr_EQ(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(CompareText(Trim(Args[0]), Trim(Args[1])) = 0);
end;

procedure FuncStr_LT(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(CompareText(Trim(Args[0]), Trim(Args[1])) < 0);
end;

procedure FuncStr_GT(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(CompareText(Trim(Args[0]), Trim(Args[1])) > 0);
end;


procedure FuncStr_LTE(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(CompareText(Trim(Args[0]), Trim(Args[1])) <= 0);
end;

procedure FuncStr_GTE(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(CompareText(Trim(Args[0]), Trim(Args[1])) >= 0);
end;

procedure Func_FF_EQ(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PDouble(Args[0])^   =  PDouble(Args[1])^);
end;

procedure Func_FF_LT(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PDouble(Args[0])^   <  PDouble(Args[1])^);
end;

procedure Func_FF_GT(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PDouble(Args[0])^   >  PDouble(Args[1])^);
end;

procedure Func_FF_LTE(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PDouble(Args[0])^   <= PDouble(Args[1])^);
end;

procedure Func_FF_GTE(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PDouble(Args[0])^   >= PDouble(Args[1])^);
end;

procedure Func_FI_EQ(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PDouble(Args[0])^   =  PInteger(Args[1])^);
end;

procedure Func_FI_LT(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PDouble(Args[0])^   <  PInteger(Args[1])^);
end;

procedure Func_FI_GT(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PDouble(Args[0])^   >  PInteger(Args[1])^);
end;

procedure Func_FI_LTE(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PDouble(Args[0])^   <= PInteger(Args[1])^);
end;

procedure Func_FI_GTE(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PDouble(Args[0])^   >= PInteger(Args[1])^);
end;

procedure Func_II_EQ(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PInteger(Args[0])^  =  PInteger(Args[1])^);
end;

procedure Func_II_LT(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PInteger(Args[0])^  <  PInteger(Args[1])^);
end;

procedure Func_II_GT(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PInteger(Args[0])^  >  PInteger(Args[1])^);
end;

procedure Func_II_LTE(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PInteger(Args[0])^  <= PInteger(Args[1])^);
end;

procedure Func_II_GTE(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PInteger(Args[0])^  >= PInteger(Args[1])^);
end;

procedure Func_IF_EQ(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PInteger(Args[0])^  =  PDouble(Args[1])^);
end;

procedure Func_IF_LT(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PInteger(Args[0])^  <  PDouble(Args[1])^);
end;

procedure Func_IF_GT(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PInteger(Args[0])^  >  PDouble(Args[1])^);
end;

procedure Func_IF_LTE(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PInteger(Args[0])^  <= PDouble(Args[1])^);
end;

procedure Func_IF_GTE(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PInteger(Args[0])^  >= PDouble(Args[1])^);
end;

{$ifdef DELPHI_4}

procedure Func_LL_EQ(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PInt64(Args[0])^    =  PInt64(Args[1])^);
end;

procedure Func_LL_LT(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PInt64(Args[0])^    <  PInt64(Args[1])^);
end;

procedure Func_LL_GT(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PInt64(Args[0])^    >  PInt64(Args[1])^);
end;

procedure Func_LL_LTE(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PInt64(Args[0])^    <= PInt64(Args[1])^);
end;

procedure Func_LL_GTE(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PInt64(Args[0])^    >= PInt64(Args[1])^);
end;

procedure Func_LF_EQ(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PInt64(Args[0])^    =  PDouble(Args[1])^);
end;

procedure Func_LF_LT(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PInt64(Args[0])^    <  PDouble(Args[1])^);
end;

procedure Func_LF_GT(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PInt64(Args[0])^    >  PDouble(Args[1])^);
end;

procedure Func_LF_LTE(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PInt64(Args[0])^    <= PDouble(Args[1])^);
end;

procedure Func_LF_GTE(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PInt64(Args[0])^    >= PDouble(Args[1])^);
end;

procedure Func_FL_EQ(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PDouble(Args[0])^   =  PInt64(Args[1])^);
end;

procedure Func_FL_LT(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PDouble(Args[0])^   <  PInt64(Args[1])^);
end;

procedure Func_FL_GT(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PDouble(Args[0])^   >  PInt64(Args[1])^);
end;

procedure Func_FL_LTE(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PDouble(Args[0])^   <= PInt64(Args[1])^);
end;

procedure Func_FL_GTE(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PDouble(Args[0])^   >= PInt64(Args[1])^);
end;

procedure Func_LI_EQ(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PInt64(Args[0])^    =  PInteger(Args[1])^);
end;

procedure Func_LI_LT(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PInt64(Args[0])^    <  PInteger(Args[1])^);
end;

procedure Func_LI_GT(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PInt64(Args[0])^    >  PInteger(Args[1])^);
end;

procedure Func_LI_LTE(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PInt64(Args[0])^    <= PInteger(Args[1])^);
end;

procedure Func_LI_GTE(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PInt64(Args[0])^    >= PInteger(Args[1])^);
end;

procedure Func_IL_EQ(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PInteger(Args[0])^  =  PInt64(Args[1])^);
end;

procedure Func_IL_LT(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PInteger(Args[0])^  <  PInt64(Args[1])^);
end;

procedure Func_IL_GT(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PInteger(Args[0])^  >  PInt64(Args[1])^);
end;

procedure Func_IL_LTE(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PInteger(Args[0])^  <= PInt64(Args[1])^);
end;

procedure Func_IL_GTE(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PInteger(Args[0])^  >= PInt64(Args[1])^);
end;

{$endif}

{
procedure FuncInt16_EQ(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PSmallInt(Args[0])^ =  PSmallInt(Args[1])^);
end;

procedure FuncInt16_LT(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PSmallInt(Args[0])^ <  PSmallInt(Args[1])^);
end;

procedure FuncInt16_GT(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PSmallInt(Args[0])^ >  PSmallInt(Args[1])^);
end;

procedure FuncInt16_LTE(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PSmallInt(Args[0])^ <= PSmallInt(Args[1])^);
end;

procedure FuncInt16_GTE(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(PSmallInt(Args[0])^ >= PSmallInt(Args[1])^);
end;
}

procedure Func_AND(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(Boolean(Args[0]^) and Boolean(Args[1]^));
end;

procedure Func_OR(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(Boolean(Args[0]^) or Boolean(Args[1]^));
end;

procedure Func_NOT(Param: PExpressionRec);
begin
  with Param^ do
    Res.MemoryPos^^ := Char(not Boolean(Args[0]^));
end;

//--TDbfParser---------------------------------------------------------------
constructor TDbfParser.Create(ADbfFile: Pointer);
begin
  inherited Create;

  FDbfFile := ADbfFile;
  FFieldVarList := TStringList.Create;
end;

destructor TDbfParser.Destroy;
begin
  ClearExpressions;
  FFieldVarList.Free;
  FFieldVarList := nil;
  inherited;
end;

function TDbfParser.GetResultType: TVarType;
begin
  // if not a real expression, return type ourself
  if FIsExpression then
    Result := inherited GetResultType
  else
    Result := FFieldType;
end;

procedure TDbfParser.FillExpressList;
begin
  with FWordsList do
  begin
    Duplicates := true;

    // basic function functionality
    Add(TLeftBracket.Create('(', nil));
    Add(TRightBracket.Create(')', nil));
    Add(TComma.Create(ArgSeparator, nil));

    // operators - name, param types, result type, func addr, precedence
    Add(TFunction.CreateOper('+', 'SS', vtString,  nil,           40));
    Add(TFunction.CreateOper('+', 'FF', vtFloat,   FuncAdd_F_FF , 40));
    Add(TFunction.CreateOper('+', 'FI', vtFloat,   FuncAdd_F_FI , 40));
    Add(TFunction.CreateOper('+', 'FL', vtFloat,   FuncAdd_F_FL , 40));
    Add(TFunction.CreateOper('+', 'II', vtInteger, FuncAdd_F_II , 40));
    Add(TFunction.CreateOper('+', 'IF', vtFloat,   FuncAdd_F_IF , 40));
    Add(TFunction.CreateOper('+', 'IL', vtLargeInt,FuncAdd_F_IL , 40));
    Add(TFunction.CreateOper('+', 'LL', vtLargeInt,FuncAdd_F_LI , 40));
    Add(TFunction.CreateOper('+', 'LF', vtFloat,   FuncAdd_F_LF , 40));
    Add(TFunction.CreateOper('+', 'LI', vtLArgeInt,FuncAdd_F_LL , 40));

    Add(TFunction.CreateOper('=', 'SS', vtBoolean, FuncStr_EQ   , 80));
    Add(TFunction.CreateOper('<', 'SS', vtBoolean, FuncStr_LT   , 80));
    Add(TFunction.CreateOper('>', 'SS', vtBoolean, FuncStr_GT   , 80));
    Add(TFunction.CreateOper('<=','SS', vtBoolean, FuncStr_LTE  , 80));
    Add(TFunction.CreateOper('>=','SS', vtBoolean, FuncStr_GTE  , 80));
    Add(TFunction.CreateOper('=', 'FF', vtBoolean, Func_FF_EQ , 80));
    Add(TFunction.CreateOper('<', 'FF', vtBoolean, Func_FF_LT , 80));
    Add(TFunction.CreateOper('>', 'FF', vtBoolean, Func_FF_GT , 80));
    Add(TFunction.CreateOper('<=','FF', vtBoolean, Func_FF_LTE, 80));
    Add(TFunction.CreateOper('>=','FF', vtBoolean, Func_FF_GTE, 80));
    Add(TFunction.CreateOper('=', 'FI', vtBoolean, Func_FI_EQ , 80));
    Add(TFunction.CreateOper('<', 'FI', vtBoolean, Func_FI_LT , 80));
    Add(TFunction.CreateOper('>', 'FI', vtBoolean, Func_FI_GT , 80));
    Add(TFunction.CreateOper('<=','FI', vtBoolean, Func_FI_LTE, 80));
    Add(TFunction.CreateOper('>=','FI', vtBoolean, Func_FI_GTE, 80));
    Add(TFunction.CreateOper('=', 'II', vtBoolean, Func_II_EQ , 80));
    Add(TFunction.CreateOper('<', 'II', vtBoolean, Func_II_LT , 80));
    Add(TFunction.CreateOper('>', 'II', vtBoolean, Func_II_GT , 80));
    Add(TFunction.CreateOper('<=','II', vtBoolean, Func_II_LTE, 80));
    Add(TFunction.CreateOper('>=','II', vtBoolean, Func_II_GTE, 80));
    Add(TFunction.CreateOper('=', 'IF', vtBoolean, Func_IF_EQ , 80));
    Add(TFunction.CreateOper('<', 'IF', vtBoolean, Func_IF_LT , 80));
    Add(TFunction.CreateOper('>', 'IF', vtBoolean, Func_IF_GT , 80));
    Add(TFunction.CreateOper('<=','IF', vtBoolean, Func_IF_LTE, 80));
    Add(TFunction.CreateOper('>=','IF', vtBoolean, Func_IF_GTE, 80));
{$ifdef DELPHI_4}
    Add(TFunction.CreateOper('=', 'LL', vtBoolean, Func_LL_EQ , 80));
    Add(TFunction.CreateOper('<', 'LL', vtBoolean, Func_LL_LT , 80));
    Add(TFunction.CreateOper('>', 'LL', vtBoolean, Func_LL_GT , 80));
    Add(TFunction.CreateOper('<=','LL', vtBoolean, Func_LL_LTE, 80));
    Add(TFunction.CreateOper('>=','LL', vtBoolean, Func_LL_GTE, 80));
    Add(TFunction.CreateOper('=', 'LF', vtBoolean, Func_LF_EQ , 80));
    Add(TFunction.CreateOper('<', 'LF', vtBoolean, Func_LF_LT , 80));
    Add(TFunction.CreateOper('>', 'LF', vtBoolean, Func_LF_GT , 80));
    Add(TFunction.CreateOper('<=','LF', vtBoolean, Func_LF_LTE, 80));
    Add(TFunction.CreateOper('>=','LF', vtBoolean, Func_LF_GTE, 80));
    Add(TFunction.CreateOper('=', 'LI', vtBoolean, Func_LI_EQ , 80));
    Add(TFunction.CreateOper('<', 'LI', vtBoolean, Func_LI_LT , 80));
    Add(TFunction.CreateOper('>', 'LI', vtBoolean, Func_LI_GT , 80));
    Add(TFunction.CreateOper('<=','LI', vtBoolean, Func_LI_LTE, 80));
    Add(TFunction.CreateOper('>=','LI', vtBoolean, Func_LI_GTE, 80));
    Add(TFunction.CreateOper('=', 'FL', vtBoolean, Func_FL_EQ , 80));
    Add(TFunction.CreateOper('<', 'FL', vtBoolean, Func_FL_LT , 80));
    Add(TFunction.CreateOper('>', 'FL', vtBoolean, Func_FL_GT , 80));
    Add(TFunction.CreateOper('<=','FL', vtBoolean, Func_FL_LTE, 80));
    Add(TFunction.CreateOper('>=','FL', vtBoolean, Func_FL_GTE, 80));
    Add(TFunction.CreateOper('=', 'IL', vtBoolean, Func_IL_EQ , 80));
    Add(TFunction.CreateOper('<', 'IL', vtBoolean, Func_IL_LT , 80));
    Add(TFunction.CreateOper('>', 'IL', vtBoolean, Func_IL_GT , 80));
    Add(TFunction.CreateOper('<=','IL', vtBoolean, Func_IL_LTE, 80));
    Add(TFunction.CreateOper('>=','IL', vtBoolean, Func_IL_GTE, 80));
{$endif}
{
    Add(TFunction.CreateOper('=', 'JJ', vtBoolean, FuncInt16_EQ , 80));
    Add(TFunction.CreateOper('<', 'JJ', vtBoolean, FuncInt16_LT , 80));
    Add(TFunction.CreateOper('>', 'JJ', vtBoolean, FuncInt16_GT , 80));
    Add(TFunction.CreateOper('<=','JJ', vtBoolean, FuncInt16_LTE, 80));
    Add(TFunction.CreateOper('>=','JJ', vtBoolean, FuncInt16_GTE, 80));
}

    Add(TFunction.CreateOper('NOT', 'B',  vtBoolean, Func_NOT, 85));
    Add(TFunction.CreateOper('AND', 'BB', vtBoolean, Func_AND, 90));
    Add(TFunction.CreateOper('OR',  'BB', vtBoolean, Func_OR, 100));

    // functions - name, description, param types, min params, result type, func addr
    Add(TFunction.Create('STR',       '', 'FII', 1, vtString, FuncFloatToStr));
    Add(TFunction.Create('STR',       '', 'III', 1, vtString, FuncIntToStr));
//    Add(TFunction.Create('STR',       '', 'JII', 1, vtString, FuncSmallIntToStr));
    Add(TFunction.Create('DTOS',      '', 'D',   1, vtString, FuncDateToStr));
    Add(TFunction.Create('SUBSTR',    '', 'SII', 3, vtString, FuncSubString));
    Add(TFunction.Create('UPPERCASE', '', 'S',   1, vtString, FuncUppercase));
    Add(TFunction.Create('LOWERCASE', '', 'S',   1, vtString, FuncLowercase));
    Add(TFunction.Create('UPPER',     '', 'S',   1, vtString, FuncUppercase));
    Add(TFunction.Create('LOWER',     '', 'S',   1, vtString, FuncLowercase));
  end;
end;

function TDbfParser.GetVariableInfo(VarName: string): TDbfFieldDef;
begin
  Result := TDbfFile(FDbfFile).GetFieldInfo(VarName);
end;

procedure TDbfParser.HandleUnknownVariable(VarName: string);
var
  FieldInfo: TDbfFieldDef;
  TempFieldVar: TFieldVar;
begin
  // is this variable a fieldname?
  FieldInfo := GetVariableInfo(VarName);
  if FieldInfo = nil then
    raise EDbfFile.CreateFmt(STRING_INDEX_BASED_ON_UNKNOWN_FIELD, [VarName]);

  // define field in parser
  case FieldInfo.FieldType of
    ftString:
      begin
        TempFieldVar := TStringFieldVar.Create(FieldInfo, TDbfFile(FDbfFile));
        DefineStringVariableFixedLen(VarName, TempFieldVar.FieldVal, FieldInfo.Size);
      end;
    ftFloat:
      begin
        TempFieldVar := TFloatFieldVar.Create(FieldInfo, TDbfFile(FDbfFile));
        DefineFloatVariable(VarName, TempFieldVar.FieldVal);
      end;
    ftAutoInc, ftInteger, ftSmallInt:
      begin
        TempFieldVar := TIntegerFieldVar.Create(FieldInfo, TDbfFile(FDbfFile));
        DefineIntegerVariable(VarName, TempFieldVar.FieldVal);
      end;
{
    ftSmallInt:
      begin
        TempFieldVar := TSmallIntFieldVar.Create(FieldInfo, TDbfFile(FDbfFile));
        DefineSmallIntVariable(VarName, TempFieldVar.FieldVal);
      end;
}
{$ifdef DELPHI_4}
    ftLargeInt:
      begin
        TempFieldVar := TLargeIntFieldVar.Create(FieldInfo, TDbfFile(FDbfFile));
        DefineLargeIntVariable(VarName, TempFieldVar.FieldVal);
      end;
{$endif}
    ftDate, ftDateTime:
      begin
        TempFieldVar := TDateTimeFieldVar.Create(FieldInfo, TDbfFile(FDbfFile));
        DefineDateTimeVariable(VarName, TempFieldVar.FieldVal);
      end;
    ftBoolean:
      begin
        TempFieldVar := TBooleanFieldVar.Create(FieldInfo, TDbfFile(FDbfFile));
        DefineBooleanVariable(VarName, TempFieldVar.FieldVal);
      end;
  else
    raise EDbfFile.CreateFmt(STRING_INDEX_BASED_ON_INVALID_FIELD, [VarName]);
  end;

  // add to our own list
  FFieldVarList.AddObject(VarName, TempFieldVar);
end;

function TDbfParser.CurrentExpression: string;
begin
  Result := FCurrentExpression;
end;

procedure TDbfParser.ClearExpressions;
var
  I: Integer;
begin
  inherited;

  // test if already freed
  if FFieldVarList <> nil then
  begin
    // free field list
    for I := 0 to FFieldVarList.Count - 1 do
    begin
      // replacing with nil = undefining variable
      ReplaceFunction(TFieldVar(FFieldVarList.Objects[I]).FieldDef.FieldName, nil);
      TFieldVar(FFieldVarList.Objects[I]).Free;
    end;
    FFieldVarList.Clear;
  end;

  // clear expression
  FCurrentExpression := EmptyStr;
end;

procedure TDbfParser.ParseExpression(Expression: string);
var
  TempBuffer: array[0..4000] of Char;
begin
  // clear any current expression
  ClearExpressions;

  // is this a simple field or complex expression?
  FIsExpression := GetVariableInfo(Expression) = nil;
  if FIsExpression then
  begin
    // parse requested
    CompileExpression(Expression);

    // determine length of string length expressions
    if ResultType = vtString then
    begin
      // make empty record
      TDbfFile(FDbfFile).InitRecord(@TempBuffer[0]);
      FResultLen := StrLen(ExtractFromBuffer(@TempBuffer[0]));
    end;
  end else begin
    // simple field, create field variable for it
    HandleUnknownVariable(Expression);
    FFieldType := TFieldVar(FFieldVarList.Objects[0]).FieldType;
    // set result len of variable length fields
    if FFieldType = vtString then
      FResultLen := TFieldVar(FFieldVarList.Objects[0]).FieldDef.Size
  end;

  // set result len for fixed length expressions / fields
  case ResultType of
    vtBoolean:  FResultLen := 1;
//    vtSmallInt: FResultLen := 2;
    vtInteger:  FResultLen := 4;
    vtFloat:    FResultLen := 8;
    vtDateTime: FResultLen := 8;
  end;

  // check if expression not too long
  if FResultLen > 100 then
    raise EDbfError.CreateFmt(STRING_INDEX_EXPRESSION_TOO_LONG, [Expression, FResultLen]);

  // if no errors, assign current expression
  FCurrentExpression := Expression;
end;

function TDbfParser.ExtractFromBuffer(Buffer: PChar): PChar;
var
  I: Integer;
begin
  // prepare all field variables
  for I := 0 to FFieldVarList.Count - 1 do
    TFieldVar(FFieldVarList.Objects[I]).Refresh(Buffer);

  // complex expression?
  if FIsExpression then
  begin
    // execute expression
    EvaluateCurrent;
    Result := ExpResult;
  end else begin
    // simple field, get field result
    Result := TFieldVar(FFieldVarList.Objects[0]).FieldVal;
    // if string then dereference
    if FFieldType = vtString then
      Result := PPChar(Result)^;
  end;
end;

end.


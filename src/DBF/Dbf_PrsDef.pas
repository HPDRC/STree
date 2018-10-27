unit Dbf_PrsDef;

interface

{$I Dbf_Common.inc}

uses
  SysUtils,
  Dbf_Common,
  Dbf_PrsSupp;

{$define NAN}

{use this directive to suppress math exceptions,
instead NAN is returned.
Using this directive is slightly less efficient}

const
  MaxArg = 6;
  ArgAllocSize = 32;

{$ifdef NAN}

const
  Nan: Double = 0/0;

function IsNan(var d: Double): Boolean;

{$endif}

type
  TVarType = (vtBoolean, vtInteger, {vtSmallInt,} vtLargeInt, vtFloat, vtDateTime,
    vtString, vtLeftBracket, vtRightBracket, vtComma, vtUnknown);

  PPChar = ^PChar;
  PBoolean = ^Boolean;
  PInteger = ^Integer;
  PDateTime = ^TDateTime;
  EParserException = class(Exception);
  PExpressionRec = ^TExpressionRec;
  PDynamicType = ^TDynamicType;

  TExprWord = class;

  TExprFunc = procedure(Expr: PExpressionRec);

//-----

  TDynamicType = class (TObject)
  private
    FMemory: PPChar;
    FMemoryPos: PPChar;
    FSize: PInteger;
  public
    constructor Create(DestMem, DestPos: PPChar; Size: PInteger);

    procedure AssureSpace(ASize: Integer);
    procedure Resize(NewSize: Integer; Exact: Boolean);
    procedure Rewind;
    procedure Append(Source: PChar; Length: Integer);

    property Memory: PPChar read FMemory;
    property MemoryPos: PPChar read FMemoryPos;
    property Size: PInteger read FSize;
  end;

  TExpressionRec = record
    //used both as linked tree and linked list for maximum evaluation efficiency
    Oper: TExprFunc;
    Next: PExpressionRec;
    Res: TDynamicType;
    ExprWord: TExprWord;
    ResetDest: Boolean;
    Args: array[0..MaxArg-1] of PChar;
    ArgsPos: array[0..MaxArg-1] of PChar;
    ArgsSize: array[0..MaxArg-1] of Integer;
    ArgsType: array[0..MaxArg-1] of TVarType;
    ArgList: array[0..MaxArg-1] of PExpressionRec;
  end;

  TExprCollection = class(TNoOwnerCollection)
  public
    function NextOper(IStart: Integer): Integer;
    procedure Check;
    procedure EraseExtraBrackets;
  end;

  TExprWord = class
  private
    FName: string;
    FExprFunc: TExprFunc;
  protected
    function GetIsOper: Boolean; virtual;
    function GetAsString: string; virtual;
    function GetIsVariable: Boolean;
    function GetNeedsCopy: Boolean;
    function GetFixedLen: Integer; virtual;
    function GetCanVary: Boolean; virtual;
    function GetResultType: TVarType; virtual;
    function GetMinFunctionArg: Integer; virtual;
    function GetMaxFunctionArg: Integer; virtual;
    function GetDescription: string; virtual;
    function GetTypeSpec: string; virtual;
  public
    constructor Create(AName: string; AExprFunc: TExprFunc);

    function LenAsPointer: PInteger; virtual;
    function AsPointer: PChar; virtual;
    function IsFunction: Boolean; virtual;

    property AsString: string read GetAsString;
    property ExprFunc: TExprFunc read FExprFunc;
    property IsOper: Boolean read GetIsOper;
    property CanVary: Boolean read GetCanVary;
    property IsVariable: Boolean read GetIsVariable;
    property NeedsCopy: Boolean read GetNeedsCopy;
    property FixedLen: Integer read GetFixedLen;
    property ResultType: TVarType read GetResultType;
    property MinFunctionArg: Integer read GetMinFunctionArg;
    property MaxFunctionArg: Integer read GetMaxFunctionArg;
    property Name: string read FName;
    property Description: string read GetDescription;
    property TypeSpec: string read GetTypeSpec;
  end;

  TExpressList = class(TSortedCollection)
  public
    function KeyOf(Item: Pointer): Pointer; override;
    function Compare(Key1, Key2: Pointer): Integer; override;
  end;

  TConstant = class(TExprWord)
  private
    FResultType: TVarType;
  protected
    function GetResultType: TVarType; override;
  public
    constructor Create(AName: string; AVarType: TVarType; AExprFunc: TExprFunc);
  end;

  TFloatConstant = class(TConstant)
  private
    FValue: Double;
  public
    // not overloaded to support older Delphi versions
    constructor Create(AName: string; AValue: string);
    constructor CreateAsDouble(AName: string; AValue: Double);

    function AsPointer: PChar; override;

    property Value: Double read FValue write FValue;
  end;

  TUserConstant = class(TFloatConstant)
  private
    FDescription: string;
  protected
    function GetDescription: string; override;
  public
    constructor CreateAsDouble(AName, Descr: string; AValue: Double);
  end;

  TStringConstant = class(TConstant)
  private
    FValue: string;
  protected
    function GetAsString: string; override;
  public
    constructor Create(AValue: string);

    function AsPointer: PChar; override;
  end;

  TIntegerConstant = class(TConstant)
  private
    FValue: Integer;
  public
    constructor Create(AValue: Integer);

    function AsPointer: PChar; override;
  end;

  TBooleanConstant = class(TConstant)
  private
    FValue: Boolean;
  public
    // not overloaded to support older Delphi versions
    constructor Create(AName: string; AValue: Boolean);

    function AsPointer: PChar; override;

    property Value: Boolean read FValue write FValue;
  end;

{
  TGeneratedVariable = class(TFloatConstant)
  private
    FAsString: string;
    FResultType: TVarType;
  protected
    function GetResultType: TVarType; override;
    function GetAsString: string; override;
    function GetCanVary: Boolean; override;
  public
    constructor Create(AName: string);

    property ResultType read GetResultType write FResultType;
    property AsString: string read GetAsString write FAsString;
  end;
}

  TVariable = class(TExprWord)
  private
    FResultType: TVarType;
  protected
    function GetCanVary: Boolean; override;
    function GetResultType: TVarType; override;
  public
    constructor Create(AName: string; AVarType: TVarType; AExprFunc: TExprFunc);
  end;

  TFloatVariable = class(TVariable)
  private
    FValue: PDouble;
  public
    constructor Create(AName: string; AValue: PDouble);

    function AsPointer: PChar; override;
  end;

  TStringVariable = class(TVariable)
  private
    FValue: PPChar;
    FFixedLen: Integer;
  protected
    function GetAsString: string; override;
    function GetFixedLen: Integer; override;
  public
    constructor Create(AName: string; AValue: PPChar; AFixedLen: Integer);

    function LenAsPointer: PInteger; override;
    function AsPointer: PChar; override;

    property FixedLen: Integer read FFixedLen;
  end;

  TDateTimeVariable = class(TVariable)
  private
    FValue: PDateTime;
  public
    constructor Create(AName: string; AValue: PDateTime);

    function AsPointer: PChar; override;
  end;

  TIntegerVariable = class(TVariable)
  private
    FValue: PInteger;
  public
    constructor Create(AName: string; AValue: PInteger);

    function AsPointer: PChar; override;
  end;

{
  TSmallIntVariable = class(TVariable)
  private
    FValue: PSmallInt;
  public
    constructor Create(AName: string; AValue: PSmallInt);

    function AsPointer: PChar; override;
  end;
}

{$ifdef DELPHI_4}

  TLargeIntVariable = class(TVariable)
  private
    FValue: PLargeInt;
  public
    constructor Create(AName: string; AValue: PLargeInt);

    function AsPointer: PChar; override;
  end;

{$endif}

  TBooleanVariable = class(TVariable)
  private
    FValue: PBoolean;
  public
    constructor Create(AName: string; AValue: PBoolean);

    function AsPointer: PChar; override;
  end;

  TLeftBracket = class(TExprWord)
    function GetResultType: TVarType; override;
  end;

  TRightBracket = class(TExprWord)
  protected
    function GetResultType: TVarType; override;
  end;

  TComma = class(TExprWord)
  protected
    function GetResultType: TVarType; override;
  end;

  TFunction = class(TExprWord)
  private
    FIsOper: Boolean;
    FOperPrec: Integer;
    FMinFunctionArg: Integer;
    FMaxFunctionArg: Integer;
    FDescription: string;
    FTypeSpec: string;
    FResultType: TVarType;
  protected
    function GetDescription: string; override;
    function GetIsOper: Boolean; override;
    function GetMinFunctionArg: Integer; override;
    function GetMaxFunctionArg: Integer; override;
    function GetResultType: TVarType; override;
    function GetTypeSpec: string; override;

    procedure InternalCreate(AName, ATypeSpec: string; AMinFuncArg: Integer; AResultType: TVarType;
      AExprFunc: TExprFunc; AIsOper: Boolean; AOperPrec: Integer);
  public
    constructor Create(AName, Descr, ATypeSpec: string; AMinFuncArg: Integer; AResultType: TVarType; AExprFunc: TExprFunc);
    constructor CreateOper(AName, ATypeSpec: string; AResultType: TVarType; AExprFunc: TExprFunc; AOperPrec: Integer);

    function IsFunction: Boolean; override;

    property OperPrec: Integer read FOperPrec;
    property TypeSpec: string read FTypeSpec;
  end;

  TVaryingFunction = class(TFunction)
    // Functions that can vary for ex. random generators
    // should be TVaryingFunction to be sure that they are
    // always evaluated
  protected
    function GetCanVary: Boolean; override;
  end;

const
  ListChar = ','; {the delimiter used with the 'in' operator: e.g.,
  ('a' in 'a,b') =True
  ('c' in 'a,b') =False}

function VarStrToVarType(VarStr: Char): TVarType;



implementation

{$ifdef NAN}

function IsNaN(var d: Double): Boolean;
var
  _Nan:double;
begin
  _nan:=nan;
  Result:=CompareMem(@d, @_Nan, SizeOf(Double))
end;

{$endif}

function VarStrToVarType(VarStr: Char): TVarType;
begin
  case VarStr of
    'B': Result := vtBoolean;
    'I': Result := vtInteger;
//    'J': Result := vtSmallInt;
    'L': Result := vtLargeInt;
    'F': Result := vtFloat;
    'D': Result := vtDateTime;
    'S': Result := vtString;
  else
    Result := vtUnknown;
  end;
end;

procedure _FloatVariable(Param: PExpressionRec);
begin
  with Param^ do
    PDouble(Res.MemoryPos^)^ := PDouble(Args[0])^;
end;

procedure _BooleanVariable(Param: PExpressionRec);
begin
  with Param^ do
    PBoolean(Res.MemoryPos^)^ := PBoolean(Args[0])^;
end;

procedure _StringConstant(Param: PExpressionRec);
begin
  with Param^ do
    Res.Append(Args[0], StrLen(Args[0]));
end;

procedure _StringVariable(Param: PExpressionRec);
begin
  with Param^ do
    Res.Append(PPChar(Args[0])^, StrLen(PPChar(Args[0])^));
end;

procedure _StringVariableFixedLen(Param: PExpressionRec);
begin
  with Param^ do
    Res.Append(PPChar(Args[0])^, PInteger(Args[1])^);
end;

procedure _DateTimeVariable(Param: PExpressionRec);
begin
  with Param^ do
    PDateTime(Res.MemoryPos^)^ := PDateTime(Args[0])^;
end;

procedure _IntegerVariable(Param: PExpressionRec);
begin
  with Param^ do
    PInteger(Res.MemoryPos^)^ := PInteger(Args[0])^;
end;

{
procedure _SmallIntVariable(Param: PExpressionRec);
begin
  with Param^ do
    PSmallInt(Res.MemoryPos^)^ := PSmallInt(Args[0])^;
end;
}

{$ifdef DELPHI_4}

procedure _LargeIntVariable(Param: PExpressionRec);
begin
  with Param^ do
    PLargeInt(Res.MemoryPos^)^ := PLargeInt(Args[0])^;
end;

{$endif}

{ TExpressionWord }

constructor TExprWord.Create(AName: string; AExprFunc: TExprFunc);
begin
  FName := LowerCase(AName);
  FExprFunc := AExprFunc;
end;

function TExprWord.GetAsString: string;
begin
  Result := EmptyStr;
end;

function TExprWord.GetCanVary: Boolean;
begin
  Result := False;
end;

function TExprWord.GetDescription: string;
begin
  Result := EmptyStr;
end;

function TExprWord.GetIsOper: Boolean;
begin
  Result := False;
end;

function TExprWord.GetIsVariable: Boolean;
begin
  Result := (@FExprFunc = @_StringVariable)         or
            (@FExprFunc = @_StringConstant)         or
            (@FExprFunc = @_StringVariableFixedLen) or
            (@FExprFunc = @_FloatVariable)          or
            (@FExprFunc = @_IntegerVariable)        or
//            (@FExprFunc = @_SmallIntVariable)       or
{$ifdef DELPHI_4}
            (@FExprFunc = @_LargeIntVariable)       or
{$endif}
            (@FExprFunc = @_DateTimeVariable)       or
            (@FExprFunc = @_BooleanVariable);
end;

function TExprWord.GetNeedsCopy: Boolean;
begin
  Result := (@FExprFunc <> @_StringConstant)         and
//            (@FExprFunc <> @_StringVariable)         and
//            (@FExprFunc <> @_StringVariableFixedLen) and
// string variable cannot be used as normal parameter
// because it is indirectly referenced and possibly
// not null-terminated (fixed len)
            (@FExprFunc <> @_FloatVariable)          and
            (@FExprFunc <> @_IntegerVariable)        and
//            (@FExprFunc <> @_SmallIntVariable)       and
{$ifdef DELPHI_4}
            (@FExprFunc <> @_LargeIntVariable)       and
{$endif}
            (@FExprFunc <> @_DateTimeVariable)       and
            (@FExprFunc <> @_BooleanVariable);
end;

function TExprWord.GetFixedLen: Integer;
begin
  // -1 means variable, non-fixed length
  Result := -1;
end;

function TExprWord.GetMinFunctionArg: Integer;
begin
  Result := 0;
end;

function TExprWord.GetMaxFunctionArg: Integer;
begin
  Result := 0;
end;

function TExprWord.GetResultType: TVarType;
begin
  Result := vtUnknown;
end;

function TExprWord.GetTypeSpec: string;
begin
  Result := EmptyStr;
end;

function TExprWord.AsPointer: PChar;
begin
  Result := nil;
end;

function TExprWord.LenAsPointer: PInteger;
begin
  Result := nil;
end;

function TExprWord.IsFunction: Boolean;
begin
  Result := False;
end;

{ TConstant }

constructor TConstant.Create(AName: string; AVarType: TVarType; AExprFunc: TExprFunc);
begin
  inherited Create(AName, AExprFunc);

  FResultType := AVarType;
end;

function TConstant.GetResultType: TVarType;
begin
  Result := FResultType;
end;

{ TFloatConstant }

constructor TFloatConstant.Create(AName, AValue: string);
begin
  inherited Create(AName, vtFloat, _FloatVariable);

  if Length(AValue) > 0 then
    FValue := StrToFloat(AValue)
  else
    FValue := 0.0;
end;

constructor TFloatConstant.CreateAsDouble(AName: string; AValue: Double);
begin
  inherited Create(AName, vtFloat, _FloatVariable);

  FValue := AValue;
end;

function TFloatConstant.AsPointer: PChar;
begin
  Result := PChar(@FValue);
end;

{ TUserConstant }

constructor TUserConstant.CreateAsDouble(AName, Descr: string; AValue: Double);
begin
  FDescription := Descr;

  inherited CreateAsDouble(AName, AValue);
end;

function TUserConstant.GetDescription: string;
begin
  Result := FDescription;
end;

{ TStringConstant }

constructor TStringConstant.Create(AValue: string);
var
  firstChar, lastChar: Char;
begin
  inherited Create(AValue, vtString, _StringConstant);

  firstChar := AValue[1];
  lastChar := AValue[Length(AValue)];
  if (firstChar = lastChar) and ((firstChar = '''') or (firstChar = '"')) then
    FValue := Copy(AValue, 2, Length(AValue) - 2)
  else
    FValue := AValue;
end;

function TStringConstant.GetAsString: string;
begin
  Result := FValue;
end;

function TStringConstant.AsPointer: PChar;
begin
  Result := PChar(FValue);
end;

{ TBooleanConstant }

constructor TBooleanConstant.Create(AName: string; AValue: Boolean);
begin
  inherited Create(AName, vtBoolean, _BooleanVariable);

  FValue := AValue;
end;

function TBooleanConstant.AsPointer: PChar;
begin
  Result := PChar(@FValue);
end;

{ TIntegerConstant }

constructor TIntegerConstant.Create(AValue: Integer);
begin
  inherited Create(IntToStr(AValue), vtInteger, _IntegerVariable);

  FValue := AValue;
end;

function TIntegerConstant.AsPointer: PChar;
begin
  Result := PChar(@FValue);
end;

{ TVariable }

constructor TVariable.Create(AName: string; AVarType: TVarType; AExprFunc: TExprFunc);
begin
  inherited Create(AName, AExprFunc);

  FResultType := AVarType;
end;

function TVariable.GetCanVary: Boolean;
begin
  Result := True;
end;

function TVariable.GetResultType: TVarType;
begin
  Result := FResultType;
end;

{ TFloatVariable }

constructor TFloatVariable.Create(AName: string; AValue: PDouble);
begin
  inherited Create(AName, vtFloat, _FloatVariable);
  FValue := AValue;
end;

function TFloatVariable.AsPointer: PChar;
begin
  Result := PChar(FValue);
end;

{ TStringVariable }

constructor TStringVariable.Create(AName: string; AValue: PPChar; AFixedLen: Integer);
begin
  // variable or fixed length?
  if (AFixedLen < 0) then
    inherited Create(AName, vtString, _StringVariable)
  else
    inherited Create(AName, vtString, _StringVariableFixedLen);

  // store pointer to string
  FValue := AValue;
  FFixedLen := AFixedLen;
end;

function TStringVariable.GetAsString: string;
begin
  Result := FValue^;
end;

function TStringVariable.AsPointer: PChar;
begin
  Result := PChar(FValue);
end;

function TStringVariable.GetFixedLen: Integer;
begin
  Result := FFixedLen;
end;

function TStringVariable.LenAsPointer: PInteger;
begin
  Result := @FFixedLen;
end;

{ TDateTimeVariable }

constructor TDateTimeVariable.Create(AName: string; AValue: PDateTime);
begin
  inherited Create(AName, vtDateTime, _DateTimeVariable);
  FValue := AValue;
end;

function TDateTimeVariable.AsPointer: PChar;
begin
  Result := PChar(FValue);
end;

{ TIntegerVariable }

constructor TIntegerVariable.Create(AName: string; AValue: PInteger);
begin
  inherited Create(AName, vtInteger, _IntegerVariable);
  FValue := AValue;
end;

function TIntegerVariable.AsPointer: PChar;
begin
  Result := PChar(FValue);
end;

{ TSmallIntVariable }
{
constructor TSmallIntVariable.Create(AName: string; AValue: PSmallInt);
begin
  inherited Create(AName, vtSmallInt, _SmallIntVariable);
  FValue := AValue;
end;

function TSmallIntVariable.AsPointer: PChar;
begin
  Result := PChar(FValue);
end;
}

{$ifdef DELPHI_4}

{ TLargeIntVariable }

constructor TLargeIntVariable.Create(AName: string; AValue: PLargeInt);
begin
  inherited Create(AName, vtLargeInt, _LargeIntVariable);
  FValue := AValue;
end;

function TLargeIntVariable.AsPointer: PChar;
begin
  Result := PChar(FValue);
end;

{$endif}

{ TBooleanVariable }

constructor TBooleanVariable.Create(AName: string; AValue: PBoolean);
begin
  inherited Create(AName, vtBoolean, _BooleanVariable);
  FValue := AValue;
end;

function TBooleanVariable.AsPointer: PChar;
begin
  Result := PChar(FValue);
end;

{ TLeftBracket }

function TLeftBracket.GetResultType: TVarType;
begin
  Result := vtLeftBracket;
end;

{ TRightBracket }

function TRightBracket.GetResultType: TVarType;
begin
  Result := vtRightBracket;
end;

{ TComma }

function TComma.GetResultType: TVarType;
begin
  Result := vtComma;
end;

{ TExpressList }

function TExpressList.Compare(Key1, Key2: Pointer): Integer;
begin
  Result := StrIComp(PChar(Key1), PChar(Key2));
end;

function TExpressList.KeyOf(Item: Pointer): Pointer;
begin
  Result := PChar(TExprWord(Item).Name);
end;

{ TExprCollection }

procedure TExprCollection.Check;
var
  brCount, I: Integer;
begin
  brCount := 0;
  for I := 0 to Count - 1 do
  begin
    case TExprWord(Items[I]).ResultType of
      vtLeftBracket: Inc(brCount);
      vtRightBracket: Dec(brCount);
    end;
  end;
  if brCount <> 0 then
    raise EParserException.Create('Unequal brackets');
end;

procedure TExprCollection.EraseExtraBrackets;
var
  I: Integer;
  brCount: Integer;
begin
  if (TExprWord(Items[0]).ResultType = vtLeftBracket) then
  begin
    brCount := 1;
    I := 1;
    while (I < Count) and (brCount > 0) do
    begin
      case TExprWord(Items[I]).ResultType of
        vtLeftBracket: Inc(brCount);
        vtRightBracket: Dec(brCount);
      end;
      Inc(I);
    end;
    if (brCount = 0) and (I = Count) and (TExprWord(Items[I - 1]).ResultType =
      vtRightBracket) then
    begin
      for I := 0 to Count - 3 do
        Items[I] := Items[I + 1];
      Count := Count - 2;
      EraseExtraBrackets; //Check if there are still too many brackets
    end;
  end;
end;

function TExprCollection.NextOper(IStart: Integer): Integer;
var
  brCount: Integer;
begin
  brCount := 0;
  Result := IStart;
  while (Result < Count) and ((brCount > 0) or not (TExprWord(Items[Result]).IsFunction)) do
  begin
    case TExprWord(Items[Result]).ResultType of
      vtLeftBracket: Inc(brCount);
      vtRightBracket: Dec(brCount);
    end;
    Inc(Result);
  end;
end;

{ TFunction }

constructor TFunction.Create(AName, Descr, ATypeSpec: string; AMinFuncArg: Integer; AResultType: TVarType;
  AExprFunc: TExprFunc);
begin
  //to increase compatibility don't use default parameters
  FDescription := Descr;
  InternalCreate(AName, ATypeSpec, AMinFuncArg, AResultType, AExprFunc, false, 0);
end;

constructor TFunction.CreateOper(AName, ATypeSpec: string; AResultType: TVarType;
  AExprFunc: TExprFunc; AOperPrec: Integer);
begin
  InternalCreate(AName, ATypeSpec, -1, AResultType, AExprFunc, true, AOperPrec);
end;

procedure TFunction.InternalCreate(AName, ATypeSpec: string; AMinFuncArg: Integer; AResultType: TVarType;
  AExprFunc: TExprFunc; AIsOper: Boolean; AOperPrec: Integer);
begin
  inherited Create(AName, AExprFunc);

  FMaxFunctionArg := Length(ATypeSpec);
  FMinFunctionArg := AMinFuncArg;
  if AMinFuncArg = -1 then
    FMinFunctionArg := FMaxFunctionArg;
  FIsOper := AIsOper;
  FOperPrec := AOperPrec;
  FTypeSpec := ATypeSpec;
  FResultType := AResultType;

  // check correctness
  if FMaxFunctionArg > MaxArg then
    raise EParserException.Create('Too many arguments');
end;

function TFunction.GetDescription: string;
begin
  Result := FDescription;
end;

function TFunction.GetIsOper: Boolean;
begin
  Result := FIsOper;
end;

function TFunction.GetMinFunctionArg: Integer;
begin
  Result := FMinFunctionArg;
end;

function TFunction.GetMaxFunctionArg: Integer;
begin
  Result := FMaxFunctionArg;
end;

function TFunction.GetResultType: TVarType;
begin
  Result := FResultType;
end;

function TFunction.GetTypeSpec: string;
begin
  Result := FTypeSpec;
end;

function TFunction.IsFunction: Boolean;
begin
  Result := True;
end;

{ TVaryingFunction }

function TVaryingFunction.GetCanVary: Boolean;
begin
  Result := True;
end;

{ TDynamicType }

constructor TDynamicType.Create(DestMem, DestPos: PPChar; Size: PInteger);
begin
  inherited Create;

  FMemory := DestMem;
  FMemoryPos := DestPos;
  FSize := Size;
end;

procedure TDynamicType.Rewind;
begin
  FMemoryPos^ := FMemory^;
end;

procedure TDynamicType.AssureSpace(ASize: Integer);
begin
  // need more memory?
  if ((FMemoryPos^) - (FMemory^) + ASize) > (FSize^) then
    Resize((FMemoryPos^) - (FMemory^) + ASize, False);
end;

procedure TDynamicType.Resize(NewSize: Integer; Exact: Boolean);
var
  tempBuf: PChar;
  bytesCopy, pos: Integer;
begin
  // if not exact requested make newlength a multiple of ArgAllocSize
  if not Exact then
    NewSize := NewSize div ArgAllocSize * ArgAllocSize + ArgAllocSize;
  // create new buffer
  GetMem(tempBuf, NewSize);
  // copy memory
  bytesCopy := FSize^;
  if bytesCopy > NewSize then
    bytesCopy := NewSize;
  Move(FMemory^^, tempBuf^, bytesCopy);
  // save position in string
  pos := FMemoryPos^ - FMemory^;
  // delete old mem
  FreeMem(FMemory^);
  // assign new
  FMemory^ := tempBuf;
  FSize^ := NewSize;
  // assign position
  FMemoryPos^ := FMemory^ + pos;
end;

procedure TDynamicType.Append(Source: PChar; Length: Integer);
begin
  // make room for string plus null-terminator
  AssureSpace(Length+4);
  // copy
  Move(Source^, FMemoryPos^^, Length);
  Inc(FMemoryPos^, Length);
  // null-terminate
  FMemoryPos^^ := #0;
end;

end.


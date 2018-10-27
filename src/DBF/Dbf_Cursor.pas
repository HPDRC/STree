unit Dbf_Cursor;

interface

{$I Dbf_Common.inc}

uses
  SysUtils,
  Classes,
  Db,
  Dbf_PgFile,
  Dbf_Common;

type
  TSearchKeyType = (stEqual, stGreaterEqual, stGreater);

//====================================================================
  TVirtualCursor = class(TObject)
  private
    FFile: TPagedFile;

  protected
    function GetPhysicalRecno: Integer; virtual; abstract;
    function GetSequentialRecno: Integer; virtual; abstract;
    function GetSequentialRecordCount: Integer; virtual; abstract;
    procedure SetPhysicalRecno(Recno: Integer); virtual; abstract;
    procedure SetSequentialRecno(Recno: Integer); virtual; abstract;

  public
    constructor Create(pFile: TPagedFile);
    destructor Destroy; override;

    function  RecordSize: Integer;

    function  Next: Boolean; virtual; abstract;
    function  Prev: Boolean; virtual; abstract;
    procedure First; virtual; abstract;
    procedure Last; virtual; abstract;

    function  GetBookMark: rBookmarkData; virtual; abstract;
    procedure GotoBookmark(Bookmark: rBookmarkData); virtual; abstract;

    procedure Insert(Recno: Integer; Buffer: PChar); virtual; abstract;
    procedure Update(Recno: Integer; PrevBuffer,NewBuffer: PChar); virtual; abstract;

(*
{.$ifdef DELPHI_4}
    function  VariantToBuffer(Key: Variant; DoubleKey: PDouble; StringKey: PString): PChar; virtual;
{.$endif}
    function  CheckUserKey(Key: PChar; StringBuf: PChar): PChar; virtual;
    function  SearchKey(Key: PChar; SearchType: TSearchKeyType): Boolean; virtual;
    procedure CancelRange; virtual;
    procedure SetBracketLow; virtual;
    procedure SetBracketHigh; virtual;
*)

    property PagedFile: TPagedFile read FFile;
    property PhysicalRecNo: Integer read GetPhysicalRecNo write SetPhysicalRecNo;
    property SequentialRecNo: Integer read GetSequentialRecNo write SetSequentialRecNo;
    property SequentialRecordCount: Integer read GetSequentialRecordCount;
  end;

implementation

constructor TVirtualCursor.Create(pFile: TPagedFile);
begin
  FFile := pFile;
end;

destructor TVirtualCursor.Destroy; {override;}
begin
end;

function TVirtualCursor.RecordSize : Integer;
begin
  if FFile = nil then
    Result := 0
  else
    Result := FFile.RecordSize;
end;

(*

{.$ifdef DELPHI_4}

function TVirtualCursor.VariantToBuffer(Key: Variant; DoubleKey: PDouble; StringKey: PString): PChar;
begin
  Result := nil;
end;

{.$endif}

function TVirtualCursor.CheckUserKey(Key: PChar; StringBuf: PChar): PChar;
begin
  Result := Key;
end;

function TVirtualCursor.SearchKey(Key: PChar; SearchType: TSearchKeyType): Boolean; {virtual;}
begin
  Result := false;
end;

procedure TVirtualCursor.CancelRange; {virtual;}
begin
end;

procedure TVirtualCursor.SetBracketLow; {virtual;}
begin
end;

procedure TVirtualCursor.SetBracketHigh; {virtual;}
begin
end;

*)

end.


unit Dbf_Common;

interface

{$I Dbf_Common.inc}

uses
  SysUtils, Classes, DB,
{$ifdef WIN32}
  Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Grids, Menus, Buttons, ComCtrls;
{$endif}
{$ifdef LINUX}
  Libc, Types;
{$endif}


const
  // _MAJOR_VERSION
  _MAJOR_VERSION = 6;
  // _MINOR_VERSION
  _MINOR_VERSION = 20;
  // _SUB_MINOR_VERSION
  _SUB_MINOR_VERSION = 0;

type
  EDbfError = class (EDatabaseError);

  TDbfFieldType = char;
  PBookMarkData = ^rBookMarkData;
  rBookmarkData = Integer;

  xBaseVersion = (xUnknown, xClipper, xBaseIII, xBaseIV, xBaseV, xBaseVII, xFoxPro, xVisualFoxPro);

  TDateTimeHandling       = (dtDateTime, dtBDETimeStamp);

//-------------------------------------

  PSmallInt = ^SmallInt;
  PDouble = ^Double;
  PString = ^String;
  PDateTimeRec = ^TDateTimeRec;

{$ifdef DELPHI_4}
  PLargeInt = ^Int64;
{$endif}

//-------------------------------------

{$ifndef DELPHI_5}
// some procedures for the less lucky who don't have newer versions yet :-)
procedure FreeAndNil(var v);
{$endif}

//-------------------------------------

{$ifndef DELPHI_6}

const

{$ifdef WIN32}
  PathDelim = '\';
{$endif}
{$ifdef LINUX}
  PathDelim = '/';
{$endif}

function IncludeTrailingPathDelimiter(const Path: string): string;

{$endif}

//-------------------------------------

function GetCompletePath(const Base, Path: string): string;
function GetCompleteFileName(const Base, FileName: string): string;
function DateTimeToBDETimeStamp(aDT: TDateTime): double;
function BDETimeStampToDateTime(aBT: double): TDateTime;
function  GetStrFromInt(Val: Integer; const Dst: PChar): Integer;
procedure GetStrFromInt_Width(Val: Integer; const Width: Integer; const Dst: PChar);
{$ifdef DELPHI_4}
function  GetStrFromInt64(Val: Int64; const Dst: PChar): Integer;
procedure GetStrFromInt64_Width(Val: Int64; const Width: Integer; const Dst: PChar);
{$endif}
{$ifdef USE_CACHE}
function GetFreeMemory: Integer;
{$endif}


implementation

{$ifdef WIN32}
uses
  Windows;
{$endif}

//====================================================================

function GetCompletePath(const Base, Path: string): string;
begin
  if ((Length(Path)>=1) and (Path[1]=PathDelim))
{$ifdef WIN32}
     or ((Length(Path)>=2) and (Path[2]=':'))
{$endif}
  then begin
    // if the FFilePath is absolute...
    // it is either \blahblah or c: \
    Result := Path;
  end else begin
    Result := ExpandFileName(Base + Path);
    if (Length(Result) > 0) and (Result[Length(Result)] <> PathDelim) then
      Result := Result + PathDelim;
  end;

  // add last backslash if not present
  if Length(Result) > 0 then
    Result := IncludeTrailingPathDelimiter(Result);
end;

//====================================================================

function GetCompleteFileName(const Base, FileName: string): string;
var
  lpath: string;
  lfile: string;
begin
  lpath := GetCompletePath(Base, ExtractFilePath(FileName));
  lfile := ExtractFileName(FileName);
  lpath := lpath + lfile;
  result := lpath;
end;

// it seems there is no pascal function to convert an integer into a PChar???

procedure GetStrFromInt_Width(Val: Integer; const Width: Integer; const Dst: PChar);
var
  Temp: array[0..10] of Char;
  I, J, K, Sign: Integer;
begin
  Sign := Val;
  Val := Abs(Val);
  // we'll have to store characters backwards first
  I := 0;
  J := 0;
  repeat
    Temp[I] := Chr((Val mod 10) + Ord('0'));
    Val := Val div 10;
    Inc(I);
  until Val = 0;
  // add sign
  if Sign < 0 then
  begin
    Dst[J] := '-';
    Inc(J);
  end;
  // add spaces
  for K := 0 to Width - I - J - 1 do
  begin
    Dst[J] := '0';
    Inc(J);
  end;
  // if field too long, cut off
  if J + I > Width then
    I := Width - J;
  // copy value, remember: stored backwards
  repeat
    Dst[J] := Temp[I-1];
    Inc(J);
    Dec(I);
  until I = 0;
  // done!
end;

{$ifdef DELPHI_4}

procedure GetStrFromInt64_Width(Val: Int64; const Width: Integer; const Dst: PChar);
var
  Temp: array[0..19] of Char;
  I, J, K: Integer;
  Sign: Int64;
begin
  Sign := Val;
  Val := Abs(Val);
  // we'll have to store characters backwards first
  I := 0;
  J := 0;
  repeat
    Temp[I] := Chr((Val mod 10) + Ord('0'));
    Val := Val div 10;
    inc(I);
  until Val = 0;
  // add sign
  if Sign < 0 then
  begin
    Dst[J] := '-';
    inc(J);
  end;
  // add spaces
  for K := 0 to Width - I - J - 1 do
  begin
    Dst[J] := '0';
    inc(J);
  end;
  // if field too long, cut off
  if J + I > Width then
    I := Width - J;
  // copy value, remember: stored backwards
  repeat
    Dst[J] := Temp[I-1];
    inc(J);
    dec(I);
  until I = 0;
  // done!
end;
{$endif}

// it seems there is no pascal function to convert an integer into a PChar???
// NOTE: in dbf_dbffile.pas there is also a convert routine, but is slightly different

function GetStrFromInt(Val: Integer; const Dst: PChar): Integer;
var
  Temp: array[0..10] of Char;
  I, J: Integer;
begin
  Val := Abs(Val);
  // we'll have to store characters backwards first
  I := 0;
  J := 0;
  repeat
    Temp[I] := Chr((Val mod 10) + Ord('0'));
    Val := Val div 10;
    Inc(I);
  until Val = 0;

  // remember number of digits
  Result := I;
  // copy value, remember: stored backwards
  repeat
    Dst[J] := Temp[I-1];
    Inc(J);
    Dec(I);
  until I = 0;
  // done!
end;

{$ifdef DELPHI_4}
function GetStrFromInt64(Val: Int64; const Dst: PChar): Integer;
var
  Temp: array[0..19] of Char;
  I, J: Integer;
begin
  Val := Abs(Val);
  // we'll have to store characters backwards first
  I := 0;
  J := 0;
  repeat
    Temp[I] := Chr((Val mod 10) + Ord('0'));
    Val := Val div 10;
    Inc(I);
  until Val = 0;

  // remember number of digits
  Result := I;
  // copy value, remember: stored backwards
  repeat
    Dst[J] := Temp[I-1];
    inc(J);
    dec(I);
  until I = 0;
  // done!
end;
{$endif}

function DateTimeToBDETimeStamp(aDT: TDateTime): Double;
var
  aTS: TTimeStamp;
begin
  aTS := DateTimeToTimeStamp(aDT);
  Result := TimeStampToMSecs(aTS);
end;

function BDETimeStampToDateTime(aBT: Double): TDateTime;
var
  aTS: TTimeStamp;
begin
  aTS := MSecsToTimeStamp(aBT);
  Result := TimeStampToDateTime(aTS);
end;

//====================================================================

{$ifndef DELPHI_5}

procedure FreeAndNil(var v);
begin
  try
    TObject(v).Free;
  finally
    TObject(v) := nil;
  end;
end;

{$endif}

//====================================================================

{$ifndef DELPHI_6}

function IncludeTrailingPathDelimiter(const Path: string): string;
begin
  Result := Path;
  if Result[Length(Result)] <> PathDelim then
    Result := Result + PathDelim;
end;

{$endif}

{$ifdef USE_CACHE}

function GetFreeMemory: Integer;
var
  MemStatus: TMemoryStatus;
begin
  GlobalMemoryStatus(MemStatus);
  Result := MemStatus.dwAvailPhys;
end;

{$endif}


end.


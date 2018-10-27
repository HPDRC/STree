unit inovaGIS_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : 1.2
// File generated on 12/12/2003 8:10:54 PM from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Program Files\inovaGIS\BIN\inovaGIS31.dll (1)
// LIBID: {6C942560-A98E-11D3-A52B-0000E85E2CDE}
// LCID: 0
// Helpfile: 
// HelpString: inovaGIS Base Library 3.1.
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINNT\System32\stdole2.tlb)
// Errors:
//   Hint: Symbol 'ClassName' renamed to '_className'
//   Hint: Symbol 'ClassName' renamed to '_className'
// ************************************************************************ //
// *************************************************************************//
// NOTE:                                                                      
// Items guarded by $IFDEF_LIVE_SERVER_AT_DESIGN_TIME are used by properties  
// which return objects that may need to be explicitly created via a function 
// call prior to any access via the property. These items have been disabled  
// in order to prevent accidental use from within the object inspector. You   
// may enable them by defining LIVE_SERVER_AT_DESIGN_TIME or by selectively   
// removing them from the $IFDEF blocks. However, such items must still be    
// programmatically created via a method of the appropriate CoClass before    
// they can be used.                                                          
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, OleServer, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  inovaGISMajorVersion = 3;
  inovaGISMinorVersion = 1;

  LIBID_inovaGIS: TGUID = '{6C942560-A98E-11D3-A52B-0000E85E2CDE}';

  IID_IiFile: TGUID = '{6C942561-A98E-11D3-A52B-0000E85E2CDE}';
  CLASS_iFile: TGUID = '{6C942563-A98E-11D3-A52B-0000E85E2CDE}';
  IID_IiPal: TGUID = '{6C942565-A98E-11D3-A52B-0000E85E2CDE}';
  CLASS_iPal: TGUID = '{6C942567-A98E-11D3-A52B-0000E85E2CDE}';
  IID_IiColor: TGUID = '{6C942569-A98E-11D3-A52B-0000E85E2CDE}';
  CLASS_iColor: TGUID = '{6C94256B-A98E-11D3-A52B-0000E85E2CDE}';
  IID_IiFont: TGUID = '{6C94256D-A98E-11D3-A52B-0000E85E2CDE}';
  CLASS_iFont: TGUID = '{6C94256F-A98E-11D3-A52B-0000E85E2CDE}';
  IID_IiLegend: TGUID = '{6C942571-A98E-11D3-A52B-0000E85E2CDE}';
  CLASS_iLegend: TGUID = '{6C942573-A98E-11D3-A52B-0000E85E2CDE}';
  IID_IiData: TGUID = '{6C942575-A98E-11D3-A52B-0000E85E2CDE}';
  CLASS_iData: TGUID = '{6C942577-A98E-11D3-A52B-0000E85E2CDE}';
  IID_IiGeoData: TGUID = '{6C942579-A98E-11D3-A52B-0000E85E2CDE}';
  CLASS_iGeoData: TGUID = '{6C94257B-A98E-11D3-A52B-0000E85E2CDE}';
  IID_IiRaster: TGUID = '{6C94257D-A98E-11D3-A52B-0000E85E2CDE}';
  CLASS_iRaster: TGUID = '{6C94257F-A98E-11D3-A52B-0000E85E2CDE}';
  IID_IiImg: TGUID = '{6C942581-A98E-11D3-A52B-0000E85E2CDE}';
  CLASS_iImg: TGUID = '{6C942583-A98E-11D3-A52B-0000E85E2CDE}';
  IID_IiStringList: TGUID = '{6C942588-A98E-11D3-A52B-0000E85E2CDE}';
  CLASS_iStringList: TGUID = '{6C94258A-A98E-11D3-A52B-0000E85E2CDE}';
  IID_IiScalar: TGUID = '{6C942592-A98E-11D3-A52B-0000E85E2CDE}';
  CLASS_iScalar: TGUID = '{6C942594-A98E-11D3-A52B-0000E85E2CDE}';
  IID_IiVectorial: TGUID = '{6C942596-A98E-11D3-A52B-0000E85E2CDE}';
  CLASS_iVectorial: TGUID = '{6C942598-A98E-11D3-A52B-0000E85E2CDE}';
  IID_IiVec: TGUID = '{6C94259A-A98E-11D3-A52B-0000E85E2CDE}';
  CLASS_iVec: TGUID = '{6C94259E-A98E-11D3-A52B-0000E85E2CDE}';
  IID_IiDiscreteLeg: TGUID = '{6C9425A2-A98E-11D3-A52B-0000E85E2CDE}';
  CLASS_iDiscreteLeg: TGUID = '{6C9425A4-A98E-11D3-A52B-0000E85E2CDE}';
  IID_IiContLeg: TGUID = '{6C9425A6-A98E-11D3-A52B-0000E85E2CDE}';
  CLASS_iContLeg: TGUID = '{6C9425A8-A98E-11D3-A52B-0000E85E2CDE}';
  IID_IiVal: TGUID = '{6C9425AB-A98E-11D3-A52B-0000E85E2CDE}';
  CLASS_iVal: TGUID = '{6C9425AD-A98E-11D3-A52B-0000E85E2CDE}';
  IID_IiShp: TGUID = '{A42E61F1-A993-11D3-A52C-0000E85E2CDE}';
  CLASS_iShp: TGUID = '{A42E61F3-A993-11D3-A52C-0000E85E2CDE}';
  IID_IIiDRISIVal: TGUID = '{F1DD7E31-BC5F-11D3-A532-0000E85E2CDE}';
  CLASS_iIdrisiVal: TGUID = '{F1DD7E33-BC5F-11D3-A532-0000E85E2CDE}';
  IID_IiDbf: TGUID = '{F1DD7E35-BC5F-11D3-A532-0000E85E2CDE}';
  CLASS_iDbf: TGUID = '{F1DD7E37-BC5F-11D3-A532-0000E85E2CDE}';
  IID_IiPaint: TGUID = '{5BA340A0-C918-11D3-BE9A-8CFFB6DC2143}';
  CLASS_iPaint: TGUID = '{5BA340A2-C918-11D3-BE9A-8CFFB6DC2143}';
  IID_IiRst: TGUID = '{A7CFB2DC-7CD3-11D4-A88D-00A0C9EC10A4}';
  CLASS_iRst: TGUID = '{A7CFB2DE-7CD3-11D4-A88D-00A0C9EC10A4}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum iFileTypeConst
type
  iFileTypeConst = TOleEnum;
const
  iUnavailable = $00000000;
  iBinary = $00000001;
  iASCII = $00000002;
  iCompressed = $00000003;

// Constants for enum iDataTypeConst
type
  iDataTypeConst = TOleEnum;
const
  iUnavailableData = $00000000;
  iInteger = $00000001;
  iLong = $00000002;
  iSingle = $00000003;
  iDouble = $00000004;
  iCurrency = $00000005;
  iBoolean = $00000006;
  iByte = $00000007;
  iWord = $00000008;
  iRGB8 = $00000009;
  iRGB24 = $0000000A;

// Constants for enum iPalettes
type
  iPalettes = TOleEnum;
const
  UserDefined = $00000000;
  Grey256 = $00000001;
  Grey16 = $00000002;
  Alt256 = $00000003;
  Composit = $00000004;
  Idri256 = $00000005;
  Idri16 = $00000006;
  Ibm16 = $00000007;
  S16 = $00000008;
  BiMod16 = $00000009;
  BiMod256 = $0000000A;
  BiPol16 = $0000000B;
  BiPol256 = $0000000C;
  Ndvi16 = $0000000D;
  Ndvi256 = $0000000E;
  Qual16 = $0000000F;
  Qual256 = $00000010;
  Quant256 = $00000011;
  Qual512 = $00000012;
  Qual1024 = $00000013;

// Constants for enum iTextPosition
type
  iTextPosition = TOleEnum;
const
  iRight = $00000000;
  iBottom = $00000001;
  iLeft = $00000002;
  iTop = $00000003;

// Constants for enum iShapeType
type
  iShapeType = TOleEnum;
const
  iNullText = $00000000;
  iPoint = $00000001;
  iPolyLine = $00000003;
  iPolygon = $00000005;
  iMultiPoint = $00000008;
  iPointZ = $0000000B;
  iPolyLineZ = $0000000D;
  iPolygonZ = $0000000F;
  iMultiPointZ = $00000012;
  iPointM = $00000015;
  iPolyLineM = $00000017;
  iPolygonM = $00000019;
  iMultiPointM = $0000001C;
  iMultiPatch = $0000001F;

// Constants for enum iVectorialVersion
type
  iVectorialVersion = TOleEnum;
const
  iDefault = $00000008;
  iIdrisi = $00000004;

// Constants for enum LegType
type
  LegType = TOleEnum;
const
  iUntyped = $00000000;
  iDiscrete = $00000001;
  iContinuos = $00000002;

// Constants for enum iAtriValFilesType
type
  iAtriValFilesType = TOleEnum;
const
  iValASCII = $00000000;
  iValFixed = $00000001;
  iValUnknownType = $00000002;

// Constants for enum iFeatureType
type
  iFeatureType = TOleEnum;
const
  iUnsupported = $00000000;
  iFeatureSmallInt = $00000001;
  iFeatureInteger = $00000002;
  iFeatureFloat = $00000003;
  iFeatureText = $00000004;
  iFeatureReal = $00000005;

// Constants for enum iBrushStyle
type
  iBrushStyle = TOleEnum;
const
  iBSSolid = $00000000;
  iBSClear = $00000001;
  iBSBDiagonal = $00000002;
  iBSFDiagonal = $00000003;
  iBSCross = $00000004;
  iBSDiagCross = $00000005;
  iBSHorizontal = $00000006;
  iBSVertical = $00000007;

// Constants for enum iPenStyle
type
  iPenStyle = TOleEnum;
const
  iPSSolid = $00000000;
  iPSDash = $00000001;
  iPSDot = $00000002;
  iPSDashDot = $00000003;
  iPSDashDotDot = $00000004;
  iPSNull = $00000005;
  iPSInsedeFrame = $00000006;

// Constants for enum iByteOrder
type
  iByteOrder = TOleEnum;
const
  iIntelByte = $00000000;
  iMotorolaByte = $00000001;

// Constants for enum iScanlineOrientType
type
  iScanlineOrientType = TOleEnum;
const
  iUpperLeftHorizontal = $00000004;
  iUpperLeftVertical = $00000000;
  iUpperRightHorizontal = $00000005;
  iUpperRightVertical = $00000001;
  iLowerLeftHorizontal = $00000006;
  iLowerLeftVertical = $00000002;
  iLowerRightHorizontal = $00000007;
  iLowerRightVertical = $00000003;

// Constants for enum iStreamType
type
  iStreamType = TOleEnum;
const
  iOriginalFormat = $00000000;
  iRasterDataRowMajor = $00000001;
  iRasterDataColMajor = $00000002;
  iBMP24Bits = $0000000A;
  iBMP8Bits = $0000000B;
  iJPEGVeryHighQuality = $00000014;
  iJPEGHighQuality = $00000015;
  iJPEGMediumQuality = $00000016;
  iJPEGLowQuality = $00000017;
  iJPEGVeryLowQuality = $00000018;
  iGifStream = $0000001E;
  iWbmpStream = $0000000F;
  iPNGStream = $00000028;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IiFile = interface;
  IiFileDisp = dispinterface;
  IiPal = interface;
  IiPalDisp = dispinterface;
  IiColor = interface;
  IiColorDisp = dispinterface;
  IiFont = interface;
  IiFontDisp = dispinterface;
  IiLegend = interface;
  IiLegendDisp = dispinterface;
  IiData = interface;
  IiDataDisp = dispinterface;
  IiGeoData = interface;
  IiGeoDataDisp = dispinterface;
  IiRaster = interface;
  IiRasterDisp = dispinterface;
  IiImg = interface;
  IiImgDisp = dispinterface;
  IiStringList = interface;
  IiStringListDisp = dispinterface;
  IiScalar = interface;
  IiScalarDisp = dispinterface;
  IiVectorial = interface;
  IiVectorialDisp = dispinterface;
  IiVec = interface;
  IiVecDisp = dispinterface;
  IiDiscreteLeg = interface;
  IiDiscreteLegDisp = dispinterface;
  IiContLeg = interface;
  IiContLegDisp = dispinterface;
  IiVal = interface;
  IiValDisp = dispinterface;
  IiShp = interface;
  IiShpDisp = dispinterface;
  IIiDRISIVal = interface;
  IIiDRISIValDisp = dispinterface;
  IiDbf = interface;
  IiDbfDisp = dispinterface;
  IiPaint = interface;
  IiPaintDisp = dispinterface;
  IiRst = interface;
  IiRstDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  iFile = IiFile;
  iPal = IiPal;
  iColor = IiColor;
  iFont = IiFont;
  iLegend = IiLegend;
  iData = IiData;
  iGeoData = IiGeoData;
  iRaster = IiRaster;
  iImg = IiImg;
  iStringList = IiStringList;
  iScalar = IiScalar;
  iVectorial = IiVectorial;
  iVec = IiVec;
  iDiscreteLeg = IiDiscreteLeg;
  iContLeg = IiContLeg;
  iVal = IiVal;
  iShp = IiShp;
  iIdrisiVal = IIiDRISIVal;
  iDbf = IiDbf;
  iPaint = IiPaint;
  iRst = IiRst;


// *********************************************************************//
// Interface: IiFile
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {6C942561-A98E-11D3-A52B-0000E85E2CDE}
// *********************************************************************//
  IiFile = interface(IDispatch)
    ['{6C942561-A98E-11D3-A52B-0000E85E2CDE}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(const Value: WideString); safecall;
    function Get_Directory: WideString; safecall;
    procedure Set_Directory(const Value: WideString); safecall;
    function GetFileName: WideString; safecall;
    function Get_FileType: iFileTypeConst; safecall;
    procedure Set_FileType(Value: iFileTypeConst); safecall;
    function Get_Empty: WordBool; safecall;
    procedure Set_Empty(Value: WordBool); safecall;
    function FileOpen: WordBool; safecall;
    function FileClose: WordBool; safecall;
    function Get_Extension: WideString; safecall;
    procedure Set_Extension(const Value: WideString); safecall;
    function Get_HeaderExtension: WideString; safecall;
    procedure Set_HeaderExtension(const Value: WideString); safecall;
    function GetHeader(out DocText: OleVariant): Smallint; safecall;
    function SetHeader(DocText: OleVariant): WordBool; safecall;
    function GetFileSize: Integer; safecall;
    function FileSeek(Position: Integer): WordBool; safecall;
    function FileBlockRead(out Buf: OleVariant; Count: Integer): Integer; safecall;
    function FileBlockWrite(Buf: OleVariant): Integer; safecall;
    procedure FileRead; safecall;
    procedure FileWrite; safecall;
    procedure FileNew; safecall;
    procedure ReadLn(var Param: OleVariant); safecall;
    function CheckFileExists: WordBool; safecall;
    function FileBlockReadWithStep(out Buf: OleVariant; Count: Integer; Step: Integer; 
                                   DataType: iDataTypeConst): Integer; safecall;
    function Get_Process: IUnknown; safecall;
    procedure Set_Process(const Value: IUnknown); safecall;
    function Get_IndexFileExtension: WideString; safecall;
    procedure Set_IndexFileExtension(const Value: WideString); safecall;
    procedure GetIndexFileExtension(out FileBuffer: OleVariant); safecall;
    procedure SetIndexFileExtension(FileBuffer: OleVariant); safecall;
    function Get_ReadOnly: WordBool; safecall;
    procedure Set_ReadOnly(Value: WordBool); safecall;
    procedure AssignObject(const Source: iFile); safecall;
    function CreateDirFileList: iStringList; safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Directory: WideString read Get_Directory write Set_Directory;
    property FileType: iFileTypeConst read Get_FileType write Set_FileType;
    property Empty: WordBool read Get_Empty write Set_Empty;
    property Extension: WideString read Get_Extension write Set_Extension;
    property HeaderExtension: WideString read Get_HeaderExtension write Set_HeaderExtension;
    property Process: IUnknown read Get_Process write Set_Process;
    property IndexFileExtension: WideString read Get_IndexFileExtension write Set_IndexFileExtension;
    property ReadOnly: WordBool read Get_ReadOnly write Set_ReadOnly;
  end;

// *********************************************************************//
// DispIntf:  IiFileDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {6C942561-A98E-11D3-A52B-0000E85E2CDE}
// *********************************************************************//
  IiFileDisp = dispinterface
    ['{6C942561-A98E-11D3-A52B-0000E85E2CDE}']
    property Name: WideString dispid 1;
    property Directory: WideString dispid 2;
    function GetFileName: WideString; dispid 3;
    property FileType: iFileTypeConst dispid 4;
    property Empty: WordBool dispid 6;
    function FileOpen: WordBool; dispid 11;
    function FileClose: WordBool; dispid 12;
    property Extension: WideString dispid 13;
    property HeaderExtension: WideString dispid 14;
    function GetHeader(out DocText: OleVariant): Smallint; dispid 15;
    function SetHeader(DocText: OleVariant): WordBool; dispid 16;
    function GetFileSize: Integer; dispid 17;
    function FileSeek(Position: Integer): WordBool; dispid 18;
    function FileBlockRead(out Buf: OleVariant; Count: Integer): Integer; dispid 19;
    function FileBlockWrite(Buf: OleVariant): Integer; dispid 20;
    procedure FileRead; dispid 21;
    procedure FileWrite; dispid 22;
    procedure FileNew; dispid 23;
    procedure ReadLn(var Param: OleVariant); dispid 29;
    function CheckFileExists: WordBool; dispid 30;
    function FileBlockReadWithStep(out Buf: OleVariant; Count: Integer; Step: Integer; 
                                   DataType: iDataTypeConst): Integer; dispid 32;
    property Process: IUnknown dispid 25;
    property IndexFileExtension: WideString dispid 26;
    procedure GetIndexFileExtension(out FileBuffer: OleVariant); dispid 27;
    procedure SetIndexFileExtension(FileBuffer: OleVariant); dispid 28;
    property ReadOnly: WordBool dispid 33;
    procedure AssignObject(const Source: iFile); dispid 35;
    function CreateDirFileList: iStringList; dispid 5;
  end;

// *********************************************************************//
// Interface: IiPal
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {6C942565-A98E-11D3-A52B-0000E85E2CDE}
// *********************************************************************//
  IiPal = interface(IDispatch)
    ['{6C942565-A98E-11D3-A52B-0000E85E2CDE}']
    function Get_Name: iPalettes; safecall;
    procedure Set_Name(Value: iPalettes); safecall;
    function Get_NumColors: Integer; safecall;
    function Get_Color(X: Integer): iColor; safecall;
    procedure Set_Color(X: Integer; const Value: iColor); safecall;
    function Get_Document: iFile; safecall;
    procedure Set_Document(const Value: iFile); safecall;
    procedure AddColor(Red: Byte; Green: Byte; Blue: Byte); safecall;
    procedure RemoveColor(ColorNumber: Integer); safecall;
    function Open: WordBool; safecall;
    procedure Save; safecall;
    procedure SaveAs; safecall;
    procedure Close; safecall;
    function Get_Changed: WordBool; safecall;
    procedure Set_Changed(Value: WordBool); safecall;
    function Get_ColorBuffer: OleVariant; safecall;
    procedure Set_ColorBuffer(Value: OleVariant); safecall;
    function Get_Process: IUnknown; safecall;
    procedure Set_Process(const Value: IUnknown); safecall;
    procedure AssignObject(const Source: iPal); safecall;
    procedure Invert; safecall;
    property Name: iPalettes read Get_Name write Set_Name;
    property NumColors: Integer read Get_NumColors;
    property Color[X: Integer]: iColor read Get_Color write Set_Color;
    property Document: iFile read Get_Document write Set_Document;
    property Changed: WordBool read Get_Changed write Set_Changed;
    property ColorBuffer: OleVariant read Get_ColorBuffer write Set_ColorBuffer;
    property Process: IUnknown read Get_Process write Set_Process;
  end;

// *********************************************************************//
// DispIntf:  IiPalDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {6C942565-A98E-11D3-A52B-0000E85E2CDE}
// *********************************************************************//
  IiPalDisp = dispinterface
    ['{6C942565-A98E-11D3-A52B-0000E85E2CDE}']
    property Name: iPalettes dispid 1;
    property NumColors: Integer readonly dispid 2;
    property Color[X: Integer]: iColor dispid 3;
    property Document: iFile dispid 4;
    procedure AddColor(Red: Byte; Green: Byte; Blue: Byte); dispid 5;
    procedure RemoveColor(ColorNumber: Integer); dispid 6;
    function Open: WordBool; dispid 7;
    procedure Save; dispid 8;
    procedure SaveAs; dispid 9;
    procedure Close; dispid 10;
    property Changed: WordBool dispid 11;
    property ColorBuffer: OleVariant dispid 12;
    property Process: IUnknown dispid 13;
    procedure AssignObject(const Source: iPal); dispid 14;
    procedure Invert; dispid 15;
  end;

// *********************************************************************//
// Interface: IiColor
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {6C942569-A98E-11D3-A52B-0000E85E2CDE}
// *********************************************************************//
  IiColor = interface(IDispatch)
    ['{6C942569-A98E-11D3-A52B-0000E85E2CDE}']
    function Get_Red: Byte; safecall;
    procedure Set_Red(Red: Byte); safecall;
    function Get_Green: Byte; safecall;
    procedure Set_Green(Green: Byte); safecall;
    function Get_Blue: Byte; safecall;
    procedure Set_Blue(Blue: Byte); safecall;
    function Get_Process: IUnknown; safecall;
    procedure Set_Process(const Value: IUnknown); safecall;
    property Red: Byte read Get_Red write Set_Red;
    property Green: Byte read Get_Green write Set_Green;
    property Blue: Byte read Get_Blue write Set_Blue;
    property Process: IUnknown read Get_Process write Set_Process;
  end;

// *********************************************************************//
// DispIntf:  IiColorDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {6C942569-A98E-11D3-A52B-0000E85E2CDE}
// *********************************************************************//
  IiColorDisp = dispinterface
    ['{6C942569-A98E-11D3-A52B-0000E85E2CDE}']
    property Red: Byte dispid 1;
    property Green: Byte dispid 2;
    property Blue: Byte dispid 3;
    property Process: IUnknown dispid 4;
  end;

// *********************************************************************//
// Interface: IiFont
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {6C94256D-A98E-11D3-A52B-0000E85E2CDE}
// *********************************************************************//
  IiFont = interface(IDispatch)
    ['{6C94256D-A98E-11D3-A52B-0000E85E2CDE}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(const Name: WideString); safecall;
    function Get_Size: Integer; safecall;
    procedure Set_Size(Size: Integer); safecall;
    function Get_Style: Byte; safecall;
    procedure Set_Style(Style: Byte); safecall;
    function Get_Process: IUnknown; safecall;
    procedure Set_Process(const Value: IUnknown); safecall;
    procedure AssignObject(const Source: iFont); safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Size: Integer read Get_Size write Set_Size;
    property Style: Byte read Get_Style write Set_Style;
    property Process: IUnknown read Get_Process write Set_Process;
  end;

// *********************************************************************//
// DispIntf:  IiFontDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {6C94256D-A98E-11D3-A52B-0000E85E2CDE}
// *********************************************************************//
  IiFontDisp = dispinterface
    ['{6C94256D-A98E-11D3-A52B-0000E85E2CDE}']
    property Name: WideString dispid 1;
    property Size: Integer dispid 2;
    property Style: Byte dispid 3;
    property Process: IUnknown dispid 4;
    procedure AssignObject(const Source: iFont); dispid 5;
  end;

// *********************************************************************//
// Interface: IiLegend
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {6C942571-A98E-11D3-A52B-0000E85E2CDE}
// *********************************************************************//
  IiLegend = interface(IDispatch)
    ['{6C942571-A98E-11D3-A52B-0000E85E2CDE}']
    function Get_Width: Integer; safecall;
    procedure Set_Width(Value: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(Value: Integer); safecall;
    function Get_hDC: Integer; safecall;
    function Get_Palette: iPal; safecall;
    procedure Set_Palette(const Value: iPal); safecall;
    function Get_Count: Integer; safecall;
    function Get_Font: iFont; safecall;
    procedure Set_Font(const Value: iFont); safecall;
    function Get_Horizontal: WordBool; safecall;
    procedure Set_Horizontal(Value: WordBool); safecall;
    function Get_BackColor: Integer; safecall;
    procedure Set_BackColor(Value: Integer); safecall;
    function Get_BorderColor: Integer; safecall;
    procedure Set_BorderColor(Value: Integer); safecall;
    function Get_TextPosition: iTextPosition; safecall;
    procedure Set_TextPosition(Value: iTextPosition); safecall;
    function Get_DistSclTxt: Integer; safecall;
    procedure Set_DistSclTxt(Value: Integer); safecall;
    function Get_MaxTextHeight: Integer; safecall;
    function Get_MaxTextWidth: Integer; safecall;
    function Get_MaxValue: Double; safecall;
    procedure Set_MaxValue(Value: Double); safecall;
    function Get_MinValue: Double; safecall;
    procedure Set_MinValue(Value: Double); safecall;
    function Get_Decimal: Integer; safecall;
    procedure Set_Decimal(Value: Integer); safecall;
    procedure Draw(Left: Integer; Top: Integer; PictureHandle: Integer); safecall;
    procedure Copy; safecall;
    procedure SetAutoSize; safecall;
    procedure SaveAsJPEG; safecall;
    procedure Add(const ClassName: WideString); safecall;
    procedure Clear; safecall;
    function Get_iType: LegType; safecall;
    function Get_FlagVal: Single; safecall;
    procedure Set_FlagVal(Value: Single); safecall;
    function Get_FlagDef: WideString; safecall;
    procedure Set_FlagDef(const Value: WideString); safecall;
    function Get_RefSys: WideString; safecall;
    procedure Set_RefSys(const Value: WideString); safecall;
    function Get_UnitDist: Double; safecall;
    procedure Set_UnitDist(Value: Double); safecall;
    function Get_RefUnits: WideString; safecall;
    procedure Set_RefUnits(const Value: WideString); safecall;
    function Get_ValUnits: WideString; safecall;
    procedure Set_ValUnits(const Value: WideString); safecall;
    function StreamAs(StreamType: iStreamType): OleVariant; safecall;
    function Get_Process: IUnknown; safecall;
    procedure Set_Process(const Value: IUnknown); safecall;
    procedure Refresh; safecall;
    procedure AssignObject(const Source: iLegend); safecall;
    function Get__className(X: Integer): WideString; safecall;
    procedure Set__className(X: Integer; const Value: WideString); safecall;
    function Get_Disabled(LegendNumber: Integer): WordBool; safecall;
    procedure Set_Disabled(LegendNumber: Integer; Value: WordBool); safecall;
    property Width: Integer read Get_Width write Set_Width;
    property Height: Integer read Get_Height write Set_Height;
    property hDC: Integer read Get_hDC;
    property Palette: iPal read Get_Palette write Set_Palette;
    property Count: Integer read Get_Count;
    property Font: iFont read Get_Font write Set_Font;
    property Horizontal: WordBool read Get_Horizontal write Set_Horizontal;
    property BackColor: Integer read Get_BackColor write Set_BackColor;
    property BorderColor: Integer read Get_BorderColor write Set_BorderColor;
    property TextPosition: iTextPosition read Get_TextPosition write Set_TextPosition;
    property DistSclTxt: Integer read Get_DistSclTxt write Set_DistSclTxt;
    property MaxTextHeight: Integer read Get_MaxTextHeight;
    property MaxTextWidth: Integer read Get_MaxTextWidth;
    property MaxValue: Double read Get_MaxValue write Set_MaxValue;
    property MinValue: Double read Get_MinValue write Set_MinValue;
    property Decimal: Integer read Get_Decimal write Set_Decimal;
    property iType: LegType read Get_iType;
    property FlagVal: Single read Get_FlagVal write Set_FlagVal;
    property FlagDef: WideString read Get_FlagDef write Set_FlagDef;
    property RefSys: WideString read Get_RefSys write Set_RefSys;
    property UnitDist: Double read Get_UnitDist write Set_UnitDist;
    property RefUnits: WideString read Get_RefUnits write Set_RefUnits;
    property ValUnits: WideString read Get_ValUnits write Set_ValUnits;
    property Process: IUnknown read Get_Process write Set_Process;
    property _className[X: Integer]: WideString read Get__className write Set__className;
    property Disabled[LegendNumber: Integer]: WordBool read Get_Disabled write Set_Disabled;
  end;

// *********************************************************************//
// DispIntf:  IiLegendDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {6C942571-A98E-11D3-A52B-0000E85E2CDE}
// *********************************************************************//
  IiLegendDisp = dispinterface
    ['{6C942571-A98E-11D3-A52B-0000E85E2CDE}']
    property Width: Integer dispid 1;
    property Height: Integer dispid 2;
    property hDC: Integer readonly dispid 3;
    property Palette: iPal dispid 4;
    property Count: Integer readonly dispid 6;
    property Font: iFont dispid 7;
    property Horizontal: WordBool dispid 8;
    property BackColor: Integer dispid 9;
    property BorderColor: Integer dispid 10;
    property TextPosition: iTextPosition dispid 11;
    property DistSclTxt: Integer dispid 12;
    property MaxTextHeight: Integer readonly dispid 13;
    property MaxTextWidth: Integer readonly dispid 14;
    property MaxValue: Double dispid 15;
    property MinValue: Double dispid 16;
    property Decimal: Integer dispid 17;
    procedure Draw(Left: Integer; Top: Integer; PictureHandle: Integer); dispid 18;
    procedure Copy; dispid 19;
    procedure SetAutoSize; dispid 20;
    procedure SaveAsJPEG; dispid 21;
    procedure Add(const ClassName: WideString); dispid 22;
    procedure Clear; dispid 23;
    property iType: LegType readonly dispid 24;
    property FlagVal: Single dispid 25;
    property FlagDef: WideString dispid 26;
    property RefSys: WideString dispid 27;
    property UnitDist: Double dispid 28;
    property RefUnits: WideString dispid 29;
    property ValUnits: WideString dispid 30;
    function StreamAs(StreamType: iStreamType): OleVariant; dispid 31;
    property Process: IUnknown dispid 32;
    procedure Refresh; dispid 33;
    procedure AssignObject(const Source: iLegend); dispid 34;
    property _className[X: Integer]: WideString dispid 36;
    property Disabled[LegendNumber: Integer]: WordBool dispid 5;
  end;

// *********************************************************************//
// Interface: IiData
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {6C942575-A98E-11D3-A52B-0000E85E2CDE}
// *********************************************************************//
  IiData = interface(IDispatch)
    ['{6C942575-A98E-11D3-A52B-0000E85E2CDE}']
    function Get_CheckStatus: Byte; safecall;
    procedure Set_CheckStatus(Value: Byte); safecall;
    function Get_Empty: WordBool; safecall;
    procedure Set_Empty(Value: WordBool); safecall;
    function Get_Changed: WordBool; safecall;
    procedure Set_Changed(Value: WordBool); safecall;
    function Get_Error: WideString; safecall;
    function Get_ObjectName: WideString; safecall;
    function Get_Process: IUnknown; safecall;
    procedure Set_Process(const Value: IUnknown); safecall;
    function Get_DataHandle: Integer; safecall;
    function ArrayOfVar(SourceArray: OleVariant): OleVariant; safecall;
    procedure AssignObject(const Source: iData); safecall;
    function Get_Status: WideString; safecall;
    function Get_Processing: WordBool; safecall;
    function Get_PercentDone: Byte; safecall;
    property CheckStatus: Byte read Get_CheckStatus write Set_CheckStatus;
    property Empty: WordBool read Get_Empty write Set_Empty;
    property Changed: WordBool read Get_Changed write Set_Changed;
    property Error: WideString read Get_Error;
    property ObjectName: WideString read Get_ObjectName;
    property Process: IUnknown read Get_Process write Set_Process;
    property DataHandle: Integer read Get_DataHandle;
    property Status: WideString read Get_Status;
    property Processing: WordBool read Get_Processing;
    property PercentDone: Byte read Get_PercentDone;
  end;

// *********************************************************************//
// DispIntf:  IiDataDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {6C942575-A98E-11D3-A52B-0000E85E2CDE}
// *********************************************************************//
  IiDataDisp = dispinterface
    ['{6C942575-A98E-11D3-A52B-0000E85E2CDE}']
    property CheckStatus: Byte dispid 1;
    property Empty: WordBool dispid 2;
    property Changed: WordBool dispid 3;
    property Error: WideString readonly dispid 4;
    property ObjectName: WideString readonly dispid 5;
    property Process: IUnknown dispid 6;
    property DataHandle: Integer readonly dispid 7;
    function ArrayOfVar(SourceArray: OleVariant): OleVariant; dispid 8;
    procedure AssignObject(const Source: iData); dispid 9;
    property Status: WideString readonly dispid 11;
    property Processing: WordBool readonly dispid 10;
    property PercentDone: Byte readonly dispid 12;
  end;

// *********************************************************************//
// Interface: IiGeoData
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6C942579-A98E-11D3-A52B-0000E85E2CDE}
// *********************************************************************//
  IiGeoData = interface(IiData)
    ['{6C942579-A98E-11D3-A52B-0000E85E2CDE}']
    function Get_Title: WideString; safecall;
    procedure Set_Title(const Value: WideString); safecall;
    function Get_Legend: iLegend; safecall;
    procedure Set_Legend(const Value: iLegend); safecall;
    function Get_hDC: Integer; safecall;
    function Get_MinX: Double; safecall;
    procedure Set_MinX(Value: Double); safecall;
    function Get_MaxX: Double; safecall;
    procedure Set_MaxX(Value: Double); safecall;
    function Get_MinY: Double; safecall;
    procedure Set_MinY(Value: Double); safecall;
    function Get_MaxY: Double; safecall;
    procedure Set_MaxY(Value: Double); safecall;
    function Get_Document: iFile; safecall;
    procedure Set_Document(const Value: iFile); safecall;
    procedure PasteGeoRefs(const PassVar: iGeoData); safecall;
    function Open: WordBool; safecall;
    procedure Save; safecall;
    function Terminate: WordBool; safecall;
    procedure SaveHeader; safecall;
    function OpenHeader: WordBool; safecall;
    function Get_Comment: iStringList; safecall;
    procedure Set_Comment(const Value: iStringList); safecall;
    function Get_Lineage: iStringList; safecall;
    procedure Set_Lineage(const Value: iStringList); safecall;
    function Get_Completeness: iStringList; safecall;
    procedure Set_Completeness(const Value: iStringList); safecall;
    function Get_Consistency: iStringList; safecall;
    procedure Set_Consistency(const Value: iStringList); safecall;
    function OpenWindow(X1: OleVariant; Y1: OleVariant; X2: OleVariant; Y2: OleVariant; 
                        Step: Smallint): WordBool; safecall;
    function Get_PartialScene: WordBool; safecall;
    function OpenSample(Step: Smallint): WordBool; safecall;
    procedure PasteHDC(BitmapHDC: Integer; Width: Integer; Height: Integer); safecall;
    procedure Refresh; safecall;
    procedure ClearBitmap; safecall;
    function StreamMapAs(StreamType: iStreamType): OleVariant; safecall;
    procedure PaintPoint(X: OleVariant; Y: OleVariant; Radius: OleVariant; const Color: WideString); safecall;
    procedure PaintLine(X1: OleVariant; Y1: OleVariant; X2: OleVariant; Y2: OleVariant; 
                        Width: OleVariant; const Color: WideString); safecall;
    procedure PaintPolygon(Points: OleVariant; LineWidth: Integer; const Color: WideString; 
                           BrushStyle: iBrushStyle; IsGeographic: WordBool); safecall;
    procedure PaintText(X: OleVariant; Y: OleVariant; const Text: WideString; 
                        const FontName: WideString; Size: Integer; const Style: WideString; 
                        const Color: WideString); safecall;
    function StreamAs(StreamType: iStreamType): OleVariant; safecall;
    procedure Draw(Left: Integer; Top: Integer; Zoom: Single; PictureHandle: Integer); safecall;
    procedure DrawMap(Zoom: Single; PictureHandle: Integer); safecall;
    procedure CopyMap(Zoom: Single); safecall;
    procedure Copy; safecall;
    function Get_ImageWidth: Integer; safecall;
    procedure Set_ImageWidth(Value: Integer); safecall;
    function Get_ImageHeight: Integer; safecall;
    procedure Set_ImageHeight(Value: Integer); safecall;
    procedure StretchDraw(hDC: Integer; X1: Double; Y1: Double; X2: Double; Y2: Double; 
                          Left: Integer; Top: Integer; Right: Integer; Bottom: Integer); safecall;
    function GetDataBuffer(out DataOut: OleVariant): Integer; safecall;
    procedure SetDataBuffer(DataIn: OleVariant); safecall;
    function RetrieveBitmap(Source: OleVariant; TimeOut_Sec: Integer; X1: Integer; Y1: Integer; 
                            X2: Integer; Y2: Integer; Transparency: Byte): Integer; safecall;
    function Get_PointXY(X: OleVariant; Y: OleVariant): OleVariant; safecall;
    procedure Set_PointXY(X: OleVariant; Y: OleVariant; Value: OleVariant); safecall;
    property Title: WideString read Get_Title write Set_Title;
    property Legend: iLegend read Get_Legend write Set_Legend;
    property hDC: Integer read Get_hDC;
    property MinX: Double read Get_MinX write Set_MinX;
    property MaxX: Double read Get_MaxX write Set_MaxX;
    property MinY: Double read Get_MinY write Set_MinY;
    property MaxY: Double read Get_MaxY write Set_MaxY;
    property Document: iFile read Get_Document write Set_Document;
    property Comment: iStringList read Get_Comment write Set_Comment;
    property Lineage: iStringList read Get_Lineage write Set_Lineage;
    property Completeness: iStringList read Get_Completeness write Set_Completeness;
    property Consistency: iStringList read Get_Consistency write Set_Consistency;
    property PartialScene: WordBool read Get_PartialScene;
    property ImageWidth: Integer read Get_ImageWidth write Set_ImageWidth;
    property ImageHeight: Integer read Get_ImageHeight write Set_ImageHeight;
    property PointXY[X: OleVariant; Y: OleVariant]: OleVariant read Get_PointXY write Set_PointXY;
  end;

// *********************************************************************//
// DispIntf:  IiGeoDataDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6C942579-A98E-11D3-A52B-0000E85E2CDE}
// *********************************************************************//
  IiGeoDataDisp = dispinterface
    ['{6C942579-A98E-11D3-A52B-0000E85E2CDE}']
    property Title: WideString dispid 47;
    property Legend: iLegend dispid 49;
    property hDC: Integer readonly dispid 50;
    property MinX: Double dispid 51;
    property MaxX: Double dispid 52;
    property MinY: Double dispid 53;
    property MaxY: Double dispid 54;
    property Document: iFile dispid 55;
    procedure PasteGeoRefs(const PassVar: iGeoData); dispid 56;
    function Open: WordBool; dispid 57;
    procedure Save; dispid 58;
    function Terminate: WordBool; dispid 60;
    procedure SaveHeader; dispid 61;
    function OpenHeader: WordBool; dispid 62;
    property Comment: iStringList dispid 66;
    property Lineage: iStringList dispid 67;
    property Completeness: iStringList dispid 68;
    property Consistency: iStringList dispid 69;
    function OpenWindow(X1: OleVariant; Y1: OleVariant; X2: OleVariant; Y2: OleVariant; 
                        Step: Smallint): WordBool; dispid 70;
    property PartialScene: WordBool readonly dispid 71;
    function OpenSample(Step: Smallint): WordBool; dispid 72;
    procedure PasteHDC(BitmapHDC: Integer; Width: Integer; Height: Integer); dispid 73;
    procedure Refresh; dispid 75;
    procedure ClearBitmap; dispid 76;
    function StreamMapAs(StreamType: iStreamType): OleVariant; dispid 80;
    procedure PaintPoint(X: OleVariant; Y: OleVariant; Radius: OleVariant; const Color: WideString); dispid 81;
    procedure PaintLine(X1: OleVariant; Y1: OleVariant; X2: OleVariant; Y2: OleVariant; 
                        Width: OleVariant; const Color: WideString); dispid 82;
    procedure PaintPolygon(Points: OleVariant; LineWidth: Integer; const Color: WideString; 
                           BrushStyle: iBrushStyle; IsGeographic: WordBool); dispid 83;
    procedure PaintText(X: OleVariant; Y: OleVariant; const Text: WideString; 
                        const FontName: WideString; Size: Integer; const Style: WideString; 
                        const Color: WideString); dispid 84;
    function StreamAs(StreamType: iStreamType): OleVariant; dispid 85;
    procedure Draw(Left: Integer; Top: Integer; Zoom: Single; PictureHandle: Integer); dispid 86;
    procedure DrawMap(Zoom: Single; PictureHandle: Integer); dispid 87;
    procedure CopyMap(Zoom: Single); dispid 88;
    procedure Copy; dispid 89;
    property ImageWidth: Integer dispid 90;
    property ImageHeight: Integer dispid 91;
    procedure StretchDraw(hDC: Integer; X1: Double; Y1: Double; X2: Double; Y2: Double; 
                          Left: Integer; Top: Integer; Right: Integer; Bottom: Integer); dispid 92;
    function GetDataBuffer(out DataOut: OleVariant): Integer; dispid 93;
    procedure SetDataBuffer(DataIn: OleVariant); dispid 94;
    function RetrieveBitmap(Source: OleVariant; TimeOut_Sec: Integer; X1: Integer; Y1: Integer; 
                            X2: Integer; Y2: Integer; Transparency: Byte): Integer; dispid 95;
    property PointXY[X: OleVariant; Y: OleVariant]: OleVariant dispid 15;
    property CheckStatus: Byte dispid 1;
    property Empty: WordBool dispid 2;
    property Changed: WordBool dispid 3;
    property Error: WideString readonly dispid 4;
    property ObjectName: WideString readonly dispid 5;
    property Process: IUnknown dispid 6;
    property DataHandle: Integer readonly dispid 7;
    function ArrayOfVar(SourceArray: OleVariant): OleVariant; dispid 8;
    procedure AssignObject(const Source: iData); dispid 9;
    property Status: WideString readonly dispid 11;
    property Processing: WordBool readonly dispid 10;
    property PercentDone: Byte readonly dispid 12;
  end;

// *********************************************************************//
// Interface: IiRaster
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {6C94257D-A98E-11D3-A52B-0000E85E2CDE}
// *********************************************************************//
  IiRaster = interface(IiGeoData)
    ['{6C94257D-A98E-11D3-A52B-0000E85E2CDE}']
    function Get_Cols: Integer; safecall;
    function Get_Rows: Integer; safecall;
    function Get_Res: Double; safecall;
    procedure Set_Res(Value: Double); safecall;
    function Get_MaxValue: Double; safecall;
    procedure Set_MaxValue(Value: Double); safecall;
    function Get_MinValue: Double; safecall;
    procedure Set_MinValue(Value: Double); safecall;
    function Get_DataType: iDataTypeConst; safecall;
    procedure Set_DataType(Value: iDataTypeConst); safecall;
    function Get_DiferentNumCount: Integer; safecall;
    function Column(X1: Single): Integer; safecall;
    function Row(Y1: Single): Integer; safecall;
    function CoordX(PassVar: Integer): Single; safecall;
    function CoordY(PassVar: Integer): Single; safecall;
    procedure GetMaxMin; safecall;
    procedure Insert(const PassVar: iRaster); safecall;
    procedure SetDataYX(Matrix: OleVariant; X1: Integer; Y1: Integer; X2: Integer; Y2: Integer); safecall;
    function GetDataYX(X1: Integer; Y1: Integer; X2: Integer; Y2: Integer): OleVariant; safecall;
    procedure New(const NewName: WideString; NewDataType: iDataTypeConst; NewCols: Integer; 
                  NewRows: Integer; InitVal: Single); safecall;
    function Get_ByteOrder: iByteOrder; safecall;
    function Get_ScanLineOrientation: iScanlineOrientType; safecall;
    procedure Set_ScanLineOrientation(Value: iScanlineOrientType); safecall;
    procedure SetData(Matrix: OleVariant; X1: Integer; Y1: Integer; X2: Integer; Y2: Integer); safecall;
    function GetData(X1: Integer; Y1: Integer; X2: Integer; Y2: Integer): OleVariant; safecall;
    function RetrieveURLData(const URLString: WideString; TimeOut_Sec: Integer; X1: Integer; 
                             Y1: Integer; X2: Integer; Y2: Integer): Integer; safecall;
    property Cols: Integer read Get_Cols;
    property Rows: Integer read Get_Rows;
    property Res: Double read Get_Res write Set_Res;
    property MaxValue: Double read Get_MaxValue write Set_MaxValue;
    property MinValue: Double read Get_MinValue write Set_MinValue;
    property DataType: iDataTypeConst read Get_DataType write Set_DataType;
    property DiferentNumCount: Integer read Get_DiferentNumCount;
    property ByteOrder: iByteOrder read Get_ByteOrder;
    property ScanLineOrientation: iScanlineOrientType read Get_ScanLineOrientation write Set_ScanLineOrientation;
  end;

// *********************************************************************//
// DispIntf:  IiRasterDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {6C94257D-A98E-11D3-A52B-0000E85E2CDE}
// *********************************************************************//
  IiRasterDisp = dispinterface
    ['{6C94257D-A98E-11D3-A52B-0000E85E2CDE}']
    property Cols: Integer readonly dispid 100;
    property Rows: Integer readonly dispid 101;
    property Res: Double dispid 102;
    property MaxValue: Double dispid 103;
    property MinValue: Double dispid 104;
    property DataType: iDataTypeConst dispid 106;
    property DiferentNumCount: Integer readonly dispid 107;
    function Column(X1: Single): Integer; dispid 108;
    function Row(Y1: Single): Integer; dispid 109;
    function CoordX(PassVar: Integer): Single; dispid 110;
    function CoordY(PassVar: Integer): Single; dispid 111;
    procedure GetMaxMin; dispid 112;
    procedure Insert(const PassVar: iRaster); dispid 113;
    procedure SetDataYX(Matrix: OleVariant; X1: Integer; Y1: Integer; X2: Integer; Y2: Integer); dispid 114;
    function GetDataYX(X1: Integer; Y1: Integer; X2: Integer; Y2: Integer): OleVariant; dispid 115;
    procedure New(const NewName: WideString; NewDataType: iDataTypeConst; NewCols: Integer; 
                  NewRows: Integer; InitVal: Single); dispid 116;
    property ByteOrder: iByteOrder readonly dispid 126;
    property ScanLineOrientation: iScanlineOrientType dispid 128;
    procedure SetData(Matrix: OleVariant; X1: Integer; Y1: Integer; X2: Integer; Y2: Integer); dispid 117;
    function GetData(X1: Integer; Y1: Integer; X2: Integer; Y2: Integer): OleVariant; dispid 118;
    function RetrieveURLData(const URLString: WideString; TimeOut_Sec: Integer; X1: Integer; 
                             Y1: Integer; X2: Integer; Y2: Integer): Integer; dispid 119;
    property Title: WideString dispid 47;
    property Legend: iLegend dispid 49;
    property hDC: Integer readonly dispid 50;
    property MinX: Double dispid 51;
    property MaxX: Double dispid 52;
    property MinY: Double dispid 53;
    property MaxY: Double dispid 54;
    property Document: iFile dispid 55;
    procedure PasteGeoRefs(const PassVar: iGeoData); dispid 56;
    function Open: WordBool; dispid 57;
    procedure Save; dispid 58;
    function Terminate: WordBool; dispid 60;
    procedure SaveHeader; dispid 61;
    function OpenHeader: WordBool; dispid 62;
    property Comment: iStringList dispid 66;
    property Lineage: iStringList dispid 67;
    property Completeness: iStringList dispid 68;
    property Consistency: iStringList dispid 69;
    function OpenWindow(X1: OleVariant; Y1: OleVariant; X2: OleVariant; Y2: OleVariant; 
                        Step: Smallint): WordBool; dispid 70;
    property PartialScene: WordBool readonly dispid 71;
    function OpenSample(Step: Smallint): WordBool; dispid 72;
    procedure PasteHDC(BitmapHDC: Integer; Width: Integer; Height: Integer); dispid 73;
    procedure Refresh; dispid 75;
    procedure ClearBitmap; dispid 76;
    function StreamMapAs(StreamType: iStreamType): OleVariant; dispid 80;
    procedure PaintPoint(X: OleVariant; Y: OleVariant; Radius: OleVariant; const Color: WideString); dispid 81;
    procedure PaintLine(X1: OleVariant; Y1: OleVariant; X2: OleVariant; Y2: OleVariant; 
                        Width: OleVariant; const Color: WideString); dispid 82;
    procedure PaintPolygon(Points: OleVariant; LineWidth: Integer; const Color: WideString; 
                           BrushStyle: iBrushStyle; IsGeographic: WordBool); dispid 83;
    procedure PaintText(X: OleVariant; Y: OleVariant; const Text: WideString; 
                        const FontName: WideString; Size: Integer; const Style: WideString; 
                        const Color: WideString); dispid 84;
    function StreamAs(StreamType: iStreamType): OleVariant; dispid 85;
    procedure Draw(Left: Integer; Top: Integer; Zoom: Single; PictureHandle: Integer); dispid 86;
    procedure DrawMap(Zoom: Single; PictureHandle: Integer); dispid 87;
    procedure CopyMap(Zoom: Single); dispid 88;
    procedure Copy; dispid 89;
    property ImageWidth: Integer dispid 90;
    property ImageHeight: Integer dispid 91;
    procedure StretchDraw(hDC: Integer; X1: Double; Y1: Double; X2: Double; Y2: Double; 
                          Left: Integer; Top: Integer; Right: Integer; Bottom: Integer); dispid 92;
    function GetDataBuffer(out DataOut: OleVariant): Integer; dispid 93;
    procedure SetDataBuffer(DataIn: OleVariant); dispid 94;
    function RetrieveBitmap(Source: OleVariant; TimeOut_Sec: Integer; X1: Integer; Y1: Integer; 
                            X2: Integer; Y2: Integer; Transparency: Byte): Integer; dispid 95;
    property PointXY[X: OleVariant; Y: OleVariant]: OleVariant dispid 15;
    property CheckStatus: Byte dispid 1;
    property Empty: WordBool dispid 2;
    property Changed: WordBool dispid 3;
    property Error: WideString readonly dispid 4;
    property ObjectName: WideString readonly dispid 5;
    property Process: IUnknown dispid 6;
    property DataHandle: Integer readonly dispid 7;
    function ArrayOfVar(SourceArray: OleVariant): OleVariant; dispid 8;
    procedure AssignObject(const Source: iData); dispid 9;
    property Status: WideString readonly dispid 11;
    property Processing: WordBool readonly dispid 10;
    property PercentDone: Byte readonly dispid 12;
  end;

// *********************************************************************//
// Interface: IiImg
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {6C942581-A98E-11D3-A52B-0000E85E2CDE}
// *********************************************************************//
  IiImg = interface(IiRaster)
    ['{6C942581-A98E-11D3-A52B-0000E85E2CDE}']
  end;

// *********************************************************************//
// DispIntf:  IiImgDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {6C942581-A98E-11D3-A52B-0000E85E2CDE}
// *********************************************************************//
  IiImgDisp = dispinterface
    ['{6C942581-A98E-11D3-A52B-0000E85E2CDE}']
    property Cols: Integer readonly dispid 100;
    property Rows: Integer readonly dispid 101;
    property Res: Double dispid 102;
    property MaxValue: Double dispid 103;
    property MinValue: Double dispid 104;
    property DataType: iDataTypeConst dispid 106;
    property DiferentNumCount: Integer readonly dispid 107;
    function Column(X1: Single): Integer; dispid 108;
    function Row(Y1: Single): Integer; dispid 109;
    function CoordX(PassVar: Integer): Single; dispid 110;
    function CoordY(PassVar: Integer): Single; dispid 111;
    procedure GetMaxMin; dispid 112;
    procedure Insert(const PassVar: iRaster); dispid 113;
    procedure SetDataYX(Matrix: OleVariant; X1: Integer; Y1: Integer; X2: Integer; Y2: Integer); dispid 114;
    function GetDataYX(X1: Integer; Y1: Integer; X2: Integer; Y2: Integer): OleVariant; dispid 115;
    procedure New(const NewName: WideString; NewDataType: iDataTypeConst; NewCols: Integer; 
                  NewRows: Integer; InitVal: Single); dispid 116;
    property ByteOrder: iByteOrder readonly dispid 126;
    property ScanLineOrientation: iScanlineOrientType dispid 128;
    procedure SetData(Matrix: OleVariant; X1: Integer; Y1: Integer; X2: Integer; Y2: Integer); dispid 117;
    function GetData(X1: Integer; Y1: Integer; X2: Integer; Y2: Integer): OleVariant; dispid 118;
    function RetrieveURLData(const URLString: WideString; TimeOut_Sec: Integer; X1: Integer; 
                             Y1: Integer; X2: Integer; Y2: Integer): Integer; dispid 119;
    property Title: WideString dispid 47;
    property Legend: iLegend dispid 49;
    property hDC: Integer readonly dispid 50;
    property MinX: Double dispid 51;
    property MaxX: Double dispid 52;
    property MinY: Double dispid 53;
    property MaxY: Double dispid 54;
    property Document: iFile dispid 55;
    procedure PasteGeoRefs(const PassVar: iGeoData); dispid 56;
    function Open: WordBool; dispid 57;
    procedure Save; dispid 58;
    function Terminate: WordBool; dispid 60;
    procedure SaveHeader; dispid 61;
    function OpenHeader: WordBool; dispid 62;
    property Comment: iStringList dispid 66;
    property Lineage: iStringList dispid 67;
    property Completeness: iStringList dispid 68;
    property Consistency: iStringList dispid 69;
    function OpenWindow(X1: OleVariant; Y1: OleVariant; X2: OleVariant; Y2: OleVariant; 
                        Step: Smallint): WordBool; dispid 70;
    property PartialScene: WordBool readonly dispid 71;
    function OpenSample(Step: Smallint): WordBool; dispid 72;
    procedure PasteHDC(BitmapHDC: Integer; Width: Integer; Height: Integer); dispid 73;
    procedure Refresh; dispid 75;
    procedure ClearBitmap; dispid 76;
    function StreamMapAs(StreamType: iStreamType): OleVariant; dispid 80;
    procedure PaintPoint(X: OleVariant; Y: OleVariant; Radius: OleVariant; const Color: WideString); dispid 81;
    procedure PaintLine(X1: OleVariant; Y1: OleVariant; X2: OleVariant; Y2: OleVariant; 
                        Width: OleVariant; const Color: WideString); dispid 82;
    procedure PaintPolygon(Points: OleVariant; LineWidth: Integer; const Color: WideString; 
                           BrushStyle: iBrushStyle; IsGeographic: WordBool); dispid 83;
    procedure PaintText(X: OleVariant; Y: OleVariant; const Text: WideString; 
                        const FontName: WideString; Size: Integer; const Style: WideString; 
                        const Color: WideString); dispid 84;
    function StreamAs(StreamType: iStreamType): OleVariant; dispid 85;
    procedure Draw(Left: Integer; Top: Integer; Zoom: Single; PictureHandle: Integer); dispid 86;
    procedure DrawMap(Zoom: Single; PictureHandle: Integer); dispid 87;
    procedure CopyMap(Zoom: Single); dispid 88;
    procedure Copy; dispid 89;
    property ImageWidth: Integer dispid 90;
    property ImageHeight: Integer dispid 91;
    procedure StretchDraw(hDC: Integer; X1: Double; Y1: Double; X2: Double; Y2: Double; 
                          Left: Integer; Top: Integer; Right: Integer; Bottom: Integer); dispid 92;
    function GetDataBuffer(out DataOut: OleVariant): Integer; dispid 93;
    procedure SetDataBuffer(DataIn: OleVariant); dispid 94;
    function RetrieveBitmap(Source: OleVariant; TimeOut_Sec: Integer; X1: Integer; Y1: Integer; 
                            X2: Integer; Y2: Integer; Transparency: Byte): Integer; dispid 95;
    property PointXY[X: OleVariant; Y: OleVariant]: OleVariant dispid 15;
    property CheckStatus: Byte dispid 1;
    property Empty: WordBool dispid 2;
    property Changed: WordBool dispid 3;
    property Error: WideString readonly dispid 4;
    property ObjectName: WideString readonly dispid 5;
    property Process: IUnknown dispid 6;
    property DataHandle: Integer readonly dispid 7;
    function ArrayOfVar(SourceArray: OleVariant): OleVariant; dispid 8;
    procedure AssignObject(const Source: iData); dispid 9;
    property Status: WideString readonly dispid 11;
    property Processing: WordBool readonly dispid 10;
    property PercentDone: Byte readonly dispid 12;
  end;

// *********************************************************************//
// Interface: IiStringList
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {6C942588-A98E-11D3-A52B-0000E85E2CDE}
// *********************************************************************//
  IiStringList = interface(IDispatch)
    ['{6C942588-A98E-11D3-A52B-0000E85E2CDE}']
    function Get_Name(Index: Integer): WideString; safecall;
    procedure Set_Name(Index: Integer; const Value: WideString); safecall;
    function Get_Capacity: Integer; safecall;
    function Get_Count: Integer; safecall;
    function Get_Sorted: WordBool; safecall;
    procedure Set_Sorted(Value: WordBool); safecall;
    function Add(const S: WideString): Integer; safecall;
    procedure Clear; safecall;
    procedure Delete(Index: Integer); safecall;
    procedure Exchange(Index1: Integer; Index2: Integer); safecall;
    function Find(const S: WideString; var Index: Integer): WordBool; safecall;
    function IndexOf(const S: WideString): Integer; safecall;
    procedure Insert(Index: Integer; const S: WideString); safecall;
    function Get_Process: IUnknown; safecall;
    procedure Set_Process(const Value: IUnknown); safecall;
    procedure AssignObject(const Source: iStringList); safecall;
    property Name[Index: Integer]: WideString read Get_Name write Set_Name;
    property Capacity: Integer read Get_Capacity;
    property Count: Integer read Get_Count;
    property Sorted: WordBool read Get_Sorted write Set_Sorted;
    property Process: IUnknown read Get_Process write Set_Process;
  end;

// *********************************************************************//
// DispIntf:  IiStringListDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {6C942588-A98E-11D3-A52B-0000E85E2CDE}
// *********************************************************************//
  IiStringListDisp = dispinterface
    ['{6C942588-A98E-11D3-A52B-0000E85E2CDE}']
    property Name[Index: Integer]: WideString dispid 1;
    property Capacity: Integer readonly dispid 2;
    property Count: Integer readonly dispid 3;
    property Sorted: WordBool dispid 4;
    function Add(const S: WideString): Integer; dispid 5;
    procedure Clear; dispid 6;
    procedure Delete(Index: Integer); dispid 7;
    procedure Exchange(Index1: Integer; Index2: Integer); dispid 8;
    function Find(const S: WideString; var Index: Integer): WordBool; dispid 9;
    function IndexOf(const S: WideString): Integer; dispid 10;
    procedure Insert(Index: Integer; const S: WideString); dispid 11;
    property Process: IUnknown dispid 12;
    procedure AssignObject(const Source: iStringList); dispid 13;
  end;

// *********************************************************************//
// Interface: IiScalar
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {6C942592-A98E-11D3-A52B-0000E85E2CDE}
// *********************************************************************//
  IiScalar = interface(IiData)
    ['{6C942592-A98E-11D3-A52B-0000E85E2CDE}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(const Value: WideString); safecall;
    function Get_Value: OleVariant; safecall;
    procedure Set_Value(Value: OleVariant); safecall;
    function Get_DataType: iDataTypeConst; safecall;
    procedure Set_DataType(Value: iDataTypeConst); safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Value: OleVariant read Get_Value write Set_Value;
    property DataType: iDataTypeConst read Get_DataType write Set_DataType;
  end;

// *********************************************************************//
// DispIntf:  IiScalarDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {6C942592-A98E-11D3-A52B-0000E85E2CDE}
// *********************************************************************//
  IiScalarDisp = dispinterface
    ['{6C942592-A98E-11D3-A52B-0000E85E2CDE}']
    property Name: WideString dispid 100;
    property Value: OleVariant dispid 101;
    property DataType: iDataTypeConst dispid 102;
    property CheckStatus: Byte dispid 1;
    property Empty: WordBool dispid 2;
    property Changed: WordBool dispid 3;
    property Error: WideString readonly dispid 4;
    property ObjectName: WideString readonly dispid 5;
    property Process: IUnknown dispid 6;
    property DataHandle: Integer readonly dispid 7;
    function ArrayOfVar(SourceArray: OleVariant): OleVariant; dispid 8;
    procedure AssignObject(const Source: iData); dispid 9;
    property Status: WideString readonly dispid 11;
    property Processing: WordBool readonly dispid 10;
    property PercentDone: Byte readonly dispid 12;
  end;

// *********************************************************************//
// Interface: IiVectorial
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6C942596-A98E-11D3-A52B-0000E85E2CDE}
// *********************************************************************//
  IiVectorial = interface(IiGeoData)
    ['{6C942596-A98E-11D3-A52B-0000E85E2CDE}']
    function Get_Count: Integer; safecall;
    function Get_Value(RecordNumber: Integer): OleVariant; safecall;
    procedure Set_Value(RecordNumber: Integer; Value: OleVariant); safecall;
    function Get_RecordPointCount(RecordNumber: Integer): Integer; safecall;
    procedure Set_RecordPointCount(RecordNumber: Integer; Value: Integer); safecall;
    procedure DrawObject(hDC: Integer; RecordNumber: Integer; X: Integer; Y: Integer; 
                         Color: OleVariant); safecall;
    procedure AddRecordPoints(ObjectData: OleVariant; Id: Single; RecordNumber: Integer); safecall;
    procedure New(const Name: WideString; ObjectsType: iShapeType; IdType: iDataTypeConst); safecall;
    function Get_FileType: iShapeType; safecall;
    function GetRecordBuffer(RecordNumber: Integer): OleVariant; safecall;
    function IndexOf(Value: OleVariant): OleVariant; safecall;
    function Get_IdType: iDataTypeConst; safecall;
    function Get_MaxSize: Integer; safecall;
    procedure Set_MaxSize(Value: Integer); safecall;
    function IsPointInPolygon(PolygonIndex: Integer; X: Single; Y: Single): WordBool; safecall;
    procedure Insert(ObjectData: OleVariant; Position: Integer; Id: Integer); safecall;
    procedure Exchange(Pos1: Integer; Pos2: Integer); safecall;
    procedure Delete(RecordNumber: Integer); safecall;
    function Get_Val: iVal; safecall;
    procedure Set_Val(const Value: iVal); safecall;
    function Get_RecordColor(RecordNumber: Integer): Integer; safecall;
    function Get_Paint: iPaint; safecall;
    procedure Set_Paint(const Value: iPaint); safecall;
    function Get_DrawLabels: WordBool; safecall;
    procedure Set_DrawLabels(Value: WordBool); safecall;
    function Get_RecordBox(RecordNumber: Integer; Position: Integer): OleVariant; safecall;
    procedure DrawSquare(hDC: Integer; X1: Double; Y1: Double; X2: Double; Y2: Double; X: Integer; 
                         Y: Integer; Color: Integer; Width: Integer); safecall;
    function Get_DisabledRecord(RecordNumber: Integer): WordBool; safecall;
    procedure Set_DisabledRecord(RecordNumber: Integer; Value: WordBool); safecall;
    function GetRecordPoints(RecordNumber: Integer): OleVariant; safecall;
    function Get_Color(RecordNumber: Integer): WideString; safecall;
    procedure Set_Color(RecordNumber: Integer; const Value: WideString); safecall;
    function Get_Selected(RecordNumber: Integer): WordBool; safecall;
    procedure Set_Selected(RecordNumber: Integer; Value: WordBool); safecall;
    procedure Set_SelectAll(Param1: WordBool); safecall;
    function SelectString(const QueryString: WideString; AddToSelection: WordBool): WordBool; safecall;
    procedure SetRecordPoints(RecordNumber: Integer; Value: OleVariant); safecall;
    function GetDisabledRecords: OleVariant; safecall;
    procedure SetDisabledRecords(Value: OleVariant); safecall;
    function GetSelectedRecords: OleVariant; safecall;
    procedure SetSelectedRecords(Value: OleVariant); safecall;
    procedure AddRecordBuffer(ObjectData: OleVariant; Id: Single; Position: Integer); safecall;
    procedure DrawRecord(hDC: Integer; ObjectNumber: Integer; X: Integer; Y: Integer; 
                         Width: Integer; Height: Integer; const Color: WideString); safecall;
    function Get_LabelColor(RecordNumber: Integer): WideString; safecall;
    procedure Set_LabelColor(RecordNumber: Integer; const Value: WideString); safecall;
    function Get_LabelStyle(RecordNumber: Integer): WideString; safecall;
    procedure Set_LabelStyle(RecordNumber: Integer; const Value: WideString); safecall;
    function Get_LabelSize(RecordNumber: Integer): Smallint; safecall;
    procedure Set_LabelSize(RecordNumber: Integer; Value: Smallint); safecall;
    function Get_LabelFontName(RecordNumber: Integer): WideString; safecall;
    procedure Set_LabelFontName(RecordNumber: Integer; const Value: WideString); safecall;
    procedure SetLabelProperties(const FontName: WideString; const FontStyle: WideString; 
                                 const FontColor: WideString; FontSize: Integer); safecall;
    function Get_PenColor(RecordNumber: Integer): WideString; safecall;
    procedure Set_PenColor(RecordNumber: Integer; const Value: WideString); safecall;
    function Get_Parts(RecordNumber: Integer; PartNumber: Integer): Integer; safecall;
    procedure Set_Parts(RecordNumber: Integer; PartNumber: Integer; Value: Integer); safecall;
    property Count: Integer read Get_Count;
    property Value[RecordNumber: Integer]: OleVariant read Get_Value write Set_Value;
    property RecordPointCount[RecordNumber: Integer]: Integer read Get_RecordPointCount write Set_RecordPointCount;
    property FileType: iShapeType read Get_FileType;
    property IdType: iDataTypeConst read Get_IdType;
    property MaxSize: Integer read Get_MaxSize write Set_MaxSize;
    property Val: iVal read Get_Val write Set_Val;
    property RecordColor[RecordNumber: Integer]: Integer read Get_RecordColor;
    property Paint: iPaint read Get_Paint write Set_Paint;
    property DrawLabels: WordBool read Get_DrawLabels write Set_DrawLabels;
    property RecordBox[RecordNumber: Integer; Position: Integer]: OleVariant read Get_RecordBox;
    property DisabledRecord[RecordNumber: Integer]: WordBool read Get_DisabledRecord write Set_DisabledRecord;
    property Color[RecordNumber: Integer]: WideString read Get_Color write Set_Color;
    property Selected[RecordNumber: Integer]: WordBool read Get_Selected write Set_Selected;
    property SelectAll: WordBool write Set_SelectAll;
    property LabelColor[RecordNumber: Integer]: WideString read Get_LabelColor write Set_LabelColor;
    property LabelStyle[RecordNumber: Integer]: WideString read Get_LabelStyle write Set_LabelStyle;
    property LabelSize[RecordNumber: Integer]: Smallint read Get_LabelSize write Set_LabelSize;
    property LabelFontName[RecordNumber: Integer]: WideString read Get_LabelFontName write Set_LabelFontName;
    property PenColor[RecordNumber: Integer]: WideString read Get_PenColor write Set_PenColor;
    property Parts[RecordNumber: Integer; PartNumber: Integer]: Integer read Get_Parts write Set_Parts;
  end;

// *********************************************************************//
// DispIntf:  IiVectorialDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6C942596-A98E-11D3-A52B-0000E85E2CDE}
// *********************************************************************//
  IiVectorialDisp = dispinterface
    ['{6C942596-A98E-11D3-A52B-0000E85E2CDE}']
    property Count: Integer readonly dispid 100;
    property Value[RecordNumber: Integer]: OleVariant dispid 103;
    property RecordPointCount[RecordNumber: Integer]: Integer dispid 104;
    procedure DrawObject(hDC: Integer; RecordNumber: Integer; X: Integer; Y: Integer; 
                         Color: OleVariant); dispid 105;
    procedure AddRecordPoints(ObjectData: OleVariant; Id: Single; RecordNumber: Integer); dispid 107;
    procedure New(const Name: WideString; ObjectsType: iShapeType; IdType: iDataTypeConst); dispid 109;
    property FileType: iShapeType readonly dispid 110;
    function GetRecordBuffer(RecordNumber: Integer): OleVariant; dispid 112;
    function IndexOf(Value: OleVariant): OleVariant; dispid 114;
    property IdType: iDataTypeConst readonly dispid 115;
    property MaxSize: Integer dispid 119;
    function IsPointInPolygon(PolygonIndex: Integer; X: Single; Y: Single): WordBool; dispid 120;
    procedure Insert(ObjectData: OleVariant; Position: Integer; Id: Integer); dispid 122;
    procedure Exchange(Pos1: Integer; Pos2: Integer); dispid 123;
    procedure Delete(RecordNumber: Integer); dispid 124;
    property Val: iVal dispid 125;
    property RecordColor[RecordNumber: Integer]: Integer readonly dispid 126;
    property Paint: iPaint dispid 127;
    property DrawLabels: WordBool dispid 128;
    property RecordBox[RecordNumber: Integer; Position: Integer]: OleVariant readonly dispid 129;
    procedure DrawSquare(hDC: Integer; X1: Double; Y1: Double; X2: Double; Y2: Double; X: Integer; 
                         Y: Integer; Color: Integer; Width: Integer); dispid 131;
    property DisabledRecord[RecordNumber: Integer]: WordBool dispid 133;
    function GetRecordPoints(RecordNumber: Integer): OleVariant; dispid 134;
    property Color[RecordNumber: Integer]: WideString dispid 136;
    property Selected[RecordNumber: Integer]: WordBool dispid 137;
    property SelectAll: WordBool writeonly dispid 138;
    function SelectString(const QueryString: WideString; AddToSelection: WordBool): WordBool; dispid 139;
    procedure SetRecordPoints(RecordNumber: Integer; Value: OleVariant); dispid 140;
    function GetDisabledRecords: OleVariant; dispid 141;
    procedure SetDisabledRecords(Value: OleVariant); dispid 142;
    function GetSelectedRecords: OleVariant; dispid 143;
    procedure SetSelectedRecords(Value: OleVariant); dispid 144;
    procedure AddRecordBuffer(ObjectData: OleVariant; Id: Single; Position: Integer); dispid 145;
    procedure DrawRecord(hDC: Integer; ObjectNumber: Integer; X: Integer; Y: Integer; 
                         Width: Integer; Height: Integer; const Color: WideString); dispid 146;
    property LabelColor[RecordNumber: Integer]: WideString dispid 147;
    property LabelStyle[RecordNumber: Integer]: WideString dispid 148;
    property LabelSize[RecordNumber: Integer]: Smallint dispid 150;
    property LabelFontName[RecordNumber: Integer]: WideString dispid 151;
    procedure SetLabelProperties(const FontName: WideString; const FontStyle: WideString; 
                                 const FontColor: WideString; FontSize: Integer); dispid 152;
    property PenColor[RecordNumber: Integer]: WideString dispid 153;
    property Parts[RecordNumber: Integer; PartNumber: Integer]: Integer dispid 154;
    property Title: WideString dispid 47;
    property Legend: iLegend dispid 49;
    property hDC: Integer readonly dispid 50;
    property MinX: Double dispid 51;
    property MaxX: Double dispid 52;
    property MinY: Double dispid 53;
    property MaxY: Double dispid 54;
    property Document: iFile dispid 55;
    procedure PasteGeoRefs(const PassVar: iGeoData); dispid 56;
    function Open: WordBool; dispid 57;
    procedure Save; dispid 58;
    function Terminate: WordBool; dispid 60;
    procedure SaveHeader; dispid 61;
    function OpenHeader: WordBool; dispid 62;
    property Comment: iStringList dispid 66;
    property Lineage: iStringList dispid 67;
    property Completeness: iStringList dispid 68;
    property Consistency: iStringList dispid 69;
    function OpenWindow(X1: OleVariant; Y1: OleVariant; X2: OleVariant; Y2: OleVariant; 
                        Step: Smallint): WordBool; dispid 70;
    property PartialScene: WordBool readonly dispid 71;
    function OpenSample(Step: Smallint): WordBool; dispid 72;
    procedure PasteHDC(BitmapHDC: Integer; Width: Integer; Height: Integer); dispid 73;
    procedure Refresh; dispid 75;
    procedure ClearBitmap; dispid 76;
    function StreamMapAs(StreamType: iStreamType): OleVariant; dispid 80;
    procedure PaintPoint(X: OleVariant; Y: OleVariant; Radius: OleVariant; const Color: WideString); dispid 81;
    procedure PaintLine(X1: OleVariant; Y1: OleVariant; X2: OleVariant; Y2: OleVariant; 
                        Width: OleVariant; const Color: WideString); dispid 82;
    procedure PaintPolygon(Points: OleVariant; LineWidth: Integer; const Color: WideString; 
                           BrushStyle: iBrushStyle; IsGeographic: WordBool); dispid 83;
    procedure PaintText(X: OleVariant; Y: OleVariant; const Text: WideString; 
                        const FontName: WideString; Size: Integer; const Style: WideString; 
                        const Color: WideString); dispid 84;
    function StreamAs(StreamType: iStreamType): OleVariant; dispid 85;
    procedure Draw(Left: Integer; Top: Integer; Zoom: Single; PictureHandle: Integer); dispid 86;
    procedure DrawMap(Zoom: Single; PictureHandle: Integer); dispid 87;
    procedure CopyMap(Zoom: Single); dispid 88;
    procedure Copy; dispid 89;
    property ImageWidth: Integer dispid 90;
    property ImageHeight: Integer dispid 91;
    procedure StretchDraw(hDC: Integer; X1: Double; Y1: Double; X2: Double; Y2: Double; 
                          Left: Integer; Top: Integer; Right: Integer; Bottom: Integer); dispid 92;
    function GetDataBuffer(out DataOut: OleVariant): Integer; dispid 93;
    procedure SetDataBuffer(DataIn: OleVariant); dispid 94;
    function RetrieveBitmap(Source: OleVariant; TimeOut_Sec: Integer; X1: Integer; Y1: Integer; 
                            X2: Integer; Y2: Integer; Transparency: Byte): Integer; dispid 95;
    property PointXY[X: OleVariant; Y: OleVariant]: OleVariant dispid 15;
    property CheckStatus: Byte dispid 1;
    property Empty: WordBool dispid 2;
    property Changed: WordBool dispid 3;
    property Error: WideString readonly dispid 4;
    property ObjectName: WideString readonly dispid 5;
    property Process: IUnknown dispid 6;
    property DataHandle: Integer readonly dispid 7;
    function ArrayOfVar(SourceArray: OleVariant): OleVariant; dispid 8;
    procedure AssignObject(const Source: iData); dispid 9;
    property Status: WideString readonly dispid 11;
    property Processing: WordBool readonly dispid 10;
    property PercentDone: Byte readonly dispid 12;
  end;

// *********************************************************************//
// Interface: IiVec
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6C94259A-A98E-11D3-A52B-0000E85E2CDE}
// *********************************************************************//
  IiVec = interface(IiVectorial)
    ['{6C94259A-A98E-11D3-A52B-0000E85E2CDE}']
  end;

// *********************************************************************//
// DispIntf:  IiVecDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6C94259A-A98E-11D3-A52B-0000E85E2CDE}
// *********************************************************************//
  IiVecDisp = dispinterface
    ['{6C94259A-A98E-11D3-A52B-0000E85E2CDE}']
    property Count: Integer readonly dispid 100;
    property Value[RecordNumber: Integer]: OleVariant dispid 103;
    property RecordPointCount[RecordNumber: Integer]: Integer dispid 104;
    procedure DrawObject(hDC: Integer; RecordNumber: Integer; X: Integer; Y: Integer; 
                         Color: OleVariant); dispid 105;
    procedure AddRecordPoints(ObjectData: OleVariant; Id: Single; RecordNumber: Integer); dispid 107;
    procedure New(const Name: WideString; ObjectsType: iShapeType; IdType: iDataTypeConst); dispid 109;
    property FileType: iShapeType readonly dispid 110;
    function GetRecordBuffer(RecordNumber: Integer): OleVariant; dispid 112;
    function IndexOf(Value: OleVariant): OleVariant; dispid 114;
    property IdType: iDataTypeConst readonly dispid 115;
    property MaxSize: Integer dispid 119;
    function IsPointInPolygon(PolygonIndex: Integer; X: Single; Y: Single): WordBool; dispid 120;
    procedure Insert(ObjectData: OleVariant; Position: Integer; Id: Integer); dispid 122;
    procedure Exchange(Pos1: Integer; Pos2: Integer); dispid 123;
    procedure Delete(RecordNumber: Integer); dispid 124;
    property Val: iVal dispid 125;
    property RecordColor[RecordNumber: Integer]: Integer readonly dispid 126;
    property Paint: iPaint dispid 127;
    property DrawLabels: WordBool dispid 128;
    property RecordBox[RecordNumber: Integer; Position: Integer]: OleVariant readonly dispid 129;
    procedure DrawSquare(hDC: Integer; X1: Double; Y1: Double; X2: Double; Y2: Double; X: Integer; 
                         Y: Integer; Color: Integer; Width: Integer); dispid 131;
    property DisabledRecord[RecordNumber: Integer]: WordBool dispid 133;
    function GetRecordPoints(RecordNumber: Integer): OleVariant; dispid 134;
    property Color[RecordNumber: Integer]: WideString dispid 136;
    property Selected[RecordNumber: Integer]: WordBool dispid 137;
    property SelectAll: WordBool writeonly dispid 138;
    function SelectString(const QueryString: WideString; AddToSelection: WordBool): WordBool; dispid 139;
    procedure SetRecordPoints(RecordNumber: Integer; Value: OleVariant); dispid 140;
    function GetDisabledRecords: OleVariant; dispid 141;
    procedure SetDisabledRecords(Value: OleVariant); dispid 142;
    function GetSelectedRecords: OleVariant; dispid 143;
    procedure SetSelectedRecords(Value: OleVariant); dispid 144;
    procedure AddRecordBuffer(ObjectData: OleVariant; Id: Single; Position: Integer); dispid 145;
    procedure DrawRecord(hDC: Integer; ObjectNumber: Integer; X: Integer; Y: Integer; 
                         Width: Integer; Height: Integer; const Color: WideString); dispid 146;
    property LabelColor[RecordNumber: Integer]: WideString dispid 147;
    property LabelStyle[RecordNumber: Integer]: WideString dispid 148;
    property LabelSize[RecordNumber: Integer]: Smallint dispid 150;
    property LabelFontName[RecordNumber: Integer]: WideString dispid 151;
    procedure SetLabelProperties(const FontName: WideString; const FontStyle: WideString; 
                                 const FontColor: WideString; FontSize: Integer); dispid 152;
    property PenColor[RecordNumber: Integer]: WideString dispid 153;
    property Parts[RecordNumber: Integer; PartNumber: Integer]: Integer dispid 154;
    property Title: WideString dispid 47;
    property Legend: iLegend dispid 49;
    property hDC: Integer readonly dispid 50;
    property MinX: Double dispid 51;
    property MaxX: Double dispid 52;
    property MinY: Double dispid 53;
    property MaxY: Double dispid 54;
    property Document: iFile dispid 55;
    procedure PasteGeoRefs(const PassVar: iGeoData); dispid 56;
    function Open: WordBool; dispid 57;
    procedure Save; dispid 58;
    function Terminate: WordBool; dispid 60;
    procedure SaveHeader; dispid 61;
    function OpenHeader: WordBool; dispid 62;
    property Comment: iStringList dispid 66;
    property Lineage: iStringList dispid 67;
    property Completeness: iStringList dispid 68;
    property Consistency: iStringList dispid 69;
    function OpenWindow(X1: OleVariant; Y1: OleVariant; X2: OleVariant; Y2: OleVariant; 
                        Step: Smallint): WordBool; dispid 70;
    property PartialScene: WordBool readonly dispid 71;
    function OpenSample(Step: Smallint): WordBool; dispid 72;
    procedure PasteHDC(BitmapHDC: Integer; Width: Integer; Height: Integer); dispid 73;
    procedure Refresh; dispid 75;
    procedure ClearBitmap; dispid 76;
    function StreamMapAs(StreamType: iStreamType): OleVariant; dispid 80;
    procedure PaintPoint(X: OleVariant; Y: OleVariant; Radius: OleVariant; const Color: WideString); dispid 81;
    procedure PaintLine(X1: OleVariant; Y1: OleVariant; X2: OleVariant; Y2: OleVariant; 
                        Width: OleVariant; const Color: WideString); dispid 82;
    procedure PaintPolygon(Points: OleVariant; LineWidth: Integer; const Color: WideString; 
                           BrushStyle: iBrushStyle; IsGeographic: WordBool); dispid 83;
    procedure PaintText(X: OleVariant; Y: OleVariant; const Text: WideString; 
                        const FontName: WideString; Size: Integer; const Style: WideString; 
                        const Color: WideString); dispid 84;
    function StreamAs(StreamType: iStreamType): OleVariant; dispid 85;
    procedure Draw(Left: Integer; Top: Integer; Zoom: Single; PictureHandle: Integer); dispid 86;
    procedure DrawMap(Zoom: Single; PictureHandle: Integer); dispid 87;
    procedure CopyMap(Zoom: Single); dispid 88;
    procedure Copy; dispid 89;
    property ImageWidth: Integer dispid 90;
    property ImageHeight: Integer dispid 91;
    procedure StretchDraw(hDC: Integer; X1: Double; Y1: Double; X2: Double; Y2: Double; 
                          Left: Integer; Top: Integer; Right: Integer; Bottom: Integer); dispid 92;
    function GetDataBuffer(out DataOut: OleVariant): Integer; dispid 93;
    procedure SetDataBuffer(DataIn: OleVariant); dispid 94;
    function RetrieveBitmap(Source: OleVariant; TimeOut_Sec: Integer; X1: Integer; Y1: Integer; 
                            X2: Integer; Y2: Integer; Transparency: Byte): Integer; dispid 95;
    property PointXY[X: OleVariant; Y: OleVariant]: OleVariant dispid 15;
    property CheckStatus: Byte dispid 1;
    property Empty: WordBool dispid 2;
    property Changed: WordBool dispid 3;
    property Error: WideString readonly dispid 4;
    property ObjectName: WideString readonly dispid 5;
    property Process: IUnknown dispid 6;
    property DataHandle: Integer readonly dispid 7;
    function ArrayOfVar(SourceArray: OleVariant): OleVariant; dispid 8;
    procedure AssignObject(const Source: iData); dispid 9;
    property Status: WideString readonly dispid 11;
    property Processing: WordBool readonly dispid 10;
    property PercentDone: Byte readonly dispid 12;
  end;

// *********************************************************************//
// Interface: IiDiscreteLeg
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6C9425A2-A98E-11D3-A52B-0000E85E2CDE}
// *********************************************************************//
  IiDiscreteLeg = interface(IiLegend)
    ['{6C9425A2-A98E-11D3-A52B-0000E85E2CDE}']
  end;

// *********************************************************************//
// DispIntf:  IiDiscreteLegDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6C9425A2-A98E-11D3-A52B-0000E85E2CDE}
// *********************************************************************//
  IiDiscreteLegDisp = dispinterface
    ['{6C9425A2-A98E-11D3-A52B-0000E85E2CDE}']
    property Width: Integer dispid 1;
    property Height: Integer dispid 2;
    property hDC: Integer readonly dispid 3;
    property Palette: iPal dispid 4;
    property Count: Integer readonly dispid 6;
    property Font: iFont dispid 7;
    property Horizontal: WordBool dispid 8;
    property BackColor: Integer dispid 9;
    property BorderColor: Integer dispid 10;
    property TextPosition: iTextPosition dispid 11;
    property DistSclTxt: Integer dispid 12;
    property MaxTextHeight: Integer readonly dispid 13;
    property MaxTextWidth: Integer readonly dispid 14;
    property MaxValue: Double dispid 15;
    property MinValue: Double dispid 16;
    property Decimal: Integer dispid 17;
    procedure Draw(Left: Integer; Top: Integer; PictureHandle: Integer); dispid 18;
    procedure Copy; dispid 19;
    procedure SetAutoSize; dispid 20;
    procedure SaveAsJPEG; dispid 21;
    procedure Add(const ClassName: WideString); dispid 22;
    procedure Clear; dispid 23;
    property iType: LegType readonly dispid 24;
    property FlagVal: Single dispid 25;
    property FlagDef: WideString dispid 26;
    property RefSys: WideString dispid 27;
    property UnitDist: Double dispid 28;
    property RefUnits: WideString dispid 29;
    property ValUnits: WideString dispid 30;
    function StreamAs(StreamType: iStreamType): OleVariant; dispid 31;
    property Process: IUnknown dispid 32;
    procedure Refresh; dispid 33;
    procedure AssignObject(const Source: iLegend); dispid 34;
    property _className[X: Integer]: WideString dispid 36;
    property Disabled[LegendNumber: Integer]: WordBool dispid 5;
  end;

// *********************************************************************//
// Interface: IiContLeg
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6C9425A6-A98E-11D3-A52B-0000E85E2CDE}
// *********************************************************************//
  IiContLeg = interface(IiLegend)
    ['{6C9425A6-A98E-11D3-A52B-0000E85E2CDE}']
  end;

// *********************************************************************//
// DispIntf:  IiContLegDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6C9425A6-A98E-11D3-A52B-0000E85E2CDE}
// *********************************************************************//
  IiContLegDisp = dispinterface
    ['{6C9425A6-A98E-11D3-A52B-0000E85E2CDE}']
    property Width: Integer dispid 1;
    property Height: Integer dispid 2;
    property hDC: Integer readonly dispid 3;
    property Palette: iPal dispid 4;
    property Count: Integer readonly dispid 6;
    property Font: iFont dispid 7;
    property Horizontal: WordBool dispid 8;
    property BackColor: Integer dispid 9;
    property BorderColor: Integer dispid 10;
    property TextPosition: iTextPosition dispid 11;
    property DistSclTxt: Integer dispid 12;
    property MaxTextHeight: Integer readonly dispid 13;
    property MaxTextWidth: Integer readonly dispid 14;
    property MaxValue: Double dispid 15;
    property MinValue: Double dispid 16;
    property Decimal: Integer dispid 17;
    procedure Draw(Left: Integer; Top: Integer; PictureHandle: Integer); dispid 18;
    procedure Copy; dispid 19;
    procedure SetAutoSize; dispid 20;
    procedure SaveAsJPEG; dispid 21;
    procedure Add(const ClassName: WideString); dispid 22;
    procedure Clear; dispid 23;
    property iType: LegType readonly dispid 24;
    property FlagVal: Single dispid 25;
    property FlagDef: WideString dispid 26;
    property RefSys: WideString dispid 27;
    property UnitDist: Double dispid 28;
    property RefUnits: WideString dispid 29;
    property ValUnits: WideString dispid 30;
    function StreamAs(StreamType: iStreamType): OleVariant; dispid 31;
    property Process: IUnknown dispid 32;
    procedure Refresh; dispid 33;
    procedure AssignObject(const Source: iLegend); dispid 34;
    property _className[X: Integer]: WideString dispid 36;
    property Disabled[LegendNumber: Integer]: WordBool dispid 5;
  end;

// *********************************************************************//
// Interface: IiVal
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6C9425AB-A98E-11D3-A52B-0000E85E2CDE}
// *********************************************************************//
  IiVal = interface(IiData)
    ['{6C9425AB-A98E-11D3-A52B-0000E85E2CDE}']
    function Get_RecordCount: Integer; safecall;
    function Get_FeatureType(FeatureIndex: OleVariant): iFeatureType; safecall;
    procedure Set_FeatureType(FeatureIndex: OleVariant; Value: iFeatureType); safecall;
    function Get_FeatureCount: Integer; safecall;
    function Get_FeatureData(FieldNumber: OleVariant): OleVariant; safecall;
    procedure Set_FeatureData(FieldNumber: OleVariant; Value: OleVariant); safecall;
    function Open(ReadOnly: WordBool): WordBool; safecall;
    procedure Save; safecall;
    function Get_Document: iFile; safecall;
    procedure Set_Document(const Value: iFile); safecall;
    function OpenHeader: WordBool; safecall;
    procedure SaveHeader; safecall;
    procedure AddFeature(DataFeature: OleVariant; FeatureType: iFeatureType; const Name: WideString); safecall;
    procedure Clear; safecall;
    function Get_Legend(FeatureIndex: OleVariant): iLegend; safecall;
    procedure Set_Legend(FeatureIndex: OleVariant; const Value: iLegend); safecall;
    function Get_ActiveFeature: Integer; safecall;
    procedure Set_ActiveFeature(Value: Integer); safecall;
    function Get_IDData: OleVariant; safecall;
    procedure Set_IDData(Value: OleVariant); safecall;
    function Get_FeatureName(Index_: Integer): WideString; safecall;
    function IsFeatureDifValuesMoreThan(FeatureIndex: Integer; Value: Integer): WordBool; safecall;
    function Get_RecordData(RecordIndex: Integer; FeatureIndex: OleVariant): OleVariant; safecall;
    procedure Set_RecordData(RecordIndex: Integer; FeatureIndex: OleVariant; Value: OleVariant); safecall;
    procedure AddRecord(RecordPosition: Integer); safecall;
    procedure Delete(RecordNumber: Integer); safecall;
    property RecordCount: Integer read Get_RecordCount;
    property FeatureType[FeatureIndex: OleVariant]: iFeatureType read Get_FeatureType write Set_FeatureType;
    property FeatureCount: Integer read Get_FeatureCount;
    property FeatureData[FieldNumber: OleVariant]: OleVariant read Get_FeatureData write Set_FeatureData;
    property Document: iFile read Get_Document write Set_Document;
    property Legend[FeatureIndex: OleVariant]: iLegend read Get_Legend write Set_Legend;
    property ActiveFeature: Integer read Get_ActiveFeature write Set_ActiveFeature;
    property IDData: OleVariant read Get_IDData write Set_IDData;
    property FeatureName[Index_: Integer]: WideString read Get_FeatureName;
    property RecordData[RecordIndex: Integer; FeatureIndex: OleVariant]: OleVariant read Get_RecordData write Set_RecordData;
  end;

// *********************************************************************//
// DispIntf:  IiValDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6C9425AB-A98E-11D3-A52B-0000E85E2CDE}
// *********************************************************************//
  IiValDisp = dispinterface
    ['{6C9425AB-A98E-11D3-A52B-0000E85E2CDE}']
    property RecordCount: Integer readonly dispid 100;
    property FeatureType[FeatureIndex: OleVariant]: iFeatureType dispid 101;
    property FeatureCount: Integer readonly dispid 102;
    property FeatureData[FieldNumber: OleVariant]: OleVariant dispid 103;
    function Open(ReadOnly: WordBool): WordBool; dispid 104;
    procedure Save; dispid 105;
    property Document: iFile dispid 106;
    function OpenHeader: WordBool; dispid 107;
    procedure SaveHeader; dispid 108;
    procedure AddFeature(DataFeature: OleVariant; FeatureType: iFeatureType; const Name: WideString); dispid 109;
    procedure Clear; dispid 110;
    property Legend[FeatureIndex: OleVariant]: iLegend dispid 111;
    property ActiveFeature: Integer dispid 112;
    property IDData: OleVariant dispid 113;
    property FeatureName[Index_: Integer]: WideString readonly dispid 116;
    function IsFeatureDifValuesMoreThan(FeatureIndex: Integer; Value: Integer): WordBool; dispid 117;
    property RecordData[RecordIndex: Integer; FeatureIndex: OleVariant]: OleVariant dispid 118;
    procedure AddRecord(RecordPosition: Integer); dispid 119;
    procedure Delete(RecordNumber: Integer); dispid 13;
    property CheckStatus: Byte dispid 1;
    property Empty: WordBool dispid 2;
    property Changed: WordBool dispid 3;
    property Error: WideString readonly dispid 4;
    property ObjectName: WideString readonly dispid 5;
    property Process: IUnknown dispid 6;
    property DataHandle: Integer readonly dispid 7;
    function ArrayOfVar(SourceArray: OleVariant): OleVariant; dispid 8;
    procedure AssignObject(const Source: iData); dispid 9;
    property Status: WideString readonly dispid 11;
    property Processing: WordBool readonly dispid 10;
    property PercentDone: Byte readonly dispid 12;
  end;

// *********************************************************************//
// Interface: IiShp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A42E61F1-A993-11D3-A52C-0000E85E2CDE}
// *********************************************************************//
  IiShp = interface(IiVectorial)
    ['{A42E61F1-A993-11D3-A52C-0000E85E2CDE}']
    function Get_ZMin: Double; safecall;
    function Get_ZMax: Double; safecall;
    function Get_Mmin: Double; safecall;
    function Get_Mmax: Double; safecall;
    function Get_Version: Integer; safecall;
    function Get_FileCode: Integer; safecall;
    property ZMin: Double read Get_ZMin;
    property ZMax: Double read Get_ZMax;
    property Mmin: Double read Get_Mmin;
    property Mmax: Double read Get_Mmax;
    property Version: Integer read Get_Version;
    property FileCode: Integer read Get_FileCode;
  end;

// *********************************************************************//
// DispIntf:  IiShpDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A42E61F1-A993-11D3-A52C-0000E85E2CDE}
// *********************************************************************//
  IiShpDisp = dispinterface
    ['{A42E61F1-A993-11D3-A52C-0000E85E2CDE}']
    property ZMin: Double readonly dispid 200;
    property ZMax: Double readonly dispid 201;
    property Mmin: Double readonly dispid 202;
    property Mmax: Double readonly dispid 203;
    property Version: Integer readonly dispid 204;
    property FileCode: Integer readonly dispid 205;
    property Count: Integer readonly dispid 100;
    property Value[RecordNumber: Integer]: OleVariant dispid 103;
    property RecordPointCount[RecordNumber: Integer]: Integer dispid 104;
    procedure DrawObject(hDC: Integer; RecordNumber: Integer; X: Integer; Y: Integer; 
                         Color: OleVariant); dispid 105;
    procedure AddRecordPoints(ObjectData: OleVariant; Id: Single; RecordNumber: Integer); dispid 107;
    procedure New(const Name: WideString; ObjectsType: iShapeType; IdType: iDataTypeConst); dispid 109;
    property FileType: iShapeType readonly dispid 110;
    function GetRecordBuffer(RecordNumber: Integer): OleVariant; dispid 112;
    function IndexOf(Value: OleVariant): OleVariant; dispid 114;
    property IdType: iDataTypeConst readonly dispid 115;
    property MaxSize: Integer dispid 119;
    function IsPointInPolygon(PolygonIndex: Integer; X: Single; Y: Single): WordBool; dispid 120;
    procedure Insert(ObjectData: OleVariant; Position: Integer; Id: Integer); dispid 122;
    procedure Exchange(Pos1: Integer; Pos2: Integer); dispid 123;
    procedure Delete(RecordNumber: Integer); dispid 124;
    property Val: iVal dispid 125;
    property RecordColor[RecordNumber: Integer]: Integer readonly dispid 126;
    property Paint: iPaint dispid 127;
    property DrawLabels: WordBool dispid 128;
    property RecordBox[RecordNumber: Integer; Position: Integer]: OleVariant readonly dispid 129;
    procedure DrawSquare(hDC: Integer; X1: Double; Y1: Double; X2: Double; Y2: Double; X: Integer; 
                         Y: Integer; Color: Integer; Width: Integer); dispid 131;
    property DisabledRecord[RecordNumber: Integer]: WordBool dispid 133;
    function GetRecordPoints(RecordNumber: Integer): OleVariant; dispid 134;
    property Color[RecordNumber: Integer]: WideString dispid 136;
    property Selected[RecordNumber: Integer]: WordBool dispid 137;
    property SelectAll: WordBool writeonly dispid 138;
    function SelectString(const QueryString: WideString; AddToSelection: WordBool): WordBool; dispid 139;
    procedure SetRecordPoints(RecordNumber: Integer; Value: OleVariant); dispid 140;
    function GetDisabledRecords: OleVariant; dispid 141;
    procedure SetDisabledRecords(Value: OleVariant); dispid 142;
    function GetSelectedRecords: OleVariant; dispid 143;
    procedure SetSelectedRecords(Value: OleVariant); dispid 144;
    procedure AddRecordBuffer(ObjectData: OleVariant; Id: Single; Position: Integer); dispid 145;
    procedure DrawRecord(hDC: Integer; ObjectNumber: Integer; X: Integer; Y: Integer; 
                         Width: Integer; Height: Integer; const Color: WideString); dispid 146;
    property LabelColor[RecordNumber: Integer]: WideString dispid 147;
    property LabelStyle[RecordNumber: Integer]: WideString dispid 148;
    property LabelSize[RecordNumber: Integer]: Smallint dispid 150;
    property LabelFontName[RecordNumber: Integer]: WideString dispid 151;
    procedure SetLabelProperties(const FontName: WideString; const FontStyle: WideString; 
                                 const FontColor: WideString; FontSize: Integer); dispid 152;
    property PenColor[RecordNumber: Integer]: WideString dispid 153;
    property Parts[RecordNumber: Integer; PartNumber: Integer]: Integer dispid 154;
    property Title: WideString dispid 47;
    property Legend: iLegend dispid 49;
    property hDC: Integer readonly dispid 50;
    property MinX: Double dispid 51;
    property MaxX: Double dispid 52;
    property MinY: Double dispid 53;
    property MaxY: Double dispid 54;
    property Document: iFile dispid 55;
    procedure PasteGeoRefs(const PassVar: iGeoData); dispid 56;
    function Open: WordBool; dispid 57;
    procedure Save; dispid 58;
    function Terminate: WordBool; dispid 60;
    procedure SaveHeader; dispid 61;
    function OpenHeader: WordBool; dispid 62;
    property Comment: iStringList dispid 66;
    property Lineage: iStringList dispid 67;
    property Completeness: iStringList dispid 68;
    property Consistency: iStringList dispid 69;
    function OpenWindow(X1: OleVariant; Y1: OleVariant; X2: OleVariant; Y2: OleVariant; 
                        Step: Smallint): WordBool; dispid 70;
    property PartialScene: WordBool readonly dispid 71;
    function OpenSample(Step: Smallint): WordBool; dispid 72;
    procedure PasteHDC(BitmapHDC: Integer; Width: Integer; Height: Integer); dispid 73;
    procedure Refresh; dispid 75;
    procedure ClearBitmap; dispid 76;
    function StreamMapAs(StreamType: iStreamType): OleVariant; dispid 80;
    procedure PaintPoint(X: OleVariant; Y: OleVariant; Radius: OleVariant; const Color: WideString); dispid 81;
    procedure PaintLine(X1: OleVariant; Y1: OleVariant; X2: OleVariant; Y2: OleVariant; 
                        Width: OleVariant; const Color: WideString); dispid 82;
    procedure PaintPolygon(Points: OleVariant; LineWidth: Integer; const Color: WideString; 
                           BrushStyle: iBrushStyle; IsGeographic: WordBool); dispid 83;
    procedure PaintText(X: OleVariant; Y: OleVariant; const Text: WideString; 
                        const FontName: WideString; Size: Integer; const Style: WideString; 
                        const Color: WideString); dispid 84;
    function StreamAs(StreamType: iStreamType): OleVariant; dispid 85;
    procedure Draw(Left: Integer; Top: Integer; Zoom: Single; PictureHandle: Integer); dispid 86;
    procedure DrawMap(Zoom: Single; PictureHandle: Integer); dispid 87;
    procedure CopyMap(Zoom: Single); dispid 88;
    procedure Copy; dispid 89;
    property ImageWidth: Integer dispid 90;
    property ImageHeight: Integer dispid 91;
    procedure StretchDraw(hDC: Integer; X1: Double; Y1: Double; X2: Double; Y2: Double; 
                          Left: Integer; Top: Integer; Right: Integer; Bottom: Integer); dispid 92;
    function GetDataBuffer(out DataOut: OleVariant): Integer; dispid 93;
    procedure SetDataBuffer(DataIn: OleVariant); dispid 94;
    function RetrieveBitmap(Source: OleVariant; TimeOut_Sec: Integer; X1: Integer; Y1: Integer; 
                            X2: Integer; Y2: Integer; Transparency: Byte): Integer; dispid 95;
    property PointXY[X: OleVariant; Y: OleVariant]: OleVariant dispid 15;
    property CheckStatus: Byte dispid 1;
    property Empty: WordBool dispid 2;
    property Changed: WordBool dispid 3;
    property Error: WideString readonly dispid 4;
    property ObjectName: WideString readonly dispid 5;
    property Process: IUnknown dispid 6;
    property DataHandle: Integer readonly dispid 7;
    function ArrayOfVar(SourceArray: OleVariant): OleVariant; dispid 8;
    procedure AssignObject(const Source: iData); dispid 9;
    property Status: WideString readonly dispid 11;
    property Processing: WordBool readonly dispid 10;
    property PercentDone: Byte readonly dispid 12;
  end;

// *********************************************************************//
// Interface: IIiDRISIVal
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F1DD7E31-BC5F-11D3-A532-0000E85E2CDE}
// *********************************************************************//
  IIiDRISIVal = interface(IiVal)
    ['{F1DD7E31-BC5F-11D3-A532-0000E85E2CDE}']
    function Get_Lineage: iStringList; safecall;
    procedure Set_Lineage(const Value: iStringList); safecall;
    function Get_Comment: iStringList; safecall;
    procedure Set_Comment(const Value: iStringList); safecall;
    function Get_Completeness: iStringList; safecall;
    procedure Set_Completeness(const Value: iStringList); safecall;
    function Get_Consistency: iStringList; safecall;
    procedure Set_Consistency(const Value: iStringList); safecall;
    property Lineage: iStringList read Get_Lineage write Set_Lineage;
    property Comment: iStringList read Get_Comment write Set_Comment;
    property Completeness: iStringList read Get_Completeness write Set_Completeness;
    property Consistency: iStringList read Get_Consistency write Set_Consistency;
  end;

// *********************************************************************//
// DispIntf:  IIiDRISIValDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F1DD7E31-BC5F-11D3-A532-0000E85E2CDE}
// *********************************************************************//
  IIiDRISIValDisp = dispinterface
    ['{F1DD7E31-BC5F-11D3-A532-0000E85E2CDE}']
    property Lineage: iStringList dispid 200;
    property Comment: iStringList dispid 201;
    property Completeness: iStringList dispid 202;
    property Consistency: iStringList dispid 203;
    property RecordCount: Integer readonly dispid 100;
    property FeatureType[FeatureIndex: OleVariant]: iFeatureType dispid 101;
    property FeatureCount: Integer readonly dispid 102;
    property FeatureData[FieldNumber: OleVariant]: OleVariant dispid 103;
    function Open(ReadOnly: WordBool): WordBool; dispid 104;
    procedure Save; dispid 105;
    property Document: iFile dispid 106;
    function OpenHeader: WordBool; dispid 107;
    procedure SaveHeader; dispid 108;
    procedure AddFeature(DataFeature: OleVariant; FeatureType: iFeatureType; const Name: WideString); dispid 109;
    procedure Clear; dispid 110;
    property Legend[FeatureIndex: OleVariant]: iLegend dispid 111;
    property ActiveFeature: Integer dispid 112;
    property IDData: OleVariant dispid 113;
    property FeatureName[Index_: Integer]: WideString readonly dispid 116;
    function IsFeatureDifValuesMoreThan(FeatureIndex: Integer; Value: Integer): WordBool; dispid 117;
    property RecordData[RecordIndex: Integer; FeatureIndex: OleVariant]: OleVariant dispid 118;
    procedure AddRecord(RecordPosition: Integer); dispid 119;
    procedure Delete(RecordNumber: Integer); dispid 13;
    property CheckStatus: Byte dispid 1;
    property Empty: WordBool dispid 2;
    property Changed: WordBool dispid 3;
    property Error: WideString readonly dispid 4;
    property ObjectName: WideString readonly dispid 5;
    property Process: IUnknown dispid 6;
    property DataHandle: Integer readonly dispid 7;
    function ArrayOfVar(SourceArray: OleVariant): OleVariant; dispid 8;
    procedure AssignObject(const Source: iData); dispid 9;
    property Status: WideString readonly dispid 11;
    property Processing: WordBool readonly dispid 10;
    property PercentDone: Byte readonly dispid 12;
  end;

// *********************************************************************//
// Interface: IiDbf
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F1DD7E35-BC5F-11D3-A532-0000E85E2CDE}
// *********************************************************************//
  IiDbf = interface(IiVal)
    ['{F1DD7E35-BC5F-11D3-A532-0000E85E2CDE}']
    procedure Set_RecordsToBeOpened(Param1: OleVariant); safecall;
    property RecordsToBeOpened: OleVariant write Set_RecordsToBeOpened;
  end;

// *********************************************************************//
// DispIntf:  IiDbfDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F1DD7E35-BC5F-11D3-A532-0000E85E2CDE}
// *********************************************************************//
  IiDbfDisp = dispinterface
    ['{F1DD7E35-BC5F-11D3-A532-0000E85E2CDE}']
    property RecordsToBeOpened: OleVariant writeonly dispid 200;
    property RecordCount: Integer readonly dispid 100;
    property FeatureType[FeatureIndex: OleVariant]: iFeatureType dispid 101;
    property FeatureCount: Integer readonly dispid 102;
    property FeatureData[FieldNumber: OleVariant]: OleVariant dispid 103;
    function Open(ReadOnly: WordBool): WordBool; dispid 104;
    procedure Save; dispid 105;
    property Document: iFile dispid 106;
    function OpenHeader: WordBool; dispid 107;
    procedure SaveHeader; dispid 108;
    procedure AddFeature(DataFeature: OleVariant; FeatureType: iFeatureType; const Name: WideString); dispid 109;
    procedure Clear; dispid 110;
    property Legend[FeatureIndex: OleVariant]: iLegend dispid 111;
    property ActiveFeature: Integer dispid 112;
    property IDData: OleVariant dispid 113;
    property FeatureName[Index_: Integer]: WideString readonly dispid 116;
    function IsFeatureDifValuesMoreThan(FeatureIndex: Integer; Value: Integer): WordBool; dispid 117;
    property RecordData[RecordIndex: Integer; FeatureIndex: OleVariant]: OleVariant dispid 118;
    procedure AddRecord(RecordPosition: Integer); dispid 119;
    procedure Delete(RecordNumber: Integer); dispid 13;
    property CheckStatus: Byte dispid 1;
    property Empty: WordBool dispid 2;
    property Changed: WordBool dispid 3;
    property Error: WideString readonly dispid 4;
    property ObjectName: WideString readonly dispid 5;
    property Process: IUnknown dispid 6;
    property DataHandle: Integer readonly dispid 7;
    function ArrayOfVar(SourceArray: OleVariant): OleVariant; dispid 8;
    procedure AssignObject(const Source: iData); dispid 9;
    property Status: WideString readonly dispid 11;
    property Processing: WordBool readonly dispid 10;
    property PercentDone: Byte readonly dispid 12;
  end;

// *********************************************************************//
// Interface: IiPaint
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5BA340A0-C918-11D3-BE9A-8CFFB6DC2143}
// *********************************************************************//
  IiPaint = interface(IDispatch)
    ['{5BA340A0-C918-11D3-BE9A-8CFFB6DC2143}']
    function Get_BrushStyle: iBrushStyle; safecall;
    procedure Set_BrushStyle(Value: iBrushStyle); safecall;
    function Get_LogBrush: OleVariant; safecall;
    procedure Set_LogBrush(Value: OleVariant); safecall;
    function Get_PenStyle: iPenStyle; safecall;
    procedure Set_PenStyle(Value: iPenStyle); safecall;
    function Get_LogPen: OleVariant; safecall;
    procedure Set_LogPen(Value: OleVariant); safecall;
    function Get_PenWidth: Integer; safecall;
    procedure Set_PenWidth(Value: Integer); safecall;
    function Get_Changed: WordBool; safecall;
    procedure Set_Changed(Value: WordBool); safecall;
    function Get_PenColor: WideString; safecall;
    procedure Set_PenColor(const Value: WideString); safecall;
    property BrushStyle: iBrushStyle read Get_BrushStyle write Set_BrushStyle;
    property LogBrush: OleVariant read Get_LogBrush write Set_LogBrush;
    property PenStyle: iPenStyle read Get_PenStyle write Set_PenStyle;
    property LogPen: OleVariant read Get_LogPen write Set_LogPen;
    property PenWidth: Integer read Get_PenWidth write Set_PenWidth;
    property Changed: WordBool read Get_Changed write Set_Changed;
    property PenColor: WideString read Get_PenColor write Set_PenColor;
  end;

// *********************************************************************//
// DispIntf:  IiPaintDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5BA340A0-C918-11D3-BE9A-8CFFB6DC2143}
// *********************************************************************//
  IiPaintDisp = dispinterface
    ['{5BA340A0-C918-11D3-BE9A-8CFFB6DC2143}']
    property BrushStyle: iBrushStyle dispid 1;
    property LogBrush: OleVariant dispid 2;
    property PenStyle: iPenStyle dispid 4;
    property LogPen: OleVariant dispid 5;
    property PenWidth: Integer dispid 6;
    property Changed: WordBool dispid 7;
    property PenColor: WideString dispid 8;
  end;

// *********************************************************************//
// Interface: IiRst
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A7CFB2DC-7CD3-11D4-A88D-00A0C9EC10A4}
// *********************************************************************//
  IiRst = interface(IiRaster)
    ['{A7CFB2DC-7CD3-11D4-A88D-00A0C9EC10A4}']
    function Get_FileFormat: WideString; safecall;
    property FileFormat: WideString read Get_FileFormat;
  end;

// *********************************************************************//
// DispIntf:  IiRstDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A7CFB2DC-7CD3-11D4-A88D-00A0C9EC10A4}
// *********************************************************************//
  IiRstDisp = dispinterface
    ['{A7CFB2DC-7CD3-11D4-A88D-00A0C9EC10A4}']
    property FileFormat: WideString readonly dispid 200;
    property Cols: Integer readonly dispid 100;
    property Rows: Integer readonly dispid 101;
    property Res: Double dispid 102;
    property MaxValue: Double dispid 103;
    property MinValue: Double dispid 104;
    property DataType: iDataTypeConst dispid 106;
    property DiferentNumCount: Integer readonly dispid 107;
    function Column(X1: Single): Integer; dispid 108;
    function Row(Y1: Single): Integer; dispid 109;
    function CoordX(PassVar: Integer): Single; dispid 110;
    function CoordY(PassVar: Integer): Single; dispid 111;
    procedure GetMaxMin; dispid 112;
    procedure Insert(const PassVar: iRaster); dispid 113;
    procedure SetDataYX(Matrix: OleVariant; X1: Integer; Y1: Integer; X2: Integer; Y2: Integer); dispid 114;
    function GetDataYX(X1: Integer; Y1: Integer; X2: Integer; Y2: Integer): OleVariant; dispid 115;
    procedure New(const NewName: WideString; NewDataType: iDataTypeConst; NewCols: Integer; 
                  NewRows: Integer; InitVal: Single); dispid 116;
    property ByteOrder: iByteOrder readonly dispid 126;
    property ScanLineOrientation: iScanlineOrientType dispid 128;
    procedure SetData(Matrix: OleVariant; X1: Integer; Y1: Integer; X2: Integer; Y2: Integer); dispid 117;
    function GetData(X1: Integer; Y1: Integer; X2: Integer; Y2: Integer): OleVariant; dispid 118;
    function RetrieveURLData(const URLString: WideString; TimeOut_Sec: Integer; X1: Integer; 
                             Y1: Integer; X2: Integer; Y2: Integer): Integer; dispid 119;
    property Title: WideString dispid 47;
    property Legend: iLegend dispid 49;
    property hDC: Integer readonly dispid 50;
    property MinX: Double dispid 51;
    property MaxX: Double dispid 52;
    property MinY: Double dispid 53;
    property MaxY: Double dispid 54;
    property Document: iFile dispid 55;
    procedure PasteGeoRefs(const PassVar: iGeoData); dispid 56;
    function Open: WordBool; dispid 57;
    procedure Save; dispid 58;
    function Terminate: WordBool; dispid 60;
    procedure SaveHeader; dispid 61;
    function OpenHeader: WordBool; dispid 62;
    property Comment: iStringList dispid 66;
    property Lineage: iStringList dispid 67;
    property Completeness: iStringList dispid 68;
    property Consistency: iStringList dispid 69;
    function OpenWindow(X1: OleVariant; Y1: OleVariant; X2: OleVariant; Y2: OleVariant; 
                        Step: Smallint): WordBool; dispid 70;
    property PartialScene: WordBool readonly dispid 71;
    function OpenSample(Step: Smallint): WordBool; dispid 72;
    procedure PasteHDC(BitmapHDC: Integer; Width: Integer; Height: Integer); dispid 73;
    procedure Refresh; dispid 75;
    procedure ClearBitmap; dispid 76;
    function StreamMapAs(StreamType: iStreamType): OleVariant; dispid 80;
    procedure PaintPoint(X: OleVariant; Y: OleVariant; Radius: OleVariant; const Color: WideString); dispid 81;
    procedure PaintLine(X1: OleVariant; Y1: OleVariant; X2: OleVariant; Y2: OleVariant; 
                        Width: OleVariant; const Color: WideString); dispid 82;
    procedure PaintPolygon(Points: OleVariant; LineWidth: Integer; const Color: WideString; 
                           BrushStyle: iBrushStyle; IsGeographic: WordBool); dispid 83;
    procedure PaintText(X: OleVariant; Y: OleVariant; const Text: WideString; 
                        const FontName: WideString; Size: Integer; const Style: WideString; 
                        const Color: WideString); dispid 84;
    function StreamAs(StreamType: iStreamType): OleVariant; dispid 85;
    procedure Draw(Left: Integer; Top: Integer; Zoom: Single; PictureHandle: Integer); dispid 86;
    procedure DrawMap(Zoom: Single; PictureHandle: Integer); dispid 87;
    procedure CopyMap(Zoom: Single); dispid 88;
    procedure Copy; dispid 89;
    property ImageWidth: Integer dispid 90;
    property ImageHeight: Integer dispid 91;
    procedure StretchDraw(hDC: Integer; X1: Double; Y1: Double; X2: Double; Y2: Double; 
                          Left: Integer; Top: Integer; Right: Integer; Bottom: Integer); dispid 92;
    function GetDataBuffer(out DataOut: OleVariant): Integer; dispid 93;
    procedure SetDataBuffer(DataIn: OleVariant); dispid 94;
    function RetrieveBitmap(Source: OleVariant; TimeOut_Sec: Integer; X1: Integer; Y1: Integer; 
                            X2: Integer; Y2: Integer; Transparency: Byte): Integer; dispid 95;
    property PointXY[X: OleVariant; Y: OleVariant]: OleVariant dispid 15;
    property CheckStatus: Byte dispid 1;
    property Empty: WordBool dispid 2;
    property Changed: WordBool dispid 3;
    property Error: WideString readonly dispid 4;
    property ObjectName: WideString readonly dispid 5;
    property Process: IUnknown dispid 6;
    property DataHandle: Integer readonly dispid 7;
    function ArrayOfVar(SourceArray: OleVariant): OleVariant; dispid 8;
    procedure AssignObject(const Source: iData); dispid 9;
    property Status: WideString readonly dispid 11;
    property Processing: WordBool readonly dispid 10;
    property PercentDone: Byte readonly dispid 12;
  end;

// *********************************************************************//
// The Class CoiFile provides a Create and CreateRemote method to          
// create instances of the default interface IiFile exposed by              
// the CoClass iFile. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoiFile = class
    class function Create: IiFile;
    class function CreateRemote(const MachineName: string): IiFile;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TiFile
// Help String      : iFileObject
// Default Interface: IiFile
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TiFileProperties= class;
{$ENDIF}
  TiFile = class(TOleServer)
  private
    FIntf:        IiFile;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TiFileProperties;
    function      GetServerProperties: TiFileProperties;
{$ENDIF}
    function      GetDefaultInterface: IiFile;
  protected
    procedure InitServerData; override;
    function Get_Name: WideString;
    procedure Set_Name(const Value: WideString);
    function Get_Directory: WideString;
    procedure Set_Directory(const Value: WideString);
    function Get_FileType: iFileTypeConst;
    procedure Set_FileType(Value: iFileTypeConst);
    function Get_Empty: WordBool;
    procedure Set_Empty(Value: WordBool);
    function Get_Extension: WideString;
    procedure Set_Extension(const Value: WideString);
    function Get_HeaderExtension: WideString;
    procedure Set_HeaderExtension(const Value: WideString);
    function Get_Process: IUnknown;
    procedure Set_Process(const Value: IUnknown);
    function Get_IndexFileExtension: WideString;
    procedure Set_IndexFileExtension(const Value: WideString);
    function Get_ReadOnly: WordBool;
    procedure Set_ReadOnly(Value: WordBool);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IiFile);
    procedure Disconnect; override;
    function GetFileName: WideString;
    function FileOpen: WordBool;
    function FileClose: WordBool;
    function GetHeader(out DocText: OleVariant): Smallint;
    function SetHeader(DocText: OleVariant): WordBool;
    function GetFileSize: Integer;
    function FileSeek(Position: Integer): WordBool;
    function FileBlockRead(out Buf: OleVariant; Count: Integer): Integer;
    function FileBlockWrite(Buf: OleVariant): Integer;
    procedure FileRead;
    procedure FileWrite;
    procedure FileNew;
    function CheckFileExists: WordBool;
    function FileBlockReadWithStep(out Buf: OleVariant; Count: Integer; Step: Integer; 
                                   DataType: iDataTypeConst): Integer;
    procedure GetIndexFileExtension(out FileBuffer: OleVariant);
    procedure SetIndexFileExtension(FileBuffer: OleVariant);
    procedure AssignObject(const Source: iFile);
    function CreateDirFileList: iStringList;
    property DefaultInterface: IiFile read GetDefaultInterface;
    property Empty: WordBool read Get_Empty write Set_Empty;
    property Process: IUnknown read Get_Process write Set_Process;
    property IndexFileExtension: WideString read Get_IndexFileExtension write Set_IndexFileExtension;
    property Name: WideString read Get_Name write Set_Name;
    property Directory: WideString read Get_Directory write Set_Directory;
    property FileType: iFileTypeConst read Get_FileType write Set_FileType;
    property Extension: WideString read Get_Extension write Set_Extension;
    property HeaderExtension: WideString read Get_HeaderExtension write Set_HeaderExtension;
    property ReadOnly: WordBool read Get_ReadOnly write Set_ReadOnly;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TiFileProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TiFile
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TiFileProperties = class(TPersistent)
  private
    FServer:    TiFile;
    function    GetDefaultInterface: IiFile;
    constructor Create(AServer: TiFile);
  protected
    function Get_Name: WideString;
    procedure Set_Name(const Value: WideString);
    function Get_Directory: WideString;
    procedure Set_Directory(const Value: WideString);
    function Get_FileType: iFileTypeConst;
    procedure Set_FileType(Value: iFileTypeConst);
    function Get_Empty: WordBool;
    procedure Set_Empty(Value: WordBool);
    function Get_Extension: WideString;
    procedure Set_Extension(const Value: WideString);
    function Get_HeaderExtension: WideString;
    procedure Set_HeaderExtension(const Value: WideString);
    function Get_Process: IUnknown;
    procedure Set_Process(const Value: IUnknown);
    function Get_IndexFileExtension: WideString;
    procedure Set_IndexFileExtension(const Value: WideString);
    function Get_ReadOnly: WordBool;
    procedure Set_ReadOnly(Value: WordBool);
  public
    property DefaultInterface: IiFile read GetDefaultInterface;
  published
    property Name: WideString read Get_Name write Set_Name;
    property Directory: WideString read Get_Directory write Set_Directory;
    property FileType: iFileTypeConst read Get_FileType write Set_FileType;
    property Extension: WideString read Get_Extension write Set_Extension;
    property HeaderExtension: WideString read Get_HeaderExtension write Set_HeaderExtension;
    property ReadOnly: WordBool read Get_ReadOnly write Set_ReadOnly;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoiPal provides a Create and CreateRemote method to          
// create instances of the default interface IiPal exposed by              
// the CoClass iPal. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoiPal = class
    class function Create: IiPal;
    class function CreateRemote(const MachineName: string): IiPal;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TiPal
// Help String      : iPalObject
// Default Interface: IiPal
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TiPalProperties= class;
{$ENDIF}
  TiPal = class(TOleServer)
  private
    FIntf:        IiPal;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TiPalProperties;
    function      GetServerProperties: TiPalProperties;
{$ENDIF}
    function      GetDefaultInterface: IiPal;
  protected
    procedure InitServerData; override;
    function Get_Name: iPalettes;
    procedure Set_Name(Value: iPalettes);
    function Get_NumColors: Integer;
    function Get_Color(X: Integer): iColor;
    procedure Set_Color(X: Integer; const Value: iColor);
    function Get_Document: iFile;
    procedure Set_Document(const Value: iFile);
    function Get_Changed: WordBool;
    procedure Set_Changed(Value: WordBool);
    function Get_ColorBuffer: OleVariant;
    procedure Set_ColorBuffer(Value: OleVariant);
    function Get_Process: IUnknown;
    procedure Set_Process(const Value: IUnknown);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IiPal);
    procedure Disconnect; override;
    procedure AddColor(Red: Byte; Green: Byte; Blue: Byte);
    procedure RemoveColor(ColorNumber: Integer);
    function Open: WordBool;
    procedure AssignObject(const Source: iPal);
    procedure Invert;
    property DefaultInterface: IiPal read GetDefaultInterface;
    property NumColors: Integer read Get_NumColors;
    property Color[X: Integer]: iColor read Get_Color write Set_Color;
    property ColorBuffer: OleVariant read Get_ColorBuffer write Set_ColorBuffer;
    property Process: IUnknown read Get_Process write Set_Process;
    property Name: iPalettes read Get_Name write Set_Name;
    property Document: iFile read Get_Document write Set_Document;
    property Changed: WordBool read Get_Changed write Set_Changed;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TiPalProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TiPal
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TiPalProperties = class(TPersistent)
  private
    FServer:    TiPal;
    function    GetDefaultInterface: IiPal;
    constructor Create(AServer: TiPal);
  protected
    function Get_Name: iPalettes;
    procedure Set_Name(Value: iPalettes);
    function Get_NumColors: Integer;
    function Get_Color(X: Integer): iColor;
    procedure Set_Color(X: Integer; const Value: iColor);
    function Get_Document: iFile;
    procedure Set_Document(const Value: iFile);
    function Get_Changed: WordBool;
    procedure Set_Changed(Value: WordBool);
    function Get_ColorBuffer: OleVariant;
    procedure Set_ColorBuffer(Value: OleVariant);
    function Get_Process: IUnknown;
    procedure Set_Process(const Value: IUnknown);
  public
    property DefaultInterface: IiPal read GetDefaultInterface;
  published
    property Name: iPalettes read Get_Name write Set_Name;
    property Document: iFile read Get_Document write Set_Document;
    property Changed: WordBool read Get_Changed write Set_Changed;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoiColor provides a Create and CreateRemote method to          
// create instances of the default interface IiColor exposed by              
// the CoClass iColor. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoiColor = class
    class function Create: IiColor;
    class function CreateRemote(const MachineName: string): IiColor;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TiColor
// Help String      : iColorObject
// Default Interface: IiColor
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TiColorProperties= class;
{$ENDIF}
  TiColor = class(TOleServer)
  private
    FIntf:        IiColor;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TiColorProperties;
    function      GetServerProperties: TiColorProperties;
{$ENDIF}
    function      GetDefaultInterface: IiColor;
  protected
    procedure InitServerData; override;
    function Get_Red: Byte;
    procedure Set_Red(Red: Byte);
    function Get_Green: Byte;
    procedure Set_Green(Green: Byte);
    function Get_Blue: Byte;
    procedure Set_Blue(Blue: Byte);
    function Get_Process: IUnknown;
    procedure Set_Process(const Value: IUnknown);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IiColor);
    procedure Disconnect; override;
    property DefaultInterface: IiColor read GetDefaultInterface;
    property Process: IUnknown read Get_Process write Set_Process;
    property Red: Byte read Get_Red write Set_Red;
    property Green: Byte read Get_Green write Set_Green;
    property Blue: Byte read Get_Blue write Set_Blue;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TiColorProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TiColor
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TiColorProperties = class(TPersistent)
  private
    FServer:    TiColor;
    function    GetDefaultInterface: IiColor;
    constructor Create(AServer: TiColor);
  protected
    function Get_Red: Byte;
    procedure Set_Red(Red: Byte);
    function Get_Green: Byte;
    procedure Set_Green(Green: Byte);
    function Get_Blue: Byte;
    procedure Set_Blue(Blue: Byte);
    function Get_Process: IUnknown;
    procedure Set_Process(const Value: IUnknown);
  public
    property DefaultInterface: IiColor read GetDefaultInterface;
  published
    property Red: Byte read Get_Red write Set_Red;
    property Green: Byte read Get_Green write Set_Green;
    property Blue: Byte read Get_Blue write Set_Blue;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoiFont provides a Create and CreateRemote method to          
// create instances of the default interface IiFont exposed by              
// the CoClass iFont. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoiFont = class
    class function Create: IiFont;
    class function CreateRemote(const MachineName: string): IiFont;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TiFont
// Help String      : iFontObject
// Default Interface: IiFont
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TiFontProperties= class;
{$ENDIF}
  TiFont = class(TOleServer)
  private
    FIntf:        IiFont;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TiFontProperties;
    function      GetServerProperties: TiFontProperties;
{$ENDIF}
    function      GetDefaultInterface: IiFont;
  protected
    procedure InitServerData; override;
    function Get_Name: WideString;
    procedure Set_Name(const Name: WideString);
    function Get_Size: Integer;
    procedure Set_Size(Size: Integer);
    function Get_Process: IUnknown;
    procedure Set_Process(const Value: IUnknown);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IiFont);
    procedure Disconnect; override;
    procedure AssignObject(const Source: iFont);
    property DefaultInterface: IiFont read GetDefaultInterface;
    property Process: IUnknown read Get_Process write Set_Process;
    property Name: WideString read Get_Name write Set_Name;
    property Size: Integer read Get_Size write Set_Size;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TiFontProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TiFont
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TiFontProperties = class(TPersistent)
  private
    FServer:    TiFont;
    function    GetDefaultInterface: IiFont;
    constructor Create(AServer: TiFont);
  protected
    function Get_Name: WideString;
    procedure Set_Name(const Name: WideString);
    function Get_Size: Integer;
    procedure Set_Size(Size: Integer);
    function Get_Process: IUnknown;
    procedure Set_Process(const Value: IUnknown);
  public
    property DefaultInterface: IiFont read GetDefaultInterface;
  published
    property Name: WideString read Get_Name write Set_Name;
    property Size: Integer read Get_Size write Set_Size;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoiLegend provides a Create and CreateRemote method to          
// create instances of the default interface IiLegend exposed by              
// the CoClass iLegend. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoiLegend = class
    class function Create: IiLegend;
    class function CreateRemote(const MachineName: string): IiLegend;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TiLegend
// Help String      : iLegendObject
// Default Interface: IiLegend
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TiLegendProperties= class;
{$ENDIF}
  TiLegend = class(TOleServer)
  private
    FIntf:        IiLegend;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TiLegendProperties;
    function      GetServerProperties: TiLegendProperties;
{$ENDIF}
    function      GetDefaultInterface: IiLegend;
  protected
    procedure InitServerData; override;
    function Get_Width: Integer;
    procedure Set_Width(Value: Integer);
    function Get_Height: Integer;
    procedure Set_Height(Value: Integer);
    function Get_Palette: iPal;
    procedure Set_Palette(const Value: iPal);
    function Get_Count: Integer;
    function Get_Font: iFont;
    procedure Set_Font(const Value: iFont);
    function Get_Horizontal: WordBool;
    procedure Set_Horizontal(Value: WordBool);
    function Get_BackColor: Integer;
    procedure Set_BackColor(Value: Integer);
    function Get_BorderColor: Integer;
    procedure Set_BorderColor(Value: Integer);
    function Get_TextPosition: iTextPosition;
    procedure Set_TextPosition(Value: iTextPosition);
    function Get_MaxValue: Double;
    procedure Set_MaxValue(Value: Double);
    function Get_MinValue: Double;
    procedure Set_MinValue(Value: Double);
    function Get_Decimal: Integer;
    procedure Set_Decimal(Value: Integer);
    function Get_iType: LegType;
    function Get_FlagVal: Single;
    procedure Set_FlagVal(Value: Single);
    function Get_FlagDef: WideString;
    procedure Set_FlagDef(const Value: WideString);
    function Get_RefSys: WideString;
    procedure Set_RefSys(const Value: WideString);
    function Get_UnitDist: Double;
    procedure Set_UnitDist(Value: Double);
    function Get_RefUnits: WideString;
    procedure Set_RefUnits(const Value: WideString);
    function Get_ValUnits: WideString;
    procedure Set_ValUnits(const Value: WideString);
    function Get_Process: IUnknown;
    procedure Set_Process(const Value: IUnknown);
    function Get__className(X: Integer): WideString;
    procedure Set__className(X: Integer; const Value: WideString);
    function Get_Disabled(LegendNumber: Integer): WordBool;
    procedure Set_Disabled(LegendNumber: Integer; Value: WordBool);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IiLegend);
    procedure Disconnect; override;
    procedure Draw(Left: Integer; Top: Integer; PictureHandle: Integer);
    procedure Copy;
    procedure SetAutoSize;
    procedure SaveAsJPEG;
    procedure Add(const ClassName: WideString);
    procedure Clear;
    function StreamAs(StreamType: iStreamType): OleVariant;
    procedure Refresh;
    procedure AssignObject(const Source: iLegend);
    property DefaultInterface: IiLegend read GetDefaultInterface;
    property Count: Integer read Get_Count;
    property iType: LegType read Get_iType;
    property Process: IUnknown read Get_Process write Set_Process;
    property _className[X: Integer]: WideString read Get__className write Set__className;
    property Disabled[LegendNumber: Integer]: WordBool read Get_Disabled write Set_Disabled;
    property Width: Integer read Get_Width write Set_Width;
    property Height: Integer read Get_Height write Set_Height;
    property Palette: iPal read Get_Palette write Set_Palette;
    property Font: iFont read Get_Font write Set_Font;
    property Horizontal: WordBool read Get_Horizontal write Set_Horizontal;
    property BackColor: Integer read Get_BackColor write Set_BackColor;
    property BorderColor: Integer read Get_BorderColor write Set_BorderColor;
    property TextPosition: iTextPosition read Get_TextPosition write Set_TextPosition;
    property MaxValue: Double read Get_MaxValue write Set_MaxValue;
    property MinValue: Double read Get_MinValue write Set_MinValue;
    property Decimal: Integer read Get_Decimal write Set_Decimal;
    property FlagVal: Single read Get_FlagVal write Set_FlagVal;
    property FlagDef: WideString read Get_FlagDef write Set_FlagDef;
    property RefSys: WideString read Get_RefSys write Set_RefSys;
    property UnitDist: Double read Get_UnitDist write Set_UnitDist;
    property RefUnits: WideString read Get_RefUnits write Set_RefUnits;
    property ValUnits: WideString read Get_ValUnits write Set_ValUnits;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TiLegendProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TiLegend
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TiLegendProperties = class(TPersistent)
  private
    FServer:    TiLegend;
    function    GetDefaultInterface: IiLegend;
    constructor Create(AServer: TiLegend);
  protected
    function Get_Width: Integer;
    procedure Set_Width(Value: Integer);
    function Get_Height: Integer;
    procedure Set_Height(Value: Integer);
    function Get_Palette: iPal;
    procedure Set_Palette(const Value: iPal);
    function Get_Count: Integer;
    function Get_Font: iFont;
    procedure Set_Font(const Value: iFont);
    function Get_Horizontal: WordBool;
    procedure Set_Horizontal(Value: WordBool);
    function Get_BackColor: Integer;
    procedure Set_BackColor(Value: Integer);
    function Get_BorderColor: Integer;
    procedure Set_BorderColor(Value: Integer);
    function Get_TextPosition: iTextPosition;
    procedure Set_TextPosition(Value: iTextPosition);
    function Get_MaxValue: Double;
    procedure Set_MaxValue(Value: Double);
    function Get_MinValue: Double;
    procedure Set_MinValue(Value: Double);
    function Get_Decimal: Integer;
    procedure Set_Decimal(Value: Integer);
    function Get_iType: LegType;
    function Get_FlagVal: Single;
    procedure Set_FlagVal(Value: Single);
    function Get_FlagDef: WideString;
    procedure Set_FlagDef(const Value: WideString);
    function Get_RefSys: WideString;
    procedure Set_RefSys(const Value: WideString);
    function Get_UnitDist: Double;
    procedure Set_UnitDist(Value: Double);
    function Get_RefUnits: WideString;
    procedure Set_RefUnits(const Value: WideString);
    function Get_ValUnits: WideString;
    procedure Set_ValUnits(const Value: WideString);
    function Get_Process: IUnknown;
    procedure Set_Process(const Value: IUnknown);
    function Get__className(X: Integer): WideString;
    procedure Set__className(X: Integer; const Value: WideString);
    function Get_Disabled(LegendNumber: Integer): WordBool;
    procedure Set_Disabled(LegendNumber: Integer; Value: WordBool);
  public
    property DefaultInterface: IiLegend read GetDefaultInterface;
  published
    property Width: Integer read Get_Width write Set_Width;
    property Height: Integer read Get_Height write Set_Height;
    property Palette: iPal read Get_Palette write Set_Palette;
    property Font: iFont read Get_Font write Set_Font;
    property Horizontal: WordBool read Get_Horizontal write Set_Horizontal;
    property BackColor: Integer read Get_BackColor write Set_BackColor;
    property BorderColor: Integer read Get_BorderColor write Set_BorderColor;
    property TextPosition: iTextPosition read Get_TextPosition write Set_TextPosition;
    property MaxValue: Double read Get_MaxValue write Set_MaxValue;
    property MinValue: Double read Get_MinValue write Set_MinValue;
    property Decimal: Integer read Get_Decimal write Set_Decimal;
    property FlagVal: Single read Get_FlagVal write Set_FlagVal;
    property FlagDef: WideString read Get_FlagDef write Set_FlagDef;
    property RefSys: WideString read Get_RefSys write Set_RefSys;
    property UnitDist: Double read Get_UnitDist write Set_UnitDist;
    property RefUnits: WideString read Get_RefUnits write Set_RefUnits;
    property ValUnits: WideString read Get_ValUnits write Set_ValUnits;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoiData provides a Create and CreateRemote method to          
// create instances of the default interface IiData exposed by              
// the CoClass iData. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoiData = class
    class function Create: IiData;
    class function CreateRemote(const MachineName: string): IiData;
  end;

// *********************************************************************//
// The Class CoiGeoData provides a Create and CreateRemote method to          
// create instances of the default interface IiGeoData exposed by              
// the CoClass iGeoData. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoiGeoData = class
    class function Create: IiGeoData;
    class function CreateRemote(const MachineName: string): IiGeoData;
  end;

// *********************************************************************//
// The Class CoiRaster provides a Create and CreateRemote method to          
// create instances of the default interface IiRaster exposed by              
// the CoClass iRaster. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoiRaster = class
    class function Create: IiRaster;
    class function CreateRemote(const MachineName: string): IiRaster;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TiRaster
// Help String      : Generic Raster Object
// Default Interface: IiRaster
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TiRasterProperties= class;
{$ENDIF}
  TiRaster = class(TOleServer)
  private
    FIntf:        IiRaster;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TiRasterProperties;
    function      GetServerProperties: TiRasterProperties;
{$ENDIF}
    function      GetDefaultInterface: IiRaster;
  protected
    procedure InitServerData; override;
    function Get_CheckStatus: Byte;
    procedure Set_CheckStatus(Value: Byte);
    function Get_Empty: WordBool;
    procedure Set_Empty(Value: WordBool);
    function Get_Changed: WordBool;
    procedure Set_Changed(Value: WordBool);
    function Get_Error: WideString;
    function Get_ObjectName: WideString;
    function Get_Process: IUnknown;
    procedure Set_Process(const Value: IUnknown);
    function Get_DataHandle: Integer;
    function Get_Status: WideString;
    function Get_Processing: WordBool;
    function Get_PercentDone: Byte;
    function Get_Title: WideString;
    procedure Set_Title(const Value: WideString);
    function Get_Legend: iLegend;
    procedure Set_Legend(const Value: iLegend);
    function Get_hDC: Integer;
    function Get_MinX: Double;
    procedure Set_MinX(Value: Double);
    function Get_MaxX: Double;
    procedure Set_MaxX(Value: Double);
    function Get_MinY: Double;
    procedure Set_MinY(Value: Double);
    function Get_MaxY: Double;
    procedure Set_MaxY(Value: Double);
    function Get_Document: iFile;
    procedure Set_Document(const Value: iFile);
    function Get_Comment: iStringList;
    procedure Set_Comment(const Value: iStringList);
    function Get_Lineage: iStringList;
    procedure Set_Lineage(const Value: iStringList);
    function Get_Completeness: iStringList;
    procedure Set_Completeness(const Value: iStringList);
    function Get_Consistency: iStringList;
    procedure Set_Consistency(const Value: iStringList);
    function Get_PartialScene: WordBool;
    function Get_ImageWidth: Integer;
    procedure Set_ImageWidth(Value: Integer);
    function Get_ImageHeight: Integer;
    procedure Set_ImageHeight(Value: Integer);
    function Get_PointXY(X: OleVariant; Y: OleVariant): OleVariant;
    procedure Set_PointXY(X: OleVariant; Y: OleVariant; Value: OleVariant);
    function Get_Cols: Integer;
    function Get_Rows: Integer;
    function Get_Res: Double;
    procedure Set_Res(Value: Double);
    function Get_MaxValue: Double;
    procedure Set_MaxValue(Value: Double);
    function Get_MinValue: Double;
    procedure Set_MinValue(Value: Double);
    function Get_DataType: iDataTypeConst;
    procedure Set_DataType(Value: iDataTypeConst);
    function Get_ByteOrder: iByteOrder;
    function Get_ScanLineOrientation: iScanlineOrientType;
    procedure Set_ScanLineOrientation(Value: iScanlineOrientType);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IiRaster);
    procedure Disconnect; override;
    function ArrayOfVar(SourceArray: OleVariant): OleVariant;
    procedure AssignObject(const Source: iData);
    procedure PasteGeoRefs(const PassVar: iGeoData);
    function Open: WordBool;
    procedure Save;
    function Terminate: WordBool;
    procedure SaveHeader;
    function OpenHeader: WordBool;
    function OpenWindow(X1: OleVariant; Y1: OleVariant; X2: OleVariant; Y2: OleVariant; 
                        Step: Smallint): WordBool;
    function OpenSample(Step: Smallint): WordBool;
    procedure PasteHDC(BitmapHDC: Integer; Width: Integer; Height: Integer);
    procedure Refresh;
    procedure ClearBitmap;
    function StreamMapAs(StreamType: iStreamType): OleVariant;
    procedure PaintPoint(X: OleVariant; Y: OleVariant; Radius: OleVariant; const Color: WideString);
    procedure PaintLine(X1: OleVariant; Y1: OleVariant; X2: OleVariant; Y2: OleVariant; 
                        Width: OleVariant; const Color: WideString);
    procedure PaintPolygon(Points: OleVariant; LineWidth: Integer; const Color: WideString; 
                           BrushStyle: iBrushStyle; IsGeographic: WordBool);
    procedure PaintText(X: OleVariant; Y: OleVariant; const Text: WideString; 
                        const FontName: WideString; Size: Integer; const Style: WideString; 
                        const Color: WideString);
    function StreamAs(StreamType: iStreamType): OleVariant;
    procedure Draw(Left: Integer; Top: Integer; Zoom: Single; PictureHandle: Integer);
    procedure DrawMap(Zoom: Single; PictureHandle: Integer);
    procedure CopyMap(Zoom: Single);
    procedure Copy;
    procedure StretchDraw(hDC: Integer; X1: Double; Y1: Double; X2: Double; Y2: Double; 
                          Left: Integer; Top: Integer; Right: Integer; Bottom: Integer);
    function GetDataBuffer(out DataOut: OleVariant): Integer;
    procedure SetDataBuffer(DataIn: OleVariant);
    function RetrieveBitmap(Source: OleVariant; TimeOut_Sec: Integer; X1: Integer; Y1: Integer; 
                            X2: Integer; Y2: Integer; Transparency: Byte): Integer;
    function Column(X1: Single): Integer;
    function Row(Y1: Single): Integer;
    function CoordX(PassVar: Integer): Single;
    function CoordY(PassVar: Integer): Single;
    procedure GetMaxMin;
    procedure Insert(const PassVar: iRaster);
    procedure SetDataYX(Matrix: OleVariant; X1: Integer; Y1: Integer; X2: Integer; Y2: Integer);
    function GetDataYX(X1: Integer; Y1: Integer; X2: Integer; Y2: Integer): OleVariant;
    procedure New(const NewName: WideString; NewDataType: iDataTypeConst; NewCols: Integer; 
                  NewRows: Integer; InitVal: Single);
    procedure SetData(Matrix: OleVariant; X1: Integer; Y1: Integer; X2: Integer; Y2: Integer);
    function GetData(X1: Integer; Y1: Integer; X2: Integer; Y2: Integer): OleVariant;
    function RetrieveURLData(const URLString: WideString; TimeOut_Sec: Integer; X1: Integer; 
                             Y1: Integer; X2: Integer; Y2: Integer): Integer;
    property DefaultInterface: IiRaster read GetDefaultInterface;
    property CheckStatus: Byte read Get_CheckStatus write Set_CheckStatus;
    property Changed: WordBool read Get_Changed write Set_Changed;
    property Error: WideString read Get_Error;
    property ObjectName: WideString read Get_ObjectName;
    property Process: IUnknown read Get_Process write Set_Process;
    property DataHandle: Integer read Get_DataHandle;
    property Status: WideString read Get_Status;
    property Processing: WordBool read Get_Processing;
    property PercentDone: Byte read Get_PercentDone;
    property hDC: Integer read Get_hDC;
    property PartialScene: WordBool read Get_PartialScene;
    property PointXY[X: OleVariant; Y: OleVariant]: OleVariant read Get_PointXY write Set_PointXY;
    property Cols: Integer read Get_Cols;
    property Rows: Integer read Get_Rows;
    property ByteOrder: iByteOrder read Get_ByteOrder;
    property Empty: WordBool read Get_Empty write Set_Empty;
    property Title: WideString read Get_Title write Set_Title;
    property Legend: iLegend read Get_Legend write Set_Legend;
    property MinX: Double read Get_MinX write Set_MinX;
    property MaxX: Double read Get_MaxX write Set_MaxX;
    property MinY: Double read Get_MinY write Set_MinY;
    property MaxY: Double read Get_MaxY write Set_MaxY;
    property Document: iFile read Get_Document write Set_Document;
    property Comment: iStringList read Get_Comment write Set_Comment;
    property Lineage: iStringList read Get_Lineage write Set_Lineage;
    property Completeness: iStringList read Get_Completeness write Set_Completeness;
    property Consistency: iStringList read Get_Consistency write Set_Consistency;
    property ImageWidth: Integer read Get_ImageWidth write Set_ImageWidth;
    property ImageHeight: Integer read Get_ImageHeight write Set_ImageHeight;
    property Res: Double read Get_Res write Set_Res;
    property MaxValue: Double read Get_MaxValue write Set_MaxValue;
    property MinValue: Double read Get_MinValue write Set_MinValue;
    property DataType: iDataTypeConst read Get_DataType write Set_DataType;
    property ScanLineOrientation: iScanlineOrientType read Get_ScanLineOrientation write Set_ScanLineOrientation;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TiRasterProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TiRaster
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TiRasterProperties = class(TPersistent)
  private
    FServer:    TiRaster;
    function    GetDefaultInterface: IiRaster;
    constructor Create(AServer: TiRaster);
  protected
    function Get_CheckStatus: Byte;
    procedure Set_CheckStatus(Value: Byte);
    function Get_Empty: WordBool;
    procedure Set_Empty(Value: WordBool);
    function Get_Changed: WordBool;
    procedure Set_Changed(Value: WordBool);
    function Get_Error: WideString;
    function Get_ObjectName: WideString;
    function Get_Process: IUnknown;
    procedure Set_Process(const Value: IUnknown);
    function Get_DataHandle: Integer;
    function Get_Status: WideString;
    function Get_Processing: WordBool;
    function Get_PercentDone: Byte;
    function Get_Title: WideString;
    procedure Set_Title(const Value: WideString);
    function Get_Legend: iLegend;
    procedure Set_Legend(const Value: iLegend);
    function Get_hDC: Integer;
    function Get_MinX: Double;
    procedure Set_MinX(Value: Double);
    function Get_MaxX: Double;
    procedure Set_MaxX(Value: Double);
    function Get_MinY: Double;
    procedure Set_MinY(Value: Double);
    function Get_MaxY: Double;
    procedure Set_MaxY(Value: Double);
    function Get_Document: iFile;
    procedure Set_Document(const Value: iFile);
    function Get_Comment: iStringList;
    procedure Set_Comment(const Value: iStringList);
    function Get_Lineage: iStringList;
    procedure Set_Lineage(const Value: iStringList);
    function Get_Completeness: iStringList;
    procedure Set_Completeness(const Value: iStringList);
    function Get_Consistency: iStringList;
    procedure Set_Consistency(const Value: iStringList);
    function Get_PartialScene: WordBool;
    function Get_ImageWidth: Integer;
    procedure Set_ImageWidth(Value: Integer);
    function Get_ImageHeight: Integer;
    procedure Set_ImageHeight(Value: Integer);
    function Get_PointXY(X: OleVariant; Y: OleVariant): OleVariant;
    procedure Set_PointXY(X: OleVariant; Y: OleVariant; Value: OleVariant);
    function Get_Cols: Integer;
    function Get_Rows: Integer;
    function Get_Res: Double;
    procedure Set_Res(Value: Double);
    function Get_MaxValue: Double;
    procedure Set_MaxValue(Value: Double);
    function Get_MinValue: Double;
    procedure Set_MinValue(Value: Double);
    function Get_DataType: iDataTypeConst;
    procedure Set_DataType(Value: iDataTypeConst);
    function Get_ByteOrder: iByteOrder;
    function Get_ScanLineOrientation: iScanlineOrientType;
    procedure Set_ScanLineOrientation(Value: iScanlineOrientType);
  public
    property DefaultInterface: IiRaster read GetDefaultInterface;
  published
    property Empty: WordBool read Get_Empty write Set_Empty;
    property Title: WideString read Get_Title write Set_Title;
    property Legend: iLegend read Get_Legend write Set_Legend;
    property MinX: Double read Get_MinX write Set_MinX;
    property MaxX: Double read Get_MaxX write Set_MaxX;
    property MinY: Double read Get_MinY write Set_MinY;
    property MaxY: Double read Get_MaxY write Set_MaxY;
    property Document: iFile read Get_Document write Set_Document;
    property Comment: iStringList read Get_Comment write Set_Comment;
    property Lineage: iStringList read Get_Lineage write Set_Lineage;
    property Completeness: iStringList read Get_Completeness write Set_Completeness;
    property Consistency: iStringList read Get_Consistency write Set_Consistency;
    property ImageWidth: Integer read Get_ImageWidth write Set_ImageWidth;
    property ImageHeight: Integer read Get_ImageHeight write Set_ImageHeight;
    property Res: Double read Get_Res write Set_Res;
    property MaxValue: Double read Get_MaxValue write Set_MaxValue;
    property MinValue: Double read Get_MinValue write Set_MinValue;
    property DataType: iDataTypeConst read Get_DataType write Set_DataType;
    property ScanLineOrientation: iScanlineOrientType read Get_ScanLineOrientation write Set_ScanLineOrientation;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoiImg provides a Create and CreateRemote method to          
// create instances of the default interface IiImg exposed by              
// the CoClass iImg. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoiImg = class
    class function Create: IiImg;
    class function CreateRemote(const MachineName: string): IiImg;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TiImg
// Help String      : Raster Object for IMG files (IDRISI)
// Default Interface: IiImg
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TiImgProperties= class;
{$ENDIF}
  TiImg = class(TOleServer)
  private
    FIntf:        IiImg;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TiImgProperties;
    function      GetServerProperties: TiImgProperties;
{$ENDIF}
    function      GetDefaultInterface: IiImg;
  protected
    procedure InitServerData; override;
    function Get_CheckStatus: Byte;
    procedure Set_CheckStatus(Value: Byte);
    function Get_Empty: WordBool;
    procedure Set_Empty(Value: WordBool);
    function Get_Changed: WordBool;
    procedure Set_Changed(Value: WordBool);
    function Get_Error: WideString;
    function Get_ObjectName: WideString;
    function Get_Process: IUnknown;
    procedure Set_Process(const Value: IUnknown);
    function Get_DataHandle: Integer;
    function Get_Status: WideString;
    function Get_Processing: WordBool;
    function Get_PercentDone: Byte;
    function Get_Title: WideString;
    procedure Set_Title(const Value: WideString);
    function Get_Legend: iLegend;
    procedure Set_Legend(const Value: iLegend);
    function Get_hDC: Integer;
    function Get_MinX: Double;
    procedure Set_MinX(Value: Double);
    function Get_MaxX: Double;
    procedure Set_MaxX(Value: Double);
    function Get_MinY: Double;
    procedure Set_MinY(Value: Double);
    function Get_MaxY: Double;
    procedure Set_MaxY(Value: Double);
    function Get_Document: iFile;
    procedure Set_Document(const Value: iFile);
    function Get_Comment: iStringList;
    procedure Set_Comment(const Value: iStringList);
    function Get_Lineage: iStringList;
    procedure Set_Lineage(const Value: iStringList);
    function Get_Completeness: iStringList;
    procedure Set_Completeness(const Value: iStringList);
    function Get_Consistency: iStringList;
    procedure Set_Consistency(const Value: iStringList);
    function Get_PartialScene: WordBool;
    function Get_ImageWidth: Integer;
    procedure Set_ImageWidth(Value: Integer);
    function Get_ImageHeight: Integer;
    procedure Set_ImageHeight(Value: Integer);
    function Get_PointXY(X: OleVariant; Y: OleVariant): OleVariant;
    procedure Set_PointXY(X: OleVariant; Y: OleVariant; Value: OleVariant);
    function Get_Cols: Integer;
    function Get_Rows: Integer;
    function Get_Res: Double;
    procedure Set_Res(Value: Double);
    function Get_MaxValue: Double;
    procedure Set_MaxValue(Value: Double);
    function Get_MinValue: Double;
    procedure Set_MinValue(Value: Double);
    function Get_DataType: iDataTypeConst;
    procedure Set_DataType(Value: iDataTypeConst);
    function Get_ByteOrder: iByteOrder;
    function Get_ScanLineOrientation: iScanlineOrientType;
    procedure Set_ScanLineOrientation(Value: iScanlineOrientType);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IiImg);
    procedure Disconnect; override;
    function ArrayOfVar(SourceArray: OleVariant): OleVariant;
    procedure AssignObject(const Source: iData);
    procedure PasteGeoRefs(const PassVar: iGeoData);
    function Open: WordBool;
    procedure Save;
    function Terminate: WordBool;
    procedure SaveHeader;
    function OpenHeader: WordBool;
    function OpenWindow(X1: OleVariant; Y1: OleVariant; X2: OleVariant; Y2: OleVariant; 
                        Step: Smallint): WordBool;
    function OpenSample(Step: Smallint): WordBool;
    procedure PasteHDC(BitmapHDC: Integer; Width: Integer; Height: Integer);
    procedure Refresh;
    procedure ClearBitmap;
    function StreamMapAs(StreamType: iStreamType): OleVariant;
    procedure PaintPoint(X: OleVariant; Y: OleVariant; Radius: OleVariant; const Color: WideString);
    procedure PaintLine(X1: OleVariant; Y1: OleVariant; X2: OleVariant; Y2: OleVariant; 
                        Width: OleVariant; const Color: WideString);
    procedure PaintPolygon(Points: OleVariant; LineWidth: Integer; const Color: WideString; 
                           BrushStyle: iBrushStyle; IsGeographic: WordBool);
    procedure PaintText(X: OleVariant; Y: OleVariant; const Text: WideString; 
                        const FontName: WideString; Size: Integer; const Style: WideString; 
                        const Color: WideString);
    function StreamAs(StreamType: iStreamType): OleVariant;
    procedure Draw(Left: Integer; Top: Integer; Zoom: Single; PictureHandle: Integer);
    procedure DrawMap(Zoom: Single; PictureHandle: Integer);
    procedure CopyMap(Zoom: Single);
    procedure Copy;
    procedure StretchDraw(hDC: Integer; X1: Double; Y1: Double; X2: Double; Y2: Double; 
                          Left: Integer; Top: Integer; Right: Integer; Bottom: Integer);
    function GetDataBuffer(out DataOut: OleVariant): Integer;
    procedure SetDataBuffer(DataIn: OleVariant);
    function RetrieveBitmap(Source: OleVariant; TimeOut_Sec: Integer; X1: Integer; Y1: Integer; 
                            X2: Integer; Y2: Integer; Transparency: Byte): Integer;
    function Column(X1: Single): Integer;
    function Row(Y1: Single): Integer;
    function CoordX(PassVar: Integer): Single;
    function CoordY(PassVar: Integer): Single;
    procedure GetMaxMin;
    procedure Insert(const PassVar: iRaster);
    procedure SetDataYX(Matrix: OleVariant; X1: Integer; Y1: Integer; X2: Integer; Y2: Integer);
    function GetDataYX(X1: Integer; Y1: Integer; X2: Integer; Y2: Integer): OleVariant;
    procedure New(const NewName: WideString; NewDataType: iDataTypeConst; NewCols: Integer; 
                  NewRows: Integer; InitVal: Single);
    procedure SetData(Matrix: OleVariant; X1: Integer; Y1: Integer; X2: Integer; Y2: Integer);
    function GetData(X1: Integer; Y1: Integer; X2: Integer; Y2: Integer): OleVariant;
    function RetrieveURLData(const URLString: WideString; TimeOut_Sec: Integer; X1: Integer; 
                             Y1: Integer; X2: Integer; Y2: Integer): Integer;
    property DefaultInterface: IiImg read GetDefaultInterface;
    property CheckStatus: Byte read Get_CheckStatus write Set_CheckStatus;
    property Changed: WordBool read Get_Changed write Set_Changed;
    property Error: WideString read Get_Error;
    property ObjectName: WideString read Get_ObjectName;
    property Process: IUnknown read Get_Process write Set_Process;
    property DataHandle: Integer read Get_DataHandle;
    property Status: WideString read Get_Status;
    property Processing: WordBool read Get_Processing;
    property PercentDone: Byte read Get_PercentDone;
    property hDC: Integer read Get_hDC;
    property PartialScene: WordBool read Get_PartialScene;
    property PointXY[X: OleVariant; Y: OleVariant]: OleVariant read Get_PointXY write Set_PointXY;
    property Cols: Integer read Get_Cols;
    property Rows: Integer read Get_Rows;
    property ByteOrder: iByteOrder read Get_ByteOrder;
    property Empty: WordBool read Get_Empty write Set_Empty;
    property Title: WideString read Get_Title write Set_Title;
    property Legend: iLegend read Get_Legend write Set_Legend;
    property MinX: Double read Get_MinX write Set_MinX;
    property MaxX: Double read Get_MaxX write Set_MaxX;
    property MinY: Double read Get_MinY write Set_MinY;
    property MaxY: Double read Get_MaxY write Set_MaxY;
    property Document: iFile read Get_Document write Set_Document;
    property Comment: iStringList read Get_Comment write Set_Comment;
    property Lineage: iStringList read Get_Lineage write Set_Lineage;
    property Completeness: iStringList read Get_Completeness write Set_Completeness;
    property Consistency: iStringList read Get_Consistency write Set_Consistency;
    property ImageWidth: Integer read Get_ImageWidth write Set_ImageWidth;
    property ImageHeight: Integer read Get_ImageHeight write Set_ImageHeight;
    property Res: Double read Get_Res write Set_Res;
    property MaxValue: Double read Get_MaxValue write Set_MaxValue;
    property MinValue: Double read Get_MinValue write Set_MinValue;
    property DataType: iDataTypeConst read Get_DataType write Set_DataType;
    property ScanLineOrientation: iScanlineOrientType read Get_ScanLineOrientation write Set_ScanLineOrientation;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TiImgProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TiImg
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TiImgProperties = class(TPersistent)
  private
    FServer:    TiImg;
    function    GetDefaultInterface: IiImg;
    constructor Create(AServer: TiImg);
  protected
    function Get_CheckStatus: Byte;
    procedure Set_CheckStatus(Value: Byte);
    function Get_Empty: WordBool;
    procedure Set_Empty(Value: WordBool);
    function Get_Changed: WordBool;
    procedure Set_Changed(Value: WordBool);
    function Get_Error: WideString;
    function Get_ObjectName: WideString;
    function Get_Process: IUnknown;
    procedure Set_Process(const Value: IUnknown);
    function Get_DataHandle: Integer;
    function Get_Status: WideString;
    function Get_Processing: WordBool;
    function Get_PercentDone: Byte;
    function Get_Title: WideString;
    procedure Set_Title(const Value: WideString);
    function Get_Legend: iLegend;
    procedure Set_Legend(const Value: iLegend);
    function Get_hDC: Integer;
    function Get_MinX: Double;
    procedure Set_MinX(Value: Double);
    function Get_MaxX: Double;
    procedure Set_MaxX(Value: Double);
    function Get_MinY: Double;
    procedure Set_MinY(Value: Double);
    function Get_MaxY: Double;
    procedure Set_MaxY(Value: Double);
    function Get_Document: iFile;
    procedure Set_Document(const Value: iFile);
    function Get_Comment: iStringList;
    procedure Set_Comment(const Value: iStringList);
    function Get_Lineage: iStringList;
    procedure Set_Lineage(const Value: iStringList);
    function Get_Completeness: iStringList;
    procedure Set_Completeness(const Value: iStringList);
    function Get_Consistency: iStringList;
    procedure Set_Consistency(const Value: iStringList);
    function Get_PartialScene: WordBool;
    function Get_ImageWidth: Integer;
    procedure Set_ImageWidth(Value: Integer);
    function Get_ImageHeight: Integer;
    procedure Set_ImageHeight(Value: Integer);
    function Get_PointXY(X: OleVariant; Y: OleVariant): OleVariant;
    procedure Set_PointXY(X: OleVariant; Y: OleVariant; Value: OleVariant);
    function Get_Cols: Integer;
    function Get_Rows: Integer;
    function Get_Res: Double;
    procedure Set_Res(Value: Double);
    function Get_MaxValue: Double;
    procedure Set_MaxValue(Value: Double);
    function Get_MinValue: Double;
    procedure Set_MinValue(Value: Double);
    function Get_DataType: iDataTypeConst;
    procedure Set_DataType(Value: iDataTypeConst);
    function Get_ByteOrder: iByteOrder;
    function Get_ScanLineOrientation: iScanlineOrientType;
    procedure Set_ScanLineOrientation(Value: iScanlineOrientType);
  public
    property DefaultInterface: IiImg read GetDefaultInterface;
  published
    property Empty: WordBool read Get_Empty write Set_Empty;
    property Title: WideString read Get_Title write Set_Title;
    property Legend: iLegend read Get_Legend write Set_Legend;
    property MinX: Double read Get_MinX write Set_MinX;
    property MaxX: Double read Get_MaxX write Set_MaxX;
    property MinY: Double read Get_MinY write Set_MinY;
    property MaxY: Double read Get_MaxY write Set_MaxY;
    property Document: iFile read Get_Document write Set_Document;
    property Comment: iStringList read Get_Comment write Set_Comment;
    property Lineage: iStringList read Get_Lineage write Set_Lineage;
    property Completeness: iStringList read Get_Completeness write Set_Completeness;
    property Consistency: iStringList read Get_Consistency write Set_Consistency;
    property ImageWidth: Integer read Get_ImageWidth write Set_ImageWidth;
    property ImageHeight: Integer read Get_ImageHeight write Set_ImageHeight;
    property Res: Double read Get_Res write Set_Res;
    property MaxValue: Double read Get_MaxValue write Set_MaxValue;
    property MinValue: Double read Get_MinValue write Set_MinValue;
    property DataType: iDataTypeConst read Get_DataType write Set_DataType;
    property ScanLineOrientation: iScanlineOrientType read Get_ScanLineOrientation write Set_ScanLineOrientation;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoiStringList provides a Create and CreateRemote method to          
// create instances of the default interface IiStringList exposed by              
// the CoClass iStringList. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoiStringList = class
    class function Create: IiStringList;
    class function CreateRemote(const MachineName: string): IiStringList;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TiStringList
// Help String      : iStringListObject
// Default Interface: IiStringList
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TiStringListProperties= class;
{$ENDIF}
  TiStringList = class(TOleServer)
  private
    FIntf:        IiStringList;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TiStringListProperties;
    function      GetServerProperties: TiStringListProperties;
{$ENDIF}
    function      GetDefaultInterface: IiStringList;
  protected
    procedure InitServerData; override;
    function Get_Name(Index: Integer): WideString;
    procedure Set_Name(Index: Integer; const Value: WideString);
    function Get_Capacity: Integer;
    function Get_Count: Integer;
    function Get_Sorted: WordBool;
    procedure Set_Sorted(Value: WordBool);
    function Get_Process: IUnknown;
    procedure Set_Process(const Value: IUnknown);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IiStringList);
    procedure Disconnect; override;
    function Add(const S: WideString): Integer;
    procedure Clear;
    procedure Delete(Index: Integer);
    procedure Exchange(Index1: Integer; Index2: Integer);
    function Find(const S: WideString; var Index: Integer): WordBool;
    function IndexOf(const S: WideString): Integer;
    procedure Insert(Index: Integer; const S: WideString);
    procedure AssignObject(const Source: iStringList);
    property DefaultInterface: IiStringList read GetDefaultInterface;
    property Name[Index: Integer]: WideString read Get_Name write Set_Name;
    property Capacity: Integer read Get_Capacity;
    property Count: Integer read Get_Count;
    property Process: IUnknown read Get_Process write Set_Process;
    property Sorted: WordBool read Get_Sorted write Set_Sorted;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TiStringListProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TiStringList
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TiStringListProperties = class(TPersistent)
  private
    FServer:    TiStringList;
    function    GetDefaultInterface: IiStringList;
    constructor Create(AServer: TiStringList);
  protected
    function Get_Name(Index: Integer): WideString;
    procedure Set_Name(Index: Integer; const Value: WideString);
    function Get_Capacity: Integer;
    function Get_Count: Integer;
    function Get_Sorted: WordBool;
    procedure Set_Sorted(Value: WordBool);
    function Get_Process: IUnknown;
    procedure Set_Process(const Value: IUnknown);
  public
    property DefaultInterface: IiStringList read GetDefaultInterface;
  published
    property Sorted: WordBool read Get_Sorted write Set_Sorted;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoiScalar provides a Create and CreateRemote method to          
// create instances of the default interface IiScalar exposed by              
// the CoClass iScalar. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoiScalar = class
    class function Create: IiScalar;
    class function CreateRemote(const MachineName: string): IiScalar;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TiScalar
// Help String      : ScalarObject
// Default Interface: IiScalar
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TiScalarProperties= class;
{$ENDIF}
  TiScalar = class(TOleServer)
  private
    FIntf:        IiScalar;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TiScalarProperties;
    function      GetServerProperties: TiScalarProperties;
{$ENDIF}
    function      GetDefaultInterface: IiScalar;
  protected
    procedure InitServerData; override;
    function Get_CheckStatus: Byte;
    procedure Set_CheckStatus(Value: Byte);
    function Get_Empty: WordBool;
    procedure Set_Empty(Value: WordBool);
    function Get_Changed: WordBool;
    procedure Set_Changed(Value: WordBool);
    function Get_Error: WideString;
    function Get_ObjectName: WideString;
    function Get_Process: IUnknown;
    procedure Set_Process(const Value: IUnknown);
    function Get_DataHandle: Integer;
    function Get_Status: WideString;
    function Get_Processing: WordBool;
    function Get_PercentDone: Byte;
    function Get_Name: WideString;
    procedure Set_Name(const Value: WideString);
    function Get_Value: OleVariant;
    procedure Set_Value(Value: OleVariant);
    function Get_DataType: iDataTypeConst;
    procedure Set_DataType(Value: iDataTypeConst);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IiScalar);
    procedure Disconnect; override;
    function ArrayOfVar(SourceArray: OleVariant): OleVariant;
    procedure AssignObject(const Source: iData);
    property DefaultInterface: IiScalar read GetDefaultInterface;
    property CheckStatus: Byte read Get_CheckStatus write Set_CheckStatus;
    property Changed: WordBool read Get_Changed write Set_Changed;
    property Error: WideString read Get_Error;
    property ObjectName: WideString read Get_ObjectName;
    property Process: IUnknown read Get_Process write Set_Process;
    property DataHandle: Integer read Get_DataHandle;
    property Status: WideString read Get_Status;
    property Processing: WordBool read Get_Processing;
    property PercentDone: Byte read Get_PercentDone;
    property Value: OleVariant read Get_Value write Set_Value;
    property Empty: WordBool read Get_Empty write Set_Empty;
    property Name: WideString read Get_Name write Set_Name;
    property DataType: iDataTypeConst read Get_DataType write Set_DataType;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TiScalarProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TiScalar
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TiScalarProperties = class(TPersistent)
  private
    FServer:    TiScalar;
    function    GetDefaultInterface: IiScalar;
    constructor Create(AServer: TiScalar);
  protected
    function Get_CheckStatus: Byte;
    procedure Set_CheckStatus(Value: Byte);
    function Get_Empty: WordBool;
    procedure Set_Empty(Value: WordBool);
    function Get_Changed: WordBool;
    procedure Set_Changed(Value: WordBool);
    function Get_Error: WideString;
    function Get_ObjectName: WideString;
    function Get_Process: IUnknown;
    procedure Set_Process(const Value: IUnknown);
    function Get_DataHandle: Integer;
    function Get_Status: WideString;
    function Get_Processing: WordBool;
    function Get_PercentDone: Byte;
    function Get_Name: WideString;
    procedure Set_Name(const Value: WideString);
    function Get_Value: OleVariant;
    procedure Set_Value(Value: OleVariant);
    function Get_DataType: iDataTypeConst;
    procedure Set_DataType(Value: iDataTypeConst);
  public
    property DefaultInterface: IiScalar read GetDefaultInterface;
  published
    property Empty: WordBool read Get_Empty write Set_Empty;
    property Name: WideString read Get_Name write Set_Name;
    property DataType: iDataTypeConst read Get_DataType write Set_DataType;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoiVectorial provides a Create and CreateRemote method to          
// create instances of the default interface IiVectorial exposed by              
// the CoClass iVectorial. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoiVectorial = class
    class function Create: IiVectorial;
    class function CreateRemote(const MachineName: string): IiVectorial;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TiVectorial
// Help String      : iVectorial Object
// Default Interface: IiVectorial
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TiVectorialProperties= class;
{$ENDIF}
  TiVectorial = class(TOleServer)
  private
    FIntf:        IiVectorial;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TiVectorialProperties;
    function      GetServerProperties: TiVectorialProperties;
{$ENDIF}
    function      GetDefaultInterface: IiVectorial;
  protected
    procedure InitServerData; override;
    function Get_CheckStatus: Byte;
    procedure Set_CheckStatus(Value: Byte);
    function Get_Empty: WordBool;
    procedure Set_Empty(Value: WordBool);
    function Get_Changed: WordBool;
    procedure Set_Changed(Value: WordBool);
    function Get_Error: WideString;
    function Get_ObjectName: WideString;
    function Get_Process: IUnknown;
    procedure Set_Process(const Value: IUnknown);
    function Get_DataHandle: Integer;
    function Get_Status: WideString;
    function Get_Processing: WordBool;
    function Get_PercentDone: Byte;
    function Get_Title: WideString;
    procedure Set_Title(const Value: WideString);
    function Get_Legend: iLegend;
    procedure Set_Legend(const Value: iLegend);
    function Get_hDC: Integer;
    function Get_MinX: Double;
    procedure Set_MinX(Value: Double);
    function Get_MaxX: Double;
    procedure Set_MaxX(Value: Double);
    function Get_MinY: Double;
    procedure Set_MinY(Value: Double);
    function Get_MaxY: Double;
    procedure Set_MaxY(Value: Double);
    function Get_Document: iFile;
    procedure Set_Document(const Value: iFile);
    function Get_Comment: iStringList;
    procedure Set_Comment(const Value: iStringList);
    function Get_Lineage: iStringList;
    procedure Set_Lineage(const Value: iStringList);
    function Get_Completeness: iStringList;
    procedure Set_Completeness(const Value: iStringList);
    function Get_Consistency: iStringList;
    procedure Set_Consistency(const Value: iStringList);
    function Get_PartialScene: WordBool;
    function Get_ImageWidth: Integer;
    procedure Set_ImageWidth(Value: Integer);
    function Get_ImageHeight: Integer;
    procedure Set_ImageHeight(Value: Integer);
    function Get_PointXY(X: OleVariant; Y: OleVariant): OleVariant;
    procedure Set_PointXY(X: OleVariant; Y: OleVariant; Value: OleVariant);
    function Get_Count: Integer;
    function Get_Value(RecordNumber: Integer): OleVariant;
    procedure Set_Value(RecordNumber: Integer; Value: OleVariant);
    function Get_RecordPointCount(RecordNumber: Integer): Integer;
    procedure Set_RecordPointCount(RecordNumber: Integer; Value: Integer);
    function Get_FileType: iShapeType;
    function Get_IdType: iDataTypeConst;
    function Get_MaxSize: Integer;
    procedure Set_MaxSize(Value: Integer);
    function Get_Val: iVal;
    procedure Set_Val(const Value: iVal);
    function Get_RecordColor(RecordNumber: Integer): Integer;
    function Get_Paint: iPaint;
    procedure Set_Paint(const Value: iPaint);
    function Get_DrawLabels: WordBool;
    procedure Set_DrawLabels(Value: WordBool);
    function Get_RecordBox(RecordNumber: Integer; Position: Integer): OleVariant;
    function Get_DisabledRecord(RecordNumber: Integer): WordBool;
    procedure Set_DisabledRecord(RecordNumber: Integer; Value: WordBool);
    function Get_Color(RecordNumber: Integer): WideString;
    procedure Set_Color(RecordNumber: Integer; const Value: WideString);
    function Get_Selected(RecordNumber: Integer): WordBool;
    procedure Set_Selected(RecordNumber: Integer; Value: WordBool);
    procedure Set_SelectAll(Param1: WordBool);
    function Get_LabelColor(RecordNumber: Integer): WideString;
    procedure Set_LabelColor(RecordNumber: Integer; const Value: WideString);
    function Get_LabelStyle(RecordNumber: Integer): WideString;
    procedure Set_LabelStyle(RecordNumber: Integer; const Value: WideString);
    function Get_LabelSize(RecordNumber: Integer): Smallint;
    procedure Set_LabelSize(RecordNumber: Integer; Value: Smallint);
    function Get_LabelFontName(RecordNumber: Integer): WideString;
    procedure Set_LabelFontName(RecordNumber: Integer; const Value: WideString);
    function Get_PenColor(RecordNumber: Integer): WideString;
    procedure Set_PenColor(RecordNumber: Integer; const Value: WideString);
    function Get_Parts(RecordNumber: Integer; PartNumber: Integer): Integer;
    procedure Set_Parts(RecordNumber: Integer; PartNumber: Integer; Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IiVectorial);
    procedure Disconnect; override;
    function ArrayOfVar(SourceArray: OleVariant): OleVariant;
    procedure AssignObject(const Source: iData);
    procedure PasteGeoRefs(const PassVar: iGeoData);
    function Open: WordBool;
    procedure Save;
    function Terminate: WordBool;
    procedure SaveHeader;
    function OpenHeader: WordBool;
    function OpenWindow(X1: OleVariant; Y1: OleVariant; X2: OleVariant; Y2: OleVariant; 
                        Step: Smallint): WordBool;
    function OpenSample(Step: Smallint): WordBool;
    procedure PasteHDC(BitmapHDC: Integer; Width: Integer; Height: Integer);
    procedure Refresh;
    procedure ClearBitmap;
    function StreamMapAs(StreamType: iStreamType): OleVariant;
    procedure PaintPoint(X: OleVariant; Y: OleVariant; Radius: OleVariant; const Color: WideString);
    procedure PaintLine(X1: OleVariant; Y1: OleVariant; X2: OleVariant; Y2: OleVariant; 
                        Width: OleVariant; const Color: WideString);
    procedure PaintPolygon(Points: OleVariant; LineWidth: Integer; const Color: WideString; 
                           BrushStyle: iBrushStyle; IsGeographic: WordBool);
    procedure PaintText(X: OleVariant; Y: OleVariant; const Text: WideString; 
                        const FontName: WideString; Size: Integer; const Style: WideString; 
                        const Color: WideString);
    function StreamAs(StreamType: iStreamType): OleVariant;
    procedure Draw(Left: Integer; Top: Integer; Zoom: Single; PictureHandle: Integer);
    procedure DrawMap(Zoom: Single; PictureHandle: Integer);
    procedure CopyMap(Zoom: Single);
    procedure Copy;
    procedure StretchDraw(hDC: Integer; X1: Double; Y1: Double; X2: Double; Y2: Double; 
                          Left: Integer; Top: Integer; Right: Integer; Bottom: Integer);
    function GetDataBuffer(out DataOut: OleVariant): Integer;
    procedure SetDataBuffer(DataIn: OleVariant);
    function RetrieveBitmap(Source: OleVariant; TimeOut_Sec: Integer; X1: Integer; Y1: Integer; 
                            X2: Integer; Y2: Integer; Transparency: Byte): Integer;
    procedure DrawObject(hDC: Integer; RecordNumber: Integer; X: Integer; Y: Integer); overload;
    procedure DrawObject(hDC: Integer; RecordNumber: Integer; X: Integer; Y: Integer; 
                         Color: OleVariant); overload;
    procedure AddRecordPoints(ObjectData: OleVariant; Id: Single; RecordNumber: Integer);
    procedure New(const Name: WideString; ObjectsType: iShapeType; IdType: iDataTypeConst);
    function GetRecordBuffer(RecordNumber: Integer): OleVariant;
    function IndexOf(Value: OleVariant): OleVariant;
    function IsPointInPolygon(PolygonIndex: Integer; X: Single; Y: Single): WordBool;
    procedure Insert(ObjectData: OleVariant; Position: Integer; Id: Integer);
    procedure Exchange(Pos1: Integer; Pos2: Integer);
    procedure Delete(RecordNumber: Integer);
    procedure DrawSquare(hDC: Integer; X1: Double; Y1: Double; X2: Double; Y2: Double; X: Integer; 
                         Y: Integer; Color: Integer; Width: Integer);
    function GetRecordPoints(RecordNumber: Integer): OleVariant;
    function SelectString(const QueryString: WideString; AddToSelection: WordBool): WordBool;
    procedure SetRecordPoints(RecordNumber: Integer; Value: OleVariant);
    function GetDisabledRecords: OleVariant;
    procedure SetDisabledRecords(Value: OleVariant);
    function GetSelectedRecords: OleVariant;
    procedure SetSelectedRecords(Value: OleVariant);
    procedure AddRecordBuffer(ObjectData: OleVariant; Id: Single; Position: Integer);
    procedure DrawRecord(hDC: Integer; ObjectNumber: Integer; X: Integer; Y: Integer; 
                         Width: Integer; Height: Integer; const Color: WideString);
    procedure SetLabelProperties(const FontName: WideString; const FontStyle: WideString; 
                                 const FontColor: WideString; FontSize: Integer);
    property DefaultInterface: IiVectorial read GetDefaultInterface;
    property CheckStatus: Byte read Get_CheckStatus write Set_CheckStatus;
    property Changed: WordBool read Get_Changed write Set_Changed;
    property Error: WideString read Get_Error;
    property ObjectName: WideString read Get_ObjectName;
    property Process: IUnknown read Get_Process write Set_Process;
    property DataHandle: Integer read Get_DataHandle;
    property Status: WideString read Get_Status;
    property Processing: WordBool read Get_Processing;
    property PercentDone: Byte read Get_PercentDone;
    property hDC: Integer read Get_hDC;
    property PartialScene: WordBool read Get_PartialScene;
    property PointXY[X: OleVariant; Y: OleVariant]: OleVariant read Get_PointXY write Set_PointXY;
    property Count: Integer read Get_Count;
    property Value[RecordNumber: Integer]: OleVariant read Get_Value write Set_Value;
    property RecordPointCount[RecordNumber: Integer]: Integer read Get_RecordPointCount write Set_RecordPointCount;
    property FileType: iShapeType read Get_FileType;
    property IdType: iDataTypeConst read Get_IdType;
    property RecordColor[RecordNumber: Integer]: Integer read Get_RecordColor;
    property RecordBox[RecordNumber: Integer; Position: Integer]: OleVariant read Get_RecordBox;
    property DisabledRecord[RecordNumber: Integer]: WordBool read Get_DisabledRecord write Set_DisabledRecord;
    property Color[RecordNumber: Integer]: WideString read Get_Color write Set_Color;
    property Selected[RecordNumber: Integer]: WordBool read Get_Selected write Set_Selected;
    property SelectAll: WordBool write Set_SelectAll;
    property LabelColor[RecordNumber: Integer]: WideString read Get_LabelColor write Set_LabelColor;
    property LabelStyle[RecordNumber: Integer]: WideString read Get_LabelStyle write Set_LabelStyle;
    property LabelSize[RecordNumber: Integer]: Smallint read Get_LabelSize write Set_LabelSize;
    property LabelFontName[RecordNumber: Integer]: WideString read Get_LabelFontName write Set_LabelFontName;
    property PenColor[RecordNumber: Integer]: WideString read Get_PenColor write Set_PenColor;
    property Parts[RecordNumber: Integer; PartNumber: Integer]: Integer read Get_Parts write Set_Parts;
    property Empty: WordBool read Get_Empty write Set_Empty;
    property Title: WideString read Get_Title write Set_Title;
    property Legend: iLegend read Get_Legend write Set_Legend;
    property MinX: Double read Get_MinX write Set_MinX;
    property MaxX: Double read Get_MaxX write Set_MaxX;
    property MinY: Double read Get_MinY write Set_MinY;
    property MaxY: Double read Get_MaxY write Set_MaxY;
    property Document: iFile read Get_Document write Set_Document;
    property Comment: iStringList read Get_Comment write Set_Comment;
    property Lineage: iStringList read Get_Lineage write Set_Lineage;
    property Completeness: iStringList read Get_Completeness write Set_Completeness;
    property Consistency: iStringList read Get_Consistency write Set_Consistency;
    property ImageWidth: Integer read Get_ImageWidth write Set_ImageWidth;
    property ImageHeight: Integer read Get_ImageHeight write Set_ImageHeight;
    property MaxSize: Integer read Get_MaxSize write Set_MaxSize;
    property Val: iVal read Get_Val write Set_Val;
    property Paint: iPaint read Get_Paint write Set_Paint;
    property DrawLabels: WordBool read Get_DrawLabels write Set_DrawLabels;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TiVectorialProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TiVectorial
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TiVectorialProperties = class(TPersistent)
  private
    FServer:    TiVectorial;
    function    GetDefaultInterface: IiVectorial;
    constructor Create(AServer: TiVectorial);
  protected
    function Get_CheckStatus: Byte;
    procedure Set_CheckStatus(Value: Byte);
    function Get_Empty: WordBool;
    procedure Set_Empty(Value: WordBool);
    function Get_Changed: WordBool;
    procedure Set_Changed(Value: WordBool);
    function Get_Error: WideString;
    function Get_ObjectName: WideString;
    function Get_Process: IUnknown;
    procedure Set_Process(const Value: IUnknown);
    function Get_DataHandle: Integer;
    function Get_Status: WideString;
    function Get_Processing: WordBool;
    function Get_PercentDone: Byte;
    function Get_Title: WideString;
    procedure Set_Title(const Value: WideString);
    function Get_Legend: iLegend;
    procedure Set_Legend(const Value: iLegend);
    function Get_hDC: Integer;
    function Get_MinX: Double;
    procedure Set_MinX(Value: Double);
    function Get_MaxX: Double;
    procedure Set_MaxX(Value: Double);
    function Get_MinY: Double;
    procedure Set_MinY(Value: Double);
    function Get_MaxY: Double;
    procedure Set_MaxY(Value: Double);
    function Get_Document: iFile;
    procedure Set_Document(const Value: iFile);
    function Get_Comment: iStringList;
    procedure Set_Comment(const Value: iStringList);
    function Get_Lineage: iStringList;
    procedure Set_Lineage(const Value: iStringList);
    function Get_Completeness: iStringList;
    procedure Set_Completeness(const Value: iStringList);
    function Get_Consistency: iStringList;
    procedure Set_Consistency(const Value: iStringList);
    function Get_PartialScene: WordBool;
    function Get_ImageWidth: Integer;
    procedure Set_ImageWidth(Value: Integer);
    function Get_ImageHeight: Integer;
    procedure Set_ImageHeight(Value: Integer);
    function Get_PointXY(X: OleVariant; Y: OleVariant): OleVariant;
    procedure Set_PointXY(X: OleVariant; Y: OleVariant; Value: OleVariant);
    function Get_Count: Integer;
    function Get_Value(RecordNumber: Integer): OleVariant;
    procedure Set_Value(RecordNumber: Integer; Value: OleVariant);
    function Get_RecordPointCount(RecordNumber: Integer): Integer;
    procedure Set_RecordPointCount(RecordNumber: Integer; Value: Integer);
    function Get_FileType: iShapeType;
    function Get_IdType: iDataTypeConst;
    function Get_MaxSize: Integer;
    procedure Set_MaxSize(Value: Integer);
    function Get_Val: iVal;
    procedure Set_Val(const Value: iVal);
    function Get_RecordColor(RecordNumber: Integer): Integer;
    function Get_Paint: iPaint;
    procedure Set_Paint(const Value: iPaint);
    function Get_DrawLabels: WordBool;
    procedure Set_DrawLabels(Value: WordBool);
    function Get_RecordBox(RecordNumber: Integer; Position: Integer): OleVariant;
    function Get_DisabledRecord(RecordNumber: Integer): WordBool;
    procedure Set_DisabledRecord(RecordNumber: Integer; Value: WordBool);
    function Get_Color(RecordNumber: Integer): WideString;
    procedure Set_Color(RecordNumber: Integer; const Value: WideString);
    function Get_Selected(RecordNumber: Integer): WordBool;
    procedure Set_Selected(RecordNumber: Integer; Value: WordBool);
    procedure Set_SelectAll(Param1: WordBool);
    function Get_LabelColor(RecordNumber: Integer): WideString;
    procedure Set_LabelColor(RecordNumber: Integer; const Value: WideString);
    function Get_LabelStyle(RecordNumber: Integer): WideString;
    procedure Set_LabelStyle(RecordNumber: Integer; const Value: WideString);
    function Get_LabelSize(RecordNumber: Integer): Smallint;
    procedure Set_LabelSize(RecordNumber: Integer; Value: Smallint);
    function Get_LabelFontName(RecordNumber: Integer): WideString;
    procedure Set_LabelFontName(RecordNumber: Integer; const Value: WideString);
    function Get_PenColor(RecordNumber: Integer): WideString;
    procedure Set_PenColor(RecordNumber: Integer; const Value: WideString);
    function Get_Parts(RecordNumber: Integer; PartNumber: Integer): Integer;
    procedure Set_Parts(RecordNumber: Integer; PartNumber: Integer; Value: Integer);
  public
    property DefaultInterface: IiVectorial read GetDefaultInterface;
  published
    property Empty: WordBool read Get_Empty write Set_Empty;
    property Title: WideString read Get_Title write Set_Title;
    property Legend: iLegend read Get_Legend write Set_Legend;
    property MinX: Double read Get_MinX write Set_MinX;
    property MaxX: Double read Get_MaxX write Set_MaxX;
    property MinY: Double read Get_MinY write Set_MinY;
    property MaxY: Double read Get_MaxY write Set_MaxY;
    property Document: iFile read Get_Document write Set_Document;
    property Comment: iStringList read Get_Comment write Set_Comment;
    property Lineage: iStringList read Get_Lineage write Set_Lineage;
    property Completeness: iStringList read Get_Completeness write Set_Completeness;
    property Consistency: iStringList read Get_Consistency write Set_Consistency;
    property ImageWidth: Integer read Get_ImageWidth write Set_ImageWidth;
    property ImageHeight: Integer read Get_ImageHeight write Set_ImageHeight;
    property MaxSize: Integer read Get_MaxSize write Set_MaxSize;
    property Val: iVal read Get_Val write Set_Val;
    property Paint: iPaint read Get_Paint write Set_Paint;
    property DrawLabels: WordBool read Get_DrawLabels write Set_DrawLabels;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoiVec provides a Create and CreateRemote method to          
// create instances of the default interface IiVec exposed by              
// the CoClass iVec. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoiVec = class
    class function Create: IiVec;
    class function CreateRemote(const MachineName: string): IiVec;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TiVec
// Help String      : iVec Object
// Default Interface: IiVec
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TiVecProperties= class;
{$ENDIF}
  TiVec = class(TOleServer)
  private
    FIntf:        IiVec;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TiVecProperties;
    function      GetServerProperties: TiVecProperties;
{$ENDIF}
    function      GetDefaultInterface: IiVec;
  protected
    procedure InitServerData; override;
    function Get_CheckStatus: Byte;
    procedure Set_CheckStatus(Value: Byte);
    function Get_Empty: WordBool;
    procedure Set_Empty(Value: WordBool);
    function Get_Changed: WordBool;
    procedure Set_Changed(Value: WordBool);
    function Get_Error: WideString;
    function Get_ObjectName: WideString;
    function Get_Process: IUnknown;
    procedure Set_Process(const Value: IUnknown);
    function Get_DataHandle: Integer;
    function Get_Status: WideString;
    function Get_Processing: WordBool;
    function Get_PercentDone: Byte;
    function Get_Title: WideString;
    procedure Set_Title(const Value: WideString);
    function Get_Legend: iLegend;
    procedure Set_Legend(const Value: iLegend);
    function Get_hDC: Integer;
    function Get_MinX: Double;
    procedure Set_MinX(Value: Double);
    function Get_MaxX: Double;
    procedure Set_MaxX(Value: Double);
    function Get_MinY: Double;
    procedure Set_MinY(Value: Double);
    function Get_MaxY: Double;
    procedure Set_MaxY(Value: Double);
    function Get_Document: iFile;
    procedure Set_Document(const Value: iFile);
    function Get_Comment: iStringList;
    procedure Set_Comment(const Value: iStringList);
    function Get_Lineage: iStringList;
    procedure Set_Lineage(const Value: iStringList);
    function Get_Completeness: iStringList;
    procedure Set_Completeness(const Value: iStringList);
    function Get_Consistency: iStringList;
    procedure Set_Consistency(const Value: iStringList);
    function Get_PartialScene: WordBool;
    function Get_ImageWidth: Integer;
    procedure Set_ImageWidth(Value: Integer);
    function Get_ImageHeight: Integer;
    procedure Set_ImageHeight(Value: Integer);
    function Get_PointXY(X: OleVariant; Y: OleVariant): OleVariant;
    procedure Set_PointXY(X: OleVariant; Y: OleVariant; Value: OleVariant);
    function Get_Count: Integer;
    function Get_Value(RecordNumber: Integer): OleVariant;
    procedure Set_Value(RecordNumber: Integer; Value: OleVariant);
    function Get_RecordPointCount(RecordNumber: Integer): Integer;
    procedure Set_RecordPointCount(RecordNumber: Integer; Value: Integer);
    function Get_FileType: iShapeType;
    function Get_IdType: iDataTypeConst;
    function Get_MaxSize: Integer;
    procedure Set_MaxSize(Value: Integer);
    function Get_Val: iVal;
    procedure Set_Val(const Value: iVal);
    function Get_RecordColor(RecordNumber: Integer): Integer;
    function Get_Paint: iPaint;
    procedure Set_Paint(const Value: iPaint);
    function Get_DrawLabels: WordBool;
    procedure Set_DrawLabels(Value: WordBool);
    function Get_RecordBox(RecordNumber: Integer; Position: Integer): OleVariant;
    function Get_DisabledRecord(RecordNumber: Integer): WordBool;
    procedure Set_DisabledRecord(RecordNumber: Integer; Value: WordBool);
    function Get_Color(RecordNumber: Integer): WideString;
    procedure Set_Color(RecordNumber: Integer; const Value: WideString);
    function Get_Selected(RecordNumber: Integer): WordBool;
    procedure Set_Selected(RecordNumber: Integer; Value: WordBool);
    procedure Set_SelectAll(Param1: WordBool);
    function Get_LabelColor(RecordNumber: Integer): WideString;
    procedure Set_LabelColor(RecordNumber: Integer; const Value: WideString);
    function Get_LabelStyle(RecordNumber: Integer): WideString;
    procedure Set_LabelStyle(RecordNumber: Integer; const Value: WideString);
    function Get_LabelSize(RecordNumber: Integer): Smallint;
    procedure Set_LabelSize(RecordNumber: Integer; Value: Smallint);
    function Get_LabelFontName(RecordNumber: Integer): WideString;
    procedure Set_LabelFontName(RecordNumber: Integer; const Value: WideString);
    function Get_PenColor(RecordNumber: Integer): WideString;
    procedure Set_PenColor(RecordNumber: Integer; const Value: WideString);
    function Get_Parts(RecordNumber: Integer; PartNumber: Integer): Integer;
    procedure Set_Parts(RecordNumber: Integer; PartNumber: Integer; Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IiVec);
    procedure Disconnect; override;
    function ArrayOfVar(SourceArray: OleVariant): OleVariant;
    procedure AssignObject(const Source: iData);
    procedure PasteGeoRefs(const PassVar: iGeoData);
    function Open: WordBool;
    procedure Save;
    function Terminate: WordBool;
    procedure SaveHeader;
    function OpenHeader: WordBool;
    function OpenWindow(X1: OleVariant; Y1: OleVariant; X2: OleVariant; Y2: OleVariant; 
                        Step: Smallint): WordBool;
    function OpenSample(Step: Smallint): WordBool;
    procedure PasteHDC(BitmapHDC: Integer; Width: Integer; Height: Integer);
    procedure Refresh;
    procedure ClearBitmap;
    function StreamMapAs(StreamType: iStreamType): OleVariant;
    procedure PaintPoint(X: OleVariant; Y: OleVariant; Radius: OleVariant; const Color: WideString);
    procedure PaintLine(X1: OleVariant; Y1: OleVariant; X2: OleVariant; Y2: OleVariant; 
                        Width: OleVariant; const Color: WideString);
    procedure PaintPolygon(Points: OleVariant; LineWidth: Integer; const Color: WideString; 
                           BrushStyle: iBrushStyle; IsGeographic: WordBool);
    procedure PaintText(X: OleVariant; Y: OleVariant; const Text: WideString; 
                        const FontName: WideString; Size: Integer; const Style: WideString; 
                        const Color: WideString);
    function StreamAs(StreamType: iStreamType): OleVariant;
    procedure Draw(Left: Integer; Top: Integer; Zoom: Single; PictureHandle: Integer);
    procedure DrawMap(Zoom: Single; PictureHandle: Integer);
    procedure CopyMap(Zoom: Single);
    procedure Copy;
    procedure StretchDraw(hDC: Integer; X1: Double; Y1: Double; X2: Double; Y2: Double; 
                          Left: Integer; Top: Integer; Right: Integer; Bottom: Integer);
    function GetDataBuffer(out DataOut: OleVariant): Integer;
    procedure SetDataBuffer(DataIn: OleVariant);
    function RetrieveBitmap(Source: OleVariant; TimeOut_Sec: Integer; X1: Integer; Y1: Integer; 
                            X2: Integer; Y2: Integer; Transparency: Byte): Integer;
    procedure DrawObject(hDC: Integer; RecordNumber: Integer; X: Integer; Y: Integer); overload;
    procedure DrawObject(hDC: Integer; RecordNumber: Integer; X: Integer; Y: Integer; 
                         Color: OleVariant); overload;
    procedure AddRecordPoints(ObjectData: OleVariant; Id: Single; RecordNumber: Integer);
    procedure New(const Name: WideString; ObjectsType: iShapeType; IdType: iDataTypeConst);
    function GetRecordBuffer(RecordNumber: Integer): OleVariant;
    function IndexOf(Value: OleVariant): OleVariant;
    function IsPointInPolygon(PolygonIndex: Integer; X: Single; Y: Single): WordBool;
    procedure Insert(ObjectData: OleVariant; Position: Integer; Id: Integer);
    procedure Exchange(Pos1: Integer; Pos2: Integer);
    procedure Delete(RecordNumber: Integer);
    procedure DrawSquare(hDC: Integer; X1: Double; Y1: Double; X2: Double; Y2: Double; X: Integer; 
                         Y: Integer; Color: Integer; Width: Integer);
    function GetRecordPoints(RecordNumber: Integer): OleVariant;
    function SelectString(const QueryString: WideString; AddToSelection: WordBool): WordBool;
    procedure SetRecordPoints(RecordNumber: Integer; Value: OleVariant);
    function GetDisabledRecords: OleVariant;
    procedure SetDisabledRecords(Value: OleVariant);
    function GetSelectedRecords: OleVariant;
    procedure SetSelectedRecords(Value: OleVariant);
    procedure AddRecordBuffer(ObjectData: OleVariant; Id: Single; Position: Integer);
    procedure DrawRecord(hDC: Integer; ObjectNumber: Integer; X: Integer; Y: Integer; 
                         Width: Integer; Height: Integer; const Color: WideString);
    procedure SetLabelProperties(const FontName: WideString; const FontStyle: WideString; 
                                 const FontColor: WideString; FontSize: Integer);
    property DefaultInterface: IiVec read GetDefaultInterface;
    property CheckStatus: Byte read Get_CheckStatus write Set_CheckStatus;
    property Changed: WordBool read Get_Changed write Set_Changed;
    property Error: WideString read Get_Error;
    property ObjectName: WideString read Get_ObjectName;
    property Process: IUnknown read Get_Process write Set_Process;
    property DataHandle: Integer read Get_DataHandle;
    property Status: WideString read Get_Status;
    property Processing: WordBool read Get_Processing;
    property PercentDone: Byte read Get_PercentDone;
    property hDC: Integer read Get_hDC;
    property PartialScene: WordBool read Get_PartialScene;
    property PointXY[X: OleVariant; Y: OleVariant]: OleVariant read Get_PointXY write Set_PointXY;
    property Count: Integer read Get_Count;
    property Value[RecordNumber: Integer]: OleVariant read Get_Value write Set_Value;
    property RecordPointCount[RecordNumber: Integer]: Integer read Get_RecordPointCount write Set_RecordPointCount;
    property FileType: iShapeType read Get_FileType;
    property IdType: iDataTypeConst read Get_IdType;
    property RecordColor[RecordNumber: Integer]: Integer read Get_RecordColor;
    property RecordBox[RecordNumber: Integer; Position: Integer]: OleVariant read Get_RecordBox;
    property DisabledRecord[RecordNumber: Integer]: WordBool read Get_DisabledRecord write Set_DisabledRecord;
    property Color[RecordNumber: Integer]: WideString read Get_Color write Set_Color;
    property Selected[RecordNumber: Integer]: WordBool read Get_Selected write Set_Selected;
    property SelectAll: WordBool write Set_SelectAll;
    property LabelColor[RecordNumber: Integer]: WideString read Get_LabelColor write Set_LabelColor;
    property LabelStyle[RecordNumber: Integer]: WideString read Get_LabelStyle write Set_LabelStyle;
    property LabelSize[RecordNumber: Integer]: Smallint read Get_LabelSize write Set_LabelSize;
    property LabelFontName[RecordNumber: Integer]: WideString read Get_LabelFontName write Set_LabelFontName;
    property PenColor[RecordNumber: Integer]: WideString read Get_PenColor write Set_PenColor;
    property Parts[RecordNumber: Integer; PartNumber: Integer]: Integer read Get_Parts write Set_Parts;
    property Empty: WordBool read Get_Empty write Set_Empty;
    property Title: WideString read Get_Title write Set_Title;
    property Legend: iLegend read Get_Legend write Set_Legend;
    property MinX: Double read Get_MinX write Set_MinX;
    property MaxX: Double read Get_MaxX write Set_MaxX;
    property MinY: Double read Get_MinY write Set_MinY;
    property MaxY: Double read Get_MaxY write Set_MaxY;
    property Document: iFile read Get_Document write Set_Document;
    property Comment: iStringList read Get_Comment write Set_Comment;
    property Lineage: iStringList read Get_Lineage write Set_Lineage;
    property Completeness: iStringList read Get_Completeness write Set_Completeness;
    property Consistency: iStringList read Get_Consistency write Set_Consistency;
    property ImageWidth: Integer read Get_ImageWidth write Set_ImageWidth;
    property ImageHeight: Integer read Get_ImageHeight write Set_ImageHeight;
    property MaxSize: Integer read Get_MaxSize write Set_MaxSize;
    property Val: iVal read Get_Val write Set_Val;
    property Paint: iPaint read Get_Paint write Set_Paint;
    property DrawLabels: WordBool read Get_DrawLabels write Set_DrawLabels;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TiVecProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TiVec
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TiVecProperties = class(TPersistent)
  private
    FServer:    TiVec;
    function    GetDefaultInterface: IiVec;
    constructor Create(AServer: TiVec);
  protected
    function Get_CheckStatus: Byte;
    procedure Set_CheckStatus(Value: Byte);
    function Get_Empty: WordBool;
    procedure Set_Empty(Value: WordBool);
    function Get_Changed: WordBool;
    procedure Set_Changed(Value: WordBool);
    function Get_Error: WideString;
    function Get_ObjectName: WideString;
    function Get_Process: IUnknown;
    procedure Set_Process(const Value: IUnknown);
    function Get_DataHandle: Integer;
    function Get_Status: WideString;
    function Get_Processing: WordBool;
    function Get_PercentDone: Byte;
    function Get_Title: WideString;
    procedure Set_Title(const Value: WideString);
    function Get_Legend: iLegend;
    procedure Set_Legend(const Value: iLegend);
    function Get_hDC: Integer;
    function Get_MinX: Double;
    procedure Set_MinX(Value: Double);
    function Get_MaxX: Double;
    procedure Set_MaxX(Value: Double);
    function Get_MinY: Double;
    procedure Set_MinY(Value: Double);
    function Get_MaxY: Double;
    procedure Set_MaxY(Value: Double);
    function Get_Document: iFile;
    procedure Set_Document(const Value: iFile);
    function Get_Comment: iStringList;
    procedure Set_Comment(const Value: iStringList);
    function Get_Lineage: iStringList;
    procedure Set_Lineage(const Value: iStringList);
    function Get_Completeness: iStringList;
    procedure Set_Completeness(const Value: iStringList);
    function Get_Consistency: iStringList;
    procedure Set_Consistency(const Value: iStringList);
    function Get_PartialScene: WordBool;
    function Get_ImageWidth: Integer;
    procedure Set_ImageWidth(Value: Integer);
    function Get_ImageHeight: Integer;
    procedure Set_ImageHeight(Value: Integer);
    function Get_PointXY(X: OleVariant; Y: OleVariant): OleVariant;
    procedure Set_PointXY(X: OleVariant; Y: OleVariant; Value: OleVariant);
    function Get_Count: Integer;
    function Get_Value(RecordNumber: Integer): OleVariant;
    procedure Set_Value(RecordNumber: Integer; Value: OleVariant);
    function Get_RecordPointCount(RecordNumber: Integer): Integer;
    procedure Set_RecordPointCount(RecordNumber: Integer; Value: Integer);
    function Get_FileType: iShapeType;
    function Get_IdType: iDataTypeConst;
    function Get_MaxSize: Integer;
    procedure Set_MaxSize(Value: Integer);
    function Get_Val: iVal;
    procedure Set_Val(const Value: iVal);
    function Get_RecordColor(RecordNumber: Integer): Integer;
    function Get_Paint: iPaint;
    procedure Set_Paint(const Value: iPaint);
    function Get_DrawLabels: WordBool;
    procedure Set_DrawLabels(Value: WordBool);
    function Get_RecordBox(RecordNumber: Integer; Position: Integer): OleVariant;
    function Get_DisabledRecord(RecordNumber: Integer): WordBool;
    procedure Set_DisabledRecord(RecordNumber: Integer; Value: WordBool);
    function Get_Color(RecordNumber: Integer): WideString;
    procedure Set_Color(RecordNumber: Integer; const Value: WideString);
    function Get_Selected(RecordNumber: Integer): WordBool;
    procedure Set_Selected(RecordNumber: Integer; Value: WordBool);
    procedure Set_SelectAll(Param1: WordBool);
    function Get_LabelColor(RecordNumber: Integer): WideString;
    procedure Set_LabelColor(RecordNumber: Integer; const Value: WideString);
    function Get_LabelStyle(RecordNumber: Integer): WideString;
    procedure Set_LabelStyle(RecordNumber: Integer; const Value: WideString);
    function Get_LabelSize(RecordNumber: Integer): Smallint;
    procedure Set_LabelSize(RecordNumber: Integer; Value: Smallint);
    function Get_LabelFontName(RecordNumber: Integer): WideString;
    procedure Set_LabelFontName(RecordNumber: Integer; const Value: WideString);
    function Get_PenColor(RecordNumber: Integer): WideString;
    procedure Set_PenColor(RecordNumber: Integer; const Value: WideString);
    function Get_Parts(RecordNumber: Integer; PartNumber: Integer): Integer;
    procedure Set_Parts(RecordNumber: Integer; PartNumber: Integer; Value: Integer);
  public
    property DefaultInterface: IiVec read GetDefaultInterface;
  published
    property Empty: WordBool read Get_Empty write Set_Empty;
    property Title: WideString read Get_Title write Set_Title;
    property Legend: iLegend read Get_Legend write Set_Legend;
    property MinX: Double read Get_MinX write Set_MinX;
    property MaxX: Double read Get_MaxX write Set_MaxX;
    property MinY: Double read Get_MinY write Set_MinY;
    property MaxY: Double read Get_MaxY write Set_MaxY;
    property Document: iFile read Get_Document write Set_Document;
    property Comment: iStringList read Get_Comment write Set_Comment;
    property Lineage: iStringList read Get_Lineage write Set_Lineage;
    property Completeness: iStringList read Get_Completeness write Set_Completeness;
    property Consistency: iStringList read Get_Consistency write Set_Consistency;
    property ImageWidth: Integer read Get_ImageWidth write Set_ImageWidth;
    property ImageHeight: Integer read Get_ImageHeight write Set_ImageHeight;
    property MaxSize: Integer read Get_MaxSize write Set_MaxSize;
    property Val: iVal read Get_Val write Set_Val;
    property Paint: iPaint read Get_Paint write Set_Paint;
    property DrawLabels: WordBool read Get_DrawLabels write Set_DrawLabels;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoiDiscreteLeg provides a Create and CreateRemote method to          
// create instances of the default interface IiDiscreteLeg exposed by              
// the CoClass iDiscreteLeg. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoiDiscreteLeg = class
    class function Create: IiDiscreteLeg;
    class function CreateRemote(const MachineName: string): IiDiscreteLeg;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TiDiscreteLeg
// Help String      : iDiscreteLeg Object
// Default Interface: IiDiscreteLeg
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TiDiscreteLegProperties= class;
{$ENDIF}
  TiDiscreteLeg = class(TOleServer)
  private
    FIntf:        IiDiscreteLeg;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TiDiscreteLegProperties;
    function      GetServerProperties: TiDiscreteLegProperties;
{$ENDIF}
    function      GetDefaultInterface: IiDiscreteLeg;
  protected
    procedure InitServerData; override;
    function Get_Width: Integer;
    procedure Set_Width(Value: Integer);
    function Get_Height: Integer;
    procedure Set_Height(Value: Integer);
    function Get_Palette: iPal;
    procedure Set_Palette(const Value: iPal);
    function Get_Count: Integer;
    function Get_Font: iFont;
    procedure Set_Font(const Value: iFont);
    function Get_Horizontal: WordBool;
    procedure Set_Horizontal(Value: WordBool);
    function Get_BackColor: Integer;
    procedure Set_BackColor(Value: Integer);
    function Get_BorderColor: Integer;
    procedure Set_BorderColor(Value: Integer);
    function Get_TextPosition: iTextPosition;
    procedure Set_TextPosition(Value: iTextPosition);
    function Get_MaxValue: Double;
    procedure Set_MaxValue(Value: Double);
    function Get_MinValue: Double;
    procedure Set_MinValue(Value: Double);
    function Get_Decimal: Integer;
    procedure Set_Decimal(Value: Integer);
    function Get_iType: LegType;
    function Get_FlagVal: Single;
    procedure Set_FlagVal(Value: Single);
    function Get_FlagDef: WideString;
    procedure Set_FlagDef(const Value: WideString);
    function Get_RefSys: WideString;
    procedure Set_RefSys(const Value: WideString);
    function Get_UnitDist: Double;
    procedure Set_UnitDist(Value: Double);
    function Get_RefUnits: WideString;
    procedure Set_RefUnits(const Value: WideString);
    function Get_ValUnits: WideString;
    procedure Set_ValUnits(const Value: WideString);
    function Get_Process: IUnknown;
    procedure Set_Process(const Value: IUnknown);
    function Get__className(X: Integer): WideString;
    procedure Set__className(X: Integer; const Value: WideString);
    function Get_Disabled(LegendNumber: Integer): WordBool;
    procedure Set_Disabled(LegendNumber: Integer; Value: WordBool);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IiDiscreteLeg);
    procedure Disconnect; override;
    procedure Draw(Left: Integer; Top: Integer; PictureHandle: Integer);
    procedure Copy;
    procedure SetAutoSize;
    procedure SaveAsJPEG;
    procedure Add(const ClassName: WideString);
    procedure Clear;
    function StreamAs(StreamType: iStreamType): OleVariant;
    procedure Refresh;
    procedure AssignObject(const Source: iLegend);
    property DefaultInterface: IiDiscreteLeg read GetDefaultInterface;
    property Count: Integer read Get_Count;
    property iType: LegType read Get_iType;
    property Process: IUnknown read Get_Process write Set_Process;
    property _className[X: Integer]: WideString read Get__className write Set__className;
    property Disabled[LegendNumber: Integer]: WordBool read Get_Disabled write Set_Disabled;
    property Width: Integer read Get_Width write Set_Width;
    property Height: Integer read Get_Height write Set_Height;
    property Palette: iPal read Get_Palette write Set_Palette;
    property Font: iFont read Get_Font write Set_Font;
    property Horizontal: WordBool read Get_Horizontal write Set_Horizontal;
    property BackColor: Integer read Get_BackColor write Set_BackColor;
    property BorderColor: Integer read Get_BorderColor write Set_BorderColor;
    property TextPosition: iTextPosition read Get_TextPosition write Set_TextPosition;
    property MaxValue: Double read Get_MaxValue write Set_MaxValue;
    property MinValue: Double read Get_MinValue write Set_MinValue;
    property Decimal: Integer read Get_Decimal write Set_Decimal;
    property FlagVal: Single read Get_FlagVal write Set_FlagVal;
    property FlagDef: WideString read Get_FlagDef write Set_FlagDef;
    property RefSys: WideString read Get_RefSys write Set_RefSys;
    property UnitDist: Double read Get_UnitDist write Set_UnitDist;
    property RefUnits: WideString read Get_RefUnits write Set_RefUnits;
    property ValUnits: WideString read Get_ValUnits write Set_ValUnits;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TiDiscreteLegProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TiDiscreteLeg
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TiDiscreteLegProperties = class(TPersistent)
  private
    FServer:    TiDiscreteLeg;
    function    GetDefaultInterface: IiDiscreteLeg;
    constructor Create(AServer: TiDiscreteLeg);
  protected
    function Get_Width: Integer;
    procedure Set_Width(Value: Integer);
    function Get_Height: Integer;
    procedure Set_Height(Value: Integer);
    function Get_Palette: iPal;
    procedure Set_Palette(const Value: iPal);
    function Get_Count: Integer;
    function Get_Font: iFont;
    procedure Set_Font(const Value: iFont);
    function Get_Horizontal: WordBool;
    procedure Set_Horizontal(Value: WordBool);
    function Get_BackColor: Integer;
    procedure Set_BackColor(Value: Integer);
    function Get_BorderColor: Integer;
    procedure Set_BorderColor(Value: Integer);
    function Get_TextPosition: iTextPosition;
    procedure Set_TextPosition(Value: iTextPosition);
    function Get_MaxValue: Double;
    procedure Set_MaxValue(Value: Double);
    function Get_MinValue: Double;
    procedure Set_MinValue(Value: Double);
    function Get_Decimal: Integer;
    procedure Set_Decimal(Value: Integer);
    function Get_iType: LegType;
    function Get_FlagVal: Single;
    procedure Set_FlagVal(Value: Single);
    function Get_FlagDef: WideString;
    procedure Set_FlagDef(const Value: WideString);
    function Get_RefSys: WideString;
    procedure Set_RefSys(const Value: WideString);
    function Get_UnitDist: Double;
    procedure Set_UnitDist(Value: Double);
    function Get_RefUnits: WideString;
    procedure Set_RefUnits(const Value: WideString);
    function Get_ValUnits: WideString;
    procedure Set_ValUnits(const Value: WideString);
    function Get_Process: IUnknown;
    procedure Set_Process(const Value: IUnknown);
    function Get__className(X: Integer): WideString;
    procedure Set__className(X: Integer; const Value: WideString);
    function Get_Disabled(LegendNumber: Integer): WordBool;
    procedure Set_Disabled(LegendNumber: Integer; Value: WordBool);
  public
    property DefaultInterface: IiDiscreteLeg read GetDefaultInterface;
  published
    property Width: Integer read Get_Width write Set_Width;
    property Height: Integer read Get_Height write Set_Height;
    property Palette: iPal read Get_Palette write Set_Palette;
    property Font: iFont read Get_Font write Set_Font;
    property Horizontal: WordBool read Get_Horizontal write Set_Horizontal;
    property BackColor: Integer read Get_BackColor write Set_BackColor;
    property BorderColor: Integer read Get_BorderColor write Set_BorderColor;
    property TextPosition: iTextPosition read Get_TextPosition write Set_TextPosition;
    property MaxValue: Double read Get_MaxValue write Set_MaxValue;
    property MinValue: Double read Get_MinValue write Set_MinValue;
    property Decimal: Integer read Get_Decimal write Set_Decimal;
    property FlagVal: Single read Get_FlagVal write Set_FlagVal;
    property FlagDef: WideString read Get_FlagDef write Set_FlagDef;
    property RefSys: WideString read Get_RefSys write Set_RefSys;
    property UnitDist: Double read Get_UnitDist write Set_UnitDist;
    property RefUnits: WideString read Get_RefUnits write Set_RefUnits;
    property ValUnits: WideString read Get_ValUnits write Set_ValUnits;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoiContLeg provides a Create and CreateRemote method to          
// create instances of the default interface IiContLeg exposed by              
// the CoClass iContLeg. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoiContLeg = class
    class function Create: IiContLeg;
    class function CreateRemote(const MachineName: string): IiContLeg;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TiContLeg
// Help String      : iContLeg Object
// Default Interface: IiContLeg
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TiContLegProperties= class;
{$ENDIF}
  TiContLeg = class(TOleServer)
  private
    FIntf:        IiContLeg;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TiContLegProperties;
    function      GetServerProperties: TiContLegProperties;
{$ENDIF}
    function      GetDefaultInterface: IiContLeg;
  protected
    procedure InitServerData; override;
    function Get_Width: Integer;
    procedure Set_Width(Value: Integer);
    function Get_Height: Integer;
    procedure Set_Height(Value: Integer);
    function Get_Palette: iPal;
    procedure Set_Palette(const Value: iPal);
    function Get_Count: Integer;
    function Get_Font: iFont;
    procedure Set_Font(const Value: iFont);
    function Get_Horizontal: WordBool;
    procedure Set_Horizontal(Value: WordBool);
    function Get_BackColor: Integer;
    procedure Set_BackColor(Value: Integer);
    function Get_BorderColor: Integer;
    procedure Set_BorderColor(Value: Integer);
    function Get_TextPosition: iTextPosition;
    procedure Set_TextPosition(Value: iTextPosition);
    function Get_MaxValue: Double;
    procedure Set_MaxValue(Value: Double);
    function Get_MinValue: Double;
    procedure Set_MinValue(Value: Double);
    function Get_Decimal: Integer;
    procedure Set_Decimal(Value: Integer);
    function Get_iType: LegType;
    function Get_FlagVal: Single;
    procedure Set_FlagVal(Value: Single);
    function Get_FlagDef: WideString;
    procedure Set_FlagDef(const Value: WideString);
    function Get_RefSys: WideString;
    procedure Set_RefSys(const Value: WideString);
    function Get_UnitDist: Double;
    procedure Set_UnitDist(Value: Double);
    function Get_RefUnits: WideString;
    procedure Set_RefUnits(const Value: WideString);
    function Get_ValUnits: WideString;
    procedure Set_ValUnits(const Value: WideString);
    function Get_Process: IUnknown;
    procedure Set_Process(const Value: IUnknown);
    function Get__className(X: Integer): WideString;
    procedure Set__className(X: Integer; const Value: WideString);
    function Get_Disabled(LegendNumber: Integer): WordBool;
    procedure Set_Disabled(LegendNumber: Integer; Value: WordBool);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IiContLeg);
    procedure Disconnect; override;
    procedure Draw(Left: Integer; Top: Integer; PictureHandle: Integer);
    procedure Copy;
    procedure SetAutoSize;
    procedure SaveAsJPEG;
    procedure Add(const ClassName: WideString);
    procedure Clear;
    function StreamAs(StreamType: iStreamType): OleVariant;
    procedure Refresh;
    procedure AssignObject(const Source: iLegend);
    property DefaultInterface: IiContLeg read GetDefaultInterface;
    property Count: Integer read Get_Count;
    property iType: LegType read Get_iType;
    property Process: IUnknown read Get_Process write Set_Process;
    property _className[X: Integer]: WideString read Get__className write Set__className;
    property Disabled[LegendNumber: Integer]: WordBool read Get_Disabled write Set_Disabled;
    property Width: Integer read Get_Width write Set_Width;
    property Height: Integer read Get_Height write Set_Height;
    property Palette: iPal read Get_Palette write Set_Palette;
    property Font: iFont read Get_Font write Set_Font;
    property Horizontal: WordBool read Get_Horizontal write Set_Horizontal;
    property BackColor: Integer read Get_BackColor write Set_BackColor;
    property BorderColor: Integer read Get_BorderColor write Set_BorderColor;
    property TextPosition: iTextPosition read Get_TextPosition write Set_TextPosition;
    property MaxValue: Double read Get_MaxValue write Set_MaxValue;
    property MinValue: Double read Get_MinValue write Set_MinValue;
    property Decimal: Integer read Get_Decimal write Set_Decimal;
    property FlagVal: Single read Get_FlagVal write Set_FlagVal;
    property FlagDef: WideString read Get_FlagDef write Set_FlagDef;
    property RefSys: WideString read Get_RefSys write Set_RefSys;
    property UnitDist: Double read Get_UnitDist write Set_UnitDist;
    property RefUnits: WideString read Get_RefUnits write Set_RefUnits;
    property ValUnits: WideString read Get_ValUnits write Set_ValUnits;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TiContLegProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TiContLeg
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TiContLegProperties = class(TPersistent)
  private
    FServer:    TiContLeg;
    function    GetDefaultInterface: IiContLeg;
    constructor Create(AServer: TiContLeg);
  protected
    function Get_Width: Integer;
    procedure Set_Width(Value: Integer);
    function Get_Height: Integer;
    procedure Set_Height(Value: Integer);
    function Get_Palette: iPal;
    procedure Set_Palette(const Value: iPal);
    function Get_Count: Integer;
    function Get_Font: iFont;
    procedure Set_Font(const Value: iFont);
    function Get_Horizontal: WordBool;
    procedure Set_Horizontal(Value: WordBool);
    function Get_BackColor: Integer;
    procedure Set_BackColor(Value: Integer);
    function Get_BorderColor: Integer;
    procedure Set_BorderColor(Value: Integer);
    function Get_TextPosition: iTextPosition;
    procedure Set_TextPosition(Value: iTextPosition);
    function Get_MaxValue: Double;
    procedure Set_MaxValue(Value: Double);
    function Get_MinValue: Double;
    procedure Set_MinValue(Value: Double);
    function Get_Decimal: Integer;
    procedure Set_Decimal(Value: Integer);
    function Get_iType: LegType;
    function Get_FlagVal: Single;
    procedure Set_FlagVal(Value: Single);
    function Get_FlagDef: WideString;
    procedure Set_FlagDef(const Value: WideString);
    function Get_RefSys: WideString;
    procedure Set_RefSys(const Value: WideString);
    function Get_UnitDist: Double;
    procedure Set_UnitDist(Value: Double);
    function Get_RefUnits: WideString;
    procedure Set_RefUnits(const Value: WideString);
    function Get_ValUnits: WideString;
    procedure Set_ValUnits(const Value: WideString);
    function Get_Process: IUnknown;
    procedure Set_Process(const Value: IUnknown);
    function Get__className(X: Integer): WideString;
    procedure Set__className(X: Integer; const Value: WideString);
    function Get_Disabled(LegendNumber: Integer): WordBool;
    procedure Set_Disabled(LegendNumber: Integer; Value: WordBool);
  public
    property DefaultInterface: IiContLeg read GetDefaultInterface;
  published
    property Width: Integer read Get_Width write Set_Width;
    property Height: Integer read Get_Height write Set_Height;
    property Palette: iPal read Get_Palette write Set_Palette;
    property Font: iFont read Get_Font write Set_Font;
    property Horizontal: WordBool read Get_Horizontal write Set_Horizontal;
    property BackColor: Integer read Get_BackColor write Set_BackColor;
    property BorderColor: Integer read Get_BorderColor write Set_BorderColor;
    property TextPosition: iTextPosition read Get_TextPosition write Set_TextPosition;
    property MaxValue: Double read Get_MaxValue write Set_MaxValue;
    property MinValue: Double read Get_MinValue write Set_MinValue;
    property Decimal: Integer read Get_Decimal write Set_Decimal;
    property FlagVal: Single read Get_FlagVal write Set_FlagVal;
    property FlagDef: WideString read Get_FlagDef write Set_FlagDef;
    property RefSys: WideString read Get_RefSys write Set_RefSys;
    property UnitDist: Double read Get_UnitDist write Set_UnitDist;
    property RefUnits: WideString read Get_RefUnits write Set_RefUnits;
    property ValUnits: WideString read Get_ValUnits write Set_ValUnits;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoiVal provides a Create and CreateRemote method to          
// create instances of the default interface IiVal exposed by              
// the CoClass iVal. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoiVal = class
    class function Create: IiVal;
    class function CreateRemote(const MachineName: string): IiVal;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TiVal
// Help String      : iVal Object
// Default Interface: IiVal
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TiValProperties= class;
{$ENDIF}
  TiVal = class(TOleServer)
  private
    FIntf:        IiVal;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TiValProperties;
    function      GetServerProperties: TiValProperties;
{$ENDIF}
    function      GetDefaultInterface: IiVal;
  protected
    procedure InitServerData; override;
    function Get_CheckStatus: Byte;
    procedure Set_CheckStatus(Value: Byte);
    function Get_Empty: WordBool;
    procedure Set_Empty(Value: WordBool);
    function Get_Changed: WordBool;
    procedure Set_Changed(Value: WordBool);
    function Get_Error: WideString;
    function Get_ObjectName: WideString;
    function Get_Process: IUnknown;
    procedure Set_Process(const Value: IUnknown);
    function Get_DataHandle: Integer;
    function Get_Status: WideString;
    function Get_Processing: WordBool;
    function Get_PercentDone: Byte;
    function Get_RecordCount: Integer;
    function Get_FeatureType(FeatureIndex: OleVariant): iFeatureType;
    procedure Set_FeatureType(FeatureIndex: OleVariant; Value: iFeatureType);
    function Get_FeatureCount: Integer;
    function Get_FeatureData(FieldNumber: OleVariant): OleVariant;
    procedure Set_FeatureData(FieldNumber: OleVariant; Value: OleVariant);
    function Get_Document: iFile;
    procedure Set_Document(const Value: iFile);
    function Get_Legend(FeatureIndex: OleVariant): iLegend;
    procedure Set_Legend(FeatureIndex: OleVariant; const Value: iLegend);
    function Get_ActiveFeature: Integer;
    procedure Set_ActiveFeature(Value: Integer);
    function Get_IDData: OleVariant;
    procedure Set_IDData(Value: OleVariant);
    function Get_FeatureName(Index_: Integer): WideString;
    function Get_RecordData(RecordIndex: Integer; FeatureIndex: OleVariant): OleVariant;
    procedure Set_RecordData(RecordIndex: Integer; FeatureIndex: OleVariant; Value: OleVariant);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IiVal);
    procedure Disconnect; override;
    function ArrayOfVar(SourceArray: OleVariant): OleVariant;
    procedure AssignObject(const Source: iData);
    function Open(ReadOnly: WordBool): WordBool;
    procedure Save;
    function OpenHeader: WordBool;
    procedure SaveHeader;
    procedure AddFeature(DataFeature: OleVariant; FeatureType: iFeatureType; const Name: WideString);
    procedure Clear;
    function IsFeatureDifValuesMoreThan(FeatureIndex: Integer; Value: Integer): WordBool;
    procedure AddRecord(RecordPosition: Integer);
    procedure Delete(RecordNumber: Integer);
    property DefaultInterface: IiVal read GetDefaultInterface;
    property CheckStatus: Byte read Get_CheckStatus write Set_CheckStatus;
    property Changed: WordBool read Get_Changed write Set_Changed;
    property Error: WideString read Get_Error;
    property ObjectName: WideString read Get_ObjectName;
    property Process: IUnknown read Get_Process write Set_Process;
    property DataHandle: Integer read Get_DataHandle;
    property Status: WideString read Get_Status;
    property Processing: WordBool read Get_Processing;
    property PercentDone: Byte read Get_PercentDone;
    property RecordCount: Integer read Get_RecordCount;
    property FeatureType[FeatureIndex: OleVariant]: iFeatureType read Get_FeatureType write Set_FeatureType;
    property FeatureCount: Integer read Get_FeatureCount;
    property FeatureData[FieldNumber: OleVariant]: OleVariant read Get_FeatureData write Set_FeatureData;
    property Legend[FeatureIndex: OleVariant]: iLegend read Get_Legend write Set_Legend;
    property IDData: OleVariant read Get_IDData write Set_IDData;
    property FeatureName[Index_: Integer]: WideString read Get_FeatureName;
    property RecordData[RecordIndex: Integer; FeatureIndex: OleVariant]: OleVariant read Get_RecordData write Set_RecordData;
    property Empty: WordBool read Get_Empty write Set_Empty;
    property Document: iFile read Get_Document write Set_Document;
    property ActiveFeature: Integer read Get_ActiveFeature write Set_ActiveFeature;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TiValProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TiVal
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TiValProperties = class(TPersistent)
  private
    FServer:    TiVal;
    function    GetDefaultInterface: IiVal;
    constructor Create(AServer: TiVal);
  protected
    function Get_CheckStatus: Byte;
    procedure Set_CheckStatus(Value: Byte);
    function Get_Empty: WordBool;
    procedure Set_Empty(Value: WordBool);
    function Get_Changed: WordBool;
    procedure Set_Changed(Value: WordBool);
    function Get_Error: WideString;
    function Get_ObjectName: WideString;
    function Get_Process: IUnknown;
    procedure Set_Process(const Value: IUnknown);
    function Get_DataHandle: Integer;
    function Get_Status: WideString;
    function Get_Processing: WordBool;
    function Get_PercentDone: Byte;
    function Get_RecordCount: Integer;
    function Get_FeatureType(FeatureIndex: OleVariant): iFeatureType;
    procedure Set_FeatureType(FeatureIndex: OleVariant; Value: iFeatureType);
    function Get_FeatureCount: Integer;
    function Get_FeatureData(FieldNumber: OleVariant): OleVariant;
    procedure Set_FeatureData(FieldNumber: OleVariant; Value: OleVariant);
    function Get_Document: iFile;
    procedure Set_Document(const Value: iFile);
    function Get_Legend(FeatureIndex: OleVariant): iLegend;
    procedure Set_Legend(FeatureIndex: OleVariant; const Value: iLegend);
    function Get_ActiveFeature: Integer;
    procedure Set_ActiveFeature(Value: Integer);
    function Get_IDData: OleVariant;
    procedure Set_IDData(Value: OleVariant);
    function Get_FeatureName(Index_: Integer): WideString;
    function Get_RecordData(RecordIndex: Integer; FeatureIndex: OleVariant): OleVariant;
    procedure Set_RecordData(RecordIndex: Integer; FeatureIndex: OleVariant; Value: OleVariant);
  public
    property DefaultInterface: IiVal read GetDefaultInterface;
  published
    property Empty: WordBool read Get_Empty write Set_Empty;
    property Document: iFile read Get_Document write Set_Document;
    property ActiveFeature: Integer read Get_ActiveFeature write Set_ActiveFeature;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoiShp provides a Create and CreateRemote method to          
// create instances of the default interface IiShp exposed by              
// the CoClass iShp. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoiShp = class
    class function Create: IiShp;
    class function CreateRemote(const MachineName: string): IiShp;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TiShp
// Help String      : Vectorial Object for Shape Files (ArcView/ESRI)
// Default Interface: IiShp
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TiShpProperties= class;
{$ENDIF}
  TiShp = class(TOleServer)
  private
    FIntf:        IiShp;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TiShpProperties;
    function      GetServerProperties: TiShpProperties;
{$ENDIF}
    function      GetDefaultInterface: IiShp;
  protected
    procedure InitServerData; override;
    function Get_CheckStatus: Byte;
    procedure Set_CheckStatus(Value: Byte);
    function Get_Empty: WordBool;
    procedure Set_Empty(Value: WordBool);
    function Get_Changed: WordBool;
    procedure Set_Changed(Value: WordBool);
    function Get_Error: WideString;
    function Get_ObjectName: WideString;
    function Get_Process: IUnknown;
    procedure Set_Process(const Value: IUnknown);
    function Get_DataHandle: Integer;
    function Get_Status: WideString;
    function Get_Processing: WordBool;
    function Get_PercentDone: Byte;
    function Get_Title: WideString;
    procedure Set_Title(const Value: WideString);
    function Get_Legend: iLegend;
    procedure Set_Legend(const Value: iLegend);
    function Get_hDC: Integer;
    function Get_MinX: Double;
    procedure Set_MinX(Value: Double);
    function Get_MaxX: Double;
    procedure Set_MaxX(Value: Double);
    function Get_MinY: Double;
    procedure Set_MinY(Value: Double);
    function Get_MaxY: Double;
    procedure Set_MaxY(Value: Double);
    function Get_Document: iFile;
    procedure Set_Document(const Value: iFile);
    function Get_Comment: iStringList;
    procedure Set_Comment(const Value: iStringList);
    function Get_Lineage: iStringList;
    procedure Set_Lineage(const Value: iStringList);
    function Get_Completeness: iStringList;
    procedure Set_Completeness(const Value: iStringList);
    function Get_Consistency: iStringList;
    procedure Set_Consistency(const Value: iStringList);
    function Get_PartialScene: WordBool;
    function Get_ImageWidth: Integer;
    procedure Set_ImageWidth(Value: Integer);
    function Get_ImageHeight: Integer;
    procedure Set_ImageHeight(Value: Integer);
    function Get_PointXY(X: OleVariant; Y: OleVariant): OleVariant;
    procedure Set_PointXY(X: OleVariant; Y: OleVariant; Value: OleVariant);
    function Get_Count: Integer;
    function Get_Value(RecordNumber: Integer): OleVariant;
    procedure Set_Value(RecordNumber: Integer; Value: OleVariant);
    function Get_RecordPointCount(RecordNumber: Integer): Integer;
    procedure Set_RecordPointCount(RecordNumber: Integer; Value: Integer);
    function Get_FileType: iShapeType;
    function Get_IdType: iDataTypeConst;
    function Get_MaxSize: Integer;
    procedure Set_MaxSize(Value: Integer);
    function Get_Val: iVal;
    procedure Set_Val(const Value: iVal);
    function Get_RecordColor(RecordNumber: Integer): Integer;
    function Get_Paint: iPaint;
    procedure Set_Paint(const Value: iPaint);
    function Get_DrawLabels: WordBool;
    procedure Set_DrawLabels(Value: WordBool);
    function Get_RecordBox(RecordNumber: Integer; Position: Integer): OleVariant;
    function Get_DisabledRecord(RecordNumber: Integer): WordBool;
    procedure Set_DisabledRecord(RecordNumber: Integer; Value: WordBool);
    function Get_Color(RecordNumber: Integer): WideString;
    procedure Set_Color(RecordNumber: Integer; const Value: WideString);
    function Get_Selected(RecordNumber: Integer): WordBool;
    procedure Set_Selected(RecordNumber: Integer; Value: WordBool);
    procedure Set_SelectAll(Param1: WordBool);
    function Get_LabelColor(RecordNumber: Integer): WideString;
    procedure Set_LabelColor(RecordNumber: Integer; const Value: WideString);
    function Get_LabelStyle(RecordNumber: Integer): WideString;
    procedure Set_LabelStyle(RecordNumber: Integer; const Value: WideString);
    function Get_LabelSize(RecordNumber: Integer): Smallint;
    procedure Set_LabelSize(RecordNumber: Integer; Value: Smallint);
    function Get_LabelFontName(RecordNumber: Integer): WideString;
    procedure Set_LabelFontName(RecordNumber: Integer; const Value: WideString);
    function Get_PenColor(RecordNumber: Integer): WideString;
    procedure Set_PenColor(RecordNumber: Integer; const Value: WideString);
    function Get_Parts(RecordNumber: Integer; PartNumber: Integer): Integer;
    procedure Set_Parts(RecordNumber: Integer; PartNumber: Integer; Value: Integer);
    function Get_ZMin: Double;
    function Get_ZMax: Double;
    function Get_Mmin: Double;
    function Get_Mmax: Double;
    function Get_Version: Integer;
    function Get_FileCode: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IiShp);
    procedure Disconnect; override;
    function ArrayOfVar(SourceArray: OleVariant): OleVariant;
    procedure AssignObject(const Source: iData);
    procedure PasteGeoRefs(const PassVar: iGeoData);
    function Open: WordBool;
    procedure Save;
    function Terminate: WordBool;
    procedure SaveHeader;
    function OpenHeader: WordBool;
    function OpenWindow(X1: OleVariant; Y1: OleVariant; X2: OleVariant; Y2: OleVariant; 
                        Step: Smallint): WordBool;
    function OpenSample(Step: Smallint): WordBool;
    procedure PasteHDC(BitmapHDC: Integer; Width: Integer; Height: Integer);
    procedure Refresh;
    procedure ClearBitmap;
    function StreamMapAs(StreamType: iStreamType): OleVariant;
    procedure PaintPoint(X: OleVariant; Y: OleVariant; Radius: OleVariant; const Color: WideString);
    procedure PaintLine(X1: OleVariant; Y1: OleVariant; X2: OleVariant; Y2: OleVariant; 
                        Width: OleVariant; const Color: WideString);
    procedure PaintPolygon(Points: OleVariant; LineWidth: Integer; const Color: WideString; 
                           BrushStyle: iBrushStyle; IsGeographic: WordBool);
    procedure PaintText(X: OleVariant; Y: OleVariant; const Text: WideString; 
                        const FontName: WideString; Size: Integer; const Style: WideString; 
                        const Color: WideString);
    function StreamAs(StreamType: iStreamType): OleVariant;
    procedure Draw(Left: Integer; Top: Integer; Zoom: Single; PictureHandle: Integer);
    procedure DrawMap(Zoom: Single; PictureHandle: Integer);
    procedure CopyMap(Zoom: Single);
    procedure Copy;
    procedure StretchDraw(hDC: Integer; X1: Double; Y1: Double; X2: Double; Y2: Double; 
                          Left: Integer; Top: Integer; Right: Integer; Bottom: Integer);
    function GetDataBuffer(out DataOut: OleVariant): Integer;
    procedure SetDataBuffer(DataIn: OleVariant);
    function RetrieveBitmap(Source: OleVariant; TimeOut_Sec: Integer; X1: Integer; Y1: Integer; 
                            X2: Integer; Y2: Integer; Transparency: Byte): Integer;
    procedure DrawObject(hDC: Integer; RecordNumber: Integer; X: Integer; Y: Integer); overload;
    procedure DrawObject(hDC: Integer; RecordNumber: Integer; X: Integer; Y: Integer; 
                         Color: OleVariant); overload;
    procedure AddRecordPoints(ObjectData: OleVariant; Id: Single; RecordNumber: Integer);
    procedure New(const Name: WideString; ObjectsType: iShapeType; IdType: iDataTypeConst);
    function GetRecordBuffer(RecordNumber: Integer): OleVariant;
    function IndexOf(Value: OleVariant): OleVariant;
    function IsPointInPolygon(PolygonIndex: Integer; X: Single; Y: Single): WordBool;
    procedure Insert(ObjectData: OleVariant; Position: Integer; Id: Integer);
    procedure Exchange(Pos1: Integer; Pos2: Integer);
    procedure Delete(RecordNumber: Integer);
    procedure DrawSquare(hDC: Integer; X1: Double; Y1: Double; X2: Double; Y2: Double; X: Integer; 
                         Y: Integer; Color: Integer; Width: Integer);
    function GetRecordPoints(RecordNumber: Integer): OleVariant;
    function SelectString(const QueryString: WideString; AddToSelection: WordBool): WordBool;
    procedure SetRecordPoints(RecordNumber: Integer; Value: OleVariant);
    function GetDisabledRecords: OleVariant;
    procedure SetDisabledRecords(Value: OleVariant);
    function GetSelectedRecords: OleVariant;
    procedure SetSelectedRecords(Value: OleVariant);
    procedure AddRecordBuffer(ObjectData: OleVariant; Id: Single; Position: Integer);
    procedure DrawRecord(hDC: Integer; ObjectNumber: Integer; X: Integer; Y: Integer; 
                         Width: Integer; Height: Integer; const Color: WideString);
    procedure SetLabelProperties(const FontName: WideString; const FontStyle: WideString; 
                                 const FontColor: WideString; FontSize: Integer);
    property DefaultInterface: IiShp read GetDefaultInterface;
    property CheckStatus: Byte read Get_CheckStatus write Set_CheckStatus;
    property Changed: WordBool read Get_Changed write Set_Changed;
    property Error: WideString read Get_Error;
    property ObjectName: WideString read Get_ObjectName;
    property Process: IUnknown read Get_Process write Set_Process;
    property DataHandle: Integer read Get_DataHandle;
    property Status: WideString read Get_Status;
    property Processing: WordBool read Get_Processing;
    property PercentDone: Byte read Get_PercentDone;
    property hDC: Integer read Get_hDC;
    property PartialScene: WordBool read Get_PartialScene;
    property PointXY[X: OleVariant; Y: OleVariant]: OleVariant read Get_PointXY write Set_PointXY;
    property Count: Integer read Get_Count;
    property Value[RecordNumber: Integer]: OleVariant read Get_Value write Set_Value;
    property RecordPointCount[RecordNumber: Integer]: Integer read Get_RecordPointCount write Set_RecordPointCount;
    property FileType: iShapeType read Get_FileType;
    property IdType: iDataTypeConst read Get_IdType;
    property RecordColor[RecordNumber: Integer]: Integer read Get_RecordColor;
    property RecordBox[RecordNumber: Integer; Position: Integer]: OleVariant read Get_RecordBox;
    property DisabledRecord[RecordNumber: Integer]: WordBool read Get_DisabledRecord write Set_DisabledRecord;
    property Color[RecordNumber: Integer]: WideString read Get_Color write Set_Color;
    property Selected[RecordNumber: Integer]: WordBool read Get_Selected write Set_Selected;
    property SelectAll: WordBool write Set_SelectAll;
    property LabelColor[RecordNumber: Integer]: WideString read Get_LabelColor write Set_LabelColor;
    property LabelStyle[RecordNumber: Integer]: WideString read Get_LabelStyle write Set_LabelStyle;
    property LabelSize[RecordNumber: Integer]: Smallint read Get_LabelSize write Set_LabelSize;
    property LabelFontName[RecordNumber: Integer]: WideString read Get_LabelFontName write Set_LabelFontName;
    property PenColor[RecordNumber: Integer]: WideString read Get_PenColor write Set_PenColor;
    property Parts[RecordNumber: Integer; PartNumber: Integer]: Integer read Get_Parts write Set_Parts;
    property ZMin: Double read Get_ZMin;
    property ZMax: Double read Get_ZMax;
    property Mmin: Double read Get_Mmin;
    property Mmax: Double read Get_Mmax;
    property Version: Integer read Get_Version;
    property FileCode: Integer read Get_FileCode;
    property Empty: WordBool read Get_Empty write Set_Empty;
    property Title: WideString read Get_Title write Set_Title;
    property Legend: iLegend read Get_Legend write Set_Legend;
    property MinX: Double read Get_MinX write Set_MinX;
    property MaxX: Double read Get_MaxX write Set_MaxX;
    property MinY: Double read Get_MinY write Set_MinY;
    property MaxY: Double read Get_MaxY write Set_MaxY;
    property Document: iFile read Get_Document write Set_Document;
    property Comment: iStringList read Get_Comment write Set_Comment;
    property Lineage: iStringList read Get_Lineage write Set_Lineage;
    property Completeness: iStringList read Get_Completeness write Set_Completeness;
    property Consistency: iStringList read Get_Consistency write Set_Consistency;
    property ImageWidth: Integer read Get_ImageWidth write Set_ImageWidth;
    property ImageHeight: Integer read Get_ImageHeight write Set_ImageHeight;
    property MaxSize: Integer read Get_MaxSize write Set_MaxSize;
    property Val: iVal read Get_Val write Set_Val;
    property Paint: iPaint read Get_Paint write Set_Paint;
    property DrawLabels: WordBool read Get_DrawLabels write Set_DrawLabels;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TiShpProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TiShp
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TiShpProperties = class(TPersistent)
  private
    FServer:    TiShp;
    function    GetDefaultInterface: IiShp;
    constructor Create(AServer: TiShp);
  protected
    function Get_CheckStatus: Byte;
    procedure Set_CheckStatus(Value: Byte);
    function Get_Empty: WordBool;
    procedure Set_Empty(Value: WordBool);
    function Get_Changed: WordBool;
    procedure Set_Changed(Value: WordBool);
    function Get_Error: WideString;
    function Get_ObjectName: WideString;
    function Get_Process: IUnknown;
    procedure Set_Process(const Value: IUnknown);
    function Get_DataHandle: Integer;
    function Get_Status: WideString;
    function Get_Processing: WordBool;
    function Get_PercentDone: Byte;
    function Get_Title: WideString;
    procedure Set_Title(const Value: WideString);
    function Get_Legend: iLegend;
    procedure Set_Legend(const Value: iLegend);
    function Get_hDC: Integer;
    function Get_MinX: Double;
    procedure Set_MinX(Value: Double);
    function Get_MaxX: Double;
    procedure Set_MaxX(Value: Double);
    function Get_MinY: Double;
    procedure Set_MinY(Value: Double);
    function Get_MaxY: Double;
    procedure Set_MaxY(Value: Double);
    function Get_Document: iFile;
    procedure Set_Document(const Value: iFile);
    function Get_Comment: iStringList;
    procedure Set_Comment(const Value: iStringList);
    function Get_Lineage: iStringList;
    procedure Set_Lineage(const Value: iStringList);
    function Get_Completeness: iStringList;
    procedure Set_Completeness(const Value: iStringList);
    function Get_Consistency: iStringList;
    procedure Set_Consistency(const Value: iStringList);
    function Get_PartialScene: WordBool;
    function Get_ImageWidth: Integer;
    procedure Set_ImageWidth(Value: Integer);
    function Get_ImageHeight: Integer;
    procedure Set_ImageHeight(Value: Integer);
    function Get_PointXY(X: OleVariant; Y: OleVariant): OleVariant;
    procedure Set_PointXY(X: OleVariant; Y: OleVariant; Value: OleVariant);
    function Get_Count: Integer;
    function Get_Value(RecordNumber: Integer): OleVariant;
    procedure Set_Value(RecordNumber: Integer; Value: OleVariant);
    function Get_RecordPointCount(RecordNumber: Integer): Integer;
    procedure Set_RecordPointCount(RecordNumber: Integer; Value: Integer);
    function Get_FileType: iShapeType;
    function Get_IdType: iDataTypeConst;
    function Get_MaxSize: Integer;
    procedure Set_MaxSize(Value: Integer);
    function Get_Val: iVal;
    procedure Set_Val(const Value: iVal);
    function Get_RecordColor(RecordNumber: Integer): Integer;
    function Get_Paint: iPaint;
    procedure Set_Paint(const Value: iPaint);
    function Get_DrawLabels: WordBool;
    procedure Set_DrawLabels(Value: WordBool);
    function Get_RecordBox(RecordNumber: Integer; Position: Integer): OleVariant;
    function Get_DisabledRecord(RecordNumber: Integer): WordBool;
    procedure Set_DisabledRecord(RecordNumber: Integer; Value: WordBool);
    function Get_Color(RecordNumber: Integer): WideString;
    procedure Set_Color(RecordNumber: Integer; const Value: WideString);
    function Get_Selected(RecordNumber: Integer): WordBool;
    procedure Set_Selected(RecordNumber: Integer; Value: WordBool);
    procedure Set_SelectAll(Param1: WordBool);
    function Get_LabelColor(RecordNumber: Integer): WideString;
    procedure Set_LabelColor(RecordNumber: Integer; const Value: WideString);
    function Get_LabelStyle(RecordNumber: Integer): WideString;
    procedure Set_LabelStyle(RecordNumber: Integer; const Value: WideString);
    function Get_LabelSize(RecordNumber: Integer): Smallint;
    procedure Set_LabelSize(RecordNumber: Integer; Value: Smallint);
    function Get_LabelFontName(RecordNumber: Integer): WideString;
    procedure Set_LabelFontName(RecordNumber: Integer; const Value: WideString);
    function Get_PenColor(RecordNumber: Integer): WideString;
    procedure Set_PenColor(RecordNumber: Integer; const Value: WideString);
    function Get_Parts(RecordNumber: Integer; PartNumber: Integer): Integer;
    procedure Set_Parts(RecordNumber: Integer; PartNumber: Integer; Value: Integer);
    function Get_ZMin: Double;
    function Get_ZMax: Double;
    function Get_Mmin: Double;
    function Get_Mmax: Double;
    function Get_Version: Integer;
    function Get_FileCode: Integer;
  public
    property DefaultInterface: IiShp read GetDefaultInterface;
  published
    property Empty: WordBool read Get_Empty write Set_Empty;
    property Title: WideString read Get_Title write Set_Title;
    property Legend: iLegend read Get_Legend write Set_Legend;
    property MinX: Double read Get_MinX write Set_MinX;
    property MaxX: Double read Get_MaxX write Set_MaxX;
    property MinY: Double read Get_MinY write Set_MinY;
    property MaxY: Double read Get_MaxY write Set_MaxY;
    property Document: iFile read Get_Document write Set_Document;
    property Comment: iStringList read Get_Comment write Set_Comment;
    property Lineage: iStringList read Get_Lineage write Set_Lineage;
    property Completeness: iStringList read Get_Completeness write Set_Completeness;
    property Consistency: iStringList read Get_Consistency write Set_Consistency;
    property ImageWidth: Integer read Get_ImageWidth write Set_ImageWidth;
    property ImageHeight: Integer read Get_ImageHeight write Set_ImageHeight;
    property MaxSize: Integer read Get_MaxSize write Set_MaxSize;
    property Val: iVal read Get_Val write Set_Val;
    property Paint: iPaint read Get_Paint write Set_Paint;
    property DrawLabels: WordBool read Get_DrawLabels write Set_DrawLabels;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoiIdrisiVal provides a Create and CreateRemote method to          
// create instances of the default interface IIiDRISIVal exposed by              
// the CoClass iIdrisiVal. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoiIdrisiVal = class
    class function Create: IIiDRISIVal;
    class function CreateRemote(const MachineName: string): IIiDRISIVal;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TiIdrisiVal
// Help String      : IDRISIVal Object
// Default Interface: IIiDRISIVal
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TiIdrisiValProperties= class;
{$ENDIF}
  TiIdrisiVal = class(TOleServer)
  private
    FIntf:        IIiDRISIVal;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TiIdrisiValProperties;
    function      GetServerProperties: TiIdrisiValProperties;
{$ENDIF}
    function      GetDefaultInterface: IIiDRISIVal;
  protected
    procedure InitServerData; override;
    function Get_CheckStatus: Byte;
    procedure Set_CheckStatus(Value: Byte);
    function Get_Empty: WordBool;
    procedure Set_Empty(Value: WordBool);
    function Get_Changed: WordBool;
    procedure Set_Changed(Value: WordBool);
    function Get_Error: WideString;
    function Get_ObjectName: WideString;
    function Get_Process: IUnknown;
    procedure Set_Process(const Value: IUnknown);
    function Get_DataHandle: Integer;
    function Get_Status: WideString;
    function Get_Processing: WordBool;
    function Get_PercentDone: Byte;
    function Get_RecordCount: Integer;
    function Get_FeatureType(FeatureIndex: OleVariant): iFeatureType;
    procedure Set_FeatureType(FeatureIndex: OleVariant; Value: iFeatureType);
    function Get_FeatureCount: Integer;
    function Get_FeatureData(FieldNumber: OleVariant): OleVariant;
    procedure Set_FeatureData(FieldNumber: OleVariant; Value: OleVariant);
    function Get_Document: iFile;
    procedure Set_Document(const Value: iFile);
    function Get_Legend(FeatureIndex: OleVariant): iLegend;
    procedure Set_Legend(FeatureIndex: OleVariant; const Value: iLegend);
    function Get_ActiveFeature: Integer;
    procedure Set_ActiveFeature(Value: Integer);
    function Get_IDData: OleVariant;
    procedure Set_IDData(Value: OleVariant);
    function Get_FeatureName(Index_: Integer): WideString;
    function Get_RecordData(RecordIndex: Integer; FeatureIndex: OleVariant): OleVariant;
    procedure Set_RecordData(RecordIndex: Integer; FeatureIndex: OleVariant; Value: OleVariant);
    function Get_Lineage: iStringList;
    procedure Set_Lineage(const Value: iStringList);
    function Get_Comment: iStringList;
    procedure Set_Comment(const Value: iStringList);
    function Get_Completeness: iStringList;
    procedure Set_Completeness(const Value: iStringList);
    function Get_Consistency: iStringList;
    procedure Set_Consistency(const Value: iStringList);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IIiDRISIVal);
    procedure Disconnect; override;
    function ArrayOfVar(SourceArray: OleVariant): OleVariant;
    procedure AssignObject(const Source: iData);
    function Open(ReadOnly: WordBool): WordBool;
    procedure Save;
    function OpenHeader: WordBool;
    procedure SaveHeader;
    procedure AddFeature(DataFeature: OleVariant; FeatureType: iFeatureType; const Name: WideString);
    procedure Clear;
    function IsFeatureDifValuesMoreThan(FeatureIndex: Integer; Value: Integer): WordBool;
    procedure AddRecord(RecordPosition: Integer);
    procedure Delete(RecordNumber: Integer);
    property DefaultInterface: IIiDRISIVal read GetDefaultInterface;
    property CheckStatus: Byte read Get_CheckStatus write Set_CheckStatus;
    property Changed: WordBool read Get_Changed write Set_Changed;
    property Error: WideString read Get_Error;
    property ObjectName: WideString read Get_ObjectName;
    property Process: IUnknown read Get_Process write Set_Process;
    property DataHandle: Integer read Get_DataHandle;
    property Status: WideString read Get_Status;
    property Processing: WordBool read Get_Processing;
    property PercentDone: Byte read Get_PercentDone;
    property RecordCount: Integer read Get_RecordCount;
    property FeatureType[FeatureIndex: OleVariant]: iFeatureType read Get_FeatureType write Set_FeatureType;
    property FeatureCount: Integer read Get_FeatureCount;
    property FeatureData[FieldNumber: OleVariant]: OleVariant read Get_FeatureData write Set_FeatureData;
    property Legend[FeatureIndex: OleVariant]: iLegend read Get_Legend write Set_Legend;
    property IDData: OleVariant read Get_IDData write Set_IDData;
    property FeatureName[Index_: Integer]: WideString read Get_FeatureName;
    property RecordData[RecordIndex: Integer; FeatureIndex: OleVariant]: OleVariant read Get_RecordData write Set_RecordData;
    property Empty: WordBool read Get_Empty write Set_Empty;
    property Document: iFile read Get_Document write Set_Document;
    property ActiveFeature: Integer read Get_ActiveFeature write Set_ActiveFeature;
    property Lineage: iStringList read Get_Lineage write Set_Lineage;
    property Comment: iStringList read Get_Comment write Set_Comment;
    property Completeness: iStringList read Get_Completeness write Set_Completeness;
    property Consistency: iStringList read Get_Consistency write Set_Consistency;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TiIdrisiValProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TiIdrisiVal
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TiIdrisiValProperties = class(TPersistent)
  private
    FServer:    TiIdrisiVal;
    function    GetDefaultInterface: IIiDRISIVal;
    constructor Create(AServer: TiIdrisiVal);
  protected
    function Get_CheckStatus: Byte;
    procedure Set_CheckStatus(Value: Byte);
    function Get_Empty: WordBool;
    procedure Set_Empty(Value: WordBool);
    function Get_Changed: WordBool;
    procedure Set_Changed(Value: WordBool);
    function Get_Error: WideString;
    function Get_ObjectName: WideString;
    function Get_Process: IUnknown;
    procedure Set_Process(const Value: IUnknown);
    function Get_DataHandle: Integer;
    function Get_Status: WideString;
    function Get_Processing: WordBool;
    function Get_PercentDone: Byte;
    function Get_RecordCount: Integer;
    function Get_FeatureType(FeatureIndex: OleVariant): iFeatureType;
    procedure Set_FeatureType(FeatureIndex: OleVariant; Value: iFeatureType);
    function Get_FeatureCount: Integer;
    function Get_FeatureData(FieldNumber: OleVariant): OleVariant;
    procedure Set_FeatureData(FieldNumber: OleVariant; Value: OleVariant);
    function Get_Document: iFile;
    procedure Set_Document(const Value: iFile);
    function Get_Legend(FeatureIndex: OleVariant): iLegend;
    procedure Set_Legend(FeatureIndex: OleVariant; const Value: iLegend);
    function Get_ActiveFeature: Integer;
    procedure Set_ActiveFeature(Value: Integer);
    function Get_IDData: OleVariant;
    procedure Set_IDData(Value: OleVariant);
    function Get_FeatureName(Index_: Integer): WideString;
    function Get_RecordData(RecordIndex: Integer; FeatureIndex: OleVariant): OleVariant;
    procedure Set_RecordData(RecordIndex: Integer; FeatureIndex: OleVariant; Value: OleVariant);
    function Get_Lineage: iStringList;
    procedure Set_Lineage(const Value: iStringList);
    function Get_Comment: iStringList;
    procedure Set_Comment(const Value: iStringList);
    function Get_Completeness: iStringList;
    procedure Set_Completeness(const Value: iStringList);
    function Get_Consistency: iStringList;
    procedure Set_Consistency(const Value: iStringList);
  public
    property DefaultInterface: IIiDRISIVal read GetDefaultInterface;
  published
    property Empty: WordBool read Get_Empty write Set_Empty;
    property Document: iFile read Get_Document write Set_Document;
    property ActiveFeature: Integer read Get_ActiveFeature write Set_ActiveFeature;
    property Lineage: iStringList read Get_Lineage write Set_Lineage;
    property Comment: iStringList read Get_Comment write Set_Comment;
    property Completeness: iStringList read Get_Completeness write Set_Completeness;
    property Consistency: iStringList read Get_Consistency write Set_Consistency;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoiDbf provides a Create and CreateRemote method to          
// create instances of the default interface IiDbf exposed by              
// the CoClass iDbf. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoiDbf = class
    class function Create: IiDbf;
    class function CreateRemote(const MachineName: string): IiDbf;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TiDbf
// Help String      : Database Object for DBF files (DBase)
// Default Interface: IiDbf
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TiDbfProperties= class;
{$ENDIF}
  TiDbf = class(TOleServer)
  private
    FIntf:        IiDbf;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TiDbfProperties;
    function      GetServerProperties: TiDbfProperties;
{$ENDIF}
    function      GetDefaultInterface: IiDbf;
  protected
    procedure InitServerData; override;
    function Get_CheckStatus: Byte;
    procedure Set_CheckStatus(Value: Byte);
    function Get_Empty: WordBool;
    procedure Set_Empty(Value: WordBool);
    function Get_Changed: WordBool;
    procedure Set_Changed(Value: WordBool);
    function Get_Error: WideString;
    function Get_ObjectName: WideString;
    function Get_Process: IUnknown;
    procedure Set_Process(const Value: IUnknown);
    function Get_DataHandle: Integer;
    function Get_Status: WideString;
    function Get_Processing: WordBool;
    function Get_PercentDone: Byte;
    function Get_RecordCount: Integer;
    function Get_FeatureType(FeatureIndex: OleVariant): iFeatureType;
    procedure Set_FeatureType(FeatureIndex: OleVariant; Value: iFeatureType);
    function Get_FeatureCount: Integer;
    function Get_FeatureData(FieldNumber: OleVariant): OleVariant;
    procedure Set_FeatureData(FieldNumber: OleVariant; Value: OleVariant);
    function Get_Document: iFile;
    procedure Set_Document(const Value: iFile);
    function Get_Legend(FeatureIndex: OleVariant): iLegend;
    procedure Set_Legend(FeatureIndex: OleVariant; const Value: iLegend);
    function Get_ActiveFeature: Integer;
    procedure Set_ActiveFeature(Value: Integer);
    function Get_IDData: OleVariant;
    procedure Set_IDData(Value: OleVariant);
    function Get_FeatureName(Index_: Integer): WideString;
    function Get_RecordData(RecordIndex: Integer; FeatureIndex: OleVariant): OleVariant;
    procedure Set_RecordData(RecordIndex: Integer; FeatureIndex: OleVariant; Value: OleVariant);
    procedure Set_RecordsToBeOpened(Param1: OleVariant);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IiDbf);
    procedure Disconnect; override;
    function ArrayOfVar(SourceArray: OleVariant): OleVariant;
    procedure AssignObject(const Source: iData);
    function Open(ReadOnly: WordBool): WordBool;
    procedure Save;
    function OpenHeader: WordBool;
    procedure SaveHeader;
    procedure AddFeature(DataFeature: OleVariant; FeatureType: iFeatureType; const Name: WideString);
    procedure Clear;
    function IsFeatureDifValuesMoreThan(FeatureIndex: Integer; Value: Integer): WordBool;
    procedure AddRecord(RecordPosition: Integer);
    procedure Delete(RecordNumber: Integer);
    property DefaultInterface: IiDbf read GetDefaultInterface;
    property CheckStatus: Byte read Get_CheckStatus write Set_CheckStatus;
    property Changed: WordBool read Get_Changed write Set_Changed;
    property Error: WideString read Get_Error;
    property ObjectName: WideString read Get_ObjectName;
    property Process: IUnknown read Get_Process write Set_Process;
    property DataHandle: Integer read Get_DataHandle;
    property Status: WideString read Get_Status;
    property Processing: WordBool read Get_Processing;
    property PercentDone: Byte read Get_PercentDone;
    property RecordCount: Integer read Get_RecordCount;
    property FeatureType[FeatureIndex: OleVariant]: iFeatureType read Get_FeatureType write Set_FeatureType;
    property FeatureCount: Integer read Get_FeatureCount;
    property FeatureData[FieldNumber: OleVariant]: OleVariant read Get_FeatureData write Set_FeatureData;
    property Legend[FeatureIndex: OleVariant]: iLegend read Get_Legend write Set_Legend;
    property IDData: OleVariant read Get_IDData write Set_IDData;
    property FeatureName[Index_: Integer]: WideString read Get_FeatureName;
    property RecordData[RecordIndex: Integer; FeatureIndex: OleVariant]: OleVariant read Get_RecordData write Set_RecordData;
    property RecordsToBeOpened: OleVariant write Set_RecordsToBeOpened;
    property Empty: WordBool read Get_Empty write Set_Empty;
    property Document: iFile read Get_Document write Set_Document;
    property ActiveFeature: Integer read Get_ActiveFeature write Set_ActiveFeature;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TiDbfProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TiDbf
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TiDbfProperties = class(TPersistent)
  private
    FServer:    TiDbf;
    function    GetDefaultInterface: IiDbf;
    constructor Create(AServer: TiDbf);
  protected
    function Get_CheckStatus: Byte;
    procedure Set_CheckStatus(Value: Byte);
    function Get_Empty: WordBool;
    procedure Set_Empty(Value: WordBool);
    function Get_Changed: WordBool;
    procedure Set_Changed(Value: WordBool);
    function Get_Error: WideString;
    function Get_ObjectName: WideString;
    function Get_Process: IUnknown;
    procedure Set_Process(const Value: IUnknown);
    function Get_DataHandle: Integer;
    function Get_Status: WideString;
    function Get_Processing: WordBool;
    function Get_PercentDone: Byte;
    function Get_RecordCount: Integer;
    function Get_FeatureType(FeatureIndex: OleVariant): iFeatureType;
    procedure Set_FeatureType(FeatureIndex: OleVariant; Value: iFeatureType);
    function Get_FeatureCount: Integer;
    function Get_FeatureData(FieldNumber: OleVariant): OleVariant;
    procedure Set_FeatureData(FieldNumber: OleVariant; Value: OleVariant);
    function Get_Document: iFile;
    procedure Set_Document(const Value: iFile);
    function Get_Legend(FeatureIndex: OleVariant): iLegend;
    procedure Set_Legend(FeatureIndex: OleVariant; const Value: iLegend);
    function Get_ActiveFeature: Integer;
    procedure Set_ActiveFeature(Value: Integer);
    function Get_IDData: OleVariant;
    procedure Set_IDData(Value: OleVariant);
    function Get_FeatureName(Index_: Integer): WideString;
    function Get_RecordData(RecordIndex: Integer; FeatureIndex: OleVariant): OleVariant;
    procedure Set_RecordData(RecordIndex: Integer; FeatureIndex: OleVariant; Value: OleVariant);
    procedure Set_RecordsToBeOpened(Param1: OleVariant);
  public
    property DefaultInterface: IiDbf read GetDefaultInterface;
  published
    property Empty: WordBool read Get_Empty write Set_Empty;
    property Document: iFile read Get_Document write Set_Document;
    property ActiveFeature: Integer read Get_ActiveFeature write Set_ActiveFeature;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoiPaint provides a Create and CreateRemote method to          
// create instances of the default interface IiPaint exposed by              
// the CoClass iPaint. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoiPaint = class
    class function Create: IiPaint;
    class function CreateRemote(const MachineName: string): IiPaint;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TiPaint
// Help String      : iPaint Object
// Default Interface: IiPaint
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TiPaintProperties= class;
{$ENDIF}
  TiPaint = class(TOleServer)
  private
    FIntf:        IiPaint;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TiPaintProperties;
    function      GetServerProperties: TiPaintProperties;
{$ENDIF}
    function      GetDefaultInterface: IiPaint;
  protected
    procedure InitServerData; override;
    function Get_BrushStyle: iBrushStyle;
    procedure Set_BrushStyle(Value: iBrushStyle);
    function Get_PenStyle: iPenStyle;
    procedure Set_PenStyle(Value: iPenStyle);
    function Get_PenWidth: Integer;
    procedure Set_PenWidth(Value: Integer);
    function Get_Changed: WordBool;
    procedure Set_Changed(Value: WordBool);
    function Get_PenColor: WideString;
    procedure Set_PenColor(const Value: WideString);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IiPaint);
    procedure Disconnect; override;
    property DefaultInterface: IiPaint read GetDefaultInterface;
    property BrushStyle: iBrushStyle read Get_BrushStyle write Set_BrushStyle;
    property PenStyle: iPenStyle read Get_PenStyle write Set_PenStyle;
    property PenWidth: Integer read Get_PenWidth write Set_PenWidth;
    property Changed: WordBool read Get_Changed write Set_Changed;
    property PenColor: WideString read Get_PenColor write Set_PenColor;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TiPaintProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TiPaint
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TiPaintProperties = class(TPersistent)
  private
    FServer:    TiPaint;
    function    GetDefaultInterface: IiPaint;
    constructor Create(AServer: TiPaint);
  protected
    function Get_BrushStyle: iBrushStyle;
    procedure Set_BrushStyle(Value: iBrushStyle);
    function Get_PenStyle: iPenStyle;
    procedure Set_PenStyle(Value: iPenStyle);
    function Get_PenWidth: Integer;
    procedure Set_PenWidth(Value: Integer);
    function Get_Changed: WordBool;
    procedure Set_Changed(Value: WordBool);
    function Get_PenColor: WideString;
    procedure Set_PenColor(const Value: WideString);
  public
    property DefaultInterface: IiPaint read GetDefaultInterface;
  published
    property BrushStyle: iBrushStyle read Get_BrushStyle write Set_BrushStyle;
    property PenStyle: iPenStyle read Get_PenStyle write Set_PenStyle;
    property PenWidth: Integer read Get_PenWidth write Set_PenWidth;
    property Changed: WordBool read Get_Changed write Set_Changed;
    property PenColor: WideString read Get_PenColor write Set_PenColor;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoiRst provides a Create and CreateRemote method to          
// create instances of the default interface IiRst exposed by              
// the CoClass iRst. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoiRst = class
    class function Create: IiRst;
    class function CreateRemote(const MachineName: string): IiRst;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TiRst
// Help String      : Raster Object for RST files (IDRISI32)
// Default Interface: IiRst
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TiRstProperties= class;
{$ENDIF}
  TiRst = class(TOleServer)
  private
    FIntf:        IiRst;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TiRstProperties;
    function      GetServerProperties: TiRstProperties;
{$ENDIF}
    function      GetDefaultInterface: IiRst;
  protected
    procedure InitServerData; override;
    function Get_CheckStatus: Byte;
    procedure Set_CheckStatus(Value: Byte);
    function Get_Empty: WordBool;
    procedure Set_Empty(Value: WordBool);
    function Get_Changed: WordBool;
    procedure Set_Changed(Value: WordBool);
    function Get_Error: WideString;
    function Get_ObjectName: WideString;
    function Get_Process: IUnknown;
    procedure Set_Process(const Value: IUnknown);
    function Get_DataHandle: Integer;
    function Get_Status: WideString;
    function Get_Processing: WordBool;
    function Get_PercentDone: Byte;
    function Get_Title: WideString;
    procedure Set_Title(const Value: WideString);
    function Get_Legend: iLegend;
    procedure Set_Legend(const Value: iLegend);
    function Get_hDC: Integer;
    function Get_MinX: Double;
    procedure Set_MinX(Value: Double);
    function Get_MaxX: Double;
    procedure Set_MaxX(Value: Double);
    function Get_MinY: Double;
    procedure Set_MinY(Value: Double);
    function Get_MaxY: Double;
    procedure Set_MaxY(Value: Double);
    function Get_Document: iFile;
    procedure Set_Document(const Value: iFile);
    function Get_Comment: iStringList;
    procedure Set_Comment(const Value: iStringList);
    function Get_Lineage: iStringList;
    procedure Set_Lineage(const Value: iStringList);
    function Get_Completeness: iStringList;
    procedure Set_Completeness(const Value: iStringList);
    function Get_Consistency: iStringList;
    procedure Set_Consistency(const Value: iStringList);
    function Get_PartialScene: WordBool;
    function Get_ImageWidth: Integer;
    procedure Set_ImageWidth(Value: Integer);
    function Get_ImageHeight: Integer;
    procedure Set_ImageHeight(Value: Integer);
    function Get_PointXY(X: OleVariant; Y: OleVariant): OleVariant;
    procedure Set_PointXY(X: OleVariant; Y: OleVariant; Value: OleVariant);
    function Get_Cols: Integer;
    function Get_Rows: Integer;
    function Get_Res: Double;
    procedure Set_Res(Value: Double);
    function Get_MaxValue: Double;
    procedure Set_MaxValue(Value: Double);
    function Get_MinValue: Double;
    procedure Set_MinValue(Value: Double);
    function Get_DataType: iDataTypeConst;
    procedure Set_DataType(Value: iDataTypeConst);
    function Get_ByteOrder: iByteOrder;
    function Get_ScanLineOrientation: iScanlineOrientType;
    procedure Set_ScanLineOrientation(Value: iScanlineOrientType);
    function Get_FileFormat: WideString;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IiRst);
    procedure Disconnect; override;
    function ArrayOfVar(SourceArray: OleVariant): OleVariant;
    procedure AssignObject(const Source: iData);
    procedure PasteGeoRefs(const PassVar: iGeoData);
    function Open: WordBool;
    procedure Save;
    function Terminate: WordBool;
    procedure SaveHeader;
    function OpenHeader: WordBool;
    function OpenWindow(X1: OleVariant; Y1: OleVariant; X2: OleVariant; Y2: OleVariant; 
                        Step: Smallint): WordBool;
    function OpenSample(Step: Smallint): WordBool;
    procedure PasteHDC(BitmapHDC: Integer; Width: Integer; Height: Integer);
    procedure Refresh;
    procedure ClearBitmap;
    function StreamMapAs(StreamType: iStreamType): OleVariant;
    procedure PaintPoint(X: OleVariant; Y: OleVariant; Radius: OleVariant; const Color: WideString);
    procedure PaintLine(X1: OleVariant; Y1: OleVariant; X2: OleVariant; Y2: OleVariant; 
                        Width: OleVariant; const Color: WideString);
    procedure PaintPolygon(Points: OleVariant; LineWidth: Integer; const Color: WideString; 
                           BrushStyle: iBrushStyle; IsGeographic: WordBool);
    procedure PaintText(X: OleVariant; Y: OleVariant; const Text: WideString; 
                        const FontName: WideString; Size: Integer; const Style: WideString; 
                        const Color: WideString);
    function StreamAs(StreamType: iStreamType): OleVariant;
    procedure Draw(Left: Integer; Top: Integer; Zoom: Single; PictureHandle: Integer);
    procedure DrawMap(Zoom: Single; PictureHandle: Integer);
    procedure CopyMap(Zoom: Single);
    procedure Copy;
    procedure StretchDraw(hDC: Integer; X1: Double; Y1: Double; X2: Double; Y2: Double; 
                          Left: Integer; Top: Integer; Right: Integer; Bottom: Integer);
    function GetDataBuffer(out DataOut: OleVariant): Integer;
    procedure SetDataBuffer(DataIn: OleVariant);
    function RetrieveBitmap(Source: OleVariant; TimeOut_Sec: Integer; X1: Integer; Y1: Integer; 
                            X2: Integer; Y2: Integer; Transparency: Byte): Integer;
    function Column(X1: Single): Integer;
    function Row(Y1: Single): Integer;
    function CoordX(PassVar: Integer): Single;
    function CoordY(PassVar: Integer): Single;
    procedure GetMaxMin;
    procedure Insert(const PassVar: iRaster);
    procedure SetDataYX(Matrix: OleVariant; X1: Integer; Y1: Integer; X2: Integer; Y2: Integer);
    function GetDataYX(X1: Integer; Y1: Integer; X2: Integer; Y2: Integer): OleVariant;
    procedure New(const NewName: WideString; NewDataType: iDataTypeConst; NewCols: Integer; 
                  NewRows: Integer; InitVal: Single);
    procedure SetData(Matrix: OleVariant; X1: Integer; Y1: Integer; X2: Integer; Y2: Integer);
    function GetData(X1: Integer; Y1: Integer; X2: Integer; Y2: Integer): OleVariant;
    function RetrieveURLData(const URLString: WideString; TimeOut_Sec: Integer; X1: Integer; 
                             Y1: Integer; X2: Integer; Y2: Integer): Integer;
    property DefaultInterface: IiRst read GetDefaultInterface;
    property CheckStatus: Byte read Get_CheckStatus write Set_CheckStatus;
    property Changed: WordBool read Get_Changed write Set_Changed;
    property Error: WideString read Get_Error;
    property ObjectName: WideString read Get_ObjectName;
    property Process: IUnknown read Get_Process write Set_Process;
    property DataHandle: Integer read Get_DataHandle;
    property Status: WideString read Get_Status;
    property Processing: WordBool read Get_Processing;
    property PercentDone: Byte read Get_PercentDone;
    property hDC: Integer read Get_hDC;
    property PartialScene: WordBool read Get_PartialScene;
    property PointXY[X: OleVariant; Y: OleVariant]: OleVariant read Get_PointXY write Set_PointXY;
    property Cols: Integer read Get_Cols;
    property Rows: Integer read Get_Rows;
    property ByteOrder: iByteOrder read Get_ByteOrder;
    property FileFormat: WideString read Get_FileFormat;
    property Empty: WordBool read Get_Empty write Set_Empty;
    property Title: WideString read Get_Title write Set_Title;
    property Legend: iLegend read Get_Legend write Set_Legend;
    property MinX: Double read Get_MinX write Set_MinX;
    property MaxX: Double read Get_MaxX write Set_MaxX;
    property MinY: Double read Get_MinY write Set_MinY;
    property MaxY: Double read Get_MaxY write Set_MaxY;
    property Document: iFile read Get_Document write Set_Document;
    property Comment: iStringList read Get_Comment write Set_Comment;
    property Lineage: iStringList read Get_Lineage write Set_Lineage;
    property Completeness: iStringList read Get_Completeness write Set_Completeness;
    property Consistency: iStringList read Get_Consistency write Set_Consistency;
    property ImageWidth: Integer read Get_ImageWidth write Set_ImageWidth;
    property ImageHeight: Integer read Get_ImageHeight write Set_ImageHeight;
    property Res: Double read Get_Res write Set_Res;
    property MaxValue: Double read Get_MaxValue write Set_MaxValue;
    property MinValue: Double read Get_MinValue write Set_MinValue;
    property DataType: iDataTypeConst read Get_DataType write Set_DataType;
    property ScanLineOrientation: iScanlineOrientType read Get_ScanLineOrientation write Set_ScanLineOrientation;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TiRstProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TiRst
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TiRstProperties = class(TPersistent)
  private
    FServer:    TiRst;
    function    GetDefaultInterface: IiRst;
    constructor Create(AServer: TiRst);
  protected
    function Get_CheckStatus: Byte;
    procedure Set_CheckStatus(Value: Byte);
    function Get_Empty: WordBool;
    procedure Set_Empty(Value: WordBool);
    function Get_Changed: WordBool;
    procedure Set_Changed(Value: WordBool);
    function Get_Error: WideString;
    function Get_ObjectName: WideString;
    function Get_Process: IUnknown;
    procedure Set_Process(const Value: IUnknown);
    function Get_DataHandle: Integer;
    function Get_Status: WideString;
    function Get_Processing: WordBool;
    function Get_PercentDone: Byte;
    function Get_Title: WideString;
    procedure Set_Title(const Value: WideString);
    function Get_Legend: iLegend;
    procedure Set_Legend(const Value: iLegend);
    function Get_hDC: Integer;
    function Get_MinX: Double;
    procedure Set_MinX(Value: Double);
    function Get_MaxX: Double;
    procedure Set_MaxX(Value: Double);
    function Get_MinY: Double;
    procedure Set_MinY(Value: Double);
    function Get_MaxY: Double;
    procedure Set_MaxY(Value: Double);
    function Get_Document: iFile;
    procedure Set_Document(const Value: iFile);
    function Get_Comment: iStringList;
    procedure Set_Comment(const Value: iStringList);
    function Get_Lineage: iStringList;
    procedure Set_Lineage(const Value: iStringList);
    function Get_Completeness: iStringList;
    procedure Set_Completeness(const Value: iStringList);
    function Get_Consistency: iStringList;
    procedure Set_Consistency(const Value: iStringList);
    function Get_PartialScene: WordBool;
    function Get_ImageWidth: Integer;
    procedure Set_ImageWidth(Value: Integer);
    function Get_ImageHeight: Integer;
    procedure Set_ImageHeight(Value: Integer);
    function Get_PointXY(X: OleVariant; Y: OleVariant): OleVariant;
    procedure Set_PointXY(X: OleVariant; Y: OleVariant; Value: OleVariant);
    function Get_Cols: Integer;
    function Get_Rows: Integer;
    function Get_Res: Double;
    procedure Set_Res(Value: Double);
    function Get_MaxValue: Double;
    procedure Set_MaxValue(Value: Double);
    function Get_MinValue: Double;
    procedure Set_MinValue(Value: Double);
    function Get_DataType: iDataTypeConst;
    procedure Set_DataType(Value: iDataTypeConst);
    function Get_ByteOrder: iByteOrder;
    function Get_ScanLineOrientation: iScanlineOrientType;
    procedure Set_ScanLineOrientation(Value: iScanlineOrientType);
    function Get_FileFormat: WideString;
  public
    property DefaultInterface: IiRst read GetDefaultInterface;
  published
    property Empty: WordBool read Get_Empty write Set_Empty;
    property Title: WideString read Get_Title write Set_Title;
    property Legend: iLegend read Get_Legend write Set_Legend;
    property MinX: Double read Get_MinX write Set_MinX;
    property MaxX: Double read Get_MaxX write Set_MaxX;
    property MinY: Double read Get_MinY write Set_MinY;
    property MaxY: Double read Get_MaxY write Set_MaxY;
    property Document: iFile read Get_Document write Set_Document;
    property Comment: iStringList read Get_Comment write Set_Comment;
    property Lineage: iStringList read Get_Lineage write Set_Lineage;
    property Completeness: iStringList read Get_Completeness write Set_Completeness;
    property Consistency: iStringList read Get_Consistency write Set_Consistency;
    property ImageWidth: Integer read Get_ImageWidth write Set_ImageWidth;
    property ImageHeight: Integer read Get_ImageHeight write Set_ImageHeight;
    property Res: Double read Get_Res write Set_Res;
    property MaxValue: Double read Get_MaxValue write Set_MaxValue;
    property MinValue: Double read Get_MinValue write Set_MinValue;
    property DataType: iDataTypeConst read Get_DataType write Set_DataType;
    property ScanLineOrientation: iScanlineOrientType read Get_ScanLineOrientation write Set_ScanLineOrientation;
  end;
{$ENDIF}


procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

  dtlOcxPage = 'ActiveX';

implementation

uses ComObj;

class function CoiFile.Create: IiFile;
begin
  Result := CreateComObject(CLASS_iFile) as IiFile;
end;

class function CoiFile.CreateRemote(const MachineName: string): IiFile;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_iFile) as IiFile;
end;

procedure TiFile.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{6C942563-A98E-11D3-A52B-0000E85E2CDE}';
    IntfIID:   '{6C942561-A98E-11D3-A52B-0000E85E2CDE}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TiFile.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IiFile;
  end;
end;

procedure TiFile.ConnectTo(svrIntf: IiFile);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TiFile.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TiFile.GetDefaultInterface: IiFile;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TiFile.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TiFileProperties.Create(Self);
{$ENDIF}
end;

destructor TiFile.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TiFile.GetServerProperties: TiFileProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TiFile.Get_Name: WideString;
begin
    Result := DefaultInterface.Name;
end;

procedure TiFile.Set_Name(const Value: WideString);
  { Warning: The property Name has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Name := Value;
end;

function TiFile.Get_Directory: WideString;
begin
    Result := DefaultInterface.Directory;
end;

procedure TiFile.Set_Directory(const Value: WideString);
  { Warning: The property Directory has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Directory := Value;
end;

function TiFile.Get_FileType: iFileTypeConst;
begin
    Result := DefaultInterface.FileType;
end;

procedure TiFile.Set_FileType(Value: iFileTypeConst);
begin
  DefaultInterface.Set_FileType(Value);
end;

function TiFile.Get_Empty: WordBool;
begin
    Result := DefaultInterface.Empty;
end;

procedure TiFile.Set_Empty(Value: WordBool);
begin
  DefaultInterface.Set_Empty(Value);
end;

function TiFile.Get_Extension: WideString;
begin
    Result := DefaultInterface.Extension;
end;

procedure TiFile.Set_Extension(const Value: WideString);
  { Warning: The property Extension has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Extension := Value;
end;

function TiFile.Get_HeaderExtension: WideString;
begin
    Result := DefaultInterface.HeaderExtension;
end;

procedure TiFile.Set_HeaderExtension(const Value: WideString);
  { Warning: The property HeaderExtension has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.HeaderExtension := Value;
end;

function TiFile.Get_Process: IUnknown;
begin
    Result := DefaultInterface.Process;
end;

procedure TiFile.Set_Process(const Value: IUnknown);
begin
  DefaultInterface.Set_Process(Value);
end;

function TiFile.Get_IndexFileExtension: WideString;
begin
    Result := DefaultInterface.IndexFileExtension;
end;

procedure TiFile.Set_IndexFileExtension(const Value: WideString);
  { Warning: The property IndexFileExtension has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.IndexFileExtension := Value;
end;

function TiFile.Get_ReadOnly: WordBool;
begin
    Result := DefaultInterface.ReadOnly;
end;

procedure TiFile.Set_ReadOnly(Value: WordBool);
begin
  DefaultInterface.Set_ReadOnly(Value);
end;

function TiFile.GetFileName: WideString;
begin
  Result := DefaultInterface.GetFileName;
end;

function TiFile.FileOpen: WordBool;
begin
  Result := DefaultInterface.FileOpen;
end;

function TiFile.FileClose: WordBool;
begin
  Result := DefaultInterface.FileClose;
end;

function TiFile.GetHeader(out DocText: OleVariant): Smallint;
begin
  Result := DefaultInterface.GetHeader(DocText);
end;

function TiFile.SetHeader(DocText: OleVariant): WordBool;
begin
  Result := DefaultInterface.SetHeader(DocText);
end;

function TiFile.GetFileSize: Integer;
begin
  Result := DefaultInterface.GetFileSize;
end;

function TiFile.FileSeek(Position: Integer): WordBool;
begin
  Result := DefaultInterface.FileSeek(Position);
end;

function TiFile.FileBlockRead(out Buf: OleVariant; Count: Integer): Integer;
begin
  Result := DefaultInterface.FileBlockRead(Buf, Count);
end;

function TiFile.FileBlockWrite(Buf: OleVariant): Integer;
begin
  Result := DefaultInterface.FileBlockWrite(Buf);
end;

procedure TiFile.FileRead;
begin
  DefaultInterface.FileRead;
end;

procedure TiFile.FileWrite;
begin
  DefaultInterface.FileWrite;
end;

procedure TiFile.FileNew;
begin
  DefaultInterface.FileNew;
end;

function TiFile.CheckFileExists: WordBool;
begin
  Result := DefaultInterface.CheckFileExists;
end;

function TiFile.FileBlockReadWithStep(out Buf: OleVariant; Count: Integer; Step: Integer; 
                                      DataType: iDataTypeConst): Integer;
begin
  Result := DefaultInterface.FileBlockReadWithStep(Buf, Count, Step, DataType);
end;

procedure TiFile.GetIndexFileExtension(out FileBuffer: OleVariant);
begin
  DefaultInterface.GetIndexFileExtension(FileBuffer);
end;

procedure TiFile.SetIndexFileExtension(FileBuffer: OleVariant);
begin
  DefaultInterface.SetIndexFileExtension(FileBuffer);
end;

procedure TiFile.AssignObject(const Source: iFile);
begin
  DefaultInterface.AssignObject(Source);
end;

function TiFile.CreateDirFileList: iStringList;
begin
  Result := DefaultInterface.CreateDirFileList;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TiFileProperties.Create(AServer: TiFile);
begin
  inherited Create;
  FServer := AServer;
end;

function TiFileProperties.GetDefaultInterface: IiFile;
begin
  Result := FServer.DefaultInterface;
end;

function TiFileProperties.Get_Name: WideString;
begin
    Result := DefaultInterface.Name;
end;

procedure TiFileProperties.Set_Name(const Value: WideString);
  { Warning: The property Name has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Name := Value;
end;

function TiFileProperties.Get_Directory: WideString;
begin
    Result := DefaultInterface.Directory;
end;

procedure TiFileProperties.Set_Directory(const Value: WideString);
  { Warning: The property Directory has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Directory := Value;
end;

function TiFileProperties.Get_FileType: iFileTypeConst;
begin
    Result := DefaultInterface.FileType;
end;

procedure TiFileProperties.Set_FileType(Value: iFileTypeConst);
begin
  DefaultInterface.Set_FileType(Value);
end;

function TiFileProperties.Get_Empty: WordBool;
begin
    Result := DefaultInterface.Empty;
end;

procedure TiFileProperties.Set_Empty(Value: WordBool);
begin
  DefaultInterface.Set_Empty(Value);
end;

function TiFileProperties.Get_Extension: WideString;
begin
    Result := DefaultInterface.Extension;
end;

procedure TiFileProperties.Set_Extension(const Value: WideString);
  { Warning: The property Extension has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Extension := Value;
end;

function TiFileProperties.Get_HeaderExtension: WideString;
begin
    Result := DefaultInterface.HeaderExtension;
end;

procedure TiFileProperties.Set_HeaderExtension(const Value: WideString);
  { Warning: The property HeaderExtension has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.HeaderExtension := Value;
end;

function TiFileProperties.Get_Process: IUnknown;
begin
    Result := DefaultInterface.Process;
end;

procedure TiFileProperties.Set_Process(const Value: IUnknown);
begin
  DefaultInterface.Set_Process(Value);
end;

function TiFileProperties.Get_IndexFileExtension: WideString;
begin
    Result := DefaultInterface.IndexFileExtension;
end;

procedure TiFileProperties.Set_IndexFileExtension(const Value: WideString);
  { Warning: The property IndexFileExtension has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.IndexFileExtension := Value;
end;

function TiFileProperties.Get_ReadOnly: WordBool;
begin
    Result := DefaultInterface.ReadOnly;
end;

procedure TiFileProperties.Set_ReadOnly(Value: WordBool);
begin
  DefaultInterface.Set_ReadOnly(Value);
end;

{$ENDIF}

class function CoiPal.Create: IiPal;
begin
  Result := CreateComObject(CLASS_iPal) as IiPal;
end;

class function CoiPal.CreateRemote(const MachineName: string): IiPal;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_iPal) as IiPal;
end;

procedure TiPal.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{6C942567-A98E-11D3-A52B-0000E85E2CDE}';
    IntfIID:   '{6C942565-A98E-11D3-A52B-0000E85E2CDE}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TiPal.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IiPal;
  end;
end;

procedure TiPal.ConnectTo(svrIntf: IiPal);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TiPal.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TiPal.GetDefaultInterface: IiPal;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TiPal.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TiPalProperties.Create(Self);
{$ENDIF}
end;

destructor TiPal.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TiPal.GetServerProperties: TiPalProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TiPal.Get_Name: iPalettes;
begin
    Result := DefaultInterface.Name;
end;

procedure TiPal.Set_Name(Value: iPalettes);
begin
  DefaultInterface.Set_Name(Value);
end;

function TiPal.Get_NumColors: Integer;
begin
    Result := DefaultInterface.NumColors;
end;

function TiPal.Get_Color(X: Integer): iColor;
begin
    Result := DefaultInterface.Color[X];
end;

procedure TiPal.Set_Color(X: Integer; const Value: iColor);
begin
  DefaultInterface.Color[X] := Value;
end;

function TiPal.Get_Document: iFile;
begin
    Result := DefaultInterface.Document;
end;

procedure TiPal.Set_Document(const Value: iFile);
begin
  DefaultInterface.Set_Document(Value);
end;

function TiPal.Get_Changed: WordBool;
begin
    Result := DefaultInterface.Changed;
end;

procedure TiPal.Set_Changed(Value: WordBool);
begin
  DefaultInterface.Set_Changed(Value);
end;

function TiPal.Get_ColorBuffer: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.ColorBuffer;
end;

procedure TiPal.Set_ColorBuffer(Value: OleVariant);
begin
  DefaultInterface.Set_ColorBuffer(Value);
end;

function TiPal.Get_Process: IUnknown;
begin
    Result := DefaultInterface.Process;
end;

procedure TiPal.Set_Process(const Value: IUnknown);
begin
  DefaultInterface.Set_Process(Value);
end;

procedure TiPal.AddColor(Red: Byte; Green: Byte; Blue: Byte);
begin
  DefaultInterface.AddColor(Red, Green, Blue);
end;

procedure TiPal.RemoveColor(ColorNumber: Integer);
begin
  DefaultInterface.RemoveColor(ColorNumber);
end;

function TiPal.Open: WordBool;
begin
  Result := DefaultInterface.Open;
end;

procedure TiPal.AssignObject(const Source: iPal);
begin
  DefaultInterface.AssignObject(Source);
end;

procedure TiPal.Invert;
begin
  DefaultInterface.Invert;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TiPalProperties.Create(AServer: TiPal);
begin
  inherited Create;
  FServer := AServer;
end;

function TiPalProperties.GetDefaultInterface: IiPal;
begin
  Result := FServer.DefaultInterface;
end;

function TiPalProperties.Get_Name: iPalettes;
begin
    Result := DefaultInterface.Name;
end;

procedure TiPalProperties.Set_Name(Value: iPalettes);
begin
  DefaultInterface.Set_Name(Value);
end;

function TiPalProperties.Get_NumColors: Integer;
begin
    Result := DefaultInterface.NumColors;
end;

function TiPalProperties.Get_Color(X: Integer): iColor;
begin
    Result := DefaultInterface.Color[X];
end;

procedure TiPalProperties.Set_Color(X: Integer; const Value: iColor);
begin
  DefaultInterface.Color[X] := Value;
end;

function TiPalProperties.Get_Document: iFile;
begin
    Result := DefaultInterface.Document;
end;

procedure TiPalProperties.Set_Document(const Value: iFile);
begin
  DefaultInterface.Set_Document(Value);
end;

function TiPalProperties.Get_Changed: WordBool;
begin
    Result := DefaultInterface.Changed;
end;

procedure TiPalProperties.Set_Changed(Value: WordBool);
begin
  DefaultInterface.Set_Changed(Value);
end;

function TiPalProperties.Get_ColorBuffer: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.ColorBuffer;
end;

procedure TiPalProperties.Set_ColorBuffer(Value: OleVariant);
begin
  DefaultInterface.Set_ColorBuffer(Value);
end;

function TiPalProperties.Get_Process: IUnknown;
begin
    Result := DefaultInterface.Process;
end;

procedure TiPalProperties.Set_Process(const Value: IUnknown);
begin
  DefaultInterface.Set_Process(Value);
end;

{$ENDIF}

class function CoiColor.Create: IiColor;
begin
  Result := CreateComObject(CLASS_iColor) as IiColor;
end;

class function CoiColor.CreateRemote(const MachineName: string): IiColor;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_iColor) as IiColor;
end;

procedure TiColor.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{6C94256B-A98E-11D3-A52B-0000E85E2CDE}';
    IntfIID:   '{6C942569-A98E-11D3-A52B-0000E85E2CDE}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TiColor.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IiColor;
  end;
end;

procedure TiColor.ConnectTo(svrIntf: IiColor);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TiColor.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TiColor.GetDefaultInterface: IiColor;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TiColor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TiColorProperties.Create(Self);
{$ENDIF}
end;

destructor TiColor.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TiColor.GetServerProperties: TiColorProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TiColor.Get_Red: Byte;
begin
    Result := DefaultInterface.Red;
end;

procedure TiColor.Set_Red(Red: Byte);
begin
  DefaultInterface.Set_Red(Red);
end;

function TiColor.Get_Green: Byte;
begin
    Result := DefaultInterface.Green;
end;

procedure TiColor.Set_Green(Green: Byte);
begin
  DefaultInterface.Set_Green(Green);
end;

function TiColor.Get_Blue: Byte;
begin
    Result := DefaultInterface.Blue;
end;

procedure TiColor.Set_Blue(Blue: Byte);
begin
  DefaultInterface.Set_Blue(Blue);
end;

function TiColor.Get_Process: IUnknown;
begin
    Result := DefaultInterface.Process;
end;

procedure TiColor.Set_Process(const Value: IUnknown);
begin
  DefaultInterface.Set_Process(Value);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TiColorProperties.Create(AServer: TiColor);
begin
  inherited Create;
  FServer := AServer;
end;

function TiColorProperties.GetDefaultInterface: IiColor;
begin
  Result := FServer.DefaultInterface;
end;

function TiColorProperties.Get_Red: Byte;
begin
    Result := DefaultInterface.Red;
end;

procedure TiColorProperties.Set_Red(Red: Byte);
begin
  DefaultInterface.Set_Red(Red);
end;

function TiColorProperties.Get_Green: Byte;
begin
    Result := DefaultInterface.Green;
end;

procedure TiColorProperties.Set_Green(Green: Byte);
begin
  DefaultInterface.Set_Green(Green);
end;

function TiColorProperties.Get_Blue: Byte;
begin
    Result := DefaultInterface.Blue;
end;

procedure TiColorProperties.Set_Blue(Blue: Byte);
begin
  DefaultInterface.Set_Blue(Blue);
end;

function TiColorProperties.Get_Process: IUnknown;
begin
    Result := DefaultInterface.Process;
end;

procedure TiColorProperties.Set_Process(const Value: IUnknown);
begin
  DefaultInterface.Set_Process(Value);
end;

{$ENDIF}

class function CoiFont.Create: IiFont;
begin
  Result := CreateComObject(CLASS_iFont) as IiFont;
end;

class function CoiFont.CreateRemote(const MachineName: string): IiFont;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_iFont) as IiFont;
end;

procedure TiFont.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{6C94256F-A98E-11D3-A52B-0000E85E2CDE}';
    IntfIID:   '{6C94256D-A98E-11D3-A52B-0000E85E2CDE}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TiFont.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IiFont;
  end;
end;

procedure TiFont.ConnectTo(svrIntf: IiFont);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TiFont.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TiFont.GetDefaultInterface: IiFont;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TiFont.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TiFontProperties.Create(Self);
{$ENDIF}
end;

destructor TiFont.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TiFont.GetServerProperties: TiFontProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TiFont.Get_Name: WideString;
begin
    Result := DefaultInterface.Name;
end;

procedure TiFont.Set_Name(const Name: WideString);
  { Warning: The property Name has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Name := Name;
end;

function TiFont.Get_Size: Integer;
begin
    Result := DefaultInterface.Size;
end;

procedure TiFont.Set_Size(Size: Integer);
begin
  DefaultInterface.Set_Size(Size);
end;

function TiFont.Get_Process: IUnknown;
begin
    Result := DefaultInterface.Process;
end;

procedure TiFont.Set_Process(const Value: IUnknown);
begin
  DefaultInterface.Set_Process(Value);
end;

procedure TiFont.AssignObject(const Source: iFont);
begin
  DefaultInterface.AssignObject(Source);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TiFontProperties.Create(AServer: TiFont);
begin
  inherited Create;
  FServer := AServer;
end;

function TiFontProperties.GetDefaultInterface: IiFont;
begin
  Result := FServer.DefaultInterface;
end;

function TiFontProperties.Get_Name: WideString;
begin
    Result := DefaultInterface.Name;
end;

procedure TiFontProperties.Set_Name(const Name: WideString);
  { Warning: The property Name has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Name := Name;
end;

function TiFontProperties.Get_Size: Integer;
begin
    Result := DefaultInterface.Size;
end;

procedure TiFontProperties.Set_Size(Size: Integer);
begin
  DefaultInterface.Set_Size(Size);
end;

function TiFontProperties.Get_Process: IUnknown;
begin
    Result := DefaultInterface.Process;
end;

procedure TiFontProperties.Set_Process(const Value: IUnknown);
begin
  DefaultInterface.Set_Process(Value);
end;

{$ENDIF}

class function CoiLegend.Create: IiLegend;
begin
  Result := CreateComObject(CLASS_iLegend) as IiLegend;
end;

class function CoiLegend.CreateRemote(const MachineName: string): IiLegend;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_iLegend) as IiLegend;
end;

procedure TiLegend.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{6C942573-A98E-11D3-A52B-0000E85E2CDE}';
    IntfIID:   '{6C942571-A98E-11D3-A52B-0000E85E2CDE}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TiLegend.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IiLegend;
  end;
end;

procedure TiLegend.ConnectTo(svrIntf: IiLegend);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TiLegend.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TiLegend.GetDefaultInterface: IiLegend;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TiLegend.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TiLegendProperties.Create(Self);
{$ENDIF}
end;

destructor TiLegend.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TiLegend.GetServerProperties: TiLegendProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TiLegend.Get_Width: Integer;
begin
    Result := DefaultInterface.Width;
end;

procedure TiLegend.Set_Width(Value: Integer);
begin
  DefaultInterface.Set_Width(Value);
end;

function TiLegend.Get_Height: Integer;
begin
    Result := DefaultInterface.Height;
end;

procedure TiLegend.Set_Height(Value: Integer);
begin
  DefaultInterface.Set_Height(Value);
end;

function TiLegend.Get_Palette: iPal;
begin
    Result := DefaultInterface.Palette;
end;

procedure TiLegend.Set_Palette(const Value: iPal);
begin
  DefaultInterface.Set_Palette(Value);
end;

function TiLegend.Get_Count: Integer;
begin
    Result := DefaultInterface.Count;
end;

function TiLegend.Get_Font: iFont;
begin
    Result := DefaultInterface.Font;
end;

procedure TiLegend.Set_Font(const Value: iFont);
begin
  DefaultInterface.Set_Font(Value);
end;

function TiLegend.Get_Horizontal: WordBool;
begin
    Result := DefaultInterface.Horizontal;
end;

procedure TiLegend.Set_Horizontal(Value: WordBool);
begin
  DefaultInterface.Set_Horizontal(Value);
end;

function TiLegend.Get_BackColor: Integer;
begin
    Result := DefaultInterface.BackColor;
end;

procedure TiLegend.Set_BackColor(Value: Integer);
begin
  DefaultInterface.Set_BackColor(Value);
end;

function TiLegend.Get_BorderColor: Integer;
begin
    Result := DefaultInterface.BorderColor;
end;

procedure TiLegend.Set_BorderColor(Value: Integer);
begin
  DefaultInterface.Set_BorderColor(Value);
end;

function TiLegend.Get_TextPosition: iTextPosition;
begin
    Result := DefaultInterface.TextPosition;
end;

procedure TiLegend.Set_TextPosition(Value: iTextPosition);
begin
  DefaultInterface.Set_TextPosition(Value);
end;

function TiLegend.Get_MaxValue: Double;
begin
    Result := DefaultInterface.MaxValue;
end;

procedure TiLegend.Set_MaxValue(Value: Double);
begin
  DefaultInterface.Set_MaxValue(Value);
end;

function TiLegend.Get_MinValue: Double;
begin
    Result := DefaultInterface.MinValue;
end;

procedure TiLegend.Set_MinValue(Value: Double);
begin
  DefaultInterface.Set_MinValue(Value);
end;

function TiLegend.Get_Decimal: Integer;
begin
    Result := DefaultInterface.Decimal;
end;

procedure TiLegend.Set_Decimal(Value: Integer);
begin
  DefaultInterface.Set_Decimal(Value);
end;

function TiLegend.Get_iType: LegType;
begin
    Result := DefaultInterface.iType;
end;

function TiLegend.Get_FlagVal: Single;
begin
    Result := DefaultInterface.FlagVal;
end;

procedure TiLegend.Set_FlagVal(Value: Single);
begin
  DefaultInterface.Set_FlagVal(Value);
end;

function TiLegend.Get_FlagDef: WideString;
begin
    Result := DefaultInterface.FlagDef;
end;

procedure TiLegend.Set_FlagDef(const Value: WideString);
  { Warning: The property FlagDef has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.FlagDef := Value;
end;

function TiLegend.Get_RefSys: WideString;
begin
    Result := DefaultInterface.RefSys;
end;

procedure TiLegend.Set_RefSys(const Value: WideString);
  { Warning: The property RefSys has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.RefSys := Value;
end;

function TiLegend.Get_UnitDist: Double;
begin
    Result := DefaultInterface.UnitDist;
end;

procedure TiLegend.Set_UnitDist(Value: Double);
begin
  DefaultInterface.Set_UnitDist(Value);
end;

function TiLegend.Get_RefUnits: WideString;
begin
    Result := DefaultInterface.RefUnits;
end;

procedure TiLegend.Set_RefUnits(const Value: WideString);
  { Warning: The property RefUnits has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.RefUnits := Value;
end;

function TiLegend.Get_ValUnits: WideString;
begin
    Result := DefaultInterface.ValUnits;
end;

procedure TiLegend.Set_ValUnits(const Value: WideString);
  { Warning: The property ValUnits has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.ValUnits := Value;
end;

function TiLegend.Get_Process: IUnknown;
begin
    Result := DefaultInterface.Process;
end;

procedure TiLegend.Set_Process(const Value: IUnknown);
begin
  DefaultInterface.Set_Process(Value);
end;

function TiLegend.Get__className(X: Integer): WideString;
begin
    Result := DefaultInterface._className[X];
end;

procedure TiLegend.Set__className(X: Integer; const Value: WideString);
  { Warning: The property _className has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant._className := Value;
end;

function TiLegend.Get_Disabled(LegendNumber: Integer): WordBool;
begin
    Result := DefaultInterface.Disabled[LegendNumber];
end;

procedure TiLegend.Set_Disabled(LegendNumber: Integer; Value: WordBool);
begin
  DefaultInterface.Disabled[LegendNumber] := Value;
end;

procedure TiLegend.Draw(Left: Integer; Top: Integer; PictureHandle: Integer);
begin
  DefaultInterface.Draw(Left, Top, PictureHandle);
end;

procedure TiLegend.Copy;
begin
  DefaultInterface.Copy;
end;

procedure TiLegend.SetAutoSize;
begin
  DefaultInterface.SetAutoSize;
end;

procedure TiLegend.SaveAsJPEG;
begin
  DefaultInterface.SaveAsJPEG;
end;

procedure TiLegend.Add(const ClassName: WideString);
begin
  DefaultInterface.Add(ClassName);
end;

procedure TiLegend.Clear;
begin
  DefaultInterface.Clear;
end;

function TiLegend.StreamAs(StreamType: iStreamType): OleVariant;
begin
  Result := DefaultInterface.StreamAs(StreamType);
end;

procedure TiLegend.Refresh;
begin
  DefaultInterface.Refresh;
end;

procedure TiLegend.AssignObject(const Source: iLegend);
begin
  DefaultInterface.AssignObject(Source);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TiLegendProperties.Create(AServer: TiLegend);
begin
  inherited Create;
  FServer := AServer;
end;

function TiLegendProperties.GetDefaultInterface: IiLegend;
begin
  Result := FServer.DefaultInterface;
end;

function TiLegendProperties.Get_Width: Integer;
begin
    Result := DefaultInterface.Width;
end;

procedure TiLegendProperties.Set_Width(Value: Integer);
begin
  DefaultInterface.Set_Width(Value);
end;

function TiLegendProperties.Get_Height: Integer;
begin
    Result := DefaultInterface.Height;
end;

procedure TiLegendProperties.Set_Height(Value: Integer);
begin
  DefaultInterface.Set_Height(Value);
end;

function TiLegendProperties.Get_Palette: iPal;
begin
    Result := DefaultInterface.Palette;
end;

procedure TiLegendProperties.Set_Palette(const Value: iPal);
begin
  DefaultInterface.Set_Palette(Value);
end;

function TiLegendProperties.Get_Count: Integer;
begin
    Result := DefaultInterface.Count;
end;

function TiLegendProperties.Get_Font: iFont;
begin
    Result := DefaultInterface.Font;
end;

procedure TiLegendProperties.Set_Font(const Value: iFont);
begin
  DefaultInterface.Set_Font(Value);
end;

function TiLegendProperties.Get_Horizontal: WordBool;
begin
    Result := DefaultInterface.Horizontal;
end;

procedure TiLegendProperties.Set_Horizontal(Value: WordBool);
begin
  DefaultInterface.Set_Horizontal(Value);
end;

function TiLegendProperties.Get_BackColor: Integer;
begin
    Result := DefaultInterface.BackColor;
end;

procedure TiLegendProperties.Set_BackColor(Value: Integer);
begin
  DefaultInterface.Set_BackColor(Value);
end;

function TiLegendProperties.Get_BorderColor: Integer;
begin
    Result := DefaultInterface.BorderColor;
end;

procedure TiLegendProperties.Set_BorderColor(Value: Integer);
begin
  DefaultInterface.Set_BorderColor(Value);
end;

function TiLegendProperties.Get_TextPosition: iTextPosition;
begin
    Result := DefaultInterface.TextPosition;
end;

procedure TiLegendProperties.Set_TextPosition(Value: iTextPosition);
begin
  DefaultInterface.Set_TextPosition(Value);
end;

function TiLegendProperties.Get_MaxValue: Double;
begin
    Result := DefaultInterface.MaxValue;
end;

procedure TiLegendProperties.Set_MaxValue(Value: Double);
begin
  DefaultInterface.Set_MaxValue(Value);
end;

function TiLegendProperties.Get_MinValue: Double;
begin
    Result := DefaultInterface.MinValue;
end;

procedure TiLegendProperties.Set_MinValue(Value: Double);
begin
  DefaultInterface.Set_MinValue(Value);
end;

function TiLegendProperties.Get_Decimal: Integer;
begin
    Result := DefaultInterface.Decimal;
end;

procedure TiLegendProperties.Set_Decimal(Value: Integer);
begin
  DefaultInterface.Set_Decimal(Value);
end;

function TiLegendProperties.Get_iType: LegType;
begin
    Result := DefaultInterface.iType;
end;

function TiLegendProperties.Get_FlagVal: Single;
begin
    Result := DefaultInterface.FlagVal;
end;

procedure TiLegendProperties.Set_FlagVal(Value: Single);
begin
  DefaultInterface.Set_FlagVal(Value);
end;

function TiLegendProperties.Get_FlagDef: WideString;
begin
    Result := DefaultInterface.FlagDef;
end;

procedure TiLegendProperties.Set_FlagDef(const Value: WideString);
  { Warning: The property FlagDef has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.FlagDef := Value;
end;

function TiLegendProperties.Get_RefSys: WideString;
begin
    Result := DefaultInterface.RefSys;
end;

procedure TiLegendProperties.Set_RefSys(const Value: WideString);
  { Warning: The property RefSys has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.RefSys := Value;
end;

function TiLegendProperties.Get_UnitDist: Double;
begin
    Result := DefaultInterface.UnitDist;
end;

procedure TiLegendProperties.Set_UnitDist(Value: Double);
begin
  DefaultInterface.Set_UnitDist(Value);
end;

function TiLegendProperties.Get_RefUnits: WideString;
begin
    Result := DefaultInterface.RefUnits;
end;

procedure TiLegendProperties.Set_RefUnits(const Value: WideString);
  { Warning: The property RefUnits has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.RefUnits := Value;
end;

function TiLegendProperties.Get_ValUnits: WideString;
begin
    Result := DefaultInterface.ValUnits;
end;

procedure TiLegendProperties.Set_ValUnits(const Value: WideString);
  { Warning: The property ValUnits has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.ValUnits := Value;
end;

function TiLegendProperties.Get_Process: IUnknown;
begin
    Result := DefaultInterface.Process;
end;

procedure TiLegendProperties.Set_Process(const Value: IUnknown);
begin
  DefaultInterface.Set_Process(Value);
end;

function TiLegendProperties.Get__className(X: Integer): WideString;
begin
    Result := DefaultInterface._className[X];
end;

procedure TiLegendProperties.Set__className(X: Integer; const Value: WideString);
  { Warning: The property _className has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant._className := Value;
end;

function TiLegendProperties.Get_Disabled(LegendNumber: Integer): WordBool;
begin
    Result := DefaultInterface.Disabled[LegendNumber];
end;

procedure TiLegendProperties.Set_Disabled(LegendNumber: Integer; Value: WordBool);
begin
  DefaultInterface.Disabled[LegendNumber] := Value;
end;

{$ENDIF}

class function CoiData.Create: IiData;
begin
  Result := CreateComObject(CLASS_iData) as IiData;
end;

class function CoiData.CreateRemote(const MachineName: string): IiData;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_iData) as IiData;
end;

class function CoiGeoData.Create: IiGeoData;
begin
  Result := CreateComObject(CLASS_iGeoData) as IiGeoData;
end;

class function CoiGeoData.CreateRemote(const MachineName: string): IiGeoData;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_iGeoData) as IiGeoData;
end;

class function CoiRaster.Create: IiRaster;
begin
  Result := CreateComObject(CLASS_iRaster) as IiRaster;
end;

class function CoiRaster.CreateRemote(const MachineName: string): IiRaster;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_iRaster) as IiRaster;
end;

procedure TiRaster.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{6C94257F-A98E-11D3-A52B-0000E85E2CDE}';
    IntfIID:   '{6C94257D-A98E-11D3-A52B-0000E85E2CDE}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TiRaster.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IiRaster;
  end;
end;

procedure TiRaster.ConnectTo(svrIntf: IiRaster);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TiRaster.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TiRaster.GetDefaultInterface: IiRaster;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TiRaster.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TiRasterProperties.Create(Self);
{$ENDIF}
end;

destructor TiRaster.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TiRaster.GetServerProperties: TiRasterProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TiRaster.Get_CheckStatus: Byte;
begin
    Result := DefaultInterface.CheckStatus;
end;

procedure TiRaster.Set_CheckStatus(Value: Byte);
begin
  DefaultInterface.Set_CheckStatus(Value);
end;

function TiRaster.Get_Empty: WordBool;
begin
    Result := DefaultInterface.Empty;
end;

procedure TiRaster.Set_Empty(Value: WordBool);
begin
  DefaultInterface.Set_Empty(Value);
end;

function TiRaster.Get_Changed: WordBool;
begin
    Result := DefaultInterface.Changed;
end;

procedure TiRaster.Set_Changed(Value: WordBool);
begin
  DefaultInterface.Set_Changed(Value);
end;

function TiRaster.Get_Error: WideString;
begin
    Result := DefaultInterface.Error;
end;

function TiRaster.Get_ObjectName: WideString;
begin
    Result := DefaultInterface.ObjectName;
end;

function TiRaster.Get_Process: IUnknown;
begin
    Result := DefaultInterface.Process;
end;

procedure TiRaster.Set_Process(const Value: IUnknown);
begin
  DefaultInterface.Set_Process(Value);
end;

function TiRaster.Get_DataHandle: Integer;
begin
    Result := DefaultInterface.DataHandle;
end;

function TiRaster.Get_Status: WideString;
begin
    Result := DefaultInterface.Status;
end;

function TiRaster.Get_Processing: WordBool;
begin
    Result := DefaultInterface.Processing;
end;

function TiRaster.Get_PercentDone: Byte;
begin
    Result := DefaultInterface.PercentDone;
end;

function TiRaster.Get_Title: WideString;
begin
    Result := DefaultInterface.Title;
end;

procedure TiRaster.Set_Title(const Value: WideString);
  { Warning: The property Title has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Title := Value;
end;

function TiRaster.Get_Legend: iLegend;
begin
    Result := DefaultInterface.Legend;
end;

procedure TiRaster.Set_Legend(const Value: iLegend);
begin
  DefaultInterface.Set_Legend(Value);
end;

function TiRaster.Get_hDC: Integer;
begin
    Result := DefaultInterface.hDC;
end;

function TiRaster.Get_MinX: Double;
begin
    Result := DefaultInterface.MinX;
end;

procedure TiRaster.Set_MinX(Value: Double);
begin
  DefaultInterface.Set_MinX(Value);
end;

function TiRaster.Get_MaxX: Double;
begin
    Result := DefaultInterface.MaxX;
end;

procedure TiRaster.Set_MaxX(Value: Double);
begin
  DefaultInterface.Set_MaxX(Value);
end;

function TiRaster.Get_MinY: Double;
begin
    Result := DefaultInterface.MinY;
end;

procedure TiRaster.Set_MinY(Value: Double);
begin
  DefaultInterface.Set_MinY(Value);
end;

function TiRaster.Get_MaxY: Double;
begin
    Result := DefaultInterface.MaxY;
end;

procedure TiRaster.Set_MaxY(Value: Double);
begin
  DefaultInterface.Set_MaxY(Value);
end;

function TiRaster.Get_Document: iFile;
begin
    Result := DefaultInterface.Document;
end;

procedure TiRaster.Set_Document(const Value: iFile);
begin
  DefaultInterface.Set_Document(Value);
end;

function TiRaster.Get_Comment: iStringList;
begin
    Result := DefaultInterface.Comment;
end;

procedure TiRaster.Set_Comment(const Value: iStringList);
begin
  DefaultInterface.Set_Comment(Value);
end;

function TiRaster.Get_Lineage: iStringList;
begin
    Result := DefaultInterface.Lineage;
end;

procedure TiRaster.Set_Lineage(const Value: iStringList);
begin
  DefaultInterface.Set_Lineage(Value);
end;

function TiRaster.Get_Completeness: iStringList;
begin
    Result := DefaultInterface.Completeness;
end;

procedure TiRaster.Set_Completeness(const Value: iStringList);
begin
  DefaultInterface.Set_Completeness(Value);
end;

function TiRaster.Get_Consistency: iStringList;
begin
    Result := DefaultInterface.Consistency;
end;

procedure TiRaster.Set_Consistency(const Value: iStringList);
begin
  DefaultInterface.Set_Consistency(Value);
end;

function TiRaster.Get_PartialScene: WordBool;
begin
    Result := DefaultInterface.PartialScene;
end;

function TiRaster.Get_ImageWidth: Integer;
begin
    Result := DefaultInterface.ImageWidth;
end;

procedure TiRaster.Set_ImageWidth(Value: Integer);
begin
  DefaultInterface.Set_ImageWidth(Value);
end;

function TiRaster.Get_ImageHeight: Integer;
begin
    Result := DefaultInterface.ImageHeight;
end;

procedure TiRaster.Set_ImageHeight(Value: Integer);
begin
  DefaultInterface.Set_ImageHeight(Value);
end;

function TiRaster.Get_PointXY(X: OleVariant; Y: OleVariant): OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.PointXY[X, Y];
end;

procedure TiRaster.Set_PointXY(X: OleVariant; Y: OleVariant; Value: OleVariant);
begin
  DefaultInterface.PointXY[X, Y] := Value;
end;

function TiRaster.Get_Cols: Integer;
begin
    Result := DefaultInterface.Cols;
end;

function TiRaster.Get_Rows: Integer;
begin
    Result := DefaultInterface.Rows;
end;

function TiRaster.Get_Res: Double;
begin
    Result := DefaultInterface.Res;
end;

procedure TiRaster.Set_Res(Value: Double);
begin
  DefaultInterface.Set_Res(Value);
end;

function TiRaster.Get_MaxValue: Double;
begin
    Result := DefaultInterface.MaxValue;
end;

procedure TiRaster.Set_MaxValue(Value: Double);
begin
  DefaultInterface.Set_MaxValue(Value);
end;

function TiRaster.Get_MinValue: Double;
begin
    Result := DefaultInterface.MinValue;
end;

procedure TiRaster.Set_MinValue(Value: Double);
begin
  DefaultInterface.Set_MinValue(Value);
end;

function TiRaster.Get_DataType: iDataTypeConst;
begin
    Result := DefaultInterface.DataType;
end;

procedure TiRaster.Set_DataType(Value: iDataTypeConst);
begin
  DefaultInterface.Set_DataType(Value);
end;

function TiRaster.Get_ByteOrder: iByteOrder;
begin
    Result := DefaultInterface.ByteOrder;
end;

function TiRaster.Get_ScanLineOrientation: iScanlineOrientType;
begin
    Result := DefaultInterface.ScanLineOrientation;
end;

procedure TiRaster.Set_ScanLineOrientation(Value: iScanlineOrientType);
begin
  DefaultInterface.Set_ScanLineOrientation(Value);
end;

function TiRaster.ArrayOfVar(SourceArray: OleVariant): OleVariant;
begin
  Result := DefaultInterface.ArrayOfVar(SourceArray);
end;

procedure TiRaster.AssignObject(const Source: iData);
begin
  DefaultInterface.AssignObject(Source);
end;

procedure TiRaster.PasteGeoRefs(const PassVar: iGeoData);
begin
  DefaultInterface.PasteGeoRefs(PassVar);
end;

function TiRaster.Open: WordBool;
begin
  Result := DefaultInterface.Open;
end;

procedure TiRaster.Save;
begin
  DefaultInterface.Save;
end;

function TiRaster.Terminate: WordBool;
begin
  Result := DefaultInterface.Terminate;
end;

procedure TiRaster.SaveHeader;
begin
  DefaultInterface.SaveHeader;
end;

function TiRaster.OpenHeader: WordBool;
begin
  Result := DefaultInterface.OpenHeader;
end;

function TiRaster.OpenWindow(X1: OleVariant; Y1: OleVariant; X2: OleVariant; Y2: OleVariant; 
                             Step: Smallint): WordBool;
begin
  Result := DefaultInterface.OpenWindow(X1, Y1, X2, Y2, Step);
end;

function TiRaster.OpenSample(Step: Smallint): WordBool;
begin
  Result := DefaultInterface.OpenSample(Step);
end;

procedure TiRaster.PasteHDC(BitmapHDC: Integer; Width: Integer; Height: Integer);
begin
  DefaultInterface.PasteHDC(BitmapHDC, Width, Height);
end;

procedure TiRaster.Refresh;
begin
  DefaultInterface.Refresh;
end;

procedure TiRaster.ClearBitmap;
begin
  DefaultInterface.ClearBitmap;
end;

function TiRaster.StreamMapAs(StreamType: iStreamType): OleVariant;
begin
  Result := DefaultInterface.StreamMapAs(StreamType);
end;

procedure TiRaster.PaintPoint(X: OleVariant; Y: OleVariant; Radius: OleVariant; 
                              const Color: WideString);
begin
  DefaultInterface.PaintPoint(X, Y, Radius, Color);
end;

procedure TiRaster.PaintLine(X1: OleVariant; Y1: OleVariant; X2: OleVariant; Y2: OleVariant; 
                             Width: OleVariant; const Color: WideString);
begin
  DefaultInterface.PaintLine(X1, Y1, X2, Y2, Width, Color);
end;

procedure TiRaster.PaintPolygon(Points: OleVariant; LineWidth: Integer; const Color: WideString; 
                                BrushStyle: iBrushStyle; IsGeographic: WordBool);
begin
  DefaultInterface.PaintPolygon(Points, LineWidth, Color, BrushStyle, IsGeographic);
end;

procedure TiRaster.PaintText(X: OleVariant; Y: OleVariant; const Text: WideString; 
                             const FontName: WideString; Size: Integer; const Style: WideString; 
                             const Color: WideString);
begin
  DefaultInterface.PaintText(X, Y, Text, FontName, Size, Style, Color);
end;

function TiRaster.StreamAs(StreamType: iStreamType): OleVariant;
begin
  Result := DefaultInterface.StreamAs(StreamType);
end;

procedure TiRaster.Draw(Left: Integer; Top: Integer; Zoom: Single; PictureHandle: Integer);
begin
  DefaultInterface.Draw(Left, Top, Zoom, PictureHandle);
end;

procedure TiRaster.DrawMap(Zoom: Single; PictureHandle: Integer);
begin
  DefaultInterface.DrawMap(Zoom, PictureHandle);
end;

procedure TiRaster.CopyMap(Zoom: Single);
begin
  DefaultInterface.CopyMap(Zoom);
end;

procedure TiRaster.Copy;
begin
  DefaultInterface.Copy;
end;

procedure TiRaster.StretchDraw(hDC: Integer; X1: Double; Y1: Double; X2: Double; Y2: Double; 
                               Left: Integer; Top: Integer; Right: Integer; Bottom: Integer);
begin
  DefaultInterface.StretchDraw(hDC, X1, Y1, X2, Y2, Left, Top, Right, Bottom);
end;

function TiRaster.GetDataBuffer(out DataOut: OleVariant): Integer;
begin
  Result := DefaultInterface.GetDataBuffer(DataOut);
end;

procedure TiRaster.SetDataBuffer(DataIn: OleVariant);
begin
  DefaultInterface.SetDataBuffer(DataIn);
end;

function TiRaster.RetrieveBitmap(Source: OleVariant; TimeOut_Sec: Integer; X1: Integer; 
                                 Y1: Integer; X2: Integer; Y2: Integer; Transparency: Byte): Integer;
begin
  Result := DefaultInterface.RetrieveBitmap(Source, TimeOut_Sec, X1, Y1, X2, Y2, Transparency);
end;

function TiRaster.Column(X1: Single): Integer;
begin
  Result := DefaultInterface.Column(X1);
end;

function TiRaster.Row(Y1: Single): Integer;
begin
  Result := DefaultInterface.Row(Y1);
end;

function TiRaster.CoordX(PassVar: Integer): Single;
begin
  Result := DefaultInterface.CoordX(PassVar);
end;

function TiRaster.CoordY(PassVar: Integer): Single;
begin
  Result := DefaultInterface.CoordY(PassVar);
end;

procedure TiRaster.GetMaxMin;
begin
  DefaultInterface.GetMaxMin;
end;

procedure TiRaster.Insert(const PassVar: iRaster);
begin
  DefaultInterface.Insert(PassVar);
end;

procedure TiRaster.SetDataYX(Matrix: OleVariant; X1: Integer; Y1: Integer; X2: Integer; Y2: Integer);
begin
  DefaultInterface.SetDataYX(Matrix, X1, Y1, X2, Y2);
end;

function TiRaster.GetDataYX(X1: Integer; Y1: Integer; X2: Integer; Y2: Integer): OleVariant;
begin
  Result := DefaultInterface.GetDataYX(X1, Y1, X2, Y2);
end;

procedure TiRaster.New(const NewName: WideString; NewDataType: iDataTypeConst; NewCols: Integer; 
                       NewRows: Integer; InitVal: Single);
begin
  DefaultInterface.New(NewName, NewDataType, NewCols, NewRows, InitVal);
end;

procedure TiRaster.SetData(Matrix: OleVariant; X1: Integer; Y1: Integer; X2: Integer; Y2: Integer);
begin
  DefaultInterface.SetData(Matrix, X1, Y1, X2, Y2);
end;

function TiRaster.GetData(X1: Integer; Y1: Integer; X2: Integer; Y2: Integer): OleVariant;
begin
  Result := DefaultInterface.GetData(X1, Y1, X2, Y2);
end;

function TiRaster.RetrieveURLData(const URLString: WideString; TimeOut_Sec: Integer; X1: Integer; 
                                  Y1: Integer; X2: Integer; Y2: Integer): Integer;
begin
  Result := DefaultInterface.RetrieveURLData(URLString, TimeOut_Sec, X1, Y1, X2, Y2);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TiRasterProperties.Create(AServer: TiRaster);
begin
  inherited Create;
  FServer := AServer;
end;

function TiRasterProperties.GetDefaultInterface: IiRaster;
begin
  Result := FServer.DefaultInterface;
end;

function TiRasterProperties.Get_CheckStatus: Byte;
begin
    Result := DefaultInterface.CheckStatus;
end;

procedure TiRasterProperties.Set_CheckStatus(Value: Byte);
begin
  DefaultInterface.Set_CheckStatus(Value);
end;

function TiRasterProperties.Get_Empty: WordBool;
begin
    Result := DefaultInterface.Empty;
end;

procedure TiRasterProperties.Set_Empty(Value: WordBool);
begin
  DefaultInterface.Set_Empty(Value);
end;

function TiRasterProperties.Get_Changed: WordBool;
begin
    Result := DefaultInterface.Changed;
end;

procedure TiRasterProperties.Set_Changed(Value: WordBool);
begin
  DefaultInterface.Set_Changed(Value);
end;

function TiRasterProperties.Get_Error: WideString;
begin
    Result := DefaultInterface.Error;
end;

function TiRasterProperties.Get_ObjectName: WideString;
begin
    Result := DefaultInterface.ObjectName;
end;

function TiRasterProperties.Get_Process: IUnknown;
begin
    Result := DefaultInterface.Process;
end;

procedure TiRasterProperties.Set_Process(const Value: IUnknown);
begin
  DefaultInterface.Set_Process(Value);
end;

function TiRasterProperties.Get_DataHandle: Integer;
begin
    Result := DefaultInterface.DataHandle;
end;

function TiRasterProperties.Get_Status: WideString;
begin
    Result := DefaultInterface.Status;
end;

function TiRasterProperties.Get_Processing: WordBool;
begin
    Result := DefaultInterface.Processing;
end;

function TiRasterProperties.Get_PercentDone: Byte;
begin
    Result := DefaultInterface.PercentDone;
end;

function TiRasterProperties.Get_Title: WideString;
begin
    Result := DefaultInterface.Title;
end;

procedure TiRasterProperties.Set_Title(const Value: WideString);
  { Warning: The property Title has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Title := Value;
end;

function TiRasterProperties.Get_Legend: iLegend;
begin
    Result := DefaultInterface.Legend;
end;

procedure TiRasterProperties.Set_Legend(const Value: iLegend);
begin
  DefaultInterface.Set_Legend(Value);
end;

function TiRasterProperties.Get_hDC: Integer;
begin
    Result := DefaultInterface.hDC;
end;

function TiRasterProperties.Get_MinX: Double;
begin
    Result := DefaultInterface.MinX;
end;

procedure TiRasterProperties.Set_MinX(Value: Double);
begin
  DefaultInterface.Set_MinX(Value);
end;

function TiRasterProperties.Get_MaxX: Double;
begin
    Result := DefaultInterface.MaxX;
end;

procedure TiRasterProperties.Set_MaxX(Value: Double);
begin
  DefaultInterface.Set_MaxX(Value);
end;

function TiRasterProperties.Get_MinY: Double;
begin
    Result := DefaultInterface.MinY;
end;

procedure TiRasterProperties.Set_MinY(Value: Double);
begin
  DefaultInterface.Set_MinY(Value);
end;

function TiRasterProperties.Get_MaxY: Double;
begin
    Result := DefaultInterface.MaxY;
end;

procedure TiRasterProperties.Set_MaxY(Value: Double);
begin
  DefaultInterface.Set_MaxY(Value);
end;

function TiRasterProperties.Get_Document: iFile;
begin
    Result := DefaultInterface.Document;
end;

procedure TiRasterProperties.Set_Document(const Value: iFile);
begin
  DefaultInterface.Set_Document(Value);
end;

function TiRasterProperties.Get_Comment: iStringList;
begin
    Result := DefaultInterface.Comment;
end;

procedure TiRasterProperties.Set_Comment(const Value: iStringList);
begin
  DefaultInterface.Set_Comment(Value);
end;

function TiRasterProperties.Get_Lineage: iStringList;
begin
    Result := DefaultInterface.Lineage;
end;

procedure TiRasterProperties.Set_Lineage(const Value: iStringList);
begin
  DefaultInterface.Set_Lineage(Value);
end;

function TiRasterProperties.Get_Completeness: iStringList;
begin
    Result := DefaultInterface.Completeness;
end;

procedure TiRasterProperties.Set_Completeness(const Value: iStringList);
begin
  DefaultInterface.Set_Completeness(Value);
end;

function TiRasterProperties.Get_Consistency: iStringList;
begin
    Result := DefaultInterface.Consistency;
end;

procedure TiRasterProperties.Set_Consistency(const Value: iStringList);
begin
  DefaultInterface.Set_Consistency(Value);
end;

function TiRasterProperties.Get_PartialScene: WordBool;
begin
    Result := DefaultInterface.PartialScene;
end;

function TiRasterProperties.Get_ImageWidth: Integer;
begin
    Result := DefaultInterface.ImageWidth;
end;

procedure TiRasterProperties.Set_ImageWidth(Value: Integer);
begin
  DefaultInterface.Set_ImageWidth(Value);
end;

function TiRasterProperties.Get_ImageHeight: Integer;
begin
    Result := DefaultInterface.ImageHeight;
end;

procedure TiRasterProperties.Set_ImageHeight(Value: Integer);
begin
  DefaultInterface.Set_ImageHeight(Value);
end;

function TiRasterProperties.Get_PointXY(X: OleVariant; Y: OleVariant): OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.PointXY[X, Y];
end;

procedure TiRasterProperties.Set_PointXY(X: OleVariant; Y: OleVariant; Value: OleVariant);
begin
  DefaultInterface.PointXY[X, Y] := Value;
end;

function TiRasterProperties.Get_Cols: Integer;
begin
    Result := DefaultInterface.Cols;
end;

function TiRasterProperties.Get_Rows: Integer;
begin
    Result := DefaultInterface.Rows;
end;

function TiRasterProperties.Get_Res: Double;
begin
    Result := DefaultInterface.Res;
end;

procedure TiRasterProperties.Set_Res(Value: Double);
begin
  DefaultInterface.Set_Res(Value);
end;

function TiRasterProperties.Get_MaxValue: Double;
begin
    Result := DefaultInterface.MaxValue;
end;

procedure TiRasterProperties.Set_MaxValue(Value: Double);
begin
  DefaultInterface.Set_MaxValue(Value);
end;

function TiRasterProperties.Get_MinValue: Double;
begin
    Result := DefaultInterface.MinValue;
end;

procedure TiRasterProperties.Set_MinValue(Value: Double);
begin
  DefaultInterface.Set_MinValue(Value);
end;

function TiRasterProperties.Get_DataType: iDataTypeConst;
begin
    Result := DefaultInterface.DataType;
end;

procedure TiRasterProperties.Set_DataType(Value: iDataTypeConst);
begin
  DefaultInterface.Set_DataType(Value);
end;

function TiRasterProperties.Get_ByteOrder: iByteOrder;
begin
    Result := DefaultInterface.ByteOrder;
end;

function TiRasterProperties.Get_ScanLineOrientation: iScanlineOrientType;
begin
    Result := DefaultInterface.ScanLineOrientation;
end;

procedure TiRasterProperties.Set_ScanLineOrientation(Value: iScanlineOrientType);
begin
  DefaultInterface.Set_ScanLineOrientation(Value);
end;

{$ENDIF}

class function CoiImg.Create: IiImg;
begin
  Result := CreateComObject(CLASS_iImg) as IiImg;
end;

class function CoiImg.CreateRemote(const MachineName: string): IiImg;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_iImg) as IiImg;
end;

procedure TiImg.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{6C942583-A98E-11D3-A52B-0000E85E2CDE}';
    IntfIID:   '{6C942581-A98E-11D3-A52B-0000E85E2CDE}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TiImg.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IiImg;
  end;
end;

procedure TiImg.ConnectTo(svrIntf: IiImg);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TiImg.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TiImg.GetDefaultInterface: IiImg;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TiImg.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TiImgProperties.Create(Self);
{$ENDIF}
end;

destructor TiImg.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TiImg.GetServerProperties: TiImgProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TiImg.Get_CheckStatus: Byte;
begin
    Result := DefaultInterface.CheckStatus;
end;

procedure TiImg.Set_CheckStatus(Value: Byte);
begin
  DefaultInterface.Set_CheckStatus(Value);
end;

function TiImg.Get_Empty: WordBool;
begin
    Result := DefaultInterface.Empty;
end;

procedure TiImg.Set_Empty(Value: WordBool);
begin
  DefaultInterface.Set_Empty(Value);
end;

function TiImg.Get_Changed: WordBool;
begin
    Result := DefaultInterface.Changed;
end;

procedure TiImg.Set_Changed(Value: WordBool);
begin
  DefaultInterface.Set_Changed(Value);
end;

function TiImg.Get_Error: WideString;
begin
    Result := DefaultInterface.Error;
end;

function TiImg.Get_ObjectName: WideString;
begin
    Result := DefaultInterface.ObjectName;
end;

function TiImg.Get_Process: IUnknown;
begin
    Result := DefaultInterface.Process;
end;

procedure TiImg.Set_Process(const Value: IUnknown);
begin
  DefaultInterface.Set_Process(Value);
end;

function TiImg.Get_DataHandle: Integer;
begin
    Result := DefaultInterface.DataHandle;
end;

function TiImg.Get_Status: WideString;
begin
    Result := DefaultInterface.Status;
end;

function TiImg.Get_Processing: WordBool;
begin
    Result := DefaultInterface.Processing;
end;

function TiImg.Get_PercentDone: Byte;
begin
    Result := DefaultInterface.PercentDone;
end;

function TiImg.Get_Title: WideString;
begin
    Result := DefaultInterface.Title;
end;

procedure TiImg.Set_Title(const Value: WideString);
  { Warning: The property Title has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Title := Value;
end;

function TiImg.Get_Legend: iLegend;
begin
    Result := DefaultInterface.Legend;
end;

procedure TiImg.Set_Legend(const Value: iLegend);
begin
  DefaultInterface.Set_Legend(Value);
end;

function TiImg.Get_hDC: Integer;
begin
    Result := DefaultInterface.hDC;
end;

function TiImg.Get_MinX: Double;
begin
    Result := DefaultInterface.MinX;
end;

procedure TiImg.Set_MinX(Value: Double);
begin
  DefaultInterface.Set_MinX(Value);
end;

function TiImg.Get_MaxX: Double;
begin
    Result := DefaultInterface.MaxX;
end;

procedure TiImg.Set_MaxX(Value: Double);
begin
  DefaultInterface.Set_MaxX(Value);
end;

function TiImg.Get_MinY: Double;
begin
    Result := DefaultInterface.MinY;
end;

procedure TiImg.Set_MinY(Value: Double);
begin
  DefaultInterface.Set_MinY(Value);
end;

function TiImg.Get_MaxY: Double;
begin
    Result := DefaultInterface.MaxY;
end;

procedure TiImg.Set_MaxY(Value: Double);
begin
  DefaultInterface.Set_MaxY(Value);
end;

function TiImg.Get_Document: iFile;
begin
    Result := DefaultInterface.Document;
end;

procedure TiImg.Set_Document(const Value: iFile);
begin
  DefaultInterface.Set_Document(Value);
end;

function TiImg.Get_Comment: iStringList;
begin
    Result := DefaultInterface.Comment;
end;

procedure TiImg.Set_Comment(const Value: iStringList);
begin
  DefaultInterface.Set_Comment(Value);
end;

function TiImg.Get_Lineage: iStringList;
begin
    Result := DefaultInterface.Lineage;
end;

procedure TiImg.Set_Lineage(const Value: iStringList);
begin
  DefaultInterface.Set_Lineage(Value);
end;

function TiImg.Get_Completeness: iStringList;
begin
    Result := DefaultInterface.Completeness;
end;

procedure TiImg.Set_Completeness(const Value: iStringList);
begin
  DefaultInterface.Set_Completeness(Value);
end;

function TiImg.Get_Consistency: iStringList;
begin
    Result := DefaultInterface.Consistency;
end;

procedure TiImg.Set_Consistency(const Value: iStringList);
begin
  DefaultInterface.Set_Consistency(Value);
end;

function TiImg.Get_PartialScene: WordBool;
begin
    Result := DefaultInterface.PartialScene;
end;

function TiImg.Get_ImageWidth: Integer;
begin
    Result := DefaultInterface.ImageWidth;
end;

procedure TiImg.Set_ImageWidth(Value: Integer);
begin
  DefaultInterface.Set_ImageWidth(Value);
end;

function TiImg.Get_ImageHeight: Integer;
begin
    Result := DefaultInterface.ImageHeight;
end;

procedure TiImg.Set_ImageHeight(Value: Integer);
begin
  DefaultInterface.Set_ImageHeight(Value);
end;

function TiImg.Get_PointXY(X: OleVariant; Y: OleVariant): OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.PointXY[X, Y];
end;

procedure TiImg.Set_PointXY(X: OleVariant; Y: OleVariant; Value: OleVariant);
begin
  DefaultInterface.PointXY[X, Y] := Value;
end;

function TiImg.Get_Cols: Integer;
begin
    Result := DefaultInterface.Cols;
end;

function TiImg.Get_Rows: Integer;
begin
    Result := DefaultInterface.Rows;
end;

function TiImg.Get_Res: Double;
begin
    Result := DefaultInterface.Res;
end;

procedure TiImg.Set_Res(Value: Double);
begin
  DefaultInterface.Set_Res(Value);
end;

function TiImg.Get_MaxValue: Double;
begin
    Result := DefaultInterface.MaxValue;
end;

procedure TiImg.Set_MaxValue(Value: Double);
begin
  DefaultInterface.Set_MaxValue(Value);
end;

function TiImg.Get_MinValue: Double;
begin
    Result := DefaultInterface.MinValue;
end;

procedure TiImg.Set_MinValue(Value: Double);
begin
  DefaultInterface.Set_MinValue(Value);
end;

function TiImg.Get_DataType: iDataTypeConst;
begin
    Result := DefaultInterface.DataType;
end;

procedure TiImg.Set_DataType(Value: iDataTypeConst);
begin
  DefaultInterface.Set_DataType(Value);
end;

function TiImg.Get_ByteOrder: iByteOrder;
begin
    Result := DefaultInterface.ByteOrder;
end;

function TiImg.Get_ScanLineOrientation: iScanlineOrientType;
begin
    Result := DefaultInterface.ScanLineOrientation;
end;

procedure TiImg.Set_ScanLineOrientation(Value: iScanlineOrientType);
begin
  DefaultInterface.Set_ScanLineOrientation(Value);
end;

function TiImg.ArrayOfVar(SourceArray: OleVariant): OleVariant;
begin
  Result := DefaultInterface.ArrayOfVar(SourceArray);
end;

procedure TiImg.AssignObject(const Source: iData);
begin
  DefaultInterface.AssignObject(Source);
end;

procedure TiImg.PasteGeoRefs(const PassVar: iGeoData);
begin
  DefaultInterface.PasteGeoRefs(PassVar);
end;

function TiImg.Open: WordBool;
begin
  Result := DefaultInterface.Open;
end;

procedure TiImg.Save;
begin
  DefaultInterface.Save;
end;

function TiImg.Terminate: WordBool;
begin
  Result := DefaultInterface.Terminate;
end;

procedure TiImg.SaveHeader;
begin
  DefaultInterface.SaveHeader;
end;

function TiImg.OpenHeader: WordBool;
begin
  Result := DefaultInterface.OpenHeader;
end;

function TiImg.OpenWindow(X1: OleVariant; Y1: OleVariant; X2: OleVariant; Y2: OleVariant; 
                          Step: Smallint): WordBool;
begin
  Result := DefaultInterface.OpenWindow(X1, Y1, X2, Y2, Step);
end;

function TiImg.OpenSample(Step: Smallint): WordBool;
begin
  Result := DefaultInterface.OpenSample(Step);
end;

procedure TiImg.PasteHDC(BitmapHDC: Integer; Width: Integer; Height: Integer);
begin
  DefaultInterface.PasteHDC(BitmapHDC, Width, Height);
end;

procedure TiImg.Refresh;
begin
  DefaultInterface.Refresh;
end;

procedure TiImg.ClearBitmap;
begin
  DefaultInterface.ClearBitmap;
end;

function TiImg.StreamMapAs(StreamType: iStreamType): OleVariant;
begin
  Result := DefaultInterface.StreamMapAs(StreamType);
end;

procedure TiImg.PaintPoint(X: OleVariant; Y: OleVariant; Radius: OleVariant; const Color: WideString);
begin
  DefaultInterface.PaintPoint(X, Y, Radius, Color);
end;

procedure TiImg.PaintLine(X1: OleVariant; Y1: OleVariant; X2: OleVariant; Y2: OleVariant; 
                          Width: OleVariant; const Color: WideString);
begin
  DefaultInterface.PaintLine(X1, Y1, X2, Y2, Width, Color);
end;

procedure TiImg.PaintPolygon(Points: OleVariant; LineWidth: Integer; const Color: WideString; 
                             BrushStyle: iBrushStyle; IsGeographic: WordBool);
begin
  DefaultInterface.PaintPolygon(Points, LineWidth, Color, BrushStyle, IsGeographic);
end;

procedure TiImg.PaintText(X: OleVariant; Y: OleVariant; const Text: WideString; 
                          const FontName: WideString; Size: Integer; const Style: WideString; 
                          const Color: WideString);
begin
  DefaultInterface.PaintText(X, Y, Text, FontName, Size, Style, Color);
end;

function TiImg.StreamAs(StreamType: iStreamType): OleVariant;
begin
  Result := DefaultInterface.StreamAs(StreamType);
end;

procedure TiImg.Draw(Left: Integer; Top: Integer; Zoom: Single; PictureHandle: Integer);
begin
  DefaultInterface.Draw(Left, Top, Zoom, PictureHandle);
end;

procedure TiImg.DrawMap(Zoom: Single; PictureHandle: Integer);
begin
  DefaultInterface.DrawMap(Zoom, PictureHandle);
end;

procedure TiImg.CopyMap(Zoom: Single);
begin
  DefaultInterface.CopyMap(Zoom);
end;

procedure TiImg.Copy;
begin
  DefaultInterface.Copy;
end;

procedure TiImg.StretchDraw(hDC: Integer; X1: Double; Y1: Double; X2: Double; Y2: Double; 
                            Left: Integer; Top: Integer; Right: Integer; Bottom: Integer);
begin
  DefaultInterface.StretchDraw(hDC, X1, Y1, X2, Y2, Left, Top, Right, Bottom);
end;

function TiImg.GetDataBuffer(out DataOut: OleVariant): Integer;
begin
  Result := DefaultInterface.GetDataBuffer(DataOut);
end;

procedure TiImg.SetDataBuffer(DataIn: OleVariant);
begin
  DefaultInterface.SetDataBuffer(DataIn);
end;

function TiImg.RetrieveBitmap(Source: OleVariant; TimeOut_Sec: Integer; X1: Integer; Y1: Integer; 
                              X2: Integer; Y2: Integer; Transparency: Byte): Integer;
begin
  Result := DefaultInterface.RetrieveBitmap(Source, TimeOut_Sec, X1, Y1, X2, Y2, Transparency);
end;

function TiImg.Column(X1: Single): Integer;
begin
  Result := DefaultInterface.Column(X1);
end;

function TiImg.Row(Y1: Single): Integer;
begin
  Result := DefaultInterface.Row(Y1);
end;

function TiImg.CoordX(PassVar: Integer): Single;
begin
  Result := DefaultInterface.CoordX(PassVar);
end;

function TiImg.CoordY(PassVar: Integer): Single;
begin
  Result := DefaultInterface.CoordY(PassVar);
end;

procedure TiImg.GetMaxMin;
begin
  DefaultInterface.GetMaxMin;
end;

procedure TiImg.Insert(const PassVar: iRaster);
begin
  DefaultInterface.Insert(PassVar);
end;

procedure TiImg.SetDataYX(Matrix: OleVariant; X1: Integer; Y1: Integer; X2: Integer; Y2: Integer);
begin
  DefaultInterface.SetDataYX(Matrix, X1, Y1, X2, Y2);
end;

function TiImg.GetDataYX(X1: Integer; Y1: Integer; X2: Integer; Y2: Integer): OleVariant;
begin
  Result := DefaultInterface.GetDataYX(X1, Y1, X2, Y2);
end;

procedure TiImg.New(const NewName: WideString; NewDataType: iDataTypeConst; NewCols: Integer; 
                    NewRows: Integer; InitVal: Single);
begin
  DefaultInterface.New(NewName, NewDataType, NewCols, NewRows, InitVal);
end;

procedure TiImg.SetData(Matrix: OleVariant; X1: Integer; Y1: Integer; X2: Integer; Y2: Integer);
begin
  DefaultInterface.SetData(Matrix, X1, Y1, X2, Y2);
end;

function TiImg.GetData(X1: Integer; Y1: Integer; X2: Integer; Y2: Integer): OleVariant;
begin
  Result := DefaultInterface.GetData(X1, Y1, X2, Y2);
end;

function TiImg.RetrieveURLData(const URLString: WideString; TimeOut_Sec: Integer; X1: Integer; 
                               Y1: Integer; X2: Integer; Y2: Integer): Integer;
begin
  Result := DefaultInterface.RetrieveURLData(URLString, TimeOut_Sec, X1, Y1, X2, Y2);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TiImgProperties.Create(AServer: TiImg);
begin
  inherited Create;
  FServer := AServer;
end;

function TiImgProperties.GetDefaultInterface: IiImg;
begin
  Result := FServer.DefaultInterface;
end;

function TiImgProperties.Get_CheckStatus: Byte;
begin
    Result := DefaultInterface.CheckStatus;
end;

procedure TiImgProperties.Set_CheckStatus(Value: Byte);
begin
  DefaultInterface.Set_CheckStatus(Value);
end;

function TiImgProperties.Get_Empty: WordBool;
begin
    Result := DefaultInterface.Empty;
end;

procedure TiImgProperties.Set_Empty(Value: WordBool);
begin
  DefaultInterface.Set_Empty(Value);
end;

function TiImgProperties.Get_Changed: WordBool;
begin
    Result := DefaultInterface.Changed;
end;

procedure TiImgProperties.Set_Changed(Value: WordBool);
begin
  DefaultInterface.Set_Changed(Value);
end;

function TiImgProperties.Get_Error: WideString;
begin
    Result := DefaultInterface.Error;
end;

function TiImgProperties.Get_ObjectName: WideString;
begin
    Result := DefaultInterface.ObjectName;
end;

function TiImgProperties.Get_Process: IUnknown;
begin
    Result := DefaultInterface.Process;
end;

procedure TiImgProperties.Set_Process(const Value: IUnknown);
begin
  DefaultInterface.Set_Process(Value);
end;

function TiImgProperties.Get_DataHandle: Integer;
begin
    Result := DefaultInterface.DataHandle;
end;

function TiImgProperties.Get_Status: WideString;
begin
    Result := DefaultInterface.Status;
end;

function TiImgProperties.Get_Processing: WordBool;
begin
    Result := DefaultInterface.Processing;
end;

function TiImgProperties.Get_PercentDone: Byte;
begin
    Result := DefaultInterface.PercentDone;
end;

function TiImgProperties.Get_Title: WideString;
begin
    Result := DefaultInterface.Title;
end;

procedure TiImgProperties.Set_Title(const Value: WideString);
  { Warning: The property Title has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Title := Value;
end;

function TiImgProperties.Get_Legend: iLegend;
begin
    Result := DefaultInterface.Legend;
end;

procedure TiImgProperties.Set_Legend(const Value: iLegend);
begin
  DefaultInterface.Set_Legend(Value);
end;

function TiImgProperties.Get_hDC: Integer;
begin
    Result := DefaultInterface.hDC;
end;

function TiImgProperties.Get_MinX: Double;
begin
    Result := DefaultInterface.MinX;
end;

procedure TiImgProperties.Set_MinX(Value: Double);
begin
  DefaultInterface.Set_MinX(Value);
end;

function TiImgProperties.Get_MaxX: Double;
begin
    Result := DefaultInterface.MaxX;
end;

procedure TiImgProperties.Set_MaxX(Value: Double);
begin
  DefaultInterface.Set_MaxX(Value);
end;

function TiImgProperties.Get_MinY: Double;
begin
    Result := DefaultInterface.MinY;
end;

procedure TiImgProperties.Set_MinY(Value: Double);
begin
  DefaultInterface.Set_MinY(Value);
end;

function TiImgProperties.Get_MaxY: Double;
begin
    Result := DefaultInterface.MaxY;
end;

procedure TiImgProperties.Set_MaxY(Value: Double);
begin
  DefaultInterface.Set_MaxY(Value);
end;

function TiImgProperties.Get_Document: iFile;
begin
    Result := DefaultInterface.Document;
end;

procedure TiImgProperties.Set_Document(const Value: iFile);
begin
  DefaultInterface.Set_Document(Value);
end;

function TiImgProperties.Get_Comment: iStringList;
begin
    Result := DefaultInterface.Comment;
end;

procedure TiImgProperties.Set_Comment(const Value: iStringList);
begin
  DefaultInterface.Set_Comment(Value);
end;

function TiImgProperties.Get_Lineage: iStringList;
begin
    Result := DefaultInterface.Lineage;
end;

procedure TiImgProperties.Set_Lineage(const Value: iStringList);
begin
  DefaultInterface.Set_Lineage(Value);
end;

function TiImgProperties.Get_Completeness: iStringList;
begin
    Result := DefaultInterface.Completeness;
end;

procedure TiImgProperties.Set_Completeness(const Value: iStringList);
begin
  DefaultInterface.Set_Completeness(Value);
end;

function TiImgProperties.Get_Consistency: iStringList;
begin
    Result := DefaultInterface.Consistency;
end;

procedure TiImgProperties.Set_Consistency(const Value: iStringList);
begin
  DefaultInterface.Set_Consistency(Value);
end;

function TiImgProperties.Get_PartialScene: WordBool;
begin
    Result := DefaultInterface.PartialScene;
end;

function TiImgProperties.Get_ImageWidth: Integer;
begin
    Result := DefaultInterface.ImageWidth;
end;

procedure TiImgProperties.Set_ImageWidth(Value: Integer);
begin
  DefaultInterface.Set_ImageWidth(Value);
end;

function TiImgProperties.Get_ImageHeight: Integer;
begin
    Result := DefaultInterface.ImageHeight;
end;

procedure TiImgProperties.Set_ImageHeight(Value: Integer);
begin
  DefaultInterface.Set_ImageHeight(Value);
end;

function TiImgProperties.Get_PointXY(X: OleVariant; Y: OleVariant): OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.PointXY[X, Y];
end;

procedure TiImgProperties.Set_PointXY(X: OleVariant; Y: OleVariant; Value: OleVariant);
begin
  DefaultInterface.PointXY[X, Y] := Value;
end;

function TiImgProperties.Get_Cols: Integer;
begin
    Result := DefaultInterface.Cols;
end;

function TiImgProperties.Get_Rows: Integer;
begin
    Result := DefaultInterface.Rows;
end;

function TiImgProperties.Get_Res: Double;
begin
    Result := DefaultInterface.Res;
end;

procedure TiImgProperties.Set_Res(Value: Double);
begin
  DefaultInterface.Set_Res(Value);
end;

function TiImgProperties.Get_MaxValue: Double;
begin
    Result := DefaultInterface.MaxValue;
end;

procedure TiImgProperties.Set_MaxValue(Value: Double);
begin
  DefaultInterface.Set_MaxValue(Value);
end;

function TiImgProperties.Get_MinValue: Double;
begin
    Result := DefaultInterface.MinValue;
end;

procedure TiImgProperties.Set_MinValue(Value: Double);
begin
  DefaultInterface.Set_MinValue(Value);
end;

function TiImgProperties.Get_DataType: iDataTypeConst;
begin
    Result := DefaultInterface.DataType;
end;

procedure TiImgProperties.Set_DataType(Value: iDataTypeConst);
begin
  DefaultInterface.Set_DataType(Value);
end;

function TiImgProperties.Get_ByteOrder: iByteOrder;
begin
    Result := DefaultInterface.ByteOrder;
end;

function TiImgProperties.Get_ScanLineOrientation: iScanlineOrientType;
begin
    Result := DefaultInterface.ScanLineOrientation;
end;

procedure TiImgProperties.Set_ScanLineOrientation(Value: iScanlineOrientType);
begin
  DefaultInterface.Set_ScanLineOrientation(Value);
end;

{$ENDIF}

class function CoiStringList.Create: IiStringList;
begin
  Result := CreateComObject(CLASS_iStringList) as IiStringList;
end;

class function CoiStringList.CreateRemote(const MachineName: string): IiStringList;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_iStringList) as IiStringList;
end;

procedure TiStringList.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{6C94258A-A98E-11D3-A52B-0000E85E2CDE}';
    IntfIID:   '{6C942588-A98E-11D3-A52B-0000E85E2CDE}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TiStringList.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IiStringList;
  end;
end;

procedure TiStringList.ConnectTo(svrIntf: IiStringList);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TiStringList.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TiStringList.GetDefaultInterface: IiStringList;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TiStringList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TiStringListProperties.Create(Self);
{$ENDIF}
end;

destructor TiStringList.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TiStringList.GetServerProperties: TiStringListProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TiStringList.Get_Name(Index: Integer): WideString;
begin
    Result := DefaultInterface.Name[Index];
end;

procedure TiStringList.Set_Name(Index: Integer; const Value: WideString);
  { Warning: The property Name has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Name := Value;
end;

function TiStringList.Get_Capacity: Integer;
begin
    Result := DefaultInterface.Capacity;
end;

function TiStringList.Get_Count: Integer;
begin
    Result := DefaultInterface.Count;
end;

function TiStringList.Get_Sorted: WordBool;
begin
    Result := DefaultInterface.Sorted;
end;

procedure TiStringList.Set_Sorted(Value: WordBool);
begin
  DefaultInterface.Set_Sorted(Value);
end;

function TiStringList.Get_Process: IUnknown;
begin
    Result := DefaultInterface.Process;
end;

procedure TiStringList.Set_Process(const Value: IUnknown);
begin
  DefaultInterface.Set_Process(Value);
end;

function TiStringList.Add(const S: WideString): Integer;
begin
  Result := DefaultInterface.Add(S);
end;

procedure TiStringList.Clear;
begin
  DefaultInterface.Clear;
end;

procedure TiStringList.Delete(Index: Integer);
begin
  DefaultInterface.Delete(Index);
end;

procedure TiStringList.Exchange(Index1: Integer; Index2: Integer);
begin
  DefaultInterface.Exchange(Index1, Index2);
end;

function TiStringList.Find(const S: WideString; var Index: Integer): WordBool;
begin
  Result := DefaultInterface.Find(S, Index);
end;

function TiStringList.IndexOf(const S: WideString): Integer;
begin
  Result := DefaultInterface.IndexOf(S);
end;

procedure TiStringList.Insert(Index: Integer; const S: WideString);
begin
  DefaultInterface.Insert(Index, S);
end;

procedure TiStringList.AssignObject(const Source: iStringList);
begin
  DefaultInterface.AssignObject(Source);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TiStringListProperties.Create(AServer: TiStringList);
begin
  inherited Create;
  FServer := AServer;
end;

function TiStringListProperties.GetDefaultInterface: IiStringList;
begin
  Result := FServer.DefaultInterface;
end;

function TiStringListProperties.Get_Name(Index: Integer): WideString;
begin
    Result := DefaultInterface.Name[Index];
end;

procedure TiStringListProperties.Set_Name(Index: Integer; const Value: WideString);
  { Warning: The property Name has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Name := Value;
end;

function TiStringListProperties.Get_Capacity: Integer;
begin
    Result := DefaultInterface.Capacity;
end;

function TiStringListProperties.Get_Count: Integer;
begin
    Result := DefaultInterface.Count;
end;

function TiStringListProperties.Get_Sorted: WordBool;
begin
    Result := DefaultInterface.Sorted;
end;

procedure TiStringListProperties.Set_Sorted(Value: WordBool);
begin
  DefaultInterface.Set_Sorted(Value);
end;

function TiStringListProperties.Get_Process: IUnknown;
begin
    Result := DefaultInterface.Process;
end;

procedure TiStringListProperties.Set_Process(const Value: IUnknown);
begin
  DefaultInterface.Set_Process(Value);
end;

{$ENDIF}

class function CoiScalar.Create: IiScalar;
begin
  Result := CreateComObject(CLASS_iScalar) as IiScalar;
end;

class function CoiScalar.CreateRemote(const MachineName: string): IiScalar;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_iScalar) as IiScalar;
end;

procedure TiScalar.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{6C942594-A98E-11D3-A52B-0000E85E2CDE}';
    IntfIID:   '{6C942592-A98E-11D3-A52B-0000E85E2CDE}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TiScalar.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IiScalar;
  end;
end;

procedure TiScalar.ConnectTo(svrIntf: IiScalar);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TiScalar.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TiScalar.GetDefaultInterface: IiScalar;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TiScalar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TiScalarProperties.Create(Self);
{$ENDIF}
end;

destructor TiScalar.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TiScalar.GetServerProperties: TiScalarProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TiScalar.Get_CheckStatus: Byte;
begin
    Result := DefaultInterface.CheckStatus;
end;

procedure TiScalar.Set_CheckStatus(Value: Byte);
begin
  DefaultInterface.Set_CheckStatus(Value);
end;

function TiScalar.Get_Empty: WordBool;
begin
    Result := DefaultInterface.Empty;
end;

procedure TiScalar.Set_Empty(Value: WordBool);
begin
  DefaultInterface.Set_Empty(Value);
end;

function TiScalar.Get_Changed: WordBool;
begin
    Result := DefaultInterface.Changed;
end;

procedure TiScalar.Set_Changed(Value: WordBool);
begin
  DefaultInterface.Set_Changed(Value);
end;

function TiScalar.Get_Error: WideString;
begin
    Result := DefaultInterface.Error;
end;

function TiScalar.Get_ObjectName: WideString;
begin
    Result := DefaultInterface.ObjectName;
end;

function TiScalar.Get_Process: IUnknown;
begin
    Result := DefaultInterface.Process;
end;

procedure TiScalar.Set_Process(const Value: IUnknown);
begin
  DefaultInterface.Set_Process(Value);
end;

function TiScalar.Get_DataHandle: Integer;
begin
    Result := DefaultInterface.DataHandle;
end;

function TiScalar.Get_Status: WideString;
begin
    Result := DefaultInterface.Status;
end;

function TiScalar.Get_Processing: WordBool;
begin
    Result := DefaultInterface.Processing;
end;

function TiScalar.Get_PercentDone: Byte;
begin
    Result := DefaultInterface.PercentDone;
end;

function TiScalar.Get_Name: WideString;
begin
    Result := DefaultInterface.Name;
end;

procedure TiScalar.Set_Name(const Value: WideString);
  { Warning: The property Name has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Name := Value;
end;

function TiScalar.Get_Value: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.Value;
end;

procedure TiScalar.Set_Value(Value: OleVariant);
begin
  DefaultInterface.Set_Value(Value);
end;

function TiScalar.Get_DataType: iDataTypeConst;
begin
    Result := DefaultInterface.DataType;
end;

procedure TiScalar.Set_DataType(Value: iDataTypeConst);
begin
  DefaultInterface.Set_DataType(Value);
end;

function TiScalar.ArrayOfVar(SourceArray: OleVariant): OleVariant;
begin
  Result := DefaultInterface.ArrayOfVar(SourceArray);
end;

procedure TiScalar.AssignObject(const Source: iData);
begin
  DefaultInterface.AssignObject(Source);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TiScalarProperties.Create(AServer: TiScalar);
begin
  inherited Create;
  FServer := AServer;
end;

function TiScalarProperties.GetDefaultInterface: IiScalar;
begin
  Result := FServer.DefaultInterface;
end;

function TiScalarProperties.Get_CheckStatus: Byte;
begin
    Result := DefaultInterface.CheckStatus;
end;

procedure TiScalarProperties.Set_CheckStatus(Value: Byte);
begin
  DefaultInterface.Set_CheckStatus(Value);
end;

function TiScalarProperties.Get_Empty: WordBool;
begin
    Result := DefaultInterface.Empty;
end;

procedure TiScalarProperties.Set_Empty(Value: WordBool);
begin
  DefaultInterface.Set_Empty(Value);
end;

function TiScalarProperties.Get_Changed: WordBool;
begin
    Result := DefaultInterface.Changed;
end;

procedure TiScalarProperties.Set_Changed(Value: WordBool);
begin
  DefaultInterface.Set_Changed(Value);
end;

function TiScalarProperties.Get_Error: WideString;
begin
    Result := DefaultInterface.Error;
end;

function TiScalarProperties.Get_ObjectName: WideString;
begin
    Result := DefaultInterface.ObjectName;
end;

function TiScalarProperties.Get_Process: IUnknown;
begin
    Result := DefaultInterface.Process;
end;

procedure TiScalarProperties.Set_Process(const Value: IUnknown);
begin
  DefaultInterface.Set_Process(Value);
end;

function TiScalarProperties.Get_DataHandle: Integer;
begin
    Result := DefaultInterface.DataHandle;
end;

function TiScalarProperties.Get_Status: WideString;
begin
    Result := DefaultInterface.Status;
end;

function TiScalarProperties.Get_Processing: WordBool;
begin
    Result := DefaultInterface.Processing;
end;

function TiScalarProperties.Get_PercentDone: Byte;
begin
    Result := DefaultInterface.PercentDone;
end;

function TiScalarProperties.Get_Name: WideString;
begin
    Result := DefaultInterface.Name;
end;

procedure TiScalarProperties.Set_Name(const Value: WideString);
  { Warning: The property Name has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Name := Value;
end;

function TiScalarProperties.Get_Value: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.Value;
end;

procedure TiScalarProperties.Set_Value(Value: OleVariant);
begin
  DefaultInterface.Set_Value(Value);
end;

function TiScalarProperties.Get_DataType: iDataTypeConst;
begin
    Result := DefaultInterface.DataType;
end;

procedure TiScalarProperties.Set_DataType(Value: iDataTypeConst);
begin
  DefaultInterface.Set_DataType(Value);
end;

{$ENDIF}

class function CoiVectorial.Create: IiVectorial;
begin
  Result := CreateComObject(CLASS_iVectorial) as IiVectorial;
end;

class function CoiVectorial.CreateRemote(const MachineName: string): IiVectorial;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_iVectorial) as IiVectorial;
end;

procedure TiVectorial.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{6C942598-A98E-11D3-A52B-0000E85E2CDE}';
    IntfIID:   '{6C942596-A98E-11D3-A52B-0000E85E2CDE}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TiVectorial.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IiVectorial;
  end;
end;

procedure TiVectorial.ConnectTo(svrIntf: IiVectorial);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TiVectorial.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TiVectorial.GetDefaultInterface: IiVectorial;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TiVectorial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TiVectorialProperties.Create(Self);
{$ENDIF}
end;

destructor TiVectorial.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TiVectorial.GetServerProperties: TiVectorialProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TiVectorial.Get_CheckStatus: Byte;
begin
    Result := DefaultInterface.CheckStatus;
end;

procedure TiVectorial.Set_CheckStatus(Value: Byte);
begin
  DefaultInterface.Set_CheckStatus(Value);
end;

function TiVectorial.Get_Empty: WordBool;
begin
    Result := DefaultInterface.Empty;
end;

procedure TiVectorial.Set_Empty(Value: WordBool);
begin
  DefaultInterface.Set_Empty(Value);
end;

function TiVectorial.Get_Changed: WordBool;
begin
    Result := DefaultInterface.Changed;
end;

procedure TiVectorial.Set_Changed(Value: WordBool);
begin
  DefaultInterface.Set_Changed(Value);
end;

function TiVectorial.Get_Error: WideString;
begin
    Result := DefaultInterface.Error;
end;

function TiVectorial.Get_ObjectName: WideString;
begin
    Result := DefaultInterface.ObjectName;
end;

function TiVectorial.Get_Process: IUnknown;
begin
    Result := DefaultInterface.Process;
end;

procedure TiVectorial.Set_Process(const Value: IUnknown);
begin
  DefaultInterface.Set_Process(Value);
end;

function TiVectorial.Get_DataHandle: Integer;
begin
    Result := DefaultInterface.DataHandle;
end;

function TiVectorial.Get_Status: WideString;
begin
    Result := DefaultInterface.Status;
end;

function TiVectorial.Get_Processing: WordBool;
begin
    Result := DefaultInterface.Processing;
end;

function TiVectorial.Get_PercentDone: Byte;
begin
    Result := DefaultInterface.PercentDone;
end;

function TiVectorial.Get_Title: WideString;
begin
    Result := DefaultInterface.Title;
end;

procedure TiVectorial.Set_Title(const Value: WideString);
  { Warning: The property Title has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Title := Value;
end;

function TiVectorial.Get_Legend: iLegend;
begin
    Result := DefaultInterface.Legend;
end;

procedure TiVectorial.Set_Legend(const Value: iLegend);
begin
  DefaultInterface.Set_Legend(Value);
end;

function TiVectorial.Get_hDC: Integer;
begin
    Result := DefaultInterface.hDC;
end;

function TiVectorial.Get_MinX: Double;
begin
    Result := DefaultInterface.MinX;
end;

procedure TiVectorial.Set_MinX(Value: Double);
begin
  DefaultInterface.Set_MinX(Value);
end;

function TiVectorial.Get_MaxX: Double;
begin
    Result := DefaultInterface.MaxX;
end;

procedure TiVectorial.Set_MaxX(Value: Double);
begin
  DefaultInterface.Set_MaxX(Value);
end;

function TiVectorial.Get_MinY: Double;
begin
    Result := DefaultInterface.MinY;
end;

procedure TiVectorial.Set_MinY(Value: Double);
begin
  DefaultInterface.Set_MinY(Value);
end;

function TiVectorial.Get_MaxY: Double;
begin
    Result := DefaultInterface.MaxY;
end;

procedure TiVectorial.Set_MaxY(Value: Double);
begin
  DefaultInterface.Set_MaxY(Value);
end;

function TiVectorial.Get_Document: iFile;
begin
    Result := DefaultInterface.Document;
end;

procedure TiVectorial.Set_Document(const Value: iFile);
begin
  DefaultInterface.Set_Document(Value);
end;

function TiVectorial.Get_Comment: iStringList;
begin
    Result := DefaultInterface.Comment;
end;

procedure TiVectorial.Set_Comment(const Value: iStringList);
begin
  DefaultInterface.Set_Comment(Value);
end;

function TiVectorial.Get_Lineage: iStringList;
begin
    Result := DefaultInterface.Lineage;
end;

procedure TiVectorial.Set_Lineage(const Value: iStringList);
begin
  DefaultInterface.Set_Lineage(Value);
end;

function TiVectorial.Get_Completeness: iStringList;
begin
    Result := DefaultInterface.Completeness;
end;

procedure TiVectorial.Set_Completeness(const Value: iStringList);
begin
  DefaultInterface.Set_Completeness(Value);
end;

function TiVectorial.Get_Consistency: iStringList;
begin
    Result := DefaultInterface.Consistency;
end;

procedure TiVectorial.Set_Consistency(const Value: iStringList);
begin
  DefaultInterface.Set_Consistency(Value);
end;

function TiVectorial.Get_PartialScene: WordBool;
begin
    Result := DefaultInterface.PartialScene;
end;

function TiVectorial.Get_ImageWidth: Integer;
begin
    Result := DefaultInterface.ImageWidth;
end;

procedure TiVectorial.Set_ImageWidth(Value: Integer);
begin
  DefaultInterface.Set_ImageWidth(Value);
end;

function TiVectorial.Get_ImageHeight: Integer;
begin
    Result := DefaultInterface.ImageHeight;
end;

procedure TiVectorial.Set_ImageHeight(Value: Integer);
begin
  DefaultInterface.Set_ImageHeight(Value);
end;

function TiVectorial.Get_PointXY(X: OleVariant; Y: OleVariant): OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.PointXY[X, Y];
end;

procedure TiVectorial.Set_PointXY(X: OleVariant; Y: OleVariant; Value: OleVariant);
begin
  DefaultInterface.PointXY[X, Y] := Value;
end;

function TiVectorial.Get_Count: Integer;
begin
    Result := DefaultInterface.Count;
end;

function TiVectorial.Get_Value(RecordNumber: Integer): OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.Value[RecordNumber];
end;

procedure TiVectorial.Set_Value(RecordNumber: Integer; Value: OleVariant);
begin
  DefaultInterface.Value[RecordNumber] := Value;
end;

function TiVectorial.Get_RecordPointCount(RecordNumber: Integer): Integer;
begin
    Result := DefaultInterface.RecordPointCount[RecordNumber];
end;

procedure TiVectorial.Set_RecordPointCount(RecordNumber: Integer; Value: Integer);
begin
  DefaultInterface.RecordPointCount[RecordNumber] := Value;
end;

function TiVectorial.Get_FileType: iShapeType;
begin
    Result := DefaultInterface.FileType;
end;

function TiVectorial.Get_IdType: iDataTypeConst;
begin
    Result := DefaultInterface.IdType;
end;

function TiVectorial.Get_MaxSize: Integer;
begin
    Result := DefaultInterface.MaxSize;
end;

procedure TiVectorial.Set_MaxSize(Value: Integer);
begin
  DefaultInterface.Set_MaxSize(Value);
end;

function TiVectorial.Get_Val: iVal;
begin
    Result := DefaultInterface.Val;
end;

procedure TiVectorial.Set_Val(const Value: iVal);
begin
  DefaultInterface.Set_Val(Value);
end;

function TiVectorial.Get_RecordColor(RecordNumber: Integer): Integer;
begin
    Result := DefaultInterface.RecordColor[RecordNumber];
end;

function TiVectorial.Get_Paint: iPaint;
begin
    Result := DefaultInterface.Paint;
end;

procedure TiVectorial.Set_Paint(const Value: iPaint);
begin
  DefaultInterface.Set_Paint(Value);
end;

function TiVectorial.Get_DrawLabels: WordBool;
begin
    Result := DefaultInterface.DrawLabels;
end;

procedure TiVectorial.Set_DrawLabels(Value: WordBool);
begin
  DefaultInterface.Set_DrawLabels(Value);
end;

function TiVectorial.Get_RecordBox(RecordNumber: Integer; Position: Integer): OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.RecordBox[RecordNumber, Position];
end;

function TiVectorial.Get_DisabledRecord(RecordNumber: Integer): WordBool;
begin
    Result := DefaultInterface.DisabledRecord[RecordNumber];
end;

procedure TiVectorial.Set_DisabledRecord(RecordNumber: Integer; Value: WordBool);
begin
  DefaultInterface.DisabledRecord[RecordNumber] := Value;
end;

function TiVectorial.Get_Color(RecordNumber: Integer): WideString;
begin
    Result := DefaultInterface.Color[RecordNumber];
end;

procedure TiVectorial.Set_Color(RecordNumber: Integer; const Value: WideString);
  { Warning: The property Color has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Color := Value;
end;

function TiVectorial.Get_Selected(RecordNumber: Integer): WordBool;
begin
    Result := DefaultInterface.Selected[RecordNumber];
end;

procedure TiVectorial.Set_Selected(RecordNumber: Integer; Value: WordBool);
begin
  DefaultInterface.Selected[RecordNumber] := Value;
end;

procedure TiVectorial.Set_SelectAll(Param1: WordBool);
begin
  DefaultInterface.Set_SelectAll(Param1);
end;

function TiVectorial.Get_LabelColor(RecordNumber: Integer): WideString;
begin
    Result := DefaultInterface.LabelColor[RecordNumber];
end;

procedure TiVectorial.Set_LabelColor(RecordNumber: Integer; const Value: WideString);
  { Warning: The property LabelColor has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.LabelColor := Value;
end;

function TiVectorial.Get_LabelStyle(RecordNumber: Integer): WideString;
begin
    Result := DefaultInterface.LabelStyle[RecordNumber];
end;

procedure TiVectorial.Set_LabelStyle(RecordNumber: Integer; const Value: WideString);
  { Warning: The property LabelStyle has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.LabelStyle := Value;
end;

function TiVectorial.Get_LabelSize(RecordNumber: Integer): Smallint;
begin
    Result := DefaultInterface.LabelSize[RecordNumber];
end;

procedure TiVectorial.Set_LabelSize(RecordNumber: Integer; Value: Smallint);
begin
  DefaultInterface.LabelSize[RecordNumber] := Value;
end;

function TiVectorial.Get_LabelFontName(RecordNumber: Integer): WideString;
begin
    Result := DefaultInterface.LabelFontName[RecordNumber];
end;

procedure TiVectorial.Set_LabelFontName(RecordNumber: Integer; const Value: WideString);
  { Warning: The property LabelFontName has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.LabelFontName := Value;
end;

function TiVectorial.Get_PenColor(RecordNumber: Integer): WideString;
begin
    Result := DefaultInterface.PenColor[RecordNumber];
end;

procedure TiVectorial.Set_PenColor(RecordNumber: Integer; const Value: WideString);
  { Warning: The property PenColor has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.PenColor := Value;
end;

function TiVectorial.Get_Parts(RecordNumber: Integer; PartNumber: Integer): Integer;
begin
    Result := DefaultInterface.Parts[RecordNumber, PartNumber];
end;

procedure TiVectorial.Set_Parts(RecordNumber: Integer; PartNumber: Integer; Value: Integer);
begin
  DefaultInterface.Parts[RecordNumber, PartNumber] := Value;
end;

function TiVectorial.ArrayOfVar(SourceArray: OleVariant): OleVariant;
begin
  Result := DefaultInterface.ArrayOfVar(SourceArray);
end;

procedure TiVectorial.AssignObject(const Source: iData);
begin
  DefaultInterface.AssignObject(Source);
end;

procedure TiVectorial.PasteGeoRefs(const PassVar: iGeoData);
begin
  DefaultInterface.PasteGeoRefs(PassVar);
end;

function TiVectorial.Open: WordBool;
begin
  Result := DefaultInterface.Open;
end;

procedure TiVectorial.Save;
begin
  DefaultInterface.Save;
end;

function TiVectorial.Terminate: WordBool;
begin
  Result := DefaultInterface.Terminate;
end;

procedure TiVectorial.SaveHeader;
begin
  DefaultInterface.SaveHeader;
end;

function TiVectorial.OpenHeader: WordBool;
begin
  Result := DefaultInterface.OpenHeader;
end;

function TiVectorial.OpenWindow(X1: OleVariant; Y1: OleVariant; X2: OleVariant; Y2: OleVariant; 
                                Step: Smallint): WordBool;
begin
  Result := DefaultInterface.OpenWindow(X1, Y1, X2, Y2, Step);
end;

function TiVectorial.OpenSample(Step: Smallint): WordBool;
begin
  Result := DefaultInterface.OpenSample(Step);
end;

procedure TiVectorial.PasteHDC(BitmapHDC: Integer; Width: Integer; Height: Integer);
begin
  DefaultInterface.PasteHDC(BitmapHDC, Width, Height);
end;

procedure TiVectorial.Refresh;
begin
  DefaultInterface.Refresh;
end;

procedure TiVectorial.ClearBitmap;
begin
  DefaultInterface.ClearBitmap;
end;

function TiVectorial.StreamMapAs(StreamType: iStreamType): OleVariant;
begin
  Result := DefaultInterface.StreamMapAs(StreamType);
end;

procedure TiVectorial.PaintPoint(X: OleVariant; Y: OleVariant; Radius: OleVariant; 
                                 const Color: WideString);
begin
  DefaultInterface.PaintPoint(X, Y, Radius, Color);
end;

procedure TiVectorial.PaintLine(X1: OleVariant; Y1: OleVariant; X2: OleVariant; Y2: OleVariant; 
                                Width: OleVariant; const Color: WideString);
begin
  DefaultInterface.PaintLine(X1, Y1, X2, Y2, Width, Color);
end;

procedure TiVectorial.PaintPolygon(Points: OleVariant; LineWidth: Integer; const Color: WideString; 
                                   BrushStyle: iBrushStyle; IsGeographic: WordBool);
begin
  DefaultInterface.PaintPolygon(Points, LineWidth, Color, BrushStyle, IsGeographic);
end;

procedure TiVectorial.PaintText(X: OleVariant; Y: OleVariant; const Text: WideString; 
                                const FontName: WideString; Size: Integer; const Style: WideString; 
                                const Color: WideString);
begin
  DefaultInterface.PaintText(X, Y, Text, FontName, Size, Style, Color);
end;

function TiVectorial.StreamAs(StreamType: iStreamType): OleVariant;
begin
  Result := DefaultInterface.StreamAs(StreamType);
end;

procedure TiVectorial.Draw(Left: Integer; Top: Integer; Zoom: Single; PictureHandle: Integer);
begin
  DefaultInterface.Draw(Left, Top, Zoom, PictureHandle);
end;

procedure TiVectorial.DrawMap(Zoom: Single; PictureHandle: Integer);
begin
  DefaultInterface.DrawMap(Zoom, PictureHandle);
end;

procedure TiVectorial.CopyMap(Zoom: Single);
begin
  DefaultInterface.CopyMap(Zoom);
end;

procedure TiVectorial.Copy;
begin
  DefaultInterface.Copy;
end;

procedure TiVectorial.StretchDraw(hDC: Integer; X1: Double; Y1: Double; X2: Double; Y2: Double; 
                                  Left: Integer; Top: Integer; Right: Integer; Bottom: Integer);
begin
  DefaultInterface.StretchDraw(hDC, X1, Y1, X2, Y2, Left, Top, Right, Bottom);
end;

function TiVectorial.GetDataBuffer(out DataOut: OleVariant): Integer;
begin
  Result := DefaultInterface.GetDataBuffer(DataOut);
end;

procedure TiVectorial.SetDataBuffer(DataIn: OleVariant);
begin
  DefaultInterface.SetDataBuffer(DataIn);
end;

function TiVectorial.RetrieveBitmap(Source: OleVariant; TimeOut_Sec: Integer; X1: Integer; 
                                    Y1: Integer; X2: Integer; Y2: Integer; Transparency: Byte): Integer;
begin
  Result := DefaultInterface.RetrieveBitmap(Source, TimeOut_Sec, X1, Y1, X2, Y2, Transparency);
end;

procedure TiVectorial.DrawObject(hDC: Integer; RecordNumber: Integer; X: Integer; Y: Integer);
begin
  DefaultInterface.DrawObject(hDC, RecordNumber, X, Y, EmptyParam);
end;

procedure TiVectorial.DrawObject(hDC: Integer; RecordNumber: Integer; X: Integer; Y: Integer; 
                                 Color: OleVariant);
begin
  DefaultInterface.DrawObject(hDC, RecordNumber, X, Y, Color);
end;

procedure TiVectorial.AddRecordPoints(ObjectData: OleVariant; Id: Single; RecordNumber: Integer);
begin
  DefaultInterface.AddRecordPoints(ObjectData, Id, RecordNumber);
end;

procedure TiVectorial.New(const Name: WideString; ObjectsType: iShapeType; IdType: iDataTypeConst);
begin
  DefaultInterface.New(Name, ObjectsType, IdType);
end;

function TiVectorial.GetRecordBuffer(RecordNumber: Integer): OleVariant;
begin
  Result := DefaultInterface.GetRecordBuffer(RecordNumber);
end;

function TiVectorial.IndexOf(Value: OleVariant): OleVariant;
begin
  Result := DefaultInterface.IndexOf(Value);
end;

function TiVectorial.IsPointInPolygon(PolygonIndex: Integer; X: Single; Y: Single): WordBool;
begin
  Result := DefaultInterface.IsPointInPolygon(PolygonIndex, X, Y);
end;

procedure TiVectorial.Insert(ObjectData: OleVariant; Position: Integer; Id: Integer);
begin
  DefaultInterface.Insert(ObjectData, Position, Id);
end;

procedure TiVectorial.Exchange(Pos1: Integer; Pos2: Integer);
begin
  DefaultInterface.Exchange(Pos1, Pos2);
end;

procedure TiVectorial.Delete(RecordNumber: Integer);
begin
  DefaultInterface.Delete(RecordNumber);
end;

procedure TiVectorial.DrawSquare(hDC: Integer; X1: Double; Y1: Double; X2: Double; Y2: Double; 
                                 X: Integer; Y: Integer; Color: Integer; Width: Integer);
begin
  DefaultInterface.DrawSquare(hDC, X1, Y1, X2, Y2, X, Y, Color, Width);
end;

function TiVectorial.GetRecordPoints(RecordNumber: Integer): OleVariant;
begin
  Result := DefaultInterface.GetRecordPoints(RecordNumber);
end;

function TiVectorial.SelectString(const QueryString: WideString; AddToSelection: WordBool): WordBool;
begin
  Result := DefaultInterface.SelectString(QueryString, AddToSelection);
end;

procedure TiVectorial.SetRecordPoints(RecordNumber: Integer; Value: OleVariant);
begin
  DefaultInterface.SetRecordPoints(RecordNumber, Value);
end;

function TiVectorial.GetDisabledRecords: OleVariant;
begin
  Result := DefaultInterface.GetDisabledRecords;
end;

procedure TiVectorial.SetDisabledRecords(Value: OleVariant);
begin
  DefaultInterface.SetDisabledRecords(Value);
end;

function TiVectorial.GetSelectedRecords: OleVariant;
begin
  Result := DefaultInterface.GetSelectedRecords;
end;

procedure TiVectorial.SetSelectedRecords(Value: OleVariant);
begin
  DefaultInterface.SetSelectedRecords(Value);
end;

procedure TiVectorial.AddRecordBuffer(ObjectData: OleVariant; Id: Single; Position: Integer);
begin
  DefaultInterface.AddRecordBuffer(ObjectData, Id, Position);
end;

procedure TiVectorial.DrawRecord(hDC: Integer; ObjectNumber: Integer; X: Integer; Y: Integer; 
                                 Width: Integer; Height: Integer; const Color: WideString);
begin
  DefaultInterface.DrawRecord(hDC, ObjectNumber, X, Y, Width, Height, Color);
end;

procedure TiVectorial.SetLabelProperties(const FontName: WideString; const FontStyle: WideString; 
                                         const FontColor: WideString; FontSize: Integer);
begin
  DefaultInterface.SetLabelProperties(FontName, FontStyle, FontColor, FontSize);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TiVectorialProperties.Create(AServer: TiVectorial);
begin
  inherited Create;
  FServer := AServer;
end;

function TiVectorialProperties.GetDefaultInterface: IiVectorial;
begin
  Result := FServer.DefaultInterface;
end;

function TiVectorialProperties.Get_CheckStatus: Byte;
begin
    Result := DefaultInterface.CheckStatus;
end;

procedure TiVectorialProperties.Set_CheckStatus(Value: Byte);
begin
  DefaultInterface.Set_CheckStatus(Value);
end;

function TiVectorialProperties.Get_Empty: WordBool;
begin
    Result := DefaultInterface.Empty;
end;

procedure TiVectorialProperties.Set_Empty(Value: WordBool);
begin
  DefaultInterface.Set_Empty(Value);
end;

function TiVectorialProperties.Get_Changed: WordBool;
begin
    Result := DefaultInterface.Changed;
end;

procedure TiVectorialProperties.Set_Changed(Value: WordBool);
begin
  DefaultInterface.Set_Changed(Value);
end;

function TiVectorialProperties.Get_Error: WideString;
begin
    Result := DefaultInterface.Error;
end;

function TiVectorialProperties.Get_ObjectName: WideString;
begin
    Result := DefaultInterface.ObjectName;
end;

function TiVectorialProperties.Get_Process: IUnknown;
begin
    Result := DefaultInterface.Process;
end;

procedure TiVectorialProperties.Set_Process(const Value: IUnknown);
begin
  DefaultInterface.Set_Process(Value);
end;

function TiVectorialProperties.Get_DataHandle: Integer;
begin
    Result := DefaultInterface.DataHandle;
end;

function TiVectorialProperties.Get_Status: WideString;
begin
    Result := DefaultInterface.Status;
end;

function TiVectorialProperties.Get_Processing: WordBool;
begin
    Result := DefaultInterface.Processing;
end;

function TiVectorialProperties.Get_PercentDone: Byte;
begin
    Result := DefaultInterface.PercentDone;
end;

function TiVectorialProperties.Get_Title: WideString;
begin
    Result := DefaultInterface.Title;
end;

procedure TiVectorialProperties.Set_Title(const Value: WideString);
  { Warning: The property Title has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Title := Value;
end;

function TiVectorialProperties.Get_Legend: iLegend;
begin
    Result := DefaultInterface.Legend;
end;

procedure TiVectorialProperties.Set_Legend(const Value: iLegend);
begin
  DefaultInterface.Set_Legend(Value);
end;

function TiVectorialProperties.Get_hDC: Integer;
begin
    Result := DefaultInterface.hDC;
end;

function TiVectorialProperties.Get_MinX: Double;
begin
    Result := DefaultInterface.MinX;
end;

procedure TiVectorialProperties.Set_MinX(Value: Double);
begin
  DefaultInterface.Set_MinX(Value);
end;

function TiVectorialProperties.Get_MaxX: Double;
begin
    Result := DefaultInterface.MaxX;
end;

procedure TiVectorialProperties.Set_MaxX(Value: Double);
begin
  DefaultInterface.Set_MaxX(Value);
end;

function TiVectorialProperties.Get_MinY: Double;
begin
    Result := DefaultInterface.MinY;
end;

procedure TiVectorialProperties.Set_MinY(Value: Double);
begin
  DefaultInterface.Set_MinY(Value);
end;

function TiVectorialProperties.Get_MaxY: Double;
begin
    Result := DefaultInterface.MaxY;
end;

procedure TiVectorialProperties.Set_MaxY(Value: Double);
begin
  DefaultInterface.Set_MaxY(Value);
end;

function TiVectorialProperties.Get_Document: iFile;
begin
    Result := DefaultInterface.Document;
end;

procedure TiVectorialProperties.Set_Document(const Value: iFile);
begin
  DefaultInterface.Set_Document(Value);
end;

function TiVectorialProperties.Get_Comment: iStringList;
begin
    Result := DefaultInterface.Comment;
end;

procedure TiVectorialProperties.Set_Comment(const Value: iStringList);
begin
  DefaultInterface.Set_Comment(Value);
end;

function TiVectorialProperties.Get_Lineage: iStringList;
begin
    Result := DefaultInterface.Lineage;
end;

procedure TiVectorialProperties.Set_Lineage(const Value: iStringList);
begin
  DefaultInterface.Set_Lineage(Value);
end;

function TiVectorialProperties.Get_Completeness: iStringList;
begin
    Result := DefaultInterface.Completeness;
end;

procedure TiVectorialProperties.Set_Completeness(const Value: iStringList);
begin
  DefaultInterface.Set_Completeness(Value);
end;

function TiVectorialProperties.Get_Consistency: iStringList;
begin
    Result := DefaultInterface.Consistency;
end;

procedure TiVectorialProperties.Set_Consistency(const Value: iStringList);
begin
  DefaultInterface.Set_Consistency(Value);
end;

function TiVectorialProperties.Get_PartialScene: WordBool;
begin
    Result := DefaultInterface.PartialScene;
end;

function TiVectorialProperties.Get_ImageWidth: Integer;
begin
    Result := DefaultInterface.ImageWidth;
end;

procedure TiVectorialProperties.Set_ImageWidth(Value: Integer);
begin
  DefaultInterface.Set_ImageWidth(Value);
end;

function TiVectorialProperties.Get_ImageHeight: Integer;
begin
    Result := DefaultInterface.ImageHeight;
end;

procedure TiVectorialProperties.Set_ImageHeight(Value: Integer);
begin
  DefaultInterface.Set_ImageHeight(Value);
end;

function TiVectorialProperties.Get_PointXY(X: OleVariant; Y: OleVariant): OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.PointXY[X, Y];
end;

procedure TiVectorialProperties.Set_PointXY(X: OleVariant; Y: OleVariant; Value: OleVariant);
begin
  DefaultInterface.PointXY[X, Y] := Value;
end;

function TiVectorialProperties.Get_Count: Integer;
begin
    Result := DefaultInterface.Count;
end;

function TiVectorialProperties.Get_Value(RecordNumber: Integer): OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.Value[RecordNumber];
end;

procedure TiVectorialProperties.Set_Value(RecordNumber: Integer; Value: OleVariant);
begin
  DefaultInterface.Value[RecordNumber] := Value;
end;

function TiVectorialProperties.Get_RecordPointCount(RecordNumber: Integer): Integer;
begin
    Result := DefaultInterface.RecordPointCount[RecordNumber];
end;

procedure TiVectorialProperties.Set_RecordPointCount(RecordNumber: Integer; Value: Integer);
begin
  DefaultInterface.RecordPointCount[RecordNumber] := Value;
end;

function TiVectorialProperties.Get_FileType: iShapeType;
begin
    Result := DefaultInterface.FileType;
end;

function TiVectorialProperties.Get_IdType: iDataTypeConst;
begin
    Result := DefaultInterface.IdType;
end;

function TiVectorialProperties.Get_MaxSize: Integer;
begin
    Result := DefaultInterface.MaxSize;
end;

procedure TiVectorialProperties.Set_MaxSize(Value: Integer);
begin
  DefaultInterface.Set_MaxSize(Value);
end;

function TiVectorialProperties.Get_Val: iVal;
begin
    Result := DefaultInterface.Val;
end;

procedure TiVectorialProperties.Set_Val(const Value: iVal);
begin
  DefaultInterface.Set_Val(Value);
end;

function TiVectorialProperties.Get_RecordColor(RecordNumber: Integer): Integer;
begin
    Result := DefaultInterface.RecordColor[RecordNumber];
end;

function TiVectorialProperties.Get_Paint: iPaint;
begin
    Result := DefaultInterface.Paint;
end;

procedure TiVectorialProperties.Set_Paint(const Value: iPaint);
begin
  DefaultInterface.Set_Paint(Value);
end;

function TiVectorialProperties.Get_DrawLabels: WordBool;
begin
    Result := DefaultInterface.DrawLabels;
end;

procedure TiVectorialProperties.Set_DrawLabels(Value: WordBool);
begin
  DefaultInterface.Set_DrawLabels(Value);
end;

function TiVectorialProperties.Get_RecordBox(RecordNumber: Integer; Position: Integer): OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.RecordBox[RecordNumber, Position];
end;

function TiVectorialProperties.Get_DisabledRecord(RecordNumber: Integer): WordBool;
begin
    Result := DefaultInterface.DisabledRecord[RecordNumber];
end;

procedure TiVectorialProperties.Set_DisabledRecord(RecordNumber: Integer; Value: WordBool);
begin
  DefaultInterface.DisabledRecord[RecordNumber] := Value;
end;

function TiVectorialProperties.Get_Color(RecordNumber: Integer): WideString;
begin
    Result := DefaultInterface.Color[RecordNumber];
end;

procedure TiVectorialProperties.Set_Color(RecordNumber: Integer; const Value: WideString);
  { Warning: The property Color has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Color := Value;
end;

function TiVectorialProperties.Get_Selected(RecordNumber: Integer): WordBool;
begin
    Result := DefaultInterface.Selected[RecordNumber];
end;

procedure TiVectorialProperties.Set_Selected(RecordNumber: Integer; Value: WordBool);
begin
  DefaultInterface.Selected[RecordNumber] := Value;
end;

procedure TiVectorialProperties.Set_SelectAll(Param1: WordBool);
begin
  DefaultInterface.Set_SelectAll(Param1);
end;

function TiVectorialProperties.Get_LabelColor(RecordNumber: Integer): WideString;
begin
    Result := DefaultInterface.LabelColor[RecordNumber];
end;

procedure TiVectorialProperties.Set_LabelColor(RecordNumber: Integer; const Value: WideString);
  { Warning: The property LabelColor has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.LabelColor := Value;
end;

function TiVectorialProperties.Get_LabelStyle(RecordNumber: Integer): WideString;
begin
    Result := DefaultInterface.LabelStyle[RecordNumber];
end;

procedure TiVectorialProperties.Set_LabelStyle(RecordNumber: Integer; const Value: WideString);
  { Warning: The property LabelStyle has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.LabelStyle := Value;
end;

function TiVectorialProperties.Get_LabelSize(RecordNumber: Integer): Smallint;
begin
    Result := DefaultInterface.LabelSize[RecordNumber];
end;

procedure TiVectorialProperties.Set_LabelSize(RecordNumber: Integer; Value: Smallint);
begin
  DefaultInterface.LabelSize[RecordNumber] := Value;
end;

function TiVectorialProperties.Get_LabelFontName(RecordNumber: Integer): WideString;
begin
    Result := DefaultInterface.LabelFontName[RecordNumber];
end;

procedure TiVectorialProperties.Set_LabelFontName(RecordNumber: Integer; const Value: WideString);
  { Warning: The property LabelFontName has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.LabelFontName := Value;
end;

function TiVectorialProperties.Get_PenColor(RecordNumber: Integer): WideString;
begin
    Result := DefaultInterface.PenColor[RecordNumber];
end;

procedure TiVectorialProperties.Set_PenColor(RecordNumber: Integer; const Value: WideString);
  { Warning: The property PenColor has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.PenColor := Value;
end;

function TiVectorialProperties.Get_Parts(RecordNumber: Integer; PartNumber: Integer): Integer;
begin
    Result := DefaultInterface.Parts[RecordNumber, PartNumber];
end;

procedure TiVectorialProperties.Set_Parts(RecordNumber: Integer; PartNumber: Integer; Value: Integer);
begin
  DefaultInterface.Parts[RecordNumber, PartNumber] := Value;
end;

{$ENDIF}

class function CoiVec.Create: IiVec;
begin
  Result := CreateComObject(CLASS_iVec) as IiVec;
end;

class function CoiVec.CreateRemote(const MachineName: string): IiVec;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_iVec) as IiVec;
end;

procedure TiVec.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{6C94259E-A98E-11D3-A52B-0000E85E2CDE}';
    IntfIID:   '{6C94259A-A98E-11D3-A52B-0000E85E2CDE}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TiVec.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IiVec;
  end;
end;

procedure TiVec.ConnectTo(svrIntf: IiVec);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TiVec.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TiVec.GetDefaultInterface: IiVec;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TiVec.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TiVecProperties.Create(Self);
{$ENDIF}
end;

destructor TiVec.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TiVec.GetServerProperties: TiVecProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TiVec.Get_CheckStatus: Byte;
begin
    Result := DefaultInterface.CheckStatus;
end;

procedure TiVec.Set_CheckStatus(Value: Byte);
begin
  DefaultInterface.Set_CheckStatus(Value);
end;

function TiVec.Get_Empty: WordBool;
begin
    Result := DefaultInterface.Empty;
end;

procedure TiVec.Set_Empty(Value: WordBool);
begin
  DefaultInterface.Set_Empty(Value);
end;

function TiVec.Get_Changed: WordBool;
begin
    Result := DefaultInterface.Changed;
end;

procedure TiVec.Set_Changed(Value: WordBool);
begin
  DefaultInterface.Set_Changed(Value);
end;

function TiVec.Get_Error: WideString;
begin
    Result := DefaultInterface.Error;
end;

function TiVec.Get_ObjectName: WideString;
begin
    Result := DefaultInterface.ObjectName;
end;

function TiVec.Get_Process: IUnknown;
begin
    Result := DefaultInterface.Process;
end;

procedure TiVec.Set_Process(const Value: IUnknown);
begin
  DefaultInterface.Set_Process(Value);
end;

function TiVec.Get_DataHandle: Integer;
begin
    Result := DefaultInterface.DataHandle;
end;

function TiVec.Get_Status: WideString;
begin
    Result := DefaultInterface.Status;
end;

function TiVec.Get_Processing: WordBool;
begin
    Result := DefaultInterface.Processing;
end;

function TiVec.Get_PercentDone: Byte;
begin
    Result := DefaultInterface.PercentDone;
end;

function TiVec.Get_Title: WideString;
begin
    Result := DefaultInterface.Title;
end;

procedure TiVec.Set_Title(const Value: WideString);
  { Warning: The property Title has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Title := Value;
end;

function TiVec.Get_Legend: iLegend;
begin
    Result := DefaultInterface.Legend;
end;

procedure TiVec.Set_Legend(const Value: iLegend);
begin
  DefaultInterface.Set_Legend(Value);
end;

function TiVec.Get_hDC: Integer;
begin
    Result := DefaultInterface.hDC;
end;

function TiVec.Get_MinX: Double;
begin
    Result := DefaultInterface.MinX;
end;

procedure TiVec.Set_MinX(Value: Double);
begin
  DefaultInterface.Set_MinX(Value);
end;

function TiVec.Get_MaxX: Double;
begin
    Result := DefaultInterface.MaxX;
end;

procedure TiVec.Set_MaxX(Value: Double);
begin
  DefaultInterface.Set_MaxX(Value);
end;

function TiVec.Get_MinY: Double;
begin
    Result := DefaultInterface.MinY;
end;

procedure TiVec.Set_MinY(Value: Double);
begin
  DefaultInterface.Set_MinY(Value);
end;

function TiVec.Get_MaxY: Double;
begin
    Result := DefaultInterface.MaxY;
end;

procedure TiVec.Set_MaxY(Value: Double);
begin
  DefaultInterface.Set_MaxY(Value);
end;

function TiVec.Get_Document: iFile;
begin
    Result := DefaultInterface.Document;
end;

procedure TiVec.Set_Document(const Value: iFile);
begin
  DefaultInterface.Set_Document(Value);
end;

function TiVec.Get_Comment: iStringList;
begin
    Result := DefaultInterface.Comment;
end;

procedure TiVec.Set_Comment(const Value: iStringList);
begin
  DefaultInterface.Set_Comment(Value);
end;

function TiVec.Get_Lineage: iStringList;
begin
    Result := DefaultInterface.Lineage;
end;

procedure TiVec.Set_Lineage(const Value: iStringList);
begin
  DefaultInterface.Set_Lineage(Value);
end;

function TiVec.Get_Completeness: iStringList;
begin
    Result := DefaultInterface.Completeness;
end;

procedure TiVec.Set_Completeness(const Value: iStringList);
begin
  DefaultInterface.Set_Completeness(Value);
end;

function TiVec.Get_Consistency: iStringList;
begin
    Result := DefaultInterface.Consistency;
end;

procedure TiVec.Set_Consistency(const Value: iStringList);
begin
  DefaultInterface.Set_Consistency(Value);
end;

function TiVec.Get_PartialScene: WordBool;
begin
    Result := DefaultInterface.PartialScene;
end;

function TiVec.Get_ImageWidth: Integer;
begin
    Result := DefaultInterface.ImageWidth;
end;

procedure TiVec.Set_ImageWidth(Value: Integer);
begin
  DefaultInterface.Set_ImageWidth(Value);
end;

function TiVec.Get_ImageHeight: Integer;
begin
    Result := DefaultInterface.ImageHeight;
end;

procedure TiVec.Set_ImageHeight(Value: Integer);
begin
  DefaultInterface.Set_ImageHeight(Value);
end;

function TiVec.Get_PointXY(X: OleVariant; Y: OleVariant): OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.PointXY[X, Y];
end;

procedure TiVec.Set_PointXY(X: OleVariant; Y: OleVariant; Value: OleVariant);
begin
  DefaultInterface.PointXY[X, Y] := Value;
end;

function TiVec.Get_Count: Integer;
begin
    Result := DefaultInterface.Count;
end;

function TiVec.Get_Value(RecordNumber: Integer): OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.Value[RecordNumber];
end;

procedure TiVec.Set_Value(RecordNumber: Integer; Value: OleVariant);
begin
  DefaultInterface.Value[RecordNumber] := Value;
end;

function TiVec.Get_RecordPointCount(RecordNumber: Integer): Integer;
begin
    Result := DefaultInterface.RecordPointCount[RecordNumber];
end;

procedure TiVec.Set_RecordPointCount(RecordNumber: Integer; Value: Integer);
begin
  DefaultInterface.RecordPointCount[RecordNumber] := Value;
end;

function TiVec.Get_FileType: iShapeType;
begin
    Result := DefaultInterface.FileType;
end;

function TiVec.Get_IdType: iDataTypeConst;
begin
    Result := DefaultInterface.IdType;
end;

function TiVec.Get_MaxSize: Integer;
begin
    Result := DefaultInterface.MaxSize;
end;

procedure TiVec.Set_MaxSize(Value: Integer);
begin
  DefaultInterface.Set_MaxSize(Value);
end;

function TiVec.Get_Val: iVal;
begin
    Result := DefaultInterface.Val;
end;

procedure TiVec.Set_Val(const Value: iVal);
begin
  DefaultInterface.Set_Val(Value);
end;

function TiVec.Get_RecordColor(RecordNumber: Integer): Integer;
begin
    Result := DefaultInterface.RecordColor[RecordNumber];
end;

function TiVec.Get_Paint: iPaint;
begin
    Result := DefaultInterface.Paint;
end;

procedure TiVec.Set_Paint(const Value: iPaint);
begin
  DefaultInterface.Set_Paint(Value);
end;

function TiVec.Get_DrawLabels: WordBool;
begin
    Result := DefaultInterface.DrawLabels;
end;

procedure TiVec.Set_DrawLabels(Value: WordBool);
begin
  DefaultInterface.Set_DrawLabels(Value);
end;

function TiVec.Get_RecordBox(RecordNumber: Integer; Position: Integer): OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.RecordBox[RecordNumber, Position];
end;

function TiVec.Get_DisabledRecord(RecordNumber: Integer): WordBool;
begin
    Result := DefaultInterface.DisabledRecord[RecordNumber];
end;

procedure TiVec.Set_DisabledRecord(RecordNumber: Integer; Value: WordBool);
begin
  DefaultInterface.DisabledRecord[RecordNumber] := Value;
end;

function TiVec.Get_Color(RecordNumber: Integer): WideString;
begin
    Result := DefaultInterface.Color[RecordNumber];
end;

procedure TiVec.Set_Color(RecordNumber: Integer; const Value: WideString);
  { Warning: The property Color has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Color := Value;
end;

function TiVec.Get_Selected(RecordNumber: Integer): WordBool;
begin
    Result := DefaultInterface.Selected[RecordNumber];
end;

procedure TiVec.Set_Selected(RecordNumber: Integer; Value: WordBool);
begin
  DefaultInterface.Selected[RecordNumber] := Value;
end;

procedure TiVec.Set_SelectAll(Param1: WordBool);
begin
  DefaultInterface.Set_SelectAll(Param1);
end;

function TiVec.Get_LabelColor(RecordNumber: Integer): WideString;
begin
    Result := DefaultInterface.LabelColor[RecordNumber];
end;

procedure TiVec.Set_LabelColor(RecordNumber: Integer; const Value: WideString);
  { Warning: The property LabelColor has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.LabelColor := Value;
end;

function TiVec.Get_LabelStyle(RecordNumber: Integer): WideString;
begin
    Result := DefaultInterface.LabelStyle[RecordNumber];
end;

procedure TiVec.Set_LabelStyle(RecordNumber: Integer; const Value: WideString);
  { Warning: The property LabelStyle has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.LabelStyle := Value;
end;

function TiVec.Get_LabelSize(RecordNumber: Integer): Smallint;
begin
    Result := DefaultInterface.LabelSize[RecordNumber];
end;

procedure TiVec.Set_LabelSize(RecordNumber: Integer; Value: Smallint);
begin
  DefaultInterface.LabelSize[RecordNumber] := Value;
end;

function TiVec.Get_LabelFontName(RecordNumber: Integer): WideString;
begin
    Result := DefaultInterface.LabelFontName[RecordNumber];
end;

procedure TiVec.Set_LabelFontName(RecordNumber: Integer; const Value: WideString);
  { Warning: The property LabelFontName has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.LabelFontName := Value;
end;

function TiVec.Get_PenColor(RecordNumber: Integer): WideString;
begin
    Result := DefaultInterface.PenColor[RecordNumber];
end;

procedure TiVec.Set_PenColor(RecordNumber: Integer; const Value: WideString);
  { Warning: The property PenColor has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.PenColor := Value;
end;

function TiVec.Get_Parts(RecordNumber: Integer; PartNumber: Integer): Integer;
begin
    Result := DefaultInterface.Parts[RecordNumber, PartNumber];
end;

procedure TiVec.Set_Parts(RecordNumber: Integer; PartNumber: Integer; Value: Integer);
begin
  DefaultInterface.Parts[RecordNumber, PartNumber] := Value;
end;

function TiVec.ArrayOfVar(SourceArray: OleVariant): OleVariant;
begin
  Result := DefaultInterface.ArrayOfVar(SourceArray);
end;

procedure TiVec.AssignObject(const Source: iData);
begin
  DefaultInterface.AssignObject(Source);
end;

procedure TiVec.PasteGeoRefs(const PassVar: iGeoData);
begin
  DefaultInterface.PasteGeoRefs(PassVar);
end;

function TiVec.Open: WordBool;
begin
  Result := DefaultInterface.Open;
end;

procedure TiVec.Save;
begin
  DefaultInterface.Save;
end;

function TiVec.Terminate: WordBool;
begin
  Result := DefaultInterface.Terminate;
end;

procedure TiVec.SaveHeader;
begin
  DefaultInterface.SaveHeader;
end;

function TiVec.OpenHeader: WordBool;
begin
  Result := DefaultInterface.OpenHeader;
end;

function TiVec.OpenWindow(X1: OleVariant; Y1: OleVariant; X2: OleVariant; Y2: OleVariant; 
                          Step: Smallint): WordBool;
begin
  Result := DefaultInterface.OpenWindow(X1, Y1, X2, Y2, Step);
end;

function TiVec.OpenSample(Step: Smallint): WordBool;
begin
  Result := DefaultInterface.OpenSample(Step);
end;

procedure TiVec.PasteHDC(BitmapHDC: Integer; Width: Integer; Height: Integer);
begin
  DefaultInterface.PasteHDC(BitmapHDC, Width, Height);
end;

procedure TiVec.Refresh;
begin
  DefaultInterface.Refresh;
end;

procedure TiVec.ClearBitmap;
begin
  DefaultInterface.ClearBitmap;
end;

function TiVec.StreamMapAs(StreamType: iStreamType): OleVariant;
begin
  Result := DefaultInterface.StreamMapAs(StreamType);
end;

procedure TiVec.PaintPoint(X: OleVariant; Y: OleVariant; Radius: OleVariant; const Color: WideString);
begin
  DefaultInterface.PaintPoint(X, Y, Radius, Color);
end;

procedure TiVec.PaintLine(X1: OleVariant; Y1: OleVariant; X2: OleVariant; Y2: OleVariant; 
                          Width: OleVariant; const Color: WideString);
begin
  DefaultInterface.PaintLine(X1, Y1, X2, Y2, Width, Color);
end;

procedure TiVec.PaintPolygon(Points: OleVariant; LineWidth: Integer; const Color: WideString; 
                             BrushStyle: iBrushStyle; IsGeographic: WordBool);
begin
  DefaultInterface.PaintPolygon(Points, LineWidth, Color, BrushStyle, IsGeographic);
end;

procedure TiVec.PaintText(X: OleVariant; Y: OleVariant; const Text: WideString; 
                          const FontName: WideString; Size: Integer; const Style: WideString; 
                          const Color: WideString);
begin
  DefaultInterface.PaintText(X, Y, Text, FontName, Size, Style, Color);
end;

function TiVec.StreamAs(StreamType: iStreamType): OleVariant;
begin
  Result := DefaultInterface.StreamAs(StreamType);
end;

procedure TiVec.Draw(Left: Integer; Top: Integer; Zoom: Single; PictureHandle: Integer);
begin
  DefaultInterface.Draw(Left, Top, Zoom, PictureHandle);
end;

procedure TiVec.DrawMap(Zoom: Single; PictureHandle: Integer);
begin
  DefaultInterface.DrawMap(Zoom, PictureHandle);
end;

procedure TiVec.CopyMap(Zoom: Single);
begin
  DefaultInterface.CopyMap(Zoom);
end;

procedure TiVec.Copy;
begin
  DefaultInterface.Copy;
end;

procedure TiVec.StretchDraw(hDC: Integer; X1: Double; Y1: Double; X2: Double; Y2: Double; 
                            Left: Integer; Top: Integer; Right: Integer; Bottom: Integer);
begin
  DefaultInterface.StretchDraw(hDC, X1, Y1, X2, Y2, Left, Top, Right, Bottom);
end;

function TiVec.GetDataBuffer(out DataOut: OleVariant): Integer;
begin
  Result := DefaultInterface.GetDataBuffer(DataOut);
end;

procedure TiVec.SetDataBuffer(DataIn: OleVariant);
begin
  DefaultInterface.SetDataBuffer(DataIn);
end;

function TiVec.RetrieveBitmap(Source: OleVariant; TimeOut_Sec: Integer; X1: Integer; Y1: Integer; 
                              X2: Integer; Y2: Integer; Transparency: Byte): Integer;
begin
  Result := DefaultInterface.RetrieveBitmap(Source, TimeOut_Sec, X1, Y1, X2, Y2, Transparency);
end;

procedure TiVec.DrawObject(hDC: Integer; RecordNumber: Integer; X: Integer; Y: Integer);
begin
  DefaultInterface.DrawObject(hDC, RecordNumber, X, Y, EmptyParam);
end;

procedure TiVec.DrawObject(hDC: Integer; RecordNumber: Integer; X: Integer; Y: Integer; 
                           Color: OleVariant);
begin
  DefaultInterface.DrawObject(hDC, RecordNumber, X, Y, Color);
end;

procedure TiVec.AddRecordPoints(ObjectData: OleVariant; Id: Single; RecordNumber: Integer);
begin
  DefaultInterface.AddRecordPoints(ObjectData, Id, RecordNumber);
end;

procedure TiVec.New(const Name: WideString; ObjectsType: iShapeType; IdType: iDataTypeConst);
begin
  DefaultInterface.New(Name, ObjectsType, IdType);
end;

function TiVec.GetRecordBuffer(RecordNumber: Integer): OleVariant;
begin
  Result := DefaultInterface.GetRecordBuffer(RecordNumber);
end;

function TiVec.IndexOf(Value: OleVariant): OleVariant;
begin
  Result := DefaultInterface.IndexOf(Value);
end;

function TiVec.IsPointInPolygon(PolygonIndex: Integer; X: Single; Y: Single): WordBool;
begin
  Result := DefaultInterface.IsPointInPolygon(PolygonIndex, X, Y);
end;

procedure TiVec.Insert(ObjectData: OleVariant; Position: Integer; Id: Integer);
begin
  DefaultInterface.Insert(ObjectData, Position, Id);
end;

procedure TiVec.Exchange(Pos1: Integer; Pos2: Integer);
begin
  DefaultInterface.Exchange(Pos1, Pos2);
end;

procedure TiVec.Delete(RecordNumber: Integer);
begin
  DefaultInterface.Delete(RecordNumber);
end;

procedure TiVec.DrawSquare(hDC: Integer; X1: Double; Y1: Double; X2: Double; Y2: Double; 
                           X: Integer; Y: Integer; Color: Integer; Width: Integer);
begin
  DefaultInterface.DrawSquare(hDC, X1, Y1, X2, Y2, X, Y, Color, Width);
end;

function TiVec.GetRecordPoints(RecordNumber: Integer): OleVariant;
begin
  Result := DefaultInterface.GetRecordPoints(RecordNumber);
end;

function TiVec.SelectString(const QueryString: WideString; AddToSelection: WordBool): WordBool;
begin
  Result := DefaultInterface.SelectString(QueryString, AddToSelection);
end;

procedure TiVec.SetRecordPoints(RecordNumber: Integer; Value: OleVariant);
begin
  DefaultInterface.SetRecordPoints(RecordNumber, Value);
end;

function TiVec.GetDisabledRecords: OleVariant;
begin
  Result := DefaultInterface.GetDisabledRecords;
end;

procedure TiVec.SetDisabledRecords(Value: OleVariant);
begin
  DefaultInterface.SetDisabledRecords(Value);
end;

function TiVec.GetSelectedRecords: OleVariant;
begin
  Result := DefaultInterface.GetSelectedRecords;
end;

procedure TiVec.SetSelectedRecords(Value: OleVariant);
begin
  DefaultInterface.SetSelectedRecords(Value);
end;

procedure TiVec.AddRecordBuffer(ObjectData: OleVariant; Id: Single; Position: Integer);
begin
  DefaultInterface.AddRecordBuffer(ObjectData, Id, Position);
end;

procedure TiVec.DrawRecord(hDC: Integer; ObjectNumber: Integer; X: Integer; Y: Integer; 
                           Width: Integer; Height: Integer; const Color: WideString);
begin
  DefaultInterface.DrawRecord(hDC, ObjectNumber, X, Y, Width, Height, Color);
end;

procedure TiVec.SetLabelProperties(const FontName: WideString; const FontStyle: WideString; 
                                   const FontColor: WideString; FontSize: Integer);
begin
  DefaultInterface.SetLabelProperties(FontName, FontStyle, FontColor, FontSize);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TiVecProperties.Create(AServer: TiVec);
begin
  inherited Create;
  FServer := AServer;
end;

function TiVecProperties.GetDefaultInterface: IiVec;
begin
  Result := FServer.DefaultInterface;
end;

function TiVecProperties.Get_CheckStatus: Byte;
begin
    Result := DefaultInterface.CheckStatus;
end;

procedure TiVecProperties.Set_CheckStatus(Value: Byte);
begin
  DefaultInterface.Set_CheckStatus(Value);
end;

function TiVecProperties.Get_Empty: WordBool;
begin
    Result := DefaultInterface.Empty;
end;

procedure TiVecProperties.Set_Empty(Value: WordBool);
begin
  DefaultInterface.Set_Empty(Value);
end;

function TiVecProperties.Get_Changed: WordBool;
begin
    Result := DefaultInterface.Changed;
end;

procedure TiVecProperties.Set_Changed(Value: WordBool);
begin
  DefaultInterface.Set_Changed(Value);
end;

function TiVecProperties.Get_Error: WideString;
begin
    Result := DefaultInterface.Error;
end;

function TiVecProperties.Get_ObjectName: WideString;
begin
    Result := DefaultInterface.ObjectName;
end;

function TiVecProperties.Get_Process: IUnknown;
begin
    Result := DefaultInterface.Process;
end;

procedure TiVecProperties.Set_Process(const Value: IUnknown);
begin
  DefaultInterface.Set_Process(Value);
end;

function TiVecProperties.Get_DataHandle: Integer;
begin
    Result := DefaultInterface.DataHandle;
end;

function TiVecProperties.Get_Status: WideString;
begin
    Result := DefaultInterface.Status;
end;

function TiVecProperties.Get_Processing: WordBool;
begin
    Result := DefaultInterface.Processing;
end;

function TiVecProperties.Get_PercentDone: Byte;
begin
    Result := DefaultInterface.PercentDone;
end;

function TiVecProperties.Get_Title: WideString;
begin
    Result := DefaultInterface.Title;
end;

procedure TiVecProperties.Set_Title(const Value: WideString);
  { Warning: The property Title has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Title := Value;
end;

function TiVecProperties.Get_Legend: iLegend;
begin
    Result := DefaultInterface.Legend;
end;

procedure TiVecProperties.Set_Legend(const Value: iLegend);
begin
  DefaultInterface.Set_Legend(Value);
end;

function TiVecProperties.Get_hDC: Integer;
begin
    Result := DefaultInterface.hDC;
end;

function TiVecProperties.Get_MinX: Double;
begin
    Result := DefaultInterface.MinX;
end;

procedure TiVecProperties.Set_MinX(Value: Double);
begin
  DefaultInterface.Set_MinX(Value);
end;

function TiVecProperties.Get_MaxX: Double;
begin
    Result := DefaultInterface.MaxX;
end;

procedure TiVecProperties.Set_MaxX(Value: Double);
begin
  DefaultInterface.Set_MaxX(Value);
end;

function TiVecProperties.Get_MinY: Double;
begin
    Result := DefaultInterface.MinY;
end;

procedure TiVecProperties.Set_MinY(Value: Double);
begin
  DefaultInterface.Set_MinY(Value);
end;

function TiVecProperties.Get_MaxY: Double;
begin
    Result := DefaultInterface.MaxY;
end;

procedure TiVecProperties.Set_MaxY(Value: Double);
begin
  DefaultInterface.Set_MaxY(Value);
end;

function TiVecProperties.Get_Document: iFile;
begin
    Result := DefaultInterface.Document;
end;

procedure TiVecProperties.Set_Document(const Value: iFile);
begin
  DefaultInterface.Set_Document(Value);
end;

function TiVecProperties.Get_Comment: iStringList;
begin
    Result := DefaultInterface.Comment;
end;

procedure TiVecProperties.Set_Comment(const Value: iStringList);
begin
  DefaultInterface.Set_Comment(Value);
end;

function TiVecProperties.Get_Lineage: iStringList;
begin
    Result := DefaultInterface.Lineage;
end;

procedure TiVecProperties.Set_Lineage(const Value: iStringList);
begin
  DefaultInterface.Set_Lineage(Value);
end;

function TiVecProperties.Get_Completeness: iStringList;
begin
    Result := DefaultInterface.Completeness;
end;

procedure TiVecProperties.Set_Completeness(const Value: iStringList);
begin
  DefaultInterface.Set_Completeness(Value);
end;

function TiVecProperties.Get_Consistency: iStringList;
begin
    Result := DefaultInterface.Consistency;
end;

procedure TiVecProperties.Set_Consistency(const Value: iStringList);
begin
  DefaultInterface.Set_Consistency(Value);
end;

function TiVecProperties.Get_PartialScene: WordBool;
begin
    Result := DefaultInterface.PartialScene;
end;

function TiVecProperties.Get_ImageWidth: Integer;
begin
    Result := DefaultInterface.ImageWidth;
end;

procedure TiVecProperties.Set_ImageWidth(Value: Integer);
begin
  DefaultInterface.Set_ImageWidth(Value);
end;

function TiVecProperties.Get_ImageHeight: Integer;
begin
    Result := DefaultInterface.ImageHeight;
end;

procedure TiVecProperties.Set_ImageHeight(Value: Integer);
begin
  DefaultInterface.Set_ImageHeight(Value);
end;

function TiVecProperties.Get_PointXY(X: OleVariant; Y: OleVariant): OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.PointXY[X, Y];
end;

procedure TiVecProperties.Set_PointXY(X: OleVariant; Y: OleVariant; Value: OleVariant);
begin
  DefaultInterface.PointXY[X, Y] := Value;
end;

function TiVecProperties.Get_Count: Integer;
begin
    Result := DefaultInterface.Count;
end;

function TiVecProperties.Get_Value(RecordNumber: Integer): OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.Value[RecordNumber];
end;

procedure TiVecProperties.Set_Value(RecordNumber: Integer; Value: OleVariant);
begin
  DefaultInterface.Value[RecordNumber] := Value;
end;

function TiVecProperties.Get_RecordPointCount(RecordNumber: Integer): Integer;
begin
    Result := DefaultInterface.RecordPointCount[RecordNumber];
end;

procedure TiVecProperties.Set_RecordPointCount(RecordNumber: Integer; Value: Integer);
begin
  DefaultInterface.RecordPointCount[RecordNumber] := Value;
end;

function TiVecProperties.Get_FileType: iShapeType;
begin
    Result := DefaultInterface.FileType;
end;

function TiVecProperties.Get_IdType: iDataTypeConst;
begin
    Result := DefaultInterface.IdType;
end;

function TiVecProperties.Get_MaxSize: Integer;
begin
    Result := DefaultInterface.MaxSize;
end;

procedure TiVecProperties.Set_MaxSize(Value: Integer);
begin
  DefaultInterface.Set_MaxSize(Value);
end;

function TiVecProperties.Get_Val: iVal;
begin
    Result := DefaultInterface.Val;
end;

procedure TiVecProperties.Set_Val(const Value: iVal);
begin
  DefaultInterface.Set_Val(Value);
end;

function TiVecProperties.Get_RecordColor(RecordNumber: Integer): Integer;
begin
    Result := DefaultInterface.RecordColor[RecordNumber];
end;

function TiVecProperties.Get_Paint: iPaint;
begin
    Result := DefaultInterface.Paint;
end;

procedure TiVecProperties.Set_Paint(const Value: iPaint);
begin
  DefaultInterface.Set_Paint(Value);
end;

function TiVecProperties.Get_DrawLabels: WordBool;
begin
    Result := DefaultInterface.DrawLabels;
end;

procedure TiVecProperties.Set_DrawLabels(Value: WordBool);
begin
  DefaultInterface.Set_DrawLabels(Value);
end;

function TiVecProperties.Get_RecordBox(RecordNumber: Integer; Position: Integer): OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.RecordBox[RecordNumber, Position];
end;

function TiVecProperties.Get_DisabledRecord(RecordNumber: Integer): WordBool;
begin
    Result := DefaultInterface.DisabledRecord[RecordNumber];
end;

procedure TiVecProperties.Set_DisabledRecord(RecordNumber: Integer; Value: WordBool);
begin
  DefaultInterface.DisabledRecord[RecordNumber] := Value;
end;

function TiVecProperties.Get_Color(RecordNumber: Integer): WideString;
begin
    Result := DefaultInterface.Color[RecordNumber];
end;

procedure TiVecProperties.Set_Color(RecordNumber: Integer; const Value: WideString);
  { Warning: The property Color has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Color := Value;
end;

function TiVecProperties.Get_Selected(RecordNumber: Integer): WordBool;
begin
    Result := DefaultInterface.Selected[RecordNumber];
end;

procedure TiVecProperties.Set_Selected(RecordNumber: Integer; Value: WordBool);
begin
  DefaultInterface.Selected[RecordNumber] := Value;
end;

procedure TiVecProperties.Set_SelectAll(Param1: WordBool);
begin
  DefaultInterface.Set_SelectAll(Param1);
end;

function TiVecProperties.Get_LabelColor(RecordNumber: Integer): WideString;
begin
    Result := DefaultInterface.LabelColor[RecordNumber];
end;

procedure TiVecProperties.Set_LabelColor(RecordNumber: Integer; const Value: WideString);
  { Warning: The property LabelColor has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.LabelColor := Value;
end;

function TiVecProperties.Get_LabelStyle(RecordNumber: Integer): WideString;
begin
    Result := DefaultInterface.LabelStyle[RecordNumber];
end;

procedure TiVecProperties.Set_LabelStyle(RecordNumber: Integer; const Value: WideString);
  { Warning: The property LabelStyle has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.LabelStyle := Value;
end;

function TiVecProperties.Get_LabelSize(RecordNumber: Integer): Smallint;
begin
    Result := DefaultInterface.LabelSize[RecordNumber];
end;

procedure TiVecProperties.Set_LabelSize(RecordNumber: Integer; Value: Smallint);
begin
  DefaultInterface.LabelSize[RecordNumber] := Value;
end;

function TiVecProperties.Get_LabelFontName(RecordNumber: Integer): WideString;
begin
    Result := DefaultInterface.LabelFontName[RecordNumber];
end;

procedure TiVecProperties.Set_LabelFontName(RecordNumber: Integer; const Value: WideString);
  { Warning: The property LabelFontName has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.LabelFontName := Value;
end;

function TiVecProperties.Get_PenColor(RecordNumber: Integer): WideString;
begin
    Result := DefaultInterface.PenColor[RecordNumber];
end;

procedure TiVecProperties.Set_PenColor(RecordNumber: Integer; const Value: WideString);
  { Warning: The property PenColor has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.PenColor := Value;
end;

function TiVecProperties.Get_Parts(RecordNumber: Integer; PartNumber: Integer): Integer;
begin
    Result := DefaultInterface.Parts[RecordNumber, PartNumber];
end;

procedure TiVecProperties.Set_Parts(RecordNumber: Integer; PartNumber: Integer; Value: Integer);
begin
  DefaultInterface.Parts[RecordNumber, PartNumber] := Value;
end;

{$ENDIF}

class function CoiDiscreteLeg.Create: IiDiscreteLeg;
begin
  Result := CreateComObject(CLASS_iDiscreteLeg) as IiDiscreteLeg;
end;

class function CoiDiscreteLeg.CreateRemote(const MachineName: string): IiDiscreteLeg;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_iDiscreteLeg) as IiDiscreteLeg;
end;

procedure TiDiscreteLeg.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{6C9425A4-A98E-11D3-A52B-0000E85E2CDE}';
    IntfIID:   '{6C9425A2-A98E-11D3-A52B-0000E85E2CDE}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TiDiscreteLeg.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IiDiscreteLeg;
  end;
end;

procedure TiDiscreteLeg.ConnectTo(svrIntf: IiDiscreteLeg);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TiDiscreteLeg.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TiDiscreteLeg.GetDefaultInterface: IiDiscreteLeg;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TiDiscreteLeg.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TiDiscreteLegProperties.Create(Self);
{$ENDIF}
end;

destructor TiDiscreteLeg.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TiDiscreteLeg.GetServerProperties: TiDiscreteLegProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TiDiscreteLeg.Get_Width: Integer;
begin
    Result := DefaultInterface.Width;
end;

procedure TiDiscreteLeg.Set_Width(Value: Integer);
begin
  DefaultInterface.Set_Width(Value);
end;

function TiDiscreteLeg.Get_Height: Integer;
begin
    Result := DefaultInterface.Height;
end;

procedure TiDiscreteLeg.Set_Height(Value: Integer);
begin
  DefaultInterface.Set_Height(Value);
end;

function TiDiscreteLeg.Get_Palette: iPal;
begin
    Result := DefaultInterface.Palette;
end;

procedure TiDiscreteLeg.Set_Palette(const Value: iPal);
begin
  DefaultInterface.Set_Palette(Value);
end;

function TiDiscreteLeg.Get_Count: Integer;
begin
    Result := DefaultInterface.Count;
end;

function TiDiscreteLeg.Get_Font: iFont;
begin
    Result := DefaultInterface.Font;
end;

procedure TiDiscreteLeg.Set_Font(const Value: iFont);
begin
  DefaultInterface.Set_Font(Value);
end;

function TiDiscreteLeg.Get_Horizontal: WordBool;
begin
    Result := DefaultInterface.Horizontal;
end;

procedure TiDiscreteLeg.Set_Horizontal(Value: WordBool);
begin
  DefaultInterface.Set_Horizontal(Value);
end;

function TiDiscreteLeg.Get_BackColor: Integer;
begin
    Result := DefaultInterface.BackColor;
end;

procedure TiDiscreteLeg.Set_BackColor(Value: Integer);
begin
  DefaultInterface.Set_BackColor(Value);
end;

function TiDiscreteLeg.Get_BorderColor: Integer;
begin
    Result := DefaultInterface.BorderColor;
end;

procedure TiDiscreteLeg.Set_BorderColor(Value: Integer);
begin
  DefaultInterface.Set_BorderColor(Value);
end;

function TiDiscreteLeg.Get_TextPosition: iTextPosition;
begin
    Result := DefaultInterface.TextPosition;
end;

procedure TiDiscreteLeg.Set_TextPosition(Value: iTextPosition);
begin
  DefaultInterface.Set_TextPosition(Value);
end;

function TiDiscreteLeg.Get_MaxValue: Double;
begin
    Result := DefaultInterface.MaxValue;
end;

procedure TiDiscreteLeg.Set_MaxValue(Value: Double);
begin
  DefaultInterface.Set_MaxValue(Value);
end;

function TiDiscreteLeg.Get_MinValue: Double;
begin
    Result := DefaultInterface.MinValue;
end;

procedure TiDiscreteLeg.Set_MinValue(Value: Double);
begin
  DefaultInterface.Set_MinValue(Value);
end;

function TiDiscreteLeg.Get_Decimal: Integer;
begin
    Result := DefaultInterface.Decimal;
end;

procedure TiDiscreteLeg.Set_Decimal(Value: Integer);
begin
  DefaultInterface.Set_Decimal(Value);
end;

function TiDiscreteLeg.Get_iType: LegType;
begin
    Result := DefaultInterface.iType;
end;

function TiDiscreteLeg.Get_FlagVal: Single;
begin
    Result := DefaultInterface.FlagVal;
end;

procedure TiDiscreteLeg.Set_FlagVal(Value: Single);
begin
  DefaultInterface.Set_FlagVal(Value);
end;

function TiDiscreteLeg.Get_FlagDef: WideString;
begin
    Result := DefaultInterface.FlagDef;
end;

procedure TiDiscreteLeg.Set_FlagDef(const Value: WideString);
  { Warning: The property FlagDef has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.FlagDef := Value;
end;

function TiDiscreteLeg.Get_RefSys: WideString;
begin
    Result := DefaultInterface.RefSys;
end;

procedure TiDiscreteLeg.Set_RefSys(const Value: WideString);
  { Warning: The property RefSys has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.RefSys := Value;
end;

function TiDiscreteLeg.Get_UnitDist: Double;
begin
    Result := DefaultInterface.UnitDist;
end;

procedure TiDiscreteLeg.Set_UnitDist(Value: Double);
begin
  DefaultInterface.Set_UnitDist(Value);
end;

function TiDiscreteLeg.Get_RefUnits: WideString;
begin
    Result := DefaultInterface.RefUnits;
end;

procedure TiDiscreteLeg.Set_RefUnits(const Value: WideString);
  { Warning: The property RefUnits has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.RefUnits := Value;
end;

function TiDiscreteLeg.Get_ValUnits: WideString;
begin
    Result := DefaultInterface.ValUnits;
end;

procedure TiDiscreteLeg.Set_ValUnits(const Value: WideString);
  { Warning: The property ValUnits has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.ValUnits := Value;
end;

function TiDiscreteLeg.Get_Process: IUnknown;
begin
    Result := DefaultInterface.Process;
end;

procedure TiDiscreteLeg.Set_Process(const Value: IUnknown);
begin
  DefaultInterface.Set_Process(Value);
end;

function TiDiscreteLeg.Get__className(X: Integer): WideString;
begin
    Result := DefaultInterface._className[X];
end;

procedure TiDiscreteLeg.Set__className(X: Integer; const Value: WideString);
  { Warning: The property _className has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant._className := Value;
end;

function TiDiscreteLeg.Get_Disabled(LegendNumber: Integer): WordBool;
begin
    Result := DefaultInterface.Disabled[LegendNumber];
end;

procedure TiDiscreteLeg.Set_Disabled(LegendNumber: Integer; Value: WordBool);
begin
  DefaultInterface.Disabled[LegendNumber] := Value;
end;

procedure TiDiscreteLeg.Draw(Left: Integer; Top: Integer; PictureHandle: Integer);
begin
  DefaultInterface.Draw(Left, Top, PictureHandle);
end;

procedure TiDiscreteLeg.Copy;
begin
  DefaultInterface.Copy;
end;

procedure TiDiscreteLeg.SetAutoSize;
begin
  DefaultInterface.SetAutoSize;
end;

procedure TiDiscreteLeg.SaveAsJPEG;
begin
  DefaultInterface.SaveAsJPEG;
end;

procedure TiDiscreteLeg.Add(const ClassName: WideString);
begin
  DefaultInterface.Add(ClassName);
end;

procedure TiDiscreteLeg.Clear;
begin
  DefaultInterface.Clear;
end;

function TiDiscreteLeg.StreamAs(StreamType: iStreamType): OleVariant;
begin
  Result := DefaultInterface.StreamAs(StreamType);
end;

procedure TiDiscreteLeg.Refresh;
begin
  DefaultInterface.Refresh;
end;

procedure TiDiscreteLeg.AssignObject(const Source: iLegend);
begin
  DefaultInterface.AssignObject(Source);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TiDiscreteLegProperties.Create(AServer: TiDiscreteLeg);
begin
  inherited Create;
  FServer := AServer;
end;

function TiDiscreteLegProperties.GetDefaultInterface: IiDiscreteLeg;
begin
  Result := FServer.DefaultInterface;
end;

function TiDiscreteLegProperties.Get_Width: Integer;
begin
    Result := DefaultInterface.Width;
end;

procedure TiDiscreteLegProperties.Set_Width(Value: Integer);
begin
  DefaultInterface.Set_Width(Value);
end;

function TiDiscreteLegProperties.Get_Height: Integer;
begin
    Result := DefaultInterface.Height;
end;

procedure TiDiscreteLegProperties.Set_Height(Value: Integer);
begin
  DefaultInterface.Set_Height(Value);
end;

function TiDiscreteLegProperties.Get_Palette: iPal;
begin
    Result := DefaultInterface.Palette;
end;

procedure TiDiscreteLegProperties.Set_Palette(const Value: iPal);
begin
  DefaultInterface.Set_Palette(Value);
end;

function TiDiscreteLegProperties.Get_Count: Integer;
begin
    Result := DefaultInterface.Count;
end;

function TiDiscreteLegProperties.Get_Font: iFont;
begin
    Result := DefaultInterface.Font;
end;

procedure TiDiscreteLegProperties.Set_Font(const Value: iFont);
begin
  DefaultInterface.Set_Font(Value);
end;

function TiDiscreteLegProperties.Get_Horizontal: WordBool;
begin
    Result := DefaultInterface.Horizontal;
end;

procedure TiDiscreteLegProperties.Set_Horizontal(Value: WordBool);
begin
  DefaultInterface.Set_Horizontal(Value);
end;

function TiDiscreteLegProperties.Get_BackColor: Integer;
begin
    Result := DefaultInterface.BackColor;
end;

procedure TiDiscreteLegProperties.Set_BackColor(Value: Integer);
begin
  DefaultInterface.Set_BackColor(Value);
end;

function TiDiscreteLegProperties.Get_BorderColor: Integer;
begin
    Result := DefaultInterface.BorderColor;
end;

procedure TiDiscreteLegProperties.Set_BorderColor(Value: Integer);
begin
  DefaultInterface.Set_BorderColor(Value);
end;

function TiDiscreteLegProperties.Get_TextPosition: iTextPosition;
begin
    Result := DefaultInterface.TextPosition;
end;

procedure TiDiscreteLegProperties.Set_TextPosition(Value: iTextPosition);
begin
  DefaultInterface.Set_TextPosition(Value);
end;

function TiDiscreteLegProperties.Get_MaxValue: Double;
begin
    Result := DefaultInterface.MaxValue;
end;

procedure TiDiscreteLegProperties.Set_MaxValue(Value: Double);
begin
  DefaultInterface.Set_MaxValue(Value);
end;

function TiDiscreteLegProperties.Get_MinValue: Double;
begin
    Result := DefaultInterface.MinValue;
end;

procedure TiDiscreteLegProperties.Set_MinValue(Value: Double);
begin
  DefaultInterface.Set_MinValue(Value);
end;

function TiDiscreteLegProperties.Get_Decimal: Integer;
begin
    Result := DefaultInterface.Decimal;
end;

procedure TiDiscreteLegProperties.Set_Decimal(Value: Integer);
begin
  DefaultInterface.Set_Decimal(Value);
end;

function TiDiscreteLegProperties.Get_iType: LegType;
begin
    Result := DefaultInterface.iType;
end;

function TiDiscreteLegProperties.Get_FlagVal: Single;
begin
    Result := DefaultInterface.FlagVal;
end;

procedure TiDiscreteLegProperties.Set_FlagVal(Value: Single);
begin
  DefaultInterface.Set_FlagVal(Value);
end;

function TiDiscreteLegProperties.Get_FlagDef: WideString;
begin
    Result := DefaultInterface.FlagDef;
end;

procedure TiDiscreteLegProperties.Set_FlagDef(const Value: WideString);
  { Warning: The property FlagDef has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.FlagDef := Value;
end;

function TiDiscreteLegProperties.Get_RefSys: WideString;
begin
    Result := DefaultInterface.RefSys;
end;

procedure TiDiscreteLegProperties.Set_RefSys(const Value: WideString);
  { Warning: The property RefSys has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.RefSys := Value;
end;

function TiDiscreteLegProperties.Get_UnitDist: Double;
begin
    Result := DefaultInterface.UnitDist;
end;

procedure TiDiscreteLegProperties.Set_UnitDist(Value: Double);
begin
  DefaultInterface.Set_UnitDist(Value);
end;

function TiDiscreteLegProperties.Get_RefUnits: WideString;
begin
    Result := DefaultInterface.RefUnits;
end;

procedure TiDiscreteLegProperties.Set_RefUnits(const Value: WideString);
  { Warning: The property RefUnits has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.RefUnits := Value;
end;

function TiDiscreteLegProperties.Get_ValUnits: WideString;
begin
    Result := DefaultInterface.ValUnits;
end;

procedure TiDiscreteLegProperties.Set_ValUnits(const Value: WideString);
  { Warning: The property ValUnits has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.ValUnits := Value;
end;

function TiDiscreteLegProperties.Get_Process: IUnknown;
begin
    Result := DefaultInterface.Process;
end;

procedure TiDiscreteLegProperties.Set_Process(const Value: IUnknown);
begin
  DefaultInterface.Set_Process(Value);
end;

function TiDiscreteLegProperties.Get__className(X: Integer): WideString;
begin
    Result := DefaultInterface._className[X];
end;

procedure TiDiscreteLegProperties.Set__className(X: Integer; const Value: WideString);
  { Warning: The property _className has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant._className := Value;
end;

function TiDiscreteLegProperties.Get_Disabled(LegendNumber: Integer): WordBool;
begin
    Result := DefaultInterface.Disabled[LegendNumber];
end;

procedure TiDiscreteLegProperties.Set_Disabled(LegendNumber: Integer; Value: WordBool);
begin
  DefaultInterface.Disabled[LegendNumber] := Value;
end;

{$ENDIF}

class function CoiContLeg.Create: IiContLeg;
begin
  Result := CreateComObject(CLASS_iContLeg) as IiContLeg;
end;

class function CoiContLeg.CreateRemote(const MachineName: string): IiContLeg;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_iContLeg) as IiContLeg;
end;

procedure TiContLeg.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{6C9425A8-A98E-11D3-A52B-0000E85E2CDE}';
    IntfIID:   '{6C9425A6-A98E-11D3-A52B-0000E85E2CDE}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TiContLeg.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IiContLeg;
  end;
end;

procedure TiContLeg.ConnectTo(svrIntf: IiContLeg);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TiContLeg.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TiContLeg.GetDefaultInterface: IiContLeg;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TiContLeg.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TiContLegProperties.Create(Self);
{$ENDIF}
end;

destructor TiContLeg.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TiContLeg.GetServerProperties: TiContLegProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TiContLeg.Get_Width: Integer;
begin
    Result := DefaultInterface.Width;
end;

procedure TiContLeg.Set_Width(Value: Integer);
begin
  DefaultInterface.Set_Width(Value);
end;

function TiContLeg.Get_Height: Integer;
begin
    Result := DefaultInterface.Height;
end;

procedure TiContLeg.Set_Height(Value: Integer);
begin
  DefaultInterface.Set_Height(Value);
end;

function TiContLeg.Get_Palette: iPal;
begin
    Result := DefaultInterface.Palette;
end;

procedure TiContLeg.Set_Palette(const Value: iPal);
begin
  DefaultInterface.Set_Palette(Value);
end;

function TiContLeg.Get_Count: Integer;
begin
    Result := DefaultInterface.Count;
end;

function TiContLeg.Get_Font: iFont;
begin
    Result := DefaultInterface.Font;
end;

procedure TiContLeg.Set_Font(const Value: iFont);
begin
  DefaultInterface.Set_Font(Value);
end;

function TiContLeg.Get_Horizontal: WordBool;
begin
    Result := DefaultInterface.Horizontal;
end;

procedure TiContLeg.Set_Horizontal(Value: WordBool);
begin
  DefaultInterface.Set_Horizontal(Value);
end;

function TiContLeg.Get_BackColor: Integer;
begin
    Result := DefaultInterface.BackColor;
end;

procedure TiContLeg.Set_BackColor(Value: Integer);
begin
  DefaultInterface.Set_BackColor(Value);
end;

function TiContLeg.Get_BorderColor: Integer;
begin
    Result := DefaultInterface.BorderColor;
end;

procedure TiContLeg.Set_BorderColor(Value: Integer);
begin
  DefaultInterface.Set_BorderColor(Value);
end;

function TiContLeg.Get_TextPosition: iTextPosition;
begin
    Result := DefaultInterface.TextPosition;
end;

procedure TiContLeg.Set_TextPosition(Value: iTextPosition);
begin
  DefaultInterface.Set_TextPosition(Value);
end;

function TiContLeg.Get_MaxValue: Double;
begin
    Result := DefaultInterface.MaxValue;
end;

procedure TiContLeg.Set_MaxValue(Value: Double);
begin
  DefaultInterface.Set_MaxValue(Value);
end;

function TiContLeg.Get_MinValue: Double;
begin
    Result := DefaultInterface.MinValue;
end;

procedure TiContLeg.Set_MinValue(Value: Double);
begin
  DefaultInterface.Set_MinValue(Value);
end;

function TiContLeg.Get_Decimal: Integer;
begin
    Result := DefaultInterface.Decimal;
end;

procedure TiContLeg.Set_Decimal(Value: Integer);
begin
  DefaultInterface.Set_Decimal(Value);
end;

function TiContLeg.Get_iType: LegType;
begin
    Result := DefaultInterface.iType;
end;

function TiContLeg.Get_FlagVal: Single;
begin
    Result := DefaultInterface.FlagVal;
end;

procedure TiContLeg.Set_FlagVal(Value: Single);
begin
  DefaultInterface.Set_FlagVal(Value);
end;

function TiContLeg.Get_FlagDef: WideString;
begin
    Result := DefaultInterface.FlagDef;
end;

procedure TiContLeg.Set_FlagDef(const Value: WideString);
  { Warning: The property FlagDef has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.FlagDef := Value;
end;

function TiContLeg.Get_RefSys: WideString;
begin
    Result := DefaultInterface.RefSys;
end;

procedure TiContLeg.Set_RefSys(const Value: WideString);
  { Warning: The property RefSys has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.RefSys := Value;
end;

function TiContLeg.Get_UnitDist: Double;
begin
    Result := DefaultInterface.UnitDist;
end;

procedure TiContLeg.Set_UnitDist(Value: Double);
begin
  DefaultInterface.Set_UnitDist(Value);
end;

function TiContLeg.Get_RefUnits: WideString;
begin
    Result := DefaultInterface.RefUnits;
end;

procedure TiContLeg.Set_RefUnits(const Value: WideString);
  { Warning: The property RefUnits has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.RefUnits := Value;
end;

function TiContLeg.Get_ValUnits: WideString;
begin
    Result := DefaultInterface.ValUnits;
end;

procedure TiContLeg.Set_ValUnits(const Value: WideString);
  { Warning: The property ValUnits has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.ValUnits := Value;
end;

function TiContLeg.Get_Process: IUnknown;
begin
    Result := DefaultInterface.Process;
end;

procedure TiContLeg.Set_Process(const Value: IUnknown);
begin
  DefaultInterface.Set_Process(Value);
end;

function TiContLeg.Get__className(X: Integer): WideString;
begin
    Result := DefaultInterface._className[X];
end;

procedure TiContLeg.Set__className(X: Integer; const Value: WideString);
  { Warning: The property _className has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant._className := Value;
end;

function TiContLeg.Get_Disabled(LegendNumber: Integer): WordBool;
begin
    Result := DefaultInterface.Disabled[LegendNumber];
end;

procedure TiContLeg.Set_Disabled(LegendNumber: Integer; Value: WordBool);
begin
  DefaultInterface.Disabled[LegendNumber] := Value;
end;

procedure TiContLeg.Draw(Left: Integer; Top: Integer; PictureHandle: Integer);
begin
  DefaultInterface.Draw(Left, Top, PictureHandle);
end;

procedure TiContLeg.Copy;
begin
  DefaultInterface.Copy;
end;

procedure TiContLeg.SetAutoSize;
begin
  DefaultInterface.SetAutoSize;
end;

procedure TiContLeg.SaveAsJPEG;
begin
  DefaultInterface.SaveAsJPEG;
end;

procedure TiContLeg.Add(const ClassName: WideString);
begin
  DefaultInterface.Add(ClassName);
end;

procedure TiContLeg.Clear;
begin
  DefaultInterface.Clear;
end;

function TiContLeg.StreamAs(StreamType: iStreamType): OleVariant;
begin
  Result := DefaultInterface.StreamAs(StreamType);
end;

procedure TiContLeg.Refresh;
begin
  DefaultInterface.Refresh;
end;

procedure TiContLeg.AssignObject(const Source: iLegend);
begin
  DefaultInterface.AssignObject(Source);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TiContLegProperties.Create(AServer: TiContLeg);
begin
  inherited Create;
  FServer := AServer;
end;

function TiContLegProperties.GetDefaultInterface: IiContLeg;
begin
  Result := FServer.DefaultInterface;
end;

function TiContLegProperties.Get_Width: Integer;
begin
    Result := DefaultInterface.Width;
end;

procedure TiContLegProperties.Set_Width(Value: Integer);
begin
  DefaultInterface.Set_Width(Value);
end;

function TiContLegProperties.Get_Height: Integer;
begin
    Result := DefaultInterface.Height;
end;

procedure TiContLegProperties.Set_Height(Value: Integer);
begin
  DefaultInterface.Set_Height(Value);
end;

function TiContLegProperties.Get_Palette: iPal;
begin
    Result := DefaultInterface.Palette;
end;

procedure TiContLegProperties.Set_Palette(const Value: iPal);
begin
  DefaultInterface.Set_Palette(Value);
end;

function TiContLegProperties.Get_Count: Integer;
begin
    Result := DefaultInterface.Count;
end;

function TiContLegProperties.Get_Font: iFont;
begin
    Result := DefaultInterface.Font;
end;

procedure TiContLegProperties.Set_Font(const Value: iFont);
begin
  DefaultInterface.Set_Font(Value);
end;

function TiContLegProperties.Get_Horizontal: WordBool;
begin
    Result := DefaultInterface.Horizontal;
end;

procedure TiContLegProperties.Set_Horizontal(Value: WordBool);
begin
  DefaultInterface.Set_Horizontal(Value);
end;

function TiContLegProperties.Get_BackColor: Integer;
begin
    Result := DefaultInterface.BackColor;
end;

procedure TiContLegProperties.Set_BackColor(Value: Integer);
begin
  DefaultInterface.Set_BackColor(Value);
end;

function TiContLegProperties.Get_BorderColor: Integer;
begin
    Result := DefaultInterface.BorderColor;
end;

procedure TiContLegProperties.Set_BorderColor(Value: Integer);
begin
  DefaultInterface.Set_BorderColor(Value);
end;

function TiContLegProperties.Get_TextPosition: iTextPosition;
begin
    Result := DefaultInterface.TextPosition;
end;

procedure TiContLegProperties.Set_TextPosition(Value: iTextPosition);
begin
  DefaultInterface.Set_TextPosition(Value);
end;

function TiContLegProperties.Get_MaxValue: Double;
begin
    Result := DefaultInterface.MaxValue;
end;

procedure TiContLegProperties.Set_MaxValue(Value: Double);
begin
  DefaultInterface.Set_MaxValue(Value);
end;

function TiContLegProperties.Get_MinValue: Double;
begin
    Result := DefaultInterface.MinValue;
end;

procedure TiContLegProperties.Set_MinValue(Value: Double);
begin
  DefaultInterface.Set_MinValue(Value);
end;

function TiContLegProperties.Get_Decimal: Integer;
begin
    Result := DefaultInterface.Decimal;
end;

procedure TiContLegProperties.Set_Decimal(Value: Integer);
begin
  DefaultInterface.Set_Decimal(Value);
end;

function TiContLegProperties.Get_iType: LegType;
begin
    Result := DefaultInterface.iType;
end;

function TiContLegProperties.Get_FlagVal: Single;
begin
    Result := DefaultInterface.FlagVal;
end;

procedure TiContLegProperties.Set_FlagVal(Value: Single);
begin
  DefaultInterface.Set_FlagVal(Value);
end;

function TiContLegProperties.Get_FlagDef: WideString;
begin
    Result := DefaultInterface.FlagDef;
end;

procedure TiContLegProperties.Set_FlagDef(const Value: WideString);
  { Warning: The property FlagDef has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.FlagDef := Value;
end;

function TiContLegProperties.Get_RefSys: WideString;
begin
    Result := DefaultInterface.RefSys;
end;

procedure TiContLegProperties.Set_RefSys(const Value: WideString);
  { Warning: The property RefSys has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.RefSys := Value;
end;

function TiContLegProperties.Get_UnitDist: Double;
begin
    Result := DefaultInterface.UnitDist;
end;

procedure TiContLegProperties.Set_UnitDist(Value: Double);
begin
  DefaultInterface.Set_UnitDist(Value);
end;

function TiContLegProperties.Get_RefUnits: WideString;
begin
    Result := DefaultInterface.RefUnits;
end;

procedure TiContLegProperties.Set_RefUnits(const Value: WideString);
  { Warning: The property RefUnits has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.RefUnits := Value;
end;

function TiContLegProperties.Get_ValUnits: WideString;
begin
    Result := DefaultInterface.ValUnits;
end;

procedure TiContLegProperties.Set_ValUnits(const Value: WideString);
  { Warning: The property ValUnits has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.ValUnits := Value;
end;

function TiContLegProperties.Get_Process: IUnknown;
begin
    Result := DefaultInterface.Process;
end;

procedure TiContLegProperties.Set_Process(const Value: IUnknown);
begin
  DefaultInterface.Set_Process(Value);
end;

function TiContLegProperties.Get__className(X: Integer): WideString;
begin
    Result := DefaultInterface._className[X];
end;

procedure TiContLegProperties.Set__className(X: Integer; const Value: WideString);
  { Warning: The property _className has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant._className := Value;
end;

function TiContLegProperties.Get_Disabled(LegendNumber: Integer): WordBool;
begin
    Result := DefaultInterface.Disabled[LegendNumber];
end;

procedure TiContLegProperties.Set_Disabled(LegendNumber: Integer; Value: WordBool);
begin
  DefaultInterface.Disabled[LegendNumber] := Value;
end;

{$ENDIF}

class function CoiVal.Create: IiVal;
begin
  Result := CreateComObject(CLASS_iVal) as IiVal;
end;

class function CoiVal.CreateRemote(const MachineName: string): IiVal;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_iVal) as IiVal;
end;

procedure TiVal.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{6C9425AD-A98E-11D3-A52B-0000E85E2CDE}';
    IntfIID:   '{6C9425AB-A98E-11D3-A52B-0000E85E2CDE}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TiVal.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IiVal;
  end;
end;

procedure TiVal.ConnectTo(svrIntf: IiVal);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TiVal.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TiVal.GetDefaultInterface: IiVal;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TiVal.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TiValProperties.Create(Self);
{$ENDIF}
end;

destructor TiVal.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TiVal.GetServerProperties: TiValProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TiVal.Get_CheckStatus: Byte;
begin
    Result := DefaultInterface.CheckStatus;
end;

procedure TiVal.Set_CheckStatus(Value: Byte);
begin
  DefaultInterface.Set_CheckStatus(Value);
end;

function TiVal.Get_Empty: WordBool;
begin
    Result := DefaultInterface.Empty;
end;

procedure TiVal.Set_Empty(Value: WordBool);
begin
  DefaultInterface.Set_Empty(Value);
end;

function TiVal.Get_Changed: WordBool;
begin
    Result := DefaultInterface.Changed;
end;

procedure TiVal.Set_Changed(Value: WordBool);
begin
  DefaultInterface.Set_Changed(Value);
end;

function TiVal.Get_Error: WideString;
begin
    Result := DefaultInterface.Error;
end;

function TiVal.Get_ObjectName: WideString;
begin
    Result := DefaultInterface.ObjectName;
end;

function TiVal.Get_Process: IUnknown;
begin
    Result := DefaultInterface.Process;
end;

procedure TiVal.Set_Process(const Value: IUnknown);
begin
  DefaultInterface.Set_Process(Value);
end;

function TiVal.Get_DataHandle: Integer;
begin
    Result := DefaultInterface.DataHandle;
end;

function TiVal.Get_Status: WideString;
begin
    Result := DefaultInterface.Status;
end;

function TiVal.Get_Processing: WordBool;
begin
    Result := DefaultInterface.Processing;
end;

function TiVal.Get_PercentDone: Byte;
begin
    Result := DefaultInterface.PercentDone;
end;

function TiVal.Get_RecordCount: Integer;
begin
    Result := DefaultInterface.RecordCount;
end;

function TiVal.Get_FeatureType(FeatureIndex: OleVariant): iFeatureType;
begin
    Result := DefaultInterface.FeatureType[FeatureIndex];
end;

procedure TiVal.Set_FeatureType(FeatureIndex: OleVariant; Value: iFeatureType);
begin
  DefaultInterface.FeatureType[FeatureIndex] := Value;
end;

function TiVal.Get_FeatureCount: Integer;
begin
    Result := DefaultInterface.FeatureCount;
end;

function TiVal.Get_FeatureData(FieldNumber: OleVariant): OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.FeatureData[FieldNumber];
end;

procedure TiVal.Set_FeatureData(FieldNumber: OleVariant; Value: OleVariant);
begin
  DefaultInterface.FeatureData[FieldNumber] := Value;
end;

function TiVal.Get_Document: iFile;
begin
    Result := DefaultInterface.Document;
end;

procedure TiVal.Set_Document(const Value: iFile);
begin
  DefaultInterface.Set_Document(Value);
end;

function TiVal.Get_Legend(FeatureIndex: OleVariant): iLegend;
begin
    Result := DefaultInterface.Legend[FeatureIndex];
end;

procedure TiVal.Set_Legend(FeatureIndex: OleVariant; const Value: iLegend);
begin
  DefaultInterface.Legend[FeatureIndex] := Value;
end;

function TiVal.Get_ActiveFeature: Integer;
begin
    Result := DefaultInterface.ActiveFeature;
end;

procedure TiVal.Set_ActiveFeature(Value: Integer);
begin
  DefaultInterface.Set_ActiveFeature(Value);
end;

function TiVal.Get_IDData: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.IDData;
end;

procedure TiVal.Set_IDData(Value: OleVariant);
begin
  DefaultInterface.Set_IDData(Value);
end;

function TiVal.Get_FeatureName(Index_: Integer): WideString;
begin
    Result := DefaultInterface.FeatureName[Index_];
end;

function TiVal.Get_RecordData(RecordIndex: Integer; FeatureIndex: OleVariant): OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.RecordData[RecordIndex, FeatureIndex];
end;

procedure TiVal.Set_RecordData(RecordIndex: Integer; FeatureIndex: OleVariant; Value: OleVariant);
begin
  DefaultInterface.RecordData[RecordIndex, FeatureIndex] := Value;
end;

function TiVal.ArrayOfVar(SourceArray: OleVariant): OleVariant;
begin
  Result := DefaultInterface.ArrayOfVar(SourceArray);
end;

procedure TiVal.AssignObject(const Source: iData);
begin
  DefaultInterface.AssignObject(Source);
end;

function TiVal.Open(ReadOnly: WordBool): WordBool;
begin
  Result := DefaultInterface.Open(ReadOnly);
end;

procedure TiVal.Save;
begin
  DefaultInterface.Save;
end;

function TiVal.OpenHeader: WordBool;
begin
  Result := DefaultInterface.OpenHeader;
end;

procedure TiVal.SaveHeader;
begin
  DefaultInterface.SaveHeader;
end;

procedure TiVal.AddFeature(DataFeature: OleVariant; FeatureType: iFeatureType; 
                           const Name: WideString);
begin
  DefaultInterface.AddFeature(DataFeature, FeatureType, Name);
end;

procedure TiVal.Clear;
begin
  DefaultInterface.Clear;
end;

function TiVal.IsFeatureDifValuesMoreThan(FeatureIndex: Integer; Value: Integer): WordBool;
begin
  Result := DefaultInterface.IsFeatureDifValuesMoreThan(FeatureIndex, Value);
end;

procedure TiVal.AddRecord(RecordPosition: Integer);
begin
  DefaultInterface.AddRecord(RecordPosition);
end;

procedure TiVal.Delete(RecordNumber: Integer);
begin
  DefaultInterface.Delete(RecordNumber);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TiValProperties.Create(AServer: TiVal);
begin
  inherited Create;
  FServer := AServer;
end;

function TiValProperties.GetDefaultInterface: IiVal;
begin
  Result := FServer.DefaultInterface;
end;

function TiValProperties.Get_CheckStatus: Byte;
begin
    Result := DefaultInterface.CheckStatus;
end;

procedure TiValProperties.Set_CheckStatus(Value: Byte);
begin
  DefaultInterface.Set_CheckStatus(Value);
end;

function TiValProperties.Get_Empty: WordBool;
begin
    Result := DefaultInterface.Empty;
end;

procedure TiValProperties.Set_Empty(Value: WordBool);
begin
  DefaultInterface.Set_Empty(Value);
end;

function TiValProperties.Get_Changed: WordBool;
begin
    Result := DefaultInterface.Changed;
end;

procedure TiValProperties.Set_Changed(Value: WordBool);
begin
  DefaultInterface.Set_Changed(Value);
end;

function TiValProperties.Get_Error: WideString;
begin
    Result := DefaultInterface.Error;
end;

function TiValProperties.Get_ObjectName: WideString;
begin
    Result := DefaultInterface.ObjectName;
end;

function TiValProperties.Get_Process: IUnknown;
begin
    Result := DefaultInterface.Process;
end;

procedure TiValProperties.Set_Process(const Value: IUnknown);
begin
  DefaultInterface.Set_Process(Value);
end;

function TiValProperties.Get_DataHandle: Integer;
begin
    Result := DefaultInterface.DataHandle;
end;

function TiValProperties.Get_Status: WideString;
begin
    Result := DefaultInterface.Status;
end;

function TiValProperties.Get_Processing: WordBool;
begin
    Result := DefaultInterface.Processing;
end;

function TiValProperties.Get_PercentDone: Byte;
begin
    Result := DefaultInterface.PercentDone;
end;

function TiValProperties.Get_RecordCount: Integer;
begin
    Result := DefaultInterface.RecordCount;
end;

function TiValProperties.Get_FeatureType(FeatureIndex: OleVariant): iFeatureType;
begin
    Result := DefaultInterface.FeatureType[FeatureIndex];
end;

procedure TiValProperties.Set_FeatureType(FeatureIndex: OleVariant; Value: iFeatureType);
begin
  DefaultInterface.FeatureType[FeatureIndex] := Value;
end;

function TiValProperties.Get_FeatureCount: Integer;
begin
    Result := DefaultInterface.FeatureCount;
end;

function TiValProperties.Get_FeatureData(FieldNumber: OleVariant): OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.FeatureData[FieldNumber];
end;

procedure TiValProperties.Set_FeatureData(FieldNumber: OleVariant; Value: OleVariant);
begin
  DefaultInterface.FeatureData[FieldNumber] := Value;
end;

function TiValProperties.Get_Document: iFile;
begin
    Result := DefaultInterface.Document;
end;

procedure TiValProperties.Set_Document(const Value: iFile);
begin
  DefaultInterface.Set_Document(Value);
end;

function TiValProperties.Get_Legend(FeatureIndex: OleVariant): iLegend;
begin
    Result := DefaultInterface.Legend[FeatureIndex];
end;

procedure TiValProperties.Set_Legend(FeatureIndex: OleVariant; const Value: iLegend);
begin
  DefaultInterface.Legend[FeatureIndex] := Value;
end;

function TiValProperties.Get_ActiveFeature: Integer;
begin
    Result := DefaultInterface.ActiveFeature;
end;

procedure TiValProperties.Set_ActiveFeature(Value: Integer);
begin
  DefaultInterface.Set_ActiveFeature(Value);
end;

function TiValProperties.Get_IDData: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.IDData;
end;

procedure TiValProperties.Set_IDData(Value: OleVariant);
begin
  DefaultInterface.Set_IDData(Value);
end;

function TiValProperties.Get_FeatureName(Index_: Integer): WideString;
begin
    Result := DefaultInterface.FeatureName[Index_];
end;

function TiValProperties.Get_RecordData(RecordIndex: Integer; FeatureIndex: OleVariant): OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.RecordData[RecordIndex, FeatureIndex];
end;

procedure TiValProperties.Set_RecordData(RecordIndex: Integer; FeatureIndex: OleVariant; 
                                         Value: OleVariant);
begin
  DefaultInterface.RecordData[RecordIndex, FeatureIndex] := Value;
end;

{$ENDIF}

class function CoiShp.Create: IiShp;
begin
  Result := CreateComObject(CLASS_iShp) as IiShp;
end;

class function CoiShp.CreateRemote(const MachineName: string): IiShp;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_iShp) as IiShp;
end;

procedure TiShp.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{A42E61F3-A993-11D3-A52C-0000E85E2CDE}';
    IntfIID:   '{A42E61F1-A993-11D3-A52C-0000E85E2CDE}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TiShp.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IiShp;
  end;
end;

procedure TiShp.ConnectTo(svrIntf: IiShp);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TiShp.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TiShp.GetDefaultInterface: IiShp;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TiShp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TiShpProperties.Create(Self);
{$ENDIF}
end;

destructor TiShp.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TiShp.GetServerProperties: TiShpProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TiShp.Get_CheckStatus: Byte;
begin
    Result := DefaultInterface.CheckStatus;
end;

procedure TiShp.Set_CheckStatus(Value: Byte);
begin
  DefaultInterface.Set_CheckStatus(Value);
end;

function TiShp.Get_Empty: WordBool;
begin
    Result := DefaultInterface.Empty;
end;

procedure TiShp.Set_Empty(Value: WordBool);
begin
  DefaultInterface.Set_Empty(Value);
end;

function TiShp.Get_Changed: WordBool;
begin
    Result := DefaultInterface.Changed;
end;

procedure TiShp.Set_Changed(Value: WordBool);
begin
  DefaultInterface.Set_Changed(Value);
end;

function TiShp.Get_Error: WideString;
begin
    Result := DefaultInterface.Error;
end;

function TiShp.Get_ObjectName: WideString;
begin
    Result := DefaultInterface.ObjectName;
end;

function TiShp.Get_Process: IUnknown;
begin
    Result := DefaultInterface.Process;
end;

procedure TiShp.Set_Process(const Value: IUnknown);
begin
  DefaultInterface.Set_Process(Value);
end;

function TiShp.Get_DataHandle: Integer;
begin
    Result := DefaultInterface.DataHandle;
end;

function TiShp.Get_Status: WideString;
begin
    Result := DefaultInterface.Status;
end;

function TiShp.Get_Processing: WordBool;
begin
    Result := DefaultInterface.Processing;
end;

function TiShp.Get_PercentDone: Byte;
begin
    Result := DefaultInterface.PercentDone;
end;

function TiShp.Get_Title: WideString;
begin
    Result := DefaultInterface.Title;
end;

procedure TiShp.Set_Title(const Value: WideString);
  { Warning: The property Title has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Title := Value;
end;

function TiShp.Get_Legend: iLegend;
begin
    Result := DefaultInterface.Legend;
end;

procedure TiShp.Set_Legend(const Value: iLegend);
begin
  DefaultInterface.Set_Legend(Value);
end;

function TiShp.Get_hDC: Integer;
begin
    Result := DefaultInterface.hDC;
end;

function TiShp.Get_MinX: Double;
begin
    Result := DefaultInterface.MinX;
end;

procedure TiShp.Set_MinX(Value: Double);
begin
  DefaultInterface.Set_MinX(Value);
end;

function TiShp.Get_MaxX: Double;
begin
    Result := DefaultInterface.MaxX;
end;

procedure TiShp.Set_MaxX(Value: Double);
begin
  DefaultInterface.Set_MaxX(Value);
end;

function TiShp.Get_MinY: Double;
begin
    Result := DefaultInterface.MinY;
end;

procedure TiShp.Set_MinY(Value: Double);
begin
  DefaultInterface.Set_MinY(Value);
end;

function TiShp.Get_MaxY: Double;
begin
    Result := DefaultInterface.MaxY;
end;

procedure TiShp.Set_MaxY(Value: Double);
begin
  DefaultInterface.Set_MaxY(Value);
end;

function TiShp.Get_Document: iFile;
begin
    Result := DefaultInterface.Document;
end;

procedure TiShp.Set_Document(const Value: iFile);
begin
  DefaultInterface.Set_Document(Value);
end;

function TiShp.Get_Comment: iStringList;
begin
    Result := DefaultInterface.Comment;
end;

procedure TiShp.Set_Comment(const Value: iStringList);
begin
  DefaultInterface.Set_Comment(Value);
end;

function TiShp.Get_Lineage: iStringList;
begin
    Result := DefaultInterface.Lineage;
end;

procedure TiShp.Set_Lineage(const Value: iStringList);
begin
  DefaultInterface.Set_Lineage(Value);
end;

function TiShp.Get_Completeness: iStringList;
begin
    Result := DefaultInterface.Completeness;
end;

procedure TiShp.Set_Completeness(const Value: iStringList);
begin
  DefaultInterface.Set_Completeness(Value);
end;

function TiShp.Get_Consistency: iStringList;
begin
    Result := DefaultInterface.Consistency;
end;

procedure TiShp.Set_Consistency(const Value: iStringList);
begin
  DefaultInterface.Set_Consistency(Value);
end;

function TiShp.Get_PartialScene: WordBool;
begin
    Result := DefaultInterface.PartialScene;
end;

function TiShp.Get_ImageWidth: Integer;
begin
    Result := DefaultInterface.ImageWidth;
end;

procedure TiShp.Set_ImageWidth(Value: Integer);
begin
  DefaultInterface.Set_ImageWidth(Value);
end;

function TiShp.Get_ImageHeight: Integer;
begin
    Result := DefaultInterface.ImageHeight;
end;

procedure TiShp.Set_ImageHeight(Value: Integer);
begin
  DefaultInterface.Set_ImageHeight(Value);
end;

function TiShp.Get_PointXY(X: OleVariant; Y: OleVariant): OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.PointXY[X, Y];
end;

procedure TiShp.Set_PointXY(X: OleVariant; Y: OleVariant; Value: OleVariant);
begin
  DefaultInterface.PointXY[X, Y] := Value;
end;

function TiShp.Get_Count: Integer;
begin
    Result := DefaultInterface.Count;
end;

function TiShp.Get_Value(RecordNumber: Integer): OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.Value[RecordNumber];
end;

procedure TiShp.Set_Value(RecordNumber: Integer; Value: OleVariant);
begin
  DefaultInterface.Value[RecordNumber] := Value;
end;

function TiShp.Get_RecordPointCount(RecordNumber: Integer): Integer;
begin
    Result := DefaultInterface.RecordPointCount[RecordNumber];
end;

procedure TiShp.Set_RecordPointCount(RecordNumber: Integer; Value: Integer);
begin
  DefaultInterface.RecordPointCount[RecordNumber] := Value;
end;

function TiShp.Get_FileType: iShapeType;
begin
    Result := DefaultInterface.FileType;
end;

function TiShp.Get_IdType: iDataTypeConst;
begin
    Result := DefaultInterface.IdType;
end;

function TiShp.Get_MaxSize: Integer;
begin
    Result := DefaultInterface.MaxSize;
end;

procedure TiShp.Set_MaxSize(Value: Integer);
begin
  DefaultInterface.Set_MaxSize(Value);
end;

function TiShp.Get_Val: iVal;
begin
    Result := DefaultInterface.Val;
end;

procedure TiShp.Set_Val(const Value: iVal);
begin
  DefaultInterface.Set_Val(Value);
end;

function TiShp.Get_RecordColor(RecordNumber: Integer): Integer;
begin
    Result := DefaultInterface.RecordColor[RecordNumber];
end;

function TiShp.Get_Paint: iPaint;
begin
    Result := DefaultInterface.Paint;
end;

procedure TiShp.Set_Paint(const Value: iPaint);
begin
  DefaultInterface.Set_Paint(Value);
end;

function TiShp.Get_DrawLabels: WordBool;
begin
    Result := DefaultInterface.DrawLabels;
end;

procedure TiShp.Set_DrawLabels(Value: WordBool);
begin
  DefaultInterface.Set_DrawLabels(Value);
end;

function TiShp.Get_RecordBox(RecordNumber: Integer; Position: Integer): OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.RecordBox[RecordNumber, Position];
end;

function TiShp.Get_DisabledRecord(RecordNumber: Integer): WordBool;
begin
    Result := DefaultInterface.DisabledRecord[RecordNumber];
end;

procedure TiShp.Set_DisabledRecord(RecordNumber: Integer; Value: WordBool);
begin
  DefaultInterface.DisabledRecord[RecordNumber] := Value;
end;

function TiShp.Get_Color(RecordNumber: Integer): WideString;
begin
    Result := DefaultInterface.Color[RecordNumber];
end;

procedure TiShp.Set_Color(RecordNumber: Integer; const Value: WideString);
  { Warning: The property Color has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Color := Value;
end;

function TiShp.Get_Selected(RecordNumber: Integer): WordBool;
begin
    Result := DefaultInterface.Selected[RecordNumber];
end;

procedure TiShp.Set_Selected(RecordNumber: Integer; Value: WordBool);
begin
  DefaultInterface.Selected[RecordNumber] := Value;
end;

procedure TiShp.Set_SelectAll(Param1: WordBool);
begin
  DefaultInterface.Set_SelectAll(Param1);
end;

function TiShp.Get_LabelColor(RecordNumber: Integer): WideString;
begin
    Result := DefaultInterface.LabelColor[RecordNumber];
end;

procedure TiShp.Set_LabelColor(RecordNumber: Integer; const Value: WideString);
  { Warning: The property LabelColor has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.LabelColor := Value;
end;

function TiShp.Get_LabelStyle(RecordNumber: Integer): WideString;
begin
    Result := DefaultInterface.LabelStyle[RecordNumber];
end;

procedure TiShp.Set_LabelStyle(RecordNumber: Integer; const Value: WideString);
  { Warning: The property LabelStyle has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.LabelStyle := Value;
end;

function TiShp.Get_LabelSize(RecordNumber: Integer): Smallint;
begin
    Result := DefaultInterface.LabelSize[RecordNumber];
end;

procedure TiShp.Set_LabelSize(RecordNumber: Integer; Value: Smallint);
begin
  DefaultInterface.LabelSize[RecordNumber] := Value;
end;

function TiShp.Get_LabelFontName(RecordNumber: Integer): WideString;
begin
    Result := DefaultInterface.LabelFontName[RecordNumber];
end;

procedure TiShp.Set_LabelFontName(RecordNumber: Integer; const Value: WideString);
  { Warning: The property LabelFontName has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.LabelFontName := Value;
end;

function TiShp.Get_PenColor(RecordNumber: Integer): WideString;
begin
    Result := DefaultInterface.PenColor[RecordNumber];
end;

procedure TiShp.Set_PenColor(RecordNumber: Integer; const Value: WideString);
  { Warning: The property PenColor has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.PenColor := Value;
end;

function TiShp.Get_Parts(RecordNumber: Integer; PartNumber: Integer): Integer;
begin
    Result := DefaultInterface.Parts[RecordNumber, PartNumber];
end;

procedure TiShp.Set_Parts(RecordNumber: Integer; PartNumber: Integer; Value: Integer);
begin
  DefaultInterface.Parts[RecordNumber, PartNumber] := Value;
end;

function TiShp.Get_ZMin: Double;
begin
    Result := DefaultInterface.ZMin;
end;

function TiShp.Get_ZMax: Double;
begin
    Result := DefaultInterface.ZMax;
end;

function TiShp.Get_Mmin: Double;
begin
    Result := DefaultInterface.Mmin;
end;

function TiShp.Get_Mmax: Double;
begin
    Result := DefaultInterface.Mmax;
end;

function TiShp.Get_Version: Integer;
begin
    Result := DefaultInterface.Version;
end;

function TiShp.Get_FileCode: Integer;
begin
    Result := DefaultInterface.FileCode;
end;

function TiShp.ArrayOfVar(SourceArray: OleVariant): OleVariant;
begin
  Result := DefaultInterface.ArrayOfVar(SourceArray);
end;

procedure TiShp.AssignObject(const Source: iData);
begin
  DefaultInterface.AssignObject(Source);
end;

procedure TiShp.PasteGeoRefs(const PassVar: iGeoData);
begin
  DefaultInterface.PasteGeoRefs(PassVar);
end;

function TiShp.Open: WordBool;
begin
  Result := DefaultInterface.Open;
end;

procedure TiShp.Save;
begin
  DefaultInterface.Save;
end;

function TiShp.Terminate: WordBool;
begin
  Result := DefaultInterface.Terminate;
end;

procedure TiShp.SaveHeader;
begin
  DefaultInterface.SaveHeader;
end;

function TiShp.OpenHeader: WordBool;
begin
  Result := DefaultInterface.OpenHeader;
end;

function TiShp.OpenWindow(X1: OleVariant; Y1: OleVariant; X2: OleVariant; Y2: OleVariant; 
                          Step: Smallint): WordBool;
begin
  Result := DefaultInterface.OpenWindow(X1, Y1, X2, Y2, Step);
end;

function TiShp.OpenSample(Step: Smallint): WordBool;
begin
  Result := DefaultInterface.OpenSample(Step);
end;

procedure TiShp.PasteHDC(BitmapHDC: Integer; Width: Integer; Height: Integer);
begin
  DefaultInterface.PasteHDC(BitmapHDC, Width, Height);
end;

procedure TiShp.Refresh;
begin
  DefaultInterface.Refresh;
end;

procedure TiShp.ClearBitmap;
begin
  DefaultInterface.ClearBitmap;
end;

function TiShp.StreamMapAs(StreamType: iStreamType): OleVariant;
begin
  Result := DefaultInterface.StreamMapAs(StreamType);
end;

procedure TiShp.PaintPoint(X: OleVariant; Y: OleVariant; Radius: OleVariant; const Color: WideString);
begin
  DefaultInterface.PaintPoint(X, Y, Radius, Color);
end;

procedure TiShp.PaintLine(X1: OleVariant; Y1: OleVariant; X2: OleVariant; Y2: OleVariant; 
                          Width: OleVariant; const Color: WideString);
begin
  DefaultInterface.PaintLine(X1, Y1, X2, Y2, Width, Color);
end;

procedure TiShp.PaintPolygon(Points: OleVariant; LineWidth: Integer; const Color: WideString; 
                             BrushStyle: iBrushStyle; IsGeographic: WordBool);
begin
  DefaultInterface.PaintPolygon(Points, LineWidth, Color, BrushStyle, IsGeographic);
end;

procedure TiShp.PaintText(X: OleVariant; Y: OleVariant; const Text: WideString; 
                          const FontName: WideString; Size: Integer; const Style: WideString; 
                          const Color: WideString);
begin
  DefaultInterface.PaintText(X, Y, Text, FontName, Size, Style, Color);
end;

function TiShp.StreamAs(StreamType: iStreamType): OleVariant;
begin
  Result := DefaultInterface.StreamAs(StreamType);
end;

procedure TiShp.Draw(Left: Integer; Top: Integer; Zoom: Single; PictureHandle: Integer);
begin
  DefaultInterface.Draw(Left, Top, Zoom, PictureHandle);
end;

procedure TiShp.DrawMap(Zoom: Single; PictureHandle: Integer);
begin
  DefaultInterface.DrawMap(Zoom, PictureHandle);
end;

procedure TiShp.CopyMap(Zoom: Single);
begin
  DefaultInterface.CopyMap(Zoom);
end;

procedure TiShp.Copy;
begin
  DefaultInterface.Copy;
end;

procedure TiShp.StretchDraw(hDC: Integer; X1: Double; Y1: Double; X2: Double; Y2: Double; 
                            Left: Integer; Top: Integer; Right: Integer; Bottom: Integer);
begin
  DefaultInterface.StretchDraw(hDC, X1, Y1, X2, Y2, Left, Top, Right, Bottom);
end;

function TiShp.GetDataBuffer(out DataOut: OleVariant): Integer;
begin
  Result := DefaultInterface.GetDataBuffer(DataOut);
end;

procedure TiShp.SetDataBuffer(DataIn: OleVariant);
begin
  DefaultInterface.SetDataBuffer(DataIn);
end;

function TiShp.RetrieveBitmap(Source: OleVariant; TimeOut_Sec: Integer; X1: Integer; Y1: Integer; 
                              X2: Integer; Y2: Integer; Transparency: Byte): Integer;
begin
  Result := DefaultInterface.RetrieveBitmap(Source, TimeOut_Sec, X1, Y1, X2, Y2, Transparency);
end;

procedure TiShp.DrawObject(hDC: Integer; RecordNumber: Integer; X: Integer; Y: Integer);
begin
  DefaultInterface.DrawObject(hDC, RecordNumber, X, Y, EmptyParam);
end;

procedure TiShp.DrawObject(hDC: Integer; RecordNumber: Integer; X: Integer; Y: Integer; 
                           Color: OleVariant);
begin
  DefaultInterface.DrawObject(hDC, RecordNumber, X, Y, Color);
end;

procedure TiShp.AddRecordPoints(ObjectData: OleVariant; Id: Single; RecordNumber: Integer);
begin
  DefaultInterface.AddRecordPoints(ObjectData, Id, RecordNumber);
end;

procedure TiShp.New(const Name: WideString; ObjectsType: iShapeType; IdType: iDataTypeConst);
begin
  DefaultInterface.New(Name, ObjectsType, IdType);
end;

function TiShp.GetRecordBuffer(RecordNumber: Integer): OleVariant;
begin
  Result := DefaultInterface.GetRecordBuffer(RecordNumber);
end;

function TiShp.IndexOf(Value: OleVariant): OleVariant;
begin
  Result := DefaultInterface.IndexOf(Value);
end;

function TiShp.IsPointInPolygon(PolygonIndex: Integer; X: Single; Y: Single): WordBool;
begin
  Result := DefaultInterface.IsPointInPolygon(PolygonIndex, X, Y);
end;

procedure TiShp.Insert(ObjectData: OleVariant; Position: Integer; Id: Integer);
begin
  DefaultInterface.Insert(ObjectData, Position, Id);
end;

procedure TiShp.Exchange(Pos1: Integer; Pos2: Integer);
begin
  DefaultInterface.Exchange(Pos1, Pos2);
end;

procedure TiShp.Delete(RecordNumber: Integer);
begin
  DefaultInterface.Delete(RecordNumber);
end;

procedure TiShp.DrawSquare(hDC: Integer; X1: Double; Y1: Double; X2: Double; Y2: Double; 
                           X: Integer; Y: Integer; Color: Integer; Width: Integer);
begin
  DefaultInterface.DrawSquare(hDC, X1, Y1, X2, Y2, X, Y, Color, Width);
end;

function TiShp.GetRecordPoints(RecordNumber: Integer): OleVariant;
begin
  Result := DefaultInterface.GetRecordPoints(RecordNumber);
end;

function TiShp.SelectString(const QueryString: WideString; AddToSelection: WordBool): WordBool;
begin
  Result := DefaultInterface.SelectString(QueryString, AddToSelection);
end;

procedure TiShp.SetRecordPoints(RecordNumber: Integer; Value: OleVariant);
begin
  DefaultInterface.SetRecordPoints(RecordNumber, Value);
end;

function TiShp.GetDisabledRecords: OleVariant;
begin
  Result := DefaultInterface.GetDisabledRecords;
end;

procedure TiShp.SetDisabledRecords(Value: OleVariant);
begin
  DefaultInterface.SetDisabledRecords(Value);
end;

function TiShp.GetSelectedRecords: OleVariant;
begin
  Result := DefaultInterface.GetSelectedRecords;
end;

procedure TiShp.SetSelectedRecords(Value: OleVariant);
begin
  DefaultInterface.SetSelectedRecords(Value);
end;

procedure TiShp.AddRecordBuffer(ObjectData: OleVariant; Id: Single; Position: Integer);
begin
  DefaultInterface.AddRecordBuffer(ObjectData, Id, Position);
end;

procedure TiShp.DrawRecord(hDC: Integer; ObjectNumber: Integer; X: Integer; Y: Integer; 
                           Width: Integer; Height: Integer; const Color: WideString);
begin
  DefaultInterface.DrawRecord(hDC, ObjectNumber, X, Y, Width, Height, Color);
end;

procedure TiShp.SetLabelProperties(const FontName: WideString; const FontStyle: WideString; 
                                   const FontColor: WideString; FontSize: Integer);
begin
  DefaultInterface.SetLabelProperties(FontName, FontStyle, FontColor, FontSize);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TiShpProperties.Create(AServer: TiShp);
begin
  inherited Create;
  FServer := AServer;
end;

function TiShpProperties.GetDefaultInterface: IiShp;
begin
  Result := FServer.DefaultInterface;
end;

function TiShpProperties.Get_CheckStatus: Byte;
begin
    Result := DefaultInterface.CheckStatus;
end;

procedure TiShpProperties.Set_CheckStatus(Value: Byte);
begin
  DefaultInterface.Set_CheckStatus(Value);
end;

function TiShpProperties.Get_Empty: WordBool;
begin
    Result := DefaultInterface.Empty;
end;

procedure TiShpProperties.Set_Empty(Value: WordBool);
begin
  DefaultInterface.Set_Empty(Value);
end;

function TiShpProperties.Get_Changed: WordBool;
begin
    Result := DefaultInterface.Changed;
end;

procedure TiShpProperties.Set_Changed(Value: WordBool);
begin
  DefaultInterface.Set_Changed(Value);
end;

function TiShpProperties.Get_Error: WideString;
begin
    Result := DefaultInterface.Error;
end;

function TiShpProperties.Get_ObjectName: WideString;
begin
    Result := DefaultInterface.ObjectName;
end;

function TiShpProperties.Get_Process: IUnknown;
begin
    Result := DefaultInterface.Process;
end;

procedure TiShpProperties.Set_Process(const Value: IUnknown);
begin
  DefaultInterface.Set_Process(Value);
end;

function TiShpProperties.Get_DataHandle: Integer;
begin
    Result := DefaultInterface.DataHandle;
end;

function TiShpProperties.Get_Status: WideString;
begin
    Result := DefaultInterface.Status;
end;

function TiShpProperties.Get_Processing: WordBool;
begin
    Result := DefaultInterface.Processing;
end;

function TiShpProperties.Get_PercentDone: Byte;
begin
    Result := DefaultInterface.PercentDone;
end;

function TiShpProperties.Get_Title: WideString;
begin
    Result := DefaultInterface.Title;
end;

procedure TiShpProperties.Set_Title(const Value: WideString);
  { Warning: The property Title has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Title := Value;
end;

function TiShpProperties.Get_Legend: iLegend;
begin
    Result := DefaultInterface.Legend;
end;

procedure TiShpProperties.Set_Legend(const Value: iLegend);
begin
  DefaultInterface.Set_Legend(Value);
end;

function TiShpProperties.Get_hDC: Integer;
begin
    Result := DefaultInterface.hDC;
end;

function TiShpProperties.Get_MinX: Double;
begin
    Result := DefaultInterface.MinX;
end;

procedure TiShpProperties.Set_MinX(Value: Double);
begin
  DefaultInterface.Set_MinX(Value);
end;

function TiShpProperties.Get_MaxX: Double;
begin
    Result := DefaultInterface.MaxX;
end;

procedure TiShpProperties.Set_MaxX(Value: Double);
begin
  DefaultInterface.Set_MaxX(Value);
end;

function TiShpProperties.Get_MinY: Double;
begin
    Result := DefaultInterface.MinY;
end;

procedure TiShpProperties.Set_MinY(Value: Double);
begin
  DefaultInterface.Set_MinY(Value);
end;

function TiShpProperties.Get_MaxY: Double;
begin
    Result := DefaultInterface.MaxY;
end;

procedure TiShpProperties.Set_MaxY(Value: Double);
begin
  DefaultInterface.Set_MaxY(Value);
end;

function TiShpProperties.Get_Document: iFile;
begin
    Result := DefaultInterface.Document;
end;

procedure TiShpProperties.Set_Document(const Value: iFile);
begin
  DefaultInterface.Set_Document(Value);
end;

function TiShpProperties.Get_Comment: iStringList;
begin
    Result := DefaultInterface.Comment;
end;

procedure TiShpProperties.Set_Comment(const Value: iStringList);
begin
  DefaultInterface.Set_Comment(Value);
end;

function TiShpProperties.Get_Lineage: iStringList;
begin
    Result := DefaultInterface.Lineage;
end;

procedure TiShpProperties.Set_Lineage(const Value: iStringList);
begin
  DefaultInterface.Set_Lineage(Value);
end;

function TiShpProperties.Get_Completeness: iStringList;
begin
    Result := DefaultInterface.Completeness;
end;

procedure TiShpProperties.Set_Completeness(const Value: iStringList);
begin
  DefaultInterface.Set_Completeness(Value);
end;

function TiShpProperties.Get_Consistency: iStringList;
begin
    Result := DefaultInterface.Consistency;
end;

procedure TiShpProperties.Set_Consistency(const Value: iStringList);
begin
  DefaultInterface.Set_Consistency(Value);
end;

function TiShpProperties.Get_PartialScene: WordBool;
begin
    Result := DefaultInterface.PartialScene;
end;

function TiShpProperties.Get_ImageWidth: Integer;
begin
    Result := DefaultInterface.ImageWidth;
end;

procedure TiShpProperties.Set_ImageWidth(Value: Integer);
begin
  DefaultInterface.Set_ImageWidth(Value);
end;

function TiShpProperties.Get_ImageHeight: Integer;
begin
    Result := DefaultInterface.ImageHeight;
end;

procedure TiShpProperties.Set_ImageHeight(Value: Integer);
begin
  DefaultInterface.Set_ImageHeight(Value);
end;

function TiShpProperties.Get_PointXY(X: OleVariant; Y: OleVariant): OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.PointXY[X, Y];
end;

procedure TiShpProperties.Set_PointXY(X: OleVariant; Y: OleVariant; Value: OleVariant);
begin
  DefaultInterface.PointXY[X, Y] := Value;
end;

function TiShpProperties.Get_Count: Integer;
begin
    Result := DefaultInterface.Count;
end;

function TiShpProperties.Get_Value(RecordNumber: Integer): OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.Value[RecordNumber];
end;

procedure TiShpProperties.Set_Value(RecordNumber: Integer; Value: OleVariant);
begin
  DefaultInterface.Value[RecordNumber] := Value;
end;

function TiShpProperties.Get_RecordPointCount(RecordNumber: Integer): Integer;
begin
    Result := DefaultInterface.RecordPointCount[RecordNumber];
end;

procedure TiShpProperties.Set_RecordPointCount(RecordNumber: Integer; Value: Integer);
begin
  DefaultInterface.RecordPointCount[RecordNumber] := Value;
end;

function TiShpProperties.Get_FileType: iShapeType;
begin
    Result := DefaultInterface.FileType;
end;

function TiShpProperties.Get_IdType: iDataTypeConst;
begin
    Result := DefaultInterface.IdType;
end;

function TiShpProperties.Get_MaxSize: Integer;
begin
    Result := DefaultInterface.MaxSize;
end;

procedure TiShpProperties.Set_MaxSize(Value: Integer);
begin
  DefaultInterface.Set_MaxSize(Value);
end;

function TiShpProperties.Get_Val: iVal;
begin
    Result := DefaultInterface.Val;
end;

procedure TiShpProperties.Set_Val(const Value: iVal);
begin
  DefaultInterface.Set_Val(Value);
end;

function TiShpProperties.Get_RecordColor(RecordNumber: Integer): Integer;
begin
    Result := DefaultInterface.RecordColor[RecordNumber];
end;

function TiShpProperties.Get_Paint: iPaint;
begin
    Result := DefaultInterface.Paint;
end;

procedure TiShpProperties.Set_Paint(const Value: iPaint);
begin
  DefaultInterface.Set_Paint(Value);
end;

function TiShpProperties.Get_DrawLabels: WordBool;
begin
    Result := DefaultInterface.DrawLabels;
end;

procedure TiShpProperties.Set_DrawLabels(Value: WordBool);
begin
  DefaultInterface.Set_DrawLabels(Value);
end;

function TiShpProperties.Get_RecordBox(RecordNumber: Integer; Position: Integer): OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.RecordBox[RecordNumber, Position];
end;

function TiShpProperties.Get_DisabledRecord(RecordNumber: Integer): WordBool;
begin
    Result := DefaultInterface.DisabledRecord[RecordNumber];
end;

procedure TiShpProperties.Set_DisabledRecord(RecordNumber: Integer; Value: WordBool);
begin
  DefaultInterface.DisabledRecord[RecordNumber] := Value;
end;

function TiShpProperties.Get_Color(RecordNumber: Integer): WideString;
begin
    Result := DefaultInterface.Color[RecordNumber];
end;

procedure TiShpProperties.Set_Color(RecordNumber: Integer; const Value: WideString);
  { Warning: The property Color has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Color := Value;
end;

function TiShpProperties.Get_Selected(RecordNumber: Integer): WordBool;
begin
    Result := DefaultInterface.Selected[RecordNumber];
end;

procedure TiShpProperties.Set_Selected(RecordNumber: Integer; Value: WordBool);
begin
  DefaultInterface.Selected[RecordNumber] := Value;
end;

procedure TiShpProperties.Set_SelectAll(Param1: WordBool);
begin
  DefaultInterface.Set_SelectAll(Param1);
end;

function TiShpProperties.Get_LabelColor(RecordNumber: Integer): WideString;
begin
    Result := DefaultInterface.LabelColor[RecordNumber];
end;

procedure TiShpProperties.Set_LabelColor(RecordNumber: Integer; const Value: WideString);
  { Warning: The property LabelColor has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.LabelColor := Value;
end;

function TiShpProperties.Get_LabelStyle(RecordNumber: Integer): WideString;
begin
    Result := DefaultInterface.LabelStyle[RecordNumber];
end;

procedure TiShpProperties.Set_LabelStyle(RecordNumber: Integer; const Value: WideString);
  { Warning: The property LabelStyle has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.LabelStyle := Value;
end;

function TiShpProperties.Get_LabelSize(RecordNumber: Integer): Smallint;
begin
    Result := DefaultInterface.LabelSize[RecordNumber];
end;

procedure TiShpProperties.Set_LabelSize(RecordNumber: Integer; Value: Smallint);
begin
  DefaultInterface.LabelSize[RecordNumber] := Value;
end;

function TiShpProperties.Get_LabelFontName(RecordNumber: Integer): WideString;
begin
    Result := DefaultInterface.LabelFontName[RecordNumber];
end;

procedure TiShpProperties.Set_LabelFontName(RecordNumber: Integer; const Value: WideString);
  { Warning: The property LabelFontName has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.LabelFontName := Value;
end;

function TiShpProperties.Get_PenColor(RecordNumber: Integer): WideString;
begin
    Result := DefaultInterface.PenColor[RecordNumber];
end;

procedure TiShpProperties.Set_PenColor(RecordNumber: Integer; const Value: WideString);
  { Warning: The property PenColor has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.PenColor := Value;
end;

function TiShpProperties.Get_Parts(RecordNumber: Integer; PartNumber: Integer): Integer;
begin
    Result := DefaultInterface.Parts[RecordNumber, PartNumber];
end;

procedure TiShpProperties.Set_Parts(RecordNumber: Integer; PartNumber: Integer; Value: Integer);
begin
  DefaultInterface.Parts[RecordNumber, PartNumber] := Value;
end;

function TiShpProperties.Get_ZMin: Double;
begin
    Result := DefaultInterface.ZMin;
end;

function TiShpProperties.Get_ZMax: Double;
begin
    Result := DefaultInterface.ZMax;
end;

function TiShpProperties.Get_Mmin: Double;
begin
    Result := DefaultInterface.Mmin;
end;

function TiShpProperties.Get_Mmax: Double;
begin
    Result := DefaultInterface.Mmax;
end;

function TiShpProperties.Get_Version: Integer;
begin
    Result := DefaultInterface.Version;
end;

function TiShpProperties.Get_FileCode: Integer;
begin
    Result := DefaultInterface.FileCode;
end;

{$ENDIF}

class function CoiIdrisiVal.Create: IIiDRISIVal;
begin
  Result := CreateComObject(CLASS_iIdrisiVal) as IIiDRISIVal;
end;

class function CoiIdrisiVal.CreateRemote(const MachineName: string): IIiDRISIVal;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_iIdrisiVal) as IIiDRISIVal;
end;

procedure TiIdrisiVal.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{F1DD7E33-BC5F-11D3-A532-0000E85E2CDE}';
    IntfIID:   '{F1DD7E31-BC5F-11D3-A532-0000E85E2CDE}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TiIdrisiVal.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IIiDRISIVal;
  end;
end;

procedure TiIdrisiVal.ConnectTo(svrIntf: IIiDRISIVal);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TiIdrisiVal.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TiIdrisiVal.GetDefaultInterface: IIiDRISIVal;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TiIdrisiVal.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TiIdrisiValProperties.Create(Self);
{$ENDIF}
end;

destructor TiIdrisiVal.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TiIdrisiVal.GetServerProperties: TiIdrisiValProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TiIdrisiVal.Get_CheckStatus: Byte;
begin
    Result := DefaultInterface.CheckStatus;
end;

procedure TiIdrisiVal.Set_CheckStatus(Value: Byte);
begin
  DefaultInterface.Set_CheckStatus(Value);
end;

function TiIdrisiVal.Get_Empty: WordBool;
begin
    Result := DefaultInterface.Empty;
end;

procedure TiIdrisiVal.Set_Empty(Value: WordBool);
begin
  DefaultInterface.Set_Empty(Value);
end;

function TiIdrisiVal.Get_Changed: WordBool;
begin
    Result := DefaultInterface.Changed;
end;

procedure TiIdrisiVal.Set_Changed(Value: WordBool);
begin
  DefaultInterface.Set_Changed(Value);
end;

function TiIdrisiVal.Get_Error: WideString;
begin
    Result := DefaultInterface.Error;
end;

function TiIdrisiVal.Get_ObjectName: WideString;
begin
    Result := DefaultInterface.ObjectName;
end;

function TiIdrisiVal.Get_Process: IUnknown;
begin
    Result := DefaultInterface.Process;
end;

procedure TiIdrisiVal.Set_Process(const Value: IUnknown);
begin
  DefaultInterface.Set_Process(Value);
end;

function TiIdrisiVal.Get_DataHandle: Integer;
begin
    Result := DefaultInterface.DataHandle;
end;

function TiIdrisiVal.Get_Status: WideString;
begin
    Result := DefaultInterface.Status;
end;

function TiIdrisiVal.Get_Processing: WordBool;
begin
    Result := DefaultInterface.Processing;
end;

function TiIdrisiVal.Get_PercentDone: Byte;
begin
    Result := DefaultInterface.PercentDone;
end;

function TiIdrisiVal.Get_RecordCount: Integer;
begin
    Result := DefaultInterface.RecordCount;
end;

function TiIdrisiVal.Get_FeatureType(FeatureIndex: OleVariant): iFeatureType;
begin
    Result := DefaultInterface.FeatureType[FeatureIndex];
end;

procedure TiIdrisiVal.Set_FeatureType(FeatureIndex: OleVariant; Value: iFeatureType);
begin
  DefaultInterface.FeatureType[FeatureIndex] := Value;
end;

function TiIdrisiVal.Get_FeatureCount: Integer;
begin
    Result := DefaultInterface.FeatureCount;
end;

function TiIdrisiVal.Get_FeatureData(FieldNumber: OleVariant): OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.FeatureData[FieldNumber];
end;

procedure TiIdrisiVal.Set_FeatureData(FieldNumber: OleVariant; Value: OleVariant);
begin
  DefaultInterface.FeatureData[FieldNumber] := Value;
end;

function TiIdrisiVal.Get_Document: iFile;
begin
    Result := DefaultInterface.Document;
end;

procedure TiIdrisiVal.Set_Document(const Value: iFile);
begin
  DefaultInterface.Set_Document(Value);
end;

function TiIdrisiVal.Get_Legend(FeatureIndex: OleVariant): iLegend;
begin
    Result := DefaultInterface.Legend[FeatureIndex];
end;

procedure TiIdrisiVal.Set_Legend(FeatureIndex: OleVariant; const Value: iLegend);
begin
  DefaultInterface.Legend[FeatureIndex] := Value;
end;

function TiIdrisiVal.Get_ActiveFeature: Integer;
begin
    Result := DefaultInterface.ActiveFeature;
end;

procedure TiIdrisiVal.Set_ActiveFeature(Value: Integer);
begin
  DefaultInterface.Set_ActiveFeature(Value);
end;

function TiIdrisiVal.Get_IDData: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.IDData;
end;

procedure TiIdrisiVal.Set_IDData(Value: OleVariant);
begin
  DefaultInterface.Set_IDData(Value);
end;

function TiIdrisiVal.Get_FeatureName(Index_: Integer): WideString;
begin
    Result := DefaultInterface.FeatureName[Index_];
end;

function TiIdrisiVal.Get_RecordData(RecordIndex: Integer; FeatureIndex: OleVariant): OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.RecordData[RecordIndex, FeatureIndex];
end;

procedure TiIdrisiVal.Set_RecordData(RecordIndex: Integer; FeatureIndex: OleVariant; 
                                     Value: OleVariant);
begin
  DefaultInterface.RecordData[RecordIndex, FeatureIndex] := Value;
end;

function TiIdrisiVal.Get_Lineage: iStringList;
begin
    Result := DefaultInterface.Lineage;
end;

procedure TiIdrisiVal.Set_Lineage(const Value: iStringList);
begin
  DefaultInterface.Set_Lineage(Value);
end;

function TiIdrisiVal.Get_Comment: iStringList;
begin
    Result := DefaultInterface.Comment;
end;

procedure TiIdrisiVal.Set_Comment(const Value: iStringList);
begin
  DefaultInterface.Set_Comment(Value);
end;

function TiIdrisiVal.Get_Completeness: iStringList;
begin
    Result := DefaultInterface.Completeness;
end;

procedure TiIdrisiVal.Set_Completeness(const Value: iStringList);
begin
  DefaultInterface.Set_Completeness(Value);
end;

function TiIdrisiVal.Get_Consistency: iStringList;
begin
    Result := DefaultInterface.Consistency;
end;

procedure TiIdrisiVal.Set_Consistency(const Value: iStringList);
begin
  DefaultInterface.Set_Consistency(Value);
end;

function TiIdrisiVal.ArrayOfVar(SourceArray: OleVariant): OleVariant;
begin
  Result := DefaultInterface.ArrayOfVar(SourceArray);
end;

procedure TiIdrisiVal.AssignObject(const Source: iData);
begin
  DefaultInterface.AssignObject(Source);
end;

function TiIdrisiVal.Open(ReadOnly: WordBool): WordBool;
begin
  Result := DefaultInterface.Open(ReadOnly);
end;

procedure TiIdrisiVal.Save;
begin
  DefaultInterface.Save;
end;

function TiIdrisiVal.OpenHeader: WordBool;
begin
  Result := DefaultInterface.OpenHeader;
end;

procedure TiIdrisiVal.SaveHeader;
begin
  DefaultInterface.SaveHeader;
end;

procedure TiIdrisiVal.AddFeature(DataFeature: OleVariant; FeatureType: iFeatureType; 
                                 const Name: WideString);
begin
  DefaultInterface.AddFeature(DataFeature, FeatureType, Name);
end;

procedure TiIdrisiVal.Clear;
begin
  DefaultInterface.Clear;
end;

function TiIdrisiVal.IsFeatureDifValuesMoreThan(FeatureIndex: Integer; Value: Integer): WordBool;
begin
  Result := DefaultInterface.IsFeatureDifValuesMoreThan(FeatureIndex, Value);
end;

procedure TiIdrisiVal.AddRecord(RecordPosition: Integer);
begin
  DefaultInterface.AddRecord(RecordPosition);
end;

procedure TiIdrisiVal.Delete(RecordNumber: Integer);
begin
  DefaultInterface.Delete(RecordNumber);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TiIdrisiValProperties.Create(AServer: TiIdrisiVal);
begin
  inherited Create;
  FServer := AServer;
end;

function TiIdrisiValProperties.GetDefaultInterface: IIiDRISIVal;
begin
  Result := FServer.DefaultInterface;
end;

function TiIdrisiValProperties.Get_CheckStatus: Byte;
begin
    Result := DefaultInterface.CheckStatus;
end;

procedure TiIdrisiValProperties.Set_CheckStatus(Value: Byte);
begin
  DefaultInterface.Set_CheckStatus(Value);
end;

function TiIdrisiValProperties.Get_Empty: WordBool;
begin
    Result := DefaultInterface.Empty;
end;

procedure TiIdrisiValProperties.Set_Empty(Value: WordBool);
begin
  DefaultInterface.Set_Empty(Value);
end;

function TiIdrisiValProperties.Get_Changed: WordBool;
begin
    Result := DefaultInterface.Changed;
end;

procedure TiIdrisiValProperties.Set_Changed(Value: WordBool);
begin
  DefaultInterface.Set_Changed(Value);
end;

function TiIdrisiValProperties.Get_Error: WideString;
begin
    Result := DefaultInterface.Error;
end;

function TiIdrisiValProperties.Get_ObjectName: WideString;
begin
    Result := DefaultInterface.ObjectName;
end;

function TiIdrisiValProperties.Get_Process: IUnknown;
begin
    Result := DefaultInterface.Process;
end;

procedure TiIdrisiValProperties.Set_Process(const Value: IUnknown);
begin
  DefaultInterface.Set_Process(Value);
end;

function TiIdrisiValProperties.Get_DataHandle: Integer;
begin
    Result := DefaultInterface.DataHandle;
end;

function TiIdrisiValProperties.Get_Status: WideString;
begin
    Result := DefaultInterface.Status;
end;

function TiIdrisiValProperties.Get_Processing: WordBool;
begin
    Result := DefaultInterface.Processing;
end;

function TiIdrisiValProperties.Get_PercentDone: Byte;
begin
    Result := DefaultInterface.PercentDone;
end;

function TiIdrisiValProperties.Get_RecordCount: Integer;
begin
    Result := DefaultInterface.RecordCount;
end;

function TiIdrisiValProperties.Get_FeatureType(FeatureIndex: OleVariant): iFeatureType;
begin
    Result := DefaultInterface.FeatureType[FeatureIndex];
end;

procedure TiIdrisiValProperties.Set_FeatureType(FeatureIndex: OleVariant; Value: iFeatureType);
begin
  DefaultInterface.FeatureType[FeatureIndex] := Value;
end;

function TiIdrisiValProperties.Get_FeatureCount: Integer;
begin
    Result := DefaultInterface.FeatureCount;
end;

function TiIdrisiValProperties.Get_FeatureData(FieldNumber: OleVariant): OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.FeatureData[FieldNumber];
end;

procedure TiIdrisiValProperties.Set_FeatureData(FieldNumber: OleVariant; Value: OleVariant);
begin
  DefaultInterface.FeatureData[FieldNumber] := Value;
end;

function TiIdrisiValProperties.Get_Document: iFile;
begin
    Result := DefaultInterface.Document;
end;

procedure TiIdrisiValProperties.Set_Document(const Value: iFile);
begin
  DefaultInterface.Set_Document(Value);
end;

function TiIdrisiValProperties.Get_Legend(FeatureIndex: OleVariant): iLegend;
begin
    Result := DefaultInterface.Legend[FeatureIndex];
end;

procedure TiIdrisiValProperties.Set_Legend(FeatureIndex: OleVariant; const Value: iLegend);
begin
  DefaultInterface.Legend[FeatureIndex] := Value;
end;

function TiIdrisiValProperties.Get_ActiveFeature: Integer;
begin
    Result := DefaultInterface.ActiveFeature;
end;

procedure TiIdrisiValProperties.Set_ActiveFeature(Value: Integer);
begin
  DefaultInterface.Set_ActiveFeature(Value);
end;

function TiIdrisiValProperties.Get_IDData: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.IDData;
end;

procedure TiIdrisiValProperties.Set_IDData(Value: OleVariant);
begin
  DefaultInterface.Set_IDData(Value);
end;

function TiIdrisiValProperties.Get_FeatureName(Index_: Integer): WideString;
begin
    Result := DefaultInterface.FeatureName[Index_];
end;

function TiIdrisiValProperties.Get_RecordData(RecordIndex: Integer; FeatureIndex: OleVariant): OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.RecordData[RecordIndex, FeatureIndex];
end;

procedure TiIdrisiValProperties.Set_RecordData(RecordIndex: Integer; FeatureIndex: OleVariant; 
                                               Value: OleVariant);
begin
  DefaultInterface.RecordData[RecordIndex, FeatureIndex] := Value;
end;

function TiIdrisiValProperties.Get_Lineage: iStringList;
begin
    Result := DefaultInterface.Lineage;
end;

procedure TiIdrisiValProperties.Set_Lineage(const Value: iStringList);
begin
  DefaultInterface.Set_Lineage(Value);
end;

function TiIdrisiValProperties.Get_Comment: iStringList;
begin
    Result := DefaultInterface.Comment;
end;

procedure TiIdrisiValProperties.Set_Comment(const Value: iStringList);
begin
  DefaultInterface.Set_Comment(Value);
end;

function TiIdrisiValProperties.Get_Completeness: iStringList;
begin
    Result := DefaultInterface.Completeness;
end;

procedure TiIdrisiValProperties.Set_Completeness(const Value: iStringList);
begin
  DefaultInterface.Set_Completeness(Value);
end;

function TiIdrisiValProperties.Get_Consistency: iStringList;
begin
    Result := DefaultInterface.Consistency;
end;

procedure TiIdrisiValProperties.Set_Consistency(const Value: iStringList);
begin
  DefaultInterface.Set_Consistency(Value);
end;

{$ENDIF}

class function CoiDbf.Create: IiDbf;
begin
  Result := CreateComObject(CLASS_iDbf) as IiDbf;
end;

class function CoiDbf.CreateRemote(const MachineName: string): IiDbf;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_iDbf) as IiDbf;
end;

procedure TiDbf.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{F1DD7E37-BC5F-11D3-A532-0000E85E2CDE}';
    IntfIID:   '{F1DD7E35-BC5F-11D3-A532-0000E85E2CDE}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TiDbf.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IiDbf;
  end;
end;

procedure TiDbf.ConnectTo(svrIntf: IiDbf);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TiDbf.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TiDbf.GetDefaultInterface: IiDbf;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TiDbf.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TiDbfProperties.Create(Self);
{$ENDIF}
end;

destructor TiDbf.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TiDbf.GetServerProperties: TiDbfProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TiDbf.Get_CheckStatus: Byte;
begin
    Result := DefaultInterface.CheckStatus;
end;

procedure TiDbf.Set_CheckStatus(Value: Byte);
begin
  DefaultInterface.Set_CheckStatus(Value);
end;

function TiDbf.Get_Empty: WordBool;
begin
    Result := DefaultInterface.Empty;
end;

procedure TiDbf.Set_Empty(Value: WordBool);
begin
  DefaultInterface.Set_Empty(Value);
end;

function TiDbf.Get_Changed: WordBool;
begin
    Result := DefaultInterface.Changed;
end;

procedure TiDbf.Set_Changed(Value: WordBool);
begin
  DefaultInterface.Set_Changed(Value);
end;

function TiDbf.Get_Error: WideString;
begin
    Result := DefaultInterface.Error;
end;

function TiDbf.Get_ObjectName: WideString;
begin
    Result := DefaultInterface.ObjectName;
end;

function TiDbf.Get_Process: IUnknown;
begin
    Result := DefaultInterface.Process;
end;

procedure TiDbf.Set_Process(const Value: IUnknown);
begin
  DefaultInterface.Set_Process(Value);
end;

function TiDbf.Get_DataHandle: Integer;
begin
    Result := DefaultInterface.DataHandle;
end;

function TiDbf.Get_Status: WideString;
begin
    Result := DefaultInterface.Status;
end;

function TiDbf.Get_Processing: WordBool;
begin
    Result := DefaultInterface.Processing;
end;

function TiDbf.Get_PercentDone: Byte;
begin
    Result := DefaultInterface.PercentDone;
end;

function TiDbf.Get_RecordCount: Integer;
begin
    Result := DefaultInterface.RecordCount;
end;

function TiDbf.Get_FeatureType(FeatureIndex: OleVariant): iFeatureType;
begin
    Result := DefaultInterface.FeatureType[FeatureIndex];
end;

procedure TiDbf.Set_FeatureType(FeatureIndex: OleVariant; Value: iFeatureType);
begin
  DefaultInterface.FeatureType[FeatureIndex] := Value;
end;

function TiDbf.Get_FeatureCount: Integer;
begin
    Result := DefaultInterface.FeatureCount;
end;

function TiDbf.Get_FeatureData(FieldNumber: OleVariant): OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.FeatureData[FieldNumber];
end;

procedure TiDbf.Set_FeatureData(FieldNumber: OleVariant; Value: OleVariant);
begin
  DefaultInterface.FeatureData[FieldNumber] := Value;
end;

function TiDbf.Get_Document: iFile;
begin
    Result := DefaultInterface.Document;
end;

procedure TiDbf.Set_Document(const Value: iFile);
begin
  DefaultInterface.Set_Document(Value);
end;

function TiDbf.Get_Legend(FeatureIndex: OleVariant): iLegend;
begin
    Result := DefaultInterface.Legend[FeatureIndex];
end;

procedure TiDbf.Set_Legend(FeatureIndex: OleVariant; const Value: iLegend);
begin
  DefaultInterface.Legend[FeatureIndex] := Value;
end;

function TiDbf.Get_ActiveFeature: Integer;
begin
    Result := DefaultInterface.ActiveFeature;
end;

procedure TiDbf.Set_ActiveFeature(Value: Integer);
begin
  DefaultInterface.Set_ActiveFeature(Value);
end;

function TiDbf.Get_IDData: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.IDData;
end;

procedure TiDbf.Set_IDData(Value: OleVariant);
begin
  DefaultInterface.Set_IDData(Value);
end;

function TiDbf.Get_FeatureName(Index_: Integer): WideString;
begin
    Result := DefaultInterface.FeatureName[Index_];
end;

function TiDbf.Get_RecordData(RecordIndex: Integer; FeatureIndex: OleVariant): OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.RecordData[RecordIndex, FeatureIndex];
end;

procedure TiDbf.Set_RecordData(RecordIndex: Integer; FeatureIndex: OleVariant; Value: OleVariant);
begin
  DefaultInterface.RecordData[RecordIndex, FeatureIndex] := Value;
end;

procedure TiDbf.Set_RecordsToBeOpened(Param1: OleVariant);
begin
  DefaultInterface.Set_RecordsToBeOpened(Param1);
end;

function TiDbf.ArrayOfVar(SourceArray: OleVariant): OleVariant;
begin
  Result := DefaultInterface.ArrayOfVar(SourceArray);
end;

procedure TiDbf.AssignObject(const Source: iData);
begin
  DefaultInterface.AssignObject(Source);
end;

function TiDbf.Open(ReadOnly: WordBool): WordBool;
begin
  Result := DefaultInterface.Open(ReadOnly);
end;

procedure TiDbf.Save;
begin
  DefaultInterface.Save;
end;

function TiDbf.OpenHeader: WordBool;
begin
  Result := DefaultInterface.OpenHeader;
end;

procedure TiDbf.SaveHeader;
begin
  DefaultInterface.SaveHeader;
end;

procedure TiDbf.AddFeature(DataFeature: OleVariant; FeatureType: iFeatureType; 
                           const Name: WideString);
begin
  DefaultInterface.AddFeature(DataFeature, FeatureType, Name);
end;

procedure TiDbf.Clear;
begin
  DefaultInterface.Clear;
end;

function TiDbf.IsFeatureDifValuesMoreThan(FeatureIndex: Integer; Value: Integer): WordBool;
begin
  Result := DefaultInterface.IsFeatureDifValuesMoreThan(FeatureIndex, Value);
end;

procedure TiDbf.AddRecord(RecordPosition: Integer);
begin
  DefaultInterface.AddRecord(RecordPosition);
end;

procedure TiDbf.Delete(RecordNumber: Integer);
begin
  DefaultInterface.Delete(RecordNumber);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TiDbfProperties.Create(AServer: TiDbf);
begin
  inherited Create;
  FServer := AServer;
end;

function TiDbfProperties.GetDefaultInterface: IiDbf;
begin
  Result := FServer.DefaultInterface;
end;

function TiDbfProperties.Get_CheckStatus: Byte;
begin
    Result := DefaultInterface.CheckStatus;
end;

procedure TiDbfProperties.Set_CheckStatus(Value: Byte);
begin
  DefaultInterface.Set_CheckStatus(Value);
end;

function TiDbfProperties.Get_Empty: WordBool;
begin
    Result := DefaultInterface.Empty;
end;

procedure TiDbfProperties.Set_Empty(Value: WordBool);
begin
  DefaultInterface.Set_Empty(Value);
end;

function TiDbfProperties.Get_Changed: WordBool;
begin
    Result := DefaultInterface.Changed;
end;

procedure TiDbfProperties.Set_Changed(Value: WordBool);
begin
  DefaultInterface.Set_Changed(Value);
end;

function TiDbfProperties.Get_Error: WideString;
begin
    Result := DefaultInterface.Error;
end;

function TiDbfProperties.Get_ObjectName: WideString;
begin
    Result := DefaultInterface.ObjectName;
end;

function TiDbfProperties.Get_Process: IUnknown;
begin
    Result := DefaultInterface.Process;
end;

procedure TiDbfProperties.Set_Process(const Value: IUnknown);
begin
  DefaultInterface.Set_Process(Value);
end;

function TiDbfProperties.Get_DataHandle: Integer;
begin
    Result := DefaultInterface.DataHandle;
end;

function TiDbfProperties.Get_Status: WideString;
begin
    Result := DefaultInterface.Status;
end;

function TiDbfProperties.Get_Processing: WordBool;
begin
    Result := DefaultInterface.Processing;
end;

function TiDbfProperties.Get_PercentDone: Byte;
begin
    Result := DefaultInterface.PercentDone;
end;

function TiDbfProperties.Get_RecordCount: Integer;
begin
    Result := DefaultInterface.RecordCount;
end;

function TiDbfProperties.Get_FeatureType(FeatureIndex: OleVariant): iFeatureType;
begin
    Result := DefaultInterface.FeatureType[FeatureIndex];
end;

procedure TiDbfProperties.Set_FeatureType(FeatureIndex: OleVariant; Value: iFeatureType);
begin
  DefaultInterface.FeatureType[FeatureIndex] := Value;
end;

function TiDbfProperties.Get_FeatureCount: Integer;
begin
    Result := DefaultInterface.FeatureCount;
end;

function TiDbfProperties.Get_FeatureData(FieldNumber: OleVariant): OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.FeatureData[FieldNumber];
end;

procedure TiDbfProperties.Set_FeatureData(FieldNumber: OleVariant; Value: OleVariant);
begin
  DefaultInterface.FeatureData[FieldNumber] := Value;
end;

function TiDbfProperties.Get_Document: iFile;
begin
    Result := DefaultInterface.Document;
end;

procedure TiDbfProperties.Set_Document(const Value: iFile);
begin
  DefaultInterface.Set_Document(Value);
end;

function TiDbfProperties.Get_Legend(FeatureIndex: OleVariant): iLegend;
begin
    Result := DefaultInterface.Legend[FeatureIndex];
end;

procedure TiDbfProperties.Set_Legend(FeatureIndex: OleVariant; const Value: iLegend);
begin
  DefaultInterface.Legend[FeatureIndex] := Value;
end;

function TiDbfProperties.Get_ActiveFeature: Integer;
begin
    Result := DefaultInterface.ActiveFeature;
end;

procedure TiDbfProperties.Set_ActiveFeature(Value: Integer);
begin
  DefaultInterface.Set_ActiveFeature(Value);
end;

function TiDbfProperties.Get_IDData: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.IDData;
end;

procedure TiDbfProperties.Set_IDData(Value: OleVariant);
begin
  DefaultInterface.Set_IDData(Value);
end;

function TiDbfProperties.Get_FeatureName(Index_: Integer): WideString;
begin
    Result := DefaultInterface.FeatureName[Index_];
end;

function TiDbfProperties.Get_RecordData(RecordIndex: Integer; FeatureIndex: OleVariant): OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.RecordData[RecordIndex, FeatureIndex];
end;

procedure TiDbfProperties.Set_RecordData(RecordIndex: Integer; FeatureIndex: OleVariant; 
                                         Value: OleVariant);
begin
  DefaultInterface.RecordData[RecordIndex, FeatureIndex] := Value;
end;

procedure TiDbfProperties.Set_RecordsToBeOpened(Param1: OleVariant);
begin
  DefaultInterface.Set_RecordsToBeOpened(Param1);
end;

{$ENDIF}

class function CoiPaint.Create: IiPaint;
begin
  Result := CreateComObject(CLASS_iPaint) as IiPaint;
end;

class function CoiPaint.CreateRemote(const MachineName: string): IiPaint;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_iPaint) as IiPaint;
end;

procedure TiPaint.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{5BA340A2-C918-11D3-BE9A-8CFFB6DC2143}';
    IntfIID:   '{5BA340A0-C918-11D3-BE9A-8CFFB6DC2143}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TiPaint.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IiPaint;
  end;
end;

procedure TiPaint.ConnectTo(svrIntf: IiPaint);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TiPaint.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TiPaint.GetDefaultInterface: IiPaint;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TiPaint.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TiPaintProperties.Create(Self);
{$ENDIF}
end;

destructor TiPaint.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TiPaint.GetServerProperties: TiPaintProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TiPaint.Get_BrushStyle: iBrushStyle;
begin
    Result := DefaultInterface.BrushStyle;
end;

procedure TiPaint.Set_BrushStyle(Value: iBrushStyle);
begin
  DefaultInterface.Set_BrushStyle(Value);
end;

function TiPaint.Get_PenStyle: iPenStyle;
begin
    Result := DefaultInterface.PenStyle;
end;

procedure TiPaint.Set_PenStyle(Value: iPenStyle);
begin
  DefaultInterface.Set_PenStyle(Value);
end;

function TiPaint.Get_PenWidth: Integer;
begin
    Result := DefaultInterface.PenWidth;
end;

procedure TiPaint.Set_PenWidth(Value: Integer);
begin
  DefaultInterface.Set_PenWidth(Value);
end;

function TiPaint.Get_Changed: WordBool;
begin
    Result := DefaultInterface.Changed;
end;

procedure TiPaint.Set_Changed(Value: WordBool);
begin
  DefaultInterface.Set_Changed(Value);
end;

function TiPaint.Get_PenColor: WideString;
begin
    Result := DefaultInterface.PenColor;
end;

procedure TiPaint.Set_PenColor(const Value: WideString);
  { Warning: The property PenColor has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.PenColor := Value;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TiPaintProperties.Create(AServer: TiPaint);
begin
  inherited Create;
  FServer := AServer;
end;

function TiPaintProperties.GetDefaultInterface: IiPaint;
begin
  Result := FServer.DefaultInterface;
end;

function TiPaintProperties.Get_BrushStyle: iBrushStyle;
begin
    Result := DefaultInterface.BrushStyle;
end;

procedure TiPaintProperties.Set_BrushStyle(Value: iBrushStyle);
begin
  DefaultInterface.Set_BrushStyle(Value);
end;

function TiPaintProperties.Get_PenStyle: iPenStyle;
begin
    Result := DefaultInterface.PenStyle;
end;

procedure TiPaintProperties.Set_PenStyle(Value: iPenStyle);
begin
  DefaultInterface.Set_PenStyle(Value);
end;

function TiPaintProperties.Get_PenWidth: Integer;
begin
    Result := DefaultInterface.PenWidth;
end;

procedure TiPaintProperties.Set_PenWidth(Value: Integer);
begin
  DefaultInterface.Set_PenWidth(Value);
end;

function TiPaintProperties.Get_Changed: WordBool;
begin
    Result := DefaultInterface.Changed;
end;

procedure TiPaintProperties.Set_Changed(Value: WordBool);
begin
  DefaultInterface.Set_Changed(Value);
end;

function TiPaintProperties.Get_PenColor: WideString;
begin
    Result := DefaultInterface.PenColor;
end;

procedure TiPaintProperties.Set_PenColor(const Value: WideString);
  { Warning: The property PenColor has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.PenColor := Value;
end;

{$ENDIF}

class function CoiRst.Create: IiRst;
begin
  Result := CreateComObject(CLASS_iRst) as IiRst;
end;

class function CoiRst.CreateRemote(const MachineName: string): IiRst;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_iRst) as IiRst;
end;

procedure TiRst.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{A7CFB2DE-7CD3-11D4-A88D-00A0C9EC10A4}';
    IntfIID:   '{A7CFB2DC-7CD3-11D4-A88D-00A0C9EC10A4}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TiRst.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IiRst;
  end;
end;

procedure TiRst.ConnectTo(svrIntf: IiRst);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TiRst.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TiRst.GetDefaultInterface: IiRst;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TiRst.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TiRstProperties.Create(Self);
{$ENDIF}
end;

destructor TiRst.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TiRst.GetServerProperties: TiRstProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TiRst.Get_CheckStatus: Byte;
begin
    Result := DefaultInterface.CheckStatus;
end;

procedure TiRst.Set_CheckStatus(Value: Byte);
begin
  DefaultInterface.Set_CheckStatus(Value);
end;

function TiRst.Get_Empty: WordBool;
begin
    Result := DefaultInterface.Empty;
end;

procedure TiRst.Set_Empty(Value: WordBool);
begin
  DefaultInterface.Set_Empty(Value);
end;

function TiRst.Get_Changed: WordBool;
begin
    Result := DefaultInterface.Changed;
end;

procedure TiRst.Set_Changed(Value: WordBool);
begin
  DefaultInterface.Set_Changed(Value);
end;

function TiRst.Get_Error: WideString;
begin
    Result := DefaultInterface.Error;
end;

function TiRst.Get_ObjectName: WideString;
begin
    Result := DefaultInterface.ObjectName;
end;

function TiRst.Get_Process: IUnknown;
begin
    Result := DefaultInterface.Process;
end;

procedure TiRst.Set_Process(const Value: IUnknown);
begin
  DefaultInterface.Set_Process(Value);
end;

function TiRst.Get_DataHandle: Integer;
begin
    Result := DefaultInterface.DataHandle;
end;

function TiRst.Get_Status: WideString;
begin
    Result := DefaultInterface.Status;
end;

function TiRst.Get_Processing: WordBool;
begin
    Result := DefaultInterface.Processing;
end;

function TiRst.Get_PercentDone: Byte;
begin
    Result := DefaultInterface.PercentDone;
end;

function TiRst.Get_Title: WideString;
begin
    Result := DefaultInterface.Title;
end;

procedure TiRst.Set_Title(const Value: WideString);
  { Warning: The property Title has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Title := Value;
end;

function TiRst.Get_Legend: iLegend;
begin
    Result := DefaultInterface.Legend;
end;

procedure TiRst.Set_Legend(const Value: iLegend);
begin
  DefaultInterface.Set_Legend(Value);
end;

function TiRst.Get_hDC: Integer;
begin
    Result := DefaultInterface.hDC;
end;

function TiRst.Get_MinX: Double;
begin
    Result := DefaultInterface.MinX;
end;

procedure TiRst.Set_MinX(Value: Double);
begin
  DefaultInterface.Set_MinX(Value);
end;

function TiRst.Get_MaxX: Double;
begin
    Result := DefaultInterface.MaxX;
end;

procedure TiRst.Set_MaxX(Value: Double);
begin
  DefaultInterface.Set_MaxX(Value);
end;

function TiRst.Get_MinY: Double;
begin
    Result := DefaultInterface.MinY;
end;

procedure TiRst.Set_MinY(Value: Double);
begin
  DefaultInterface.Set_MinY(Value);
end;

function TiRst.Get_MaxY: Double;
begin
    Result := DefaultInterface.MaxY;
end;

procedure TiRst.Set_MaxY(Value: Double);
begin
  DefaultInterface.Set_MaxY(Value);
end;

function TiRst.Get_Document: iFile;
begin
    Result := DefaultInterface.Document;
end;

procedure TiRst.Set_Document(const Value: iFile);
begin
  DefaultInterface.Set_Document(Value);
end;

function TiRst.Get_Comment: iStringList;
begin
    Result := DefaultInterface.Comment;
end;

procedure TiRst.Set_Comment(const Value: iStringList);
begin
  DefaultInterface.Set_Comment(Value);
end;

function TiRst.Get_Lineage: iStringList;
begin
    Result := DefaultInterface.Lineage;
end;

procedure TiRst.Set_Lineage(const Value: iStringList);
begin
  DefaultInterface.Set_Lineage(Value);
end;

function TiRst.Get_Completeness: iStringList;
begin
    Result := DefaultInterface.Completeness;
end;

procedure TiRst.Set_Completeness(const Value: iStringList);
begin
  DefaultInterface.Set_Completeness(Value);
end;

function TiRst.Get_Consistency: iStringList;
begin
    Result := DefaultInterface.Consistency;
end;

procedure TiRst.Set_Consistency(const Value: iStringList);
begin
  DefaultInterface.Set_Consistency(Value);
end;

function TiRst.Get_PartialScene: WordBool;
begin
    Result := DefaultInterface.PartialScene;
end;

function TiRst.Get_ImageWidth: Integer;
begin
    Result := DefaultInterface.ImageWidth;
end;

procedure TiRst.Set_ImageWidth(Value: Integer);
begin
  DefaultInterface.Set_ImageWidth(Value);
end;

function TiRst.Get_ImageHeight: Integer;
begin
    Result := DefaultInterface.ImageHeight;
end;

procedure TiRst.Set_ImageHeight(Value: Integer);
begin
  DefaultInterface.Set_ImageHeight(Value);
end;

function TiRst.Get_PointXY(X: OleVariant; Y: OleVariant): OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.PointXY[X, Y];
end;

procedure TiRst.Set_PointXY(X: OleVariant; Y: OleVariant; Value: OleVariant);
begin
  DefaultInterface.PointXY[X, Y] := Value;
end;

function TiRst.Get_Cols: Integer;
begin
    Result := DefaultInterface.Cols;
end;

function TiRst.Get_Rows: Integer;
begin
    Result := DefaultInterface.Rows;
end;

function TiRst.Get_Res: Double;
begin
    Result := DefaultInterface.Res;
end;

procedure TiRst.Set_Res(Value: Double);
begin
  DefaultInterface.Set_Res(Value);
end;

function TiRst.Get_MaxValue: Double;
begin
    Result := DefaultInterface.MaxValue;
end;

procedure TiRst.Set_MaxValue(Value: Double);
begin
  DefaultInterface.Set_MaxValue(Value);
end;

function TiRst.Get_MinValue: Double;
begin
    Result := DefaultInterface.MinValue;
end;

procedure TiRst.Set_MinValue(Value: Double);
begin
  DefaultInterface.Set_MinValue(Value);
end;

function TiRst.Get_DataType: iDataTypeConst;
begin
    Result := DefaultInterface.DataType;
end;

procedure TiRst.Set_DataType(Value: iDataTypeConst);
begin
  DefaultInterface.Set_DataType(Value);
end;

function TiRst.Get_ByteOrder: iByteOrder;
begin
    Result := DefaultInterface.ByteOrder;
end;

function TiRst.Get_ScanLineOrientation: iScanlineOrientType;
begin
    Result := DefaultInterface.ScanLineOrientation;
end;

procedure TiRst.Set_ScanLineOrientation(Value: iScanlineOrientType);
begin
  DefaultInterface.Set_ScanLineOrientation(Value);
end;

function TiRst.Get_FileFormat: WideString;
begin
    Result := DefaultInterface.FileFormat;
end;

function TiRst.ArrayOfVar(SourceArray: OleVariant): OleVariant;
begin
  Result := DefaultInterface.ArrayOfVar(SourceArray);
end;

procedure TiRst.AssignObject(const Source: iData);
begin
  DefaultInterface.AssignObject(Source);
end;

procedure TiRst.PasteGeoRefs(const PassVar: iGeoData);
begin
  DefaultInterface.PasteGeoRefs(PassVar);
end;

function TiRst.Open: WordBool;
begin
  Result := DefaultInterface.Open;
end;

procedure TiRst.Save;
begin
  DefaultInterface.Save;
end;

function TiRst.Terminate: WordBool;
begin
  Result := DefaultInterface.Terminate;
end;

procedure TiRst.SaveHeader;
begin
  DefaultInterface.SaveHeader;
end;

function TiRst.OpenHeader: WordBool;
begin
  Result := DefaultInterface.OpenHeader;
end;

function TiRst.OpenWindow(X1: OleVariant; Y1: OleVariant; X2: OleVariant; Y2: OleVariant; 
                          Step: Smallint): WordBool;
begin
  Result := DefaultInterface.OpenWindow(X1, Y1, X2, Y2, Step);
end;

function TiRst.OpenSample(Step: Smallint): WordBool;
begin
  Result := DefaultInterface.OpenSample(Step);
end;

procedure TiRst.PasteHDC(BitmapHDC: Integer; Width: Integer; Height: Integer);
begin
  DefaultInterface.PasteHDC(BitmapHDC, Width, Height);
end;

procedure TiRst.Refresh;
begin
  DefaultInterface.Refresh;
end;

procedure TiRst.ClearBitmap;
begin
  DefaultInterface.ClearBitmap;
end;

function TiRst.StreamMapAs(StreamType: iStreamType): OleVariant;
begin
  Result := DefaultInterface.StreamMapAs(StreamType);
end;

procedure TiRst.PaintPoint(X: OleVariant; Y: OleVariant; Radius: OleVariant; const Color: WideString);
begin
  DefaultInterface.PaintPoint(X, Y, Radius, Color);
end;

procedure TiRst.PaintLine(X1: OleVariant; Y1: OleVariant; X2: OleVariant; Y2: OleVariant; 
                          Width: OleVariant; const Color: WideString);
begin
  DefaultInterface.PaintLine(X1, Y1, X2, Y2, Width, Color);
end;

procedure TiRst.PaintPolygon(Points: OleVariant; LineWidth: Integer; const Color: WideString; 
                             BrushStyle: iBrushStyle; IsGeographic: WordBool);
begin
  DefaultInterface.PaintPolygon(Points, LineWidth, Color, BrushStyle, IsGeographic);
end;

procedure TiRst.PaintText(X: OleVariant; Y: OleVariant; const Text: WideString; 
                          const FontName: WideString; Size: Integer; const Style: WideString; 
                          const Color: WideString);
begin
  DefaultInterface.PaintText(X, Y, Text, FontName, Size, Style, Color);
end;

function TiRst.StreamAs(StreamType: iStreamType): OleVariant;
begin
  Result := DefaultInterface.StreamAs(StreamType);
end;

procedure TiRst.Draw(Left: Integer; Top: Integer; Zoom: Single; PictureHandle: Integer);
begin
  DefaultInterface.Draw(Left, Top, Zoom, PictureHandle);
end;

procedure TiRst.DrawMap(Zoom: Single; PictureHandle: Integer);
begin
  DefaultInterface.DrawMap(Zoom, PictureHandle);
end;

procedure TiRst.CopyMap(Zoom: Single);
begin
  DefaultInterface.CopyMap(Zoom);
end;

procedure TiRst.Copy;
begin
  DefaultInterface.Copy;
end;

procedure TiRst.StretchDraw(hDC: Integer; X1: Double; Y1: Double; X2: Double; Y2: Double; 
                            Left: Integer; Top: Integer; Right: Integer; Bottom: Integer);
begin
  DefaultInterface.StretchDraw(hDC, X1, Y1, X2, Y2, Left, Top, Right, Bottom);
end;

function TiRst.GetDataBuffer(out DataOut: OleVariant): Integer;
begin
  Result := DefaultInterface.GetDataBuffer(DataOut);
end;

procedure TiRst.SetDataBuffer(DataIn: OleVariant);
begin
  DefaultInterface.SetDataBuffer(DataIn);
end;

function TiRst.RetrieveBitmap(Source: OleVariant; TimeOut_Sec: Integer; X1: Integer; Y1: Integer; 
                              X2: Integer; Y2: Integer; Transparency: Byte): Integer;
begin
  Result := DefaultInterface.RetrieveBitmap(Source, TimeOut_Sec, X1, Y1, X2, Y2, Transparency);
end;

function TiRst.Column(X1: Single): Integer;
begin
  Result := DefaultInterface.Column(X1);
end;

function TiRst.Row(Y1: Single): Integer;
begin
  Result := DefaultInterface.Row(Y1);
end;

function TiRst.CoordX(PassVar: Integer): Single;
begin
  Result := DefaultInterface.CoordX(PassVar);
end;

function TiRst.CoordY(PassVar: Integer): Single;
begin
  Result := DefaultInterface.CoordY(PassVar);
end;

procedure TiRst.GetMaxMin;
begin
  DefaultInterface.GetMaxMin;
end;

procedure TiRst.Insert(const PassVar: iRaster);
begin
  DefaultInterface.Insert(PassVar);
end;

procedure TiRst.SetDataYX(Matrix: OleVariant; X1: Integer; Y1: Integer; X2: Integer; Y2: Integer);
begin
  DefaultInterface.SetDataYX(Matrix, X1, Y1, X2, Y2);
end;

function TiRst.GetDataYX(X1: Integer; Y1: Integer; X2: Integer; Y2: Integer): OleVariant;
begin
  Result := DefaultInterface.GetDataYX(X1, Y1, X2, Y2);
end;

procedure TiRst.New(const NewName: WideString; NewDataType: iDataTypeConst; NewCols: Integer; 
                    NewRows: Integer; InitVal: Single);
begin
  DefaultInterface.New(NewName, NewDataType, NewCols, NewRows, InitVal);
end;

procedure TiRst.SetData(Matrix: OleVariant; X1: Integer; Y1: Integer; X2: Integer; Y2: Integer);
begin
  DefaultInterface.SetData(Matrix, X1, Y1, X2, Y2);
end;

function TiRst.GetData(X1: Integer; Y1: Integer; X2: Integer; Y2: Integer): OleVariant;
begin
  Result := DefaultInterface.GetData(X1, Y1, X2, Y2);
end;

function TiRst.RetrieveURLData(const URLString: WideString; TimeOut_Sec: Integer; X1: Integer; 
                               Y1: Integer; X2: Integer; Y2: Integer): Integer;
begin
  Result := DefaultInterface.RetrieveURLData(URLString, TimeOut_Sec, X1, Y1, X2, Y2);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TiRstProperties.Create(AServer: TiRst);
begin
  inherited Create;
  FServer := AServer;
end;

function TiRstProperties.GetDefaultInterface: IiRst;
begin
  Result := FServer.DefaultInterface;
end;

function TiRstProperties.Get_CheckStatus: Byte;
begin
    Result := DefaultInterface.CheckStatus;
end;

procedure TiRstProperties.Set_CheckStatus(Value: Byte);
begin
  DefaultInterface.Set_CheckStatus(Value);
end;

function TiRstProperties.Get_Empty: WordBool;
begin
    Result := DefaultInterface.Empty;
end;

procedure TiRstProperties.Set_Empty(Value: WordBool);
begin
  DefaultInterface.Set_Empty(Value);
end;

function TiRstProperties.Get_Changed: WordBool;
begin
    Result := DefaultInterface.Changed;
end;

procedure TiRstProperties.Set_Changed(Value: WordBool);
begin
  DefaultInterface.Set_Changed(Value);
end;

function TiRstProperties.Get_Error: WideString;
begin
    Result := DefaultInterface.Error;
end;

function TiRstProperties.Get_ObjectName: WideString;
begin
    Result := DefaultInterface.ObjectName;
end;

function TiRstProperties.Get_Process: IUnknown;
begin
    Result := DefaultInterface.Process;
end;

procedure TiRstProperties.Set_Process(const Value: IUnknown);
begin
  DefaultInterface.Set_Process(Value);
end;

function TiRstProperties.Get_DataHandle: Integer;
begin
    Result := DefaultInterface.DataHandle;
end;

function TiRstProperties.Get_Status: WideString;
begin
    Result := DefaultInterface.Status;
end;

function TiRstProperties.Get_Processing: WordBool;
begin
    Result := DefaultInterface.Processing;
end;

function TiRstProperties.Get_PercentDone: Byte;
begin
    Result := DefaultInterface.PercentDone;
end;

function TiRstProperties.Get_Title: WideString;
begin
    Result := DefaultInterface.Title;
end;

procedure TiRstProperties.Set_Title(const Value: WideString);
  { Warning: The property Title has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Title := Value;
end;

function TiRstProperties.Get_Legend: iLegend;
begin
    Result := DefaultInterface.Legend;
end;

procedure TiRstProperties.Set_Legend(const Value: iLegend);
begin
  DefaultInterface.Set_Legend(Value);
end;

function TiRstProperties.Get_hDC: Integer;
begin
    Result := DefaultInterface.hDC;
end;

function TiRstProperties.Get_MinX: Double;
begin
    Result := DefaultInterface.MinX;
end;

procedure TiRstProperties.Set_MinX(Value: Double);
begin
  DefaultInterface.Set_MinX(Value);
end;

function TiRstProperties.Get_MaxX: Double;
begin
    Result := DefaultInterface.MaxX;
end;

procedure TiRstProperties.Set_MaxX(Value: Double);
begin
  DefaultInterface.Set_MaxX(Value);
end;

function TiRstProperties.Get_MinY: Double;
begin
    Result := DefaultInterface.MinY;
end;

procedure TiRstProperties.Set_MinY(Value: Double);
begin
  DefaultInterface.Set_MinY(Value);
end;

function TiRstProperties.Get_MaxY: Double;
begin
    Result := DefaultInterface.MaxY;
end;

procedure TiRstProperties.Set_MaxY(Value: Double);
begin
  DefaultInterface.Set_MaxY(Value);
end;

function TiRstProperties.Get_Document: iFile;
begin
    Result := DefaultInterface.Document;
end;

procedure TiRstProperties.Set_Document(const Value: iFile);
begin
  DefaultInterface.Set_Document(Value);
end;

function TiRstProperties.Get_Comment: iStringList;
begin
    Result := DefaultInterface.Comment;
end;

procedure TiRstProperties.Set_Comment(const Value: iStringList);
begin
  DefaultInterface.Set_Comment(Value);
end;

function TiRstProperties.Get_Lineage: iStringList;
begin
    Result := DefaultInterface.Lineage;
end;

procedure TiRstProperties.Set_Lineage(const Value: iStringList);
begin
  DefaultInterface.Set_Lineage(Value);
end;

function TiRstProperties.Get_Completeness: iStringList;
begin
    Result := DefaultInterface.Completeness;
end;

procedure TiRstProperties.Set_Completeness(const Value: iStringList);
begin
  DefaultInterface.Set_Completeness(Value);
end;

function TiRstProperties.Get_Consistency: iStringList;
begin
    Result := DefaultInterface.Consistency;
end;

procedure TiRstProperties.Set_Consistency(const Value: iStringList);
begin
  DefaultInterface.Set_Consistency(Value);
end;

function TiRstProperties.Get_PartialScene: WordBool;
begin
    Result := DefaultInterface.PartialScene;
end;

function TiRstProperties.Get_ImageWidth: Integer;
begin
    Result := DefaultInterface.ImageWidth;
end;

procedure TiRstProperties.Set_ImageWidth(Value: Integer);
begin
  DefaultInterface.Set_ImageWidth(Value);
end;

function TiRstProperties.Get_ImageHeight: Integer;
begin
    Result := DefaultInterface.ImageHeight;
end;

procedure TiRstProperties.Set_ImageHeight(Value: Integer);
begin
  DefaultInterface.Set_ImageHeight(Value);
end;

function TiRstProperties.Get_PointXY(X: OleVariant; Y: OleVariant): OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.PointXY[X, Y];
end;

procedure TiRstProperties.Set_PointXY(X: OleVariant; Y: OleVariant; Value: OleVariant);
begin
  DefaultInterface.PointXY[X, Y] := Value;
end;

function TiRstProperties.Get_Cols: Integer;
begin
    Result := DefaultInterface.Cols;
end;

function TiRstProperties.Get_Rows: Integer;
begin
    Result := DefaultInterface.Rows;
end;

function TiRstProperties.Get_Res: Double;
begin
    Result := DefaultInterface.Res;
end;

procedure TiRstProperties.Set_Res(Value: Double);
begin
  DefaultInterface.Set_Res(Value);
end;

function TiRstProperties.Get_MaxValue: Double;
begin
    Result := DefaultInterface.MaxValue;
end;

procedure TiRstProperties.Set_MaxValue(Value: Double);
begin
  DefaultInterface.Set_MaxValue(Value);
end;

function TiRstProperties.Get_MinValue: Double;
begin
    Result := DefaultInterface.MinValue;
end;

procedure TiRstProperties.Set_MinValue(Value: Double);
begin
  DefaultInterface.Set_MinValue(Value);
end;

function TiRstProperties.Get_DataType: iDataTypeConst;
begin
    Result := DefaultInterface.DataType;
end;

procedure TiRstProperties.Set_DataType(Value: iDataTypeConst);
begin
  DefaultInterface.Set_DataType(Value);
end;

function TiRstProperties.Get_ByteOrder: iByteOrder;
begin
    Result := DefaultInterface.ByteOrder;
end;

function TiRstProperties.Get_ScanLineOrientation: iScanlineOrientType;
begin
    Result := DefaultInterface.ScanLineOrientation;
end;

procedure TiRstProperties.Set_ScanLineOrientation(Value: iScanlineOrientType);
begin
  DefaultInterface.Set_ScanLineOrientation(Value);
end;

function TiRstProperties.Get_FileFormat: WideString;
begin
    Result := DefaultInterface.FileFormat;
end;

{$ENDIF}

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TiFile, TiPal, TiColor, TiFont, 
    TiLegend, TiRaster, TiImg, TiStringList, TiScalar, 
    TiVectorial, TiVec, TiDiscreteLeg, TiContLeg, TiVal, 
    TiShp, TiIdrisiVal, TiDbf, TiPaint, TiRst]);
end;

end.

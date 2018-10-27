{*** S-tree data structure implementation by A. Shaposhnikov 2002 ***}
{
 Indexes point objects in 2-D space. 

 The objects must implement the function
   type TObjFunction = procedure(ObjID : integer; Var X, Y : single) of object;
   Given the object ID, the function must return the object coordinates.
 The procedure AddObject is used to add objects to S-tree.
 The function FindObjects searches for objects in a given rectangle
 The function FindNextObject(Var SI : TSTreeIterator) is used to iteratively retrieve all objects.
}

unit Stree;


interface

const iNULL = $ffffffff;
//const MaxHash = (1 shl 19) - 1;
const MaxLevel = 32 div 2 - 1;
type dword = longword;

type TTriplet = record
        S1 : dword;
        S2 : dword;
        HashNext : dword;
end;

type TObjFunction = procedure(ObjID : integer; Var X, Y : single) of object;

type TStreeIterator = record
     X1, Y1, X2, Y2 : single;
     L : integer;
     Top : integer;
     Cells : array[0..31] of dword;
     Inside : array[0..31] of boolean;
     F : TObjFunction;
     Trials, N : integer;
end;

type TStree = class
   _triplets : array of TTriplet;
   _Numplets : integer;
   _MaxHash : dword;
   _Hash : array of dword;
   _W, _H : single;
   _X0, _Y0 : single;
   _LastL : integer;
   _MaxCell, _MinCell : integer;
   _FirstFree : dword;
   _C0 : array[0..MaxLevel] of dword;
   _MaxL : integer;
private
    Function  Cell(X, Y : single; L : integer) : dword;
    procedure CellToCoor(CL : dword; L : integer; Var X, Y : integer); overload;
    procedure CellToCoor(CL : dword; L : integer; Var X, Y : single); overload;
    function  CoorToCell(X, Y : dword; L : integer) : dword;
    function  HashFind(S : dword) : dword;
    function  NumObjects(S : dword) : integer;
    function  InsertTriplet(S1, S2 : dword) : dword;
    procedure RemoveTriplet(T : dword; Var P : dword);
    procedure FindLeaf(Var SI : TStreeIterator);
    function  InRegion(CL : dword; Var SI : TStreeIterator) : boolean;
public
    constructor Create(X0, Y0, X1, Y1 : single; MaxCell, MinCell : integer; MaxHash : integer);
    procedure AddObject(ObjId : integer; X,Y : single; F : TObjFunction);
//    procedure DelObject(ObjId : integer; F : TObjFunction);
    procedure FindObjects(X1, X2, Y1, Y2 : single; F : TObjFunction; Var SI : TSTreeIterator);
    function  FindNextObject(Var SI : TSTreeIterator) : dword;
end;

implementation
{$Q-}


constructor TStree.Create(X0, Y0, X1, Y1 : single; MaxCell, MinCell : integer; MaxHash : integer);
Var i : integer;
begin
   _X0 := X0;
   _Y0 := Y0;
   _W := X1 - X0;
   _H := Y1 - Y0;
   _Numplets := 0;
   _LastL := 0;
   _MaxCell := MaxCell;
   _MinCell := MinCell;
   _FirstFree := iNull;
   _MaxHash := MaxHash;
   setlength(_Hash, _MaxHash);
   setlength(_triplets, round(_MaxHash * 1.33));
   for i := 0 to _MaxHash - 1 do
     _Hash[i] := iNull;
   for i := 0 to MaxLevel do
       _C0[i] := ((1 shl (2*i)) - 1) div 3;
end;


Function  TStree.Cell(X, Y : single; L : integer) : dword;
Var DL : dword;
begin
   DL := 1 shl L;
   Result := _C0[L] + DL * trunc(DL * (Y - _Y0) / _H)
             + trunc(DL * (X-_X0)/_W);
end;

procedure TStree.CellToCoor(CL : dword; L : integer; Var X, Y : integer);
Var P : dword;
begin
   CL := CL - _C0[L];
   P := 1 shl L;
   Y := CL div P;
   X := integer(CL - dword(Y) * dword(P));
end;

procedure TStree.CellToCoor(CL : dword; L : integer; Var X, Y : single);
Var XX, YY : dword;
    P : dword;
begin
   CL := CL - _C0[L];
   P := 1 shl L;
   YY := CL div P;
   XX := CL - YY * P;
   Y := _Y0 + YY*(_H/P);
   X := _X0 + XX*(_W/P);
end;


function TStree.CoorToCell(X, Y : dword; L : integer) : dword;
begin
   Result := _C0[L] + Y * (1 shl L) + X;
end;

function TStree.HashFind(S : dword) : dword;
Var SS, H, T : dword;
begin
   if _MaxHash = 0 then
      exit;
   SS := S shr 1;
   H := SS mod _MaxHash;
   T := _Hash[H];
   while (T <> iNull) and ((_Triplets[T].S1 shr 1) <> SS) do
     T := _Triplets[T].HashNext;
   Result := T;
end;

function TSTree.NumObjects(S : dword) : integer;
Var H, SS, T : dword;
begin
   SS := s shr 1;
   H := SS mod _MaxHash;
   T := _Hash[H];
   Result := 0;
   while (T <> iNull) do
     begin
       if (_Triplets[T].S1 shr 1) = SS then
         inc(Result);
       T := _Triplets[T].HashNext;
     end;
end;

const _Deb : integer = 0;
//procedure debug;
//begin
//  inc(_Deb);
{  if _Deb = 10122 then
    _Deb := 10122;}
//end;

const ddd : integer = 0;
procedure TStree.AddObject(ObjID : integer; X,Y : single; F : TObjFunction);
Var L, N, C, R, i : integer;
    TT, NC, Obj, CL, CC, CN, T, P : dword;
    XX, YY : single;
begin
//   inc(_Deb);
//   if (_Deb > 130660) then
//     _Deb := _Deb;
   L := _LastL;
   CL := 2*Cell(X,Y,L);
   T := HashFind(CL);
   while (L > 0) and (T = iNull) do
     begin
        dec(L);
        CL := 2*Cell(X,Y,L);
        T := HashFind(CL);
     end;
   if T <> iNull then
     begin
       while (_Triplets[T].S1 and 1) = 0 do
         begin
           inc(L);
           CL := 2*Cell(X,Y,L);
           T := HashFind(CL);
           if T = iNull then
              break;
         end;
       end
   else
     begin
        CL := 0;
        L := 0;
     end;
   _LastL := L;
   N := NumObjects(CL);
   if L < MaxLevel then
     begin
{      inc(_Deb);
      if (_Deb = 130661) then
        _Deb := _Deb;}
       while N > _MaxCell do
          begin
             P := iNull;
             while T <> iNull do
                begin
                   Obj := _Triplets[T].S2;
                   F(Obj, XX, YY);
{                   inc(_Deb);
                   if _Deb = 103780 then
                     _Deb := 103780;}
{                   inc(ddd);
                   if ddd = 103780 then
                     ddd := 103780;}
                   NC := dword(2)*dword(Cell(XX, YY, L+1));
                   InsertTriplet(NC+1, Obj);
                   TT := _Triplets[T].HashNext;
                   RemoveTriplet(T, P);
                   T := TT;
                   while (T <> iNull) and (_Triplets[T].S1 <> (CL + 1)) do
                      T := _Triplets[T].HashNext;
                end;
             CellToCoor(CL shr 1, L, C, R);
             for i := 0 to 3 do
               begin
                 CC := 2*CoorToCell(C*2+(i mod 2),R*2+(i div 2), L+1);
                 if NumObjects(CC) > 0 then
                    InsertTriplet(CL, CC+1);
               end;
             if L > 0 then
               begin
                 P := iNull;
                 CN := 2*Cell(X,Y,L-1);
                 T := HashFind(CN);
                 while (T <> iNull) and (_Triplets[T].S2 <> (CL + 1)) do
                   T := _Triplets[T].HashNext;
                 if T <> iNull then
                    RemoveTriplet(T, P);
                 InsertTriplet(CN, CL);
               end;
             inc(L);
             if L >= _MaxL then
               _MaxL := L;
//             CC := CL;
             CL := 2*Cell(X,Y,L);
             N := NumObjects(CL);
{             if N = 0 then
                InsertTriplet(CC, CL+1);}
             if L >= MaxLevel then
               break;
             if N > _MaxCell then
                T := HashFind(CL);
          end;
     end;
   if (N = 0) and (L > 0) then
      begin
        CC := 2*Cell(X,Y,L-1);
        InsertTriplet(CC, CL+1);
      end;
   InsertTriplet(CL+1, ObjID);
end;

procedure TStree.RemoveTriplet(T : dword; Var P : dword);
Var H, TT : dword;
begin
{  if T = 64598 then
    T := 64598;}
  if (P <> iNull) and (_Triplets[P].HashNext = T) then
    _Triplets[P].HashNext := _Triplets[T].HashNext
  else
    begin
       H := (_Triplets[T].S1 shr 1) mod _MaxHash;
       TT := _Hash[H];
       if TT = T then
          begin
            P := iNull;
            _Hash[H] := _Triplets[T].HashNext;
          end
       else
          begin
             while (TT <> iNull) and (_Triplets[TT].HashNext <> T) do
                TT := _Triplets[TT].HashNext;
             if TT <> iNull then
                _Triplets[TT].HashNext := _Triplets[T].HashNext;
          end;
    end;
  _Triplets[T].HashNext := _FirstFree;
  _FirstFree := T;
end;

function TStree.InsertTriplet(S1, S2 : dword) : dword;
Var H : dword;
begin
{   if ((S2 = 25518) or (S2 = 25519)) and  ((S1 and 1) = 0) then
     debug;}
   if _FirstFree <> iNull then
     begin
       Result := _FirstFree;
       _FirstFree := _Triplets[_FirstFree].HashNext;
     end
   else
     begin
       Result := _Numplets;
       inc(_Numplets);
       if _Numplets >= length(_triplets) then
         setlength(_triplets, 100 + round(_Numplets * 1.1));
     end;
{   if Result = 64598 then
     Result := 64598;}
   _Triplets[Result].S1 := S1;
   _Triplets[Result].S2 := S2;
   H := (S1 shr 1) mod _MaxHash;
   _Triplets[Result].HashNext := _Hash[H];
   _Hash[H] := Result;
end;

procedure TStree.FindObjects(X1, X2, Y1, Y2 : single; F : TObjFunction; Var SI : TSTreeIterator);
Var T, P, PC : dword;
    L : integer;
begin
   if X1 < _X0 then
     begin
       X1 := _X0;
       if X2 < _X0 then
         X2 := _X0;
     end;
   if X2 >= (_X0 + _W) then
     begin
       X2 := _X0 + _W - _W/32768;
       if X1 >= (_X0 + _W) then
          X1 := _X0 + _W - _W/32768;
     end;
   if Y1 < _Y0 then
     begin
       Y1 := _Y0;
       if Y2 < _Y0 then
         Y2 := _Y0;
     end;
   if Y2 >= (_Y0 + _H) then
     begin
       Y2 := _Y0 + _H - _H/32768;
       if Y1 >= (_Y0 + _H) then
         Y1 := _Y0 + _H - _H/32768;
     end;
   if (X2 < X1) or (Y2 < Y1) or (_Numplets = 0) then
      begin
         SI.Cells[0] := iNull;
         SI.Top := 0;
         SI.L := 0;
         exit;
      end;
   SI.Trials := 0;
   SI.N := 0;
//   C1 := 0;
//   C2 := 0;
//   PC := 0;
   L := 0;
   while (L <= _MaxL) do
     begin
        inc(L);
        P := 1 shl L;
        if trunc(P*(Y1-_Y0)/_H) <> trunc(P*(Y2-_Y0)/_H) then
           break;
        if trunc(P*(X1-_X0)/_W) <> trunc(P*(X2-_X0)/_W) then
           break;
     end;
   Dec(L);
   PC := Cell(X1, Y1, L);
   T := HashFind(2*PC);
   while (T = iNull) and (L > 0) do
     begin
       dec(L);
       PC := Cell(X1,Y1, L);
       T := HashFind(2*PC);
       if T <> iNull then
         if (_TripLets[T].S1 and 1) = 0 then
           begin  // nothing found
             SI.Cells[L] := iNull;
             SI.Top := L;
             SI.L := L;
             exit;
           end;
     end;
   SI.F := F;
   SI.X1 := X1;
   SI.X2 := X2;
   SI.Y1 := Y1;
   SI.Y2 := Y2;
   SI.Top := L;
   SI.Cells[L] := T;
   SI.L := L;
   Si.Inside[L] := false;
   FindLeaf(SI);
end;

function TStree.InRegion(CL : dword; Var SI : TStreeIterator) : boolean;
Var XX, YY : dword;
    P : dword;
    X1, Y1 : real;
    X2, Y2 : real;
begin
   P := 1 shl SI.L;
   CL := (CL shr 1) - _C0[SI.L];
   YY := CL div P;
   XX := CL - YY * P;
   Y1 := _Y0 + YY*(_H/P);
   X1 := _X0 + XX*(_W/P);
   X2 := X1 + _W/P;
   Y2 := Y1 + _H/P;
   Result :=  (((X1 >= SI.X1) and (X1 <= SI.X2)) or
              ((X2 >= SI.X1) and (X2 <= SI.X2)) or
              ((X1 <= SI.X1) and (X2 >= SI.X2))) and
              (((Y1 >= SI.Y1) and (Y1 <= SI.Y2)) or
              ((Y2 >= SI.Y1) and (Y2 <= SI.Y2)) or
              ((Y1 <= SI.Y1) and (Y2 >= SI.Y2)));
   if Result then
     begin
        Si.Inside[Si.L] := (X2 < SI.X2) and (X1 > SI.X1) and
                        (Y2 < SI.Y2) and (Y1 > SI.Y1);
//        debug;
     end
   else
      Si.Inside[Si.L] := false;
end;

procedure TStree.FindLeaf(Var SI : TStreeIterator);
Var T, CL : dword;
//    X, Y : single;
begin
   while true do
     begin
       while (SI.L > SI.Top) and (SI.Cells[SI.L] = iNull) do // go back to the top and find the first next cell
          begin
            dec(SI.L);
{            if Si.L > Si.Top then
              begin
                Si.Inside[SI.L] := Si.Inside[SI.L-1];
                debug;
              end
            else
              Si.Inside[SI.L] := false;}
            T := SI.Cells[SI.L];
            CL := _Triplets[T].S1 shr 1;
            T := _Triplets[T].HashNext;
            while (T <> iNull) and ((_Triplets[T].S1 shr 1) <> CL) do
                T := _Triplets[T].HashNext;
            SI.Cells[SI.L] := T;
          end;
       if SI.Cells[SI.L] = iNull then
          exit;
       // plunge to the leaf and make sure we still in the rectangle we search
       while (_TripLets[SI.Cells[SI.L]].S1 and 1) = 0 do
         begin
           inc(SI.L);
           CL := _Triplets[SI.Cells[SI.L-1]].S2;
           Si.Inside[SI.L] := Si.Inside[SI.L-1];
//           debug;
           if not Si.Inside[SI.L] then
            if not InRegion(CL, SI) then
              begin
                SI.Cells[SI.L] := iNull;
                break;
              end;
//           CellToCoor(CL shr 1, SI.L, X, Y);
           SI.Cells[SI.L] := HashFind(CL);
         end;
       if SI.Cells[SI.L] <> iNull then
         exit;
     end;
end;

function TStree.FindNextObject(Var SI : TSTreeIterator) : dword;
Var T, CL : dword;
    X, Y : single;
    Found : boolean;
begin
   while true do
     if SI.Cells[SI.L] = iNull then
       begin
         result := iNull;
         exit;
       end
     else
       begin
//         debug;
         T := SI.Cells[SI.L];
         Result := _Triplets[T].S2;
         CL := _Triplets[T].S1;
         T := _Triplets[T].HashNext;
         while (T <> iNull) and (CL <> _Triplets[T].S1) do
            T := _Triplets[T].HashNext;
         SI.Cells[SI.L] := T;
         if SI.L > SI.Top then
            Found := SI.Inside[Si.L-1]
         else
            found := false;
         if not Found then
            begin
              SI.F(Result, X, Y);
              Found := (X <= SI.X2) and (X >= SI.X1) and (Y <= SI.Y2) and (Y >= SI.Y1);
            end;
         if T = iNull then
            FindLeaf(SI);
         inc(SI.Trials);
         if  Found then
           begin
              inc(SI.N);
              exit;
           end
       end;
end;

{$Q+}

end.




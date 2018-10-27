unit memmgr;

interface

implementation
uses sysutils;

function malloc(size:integer):pointer;cdecl;external 'memmgr.dll' name 'alp_malloc';
procedure free(blk:pointer);cdecl;external 'memmgr.dll' name 'alp_free';
function realloc(blk:pointer;newsize:integer):pointer;cdecl;external 'memmgr.dll' name 'alp_realloc';

function dmalloc(size:integer):pointer;
begin
  result:=malloc(size);
end;

function dfree(blk:pointer):integer;
begin
  free(blk);
  result:=0;
end;

function drealloc(blk:pointer;newsize:integer):pointer;
begin
  try
    result:=realloc(blk,newsize);
  except on e: exception do
    result := nil;
  end;
end;

var
  alp_memmgr:TMemoryManager;

initialization
  alp_memmgr.GetMem:=dmalloc;
  alp_memmgr.FreeMem:=dfree;
  alp_memmgr.ReallocMem:=drealloc;
  SetMemoryManager(alp_memmgr);
end.

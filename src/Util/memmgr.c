#include <stdlib.h>

__declspec(dllexport) void* _stdcall alp_malloc(int size)
{
  return malloc(size);
}

__declspec(dllexport) void _stdcall alp_free(void *blk)
{
  free(blk);
}

__declspec(dllexport) void* _stdcall alp_realloc(void *blk,int newsize)
{
  return realloc(blk,newsize);
}

This is a solution for the GetMem bug.

Since WDOSX supports DLLs we can use the memory manager of another RTL, in this
case we use Borland C's malloc, free, realloc functions.

Applications using it work as native Win32 and WDOSX-stubbed programs too.

Files:
memmgr.c        the source of the dll (memmgr.wdl)
memmgr.wdl      this is the dll itself, it is renamed to .wdl so stubit will
                put it into the exe
memmgr.pas      the Delphi interface unit, it must be the first unit in your
                main module's uses clause
test1.pas       a small test program

Note that memmgr.wdl was created by Borland C 5.0 and of course this assumes
that the memory manager of Borland C does not suffer from the problems of the
Delphi one.

I tested this with Visual C 6 (memmgr.pas needs some modifications for VC) too
but it caused crashes in bigger projects (in pmirq.wdl ???) so let's forget VC.

Laszlo (alp@dwp42.org)
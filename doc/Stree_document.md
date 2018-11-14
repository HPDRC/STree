1 - Source code path

There are 4 node of Stree. Stree1 is developing machine. Stree divides into two parts which are Svrmon and Streeweb.  
Svrmon is used to supervise the program in Stree3 and Stree4.

Source code of Svrmon is in C:\Src. There are three files servmon.dfm,  servmon.pas and srvmon.dpr and so on. If you want to change alert email, you can operate at C:\ervicemon.pas or you can click search -> find in files->search in directories. Also you should make sure Project -> Options -> Directories/Conditionals is C:\SrcMon when you build Srvmon project. For detail please look at STREE_HOW_TO.doc

Streeweb’s Source code in Stree1 is in C:\Src. Main source code is C:\Src\Webobjects\webobject.pas. Now Stree1 is 32 bits, there is a file called FastMM4 in C:\Src\FastMM which is in charge with the memory manage. It is open source. If we will replace the 32 bits compiler to 64 bits, we probably do not need this file. Also there is source code in D:\ Src which looks like a backup of C:\Src, but the real source code is in C:\. Make sure if you want to build StreeWeb, the Project -> Options -> Directories/Conditionals is D:\Stree.

2 - Stree web 

Since C:\Src is very important source code, I will use D:\Src to show the Stree web source code. D:\Src\Streeweb.dpr is the project file. But the Webobjects\webobject.pas is the main source code. It contains the main logic of this program. 

3 - webobject.pas

TWebInterf and TWebObject are mutually dependent classes. You have two ways to change parameters in Delphi.

1.	Change Project -> Options -> Directories/Conditionals is D:\Src\new_input(or any place) and  Unit output directory to D:\unit_output(or any place), then change Run -> Parameters  to D:\Stree\(the data sets are in this directory. You can’t use other directory), finally change D:\Src\util\myutil1.pas line 559-560 to S := paramstr(1). You can choose your own directory to build the project.
2.	Change Project -> Options -> Directories/Conditionals is D:\Stree\ and Unit output directory to ..\bin\temp , finally change D:\Src\util\myutil1.pas line 559-560 to S := paramstr(0). Than the project will be built in the D:\Stree\ which the current using version of Stree in. You’d better do backup before overlap the current version streeweb.exe file.

Initialize file is D:\Stree\streeweb.ini.

Streeweb structure:

![Streeweb structure](https://github.com/HPDRC/STree/blob/master/doc/Stree_document_Images/Streeweb%20structure.png)

[Streeweb structure]: (https://github.com/HPDRC/STree/blob/master/doc/Stree_document_Images/Streeweb%20structure.png) "Streeweb structure"

1.	Strip object is used to search the results in some specific data set such as realestate. 
2.	Street object: Stree needs update navteq data set which is realized in D:\src\webobjects\streetobject.pas TStreetObject.Init. Also you can search street.
3.	Zipobject Indexes all US zip codes and performs web queries.
4.	Helpobject implements help? Command http&#58;&#47;&#47;stree&#46;cs&#46;fiu&#46;edu&#47;help
5.	Categoryobject is used to query multiple data in any designate category. Using category command.
6.	<span style="background-color: #FFFF00">Requestobject</span> is important. It returns all data required by Dr. Rishe. In the future maybe new data set is needed to add in request. And there are several parameters in Requestobjects. BBox is used to for bound box, if bound box is 1 it means bound box will be used.

Stree find procedure:

![Stree procedure](https://github.com/HPDRC/STree/blob/master/doc/Stree_document_Images/Stree_procedure.png)

[Stree procedure]: (https://github.com/HPDRC/STree/blob/master/doc/Stree_document_Images/Stree_procedure.png) "Streeweb procedure"

The Initialize procedure is from Webobject.Twebinterf.Initialize to Cityobject.Tcityobject.init()

For search if used &matchprop:2 means rooftop geocode, data from First American parcel data and there are five level of match. 1: exact math, 2: 500 mile,3:zip, 4:city, 5 is not found. 

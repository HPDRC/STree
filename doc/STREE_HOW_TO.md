# STREE HOW TO

1. Ports and corresponding folders:
a.	Port 80 goes to folder D:\Stree
b.	Port 8080 goes to folder D:\stree1
c.	Port 7070 goes to folder D:\stree2
d.	Port 88 goes to folder D:\Translator
e.	Port 9090 goes to folder D:\StreeReal
f.	Port 9797 goes to folder D:\stree_test_port\
If one wants to create a new port, it is necessary to create a new folder, and copy all necessary executable files. The service monitor runs in STREE1 under folder C:\srvmon. It starts automatically but one has to make sure it is up and running.

2. How to deploy a service
a. All source code for STREE is in folder C:\Src. Open the Delphi compiler. DO a backup before any change in the source code. Perforce should be the tool for this. Modify changes in the source and compile changes in the corresponding folder (port). 
b. Shutdown STREE3 and copy executable streeweb.exe from folder to folder.
c. Bring up STREE3.
d. Do the same with STREE4.

3. How to load new NAVTEQ data

+ The best way to create the new index for streets is to perform the operation on STREE1 server. The actual load should be done on STREE3 and STREE4 since STREE1 doesn’t have the capacity to load such a big index. 
The first step is to copy all streets.dbf (actually all street files, .shp etc.) files into the navstreets directory on Street folder (port 80). STREE will look for all of those files and it will build streets.nav files within each directory. Files should be named streets.*
There is a script that copies all filles needed but it has to be used carefully. It is in folder streets and it is called “copynavteqS.bat”. To use it, open a command window and copy each sentence one by one. 

+ Then, files AllStates.NAV, AllStates.MER and AllStates.idx must be removed (copied as backup in case something happens). After that, STREE must be initialized (stree port 80). You can check the progress of the execution by looking at each folder containing the STREETS file. STREE will create a file called streets.NAV on each folder. STREE then will gather all of those files together and it will create the main .NAV file.
When STREE is creating the index, sometimes an error comes up when the instruction pointer executes
if CombinedDir > 127

+ In this case the program raises an exception and terminates abruptly. I replaced the exception raised by a loop break because it was only few records from folder 99 (Puerto rico and Virgin Islands). 
STREE will create the file AllStates.MER which is supposed to be a merging between TIGER and NAVTEQ. Creation of this file can last 24 hours so for that reason is it much better to use STREE1 server for this purpose. Once done, and since STREE1 is not as powerful as STREE3 and STREE4, an Out of memory exception pops in, and this is expected. 
The next step is to copy the AllStates.NAV and AllStates.MER files into STREE3. When initialized, they will generate the AllStates.idx file which is the actual STREE index and we are done with STREE3. Then, STREE4 must be initialized but before that we have to copy AllStates.NAV, AllStates.MER and AllStates.idx from STREE3. It will start normally.
Do some testing by geolocating addresses and STREE is ready to work if everything is done correctly.

4. 	How to load a new dataset
This process depends on how big the dataset is. Usually, dataset are uploaded using the regular STREE command “query”:

[http://stree.cs.fiu.edu:port/command_name?update=update_url&header_url=headerurl][updateUrl]

[updateUrl]:http://stree.cs.fiu.edu:port/command_name?update=update_url&header_url=headerurl

+ See stree help for more information.
When the dataset is large, (like flproperties) we have to upload it by copying the dataset in the corresponding folder and eliminate some files. The process here will be described by uploading the iypages dataset, which is a dataset of over 20 million records and has been geocoded in parallel using a python script. The dataset is uploaded into port 9797 under folder stree_test_port.
  + Prepend header file into the dataset before uploading. 
  + Copy file and header into corresponding folder with .asc and .header format.
  + Shut down port 9797 
  + Open streeweb.ini in the stree_test_port folder. Some ports use the file autoweb.ini to configure datasets. 
  + Add the following (make sure this does not exist in the dataset folder and in autoweb.ini or streeweb.ini)
       + [StripN]  # N means the number of strip dataset
       + Dir=iypages
       + Command=iypages
       + Format=strip
       + Header=iypages.asc.header
       + FileEXT=asc
       + requestparams=d=1&numfind=6 # These are default values
       + UseRAM=false
       + KeyField=id
  + Once this is done, restart port 9797
  + Stree will create .idx file and iypages.db 
  + Test new dataset using
       + [http://stree.cs.fiu.edu:9797/iypages?x1=-80.129138&y1=25.790404&numfind=10&printdist=1&header=1][part4Url]

[part4Url]:http://stree.cs.fiu.edu:9797/iypages?x1=-80.129138&y1=25.790404&numfind=10&printdist=1&header=1

5. How to update City coordinates (PORT 80, don’t forget to shut it down).
STREE uploads cities from file all.cities in folder D:\Stree\Cities. The first step is to update that file with the required information and save it. Then within that folder delete the files Cities.PAR and Cities.tab. Those files will be regenerated. After this, go to folder D:\Stree\streets and delete the file Cities.dat, this will also be regenerated. Afterwards, start STREE and it will take awhile to regenerate all of those files.

6.	How to restore the system after a crash.
Currently stree initializes all services at startup (Ports 80, 88, 8080, 9090, 7070 and 9797). 
If the system crashes and the servers are shut, restart the system will do everything. To make sure everything has been initialized go to the Task Manager. There should be 6 instances of the executable (streeweb.exe) If not, then there is no simple way to tell which service is which (they all look the same). One way to figure out the port working is by running queries, but lets suppose there is no time for that. In that case all services need to be brought down and restart them again manually (Icons on the Desktop) by using the following order:
    + Bring up port 9797 (Physicians. It is very important to bring this up first because right now it is taking 2 hours for this port to bring up)
    + Bring up port 80 ( This is the geocoder)
    + Bring up port 9090 (real estate datasets)
    + Bring up port 88 (Geoeye etc)
    + Bring up port 7070 (General Datasets)
    + Bring up port 8080 (Request service. This should be the last one, it will not operate correctly till port 9797 is working fine)

7. How to restore a port
Task Manager is the way to see what is going on with STREE. There should be ALWAYS 6 instances of streeweb.exe on it. If not, then one port is down. Sometimes the instances are on the task bar of Windows. One can also check for those ports that do not work to figure out which one is down. The simplest way to bring up a port is by doing double-click on the icon in the Desktop for the corresponding port. STREE will initialize the program (it might take a while depending on the service) Once the GUI of STREE reports Ready, the system is able to carry on queries.

8. How to create the First American Parcel Data index so that it can be used in the rooftop geocoder. This service is also known as the matchprop=2 service.
Run the program FileCache_FAPD.java (I sent this to Huibo). Parameters: directory where the index is to be placed, name of the data file containing the parcels, null, 1, field of the zip code and field of the address.
The data file is usually located in ~/TFoverlays/firstamerican_points_2012.asc
This process creates a huge index that may take 5 or 6 days to complete. Then, copy the files into folder D:\FAPD of the STREE3 and STREE4 servers and reboot the port 80 services. Do test 
[http://stree.cs.fiu.edu/street?street=125%20Northeast%2010th%20Street,%20Miami,%20FL&matchprop=2][part8Url]
It must return
X=-80.191822	Y=25.784077
Level=1	Exact Parcel match

[part8Url]:http://stree.cs.fiu.edu/street?street=125%20Northeast%2010th%20Street,%20Miami,%20FL&matchprop=2
9. How to enable a new IP in the STREE service.
STREE does not use a configuration file to enable IPs from outside. STREE service is private and only access within the school is allowed. However, one can provide access to STREE by modifying the source code in the file webobject.pas in the folder C:\Src\Webobjects.
Locate the place where all IPs are enabled e.g. a string such as “pos('207.224.213.179',IP) = 1” and add the corresponding IP.
Once this is done, recompile the port where the access is going to be given and deploy.

10. On request? query? and redirection services 
   + request? service requires modification of source code.  Go to request source code and modify the corresponding section.
   + query? service requires modification of the streeweb.ini or autoweb.ini files.
   + For redirection, it happens in port 8080. Modify streeweb.ini in folder stree1 by including the lines

[Remote35]
Host=http://localhost:7070/
Command=hotelsd
+	The above lines mean a remote service number 35 in port 7070 whose command is hotelsd







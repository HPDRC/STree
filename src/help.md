## HPDRC Spatial Web Service Help
Release as of 10/17/2002 07:18 PM

Commands:
**1. help** - displays this page. Example: [http://n158.cs.fiu.edu/help][helpUrl]

[helpUrl]: http://n158.cs.fiu.edu/help
**2. street?street=<street_address>&zip=<zip>&city=<city>&state=<state>**
Finds the nearest address range and interpolates the coordinate of the house.

Example:
[http://n158.cs.fiu.edu/street?street=100 lincoln rd&city=Miami fl][ExampleUrl]

[ExampleUrl]: http://n158.cs.fiu.edu/street?street=100%20lincoln%20rd&city=Miami%20fl

Result:
X=-80.129217	Y=25.790115
Level=1	Exact match

Possible result codes are:
1. 'Exact match'
2. 'Approx match' - the program could not find the exact range, but found the nearest syntactic match or range
3. 'Zip center' - the returned coordinate is the zip code center
4. 'City Center' - the returned coordinate is the city center
5. 'Not Found' - nothing was found


The state can optionally be appended to the city field. If the street= field is missing or contains a PO Box, the program will search for the zip code center or city center.
The city, zip, state fields may be missing.

**3. Strip objects commands:**

The following strip objects commands are active now:

| Command   | Description   | 
| --------- |-------------- |
| hotels    | US hotels     |
| gnis      | GNIS data     |  
| uschool   | US schools    |
| real      | Real estate   |
| folio     | Miami Date folios     |
| modis     | Modis fires   |
| hms       | HMS Fires   |
| fimma     | Fimma Fires   |
| abba      | ABBA fires    |
| raws      | RAWS weather stations |
each command has the following syntax:

**<command>?x1=number&y1=number[&x2=number&y2=number][&limit=number][&d=number][&header=1/0][&numfind=number]**

Examples:

Find 10 nearest properties and sort by distance:
[http://n158.cs.fiu.edu/folio?x1=-80.129138&y1=25.790404&numfind=10&printdist=1&header=1][Example2Url]

[Example2Url]: http://n158.cs.fiu.edu/folio?x1=-80.129138&y1=25.790404&numfind=10&printdist=1&header=1

Find all properties within 0.5 miles from the point and sort by distance:
[http://n158.cs.fiu.edu/folio?x1=-80.129138&y1=25.790404&d=0.5&limit=1000&printdist=1&header=1][Example3Url]

[Example3Url]: http://n158.cs.fiu.edu/folio?x1=-80.129138&y1=25.790404&d=0.5&limit=1000&printdist=1&header=1

Options description:
**x1, y1** - the point coordinates or the rectangle corner.
**x2, y2** - the opposite rectangle corner, optional for rectangle queries.
**limit** - limits the number of results to the specified number. 
    The default is 100. If the limit is exceeded, no results is returned. 
    An error message is returned instead: ERROR: LIMIT EXCEEDED. FOUND:number
**numfind** - valid for point (where x2 and y2 is not specified) queries only.
    Specifies the number of objects to find that are closesest to 
    the specified point in x1 and y1.
**printdist** - print the distance in meters, direction and offset fields by 
    appending them to the strip record
**header** - pre-pend the strip header.

**4. city?x1=number&y1=number**

This command returns the nearest city to the given coordinates record in the strip format. The city records are taken in the strip format from the file root\Cities\all.cities, where the root is the root program directory.

The distance to the city is shown in miles measured as a circle distance on earth surface using the formula:

D=69.115*180*arccos(sin(pi*y1/180)*sin(pi*y2/180)+cos(pi*y1/180)*cos(pi*abs(x1-x2)/180)), where x2 and y2 are the longitude and latitude of the city.

Example: 

[http://n158.cs.fiu.edu/city?x1=-84&y1=27 ][Example4Url]

[Example4Url]: http://n158.cs.fiu.edu/city?x1=-84&y1=27 

The record format: the fields are the tab delimited: citycode, cityname, statecode or null, countrycode, statename or null, countryname, lattitude, longitude.

**5. Shape commands**

The following shape queries are active now: (data from www&#46;census&#46;gov)

| Command   | Description   | 
| --------- |-------------- |
| bg        | [ 2000 Census Block Groups][5.1.1Url]  records as described in the [Metadata][5.1.2Url] |
| tracts    | [ 2000 Census Tracts][5.2.1Url]  records as described in the [Metadata][5.2.2Url] | 
| incorp    | [ 2000 Incorporated Places/Census Designated Places ][5.3.1Url]  records as described in the [Metadata][5.3.2Url] | 
| subcounty | [ 2000 County Subdivisions][5.4.1Url]  records as described in the [Metadata][5.4.2Url] | 
| congress  | [ 107th Congressional Districts (Jan. 2001 - Jan. 2003) ][5.5.1Url]  records as described in the [Metadata][5.5.2Url] | 
| counties  | [ 2000 County and County Equivalent Areas][5.6.1Url]  records as described in the [Metadata][5.6.2Url] | 
| metro     | [ 1999 Metropolitan Areas][5.7.1Url]  records as described in the [Metadata][5.7.2Url] | 
| state     | 2000 Census States |
| zip       |  2000 census zip codes, see [US zip code census files][5.8.1Url] |

[5.1.1Url]: https://www.census.gov/geo/www/cob/bg2000.html 
[5.1.2Url]: https://www.census.gov/geo/www/cob/bg_metadata.html
[5.2.1Url]: https://www.census.gov/geo/www/cob/tr2000.html 
[5.2.2Url]: https://www.census.gov/geo/www/cob/tr_metadata.html 
[5.3.1Url]: https://www.census.gov/geo/www/cob/pl2000.html 
[5.3.2Url]: https://www.census.gov/geo/www/cob/pl_metadata.html
[5.4.1Url]: https://www.census.gov/geo/www/cob/cs2000.html
[5.4.2Url]: https://www.census.gov/geo/www/cob/cs_metadata.html 
[5.5.1Url]: https://www.census.gov/geo/www/cob/cd107.html 
[5.5.2Url]: https://www.census.gov/geo/www/cob/cd_metadata.html 
[5.6.1Url]: https://www.census.gov/geo/www/cob/co2000.html
[5.6.2Url]: https://www.census.gov/geo/www/cob/co_metadata.html
[5.7.1Url]: https://www.census.gov/geo/www/cob/ma1999.html 
[5.7.2Url]: https://www.census.gov/geo/www/cob/ma_metadata.html 
[5.8.1Url]: https://www.census.gov/geo/www/cob/z52000.html

Example:  [http://n158.cs.fiu.edu/county?x1=-80.125&y1=25.95 ][Example5Url]

[Example5Url]: http://n158.cs.fiu.edu/county?x1=-80.125&y1=25.95 

**syntax:**

**<command>?x1=number&y1=number[&x2=number&y2=number][&resx=number&resy=number][&limit=number][&center=0/1][&bbox=0/1][&stat=0/1][&dir=0/1][&census=0/1]**

**x1, y1** - the point coordinates or the rectangle corner.
**x2, y2** - the opposite rectangle corner, optional for rectangle queries.
**limit** - limits the number of results to the specified number. 
The default is 100. If the limit is exceeded, no results is returned. 
An error message is returned instead: ERROR: LIMIT EXCEEDED. FOUND:number

**bbox=1 or 0** - output the shape bounding box
**stat=1 or 0** - output the census statistics records provided by M. Baranovsky
**dir=1 or 0** - optionally append the distance and the direction to each object's center from x1 y1
**census=1 or 0** - optionally append the word 'census' to each record in the output

**precise=1 or 0** option causes the program to find a precise intersection of the specified bounding rectangle with the area polygon. 

Otherwise the program returns all areas with the bounding rectangles that intersect the given rectangle.

**town=1 or 0** - will return the associated city and state information for the zip codes. This option is implemented for the zip code query only.


**resx=integer&resy=integer** will return the intersection of the shape polygon contour with the specified rectangle scaled into integer bitmap coordinates.  When scaling, it is assumed the bitmap point (0,0) corresponds to the earth point with coordinates (x1, y2) and the bitmap point (resx, resy) corresponds to the earth point with coordinates (x2,y1) - this is the standard for bitmaps. The polygon is appended in brackets {} to the normal program output. Each polygon consists of 1 or more contours. Contours can be the area contours or hole contours. (Holes do not belong to the area). Area contours start with 0, hole contours start with 1. The bitmap integer x and y coordinates of the vertices of the intersection contour follow the hole indicator in a clockwise order. The plotting program is supposed to plot a line starting from the first vertex to the next and so on, finishing at the first vertex at the end. In the example below, the zip code 33009 consists of two non-hole contours: 

Example:  [http://n158.cs.fiu.edu/zip?x1=-80.125&y1=25.95&x2=-80&y2=26&resx=800&resy=600%A0 ][Example6Url]

[Example6Url]: http://n158.cs.fiu.edu/zip?x1=-80.125&y1=25.95&x2=-80&y2=26&resx=800&resy=600%A0 

0
29 268
33 299
16 300
24 166
34 164


and

0
31 34
20 116
7 300
5 308
0 308
0 0
33 0

**center=1** will output the center of the zip code as specified in the census files scaled to the bitmap coordinates. Note that the center may lie outside of the bitmap boundaries. In that case the scaled center coordinates will be either less than zero or greater than the specified bitmap resolution

***6. explore*** - Interactive hotel browser interface that allows you to search for hotels by zip code, city name, and location coordinates.

Example:  [http://n158.cs.fiu.edu/explore ][Example7Url]

[Example7Url]: http://n158.cs.fiu.edu/explore

Retrieves the . The options have the same meaning as in the zip? command. The default is precise=1.

Example:  [http://n158.cs.fiu.edu/county?x1=-80.125&y1=25.95 ][Example5Url]

**7. query?category=name1&category=name2...**

This command allows you to retrieve multiple queries 2-12 in a single HTTP request.

Example:  [http://n158.cs.fiu.edu/query?category=zip&category=incorp&category=county&x1=-121.97306&y1=37.79139&x2=-121.98306&y2=38.89139 ][Example8Url]

[Example8Url]: http://n158.cs.fiu.edu/query?category=zip&category=incorp&category=county&x1=-121.97306&y1=37.79139&x2=-121.98306&y2=38.89139

If category= is omitted, all available queries will be returned.










# DeepSee-USNames
This repository contains the source classes to be used in DeepSee, InterSystem's Business Intelligence platform: 

[DeepSee](http://www.intersystems.com/our-products/embedded-technologies/deepsee/ "DeepSee")


The source class parse the most frequent names in the 1990's in the U.S. The data is extracted from this page from the US census: 

[U.S. Census](http://www2.census.gov/topics/genealogy/1990surnames/dist.male.first "U.S. Census")

After cloning this repository, the classes, the pivot and dashboard can be imported as usual using Studio or Atelier, or from terminal as follows:

```
Set path="\<path-to-local-files>"
Write $system.OBJ.Load(path_"NamesUS.xml","cf")
Write $system.OBJ.Load(path_"NamesUSCube.xml","cf")
Do ##class(%DeepSee.UserLibrary.Utils).%Import(path_"NamesUS.pivot.xml",1)
Do ##class(%DeepSee.UserLibrary.Utils).%Import(path_"NamesUS.dashboard.xml",1)
```

To generate data based on the name frequency in the 1990s in the US and to build the DeepSee cube please run: 

```
Do ##class(Ale.NamesUS).GenerateData() 
Do ##class(%DeepSee.Utils).%BuildCube("NamesUS")
```

Screenshot of the "NamesUS" dashboard:

![Alt text](https://github.com/aless80/DeepSee-USNames/blob/master/DeepSee-USNames.png "DeepSee-USNames Dashboard")


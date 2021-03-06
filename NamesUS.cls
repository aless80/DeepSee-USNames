Class Ale.NamesUS Extends %Persistent
{

Property NameID As %Integer;

Property NameCount As %Integer;

Property Name As %String;

Property Frequency As %Numeric;

Property CumFrequency As %Numeric;

Property Rank As %Integer;

/// To generate data based on the name frequency in the 1990s in the US and to build the DeepSee cube please run: 
/// Do ##class(Ale.NamesUS).GenerateData() 
/// Do ##class(%DeepSee.Utils).%BuildCube("NamesUS")
/// Follow the link in ..GetRawTextFromLink() for the details on the dataset
ClassMethod GenerateData(maxCount As %Integer) As %Status
{
    Set status=$$$OK
    Write !, "Deleting Names data..."
    //first kill extent and kill extents of child tables (none for Ale.NamesUS)
    Do ..%KillExtent()
    
    Write !, "Adding Names..."
	IF $DATA(maxCount)=0 {
		Set status=..GetNames()
	} ELSE {
		Set status=..GetNames(maxCount)
	}    
    Quit status
}

/// s tRawText=##class(Ale.NamesUS).GetRawTextFromLink(,.pSC)
/// Derives the server name and URL from <var>pLink</var> and then uses these to target a
/// <class>%Net.HttpRequest</class> at the article, returning its raw content as a string.
ClassMethod GetRawTextFromLink(pLink As %String, Output pSC As %Status) As %String
{
	I $D(pLink)=0 {
		S pLink="https://www2.census.gov/topics/genealogy/1990surnames/dist.male.first" 	
		S pLink=$e(pLink,$find(pLink,"https://"),*) 										
	}
	set pSC = $$$OK
	set tRawText = ""
	try {
		// derive server and path from pLink
		set pLink = $zstrip(pLink,"<>W")
			
		set tFirstSlash = $find(pLink,"/")
		set tServer = $e(pLink,1,tFirstSlash-2)
		set tPath = $e(pLink,tFirstSlash-1,*)
		//Create SLLConfigs
		S namespace=$Namespace
		zn "%SYS"
		S st=##class(Security.SSLConfigs).Create("Temp")
		S conf=##class(Security.SSLConfigs).%OpenId("Temp")
		S conf.VerifyPeer=0
		zn namespace		
		
		// send the HTTP request for the data
		Set tRequest = ##class(%Net.HttpRequest).%New()
		Set tRequest.SSLConfiguration="Temp"		
		Set tRequest.Server = tServer
		Set tSC = tRequest.Get(tPath)
		//Delete the SSLConfigs
		Zn "%SYS"
		Set st=##class(Security.SSLConfigs).Delete("Temp")
		Zn namespace
		If 'tSC{
			zn namespace
			W !,$System.Status.DisplayError(tSC)
			Quit 
		}
		//Read the data		
		Quit:$$$ISERR(tSC)
		Set len = 32000
		While len>0 {
			Set tString = tRequest.HttpResponse.Data.Read(.len, .pSC)
			Quit:$$$ISERR(pSC)
			Set tRawText = tRawText _ tString
		}
		//Remove those $c(10) characters
		Set tRawText=$REPLACE($ZCONVERT(tRawText,"O","JS"),"\n","\")
		//Strip all double spaces
		While $find(tRawText,"  ") > 0 {
			Set tRawText=$REPLACE(tRawText,"  "," ")
		}
	} Catch (ex) {
		Set pSC = ex.AsStatus()
	}
	Quit tRawText
}

/// run:  d ##class(Ale.NamesUS).GetDataFromTable(,.line,.nameCount)
ClassMethod GetDataFromTable(pLink As %String, ByRef line As %String, Output nameCount As %Integer) As %Status
{
	//As List of %String
	IF $D(pLink)=0 {
		S raw=..GetRawTextFromLink()
	} ELSE {
		S raw=..GetRawTextFromLink(pLink)
		}
 	s i = 1
 	s l = 0
 	s lOld=0
 	for { //for on lines
 		s l=$find(raw,"\",l)
 		Q:l=0
 		
 		s temp = $E(raw,lOld,l-1)
 		s space = 1
 		s spaceOld = 0 		
 		s j = 0
    		/*The data looks like:
    		"DORSEY 0.004 90.029 1216\"
    		*/
    		s counter=0
    		while space > 0 {
	    		//Security quit
				s counter=counter+1
				Q:counter=10

	    		s space=$find(temp," ",spaceOld)
	    		if space>0 {
		    		//Convert to number some of these fields: that happens in GetNames()
		    		//NB: It is important to remove spaces!
		    		S line(i,$I(j))=$TRANSLATE($E(temp,spaceOld,space-2)," ","")
	    		}
	    		elseif space=0 {
		    		S line(i,$I(j))=$E(temp,spaceOld,*-1)
	    		}
				s spaceOld = space
				Q:space=0	
    		}
 		//}
		s lOld=l
		s i=i+1
 	}
 	s nameCount = i - 1
 	Q $$$OK
}

/// run: d ##class(Ale.NamesUS).GetNames()
ClassMethod GetNames(records As %Integer) As %Status
{
	d ..%KillExtent()
	S status=..GetDataFromTable(,.line, .nameCount) 
	IF $DATA(records)=0 {
		S records=nameCount
	}
 	//W !!,"GetNames records="_records
	For n = 1:1:records {
		Set name=##class(Ale.NamesUS).%New()
    	Set name.NameCount=records
    	Set name.NameID=n    	
    	Set name.Name=line(n,1)
    	Set name.Frequency=line(n,2)
 		Set name.CumFrequency=line(n,3)
 		Set name.Rank=+line(n,4) 		
 		
 		Set status=name.%Save()
	}
	
	If $$$ISERR(status) {Do $System.Status.DisplayError(status) Write !, "Name save error"}
	Write !
    Write records," names stored in Ale.NamesUS"
    Quit status
}

Storage Default
{
<Data name="NamesUSDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NameID</Value>
</Value>
<Value name="3">
<Value>NameCount</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>Frequency</Value>
</Value>
<Value name="6">
<Value>CumFrequency</Value>
</Value>
<Value name="7">
<Value>Rank</Value>
</Value>
</Data>
<DataLocation>^Ale.NamesUSD</DataLocation>
<DefaultData>NamesUSDefaultData</DefaultData>
<IdLocation>^Ale.NamesUSD</IdLocation>
<IndexLocation>^Ale.NamesUSI</IndexLocation>
<StreamLocation>^Ale.NamesUSS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}


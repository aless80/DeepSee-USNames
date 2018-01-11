/// Grabs the data in http://www2.census.gov/topics/genealogy/1990surnames/dist.male.first
/// cantaining the frequency of first Names in the US in 1990, or something like that
Class Ale.NamesUSCube Extends %DeepSee.CubeDefinition [ DependsOn = Ale.NamesUS ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="NamesUS" displayName="NamesUS" disabled="false" abstract="false" sourceClass="Ale.NamesUS" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false">
  <dimension name="NamesD" disabled="false" hasAll="false" allCaption="All NamesD" allDisplayName="NamesD" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Name" disabled="false" sourceProperty="Name" list="false" useDisplayValue="true" sort="asc numeric" useAsFilter="true" hidden="false">
        <additionalDescription>undefined</additionalDescription>
      </level>
    </hierarchy>
  </dimension>
  <dimension name="NamesID" disabled="false" hasAll="false" allCaption="All NamesID" allDisplayName="NamesID" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="ID" disabled="false" sourceProperty="NameID" list="false" useDisplayValue="true" sort="asc numeric" useAsFilter="true" hidden="false">
        <additionalDescription>undefined</additionalDescription>
      </level>
    </hierarchy>
  </dimension>
  <dimension name="FrequencyD" disabled="false" hasAll="false" allCaption="All FrequencyD" allDisplayName="FrequencyD" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Frequency" disabled="false" sourceExpression="%source.Frequency" list="false" useDisplayValue="true" sort="asc numeric" useAsFilter="true" hidden="false">
        <additionalDescription>undefined</additionalDescription>
      </level>
    </hierarchy>
  </dimension>
  <dimension name="CumFrequencyD" disabled="false" hasAll="false" allCaption="All CumFrequencyD" allDisplayName="CumFrequencyD" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Cumulative Frequency" disabled="false" sourceExpression="%source.CumFrequency" list="false" useDisplayValue="true" sort="asc numeric" useAsFilter="true" hidden="false">
        <additionalDescription>undefined</additionalDescription>
      </level>
    </hierarchy>
  </dimension>
  <dimension name="RankD" disabled="false" hasAll="false" allCaption="All RankD" allDisplayName="RankD" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Rank" disabled="false" sourceProperty="Rank" list="false" useDisplayValue="true" sort="asc numeric" useAsFilter="true" hidden="false">
        <additionalDescription>undefined</additionalDescription>
      </level>
    </hierarchy>
  </dimension>
  <measure name="Frequency Meas" disabled="false" sourceProperty="Frequency" aggregate="SUM" type="number" hidden="false" searchable="false">
    <additionalDescription>undefined</additionalDescription>
  </measure>
  <measure name="CumFrequency Meas" disabled="false" sourceProperty="CumFrequency" aggregate="SUM" type="number" hidden="false" searchable="false">
    <additionalDescription>undefined</additionalDescription>
  </measure>
  <measure name="Rank" disabled="false" sourceProperty="Rank" aggregate="AVG" type="number" hidden="false" searchable="false" formatString="#">
  </measure>
  <listing name="Listing" displayName="Listing" disabled="false" listingType="table" fieldList="Name,CumFrequency,Frequency,NameCount,Rank,NameID,%ID">
    <additionalDescription>undefined</additionalDescription>
  </listing>
</cube>
}

Parameter DOMAIN;

}


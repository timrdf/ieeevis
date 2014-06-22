<xsl:transform version="2.0" 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:sr="http://www.w3.org/2005/sparql-results#"
   exclude-result-prefixes="">
<xsl:output method="text"/>

<!-- 
#3> <> rdfs:seeAlso <https://github.com/timrdf/csv2rdf4lod-automation/wiki/SDV-organization> .
-->
<xsl:param name="cr-base-uri"   select="'http://my.com'"/>
<xsl:param name="cr-source-id"  select="'epa-gov'"/>
<xsl:param name="cr-dataset-id" select="'some-dataset'"/>
<xsl:param name="cr-version-id" select="'latest'"/>

<!-- 
#3> <> rdfs:seeAlso <https://github.com/timrdf/vsr/wiki/Content-Preserving-Group-By> .
-->
<xsl:param name="group" select="'revert'"/>
<xsl:param name="dim1"  select="'reverter'"/>
<xsl:param name="dim2"  select="'against'"/>

<!--
  <variable name="reverter"/>
  <variable name="against"/>
  <variable name="supports"/>
  <variable name="revert"/>
-->

<xsl:variable name="abstract" select="concat($cr-base-uri,'/source/',$cr-source-id,'/dataset/',$cr-dataset-id)"/>
<xsl:variable name="sdv"      select="concat($cr-base-uri,'/source/', $cr-source-id,'/dataset/',$cr-dataset-id,'/version/',$cr-version-id)"/>

<xsl:variable name="prefixes"><![CDATA[@prefix prov:   <http://www.w3.org/ns/prov#>.
@prefix qb:    <http://purl.org/linked-data/cube#> .
@prefix sio:   <http://semanticscience.org/resource/> .
@prefix vocab: <http://ieeevis.tw.rpi.edu/source/ieeevis-tw-rpi-edu/dataset/IEEE-VAST-Challenge-2008-mc2-reverts-social-tally/vocab/> .
]]>
</xsl:variable>

<xsl:template match="/">
   <xsl:value-of select="$prefixes"/>

   <!-- We're grouping 'revert' members -->
   <!-- According to the values of 'reverter', then 'against' -->
   <xsl:variable name="dimensions" select="tokenize(.,',')"/>
   <!-- Two ways to make two different qb:Observations -->
   <xsl:for-each-group select="//sr:result" group-by="sr:binding[@name=$dim1]/*[1]">
      <xsl:variable name="val-1"       select="sr:binding[@name=$dim1]/*[1]"/>
      <xsl:variable name="val-1-local" select="replace($val-1,'^.*/','')"/>
      <xsl:for-each-group select="current-group()" group-by="sr:binding[@name=$dim2]/*[1]">
         <xsl:variable name="val-2"         select="sr:binding[@name=$dim2]/*[1]"/>
         <xsl:variable name="val-2-local"   select="replace($val-2,'^.*/','')"/>
         <xsl:variable name="count"         select="count(current-group()/sr:binding[@name=$group])"/>
         <xsl:variable name="qualification" select="concat($LT,$sdv,'/',$val-1-local,'/',$dim2,'/',$val-2-local,'/',$count,$GT)"/>
         
         <!--xsl:value-of select="concat('# ',$dim1,' ',$val-1,$NL,'  ',$dim2,'  ',$val-2,$NL,'  ',$count,' ',$group,'s',$NL)"/-->
         <xsl:value-of select="concat($LT,$val-1,$GT,$NL)"/>
         <xsl:value-of select="concat('   vocab:qualified',sr:cap($dim2),' ',$qualification,';',$NL)"/>
         <xsl:value-of select="concat('.',$NL)"/>
         <xsl:value-of select="concat($LT,$sdv,'/',$val-1-local,'/',$dim2,'/',$val-2-local,'/',$count,$GT,$NL)"/>
         <xsl:value-of select="concat('   a prov:EntityInfluence, qb:Observation, vocab:',sr:cap($dim2),';',$NL)"/>
         <xsl:value-of select="concat('   prov:entity ',$LT,$val-2,$GT,';',$NL)"/>
         <xsl:value-of select="concat('   sio:count ',$count,';',$NL)"/>
         <xsl:for-each select="current-group()/sr:binding[@name=$group]">
            <xsl:value-of select="concat('   sio:has-member ',$LT,.,$GT,';',$NL)"/>
         </xsl:for-each>
         <xsl:value-of select="concat('.',$NL,$NL)"/>
      </xsl:for-each-group>
   </xsl:for-each-group>
</xsl:template>

<xsl:variable name="NL" select="'&#xa;'"/>
<xsl:variable name="DQ" select="'&#x22;'"/>
<xsl:variable name="LT" select="'&lt;'"/>
<xsl:variable name="GT" select="'&gt;'"/>

<xsl:function name="sr:cap">
   <xsl:param name="string"/>
   <xsl:value-of select="concat(upper-case(substring($string,1,1)),substring($string,2))"/>
</xsl:function>

</xsl:transform>

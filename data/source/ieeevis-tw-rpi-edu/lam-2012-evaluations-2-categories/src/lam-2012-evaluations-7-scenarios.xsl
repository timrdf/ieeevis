<xsl:transform version="2.0" 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:sr="http://www.w3.org/2005/sparql-results#"
   exclude-result-prefixes="">
<xsl:output method="text"/>

<xsl:param name="base-uri" 
           select="'http://ieeevis.tw.rpi.edu/source/ieeevis-tw-rpi-edu/dataset/lam-2012-evaluations-7-scenarios/version/2013-Mar-22'"/>

<xsl:key name="get"         match="sr:binding/sr:uri" use="../@name"/>
<xsl:key name="by-year"     match="sr:result"         use="sr:binding[@name='year']/sr:literal"/>
<xsl:key name="by-scenario" match="sr:result"         use="sr:binding[@name='scenario']/sr:uri"/>

<xsl:template match="/">

   <xsl:value-of select="concat(
      '@prefix rdfs:    &lt;http://www.w3.org/2000/01/rdf-schema#&gt; .',$NL,
      '@prefix xsd:     &lt;http://www.w3.org/2001/XMLSchema#&gt; .',$NL,
      '@prefix foaf:    &lt;http://xmlns.com/foaf/0.1/&gt; .',$NL,
      '@prefix dcterms: &lt;http://purl.org/dc/terms/&gt; .',$NL,
      '@prefix void:    &lt;http://rdfs.org/ns/void#&gt; .',$NL,
      '@prefix sioc:    &lt;http://rdfs.org/sioc/ns#&gt; .',$NL,
      '@prefix prov:    &lt;http://www.w3.org/ns/prov#&gt; .',$NL,
      '@prefix sio:     &lt;http://semanticscience.org/resource/&gt; .',$NL,
      '@prefix skos:    &lt;http://www.w3.org/2004/02/skos/core#&gt; .',$NL,
      '@prefix bibo:    &lt;http://purl.org/ontology/bibo/&gt; .',$NL,
      '@prefix qb:      &lt;http://purl.org/linked-data/cube#&gt; .',$NL,
      '@base &lt;',$base-uri,'&gt; .',$NL,$NL)"/>

   <xsl:variable name="context" select="*[1]"/>

   <xsl:variable name="range">
      <xsl:for-each-group select="//sr:binding[@name='year']" group-by=".">
         <xsl:sort select="xs:integer(.)"/>
         <xsl:if test="position()=1 or position()=last()">
            <xsl:value-of select="xs:integer(current-grouping-key())"/>
         </xsl:if>
      </xsl:for-each-group>
   </xsl:variable>

   <xsl:variable name="scenarios" select="key('get','scenario')"/>
   <!--xsl:variable name="years"     select="1995 to 2011"/-->


   <!--
    xsl:for-each select="$range[1] to $range[2]"-->
   <xsl:for-each-group select="//sr:binding[@name='year']" group-by="sr:literal">
      <xsl:sort select="xs:integer(current-grouping-key())"/>
      <xsl:variable name="year" select="current-grouping-key()"/>
      <xsl:message select="$year"/>
      <xsl:for-each-group select="//sr:binding[@name='scenario']" group-by="sr:uri">
         <xsl:variable name="scenario" select="current-grouping-key()"/>
         <xsl:message select="concat('  ',$year,' ',$scenario)"/>

         <!-- http://ieeevis.tw.rpi.edu/source/datahub.io/dataset/vis-seven-scenarios-codings/count/1995/data-process/uwp
                 a qb:Observation;
                 void:inDataset <http://ieeevis.tw.rpi.edu/source/datahub.io/dataset/vis-seven-scenarios-codings/figure/1>;
                 dcterms:date    "1995";
                 dcterms:subject <../../category/visualization>;
                 sio:count 2;
                 sio:has-member <../../paper/venue/infovis/year/1995/1>;
                 sio:has-member <../../paper/venue/infovis/year/1995/2>;
         -->
         <xsl:value-of select="concat(
            '&lt;../../count/',$year,'/',replace($scenario,'.*category/',''),'&gt;',$NL,
            '   a qb:Observation;',$NL,
            '   void:inDataset &lt;figure/2&gt;;',$NL,
            '   dcterms:date ',$DQ,$year,$DQ,';',$NL,
            '   dcterms:subject &lt;',$scenario,'&gt;;',$NL,
            '   sio:count ',count(key('by-year',$year) intersect key('by-scenario',$scenario)),';',$NL
         )"/>
         <xsl:for-each select="key('by-year',$year) intersect key('by-scenario',$scenario)">
            <xsl:value-of select="concat('   sio:has-member &lt;',sr:binding[@name='publication']/sr:uri,'&gt;;',$NL)"/>
            <xsl:message select="concat('         ',sr:binding[@name='publication']/sr:uri)"/>
         </xsl:for-each>
         <xsl:value-of select="concat('.',$NL)"/>
      </xsl:for-each-group>
   </xsl:for-each-group>

</xsl:template>

<xsl:template match="@*|node()">
  <xsl:copy>
      <xsl:copy-of select="@*"/>   
      <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

<xsl:variable name="NL" select="'&#xa;'"/>
<xsl:variable name="DQ" select="'&#x22;'"/>

</xsl:transform>

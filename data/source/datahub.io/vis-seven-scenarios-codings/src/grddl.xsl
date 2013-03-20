<!--
#3> <> prov:specializationOf <https://github.com/timrdf/ieeevis/blob/master/data/source/datahub.io/vis-seven-scenarios-codings/src/grddl.xsl>;
#3>    prov:wasAttributedTo <http://tw.rpi.edu/instances/TimLebo>;
#3> .
-->

<xsl:transform version="2.0" 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:sof="http://stackoverflow.com/questions/6753343/using-xsl-to-make-a-hash-of-xml-file"
   xmlns:this="https://github.com/timrdf/ieeevis/blob/master/data/source/datahub.io/vis-seven-scenarios-codings/src/grddl.xsl"
   exclude-result-prefixes="">
<xsl:output method="text"/>

<xsl:param name="base-uri" select="'http://ieeevis.tw.rpi.edu/source/datahub.io/dataset/vis-seven-scenarios-codings/version/2013-Mar-08/'"/>
<xsl:param name="infer-hierarchy" select="false()"/>

<xsl:template match="/">
   <xsl:value-of select="concat(
                                 '@prefix rdfs: &lt;http://www.w3.org/2000/01/rdf-schema#&gt; .',$NL,
                                 '@prefix xsd: &lt;http://www.w3.org/2001/XMLSchema#&gt; .',$NL,
                                 '@prefix foaf: &lt;http://xmlns.com/foaf/0.1/&gt; .',$NL,
                                 '@prefix dcterms: &lt;http://purl.org/dc/terms/&gt; .',$NL,
                                 '@prefix void: &lt;http://rdfs.org/ns/void#&gt; .',$NL,
                                 '@prefix sioc: &lt;http://rdfs.org/sioc/ns#&gt; .',$NL,
                                 '@prefix prov: &lt;http://www.w3.org/ns/prov#&gt; .',$NL,
                                 '@prefix sio: &lt;http://semanticscience.org/resource/&gt; .',$NL,
                                 '@prefix skos: &lt;http://www.w3.org/2004/02/skos/core#&gt; .',$NL,
                                 '@prefix bibo: &lt;http://purl.org/ontology/bibo/&gt; .',$NL,
                                 '@prefix qb:  &lt;http://purl.org/linked-data/cube#&gt; .',$NL,
                                 '@base &lt;',$base-uri,'&gt; .',$NL,
                         $NL)"/>

   <xsl:apply-templates select="//code[@frag]"/>

   <xsl:apply-templates select="//publication">
      <xsl:sort select="../../title"/>
      <xsl:sort select="xs:integer(../@id)"/>
      <xsl:sort select="title"/>
   </xsl:apply-templates>

   <xsl:for-each-group select="//year" group-by="@id">                                 <!-- year     -->
      <xsl:sort select="number(current-grouping-key())"/>
      <xsl:variable name="year" select="current-grouping-key()"/>
      <xsl:message select="string($year)"/>

      <xsl:for-each select="//original_codes/code[@id = ('process','visualization')]"> <!-- category -->
         <xsl:variable name="categories">
            <xsl:for-each select="code">                                               <!-- scenario -->
               <xsl:message select="concat('    scenario: ',@id)"/>
               <xsl:for-each select="key('subtree',@id)">                              <!-- tag      -->
                  <xsl:copy-of select="key('pubs',@id)[../@id = $year]"/>
                  <xsl:message select="concat('      tag: ',@id,' = ',count(key('pubs',@id)[../@id = $year]))"/>
               </xsl:for-each>
               <!-- Figure 2 http://dx.doi.org/10.1109/TVCG.2011.279 -->
            </xsl:for-each>
         </xsl:variable>
         <xsl:message select="concat('  ',@id,' ',count($categories/publication),' / ',count(key('venue',$year)),' held venue(s)',$NL)"/>

         <!-- Figure 1 http://dx.doi.org/10.1109/TVCG.2011.279 -->
         <xsl:value-of select="concat(
            '&lt;../../count/',$year,'/',@id,'&gt;',$NL,
            '   a qb:Observation;',$NL,
            '   void:inDataset &lt;../../figure/1&gt;;',$NL,
            '   dcterms:date    ',$DQ,$year,$DQ,';',$NL,
            '   dcterms:subject &lt;../../category/',@frag,'&gt;;',$NL,
            '   sio:count ',count($categories/publication),';',$NL)"/>
         <xsl:for-each select="$categories/publication">
            <xsl:value-of select="concat(
               '   sio:has-member &lt;../../paper/venue/',lower-case(../../title),'/year/',../@id,'/',sof:checksum(title),'&gt;;',$NL)"/>
         </xsl:for-each>
         <xsl:value-of select="concat('.',$NL)"/>
      </xsl:for-each>

      <!-- Figure 2 http://dx.doi.org/10.1109/TVCG.2011.279 -->
      <xsl:for-each select="//original_codes/code[@id = ('process','visualization')]"> <!-- category -->
         <xsl:for-each select="code">                                                  <!-- scenario -->
            <xsl:message select="concat('    scenario: ',@id)"/>
            <xsl:variable name="scenarios">
               <xsl:for-each select="key('subtree',@id)">                              <!-- tag      -->
                  <xsl:copy-of select="key('pubs',@id)[../@id = $year]"/>
                  <xsl:message select="concat('      tag: ',@id,' = ',count(key('pubs',@id)[../@id = $year]))"/>
               </xsl:for-each>
            </xsl:variable>

            <xsl:value-of select="concat(
               '&lt;../../count/',$year,'/',@frag,'&gt;',$NL,
               '   a qb:Observation;',$NL,
               '   void:inDataset &lt;../../figure/2&gt;;',$NL,
               '   dcterms:date    ',$DQ,$year,$DQ,';',$NL,
               '   dcterms:subject &lt;../../category/',@frag,'&gt;;',$NL,
               '   sio:count ',count($scenarios/publication),';',$NL)"/>
            <xsl:for-each select="$scenarios/publication">
               <xsl:value-of select="concat(
                  '   sio:has-member &lt;../../paper/venue/',lower-case(../../title),'/year/',../@id,'/',sof:checksum(title),'&gt;;',$NL)"/>
            </xsl:for-each>
            <xsl:value-of select="concat('.',$NL)"/>
            <xsl:message select="concat('  ',@id,' ',count($scenarios/publication),' / ',count(key('venue',$year)),' held venue(s)',$NL)"/>
         </xsl:for-each>
      </xsl:for-each>
   </xsl:for-each-group>


</xsl:template>

<xsl:function name="this:reference">
   <xsl:param name="node"/>
   <xsl:choose>
      <xsl:when test="name($node) = 'publication'">
         <xsl:value-of select="concat('&lt;../../paper/venue/',lower-case($node/../title),'/year/',$node/../@id,'/',sof:checksum($node/title),'&gt;')"/>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
   </xsl:choose>
</xsl:function>

<xsl:key name="code" match="code" use="@id"/>

<!-- 'up - evaluating user performance' -> category/13, category/8,  category/6/performance -->
<xsl:key name="subtree" match="code" use="broader/@ref | ../broader/@ref"/>
<xsl:key name="pubs"    match="publication" use="code/@ref"/>
<xsl:key name="venue"   match="venue"       use="year/@id"/>

<xsl:template match="publication">

   <xsl:variable name="position">
      <xsl:number count="publication"/>
   </xsl:variable>

   <xsl:value-of select="concat(
      '&lt;../../paper/venue/',lower-case(../../title),'/year/',../@id,'/',$position,'&gt;',$NL,
      '   a bibo:Document;',$NL,
      '   void:inDataset &lt;',$base-uri,'&gt;;',$NL,
      if (string-length(title)) then concat(
         '   dcterms:title ',$DQ,title,$DQ,';',$NL) else '',
      if (string-length(authors)) then concat(
         '   dcterms:creator &lt;authors/',sof:checksum(authors),'&gt;;',$NL) else '',
      if (string-length(doi)) then concat(
         '   prov:alternateOf &lt;',doi,'&gt;;',$NL) else '',
      if (starts-with(doi,'http://dx.doi.org/')) then concat(
         '   bibo:doi ',$DQ,substring-after(doi,'http://dx.doi.org/'),$DQ,';',$NL) else ''
   )"/>

   <xsl:for-each-group select="code" group-by="@ref">
      <!--
         <code ref="1"/>
         <code ref="10"/>
         <code ref="11"/>
         <code ref="12"/>
         <code ref="13"/>
         <code ref="14"/>
         <code ref="15"/>
         <code ref="16 (ML criteria)"/>
         <code ref="16 (standard datasets)"/>
         <code ref="16"/>
         <code ref="17"/>
         <code ref="18"/>
         <code ref="2"/>
         <code ref="3"/>
         <code ref="4"/>
         <code ref="5"/>
         <code ref="6 (Exp)"/>
         <code ref="6 (Per)"/>
         <code ref="6 (exp: informal user feedback and potential uses)"/>
         <code ref="6"/>
         <code ref="7"/>
         <code ref="8"/>
         <code ref="9"/>
      -->
      <xsl:if test="not(key('code',@ref))">
         <xsl:message select="concat('WARNING: missing code description for ',@ref)"/>
      </xsl:if>

      <xsl:for-each select="if ($infer-hierarchy) then key('code',@ref)/ancestor-or-self::code 
                                                  else key('code',@ref)">
         <xsl:value-of select="concat(
            '   dcterms:subject &lt;../../category/',@frag,'&gt;;',$NL
         )"/>
      </xsl:for-each>
   </xsl:for-each-group>

   <xsl:value-of select="concat(
      '.',$NL,
      if (string-length(authors)) then concat(
         '&lt;../../authors/',sof:checksum(authors),'&gt;',$NL,
         '   a foaf:Agent;',$NL,
         '   dcterms:description ',$DQ,authors,$DQ,';',$NL,'.',$NL) else '',
      $NL,$NL
   )"/>

</xsl:template>

<xsl:template match="code">

   <xsl:value-of select="concat(
      '&lt;../../category/',@frag,'&gt;',$NL,
      '   a skos:Concept;',$NL,
      if (string-length(title)) then concat(
         '   dcterms:title ',$DQ,title,$DQ,';',$NL) else ''
   )"/>

   <xsl:if test="true() or $infer-hierarchy">
      <xsl:for-each select="ancestor::code">
         <xsl:value-of select="concat(
            '   skos:broader &lt;../../category/',@frag,'&gt;;',$NL
         )"/>
      </xsl:for-each>
   </xsl:if>

   <xsl:for-each select="broader">
      <xsl:value-of select="concat(
         '   skos:broader &lt;../../category/',key('code',@ref)/@frag,'&gt;;',$NL
      )"/>
   </xsl:for-each>

   <xsl:value-of select="concat(
      '.',$NL,$NL
   )"/>

</xsl:template>

<xsl:variable name="NL" select="'&#xa;'"/>
<xsl:variable name="DQ" select="'&#x22;'"/>

<xsl:function name="sof:checksum" as="xs:integer">
   <xsl:param name="str" as="xs:string"/>
   <!-- Quoted from http://stackoverflow.com/questions/6753343/using-xsl-to-make-a-hash-of-xml-file -->
   <xsl:variable name="codepoints" select="string-to-codepoints($str)"/>
   <xsl:value-of select="sof:fletcher16($codepoints, count($codepoints), 1, 0, 0)"/>
</xsl:function>

<xsl:function name="sof:fletcher16">
   <xsl:param name="str"   as="xs:integer*"/>
   <xsl:param name="len"   as="xs:integer" />
   <xsl:param name="index" as="xs:integer" />
   <xsl:param name="sum1"  as="xs:integer" />
   <xsl:param name="sum2"  as="xs:integer"/>
   <!-- Quoted from http://stackoverflow.com/questions/6753343/using-xsl-to-make-a-hash-of-xml-file -->
   <xsl:choose>
      <xsl:when test="$index ge $len">
         <xsl:sequence select="$sum2 * 256 + $sum1"/>
      </xsl:when>
      <xsl:otherwise>
         <xsl:variable name="newSum1" as="xs:integer"
             select="($sum1 + $str[$index]) mod 255"/>
         <xsl:sequence select="sof:fletcher16($str, $len, $index + 1, $newSum1,
                 ($sum2 + $newSum1) mod 255)" />
      </xsl:otherwise>
   </xsl:choose>
</xsl:function>

</xsl:transform>

<xsl:transform version="2.0" 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:html="http://www.w3.org/1999/xhtml"
   exclude-result-prefixes="">
<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

<xsl:param name="url-base" select="'http://hcil2.cs.umd.edu'"/>
<xsl:param name="mode"     select="'now'"/>

<xsl:template match="/">
   <xsl:apply-templates select="//html:div[@id='text_all']"/>
</xsl:template>

<xsl:template match="html:div">

   <xsl:choose>
      <xsl:when test="$mode = 'now'">
         <xsl:variable name="group" select="//html:a[contains(preceding-sibling::text()[1],'Provenance:')]/@href"/>
         <xsl:variable name="title" select="normalize-space(//html:b[contains(preceding-sibling::text()[1],'Title:')]/text())"/>
         <xsl:variable name="description" select="//html:div[.='Description:']/following-sibling::html:div"/>
            <xsl:value-of select="concat($DQ,string-join((
                                                          $group,$title
                                                         ),
                                                         concat($DQ,',',$DQ)),$DQ,$NL)"/>
      </xsl:when>
      <xsl:when test="$mode = 'parts'">
         <xsl:for-each select="html:ul/html:li">
            <xsl:variable name="part-url"   select="concat($url-base,html:a/@href)"/>
            <xsl:variable name="part-title" select="normalize-space(html:a)"/>
            <xsl:value-of select="concat($DQ,string-join((
                                                          $part-title
                                                         ),
                                                         concat($DQ,',',$DQ)),$DQ,$NL)"/>
         </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
         <xsl:for-each select="following-sibling::html:div[1]/html:br">
            <!-- TODO: not worth the hassle -->
            <xsl:variable name="person"     select="concat($url-base,html:a/@href)"/>
            <xsl:variable name="person-org" select="normalize-space(html:a)"/>
            <xsl:value-of select="concat(preceding-sibling::text()[1],$NL)"/> 
         </xsl:for-each>
      </xsl:otherwise>
   </xsl:choose>
</xsl:template>

<xsl:template match="@*|node()">
  <xsl:copy>
      <xsl:copy-of select="@*"/>   
      <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

<!--xsl:template match="text()">
   <xsl:value-of select="normalize-space(.)"/>
</xsl:template-->

<xsl:variable name="NL" select="'&#xa;'"/>
<xsl:variable name="DQ" select="'&#x22;'"/>

<xsl:function name="html:text">
   <xsl:param name="node"/>
   <xsl:variable name="together">
      <xsl:for-each select="$node//text()">
         <xsl:value-of select="normalize-space(.)"/>
      </xsl:for-each>
   </xsl:variable>
   <xsl:value-of select="normalize-space($together)"/>
</xsl:function>

</xsl:transform>

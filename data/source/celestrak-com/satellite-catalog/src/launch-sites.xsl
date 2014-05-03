<!-- Timothy Lebo -->
<xsl:transform version="2.0" 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:html="http://www.w3.org/1999/xhtml"
   exclude-result-prefixes="">
<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

<!-- http://stackoverflow.com/questions/1384802/java-how-to-indent-xml-generated-by-transformer -->

<xsl:template match="/">
   <xsl:value-of select="concat('Launch Site Code,Launch Site Description,Map URL',$NL)"/>
   <xsl:apply-templates select="//html:tr[@align='center' and not(@bgcolor='SKYBLUE')]"/>
</xsl:template>

<xsl:template match="html:tr">
   <xsl:choose>
      <xsl:when test="html:td[1]/html:a">
         <xsl:value-of select="concat($DQ,normalize-space(html:td[1]/html:a/text()[1]),$DQ)"/>
      </xsl:when>
      <xsl:otherwise>
         <xsl:value-of select="concat($DQ,normalize-space(html:td[1]),$DQ)"/>
      </xsl:otherwise>
   </xsl:choose>

   <xsl:value-of select="concat(',',$DQ,normalize-space(html:td[2]),$DQ)"/>

   <xsl:choose>
      <xsl:when test="html:td[1]/html:a">
         <xsl:value-of select="concat(',',$DQ,replace(replace(normalize-space(html:td[1]/html:a/@href),'javascript:openmap..','http://celestrak.com'),'\.asp.*$','.asp'),$DQ,$NL)"/>
      </xsl:when>
      <xsl:otherwise>
         <xsl:value-of select="concat(',',$DQ,$DQ,$NL)"/>
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

</xsl:transform>

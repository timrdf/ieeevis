<!-- Timothy Lebo -->
<xsl:transform version="2.0" 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:html="http://www.w3.org/1999/xhtml"
   exclude-result-prefixes="">
<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

<!-- http://stackoverflow.com/questions/1384802/java-how-to-indent-xml-generated-by-transformer -->

<xsl:template match="/">
   <xsl:value-of select="concat('Source Organization Code,Description,Homepage',$NL)"/>
   <xsl:apply-templates select="//html:tr[@align='center' and not(@bgcolor='SKYBLUE')]"/>
</xsl:template>

<xsl:template match="html:tr">
   <xsl:value-of select="concat(html:td[1],',')"/>
   <xsl:choose>
      <xsl:when test="html:td[2]/html:a">
         <xsl:variable name="title">
            <xsl:for-each select="html:td[2]/html:a/text()">
               <xsl:value-of select="concat(' ',.)"/>
            </xsl:for-each>
         </xsl:variable>
         <xsl:value-of select="concat($DQ,normalize-space($title[1]),$DQ,',',html:td[2]/html:a/@href,$NL)"/>
      </xsl:when>
      <xsl:otherwise>
         <xsl:value-of select="concat($DQ,html:td[2],$DQ,',',$NL)"/>
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

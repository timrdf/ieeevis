<xsl:transform version="2.0" 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:html="http://www.w3.org/1999/xhtml"
   exclude-result-prefixes="">
<xsl:output method="text"/>

<xsl:variable name="base" select="'http://space.skyrocket.de'"/> <!-- http://space.skyrocket.de/doc_chr/ -->

<xsl:template match="/">
   <xsl:value-of select="concat('Launch ID (COSPAR),Date,',
                                'Payload(s),',
                                'Launch Vehicle,Launch Vehicle Page,',
                                'Launch Site,',
                                'Remark',$NL)"/>
   <xsl:apply-templates select="//html:tr[starts-with(@class,'bigheadline')]/following-sibling::html:tr[html:td]"/>
</xsl:template>

<xsl:template match="html:tr">

   <xsl:variable name="launch-cospar"        select="normalize-space(html:td[1])"/>

   <xsl:variable name="date"                 select="normalize-space(html:td[2])"/>

   <xsl:variable name="payloads">
      <xsl:for-each select="html:td[3]/html:a/text()">
         <xsl:value-of select="'||'"/>
         <xsl:value-of select="normalize-space(.)"/>
      </xsl:for-each>
   </xsl:variable>

   <xsl:variable name="launch-vehicle">
      <xsl:for-each select="html:td[4]/(text() | html:a[1]/text())">
         <xsl:value-of select="normalize-space(.)"/>
      </xsl:for-each>
   </xsl:variable>

   <!-- 
        http://space.skyrocket.de/doc_chr/../doc_lau_det/soyuz-2-1a_fregat-m.htm
        http://space.skyrocket.de/doc_lau_det/soyuz-2-1a_fregat-m.htm 
   -->
   <xsl:variable name="launch-vehicle-page"  select="replace(html:td[4]/html:a[1]/@href,'^\.\.','')"/>

   <xsl:variable name="launch-site"          select="normalize-space(html:td[5])"/>

   <xsl:variable name="remark"               select="normalize-space(html:td[6])"/>

   <xsl:value-of select="concat($DQ,string-join((
                                                 $launch-cospar,$date,
                                                 replace($payloads,'^\|\|*',''),
                                                 $launch-vehicle,if ($launch-vehicle-page) then concat($base,$launch-vehicle-page) else '',
                                                 $launch-site,
                                                 $remark
                                                ),
                                                concat($DQ,',',$DQ)),$DQ,$NL)"/>
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

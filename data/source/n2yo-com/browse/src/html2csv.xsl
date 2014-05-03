<xsl:transform version="2.0" 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:html="http://www.w3.org/1999/xhtml"
   exclude-result-prefixes="">
<xsl:output method="text"/>

<xsl:param name="header" select="'false'"/>
<xsl:variable name="base" select="'http://www.n2yo.com'"/>

<xsl:template match="/">
   <xsl:choose>
      <xsl:when test="not($header = 'false')">
         <xsl:value-of select="concat('SSC,Name,Launch Date,Status,Homepage,Track Page',$NL)"/>
      </xsl:when>
      <xsl:otherwise>
         <xsl:apply-templates select="//html:table/html:tr[html:td[.='Name']]/following-sibling::html:tr"/>
      </xsl:otherwise>
   </xsl:choose>
</xsl:template>

<xsl:template match="html:tr">
   <!--     <tr bgcolor="#C6FFE2">
               <td rowspan="1" colspan="1">
                  <a href="/satellite/?s=39370" shape="rect">MARS ORBITER MISSION</a>
               </td>
               <td rowspan="1" colspan="1">2013-11-05</td>
               <td rowspan="1" colspan="1">
                  <b>IN ORBIT</b>
               </td>
               <td rowspan="1" colspan="1">
                  <a href="/?s=39370" shape="rect">Track it</a>
               </td>
            </tr>              -->
   <xsl:variable name="page"        select="if (html:td[1]/html:a/@href) then concat($base,html:td[1]/html:a/@href) else ''"/>
   <xsl:variable name="name"        select="html:text(html:td[1]/html:a)"/>
   <xsl:variable name="launch-date" select="html:td[2]"/>
   <xsl:variable name="status"      select="html:text(html:td[3])"/>
   <xsl:variable name="track-page"  select="if (html:td[4]/html:a/@href) then concat($base,html:td[4]/html:a/@href) else ''"/>

   <xsl:variable name="ssc"         select="if ($page) then replace($page,'^.*\?s=','') else ''"/>
   <xsl:value-of select="concat($DQ,string-join((
                                                 $ssc,$name,
                                                 $launch-date,
                                                 $status,
                                                 $page,$track-page
                                                ),
                                                concat($DQ,',',$DQ)),$DQ,$NL)"/>
</xsl:template>

<xsl:template match="@*|node()">
  <xsl:copy>
      <xsl:copy-of select="@*"/>   
      <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

<xsl:function name="html:text">
   <xsl:param name="node"/>
   <xsl:variable name="together">
      <xsl:for-each select="$node//text()">
         <xsl:value-of select="normalize-space(.)"/>
      </xsl:for-each>
   </xsl:variable>
   <xsl:value-of select="normalize-space($together)"/>
</xsl:function>

<!--xsl:template match="text()">
   <xsl:value-of select="normalize-space(.)"/>
</xsl:template-->

<xsl:variable name="NL" select="'&#xa;'"/>
<xsl:variable name="DQ" select="'&#x22;'"/>

</xsl:transform>

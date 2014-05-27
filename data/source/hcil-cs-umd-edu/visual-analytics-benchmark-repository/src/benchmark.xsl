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
         <xsl:variable name="title"             select="normalize-space(//html:b[contains(preceding-sibling::text()[1],'Title:')]/text())"/>
         <xsl:variable name="description"       select="html:text(//html:div[.='Description:']/following-sibling::html:div)"/>
         <xsl:variable name="description-links" select="html:anchor-hrefs(//html:div[.='Description:']/following-sibling::html:div//html:a,'')"/>
         <xsl:variable name="dataset-link"      select="//html:div[.='Dataset available at:']/following-sibling::html:div//html:a/@href"/>
         <xsl:variable name="solution-link"     select="//html:div[.='Solution:']/following-sibling::html:div//html:a/@href"/>
         <xsl:variable name="contacts"          select="//html:div[.='Contacts:']/following-sibling::html:div"/> <!-- not worth the effort -->
         <xsl:variable name="group-id"          select="substring-after(//html:a[contains(preceding-sibling::text()[1],'Provenance:')]/@href,'#')"/>

         <xsl:variable name="users"             select="//html:div[contains(normalize-space(.),'Used by:')]/../following-sibling::html:div[1]/html:div"/>

         <xsl:for-each select="$users">
            <xsl:variable name="submitter"  select="normalize-space(html:div/html:a)"/>
            <xsl:variable name="entry-link" select="html:div/html:a/@href"/>
            <xsl:variable name="award"      select="normalize-space(html:div/html:b[.='Award:']/following-sibling::text()[1])"/>
            <xsl:value-of select="concat($DQ,string-join((
                                                          $group-id,$title,concat($description,' ',$description-links),
                                                          if (starts-with($dataset-link, 'http')) then  $dataset-link else concat($url-base,$dataset-link),
                                                          if (starts-with($solution-link,'http')) then $solution-link else concat($url-base,$solution-link),
                                                          $submitter,
                                                          if (starts-with($entry-link,'http')) then $entry-link else concat($url-base,$entry-link),
                                                          $award
                                                         ),
                                                         concat($DQ,',',$DQ)),$DQ,$NL)"/>
         </xsl:for-each>
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

<xsl:function name="html:anchor-hrefs">
   <xsl:param name="anchors"/>
   <xsl:param name="base"/>

   <xsl:variable name="together">
      <xsl:for-each select="$anchors">
         <xsl:if test="position() gt 1">
            <xsl:value-of select="'||'"/>
         </xsl:if>
         <xsl:value-of select="concat($base,normalize-space(@href))"/>
      </xsl:for-each>
   </xsl:variable>

   <xsl:value-of select="normalize-space($together)"/>
</xsl:function>

</xsl:transform>

<xsl:transform version="2.0" 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:sr="http://www.w3.org/2005/sparql-results#"
   exclude-result-prefixes="">
<xsl:output method="text"/>

<!-- http://stackoverflow.com/questions/1384802/java-how-to-indent-xml-generated-by-transformer -->

<!--xsl:variable name="prefixes"><![CDATA[@prefix mc2:    <http://ieeevis.tw.rpi.edu/source/hcil-cs-umd-edu/dataset/IEEE-VAST-Challenge-2008-mc2/vocab/> .
@prefix user:   <http://ieeevis.tw.rpi.edu/source/hcil-cs-umd-edu/dataset/IEEE-VAST-Challenge-2008-mc2/version/2008-Mar-15/user/> .
@prefix social: <http://ieeevis.tw.rpi.edu/source/ieeevis-tw-rpi-edu/dataset/IEEE-VAST-Challenge-2008-mc2-reverts-social/vocab/> .
]]>
</xsl:variable-->

<xsl:variable name="prefixes"><![CDATA[@prefix mc1:    <http://ieeevis.tw.rpi.edu/source/hcil-cs-umd-edu/dataset/IEEE-VAST-Challenge-2008-mc1/vocab/> .
@prefix user:   <http://ieeevis.tw.rpi.edu/source/hcil-cs-umd-edu/dataset/IEEE-VAST-Challenge-2008-mc1/version/2008-Mar-15/user/> .
@prefix social: <http://ieeevis.tw.rpi.edu/source/ieeevis-tw-rpi-edu/dataset/IEEE-VAST-Challenge-2008-mc1-reverts-social/vocab/> .
]]>
</xsl:variable>

<xsl:template match="/">
   <xsl:value-of select="$prefixes"/>
   <xsl:for-each select="sr:sparql/sr:results/sr:result">
      <xsl:variable name="commit"  select="sr:binding[@name='commit']"/>
      <xsl:variable name="against" select="sr:binding[@name='against']"/>
      <xsl:variable name="comment" select="sr:binding[@name='comment']"/>

      <xsl:variable name="comment-1" select="substring-after($comment,'by ')"/>
      <xsl:variable name="comment-2" select="substring-after($comment-1,'by ')"/>

      <!-- Incorrectly trimmed e.g. user '209.250.162.x' to user '209'.
       xsl:variable name="first-by"  select="tokenize(replace($comment-1,'Special:Contributions/',''),'\.|,| ')[1]"/>
      <xsl:variable name="second-by" select="tokenize(replace($comment-2,'Special:Contributions/',''),'\.|,| ')[1]"/-->

      <xsl:variable name="first-by"  select="sr:user(tokenize($comment-1,' ')[1])"/>
      <xsl:variable name="second-by" select="sr:user(tokenize($comment-2,' ')[1])"/>

      <xsl:value-of select="concat($LT,$commit,$GT,$NL)"/>
      <xsl:if test="string-length($against)">
         <xsl:value-of select="concat('   social:against  ',$LT,$against,$GT,';',$NL)"/>
      </xsl:if>
      <xsl:value-of select="concat('   # ',$comment,$NL)"/>
      <xsl:value-of select="concat('   # by 1: ',$comment-1,'|',$NL)"/>
      <xsl:value-of select="concat('   # by 2: ',$comment-2,'|',$NL)"/>
      <xsl:value-of select="concat('   # first  by: ',$first-by,'|',$NL)"/>
      <xsl:value-of select="concat('   # second by: ',$second-by,'|',$NL)"/>
      <xsl:choose>
         <xsl:when test="matches($comment,'Undid revision') and string-length($first-by)">
            <xsl:value-of select="concat('   social:against user:',sr:uriify($first-by),' . # b/c undid',$NL)"/>
         </xsl:when>
         <xsl:when test="string-length($first-by) and string-length($second-by)">
            <xsl:value-of select="concat('   social:against  user:',sr:uriify($first-by),';   # b/c both',$NL)"/>
            <xsl:value-of select="concat('   social:supports user:',sr:uriify($second-by),' . # b/c both',$NL)"/>
         </xsl:when>
         <xsl:when test="string-length($first-by)">
            <xsl:value-of select="concat('   # just first exists;',$NL)"/>
            <xsl:choose>
               <xsl:when test="matches(lower-case($comment),'revert.* edit.* by ') or 
                               matches(lower-case($comment),'revert.* vandalism.* by ')">
                  <xsl:value-of select="concat('   social:against  user:',sr:uriify($first-by),' . # b/c revert (edit|vandalism) by',$NL)"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="concat('   social:supports  user:',sr:uriify($first-by),' . # b/c not(revert (edit|vandalism) by',$NL)"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="concat('   a mc1:Commit .  # b/c neither',$NL)"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="concat($NL,$NL)"/>
   </xsl:for-each>
</xsl:template>

<xsl:function name="sr:user">
   <xsl:param name="comment"/>
   <xsl:value-of select="replace(replace(tokenize($comment,' ')[1],
                                         'Special:Contributions/',''),
                                 '\.$|,|;','')"/>
</xsl:function>

<xsl:function name="sr:uriify">
   <xsl:param name="string"/>
   <xsl:value-of select="replace(replace(replace($string,'\.','_'),' ','_'),$SQ,'')"/>
</xsl:function>

<xsl:variable name="NL" select="'&#xa;'"/>
<xsl:variable name="DQ" select="'&#x22;'"/>
<xsl:variable name="LT" select="'&lt;'"/>
<xsl:variable name="GT" select="'&gt;'"/>
<xsl:variable name="SQ">'</xsl:variable>

</xsl:transform>

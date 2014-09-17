<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="@*|node()">
    <xsl:choose>
      <xsl:when test="contains(@langue,'en')">
      </xsl:when>

      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

   <xsl:template match="tablewithoutRuling">
    <xsl:variable name="lang" select="preceding-sibling::*[1][@langue='fr' or @langue='en' or @langue='fr-ca' or @langue ='en-ca']/@langue"/>
    <xsl:choose>
      <xsl:when test="contains($lang,'en')">
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>

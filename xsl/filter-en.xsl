<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="@*|node()">
		<xsl:choose>
			<xsl:when test="contains(@langue,'fr')">
			</xsl:when>

			<xsl:otherwise>
				<xsl:copy>
      		<xsl:apply-templates select="@*|node()"/>
    		</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
  </xsl:template>

</xsl:stylesheet>
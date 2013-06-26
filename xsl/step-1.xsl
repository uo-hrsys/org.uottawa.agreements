<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
  exclude-result-prefixes="xs ditaarch" version="2.0"
>

  <!--
    
    This first step perform some element conversion in order to make to DITA conversion easier
    
  -->

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="sub-article">
    <section>
      <xsl:apply-templates select="@*|node()"/>
    </section>
  </xsl:template>


  <xsl:template match="title">
  
    <xsl:choose>
      <xsl:when test="parent::article">
        <title>
          <xsl:apply-templates select="@*|node()"/>
        </title>
      </xsl:when>
      <xsl:otherwise>    
        <paragraph-numbered>
          <xsl:apply-templates select="@*|node()"/>
        </paragraph-numbered>
      </xsl:otherwise>
    </xsl:choose>  
    
  </xsl:template>

</xsl:stylesheet>

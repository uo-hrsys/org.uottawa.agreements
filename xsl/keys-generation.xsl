<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:str="http://www.metaphoricalweb.org/xmlns/string-utilities"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ditaarch = "http://dita.oasis-open.org/architecture/2005/"
  exclude-result-prefixes="str fn xsl xs"
  version="2.0">

  <xsl:output
    use-character-maps="cm1"
    method="xml"
    indent="yes"
    doctype-public="-//OASIS//DTD DITA Map//EN"
    doctype-system="TechnicalContent/dtd/map.dtd"
    standalone="true"
  />

  <xsl:character-map name="cm1">
    <xsl:output-character character="&#160;" string="&amp;nbsp;"/>
  </xsl:character-map>

  <xsl:template match="agreement">
	  <map>
		  <title>Keys for collective agreement</title>
      	<xsl:apply-templates select="//concept"/>
	  </map>
  </xsl:template>

  <xsl:template match="//concept">
	  <keydef>
		  <xsl:attribute name="keys">ca-<xsl:value-of select="@id"/></xsl:attribute>
		  <xsl:attribute name="href">articles/<xsl:value-of select="@id"/>.xml</xsl:attribute>
		  <xsl:attribute name="type">concept</xsl:attribute>
	  </keydef>
  </xsl:template>

</xsl:stylesheet>

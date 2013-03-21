<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/" exclude-result-prefixes="xs ditaarch" version="2.0">


	<xsl:output name="dita-concept" method="xml" doctype-public="-//OASIS//DTD DITA Concept//EN"
		doctype-system="technicalContent/dtd/concept.dtd"/>

	<xsl:output name="dita-ditamap" method="xml" doctype-public="-//OASIS//DTD DITA Map//EN"
		doctype-system="technicalContent/dtd/map.dtd"/>
	
	<xsl:include href="cc2dita_main_keys.xsl"/>

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>


	<xsl:template match="agreement">
		
		<xsl:for-each select="article">

		<xsl:message>
			<xsl:value-of select="@id"/>
		</xsl:message>
		<xsl:result-document format="dita-concept" href="{@id}.dita">
			<concept id="{@id}">
				<title>
					<xsl:value-of select="title"/>
				</title>
				<shortdesc/>
				<conbody>
					<xsl:apply-templates select="@*|node()"/>
				</conbody>
			</concept>

		</xsl:result-document>
		
		
		</xsl:for-each>
	
		<xsl:apply-templates mode="generate-main-keys" select="/"/>
		<xsl:apply-templates mode="generate-main-map" select="/"/>
		
	
	
	</xsl:template>

	<xsl:template match="title"/>

	<xsl:template match="section">

		<xsl:variable name="count" select="count(ancestor::section)"/>

		<xsl:choose>
			<xsl:when test="$count = 0">
				<section>
					<xsl:apply-templates select="@*|node()"/>
				</section>
			</xsl:when>
			<xsl:otherwise>
				<sectiondiv>
					<xsl:apply-templates select="@*|node()"/>
				</sectiondiv>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  	xmlns:xs="http://www.w3.org/2001/XMLSchema"
  	xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
	exclude-result-prefixes="xs ditaarch"
  	version="2.0"
>


    
  <xsl:template  mode="generate-main-keys" match="*">
  	<xsl:message>gene main keys</xsl:message>
  	
  	<xsl:variable name="list">
  		<xsl:apply-templates select="article" mode="article-keys" />  	
  	</xsl:variable>
  	

  	<xsl:variable name="title"><xsl:value-of select="title"/></xsl:variable>
  	
  		
  		<xsl:result-document format="dita-ditamap" href="keys.ditamap">
			<map>
				<title/>
				<xsl:sequence select="$list" />	
			</map>

		</xsl:result-document>
  
  </xsl:template>
  
   <xsl:template  mode="article-keys" match="article">
  		<xsl:param name="count" as="xs:integer" tunnel="yes"><xsl:number count="*"/></xsl:param>
  		<xsl:variable name="title"><xsl:value-of select="title"/></xsl:variable>
  	
		<keydef keys="{@id}" href="{concat(@id, '.dita' )}" type="concept"/>
  
  </xsl:template>
  
  <xsl:template  mode="generate-main-map" match="*">
  	<xsl:message>gene main keys</xsl:message>
  	
  	<xsl:variable name="list">
  		<mapref href="keys.ditamap" />
  		<xsl:apply-templates select="article" mode="article-topicref" />  	
  	</xsl:variable>
  	

  	<xsl:variable name="title"><xsl:value-of select="title"/></xsl:variable>
  	
  		
  		<xsl:result-document format="dita-ditamap" href="main.ditamap">
			<map outputclass="design-20">
				<title/>
				<xsl:sequence select="$list" />	
			</map>

		</xsl:result-document>
  
  </xsl:template>
  
   <xsl:template  mode="article-topicref" match="article">
  		<xsl:param name="count" as="xs:integer" tunnel="yes"><xsl:number count="*"/></xsl:param>
  		<xsl:variable name="title"><xsl:value-of select="title"/></xsl:variable>
  	
		<topicref keyref="{@id}" />
  
  </xsl:template>
  

  
  
  
</xsl:stylesheet>
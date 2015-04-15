<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
  exclude-result-prefixes="xs ditaarch"
  version="2.0"
>

  <xsl:template  mode="generate-content" match="article">
    <xsl:param name="count" as="xs:integer" tunnel="yes"><xsl:number count="*"/></xsl:param>

    <xsl:variable name="title"><xsl:value-of select="title"/></xsl:variable>
    <xsl:variable name="content">
      <xsl:apply-templates mode="generate-content"  select="*">
        <xsl:with-param name="count" tunnel="yes" select="$count" />
      </xsl:apply-templates>
    </xsl:variable>

    <xsl:message><xsl:value-of select="$content" /></xsl:message>

    <xsl:result-document format="dita-concept" href="{@id}.dita">
      <concept>
        <title/>
        <xsl:sequence select="content"/>
      </concept>
    </xsl:result-document>
  </xsl:template>

  <xsl:template  mode="generate-content" match="section">
    <xsl:param name="count" as="xs:integer" tunnel="yes" select="0" />
    <xsl:variable name="title">
      <xsl:choose>
        <xsl:when test="title != ''">
          <xsl:value-of select="title"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="''"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

   <xsl:for-each select="*">
     <xsl:message><xsl:value-of select="name(.)"/></xsl:message>
   </xsl:for-each>
  </xsl:template>

  <xsl:template  mode="generate-content" match="title" />
  <xsl:template  mode="generate-content" match="paragraph-numbered">

    <xsl:param name="count" as="xs:integer" tunnel="yes" select="0" />
    <xsl:message>match pn</xsl:message>

    <xsl:variable name="ref"><xsl:value-of select="count(ancestor::article/preceding-sibling::article) + 1 " />-<xsl:number count="sub-article | section" from="article" grouping-separator="-" />-<xsl:number count="paragraph-numbered|title" grouping-separator="-" level="single" from="section|sub-article" /></xsl:variable>
    <p>
      <xsl:attribute name="id">ca-art-<xsl:value-of select="$ref" /></xsl:attribute>

      <xsl:call-template name="addNumbering">
        <xsl:with-param name="num"><xsl:value-of select="count(ancestor::article/preceding-sibling::article) + 1 " />.<xsl:number count="sub-article | section" from="article" grouping-separator="." />.<xsl:number count="paragraph-numbered|title" grouping-separator="." level="single" from="section|sub-article" /></xsl:with-param>
      </xsl:call-template>

      <xsl:apply-templates select="@*|node()" />
    </p>
  </xsl:template>

  <xsl:template  mode="generate-content" match="paragraph">
    <p>
      <xsl:apply-templates select="@*|node()" />
    </p>
  </xsl:template>

  <xsl:template name="addNumbering">
    <xsl:param name="num" />
    <ph outputclass="num"><xsl:value-of select="$num" /></ph>
  </xsl:template>

</xsl:stylesheet>

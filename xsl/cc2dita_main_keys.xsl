<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
  exclude-result-prefixes="xs ditaarch"
  version="2.0"
>

  <xsl:template mode="generate-main-keys" match="*">
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
      <xsl:apply-templates select="article" mode="article-topicref">
        <xsl:with-param name="toc" as="xs:boolean" select="true()" tunnel="yes"/>
      </xsl:apply-templates>
    </xsl:variable>

    <xsl:variable name="title"><xsl:value-of select="title"/></xsl:variable>

    <xsl:result-document format="dita-ditamap" href="main.ditamap">
      <map outputclass="design-20">
        <title/>
        <xsl:sequence select="$list" />
      </map>
    </xsl:result-document>

  </xsl:template>

  <xsl:template  mode="generate-main-map-toc-no" match="*">
    <xsl:message>gene main keys</xsl:message>

    <xsl:variable name="list">
      <mapref href="keys.ditamap" />
      <xsl:apply-templates select="article" mode="article-topicref">
        <xsl:with-param name="toc" as="xs:boolean" select="false()" tunnel="yes"/>
      </xsl:apply-templates>
    </xsl:variable>

    <xsl:variable name="title"><xsl:value-of select="title"/></xsl:variable>

    <xsl:result-document format="dita-ditamap" href="main-no-toc.ditamap">
      <map outputclass="design-20">
        <title/>
        <xsl:sequence select="$list" />
      </map>
    </xsl:result-document>

  </xsl:template>

  <xsl:template  mode="generate-main-concept" match="*">
    <xsl:message>gene main keys</xsl:message>

    <xsl:variable name="list">
      <xsl:apply-templates select="article" mode="xref-from-keys" />
    </xsl:variable>

    <xsl:variable name="title"><xsl:value-of select="title"/></xsl:variable>

    <xsl:result-document format="dita-concept" href="whole-concept.dita">
      <concept id="{generate-id(.)}" outputclass="col-md-6">
        <title/>
        <conbody>
          <ul>
            <xsl:sequence select="$list" />
          </ul>
        </conbody>
      </concept>
    </xsl:result-document>

  </xsl:template>

   <xsl:template  mode="article-topicref" match="article">
      <xsl:param name="toc" as="xs:boolean" select="false()" tunnel="yes"/>
      <xsl:param name="count" as="xs:integer" tunnel="yes"><xsl:number count="*"/></xsl:param>
      <xsl:variable name="title"><xsl:value-of select="title"/></xsl:variable>
      <topicref keyref="{@id}">
        <xsl:if test="not($toc)">
          <xsl:attribute name="toc" select="'no'"/>
        </xsl:if>
      </topicref>
    </xsl:template>

    <xsl:template  mode="xref-from-keys" match="article">
      <xsl:param name="count" as="xs:integer" tunnel="yes"><xsl:number count="*"/></xsl:param>
      <li><xref keyref="{@id}" /></li>
   </xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
  exclude-result-prefixes="#all"
  version="2.0">

  <xsl:output
    name="dita-concept"
    method="xml"
    doctype-public="-//OASIS//DTD DITA Concept//EN"
    doctype-system="technicalContent/dtd/concept.dtd"
    indent="yes"
  />

  <xsl:output
    name="dita-ditamap"
    method="xml"
    doctype-public="-//OASIS//DTD DITA Map//EN"
    doctype-system="technicalContent/dtd/map.dtd"
    indent="yes"/>

  <xsl:include href="cc2dita_main_keys.xsl"/>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="agreement">

    <xsl:for-each select="article">
      <xsl:message>
        Processing articles <xsl:value-of select="@id"/>
      </xsl:message>
      <xsl:result-document format="dita-concept" href="{@id}.dita">
        <concept id="{@id}">
          <title>
            <xsl:value-of select="title"/>
          </title>
          <shortdesc/>
          <conbody>
            <xsl:apply-templates select="@*[name()!='id']|node()"/>
          </conbody>
        </concept>
      </xsl:result-document>
    </xsl:for-each>

    <xsl:for-each select="letter">
      <xsl:variable name="num">
        <xsl:number value="position()" format="1" />
      </xsl:variable>
      <xsl:message>
        Processing letters <xsl:value-of select="string($num)"/>
      </xsl:message>
      <xsl:result-document format="dita-concept" href="letter-{string($num)}.dita">
        <concept id="letter-{$num}">
            <xsl:choose>
              <xsl:when test="title[0]">
                <xsl:sequence select="title[0]" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:sequence select="title[1]" />
              </xsl:otherwise>
            </xsl:choose>
          <shortdesc/>
          <conbody>
            <xsl:apply-templates select="@*[name()!='id']|node()"/>
          </conbody>
        </concept>
      </xsl:result-document>
    </xsl:for-each>


    <xsl:for-each select="other-letters">
      <xsl:variable name="num">
        <xsl:number value="position()" format="1" />
      </xsl:variable>
      <xsl:message>
        Processing other-letters <xsl:value-of select="string($num)"/>
      </xsl:message>
      <xsl:result-document format="dita-concept" href="other-letters-{string($num)}.dita">
        <concept id="other-letters-{$num}">
            <xsl:choose>
              <xsl:when test="title[0]">
                <xsl:sequence select="title[0]" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:sequence select="title[1]" />
              </xsl:otherwise>
            </xsl:choose>
          <shortdesc/>
          <conbody>
            <xsl:apply-templates select="@*[name()!='id']|node()"/>
          </conbody>
        </concept>
      </xsl:result-document>
    </xsl:for-each>


    <xsl:apply-templates mode="generate-main-keys" select="/"/>
    <xsl:apply-templates mode="generate-main-map" select="/"/>
    <xsl:apply-templates mode="generate-main-map-toc-no" select="/"/>
    <xsl:apply-templates mode="generate-main-concept" select="/"/>

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

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
  exclude-result-prefixes="xs ditaarch"
  version="2.0"
>

<xsl:param name="lang"/>

  <xsl:template mode="generate-main-keys" match="*">
    <xsl:message>gene main keys</xsl:message>

    <xsl:variable name="list">
      <xsl:apply-templates select="article" mode="article-keys" />
      <xsl:apply-templates select="letter" mode="letter-keys" />
      <xsl:apply-templates select="other-letters" mode="other-letters-keys" />
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

  <xsl:template  mode="letter-keys" match="letter">
      <xsl:param name="count" as="xs:integer" tunnel="yes"><xsl:number count="*"/></xsl:param>
      <xsl:variable name="title"><xsl:value-of select="title"/></xsl:variable>
      <keydef keys="{@id}" href="{concat(@id, '.dita' )}" type="concept"/>
  </xsl:template>

  <xsl:template  mode="other-letters-keys" match="other-letters">
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
      <xsl:apply-templates select="letter" mode="letter-topicref">
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
      <xsl:apply-templates select="letter" mode="letter-topicref">
        <xsl:with-param name="toc" as="xs:boolean" select="false()" tunnel="yes"/>
      </xsl:apply-templates>
       <xsl:apply-templates select="other-letters" mode="other-letters-topicref">
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

    <xsl:variable name="list-article">
      <xsl:apply-templates select="article" mode="xref-from-keys" />
    </xsl:variable>

    <xsl:variable name="list-letter">
      <xsl:apply-templates select="letter" mode="xref-from-keys" />
    </xsl:variable>

    <xsl:variable name="list-other-letters">
      <xsl:apply-templates select="other-letters" mode="xref-from-keys" />
    </xsl:variable>

    <xsl:variable name="title"><xsl:value-of select="title"/></xsl:variable>

    <xsl:result-document format="dita-concept" href="whole-concept.dita">
      <concept id="{generate-id(.)}" outputclass="col-md-6">
        <title/>
        <conbody>
          <section>
            <title>Articles</title>
              <ul>
                <xsl:sequence select="$list-article" />
             </ul>
          </section>

          <xsl:if test="count($list-letter/*) &gt; 0">
            <section>
              <xsl:choose>
                <xsl:when test="$lang = 'fr'">
                   <title>Lettres d'entente</title>
                </xsl:when>
                <xsl:otherwise>
                   <title>Letters of agreement</title>
                </xsl:otherwise>
              </xsl:choose>
                <ul>
                  <xsl:sequence select="$list-letter" />
               </ul>
            </section>
          </xsl:if>

          <xsl:if test="count($list-other-letters/*) &gt; 0">
            <section>
              <xsl:choose>
                <xsl:when test="$lang = 'fr'">
                   <title>Autres lettres d’entente</title>
                </xsl:when>
                <xsl:otherwise>
                   <title>Other Letters of Agreement</title>
                </xsl:otherwise>
              </xsl:choose>
                <ul>
                  <xsl:sequence select="$list-other-letters" />
               </ul>
            </section>
          </xsl:if>
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

   <xsl:template  mode="letter-topicref" match="letter">
      <xsl:param name="toc" as="xs:boolean" select="false()" tunnel="yes"/>
      <xsl:param name="count" as="xs:integer" tunnel="yes"><xsl:number count="*"/></xsl:param>
      <xsl:variable name="title"><xsl:value-of select="title"/></xsl:variable>
      <topicref keyref="{@id}">
        <xsl:if test="not($toc)">
          <xsl:attribute name="toc" select="'no'"/>
        </xsl:if>
      </topicref>
    </xsl:template>

    <xsl:template  mode="other-letters-topicref" match="other-letters">
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

   <xsl:template  mode="xref-from-keys" match="letter">
      <xsl:param name="count" as="xs:integer" tunnel="yes"><xsl:number count="*"/></xsl:param>
      <li><xref keyref="{@id}" /></li>
   </xsl:template>

    <xsl:template  mode="xref-from-keys" match="other-letters">
      <xsl:param name="count" as="xs:integer" tunnel="yes"><xsl:number count="*"/></xsl:param>
      <li><xref keyref="{@id}" /></li>
   </xsl:template>

</xsl:stylesheet>

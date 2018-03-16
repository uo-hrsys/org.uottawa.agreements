<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
  exclude-result-prefixes="xs ditaarch" version="2.0"
>
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="leaveBlank" match="leaveBlank" />

  <xsl:template name="pn" match="paragraph-numbered">

  <xsl:variable name="article-level">
    <xsl:value-of select="count(ancestor::article/preceding-sibling::article) + 1 "/>
  </xsl:variable>

  <xsl:variable name="section-level">
    <xsl:value-of select="count(ancestor::section) + 1 "/>
  </xsl:variable>

  <xsl:variable name="ref">

    <xsl:choose>

      <xsl:when test="$section-level=2">
        <xsl:value-of select="$article-level"/>.<xsl:value-of select="count(parent::section/preceding-sibling::section|preceding-sibling::paragraph-numbered) + 1 " />
      </xsl:when>

      <xsl:when test="$section-level=3">
        <xsl:value-of select="$article-level"/>.<xsl:value-of select="count(parent::section/parent::section/preceding-sibling::section|parent::section/preceding-sibling::paragraph-numbered)"/>.<xsl:value-of select="count(preceding-sibling::paragraph-numbered) + 1"/>
      </xsl:when>

      <xsl:when test="$section-level=4">
        <xsl:value-of select="$article-level"/>.<xsl:value-of select="count(parent::section/parent::section/parent::section/preceding-sibling::section|parent::section/parent::section/preceding-sibling::paragraph-numbered)" />.<xsl:value-of select="count(parent::section/parent::section/preceding-sibling::section|parent::section/preceding-sibling::paragraph-numbered)" />.<xsl:value-of select="count(preceding-sibling::paragraph-numbered) + 1 "/>
      </xsl:when>

      <xsl:when test="$section-level=5">
        <xsl:message>
          ! important Level 5 reached, this level has never been tested because no use case
        </xsl:message>

        <xsl:value-of select="$article-level"/>.<xsl:value-of select="count(parent::section/parent::section/parent::section/parent::section/preceding-sibling::section|parent::section/parent::section/parent::section/preceding-sibling::paragraph-numbered)" />.<xsl:value-of select="count(parent::section/parent::section/parent::section/preceding-sibling::section|parent::section/parent::section/preceding-sibling::paragraph-numbered)" />.<xsl:value-of select="count(parent::section/parent::section/preceding-sibling::section|parent::section/preceding-sibling::paragraph-numbered)" />.<xsl:value-of select="count(preceding-sibling::paragraph-numbered) + 1 "/>

      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="id" select="replace($ref, '\.', '-')"/>
    <p>
      <ph outputclass="num">
        <xsl:value-of select="$ref"/>
      </ph><xsl:value-of select="'&#160;'"/>
      <xsl:apply-templates select="@*|node()"/>
    </p>
  </xsl:template>

  <xsl:template match="article">

    <xsl:param name="count" tunnel="yes">
      <xsl:number count="article"/>
    </xsl:param>

    <article id="{concat('article-', $count)}">
      <xsl:apply-templates select="@*|node()">
        <xsl:with-param name="article-level" select="$count"/>
      </xsl:apply-templates>
    </article>
  </xsl:template>

  <xsl:template match="letter">

    <xsl:param name="count" tunnel="yes">
      <xsl:number count="letter"/>
    </xsl:param>

    <letter id="{concat('letter-', $count)}">
      <xsl:apply-templates select="@*|node()">
        <xsl:with-param name="article-level" select="$count"/>
      </xsl:apply-templates>
    </letter>
  </xsl:template>

  <xsl:template match="other-letters">

    <xsl:param name="count" tunnel="yes">
      <xsl:number count="other-letters"/>
    </xsl:param>

    <other-letters id="{concat('other-letters-', $count)}">
      <xsl:apply-templates select="@*|node()">
        <xsl:with-param name="article-level" select="$count"/>
      </xsl:apply-templates>
    </other-letters>
  </xsl:template>

  <xsl:template match="title">
    <xsl:variable name="count">
      <xsl:number count="article"/>
    </xsl:variable>
    <title> Article <xsl:value-of select="$count"/> : <xsl:apply-templates select="node()"/>
    </title>
  </xsl:template>

  <xsl:template match="title-prefix">
    <title>
     <!--ph outputclass="lb"><xsl:apply-templates select="node()"/></ph-->
     <ph outputclass="lb"><xsl:value-of select="following-sibling::*[1]"/></ph>
    </title>
  </xsl:template>

  <xsl:template match="letter/paragraph-numbered">
    <title>
      <ph outputclass="lb"><xsl:apply-templates select="node()"/></ph>
    </title>
  </xsl:template>

  <xsl:template match="sub-letter">
    <xsl:apply-templates select="node()"/>
  </xsl:template>

  <xsl:template match="title-no-number">
    <p><b><xsl:value-of select="."/></b></p>
  </xsl:template>

  <xsl:template match="title/text()">
    <xsl:value-of select="lower-case(.)"/>
  </xsl:template>

  <xsl:template match="paragraph">
    <xsl:choose>
      <xsl:when test="name(ancestor::*[1]) = 'list'">
        <li outputclass="p"><p><xsl:apply-templates select="@*|node()"/></p></li>
      </xsl:when>

      <xsl:otherwise>
        <p><xsl:apply-templates select="@*|node()"/></p>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template match="@prefixLineOnly"> </xsl:template>
  <xsl:template match="@prefixMark"> </xsl:template>

  <xsl:template match="table|tablewithoutRuling">

    <xsl:choose>
      <xsl:when test="name(ancestor::*[1]) = 'list'">
        <li>
          <table outputclass="{name(.)}">
            <xsl:element name="tgroup">
              <xsl:attribute name="cols">
                <xsl:value-of select="count(TableHeading/TableRow/TableCell)"/>
              </xsl:attribute>
              <xsl:apply-templates select="@*|node()"/>
            </xsl:element>
          </table>
        </li>
      </xsl:when>
      <xsl:otherwise>
        <table outputclass="{name(.)}">
          <xsl:element name="tgroup">
            <xsl:attribute name="cols">
              <xsl:value-of select="count(TableHeading/TableRow/TableCell)"/>
            </xsl:attribute>
            <xsl:apply-templates select="@*|node()"/>
          </xsl:element>
        </table>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="TableHeading">
    <xsl:element name="thead">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="TableBody">
    <xsl:element name="tbody">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="TableRow">
    <xsl:element name="row">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="TableCell">
    <xsl:element name="entry">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>

  <!--
    Process list
    possible choices are: Alpha, Alpha-uppercase, Numeric, Dash, Roman, Bullet
  -->

  <xsl:template match="list/@Type" />

  <xsl:template match="list">

  <xsl:if test="count(node())" >

    <xsl:variable name="element">
      <xsl:choose>
        <xsl:when test="contains(@Type, 'alpha') or contains(@Type, 'numeric')">
          <xsl:value-of select="'ol'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'ul'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- prevent list nested in an item to be processed -->
    <xsl:element name="{$element}">
      <xsl:attribute name="outputclass">
        <xsl:value-of select="@Type"/>
      </xsl:attribute>

       <xsl:if test="name(*[1]) = 'list'">
         <li>
           <xsl:apply-templates select="*[1]"/>
         </li>
       </xsl:if>

      <xsl:apply-templates select="@*|node()[not(name(.) = 'list')]"/>
    </xsl:element>

    </xsl:if>
  </xsl:template>

  <!-- process item, move following list sibling into the previous parent item -->
  <xsl:template match="item">
    <li>
       <xsl:apply-templates select="@*|node()"/>
       <xsl:if test="name(following-sibling::*[1]) = 'list'">
         <xsl:apply-templates select="following-sibling::*[1]"/>
       </xsl:if>
    </li>
  </xsl:template>

  <!-- process appendix -->
  <!-- to be implemented -->
  <xsl:template match="appendix"> </xsl:template>

  <!-- process signature -->
  <!-- to be implemented -->
  <xsl:template match="signature"> </xsl:template>

  <xsl:template match="strong">
    <b>
      <xsl:apply-templates select="@*|node()"/>
    </b>
  </xsl:template>

  <xsl:template match="emphasis">
    <i>
      <xsl:apply-templates select="@*|node()"/>
    </i>
  </xsl:template>

  <!--xsl:template match="*[@prefixMark]">
    <xsl:if test="@prefixMark='y'"> * </xsl:if>
  </xsl:template-->

  <xsl:template name="addNumbering">
    <xsl:param name="num"/>
    <ph outputclass="num"><xsl:value-of select="$num"/><xsl:value-of select="'&#160;'"/></ph>
  </xsl:template>

</xsl:stylesheet>

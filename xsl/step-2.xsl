<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/" exclude-result-prefixes="xs ditaarch" version="2.0">

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

	<!--xsl:template match="section | sub-article">

		<xsl:for-each-group select="*"
			group-adjacent="
				boolean(self::paragraph) or 
				boolean(self::paragraph-numbered) or 
				boolean(self::list)">

			<xsl:choose>
				<xsl:when test="name(current-group()[1])='section'">
					<section>
						<xsl:apply-templates select="current-group()"/>
					</section>
				</xsl:when>
				<xsl:otherwise>
					<sectiondiv>
						<xsl:apply-templates select="current-group()"/>
					</sectiondiv>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each-group>


	</xsl:template-->
	
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
					<xsl:value-of select="$article-level"/>.<xsl:value-of
						select="count(parent::section/preceding-sibling::section|preceding-sibling::paragraph-numbered) + 1 "
					/>
				</xsl:when>
				<xsl:when test="$section-level=3">
					<xsl:value-of select="$article-level"/>.<xsl:value-of
						select="count(parent::section/parent::section/preceding-sibling::section) + 1 "/>.<xsl:value-of
							select="count(preceding-sibling::paragraph-numbered|parent::section/preceding-sibling::section[1]/paragraph-numbered) + 1 "/>
				</xsl:when>
				<xsl:when test="$section-level=4">
					<xsl:value-of select="$article-level"/>.<xsl:value-of
						select="count(parent::section/parent::section/parent::section/preceding-sibling::section) + 1 "
						/>.<xsl:value-of select="count(parent::section/preceding-sibling::paragraph-numbered)"
						/>.<xsl:value-of select="count(preceding-sibling::paragraph-numbered) + 1 "/>
				</xsl:when>
				<xsl:when test="$section-level=5">
					<xsl:message>Level 5 reached</xsl:message>
					<xsl:value-of select="$article-level"/>.<xsl:value-of
						select="count(parent::section/parent::section/parent::section/parent::section/preceding-sibling::section) + 1 "
						/>.<xsl:value-of
						select="count(parent::section/parent::section/preceding-sibling::paragraph-numbered)"
						/>.<xsl:value-of select="count(parent::section/preceding-sibling::paragraph-numbered) "
						/>.<xsl:value-of select="count(parent::section/preceding-sibling::paragraph-numbered) + 1"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="id" select="replace($ref, '\.', '-')"/>
		
		<p id="id-{replace($id, '\.', '-')}">					
			<ph outputclass="num">
				<xsl:value-of select="$ref"/>
			</ph>
			<xsl:apply-templates select="@*|node()"/>					
		</p>

	</xsl:template>


	<!-- process article -->
	<xsl:template match="article">

		<xsl:param name="count" tunnel="yes">
			<xsl:number count="article"/>
		</xsl:param>
		<article id="{concat('article-', $count)}" outputclass="article">
			<xsl:apply-templates select="@*|node()">
				<xsl:with-param name="article-level" select="$count"/>
			</xsl:apply-templates>
		</article>
	</xsl:template>

	<!-- process article -->
	<xsl:template match="title">

		<xsl:variable name="count">
			<xsl:number count="article"/>
		</xsl:variable>
		<title> ARTICLE <xsl:value-of select="$count"/> : <xsl:apply-templates select="node()"/>
		</title>
	</xsl:template>

<xsl:template match="title/text()">
    <xsl:value-of select="upper-case(.)"/>        
</xsl:template>

	<!-- process paragraph -->
	<xsl:template match="paragraph">
		<xsl:element name="p">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<!-- remove attribute -->
	<xsl:template match="@prefixLineOnly"> </xsl:template>

	<!-- process table -->
	<xsl:template match="table|tablewithoutRuling">
		<table outputclass="{name(.)}">
			<xsl:element name="tgroup">
				<xsl:attribute name="cols">
					<xsl:value-of select="count(TableHeading/TableRow/TableCell)"/>
				</xsl:attribute>
				<xsl:apply-templates select="@*|node()"/>
			</xsl:element>
		</table>
	</xsl:template>

	<!-- process TableHeading -->
	<xsl:template match="TableHeading">
		<xsl:element name="thead">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<!-- process TableBody -->
	<xsl:template match="TableBody">
		<xsl:element name="tbody">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<!-- process TableRow -->
	<xsl:template match="TableRow">
		<xsl:element name="row">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<!-- process TableCell -->
	<xsl:template match="TableCell">
		<xsl:element name="entry">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<!-- process list
		possible choices are: Alpha, Alpha-uppercase, Numeric, Dash, Roman, Bullet
	-->
	<xsl:template match="list">
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
		<xsl:if test="name(preceding-sibling::*[1]) != 'item'">
		<xsl:element name="{$element}">
			<xsl:attribute name="outputclass">
				<xsl:value-of select="@Type"/>
			</xsl:attribute>
			<!-- select those items that differ from any of their predecessors -->
			<xsl:apply-templates select="item[not(@type=preceding-sibling::list)]"/>
		</xsl:element>
		</xsl:if>
	</xsl:template>



	<!-- process appendix -->
	<xsl:template match="appendix"> </xsl:template>

	<!-- process signature -->
	<xsl:template match="signature"> </xsl:template>

	<!-- process item, move following list sibling into the previous parent item -->
	<xsl:template match="item">
		<xsl:element name="li">
			<xsl:apply-templates select="@*|node()"/>
			<xsl:if test="name(following-sibling::*[1]) = 'list'">
			<xsl:message>
			***
			Sequence: <xsl:sequence  select="following-sibling::*[1]"/></xsl:message>
				<ul>
					<xsl:for-each select="following-sibling::list[1]/item">
					<xsl:message>
					
					Item : <xsl:value-of select="."/>
					
					</xsl:message>
						<li>
							<xsl:value-of select="."/>
						</li>
					</xsl:for-each>
				</ul>
			</xsl:if>
		</xsl:element>
	</xsl:template>


	<xsl:template match="//@langue">
		<xsl:apply-templates select="attribute::*[not(name()='langue')]|node()"/>
	</xsl:template>

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

	<xsl:template match="@prefixMark">
		<xsl:if test="@prefixMark='y'"> * </xsl:if>
	</xsl:template>

	<xsl:template name="addNumbering">
		<xsl:param name="num"/>
		<ph outputclass="num">
			<xsl:value-of select="$num"/>
		</ph>
	</xsl:template>




</xsl:stylesheet>

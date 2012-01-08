<?xml version="1.0" encoding="UTF-8" ?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	       version="1.0"
	       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	       xmlns:sfa="http://developer.apple.com/namespaces/sfa" 
	       xmlns:sf="http://developer.apple.com/namespaces/sf"
	       xmlns:sl="http://developer.apple.com/namespaces/sl"
	       xmlns="http://www.daisy.org/z3986/2005/ncx/"
	       xmlns:exsl="http://exslt.org/common"
	       extension-element-prefixes="exsl"
	       exclude-result-prefixes="xsi sfa sf sl">

<xsl:template name="make_main.css" match="/">
	<exsl:document 
	href="{$maindir}/{$basename}.css"
	omit-xml-declaration="yes">
	  <xsl:apply-templates select="//sf:paragraphstyle |
				       //sf:tocstyle |
				       //sf:characterstyle"/>
	</exsl:document>
</xsl:template>

<xsl:key name="classCounter" match="sf:*[@sf:style]" use="@sf:style"/>
<xsl:key name="parentStyles" match="sf:*[@sf:ident]" use="@sf:ident"/>

<xsl:template match="sf:paragraphstyle|sf:tocstyle|sf:characterstyle">
<!--
	<xsl:comment>test</xsl:comment>
	<xsl:comment><xsl:value-of select="count(key('classCounter',@sf:ident))"/></xsl:comment>
	<xsl:comment><xsl:value-of select="count(key('classCounter',@sf:parent-ident))"/></xsl:comment>
	<xsl:comment><xsl:value-of select="count(key('classCounter',@sfa:ID))"/></xsl:comment>
	<xsl:comment><xsl:value-of select="count(key('classCounter',@sf:ident))+count(key('classCounter',@sfa:ID))+count(key('classCounter',@sf:parent-ident))"/></xsl:comment>
	-->

  <xsl:choose>
	
    <xsl:when test="@sf:ident != ''">
		<xsl:variable name="curClassName" select="@sf:ident"/>

		<xsl:variable name="curClassCount" select="count(key('classCounter',$curClassName))"/>
<!--		<xsl:if test='$curClassCount &gt; 0'> -->
/* <xsl:value-of select="@sf:name"/> */<xsl:value-of select="$rc"/>
	<xsl:text>.</xsl:text>
	<xsl:value-of select="@sf:ident"/>


	<xsl:apply-templates select="sf:property-map">
		<xsl:with-param name="className" select='$curClassName' />
	</xsl:apply-templates>
<!--	</xsl:if> -->
    </xsl:when>

    <xsl:when test="@sfa:ID != ''">
		<xsl:variable name="curClassName" select="@sfa:ID"/>
		<xsl:variable name="curClassCount" select="count(key('classCounter',$curClassName))"/>
<!--		<xsl:if test='$curClassCount &gt; 0'> -->
/* <xsl:value-of select="@sf:name"/> */<xsl:value-of select="$rc"/>
	<xsl:text>.</xsl:text>
	<xsl:value-of select="@sfa:ID"/>
	
	<xsl:apply-templates select="sf:property-map">
		<xsl:with-param name="className" select='$curClassName' />
	</xsl:apply-templates>

<!--	</xsl:if> -->
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="sf:property-map">

  <xsl:param name="className" />
	

  <xsl:text> { </xsl:text>
	<xsl:text>margin:0;</xsl:text>
	<xsl:for-each select="key('parentStyles',../@sf:parent-ident)">
			<xsl:variable name="parentIdent" select="@sf:ident"/>
			<xsl:apply-templates select="//sf:*[@sf:ident=$parentIdent]/sf:property-map/sf:*">
				<xsl:with-param name="className" select='$className' />				
			</xsl:apply-templates>
<!--			<xsl:text>.</xsl:text><xsl:value-of select="$parentIdent"/><xsl:text>, </xsl:text> -->
	</xsl:for-each>

  <xsl:apply-templates select="sf:*">
	<xsl:with-param name="className" select='$className' />
  </xsl:apply-templates>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="sf:leftIndent">
  <xsl:if test="sf:decimal-number">
    <xsl:text>margin-left:</xsl:text>
    <xsl:call-template name="pt2wpct">
	<xsl:with-param name="pt" select="sf:decimal-number/@sfa:number"/>
    </xsl:call-template>
    <xsl:text>%; </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="sf:rightIndent">
  <xsl:if test="sf:decimal-number">
    <xsl:text>margin-right:</xsl:text>
    <xsl:call-template name="pt2wpct">
	<xsl:with-param name="pt" select="sf:decimal-number/@sfa:number"/>
    </xsl:call-template>
    <xsl:text>%; </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="sf:listStyle">
  <xsl:if test="sf:liststyle">
    <xsl:text>display: list-item;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="sf:spaceAfter">
  <xsl:if test="sf:decimal-number">
    <xsl:text>margin-bottom:</xsl:text>
    <xsl:call-template name="pt2hpct">
	<xsl:with-param name="pt" select="sf:decimal-number/@sfa:number"/>
    </xsl:call-template>
    <xsl:text>%; </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="sf:spaceBefore">
  <xsl:if test="sf:decimal-number">
    <xsl:text>margin-top:</xsl:text>
    <xsl:call-template name="pt2hpct">
	<xsl:with-param name="pt" select="sf:decimal-number/@sfa:number"/>
    </xsl:call-template>
    <xsl:text>%; </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="sf:capitalization">
  <xsl:if test="sf:number">
    <xsl:text>text-transform: uppercase; </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="sf:pageBreakBefore">
  <xsl:if test="sf:number">
    <xsl:text>page-break-before:always; </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="sf:alignment">
  <xsl:if test="sf:number">
    <xsl:choose>
		<xsl:when test="sf:number/@sfa:number = '1'">
		    <xsl:text>text-align: right; </xsl:text>
		</xsl:when>
		<xsl:when test="sf:number/@sfa:number = '2'">
		    <xsl:text>text-align: center; </xsl:text>
		</xsl:when>
		<xsl:when test="sf:number/@sfa:number = '3'">
		    <xsl:text>text-align: justify; </xsl:text>
		</xsl:when>
		<xsl:otherwise>
		</xsl:otherwise>
	</xsl:choose>
  </xsl:if>
</xsl:template>

<xsl:template match="sf:firstLineIndent">
  <xsl:if test="sf:decimal-number">
    <xsl:text>text-indent:</xsl:text>
    <xsl:call-template name="pt2hpct">
	<xsl:with-param name="pt" select="sf:decimal-number/@sfa:number"/>
    </xsl:call-template>
    <xsl:text>%; </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="sf:fontName">
  <xsl:if test="sf:string">
    <xsl:text>font-family:"</xsl:text>
    <xsl:value-of select="sf:string/@sfa:string"/>
    <xsl:text>"; </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="sf:fontSize">
	  <xsl:param name="className" />
  <xsl:if test="sf:number">


	<xsl:variable name="sortedClasses">
		<fonts>
	<xsl:for-each select="//sf:paragraphstyle">
		<xsl:sort select="count(key('classCounter',@sf:ident))+count(key('classCounter',@sfa:ID))+count(key('classCounter',@sf:parent-ident))" data-type="number" order="descending"/>
		<font>
			<xsl:choose>
				<xsl:when test="@sf:parent-ident != ''">
					<xsl:value-of select="@sf:parent-ident"/>
				</xsl:when>
				<xsl:when test="@sf:ident != ''">
					<xsl:value-of select="@sf:ident"/>
				</xsl:when>				
				<xsl:otherwise>
					<xsl:value-of select="@sfa:ID"/>
				</xsl:otherwise>
			</xsl:choose>
		</font>
	</xsl:for-each>
</fonts>
</xsl:variable>
<xsl:variable name="bodyClass" select="exsl:node-set($sortedClasses)/*/*[1]"/>
<!--<xsl:comment><xsl:value-of select="$bodyClass"/></xsl:comment> -->
<!-- <xsl:variable name="bodyFontSize" select="sf:number/@sfa:number"/> -->
<!--
<xsl:if test="//sf:*[@sf:ident=$bodyClass]//sf:fontSize/sf:number/@sfa:number">
</xsl:if>
-->
<xsl:variable name="bodyFontSize" >
<xsl:choose>
<xsl:when test="//sf:*[@sf:ident=$bodyClass]//sf:fontSize/sf:number/@sfa:number">
	<xsl:value-of select="//sf:*[@sf:ident=$bodyClass]//sf:fontSize/sf:number/@sfa:number"/>
</xsl:when>
<xsl:otherwise>
	12
</xsl:otherwise>
</xsl:choose>
</xsl:variable>

<xsl:variable name="fontSize" select="sf:number/@sfa:number"/>

<xsl:choose>
	<xsl:when test="$className=$bodyClass or $bodyFontSize=$fontSize">
		<!-- body text - default font size -->
		<xsl:text>font-size: </xsl:text>
		<xsl:text>100%; </xsl:text>
	</xsl:when>

	<xsl:otherwise>
		<xsl:text>font-size: </xsl:text>
		<xsl:variable name="curFontSize" select="round((number($fontSize) div number($bodyFontSize)) * 100)"/>
		<xsl:choose>
			<xsl:when test="$curFontSize &gt; 200">
				<xsl:text>200%; </xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$curFontSize"/><xsl:text>%; </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
</xsl:otherwise>
</xsl:choose>

<!--
<xsl:text>font-size: </xsl:text>
<xsl:value-of select="$fontSize"/>
<xsl:text>px; </xsl:text>
-->


<!--
	<xsl:choose>
		<xsl:when test="$fontSize &lt; 9">
		    <xsl:text>xx-small; </xsl:text>			
		</xsl:when>
		<xsl:when test="$fontSize &gt; 8 and $fontSize &lt; 11 ">
		    <xsl:text>x-small; </xsl:text>			
		</xsl:when>
		<xsl:when test="$fontSize &gt; 10 and $fontSize &lt; 13 ">
		    <xsl:text>small; </xsl:text>			
		</xsl:when>
		<xsl:when test="$fontSize &gt; 12 and $fontSize &lt; 19">
		    <xsl:text>medium; </xsl:text>			
		</xsl:when>
		<xsl:when test="$fontSize &gt; 18 and $fontSize &lt; 21">
		    <xsl:text>large; </xsl:text>			
		</xsl:when>
		<xsl:when test="$fontSize &gt; 20 and $fontSize &lt; 25">
		    <xsl:text>x-large; </xsl:text>			
		</xsl:when>
		<xsl:when test="$fontSize &gt; 24">
		    <xsl:text>xx-large; </xsl:text>			
		</xsl:when>
		<xsl:otherwise>
		    <xsl:value-of select="$fontSize"/>
		    <xsl:text>px; </xsl:text>
		</xsl:otherwise>
	</xsl:choose>
	-->
    
  </xsl:if>
</xsl:template>

<xsl:template match="sf:fontColor">
  <xsl:apply-templates select="sf:color"/>
</xsl:template>

<xsl:template match="sf:color[@xsi:type='sfa:calibrated-rgb-color-type']">
  <xsl:text>color: rgb(</xsl:text>
  <xsl:value-of select="floor(255 * @sfa:r)"/>
  <xsl:text>, </xsl:text>
  <xsl:value-of select="floor(255 * @sfa:g)"/>
  <xsl:text>, </xsl:text>
  <xsl:value-of select="floor(255 * @sfa:b)"/>
  <xsl:text>); </xsl:text>    
</xsl:template>

<xsl:template match="sf:color[@xsi:type='sfa:calibrated-white-color-type']">
  <xsl:text>color: rgb(</xsl:text>
  <xsl:value-of select="round(100 * @sfa:w)"/>
  <xsl:text>%, </xsl:text>
  <xsl:value-of select="round(100 * @sfa:w)"/>
  <xsl:text>%, </xsl:text>
  <xsl:value-of select="round(100 * @sfa:w)"/>
  <xsl:text>%); </xsl:text>
</xsl:template>

<xsl:template match="sf:italic|sf:bold|sf:underline">
  <!-- sf:number existe => @sfa:number == 1 (== yes) -->
  <xsl:apply-templates select="sf:number"/>
</xsl:template>

<xsl:template match="sf:italic/sf:number">
  <xsl:text>font-style: italic; </xsl:text>
</xsl:template>

<xsl:template match="sf:bold/sf:number">
  <xsl:text>font-weight: bold; </xsl:text>
</xsl:template>

<xsl:template match="sf:underline/sf:number">
  <xsl:text>text-decoration: underline; </xsl:text>
</xsl:template>
</xsl:transform>


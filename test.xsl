<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" 
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:sfa="http://developer.apple.com/namespaces/sfa" xmlns:sf="http://developer.apple.com/namespaces/sf" 
>

<xsl:template match="/">
<html>
<head>
	<style>
<xsl:for-each select="//sf:paragraphstyle">
	<xsl:if test="@sf:ident!=''">
	.<xsl:value-of select="@sf:ident"/> {
	
	 <xsl:if test='./sf:property-map/sf:fontName/sf:string'>font-family: "<xsl:value-of select="./sf:property-map/sf:fontName/sf:string/@sfa:string"/>";
	</xsl:if>
	<xsl:if test='./sf:property-map/sf:fontSize/sf:number'>font-size: <xsl:value-of select="./sf:property-map/sf:fontSize/sf:number/@sfa:number"/>px;
	</xsl:if>
	<xsl:if test='./sf:property-map/sf:fontColor/sf:color'>color: rgb(<xsl:value-of select="./sf:property-map/sf:fontColor/sf:color/@sfa:r"/>,<xsl:value-of select="./sf:property-map/sf:fontColor/sf:color/@sfa:g"/>,<xsl:value-of select="./sf:property-map/sf:fontColor/sf:color/@sfa:b"/>);
	</xsl:if>
	<xsl:if test='./sf:property-map/sf:italic/sf:number'>font-style:italic;
	</xsl:if>
	<xsl:if test='./sf:property-map/sf:bold/sf:number'>font-weight:bold;
	</xsl:if>}
	</xsl:if>
	
</xsl:for-each>
</style>
</head>
<body>

<xsl:for-each select="//sf:p">
<p><xsl:attribute name="class"><xsl:value-of select="@sf:style"/></xsl:attribute>
<xsl:for-each select="child::node()"> 
<xsl:choose>
    <xsl:when test="name()='sf:toc-bookmark'">
<a><xsl:attribute name="id"><xsl:value-of select="@sf:name"/></xsl:attribute></a>
</xsl:when>
<xsl:when test="name()='sf:br'">
<br/>
</xsl:when>
<xsl:when test="name()='sf:lnbr'">
<br/>
</xsl:when>
<xsl:when test="name()='sf:span'">
<span><xsl:attribute name="class"><xsl:value-of select="@sf:style"/></xsl:attribute><xsl:value-of select="."/></span>
</xsl:when>
<xsl:when test="name()='sf:link'">
<a><xsl:attribute name="href"><xsl:value-of select="@href"/></xsl:attribute><xsl:value-of select="."/></a>
</xsl:when>

<xsl:when test="name()='sf:page-start'">
<!-- ignore -->
</xsl:when>
<xsl:when test="name()='sf:container-hint'">
<!-- ignore -->
</xsl:when>
<xsl:when test="name()='sf:toc-pagenum'">
  <a><xsl:attribute name="href">#<xsl:value-of select="@sf:bookmark"/></xsl:attribute><xsl:value-of select="@sf:value"/></a>
</xsl:when>

<xsl:otherwise>
<strong>!!!<xsl:value-of select="name()"/>!!!</strong>
<xsl:value-of select="."/>
</xsl:otherwise>
</xsl:choose>
</xsl:for-each>
</p>
</xsl:for-each>
</body>
</html>
</xsl:template>

</xsl:stylesheet>

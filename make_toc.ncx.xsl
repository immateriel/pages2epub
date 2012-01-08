<?xml version="1.0" encoding="UTF-8" ?>
<!-- Fabrication toc.ncx à partir de fichiers Pages -->
<!-- Pour intégration dans archive ePub -->
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

  <xsl:template name="make_toc.ncx" match="/">
    <exsl:document 
	href="{$maindir}/toc.ncx" 
	doctype-public="-//NISO//DTD ncx 2005-1//EN" 
	doctype-system="http://www.daisy.org/z3986/2005/ncx-2005-1.dtd"
	version="1.0" 
	indent="yes">
      <ncx version="2005-1">
	<xsl:call-template name="head"/>
	<xsl:call-template name="docTitle"/>
	<xsl:call-template name="navmap"/>
      </ncx>
    </exsl:document>
  </xsl:template>

  <xsl:template name="head">
    <head>
      <meta name="dtb:uid" content="ID"/>
            <meta name="dtb:depth" content="2"/>
      <meta name="dtb:totalPageCount" content="0"/>
      <meta name="dtb:maxPageNumber" content="0"/>
    </head>
  </xsl:template>

  <xsl:template name="docTitle">
    <docTitle>
		<xsl:choose>
			<xsl:when test="$title='undefined'">
				<text><xsl:value-of select="//sf:metadata/sf:title/sf:string/@sfa:string"/></text>
				</xsl:when>
				<xsl:otherwise>
					  <text><xsl:value-of select="$title"/></text>
			      
				</xsl:otherwise>
				</xsl:choose>    
    </docTitle>
  </xsl:template>

  <xsl:template name="navmap">
    <navMap>

		<xsl:choose>
				<xsl:when test="not(//sf:p[child::sf:toc-bookmark])">
			      	<navPoint id="navPoint-1" playOrder="1">
					  <navLabel>
					    <text><xsl:value-of select="$title"/></text>
					  </navLabel>
					  <content src="{$basename}.html"/>
					</navPoint>      
				
				</xsl:when>
				<xsl:otherwise>	
					<navPoint id="navPoint-1" playOrder="1">
					  <navLabel>
					    <text>Introduction</text>
					  </navLabel>
					  <content src="intro.html"/>
					</navPoint>
				</xsl:otherwise>
			</xsl:choose>	
							
      <xsl:for-each select="//sf:p[sf:toc-bookmark]">
	<xsl:variable name="count" select="position()+1"/>
	<navPoint id="navPoint-{$count}" playOrder="{$count}">
	  <navLabel>
	    <text><xsl:call-template name="tocTitle"/></text>
	  </navLabel>
	  <content src="{sf:toc-bookmark/@sf:name}.html"/>
	</navPoint>      
      </xsl:for-each>
    </navMap>
  </xsl:template>

</xsl:transform>

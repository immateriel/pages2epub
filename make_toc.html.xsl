<?xml version="1.0" encoding="utf-8"?>

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	       version="1.0"
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		xmlns:sfa="http://developer.apple.com/namespaces/sfa" 
		xmlns:sf="http://developer.apple.com/namespaces/sf"
		xmlns:sl="http://developer.apple.com/namespaces/sl"
	       xmlns="http://www.w3.org/1999/xhtml"
	       xmlns:exsl="http://exslt.org/common"
	       extension-element-prefixes="exsl"
	exclude-result-prefixes="xsi sfa sf sl">

  <xsl:template name="make_toc.html" match="/">
    <exsl:document href="{$maindir}/toc.html" 
		   version="1.0" 		
		   indent="yes"> 
		<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
		<meta content="text/html; charset=utf-8" http-equiv="Content-Type" />
		<title>TOC</title>
		<link href="{$basename}.css" rel="stylesheet" type="text/css" /> 	  	
		</head>
		<body>
			<xsl:for-each select="//sf:toc//sf:p[child::sf:toc-pagenum]">
			    <p class="{@sf:style}">
			      <a href="{sf:toc-pagenum/@sf:bookmark}.html">
				<xsl:apply-templates select="text()|*[name() != 'sf:toc-pagenum']"/>
			      </a>
			    </p>
			  </xsl:for-each>
			<p></p>
			
		</body>
		</html>
		
	</exsl:document>
 	</xsl:template>

 
</xsl:transform>
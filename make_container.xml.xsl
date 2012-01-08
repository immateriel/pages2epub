<?xml version="1.0" encoding="utf-8"?>
<!-- Fabrication container.xml -->
<!-- Pour intégration dans archive ePub -->
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	       version="1.0"
	       xmlns="urn:oasis:names:tc:opendocument:xmlns:container"
	       xmlns:exsl="http://exslt.org/common"
	       extension-element-prefixes="exsl">

  <xsl:template name="make_container.xml" match="/">
    <exsl:document href="{$maindir}/META-INF/container.xml" 
		   version="1.0" 
		   indent="yes">
      <container version="1.0">
	<rootfiles>
	  <rootfile full-path="content.opf" media-type="application/oebps-package+xml"/>
	</rootfiles>
      </container>
    </exsl:document>
  </xsl:template>

</xsl:transform>

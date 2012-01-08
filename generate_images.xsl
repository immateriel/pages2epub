<xsl:transform  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xhtml="http://www.w3.org/1999/xhtml" version="1.0">
  <xsl:param name="maindir" select="'/tmp/epub'"/>
  <xsl:param name="extractdir" select="'/tmp/extract'"/>

 <xsl:output method="text"/>
	<xsl:template match="/">
		<xsl:for-each select="//xhtml:img">
			<xsl:if test="@src != ''">
			<xsl:text>convert "</xsl:text>
			<xsl:value-of select="$extractdir"/>
			<xsl:text>/</xsl:text>
			<xsl:choose>
				<xsl:when test="contains(@src,'.pict') or contains(@src,'.pdf')">
					<xsl:value-of select="substring-before(@src,'.png')"/>

				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@src"/>

					</xsl:otherwise>
				</xsl:choose>
			
			<xsl:if test="@width !=''">
				<xsl:text>" -resize </xsl:text>
				<xsl:value-of select="@width"/>
				<xsl:text>x</xsl:text>
				<xsl:value-of select="@height"/>
			</xsl:if>
			<xsl:text> "</xsl:text>
			<xsl:value-of select="$maindir"/>
			<xsl:text>/</xsl:text>
					<xsl:value-of select="@src"/>
			<xsl:text>";</xsl:text>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	


</xsl:transform>
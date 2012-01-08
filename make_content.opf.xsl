<?xml version="1.0" encoding="UTF-8" ?>
<!-- Fabrication content.opf à partir de fichiers Pages -->
<!-- Pour intégration dans archive ePub -->
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	       version="1.0"
	       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	       xmlns:sfa="http://developer.apple.com/namespaces/sfa" 
	       xmlns:sf="http://developer.apple.com/namespaces/sf"
	       xmlns:sl="http://developer.apple.com/namespaces/sl"
	       xmlns="http://www.idpf.org/2007/opf"
	       xmlns:exsl="http://exslt.org/common"
	       extension-element-prefixes="exsl"
	       exclude-result-prefixes="xsi sfa sf sl">

  <xsl:template name="make_content.opf" match="/">
    <exsl:document href="{$maindir}/content.opf" version="1.0" 
		   indent="yes">
      <package version="2.0" unique-identifier="ID">
	<xsl:apply-templates select="//sf:metadata"/>
	<xsl:call-template name="manifest"/>
	<xsl:call-template name="spine"/>
      </package>
    </exsl:document>
  </xsl:template>

  <xsl:template match="sf:metadata">
	
    <xsl:variable name="pubinfo" select="preceding-sibling::sl:publication-info"/> 
    <metadata xmlns:dc="http://purl.org/dc/elements/1.1/"
	      xmlns:dcterms="http://purl.org/dc/terms/"
	      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	      xmlns:opf="http://www.idpf.org/2007/opf">
		<xsl:choose>
			<xsl:when test="$title='undefined'">
				<dc:title><xsl:value-of select="//sf:metadata/sf:title/sf:string/@sfa:string"/></dc:title>
				</xsl:when>
				<xsl:otherwise>
					<dc:title><xsl:value-of select="$title"/></dc:title>
			      
				</xsl:otherwise>
				</xsl:choose>
				
      <dc:language xsi:type="dcterms:RFC3066">
	<xsl:value-of select="$pubinfo/sl:language/sl:string/@sfa:string"/>
      </dc:language>
      <dc:identifier id="ID" opf:scheme="ISBN">
	<xsl:value-of select="$identifier"/>

      </dc:identifier>
      <xsl:for-each select="sf:keywords/sf:string">
	<dc:subject><xsl:value-of select="@sfa:string"/></dc:subject>
      </xsl:for-each>
      <dc:description><xsl:value-of select="sf:comment/sf:string/@sfa:string"/></dc:description>
<!--      <dc:relation>http://publie.net</dc:relation> -->
	<xsl:choose>
		<xsl:when test="$author='undefined'">
		  <xsl:for-each select="sf:authors/sf:string">
			<dc:creator opf:role="aut"><xsl:value-of select="@sfa:string"/></dc:creator>
	      </xsl:for-each>
		
	</xsl:when>
	<xsl:otherwise>
			<dc:creator opf:role="aut"><xsl:value-of select="$author"/></dc:creator>
		
	</xsl:otherwise>
	</xsl:choose>
      <dc:publisher><xsl:value-of select="$publisher"/></dc:publisher>
      <dc:date xsi:type="dcterms:W3CDTF"><xsl:value-of select="substring($pubinfo/sl:SLLastModifiedDateProperty/sl:date/@sf:val,1,10)"/></dc:date>
      <dc:rights><xsl:value-of select="sf:copyright/sf:string/@sfa:string"/></dc:rights>
    </metadata>
  </xsl:template>

  <xsl:template name="manifest">
    <manifest>      
      <item id="cover" media-type="application/xhtml+xml" href="cover.html"/>
      <item id="toc" media-type="application/xhtml+xml" href="toc.html"/>
	<xsl:choose>
	<xsl:when test="not(//sf:p[child::sf:toc-bookmark])">
      <item id="main" media-type="application/xhtml+xml" href="{$basename}.html"/>
	</xsl:when>
	<xsl:otherwise>
		<item id="intro" media-type="application/xhtml+xml" href="intro.html"/>
      
	</xsl:otherwise>
</xsl:choose>
	  <xsl:for-each select="//sf:p[child::sf:toc-bookmark]">
	      <item id="{sf:toc-bookmark/@sf:name}" media-type="application/xhtml+xml" href="{sf:toc-bookmark/@sf:name}.html"/>
	  </xsl:for-each>

      <item id="footnotes" media-type="application/xhtml+xml" href="footnotes.html"/>

      <item id="coverfile" media-type="image/png" href="cover.png"/>
	  <item id="css" media-type="text/css" href="{$basename}.css"/>
      <item id="ncx" href="toc.ncx" media-type="application/x-dtbncx+xml"/>

		<xsl:for-each select="//sf:attachment">
			<xsl:variable name="imgSrc" select="sf:media/sf:content//sf:data/@sf:path"/>
			<xsl:variable name="imgMedia">
			<xsl:choose>
				<xsl:when test="contains($imgSrc,'.jpg') or contains($imgSrc,'.JPG') or contains($imgSrc,'.jpeg')">
				<xsl:text>image/jpeg</xsl:text>
				</xsl:when>
				<xsl:when test="contains($imgSrc,'.gif')">
				<xsl:text>image/gif</xsl:text>
				</xsl:when>

				<xsl:otherwise>
					<xsl:text>image/png</xsl:text>
				</xsl:otherwise>
			</xsl:choose>		
			</xsl:variable>
			
			<xsl:if test="$imgSrc != ''">
				<xsl:choose>
					<xsl:when test="contains($imgSrc,'.pict') or contains(@src,'.pdf')">

						<item id="{@sfa:ID}" media-type="{$imgMedia}" href="{$imgSrc}.png"/>
					</xsl:when>
					<xsl:otherwise>
						<item id="{@sfa:ID}" media-type="{$imgMedia}" href="{$imgSrc}"/>

					</xsl:otherwise>
				</xsl:choose>
					
				
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each select="//sf:image-media">
				<xsl:variable name="imgSrc" select="sf:filtered-image/sf:unfiltered/sf:data/@sf:path"/>

				<xsl:variable name="imgMedia">
				<xsl:choose>
					<xsl:when test="contains($imgSrc,'.jpg') or contains($imgSrc,'.JPG') or contains($imgSrc,'.jpeg')">
					<xsl:text>image/jpeg</xsl:text>
					</xsl:when>
					<xsl:when test="contains($imgSrc,'.gif')">
					<xsl:text>image/gif</xsl:text>
					</xsl:when>

					<xsl:otherwise>
						<xsl:text>image/png</xsl:text>
					</xsl:otherwise>
				</xsl:choose>		
				</xsl:variable>
				<xsl:if test="$imgSrc != ''">
					<xsl:choose>
						<xsl:when test="contains($imgSrc,'.pict') or contains(@src,'.pdf')">
							<item id="img{position()}" media-type="{$imgMedia}" href="{$imgSrc}.png"/>				
						</xsl:when>
						<xsl:otherwise>
							<item id="img{position()}" media-type="{$imgMedia}" href="{$imgSrc}"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
		</xsl:for-each>
		
    </manifest>
  </xsl:template>
  <xsl:template name="spine">
    <spine toc="ncx">      
      <itemref idref="cover"/>
      <itemref idref="toc"/>
<xsl:choose>
	<xsl:when test="not(//sf:p[child::sf:toc-bookmark])">
      <itemref idref="main"/>
	</xsl:when>
	<xsl:otherwise>
      <itemref idref="intro"/>
	</xsl:otherwise>
</xsl:choose>
	  <xsl:for-each select="//sf:p[child::sf:toc-bookmark]">
	      <itemref idref="{sf:toc-bookmark/@sf:name}"/>
	  </xsl:for-each>

      <itemref idref="footnotes"/>

    </spine>
	<guide>
		<reference type="cover" title="Cover" href="cover.html" />
		<reference type="toc" title="Table of Contents" href="toc.html" />
			<xsl:choose>
			<xsl:when test="not(//sf:p[child::sf:toc-bookmark])">
		      <reference type="text" href="{$basename}.html"/>
			</xsl:when>
			<xsl:otherwise>
				<reference type="text" href="intro.html"/>

			</xsl:otherwise>
		</xsl:choose>
			  <xsl:for-each select="//sf:p[child::sf:toc-bookmark]">
			      <reference type="text" href="{sf:toc-bookmark/@sf:name}.html"/>
			  </xsl:for-each>

		<reference type="glossary" title="Footnotes" href="footnotes.html" />
	</guide>
  </xsl:template>
</xsl:transform>

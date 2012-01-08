<?xml version="1.0" encoding="UTF-8" ?>
<xsl:transform  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" 		
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		xmlns:sfa="http://developer.apple.com/namespaces/sfa" 
		xmlns:sf="http://developer.apple.com/namespaces/sf"
		xmlns:sl="http://developer.apple.com/namespaces/sl"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:exsl="http://exslt.org/common"
        extension-element-prefixes="exsl"
		exclude-result-prefixes="xsi sfa sf sl">

  <!-- Pour créer le fichier de métadonnées content.opf -->
  <xsl:include href="make_content.opf.xsl"/>
  <!-- Pour créer le fichier de métadonnées container.xml -->
  <xsl:include href="make_container.xml.xsl"/>
  <!-- Pour créer le fichier de métadonnées toc.ncx -->
  <xsl:include href="make_toc.ncx.xsl"/>
  <!-- Pour créer le fichier CSS -->
  <xsl:include href="make_main.css.xsl"/>
  <!-- Pour créer le fichier TDM -->
  <xsl:include href="make_toc.html.xsl"/>
  <!-- Pour créer le fichier Footnotes -->
  <xsl:include href="make_footnotes.html.xsl"/>

  <xsl:param name="maindir" select="'/tmp/epub'"/>
  <xsl:param name="mainfile" select="'/tmp/epub/mainfile.html'"/>
  <xsl:param name="basename" select="'/tmp/epub/main'"/>

  <xsl:param name="isbn">
    <xsl:text>ISBN : Please call the transformation with '--stringparam isbn XXX'</xsl:text>
  </xsl:param>

  <xsl:variable name="page-height" select="//sl:slprint-info/@sl:page-height"/>
  <xsl:variable name="page-width" select="//sl:slprint-info/@sl:page-width"/>

  <xsl:variable name="rc">
    <xsl:text>&#x0A;</xsl:text>
  </xsl:variable>


			
			
  <xsl:output encoding="UTF-8"
	      version="1.0"
	      indent="yes"
	      doctype-public="-//W3C//DTD XHTML 1.1//EN"
	      doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"/>


  <xsl:key name="imgs" match="sf:attachment" use="@sfa:ID"/>		   
  <xsl:key name="imgsMed" match="sf:media" use="ancestor::sl:page-group/@sl:page"/>			   

  <xsl:template match="/">
		
    <!-- Crée les fichiers annexes -->
    <xsl:call-template name="make_content.opf"/>
    <xsl:call-template name="make_container.xml"/>
    <xsl:call-template name="make_toc.ncx"/>
    <xsl:call-template name="make_main.css"/>
    <xsl:call-template name="make_toc.html"/>
    <xsl:call-template name="make_footnotes.html"/>



	<xsl:if test="$title='undefined'">
	<xsl:variable name="title" select="//sf:metadata/sf:title/sf:string/@sfa:string"/>
	</xsl:if>
  

    <html>
      <head>
		<title><xsl:value-of select="$title"/></title>
	  	<link href="{$basename}.css" rel="stylesheet" type="text/css" /> 
      </head>
      <body>
		<xsl:apply-templates select="//*[name()='sf:p' or name()='sf:page-start']"/>
<!--		<xsl:apply-templates select="//sf:p"/> -->

      </body>
    </html>
  </xsl:template>



  <!-- Traitement des en-têtes et pieds de page -->
  <xsl:template match="sf:p[ancestor::*[name()='sf:headers' or name()='sf:footers']]"/>

<!-- footnotes -->
<xsl:template match="sf:footnote">
<!--   <a id="back-footnote-mark-{@sf:autonumber}"/> -->
   <sup><a href="footnotes.html#footnote-mark-{@sf:autonumber}"><xsl:value-of select="@sf:autonumber"/></a></sup>
 </xsl:template>

<xsl:template match="sf:p[ancestor::sf:footnotes]"/>
<xsl:template match="sf:footnote-mark">
<a id="footnote-mark-{@sf:mark}"/>
<!-- <a href="{$basename}.html#back-footnote-mark-{@sf:mark}"></a> -->
<xsl:value-of select="@sf:mark"/>
</xsl:template>


<!-- image -->


  <!-- Paragraphes de Table des Matières -->
<xsl:template match="sf:p[child::sf:toc-pagenum]"/>

  <!-- Paragraphes pointés par la Table des Matières -->
  <xsl:template match="sf:p[child::sf:toc-bookmark]">
	  <xsl:variable name="curN" select="."/>
	
		<exsl:document href="{$maindir}/intro.html">
			<html>
				<head>
					<title>Introduction</title>
					<link href="{$basename}.css" rel="stylesheet" type="text/css" /> 
				</head>
				<body>
						<xsl:for-each select="preceding-sibling::sf:p[not(child::sf:toc-bookmark)] | ancestor::*/preceding-sibling::*/descendant::sf:p[not(child::sf:toc-bookmark)]">
							<xsl:if test="count(preceding-sibling::sf:p[child::sf:toc-bookmark])=0 and not(ancestor::sf:footnotes) and not(ancestor::sf:footers) and not(ancestor::sf:toc)">
							<xsl:choose>
								<xsl:when test="@sf:style !='' ">
							<p class="{@sf:style}">
								<xsl:apply-templates/>
							</p>
						</xsl:when>
						<xsl:otherwise>
							<p>
								<xsl:apply-templates/>
							</p>
						</xsl:otherwise>
					</xsl:choose>
							
						</xsl:if>
							</xsl:for-each>
				</body>
			</html>
		</exsl:document>
	
	<exsl:document href="{$maindir}/{sf:toc-bookmark/@sf:name}.html" 
		version="1.0" 
		indent="yes"> 
		<html>
			<head>
				<title><xsl:call-template name="tocTitle"/></title>
				<link href="{$basename}.css" rel="stylesheet" type="text/css" /> 
			</head>
			<body>
				<h1 class="{@sf:style}">	  
					<a id="{sf:toc-bookmark/@sf:name}"></a>
					<xsl:apply-templates/>
				</h1>
				<xsl:for-each select="following-sibling::sf:p[preceding-sibling::sf:p[child::sf:toc-bookmark][1] = $curN]">
					
					<xsl:if test="not(child::sf:toc-bookmark)">
						<xsl:if test="child::sf:page-start">
								<xsl:if test="preceding-sibling::sf:page-start">
									<xsl:for-each select="preceding-sibling::sf:page-start[preceding-sibling::sf:p[child::sf:toc-bookmark][1] = $curN]">
									<xsl:message>Found image in node page-start <xsl:value-of select="@sf:page-index"/></xsl:message>
									<xsl:variable name="curPage" select="@sf:page-index"/>
									
									<xsl:for-each select="key('imgsMed',$curPage)">
										<xsl:variable name="imgSrc" select="sf:content/sf:image-media/sf:filtered-image/sf:unfiltered/sf:data/@sf:path"/>
										<xsl:if test="$imgSrc != ''">
											<xsl:message>Apply image (preceding sf:page-start) <xsl:value-of select="$imgSrc"/> for page <xsl:value-of select="$curPage"/> </xsl:message>
											<xsl:choose>
												<xsl:when test="contains($imgSrc,'.pict') or contains($imgSrc,'.pdf')">
													<p><img src="{$imgSrc}.png" width="{sf:geometry/sf:size/@sfa:w}" height="{sf:geometry/sf:size/@sfa:h}" alt="image"/></p>
												</xsl:when>
												<xsl:otherwise>
													<p><img src="{$imgSrc}" width="{sf:geometry/sf:size/@sfa:w}" height="{sf:geometry/sf:size/@sfa:h}" alt="image"/></p>

												</xsl:otherwise>
											</xsl:choose>
										</xsl:if>
									</xsl:for-each>
									
									
									</xsl:for-each>
								</xsl:if>
								
							<xsl:for-each select="sf:page-start">
								<xsl:variable name="curPage" select="@sf:page-index"/>
								<xsl:message>Check page <xsl:value-of select="$curPage"/></xsl:message>
								
								<xsl:for-each select="key('imgsMed',$curPage)">
									<xsl:variable name="imgSrc" select="sf:content/sf:image-media/sf:filtered-image/sf:unfiltered/sf:data/@sf:path"/>
									<xsl:message>Apply image (sf:page-start) <xsl:value-of select="$imgSrc"/> for page <xsl:value-of select="$curPage"/> </xsl:message>

									<xsl:if test="$imgSrc != ''">
										<xsl:choose>
											<xsl:when test="contains($imgSrc,'.pict') or contains($imgSrc,'.pdf')">
												<p><img src="{$imgSrc}.png" width="{sf:geometry/sf:size/@sfa:w}" height="{sf:geometry/sf:size/@sfa:h}" alt="image"/></p>
											</xsl:when>
											<xsl:otherwise>
												<p><img src="{$imgSrc}" width="{sf:geometry/sf:size/@sfa:w}" height="{sf:geometry/sf:size/@sfa:h}" alt="image"/></p>

											</xsl:otherwise>
										</xsl:choose>
									</xsl:if>
								</xsl:for-each>
							</xsl:for-each>
<!--							<p class="{@sf:style}"><xsl:apply-templates/></p> -->
						</xsl:if>

						<p class="{@sf:style}">				
							<xsl:apply-templates/>
						</p>
					</xsl:if>
				</xsl:for-each>			
			</body>
		</html>
	</exsl:document> 
  </xsl:template>



<xsl:template match="sf:p[preceding-sibling::*[2][name() = 'sf:page-start'] and not(child::sf:toc-bookmark)]">

	<xsl:variable name="curPage" select="preceding-sibling::*[2][name() = 'sf:page-start']/@sf:page-index"/>
<!--
	<xsl:for-each select="key('imgsMed',$curPage)">
		<xsl:variable name="imgSrc" select="sf:content/sf:image-media/sf:filtered-image/sf:unfiltered/sf:data/@sf:path"/>
		<xsl:if test="$imgSrc != ''">
			<xsl:message>Apply image (preceding sf:page-start) (main) <xsl:value-of select="$imgSrc"/> for page <xsl:value-of select="$curPage"/> </xsl:message>

			<xsl:choose>
				<xsl:when test="contains($imgSrc,'.pict') or contains($imgSrc,'.pdf')">
					<p><img src="{$imgSrc}.png" width="{sf:geometry/sf:size/@sfa:w}" height="{sf:geometry/sf:size/@sfa:h}" alt="image"/></p>
				</xsl:when>
				<xsl:otherwise>
					<p><img src="{$imgSrc}" width="{sf:geometry/sf:size/@sfa:w}" height="{sf:geometry/sf:size/@sfa:h}" alt="image"/></p>
				</xsl:otherwise>
			</xsl:choose>			
		</xsl:if>
	</xsl:for-each>
	-->
	<p class="{@sf:style}"><xsl:apply-templates/></p>
</xsl:template>


<xsl:template match="sf:page-start[not(ancestor::sf:p)]">
	<xsl:message>Found image in node page-start<xsl:value-of select="@sf:page-index"/></xsl:message>
	
		<xsl:variable name="curPage" select="@sf:page-index"/>
		<xsl:for-each select="key('imgsMed',$curPage)">
			
			<xsl:variable name="imgSrc" select="sf:content/sf:image-media/sf:filtered-image/sf:unfiltered/sf:data/@sf:path"/>

			<xsl:if test="$imgSrc != ''">
				<xsl:message>Apply image (sf:page-start) (main) <xsl:value-of select="$imgSrc"/> for page <xsl:value-of select="$curPage"/> </xsl:message>
				<xsl:choose>
					<xsl:when test="contains($imgSrc,'.pict') or contains($imgSrc,'.pdf')">
						<p><img src="{$imgSrc}.png" width="{sf:geometry/sf:size/@sfa:w}" height="{sf:geometry/sf:size/@sfa:h}" alt="image"/></p>
					</xsl:when>
					<xsl:otherwise>
						<p><img src="{$imgSrc}" width="{sf:geometry/sf:size/@sfa:w}" height="{sf:geometry/sf:size/@sfa:h}" alt="image"/></p>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:for-each>
</xsl:template>


<xsl:template match="sf:p[child::sf:page-start]">	
	<xsl:for-each select="sf:page-start">
		<xsl:variable name="curPage" select="@sf:page-index"/>
		<xsl:for-each select="key('imgsMed',$curPage)">
			<xsl:variable name="imgSrc" select="sf:content/sf:image-media/sf:filtered-image/sf:unfiltered/sf:data/@sf:path"/>
			<xsl:if test="$imgSrc != ''">
				<xsl:choose>
					<xsl:when test="contains($imgSrc,'.pict') or contains($imgSrc,'.pdf')">
						<p><img src="{$imgSrc}.png" width="{sf:geometry/sf:size/@sfa:w}" height="{sf:geometry/sf:size/@sfa:h}" alt="image"/></p>
					</xsl:when>
					<xsl:otherwise>
						<p><img src="{$imgSrc}" width="{sf:geometry/sf:size/@sfa:w}" height="{sf:geometry/sf:size/@sfa:h}" alt="image"/></p>

					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:for-each>
	</xsl:for-each>
	<p class="{@sf:style}"><xsl:apply-templates/></p>
</xsl:template>

<!-- autre paragraphes -->
 <xsl:template match="sf:p">
<!--	<xsl:if test="not(following-sibling::sf:toc)"> -->
	<p class="{@sf:style}">
	  <xsl:apply-templates/>
	</p>
<!--	</xsl:if> -->
 </xsl:template>



	<xsl:template match="sf:attachment-ref">
		<xsl:variable name="imgId" select="@sfa:IDREF"/>
		<xsl:for-each select="key('imgs',$imgId)">
		<xsl:variable name="imgSrc" select="sf:media/sf:content//sf:data/@sf:path"/>
		<xsl:if test="$imgSrc != ''">
			<xsl:message>Apply image (sf:attachment-ref) <xsl:value-of select="$imgSrc"/></xsl:message>

			<xsl:choose>
				<xsl:when test="contains($imgSrc,'.pict') or contains($imgSrc,'.pdf')">
					<img id="{@sfa:ID}" src="{$imgSrc}.png" width="{sf:media/sf:geometry/sf:size/@sfa:w}" height="{sf:media/sf:geometry/sf:size/@sfa:h}" alt="image"/>
				</xsl:when>
				<xsl:otherwise>
					<img id="{@sfa:ID}" src="{$imgSrc}" width="{sf:media/sf:geometry/sf:size/@sfa:w}" height="{sf:media/sf:geometry/sf:size/@sfa:h}" alt="image"/>
				</xsl:otherwise>
			</xsl:choose>
				
		</xsl:if>
		</xsl:for-each>
	</xsl:template>

 
  <xsl:template match="sf:br">
    <xsl:text>&#160;</xsl:text><br/>
  </xsl:template>


  <xsl:template match="sf:lnbr">
    <xsl:text> </xsl:text><br/>
  </xsl:template>

  <xsl:template match="sf:span">
    <span class="{@sf:style}"><xsl:apply-templates/></span>
  </xsl:template>


  <xsl:template match="sf:bookmark">
      <xsl:apply-templates/>
  </xsl:template>


<xsl:template match="sf:link">
	<xsl:choose>
		<xsl:when test="substring(@href, 1, 1)='#'">
			<xsl:apply-templates/>
		</xsl:when>
		<xsl:otherwise>
			<a href="{@href}">
				<xsl:apply-templates/>
			</a>

		</xsl:otherwise>		
	</xsl:choose>
</xsl:template>

  <xsl:template match="sf:toc-pagenum">
    <a href="#{@sf:bookmark}">
      <xsl:value-of select="@sf:value"/>
    </a>
  </xsl:template>

  <xsl:template match="sf:tab">
    <xsl:text> </xsl:text>
  </xsl:template>


  <xsl:template match="text()">
<xsl:value-of select="."/>
 </xsl:template>

  <xsl:template match="sf:*"/>
  <xsl:template match="sl:*"/>

  <!--             -->
  <!-- Utilitaires -->
  <!--             -->

  <xsl:template name="tocTitle">
			<xsl:for-each select="child::text()|child::node()">
				<xsl:choose>
				<xsl:when test="name()='sf:br' or name()='sf:lnbr'">
					<xsl:text> </xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
			</xsl:for-each>
  </xsl:template>

  <!-- Pour transformer des distances en points en pourcentages par
       rapport à la largeur de page initiale -->
  <xsl:template name="pt2wpct">
    <xsl:param name="pt" select="0"/>
    <xsl:value-of select="round(100 * number($pt) div $page-width)"/>
  </xsl:template>
  <!-- Pour transformer des distances en points en pourcentages par
       rapport à la hauteur de la page initiale -->
  <xsl:template name="pt2hpct">
    <xsl:param name="pt" select="0"/>
    <xsl:value-of select="round(100 * number($pt) div $page-height)"/>
  </xsl:template>

</xsl:transform>

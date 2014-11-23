<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:umb="urn:umbraco.library"
	exclude-result-prefixes="msxml umb">

	<xsl:output method="xml" omit-xml-declaration="yes"/>
	
	<xsl:template match="*" mode="media">
		<xsl:param name="cropset" />
		<xsl:param name="quality" select="'90'" />

		<xsl:apply-templates select="umb:Split(., ',')/descendant::value[normalize-space()]" mode="media">
			<xsl:with-param name="cropset" select="$cropset" />
			<xsl:with-param name="quality" select="$quality" />
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="value" mode="media">
		<xsl:param name="cropset" />
		<xsl:param name="quality" />

		<xsl:apply-templates select="umb:GetMedia(., 1)[@id and not(error)]">
			<xsl:with-param name="cropset" select="$cropset" />
			<xsl:with-param name="quality" select="$quality" />
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="Image">
		<xsl:param name="cropset" />
		<xsl:param name="quality" />
		<xsl:variable name="data" select="umb:JsonToXml(umbracoFile)" />
		<xsl:variable name="src" select="$data/src" />
		
		<xsl:variable name="format">
			<xsl:choose>
				<xsl:when test="contains($src, '.jpg')">
					<xsl:value-of select="'jpg'" />
				</xsl:when>
				<xsl:when test="contains($src, '.png')">
					<xsl:value-of select="'png'" />
				</xsl:when>
				<xsl:when test="contains($src, '.gif')">
					<xsl:value-of select="'gif'" />
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="focalPointTop" select="$data/focalPoint/top" />
		<xsl:variable name="focalPointLeft" select="$data/focalPoint/left" />

		<img src="{$src}" width="{umbracoWidth}" height="{umbracoHeight}" alt="{@nodeName}">
			<xsl:variable name="origin">
				<xsl:choose>
					<xsl:when test="$data/crops[alias = $cropset]/coordinates">
						<xsl:value-of select="concat('?crop=', $data/crops[alias = $cropset]/coordinates/x1, ',', $data/crops[alias = $cropset]/coordinates/y1, ',', $data/crops[alias = $cropset]/coordinates/x2, ',', $data/crops[alias = $cropset]/coordinates/y2, '&amp;cropmode=percentage')" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat('?mode=crop&amp;center=', $focalPointTop, ',', $focalPointLeft, '&amp;width=', $data/crops[alias = $cropset]/width, '&amp;height=', $data/crops[alias = $cropset]/height)" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:if test="$cropset">
				<xsl:attribute name="src">
					<xsl:value-of select="$src" />
					<xsl:value-of select="$origin" />
					<xsl:value-of select="concat('&amp;quality=', $quality)" />
					<xsl:value-of select="concat('&amp;format=', $format)" />
				</xsl:attribute>
				<xsl:attribute name="width">
					<xsl:value-of select="$data/crops[alias = $cropset]/width" />
				</xsl:attribute>
				<xsl:attribute name="height">
					<xsl:value-of select="$data/crops[alias = $cropset]/height" />
				</xsl:attribute>
			</xsl:if>
		</img>
	</xsl:template>

	<xsl:template match="Folder">
		<xsl:param name="cropset" />
		<xsl:param name="quality" />

		<xsl:apply-templates select="*[@id]">
			<xsl:with-param name="cropset" select="$cropset" />
			<xsl:with-param name="quality" select="$quality" />
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="File" />
</xsl:stylesheet>
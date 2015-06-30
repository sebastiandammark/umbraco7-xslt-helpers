<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:umb="urn:umbraco.library"
	exclude-result-prefixes="msxml umb">

	<xsl:template match="*" mode="media">
		<xsl:param name="crop" />
		<xsl:param name="class" />
		<xsl:param name="id" />
		<xsl:param name="quality" select="'90'" />

		<xsl:apply-templates select="umb:Split(., ',')/descendant::value[normalize-space()]" mode="media">
			<xsl:with-param name="crop" select="$crop" />
			<xsl:with-param name="class" select="$class" />
			<xsl:with-param name="id" select="$id" />
			<xsl:with-param name="quality" select="$quality" />
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="value" mode="media">
		<xsl:param name="crop" />
		<xsl:param name="class" />
		<xsl:param name="id" />
		<xsl:param name="quality" />

		<xsl:apply-templates select="umb:GetMedia(., 1)[@id and not(error)]">
			<xsl:with-param name="crop" select="$crop" />
			<xsl:with-param name="class" select="$class" />
			<xsl:with-param name="id" select="$id" />
			<xsl:with-param name="quality" select="$quality" />
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="Image">
		<xsl:param name="crop" />
		<xsl:param name="class" />
		<xsl:param name="id" />
		<xsl:param name="quality" />
		<xsl:variable name="data" select="umb:JsonToXml(umbracoFile)" />
		<xsl:variable name="cropData" select="$data/crops[alias = $crop]" />
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
					<xsl:when test="$cropData/coordinates">
						<xsl:text>?crop=</xsl:text>
						<xsl:apply-templates select="$cropData/coordinates/x1" /><xsl:text>,</xsl:text>
						<xsl:apply-templates select="$cropData/coordinates/y1" /><xsl:text>,</xsl:text>
						<xsl:apply-templates select="$cropData/coordinates/x2" /><xsl:text>,</xsl:text>
						<xsl:apply-templates select="$cropData/coordinates/y2" />
						<xsl:text>&amp;cropmode=percent</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat('?mode=crop&amp;center=', $focalPointTop, ',', $focalPointLeft, '&amp;width=', $cropData/width, '&amp;height=', $cropData/height)" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:if test="$crop and $cropData">
				<xsl:attribute name="src">
					<xsl:value-of select="$src" />
					<xsl:value-of select="$origin" />
					<xsl:value-of select="concat('&amp;quality=', $quality)" />
					<xsl:value-of select="concat('&amp;format=', $format)" />
				</xsl:attribute>
				<xsl:attribute name="width">
					<xsl:value-of select="$cropData/width" />
				</xsl:attribute>
				<xsl:attribute name="height">
					<xsl:value-of select="$cropData/height" />
				</xsl:attribute>
			</xsl:if>

			<xsl:if test="$class">
				<xsl:attribute name="class">
					<xsl:value-of select="$class" />
				</xsl:attribute>
			</xsl:if>

			<xsl:if test="$id">
				<xsl:attribute name="id">
					<xsl:value-of select="$id" />
				</xsl:attribute>
			</xsl:if>
		</img>
	</xsl:template>

	<xsl:template match="Folder">
		<xsl:param name="crop" />
		<xsl:param name="class" />
		<xsl:param name="id" />
		<xsl:param name="quality" />

		<xsl:apply-templates select="*[@id]">
			<xsl:with-param name="crop" select="$crop" />
			<xsl:with-param name="class" select="$class" />
			<xsl:with-param name="id" select="$id" />
			<xsl:with-param name="quality" select="$quality" />
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="File[umbracoExtension='svg']">
		<xsl:param name="class" />

		<img src="{umbracoFile}" id="{@urlName}" alt="{@nodeName}">
			<xsl:if test="$class">
				<xsl:attribute name="class">
					<xsl:value-of select="$class" />
				</xsl:attribute>
			</xsl:if>
		</img>
	</xsl:template>

	<xsl:template match="File" />
	
	<!--
	Template for handling coordinates logged using scientific notation.
	Source: http://stackoverflow.com/questions/4367737/formatting-scientific-number-representation-in-xsl
	-->
	<xsl:template match="coordinates/*[substring-after(.,'E')]">
		<xsl:variable name="vExponent" select="substring-after(.,'E')"/>
		<xsl:variable name="vMantissa" select="substring-before(.,'E')"/>
		<xsl:variable name="vFactor"
			select="substring('100000000000000000000000000000000000000000000',
			        1, substring($vExponent,2) + 1)"
		/>
		<xsl:choose>
			<xsl:when test="starts-with($vExponent,'-')">
				<xsl:value-of select="$vMantissa div $vFactor"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$vMantissa * $vFactor"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
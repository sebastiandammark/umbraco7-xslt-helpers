<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:umb="urn:umbraco.library"
	exclude-result-prefixes="msxml umb">

	<xsl:output method="xml" omit-xml-declaration="yes"/>
	
	<xsl:template match="*" mode="mntp">
		<xsl:variable name="mntpSplit" select="umb:Split(., ',')" />
		<xsl:apply-templates select="$mntpSplit/descendant::value" mode="mntp" />
	</xsl:template>

	<xsl:template match="value" mode="mntp">
		<xsl:apply-templates select="umb:GetGetXmlNodeById(.)[not(error)]" />
	</xsl:template>
</xsl:stylesheet>
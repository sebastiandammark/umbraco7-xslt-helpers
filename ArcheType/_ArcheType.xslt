<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:umb="urn:umbraco.library"
	exclude-result-prefixes="msxml umb">

	<xsl:output method="xml" omit-xml-declaration="yes"/>
	
	<xsl:template match="*" mode="archetype">
		<xsl:variable name="archetype" select="umb:JsonToXml(.)" />
		<xsl:apply-templates select="$archetype/descendant::fieldsets[not(disabled = 'true')]" />
	</xsl:template>
</xsl:stylesheet>
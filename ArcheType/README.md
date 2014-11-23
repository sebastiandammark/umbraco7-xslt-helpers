# Archetype Helper

Helper file for rendering Archetype fieldsets:

## How to use it

1. Include this file in your main XSLT file:

	```xslt
	<xsl:include href="_ArcheType.xslt" />
	```
	
2. Create templates as usual for the types of nodes that are selectable in the picker, e.g.:

	```xslt
	<xsl:template match="fieldsets[alias='textcontent']">
		<!-- Code for textcontent -->
	</xsl:template>

	<xsl:template match="fieldsets[alias='mediacontent']">
		<!-- Code for mediacontent -->
	</xsl:template>
	```

3. Apply templates in "multipicker" mode, to the picker property:

	```xslt
	<xsl:apply-templates select="myArchetypeProperty" mode="archetype" />
	```
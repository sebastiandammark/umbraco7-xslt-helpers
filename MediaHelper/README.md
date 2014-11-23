# Media Helper

Helper file for rendering media from the media section:

## How to use it

1. Include this file in your main XSLT file:

	```xslt
	<xsl:include href="_MediaHelper.xslt" />
	```
	
2. Apply templates in "media" mode, to the media picker property:

	```xslt
	<xsl:template match="myMediaProperty" mode="media" />
	```

### Properties

The helper takes 2 properties:
	* cropset
	* quality (default is 90)

If you're using the built-in Image Cropper, you can use the helper like this:

	```xslt
	<xsl:apply-templates select="myMediaProperty" mode="media">
		<xsl:with-param name="cropset" select="'mycropsetname'" />
		<xsl:with-param name="quality" select="85" />
		</xsl:apply-templates>
	```

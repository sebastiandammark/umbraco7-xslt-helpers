# MultiNodeTreePicker Helper

Helper file for rendering MultiNodeTreePickers(MNTP):

## How to use it

1. Include this file in your main XSLT file:

	```xslt
	<xsl:include href="_MultiNodePreePicker.xslt" />
	```
	
2. Create templates as usual for the types of nodes that are selectable in the picker, e.g.:

	```xslt
	<xsl:template match="mydocument">
		<!-- Code for mydocument -->
	</xsl:template>
	```

3. Apply templates in "mntp" mode, to the MNTP property:

	```xslt
	<xsl:template match="myMNTPProperty" mode="mntp" />
	```
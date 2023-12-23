<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:include href="NAL-MARC21slim_MODS3-7_XSLT2-0-075.xsl"/>
    <!-- 
		Maintenance note: For each revision, change the content of <recordInfo><recordOrigin> to reflect the new revision number.
	    MARC21slim2MODS3-7

		NAL Revision Start
		
		MODS 3.7 (Revision 2.XX) 20231016
		Revision 2.54 - Added result document function to marc:collection|marc:record mode="root" template  
  -->		
    <xsl:template match="/">
        <xsl:apply-templates mode="root">
            <xsl:with-param name="workingDir"/>
            <xsl:with-param name="originalFile"/>
        </xsl:apply-templates>
    </xsl:template>
</xsl:stylesheet>
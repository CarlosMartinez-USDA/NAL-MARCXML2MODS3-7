<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs marc" version="2.0">

    <xsl:output version="1.0" encoding="UTF-8" method="xml" indent="yes"/>
   
    <xsl:template match="/">
        <xsl:result-document encoding="UTF-8" version="1.0" method="xml" media-type="text/xml"
            indent="yes" href="{replace(base-uri(),'(.*/)(.*)(\.xml)','$1')}N-{replace(base-uri(),'(.*/)(.*)(\.xml)','$2')}_{position()}.xml">
        <collection>
            <xsl:for-each select="collection/record">
                <xsl:text>&#10;</xsl:text>
                <!--Record count comment between each record-->
                <xsl:comment>
                    <xsl:value-of select="concat('Record: ', position())"/>
                </xsl:comment>
                <xsl:text>&#10;</xsl:text>
                <xsl:copy>
                    <xsl:copy-of select="(node() | @*)"/>
                </xsl:copy>
            </xsl:for-each>
        </collection>
        </xsl:result-document>
    </xsl:template>

    <!--<xsl:template match="(node() | @*)">
        <xsl:copy-of select="(node() | @*)"/>
    </xsl:template>
    -->
</xsl:stylesheet>

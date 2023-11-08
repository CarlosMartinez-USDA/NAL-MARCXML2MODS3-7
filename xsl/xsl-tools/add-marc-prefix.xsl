<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns="http://www.loc.gov/MARC21/slim" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:f="http://functions" xmlns:marc="http://www.loc.gov/MARC21/slim"
    xmlns:saxon="http://saxon.sf.net/" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.loc.gov/MARC21/slim https://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd"
    exclude-result-prefixes="f marc saxon xd xs xsi">
    <xsl:output encoding="UTF-8" indent="yes" method="xml" version="1.0" name="unprefixed"/>

    <!-- includes -->
    <xsl:include href="../../NAL-MARC21slimUtils.xsl"/>
    <xd:doc scope="stylesheet">
        <xd:desc>
        <xd:p><xd:b>Created on:</xd:b> January 23, 2023</xd:p>
        <xd:p><xd:b>Author:</xd:b> Carlos Martinez</xd:p>            
        <xd:p><xd:b>Purpose:</xd:b>Adds the marc prefix and namespace to unprefixed elements.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="/">
        <xsl:variable name="in-xml" select="//record" as="node()*"/>
        <xsl:result-document encoding="UTF-8" version="1.0" method="xml" media-type="text/xml"
            indent="yes" format="unprefixed"
            href="{replace(base-uri(), '(.*/)(.*)(\.xml)', '$1')}prefixed-{replace(base-uri(), '(.*/)(.*)(\.xml)', '$2')}_{position()}.xml">
            <marc:collection>
                <xsl:for-each select="//record">
                    <xsl:copy-of
                        select="f:add-namespace-prefix($in-xml, 'http://www.loc.gov/MARC21/slim', 'marc')"
                    />
                </xsl:for-each>
            </marc:collection>
        </xsl:result-document>
    </xsl:template>

    <xd:doc>
        <xd:desc>Identity template</xd:desc>
    </xd:doc>
    <xsl:template match="node() | @*">
        <xsl:copy-of select="node() | @*"/>
    </xsl:template>


</xsl:stylesheet>

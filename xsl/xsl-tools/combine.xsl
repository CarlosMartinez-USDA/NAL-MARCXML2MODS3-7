<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns="http://www.loc.gov/mods/v3"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" 
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    exclude-result-prefixes="xd xlink xs xsi" >
    <xsl:output name="combine" method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> January 23, 2023</xd:p>
            <xd:p><xd:b>Author:</xd:b> Carlos Martinez</xd:p>            
            <xd:p><xd:b>Purpose:</xd:b>Combines XML documents with &lt;modsCollection&gt; as the document node</xd:p>
            <xd:ul>
                <xd:li>1. Open or build the collections-index.xml document.*</xd:li>
                <xd:li>2. Using collections-index.xml and combine-mods.xsl, configure a new transformation scenario.</xd:li>
                <xd:li>3. Run the transformation scenario</xd:li>
            </xd:ul>
            <xd:p>*For information on constructing the collections-index.xml, please refer to the README.md</xd:p></xd:desc>        
        <xd:param name="fileName">
            <xd:p>Tokenizes forward slashes found within the base-uri()'s file/directory path structure. Upon reaching the last forward slash, the expath processes the instruction subract 4 directories backwards. 
                This original file name from part fo the nested directory name </xd:p>
        </xd:param>
        <xd:param name="fileNumber">
            <xd:p>Tokenizes forward slashes found within the base-uri()'s file/directory path structure. Upon reaching the last forward slash, the expath processes the instruction subract 4 directories backwards. 
                Uses the replace function to select only the file number from the whole file name to accuractetly name the output file.</xd:p>
        </xd:param>
        <xd:param name="workingDir"/>
    </xd:doc>
    <xsl:template match="/">  
        <xsl:param name="fileName" select="replace(tokenize(base-uri(), '/')[last()-4], '(.*)(\.mrc)(.*)', '$1')"/>
        <xsl:param name="fileNumber" select="replace(tokenize(base-uri(), '/')[last()-4],'(.*_new_)(\d+)(_folder)', '$2')"/>
        <xsl:param name="workingDir" select="substring-before(base-uri(), tokenize(base-uri(), '/')[last()])"/>
        <xsl:choose>
            <xsl:when test="starts-with($fileName, 'IND')">
                <xsl:result-document exclude-result-prefixes="xd xlink xs xsi" 
                    method="xml" version="1.0" encoding="UTF-8" indent="yes" 
                    format="combine" href="{$workingDir}recompile/N-agricola_IND_Jan24_{$fileNumber}.mods.xml"> 
                    <modsCollection xmlns="http://www.loc.gov/mods/v3"
                        xmlns:mods="http://www.loc.gov/mods/v3"
                        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                        xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-7.xsd">
                        <xsl:copy-of copy-namespaces="no" select="document(collection/doc/@href)/mods:modsCollection/mods:mods"/>
                    </modsCollection>
                </xsl:result-document>
            </xsl:when>
            <xsl:otherwise>
                <xsl:result-document exclude-result-prefixes="xd xlink xs xsi" 
                    method="xml" version="1.0" encoding="UTF-8" indent="yes" 
                    format="combine" href="{$workingDir}recompile/N-{$fileName}.mods.xml"> 
                    <modsCollection xmlns="http://www.loc.gov/mods/v3" 
                        xmlns:mods="http://www.loc.gov/mods/v3"
                        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                        xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-7.xsd">
                        <xsl:copy-of copy-namespaces="no" select="document(collection/doc/@href)/mods:modsCollection/mods:mods"/>
                    </modsCollection>
                </xsl:result-document>                    
            </xsl:otherwise>
        </xsl:choose>            
    </xsl:template>
</xsl:stylesheet>
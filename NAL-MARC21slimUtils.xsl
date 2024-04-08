<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0" xmlns:err="http://www.w3.org/2005/xqt-errors" xmlns:f="http://functions" xmlns:info="info:lc/xmlns/codelist-v1" xmlns:isolang="http://isolanguages" xmlns:local="http://www.local.gov/namespace" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:marccountry="http://www.local.gov/marc/countries" xmlns:nalsubcat="http://nal-subject-category-codes" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="err f info isolang local marc marccountry nalsubcat xd xlink xs">
    <xd:doc scope="stylesheet" id="Institution-id-LC">
        <xd:desc>
            <xd:p><xd:b>XSLT 1.0 templates</xd:b></xd:p>
            <xd:p><xd:b>Created on:</xd:b>August, 19, 2004</xd:p>
            <xd:p><xd:b>Author:</xd:b>Nate Trail</xd:p>
            <xd:p><xd:b>XSLT 2.0 functions</xd:b></xd:p>
            <xd:p><xd:b>Modified on:</xd:b>December, 14, 2007</xd:p>
            <xd:p><xd:b>Author:</xd:b>Nate Trail</xd:p>
            <xd:p><xd:b>Modified on:</xd:b>August 8, 2008</xd:p>
        </xd:desc>
        <xd:desc>
            <xd:p><xd:b>NAL XSLT functions</xd:b></xd:p>
            <xd:p><xd:b>Created on:</xd:b>October 27, 2022</xd:p>
            <xd:p><xd:b>Author</xd:b>Carlos Martinez III</xd:p>
        </xd:desc>
    </xd:doc>

    <!-- 08/08/08: tmee added corrected chopPunctuation templates for 260c -->
    <!-- 08/19/04: ntra added "marc:" prefix to datafield element -->
    <!-- 12/14/07: ntra added url encoding template -->
    <!-- 02/16/23: cmartinez updated datafield, subfieldSelec and specialSubfieldSelect templates to conditonally process both prefixed and non-prefixed elements. -->
    <!-- 05/22/23: cmartinez added alpha to use in functions (e.g., using translate to remove letters from page #'s) -->
 
    <!-- url encoding -->

    <xsl:variable name="ascii">
        <xsl:text> !"#$%&amp;'()*+,-./0123456789:;&lt;=&gt;?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~</xsl:text>
    </xsl:variable>

    <xsl:variable name="latin1">
        <xsl:text> ¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ</xsl:text>
    </xsl:variable>
    <!-- Characters that usually don't need to be escaped -->
    <xsl:variable name="safe">
        <xsl:text>!'()*-.0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz~</xsl:text>
    </xsl:variable>

    <xsl:variable name="hex">0123456789ABCDEF</xsl:variable>
    <xsl:variable name="alpha">ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-|. '~</xsl:variable>
    
    <!-- builds datafield template-->
    <xd:doc>
        <xd:desc>datafield</xd:desc>
        <xd:param name="tag"/>
        <xd:param name="ind1"/>
        <xd:param name="ind2"/>
        <xd:param name="subfields"/>
    </xd:doc>
    <xsl:template name="datafields">
        <xsl:param name="tag"/>
        <xsl:param name="ind1">
            <xsl:text> </xsl:text>
        </xsl:param>
        <xsl:param name="ind2">
            <xsl:text> </xsl:text>
        </xsl:param>
        <xsl:param name="subfields"/>
        <xsl:choose>
            <!-- prefixed -->
            <xsl:when test="marc:datafield">
                <xsl:element name="marc:datafield">
                    <xsl:attribute name="tag">
                        <xsl:value-of select="$tag"/>
                    </xsl:attribute>
                    <xsl:attribute name="ind1">
                        <xsl:value-of select="$ind1"/>
                    </xsl:attribute>
                    <xsl:attribute name="ind2">
                        <xsl:value-of select="$ind2"/>
                    </xsl:attribute>
                    <xsl:copy-of select="$subfields"/>
                </xsl:element>
            </xsl:when>
            <!-- non-prefixed-->
            <xsl:otherwise>
                <xsl:element name="datafield">
                    <xsl:attribute name="tag">
                        <xsl:value-of select="$tag"/>
                    </xsl:attribute>
                    <xsl:attribute name="ind1">
                        <xsl:value-of select="$ind1"/>
                    </xsl:attribute>
                    <xsl:attribute name="ind2">
                        <xsl:value-of select="$ind2"/>
                    </xsl:attribute>
                    <xsl:copy-of select="$subfields"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- builds subfield select -->
    <xd:doc>
        <xd:desc/>
        <xd:param name="codes"/>    
        <xd:param name="delimiter"/>
    </xd:doc>
    <xsl:template name="subfieldSelect">
        <xsl:param name="codes">abcdefghijklmnopqrstuvwxyz01</xsl:param>
        <xsl:param name="delimiter">
            <xsl:text> </xsl:text>
        </xsl:param>
        <xsl:variable name="str">
            <xsl:choose>                
                <!-- prefixed -->
                <xsl:when test="marc:subfield">
                    <xsl:for-each select="marc:subfield">
                        <xsl:if test="contains($codes, @code)">
                            <xsl:value-of select="text()"/>
                            <xsl:value-of select="$delimiter"/>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>                    
                    <!-- non-prefixed -->
                    <xsl:for-each select="subfield">
                        <xsl:if test="contains($codes, @code)">
                            <xsl:value-of select="text()"/>
                            <xsl:value-of select="$delimiter"/>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="substring($str, 1, string-length($str) - string-length($delimiter))"/>
    </xsl:template>
    
    <xd:doc>
        <xd:desc/>
        <xd:param name="anyCodes"/>
        <xd:param name="axis"/>
        <xd:param name="beforeCodes"/>
        <xd:param name="afterCodes"/>
    </xd:doc>
    <xsl:template name="specialSubfieldSelect">
        <xsl:param name="anyCodes"/>
        <xsl:param name="axis"/>
        <xsl:param name="beforeCodes"/>
        <xsl:param name="afterCodes"/>
        <xsl:variable name="str">
            <xsl:for-each select="marc:subfield|subfield">
                <xsl:if test="contains($anyCodes, @code) or (contains($beforeCodes, @code) and following-sibling::marc:subfield[@code = $axis]) or (contains($afterCodes, @code) and preceding-sibling::marc:subfield[@code = $axis])">
                    <xsl:value-of select="text()"/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
    </xsl:template>
    
    <xd:doc>
        <xd:desc/>
        <xd:param name="spaces"/>
        <xd:param name="char"/>
    </xd:doc>
    <xsl:template name="buildSpaces">
        <xsl:param name="spaces"/>
        <xsl:param name="char">
            <xsl:text> </xsl:text>
        </xsl:param>
        <xsl:if test="$spaces > 0">
            <xsl:value-of select="$char"/>
            <xsl:call-template name="buildSpaces">
                <xsl:with-param name="spaces" select="$spaces - 1"/>
                <xsl:with-param name="char" select="$char"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xd:doc>
        <xd:desc/>
        <xd:param name="chopString"/>
        <xd:param name="punctuation"/>
    </xd:doc>
    <xsl:template name="chopPunctuation">
        <xsl:param name="chopString"/>
        <xsl:param name="punctuation">
            <xsl:text>.:,;/ </xsl:text>
        </xsl:param>
        <xsl:variable name="length">
            <xsl:sequence select="string-length($chopString)"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$length = 0"/>
            <xsl:when test="contains($punctuation, substring($chopString, $length, 1))">
                <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString" select="substring($chopString, 1, $length - 1)"/>
                    <xsl:with-param name="punctuation" select="$punctuation"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="not($chopString)"/>
            <xsl:otherwise>
                <xsl:value-of select="$chopString"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xd:doc>
        <xd:desc/>
        <xd:param name="chopStrings"/>
        <xd:param name="punctuation"/>
    </xd:doc>
    <xsl:template name="chopPunctuationStrings">
        <xsl:param name="chopStrings"/>
        <xsl:param name="punctuation">
            <xsl:text>.:,;/ </xsl:text>
        </xsl:param>
        
        <xsl:for-each select="$chopStrings">
            <xsl:variable name="chopString" select="."/>
            <xsl:variable name="length" select="string-length($chopString)"/>
            <xsl:choose>
                <xsl:when test="$length = 0"/>
                <xsl:when test="contains($punctuation, substring($chopString, $length, 1))">
                    <xsl:call-template name="chopPunctuation">
                        <xsl:with-param name="chopString" select="substring($chopString, 1, $length - 1)"/>
                        <xsl:with-param name="punctuation" select="$punctuation"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="not($chopString)"/>
                <xsl:otherwise>
                    <xsl:value-of select="$chopString"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc/>
        <xd:param name="chopString"/>
    </xd:doc>
    <xsl:template name="chopPunctuationFront">
        <xsl:param name="chopString"/>
        <xsl:variable name="length" select="string-length($chopString)"/>
        <xsl:choose>
            <xsl:when test="$length = 0"/>
            <xsl:when test="contains('.:,;/[ ', substring($chopString, 1, 1))">
                <xsl:call-template name="chopPunctuationFront">
                    <xsl:with-param name="chopString" select="substring($chopString, 2, $length - 1)"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="not($chopString)"/>
            <xsl:otherwise>
                <xsl:value-of select="$chopString"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xd:doc>
        <xd:desc/>
        <xd:param name="chopString"/>
        <xd:param name="punctuation"/>
    </xd:doc>
    <xsl:template name="chopPunctuationBack">
        <xsl:param name="chopString"/>
        <xsl:param name="punctuation">
            <xsl:text>.:,;/] </xsl:text>
        </xsl:param>
        <xsl:variable name="length" select="string-length($chopString)"/>
        <xsl:choose>
            <xsl:when test="$length = 0"/>
            <xsl:when test="contains($punctuation, substring($chopString, $length, 1))">
                <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString" select="substring($chopString, 1, $length - 1)"/>
                    <xsl:with-param name="punctuation" select="$punctuation"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="not($chopString)"/>
            <xsl:otherwise>
                <xsl:value-of select="$chopString"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc> nate added 12/14/2007 for lccn.loc.gov: url encode ampersand, etc. </xd:desc>
        <xd:param name="str"/>
    </xd:doc>
    <xsl:template name="url-encode">
        <xsl:param name="str"/>        
        <xsl:if test="$str">
            <xsl:variable name="first-char" select="substring($str, 1, 1)"/>
            <xsl:choose>
                <xsl:when test="contains($safe, $first-char)">
                    <xsl:value-of select="$first-char"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="codepoint">
                        <xsl:choose>
                            <xsl:when test="contains($ascii, $first-char)">
                                <xsl:value-of select="string-length(substring-before($ascii, $first-char)) + 32"/>
                            </xsl:when>
                            <xsl:when test="contains($latin1, $first-char)">
                                <xsl:value-of select="string-length(substring-before($latin1, $first-char)) + 160"/>
                                <!-- was 160 -->
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:message terminate="no">Warning: string contains a character
                                    that is out of range! Substituting "?".</xsl:message>
                                <xsl:text>63</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="hex-digit1" select="substring($hex, floor($codepoint div 16) + 1, 1)"/>
                    <xsl:variable name="hex-digit2" select="substring($hex, $codepoint mod 16 + 1, 1)"/>
                    <!-- <xsl:value-of select="concat('%',$hex-digit2)"/> -->
                    <xsl:value-of select="concat('%', $hex-digit1, $hex-digit2)"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="string-length($str) &gt; 1">
                <xsl:call-template name="url-encode">
                    <xsl:with-param name="str" select="substring($str, 2)"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    
    <!-- XSLT 2.0 functions -->
    
    <xd:doc>
        <xd:desc>  
			<xd:p>Strips punctuation from the last character of a field.</xd:p>
			<xd:p>To extend add any additional punctuation to the punctuation variable</xd:p>
			<xd:p>$str: string to be analyzed</xd:p>
        </xd:desc>
        <xd:param name="str"/>
    </xd:doc>
    <xsl:function name="local:stripPunctuation">
        <xsl:param name="str"/>
        <xsl:variable name="punctuation">.:,;/ </xsl:variable>
        <!-- isolates end of string -->
        <xsl:variable name="strEnd">
            <xsl:value-of select="substring($str, (string-length($str)))"/>
        </xsl:variable>
        <!-- isolates last three characters in string tests for initials -->
        <xsl:variable name="initialTest">
            <xsl:variable name="lastChars" select="substring($str, (string-length($str)) - 2)"/>
            <xsl:choose>
                <xsl:when test="matches($lastChars, '^([.][A-Z][.])')">true</xsl:when>
                <xsl:when test="matches($lastChars, '^([ ][A-Z][.])')">true</xsl:when>
                <xsl:when test="matches($lastChars, '^([.][.][.])')">true</xsl:when>
                <xsl:otherwise>false</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="contains($punctuation, $strEnd)">
                <xsl:choose>
                    <!-- if ends with initials or ellipse then leave, otherwise remove ending punctuation -->
                    <xsl:when test="$initialTest = 'true'">
                        <xsl:value-of select="$str"/>
                    </xsl:when>
                    <!-- if ends with multiple punctiation -->
                    <xsl:when test="matches(substring($str, (string-length($str)) - 3), '([.:,;/][ ][.:,;/])')">
                        <xsl:value-of select="substring($str, 1, string-length($str) - 3)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$str"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    
    <xd:doc>
        <xd:desc> 
            <xd:p>Strips punctuation from the last character of a field, this version accepts two parameters:</xd:p>
            <xd:p>$str: string to be striped</xd:p>
            <xd:p>$pcodes: optional punctuation to override the defualt, if empty uses defualts</xd:p>
        </xd:desc>
        <xd:param name="str"/>
        <xd:param name="pcodes"/>
    </xd:doc>
    <xsl:function name="f:stripPunctuation" xmlns:f="http://functions">
        <xsl:param name="str"/>
        <xsl:param name="pcodes"/>
        <xsl:variable name="punctuation">
            <xsl:choose>
                <xsl:when test="$pcodes = ''">.:,;/ </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$pcodes"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="strEnd">
            <xsl:value-of select="substring($str, (string-length($str)))"/>
        </xsl:variable>
        <xsl:variable name="initialTest">
            <xsl:variable name="lastChars" select="substring($str, (string-length($str)) - 1)"/>
            <xsl:choose>
                <xsl:when test="matches($lastChars, '^([.][A-Z][.])')">true</xsl:when>
                <xsl:when test="matches($lastChars, '^([ ][A-Z][.])')">true</xsl:when>
                <xsl:when test="matches($lastChars, '^([.][.][.])')">true</xsl:when>
                <xsl:otherwise>false</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="contains($punctuation, $strEnd)">
                <xsl:choose>
                    <xsl:when test="$initialTest = 'true'">
                        <xsl:value-of select="$str"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$str"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    
    <xd:doc>
        <xd:desc> 
            <xd:p>Concats specified subfields in order they appear in marc record</xd:p>
            <xd:p>Two prameters</xd:p>
            <xd:p>$datafield: marc:datafield node to use for processing</xd:p>
            <xd:p>$codes: list of subfield codes, no spaces</xd:p>
        </xd:desc>
        <xd:param name="datafield"/>
        <xd:param name="codes"/>
    </xd:doc>
    <xsl:function name="f:subfieldSelect" xmlns:f="http://functions">
        <xsl:param name="datafield" as="node()"/>
        <xsl:param name="codes"/>
        <!-- Selects and prints out datafield -->
        <xsl:variable name="str">
            <xsl:for-each select="$datafield/child::*[contains($codes, @code)]">
                <xsl:value-of select="concat(., ' ')"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
    </xsl:function>
    
    
    <xd:doc>
        <xd:desc>
            <xd:p>Concats specified subfields in order they appear in marc record with specified delimiter. </xd:p>
            <xd:p>Three parameters $datafield: marc:datafield node to use for processing</xd:p>
            <xd:p>$codes: list of subfield codes, no spaces $delimiter: delimiter to use when concating</xd:p>
            <xd:p>subfields, if empty a space is used</xd:p></xd:desc>
        <xd:param name="codes"/>
        <xd:param name="delimiter"/>
        <xd:param name="datafield"/>
    </xd:doc>
    <xsl:function name="local:subfieldSelect">
        <xsl:param name="datafield" as="node()"/>
        <xsl:param name="codes"/>
        <xsl:param name="delimiter"/>
        <xsl:variable name="delimStr">
            <xsl:choose>
                <xsl:when test="$delimiter = ''">
                    <xsl:value-of select="' '"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$delimiter"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- Selects and prints out datafield -->
        <xsl:variable name="str">
            <xsl:for-each select="$datafield/child::*[contains($codes, @code)]">
                <xsl:value-of select="concat(., $delimStr)"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
    </xsl:function>
    
    
    <xd:doc>
        <xd:desc> 
            <xd:p>Concats specified subfields based on siblings</xd:p>
            <xd:p>$anyCode: the subfield you want to select on</xd:p>
            <xd:p>$axis: the that beforeCodes and afterCodes are computed</xd:p>
            <xd:p>$beforeCodes: subfields that occure before the axis</xd:p>
            <xd:p>$afterCodes: subfields that occure after the axis</xd:p>
        </xd:desc>
        <xd:param name="datafield"/>
        <xd:param name="anyCodes"/>
        <xd:param name="axis"/>
        <xd:param name="beforeCodes"/>
        <xd:param name="afterCodes"/>
    </xd:doc>
    <xsl:function name="local:specialSubfieldSelect">
        <xsl:param name="datafield" as="node()"/>
        <xsl:param name="anyCodes"/>
        <xsl:param name="axis"/>
        <xsl:param name="beforeCodes"/>
        <xsl:param name="afterCodes"/>
        <xsl:variable name="subfieldStr">
            <xsl:for-each select="$datafield/marc:subfield">
                <xsl:if test="
                    contains($anyCodes, @code)
                    or (contains($beforeCodes, @code) and following-sibling::marc:subfield[@code = $axis])
                    or (contains($afterCodes, @code) and preceding-sibling::marc:subfield[@code = $axis])">
                    <xsl:value-of select="text()"/>
                    <xsl:text> </xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="substring($subfieldStr, 1, string-length($subfieldStr) - 1)"/>
    </xsl:function>
    


  

    <!--NAL Custom Functions by Carlos Martinez III-->

    <xd:doc scope="stylesheet" id="nal-local-functions">
        <xd:desc>
            <xd:p><xd:d>created on:</xd:d>October 27, 2022</xd:p>
            <xd:p><xd:b>Creator:</xd:b>Carlos Martinez III</xd:p>
            <xd:p><xd:b>email:</xd:b>carlos.martinez2@usda.gov</xd:p>
            <xd:p><xd:b>modified on:</xd:b>January 14, 2023</xd:p>
            <xd:p>
                <xd:b>NAL Custom XSLT Functions:</xd:b>
            </xd:p>
            <xd:p>
                <xd:ul>
                    <xd:li>
                        <xd:i>1.<xd:ref name="f:add-namespace-prefix" type="function"/>f:add-namespace-prefix</xd:i>
                    </xd:li>
                    <xd:li>
                        <xd:i>2.<xd:ref name="f:subjCatCode" type="function"/>f:subjCatCode</xd:i>
                    </xd:li>
                    <xd:li>
                        <xd:i>3.<xd:ref name="info:marcCountry">info:marcCountry</xd:ref>
                            <xd:note name="f:decodeMARCCountry" type="function">Revised f:decodeMARCCountry to reference https://www.loc.gov/standards/codelists/countries.xml</xd:note></xd:i>
                    </xd:li>
                    <xd:li>
                        <xd:i>4.<xd:ref name="f:f:isoTwo2Lang" type="function"/>f:isoTwo2Lang</xd:i>
                    </xd:li>
                    <xd:li>
                        <xd:i>5.<xd:ref name="f:isoOne2Two" type="function"/>f:isoOne2Two</xd:i>
                    </xd:li>
                    <xd:li>
                        <xd:i>6.<xd:ref name="f:capitalize-first" type="function"/>f:capitalize-first</xd:i>
                    </xd:li>
                    <xd:li>
                        <xd:i>7.<xd:ref name="f:sentence-case" type="function"/>f:sentence-case</xd:i>
                    </xd:li>
                    <xd:li>
                        <xd:i>8.<xd:ref name="f:f:proper-case" type="function"/>f:f:proper-case</xd:i>
                    </xd:li>
                    <xd:li>
                        <xd:i>9.<xd:ref name="f:substring-before-match" type="function"/>f:substring-before-match</xd:i>
                    </xd:li>
                    <xd:li>
                        <xd:i>10.<xd:ref name="f:nameIdAttr" type="function"/>f:nameIdentifier</xd:i>
                    </xd:li>
                    <xd:li>
                        <xd:i>11.<xd:ref name="f:isNumber" type="function"/>f:isNumber</xd:i>
                    </xd:li>
                    <xd:li>
                        <xd:i>12.<xd:ref name="f:modsTotalPages" type="function"/>f:modsTotalPages</xd:i>
                    </xd:li>
                    <xd:li>
                        <xd:i>13.<xd:ref name="f:percentEncode" type="function"/>f:percentEncode</xd:i>
                    </xd:li>
                    <xd:li>
                        <xd:i>14.<xd:ref name="f:punctuation-trim" type="function"/>f:punctuation-trim</xd:i>
                    </xd:li>
                </xd:ul>
            </xd:p>
        </xd:desc>
    </xd:doc>

    <!--f:add-namespace-prefix-->
    <xd:doc id="f:add-namespace-prefix" scope="component">
        <xd:desc>
            <xd:p><xd:b>Function: </xd:b>f:add-namespace-prefix</xd:p>
            <xd:p><xd:b>Usage: </xd:b>f:add-namespace-prefix([nodes],[namespace to add],[added namespace prefix])</xd:p>
            <xd:p><xd:b>Purpose: </xd:b>Calculate the total page count if the first and last pages are present and are integers</xd:p>
        </xd:desc>
        <xd:param name="elements">the nodes to change the element prefix</xd:param>
        <xd:param name="add-namespace">declare no namespace</xd:param>
        <xd:param name="add-prefix">adds the namespace prefix</xd:param>
    </xd:doc>
    <xsl:function name="f:add-namespace-prefix" as="node()*" xmlns:f="http://functions">
        <xsl:param name="elements" as="node()*"/>
        <xsl:param name="add-namespace" as="xs:string"/>
        <xsl:param name="add-prefix" as="xs:string"/>
        <xsl:for-each select="$elements">
            <xsl:variable name="element" select="."/>
            <xsl:choose>
                <xsl:when test="$element instance of element()">
                    <xsl:element name="{concat($add-prefix,
                        if ($add-prefix = '')
                        then ''
                        else ':',
                        local-name($element))}" namespace="{$add-namespace}">
                        <xsl:sequence select="
                                ($element/@*,
                                f:add-namespace-prefix($element/node(),
                                $add-namespace, $add-prefix))"/>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="$element instance of document-node()">
                    <xsl:document>
                        <xsl:sequence select="
                                f:add-namespace-prefix(
                                $element/node(), $add-namespace, $add-prefix)"/>
                    </xsl:document>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="$element"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:function>


    <!-- f:subjCatCode -->
    <xd:doc id="f:subjCatCode" scope="component">
        <xd:desc>
            <xd:p><xd:b>Function: </xd:b>f:subjCatCode</xd:p>
            <xd:p><xd:b>Usage: </xd:b>f:subjCatCode(xpath)</xd:p>
            <xd:p><xd:b>Purpose: </xd:b>The function maps NAL subject category codes (i.e., 072
                ind2=0, subfield a) to it's respective term found in Appendix D: NAL Subject
                Categrory Codes</xd:p>
        </xd:desc>
        <xd:param name="subjCode">Convert subject category codes (MARC 072$a) into NAL Subject Categories.</xd:param>
    </xd:doc>
    <xsl:function name="f:subjCatCode" as="xs:string">
        <xsl:param name="subjCode" as="xs:string"/>
        <xsl:variable name="subject_name">
            <xsl:variable name="nodes">
                <xsl:copy-of select="document('commons/xml/nalSubjCat.xml')"/>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$subjCode = ''"/>
                <xsl:otherwise>
                    <xsl:sequence select="$nodes/nalsubcat:agricola/nalsubcat:subject[nalsubcat:code = $subjCode]/nalsubcat:category"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:sequence select="$subject_name"/>
    </xsl:function>

     <!--f:decodeMARCCountry--> 
    <xd:doc id="f:decodeMARCCountry" scope="component">
        <xd:desc>
            <xd:p><xd:b>Function: </xd:b>f:decodeMARCCountry</xd:p>
            <xd:p><xd:b>Usage: </xd:b>f:decodeMARCCountry($marcCountryCode)</xd:p>
            <xd:p><xd:b>Purpose:</xd:b>Use an XML lookup file to match MARC Country Code</xd:p>
            <xd:p><xd:b>Returns:</xd:b> the proper state or country name from the
                controlfield[@tag='008']</xd:p>
        </xd:desc>
        <xd:b>variables &amp; parameters</xd:b>
        <xd:variable name="marcCountryCode">variable declared from the stylesheet.</xd:variable>
        <xd:param name="marccode">marcCountry code variable passes the two or three letter valued to
            the $marcCode parameter</xd:param>
    </xd:doc>
    <xsl:function name="f:decodeMARCCountry" as="xs:string">
        <xsl:param name="marccode" as="xs:string"/>
        <xsl:variable name="MARCcode">
            <xsl:variable name="nodes">
                <xsl:copy-of select="document('commons/xml/marcCountry.xml')"/>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$marccode = ''"/>
                <xsl:otherwise>
                    <xsl:value-of select="$nodes/marccountry:marcCountry/marccountry:value[marccountry:code = $marccode]/marccountry:country"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:sequence select="$MARCcode"/>
    </xsl:function>
    
    <!-- info:marcCountry -->
    <xd:doc id="info:marcCountry" scope="component">
        <xd:desc>
            <xd:p><xd:b>Function: </xd:b>info:MARCCountry</xd:p>
            <xd:p><xd:b>Usage: </xd:b>info:decodeMARCCountry($marcCountryCode)</xd:p>
            <xd:p><xd:b>Purpose:</xd:b>Uses LC's countries.xml as lookup file to match MARC Country Code</xd:p>
            <xd:p><xd:b>Returns:</xd:b> the proper state or country name from the controlfield[@tag='008']</xd:p>
        </xd:desc>
        <xd:b>parameters &amp; variables</xd:b>        
        <xd:param name="controlField008-15-17">marcCountry code variable passes the two or three letter valued to the $marcCode parameter</xd:param>
        <xd:variable name="country_name">variable declared from the stylesheet.</xd:variable>
    </xd:doc>
      <xsl:function name="info:marcCountry" as="xs:string" xmlns="info:lc/xmlns/codelist-v1">
          <xsl:param name="controlField008-15-17" as="xs:string"/><!-- control field 008, position 15-17--> 
        <xsl:variable name="country_name">
            <xsl:variable name="nodes">
                <xsl:copy-of select="document('http://www.loc.gov/standards/codelists/countries.xml')"/>
            </xsl:variable>
          <xsl:choose>
              <xsl:when test="$controlField008-15-17 = ''"/><!-- if empty, do not process --> 
              <xsl:otherwise>
                  <xsl:value-of select="$nodes/info:codelist/info:countries/info:country[info:code = $controlField008-15-17]/info:name"/>
              </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:sequence select="$country_name"/>
    </xsl:function>
    
    <!-- info:langCode -->
    <xd:doc scope="component">
        <xd:desc>
            <xd:p><xd:b>Function: </xd:b>info:langCode()</xd:p>
            <xd:p><xd:b>Usage: </xd:b>info:langCode(iso 639-2b code)</xd:p>
            <xd:p><xd:b>Purpose: </xd:b>Convert ISO 639-2b three-letter codes into the corresponding
                languages.</xd:p>
        </xd:desc>
        <xd:param name="langParam">three-letter language code to match against</xd:param>
    </xd:doc>
    <xsl:function name="info:langCode" as="xs:string" xmlns="info:lc/xmlns/codelist-v1">
        <xsl:param name="langParam"/>
        <xsl:variable name="langVar">
            <xsl:variable name="nodes">
                <xsl:copy-of select="document('https://www.loc.gov/standards/codelists/languages.xml')"/>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$langParam = ''"/>
                <xsl:otherwise>
                    <xsl:sequence select="$nodes/info:codelist/info:languages/info:language[info:code = $langParam]/info:name"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:sequence select="$langVar"/>
    </xsl:function>
    
    <!-- f:isoTwo2Lang -->
    <xd:doc scope="component">
        <xd:desc>
            <xd:p><xd:b>Function: </xd:b>f:isoTwo2Lang</xd:p>
            <xd:p><xd:b>Usage: </xd:b>f:isoTwo2Lang(iso 639-2b code)</xd:p>
            <xd:p><xd:b>Purpose: </xd:b>Convert ISO 639-2b three-letter codes into the corresponding
                languages.</xd:p>
        </xd:desc>
        <xd:param name="iso_639-2">three-letter language code to match against</xd:param>
    </xd:doc>
    <xsl:function name="f:isoTwo2Lang" as="xs:string" xmlns:f="http://functions">
        <xsl:param name="iso_639-2"/>
        <xsl:variable name="iso639-2b">
            <xsl:variable name="nodes">
                <xsl:copy-of select="document('commons/xml/iso639conversion.xml')"/>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$iso_639-2 = ''"/>
                <xsl:otherwise>
                    <xsl:sequence select="$nodes/isolang:iso_languages/isolang:iso_language[isolang:iso_639-2 = $iso_639-2]/isolang:language"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:sequence select="$iso639-2b"/>
    </xsl:function>

    <!--f:isoOne2Two-->
    <xd:doc scope="component">
        <xd:desc>
            <xd:p><xd:b>Function: </xd:b>f:isoOne2Two</xd:p>
            <xd:p><xd:b>Usage: </xd:b>f:isoOne2Two(iso 639-1 code)</xd:p>
            <xd:p><xd:b>Purpose: </xd:b>Convert ISO 639-1 two-letter codes into ISO 639-2b
                three-letter codes.</xd:p>
        </xd:desc>
        <xd:param name="iso_639-1">two-letter language code to match against</xd:param>
    </xd:doc>
    <xsl:function name="f:isoOne2Two" as="xs:string">
        <xsl:param name="iso_639-1"/>
        <xsl:variable name="nodes">
            <xsl:copy-of select="document('commons/xml/iso639conversion.xml')"/>
        </xsl:variable>
        <xsl:sequence select="$nodes/isolang:isolanguages/isolang:isolanguage[isolang:iso_639-1 = $iso_639-1]/isolang:iso_639-2"/>
    </xsl:function>


    <!--f:capitalize-first-->
    <xd:doc>
        <xd:desc>
            <xd:p><xd:b>Function: </xd:b>f:capitalize-first</xd:p>
            <xd:p><xd:b>Usage: </xd:b>f:capitalize-first(XPath)</xd:p>
            <xd:p><xd:b>Purpose: </xd:b>The f:capitalize-first function capitalizes the first
                character of $arg. If the first character is not a lowercase letter, $arg is left
                unchanged. It capitalizes only the first character of the entire string, not the
                first letter of every word<xd:i>f:capitalize-first</xd:i></xd:p>
        </xd:desc>
        <xd:param name="arg"/>
    </xd:doc>
    <xsl:function name="f:capitalize-first" as="xs:string?" xmlns:f="http://functions">
        <xsl:param name="arg" as="xs:string?"/>
        <xsl:sequence select="
                concat(upper-case(substring($arg, 1, 1)),
                substring($arg, 2))
                "/>
    </xsl:function>

    <!--f:sentence-case-->
    <xd:doc>
        <xd:desc>
            <xd:p><xd:b>Function: </xd:b>f:sentence-case</xd:p>
            <xd:p><xd:b>Usage: </xd:b>f:sentence-case(XPath)</xd:p>
            <xd:p><xd:b>Purpose:</xd:b>The f:sentence-case function treats a string like two
                parts; the first character of $arg is capitalized, the rest of the string is
                lowercase. (e.g. "STRING THEORY" ---> "String theory"). Thus, even if the second
                letter of $arg is not a lowercase letter, the rest of the string is still lowercase.
            </xd:p>
        </xd:desc>
        <xd:param name="arg"/>
    </xd:doc>
    <xsl:function name="f:sentence-case" as="xs:string?" xmlns:f="http://functions">
        <xsl:param name="arg" as="xs:string?"/>
        <xsl:sequence select="
                concat(upper-case(substring($arg, 1, 1)),
                lower-case(substring($arg, 2)))
                "/>
    </xsl:function>

    <!-- f:proper-case -->
    <xd:doc>
        <xd:desc>
            <xd:p><xd:b>Function: </xd:b>f:proper-case</xd:p>
            <xd:p><xd:b>Usage: </xd:b>f:proper-case(XPath)</xd:p>
            <xd:p><xd:b>Purpose: </xd:b>The f:proper-case function performs a "choose when" test
                first determining if a string contains two substrings, when it does, it capitalizes
                the first character of each substring. when it does not, it capitalizes the first
                character of the substring, and the rest of the string is lowercase, making use of
                    <xd:i>f:proper-case</xd:i>function in both instances</xd:p>
            <xd:p>
                <xd:b>Parameters</xd:b>
            </xd:p>
        </xd:desc>
        <xd:param name="arg"/>
    </xd:doc>
    <xsl:function name="f:proper-case" xmlns:f="http://functions">
        <xsl:param name="arg" as="xs:string?"/>
        <xsl:variable name="otherChars" as="item()*" select="f:substring-before-match($arg,'\-|[A-Z].[A-Z].|\s')"/>
        <xsl:variable name="white-space" as="xs:string" select="(' ')"/>
        <xsl:variable name="substring-1a" select="substring-before($arg, $white-space)"/>
        <xsl:variable name="substring-1b" select="substring-after($arg, $white-space)"/>
        <xsl:variable name="substring-2a" select="substring-before($arg, $white-space)"/>
        <xsl:variable name="substring-2b" select="substring-after($arg, $white-space)"/>
        <xsl:sequence select="
                if (contains($arg, $otherChars))
                then concat(f:sentence-case($substring-1a), ($otherChars), (f:sentence-case($substring-1b)))
                else if (contains($arg, $white-space))
                then concat(f:sentence-case($substring-2a), ($white-space), (f:sentence-case($substring-2b)))
                else f:sentence-case($arg)"/>
    </xsl:function>

    <!-- f:substring-before-match -->
    <xd:doc>
        <xd:desc/>
        <xd:param name="arg"/>
        <xd:param name="regex"/>
    </xd:doc>
    <xsl:function name="f:substring-before-match" as="xs:string" xmlns:f="http://functions">
        <xsl:param name="arg" as="xs:string?"/>
        <xsl:param name="regex" as="xs:string"/>
        <xsl:sequence select="tokenize($arg, $regex)[1]"/>
    </xsl:function>

    <!-- nal:nameIdentifier -->
    <xd:doc>
        <xd:desc>
            <xd:p><xd:b>Function: </xd:b>f:typeIdentifier</xd:p>
            <xd:p><xd:b>Usage: </xd:b>f:typeIdentifier(XPath)</xd:p>
            <xd:p><xd:b>Purpose: </xd:b>The f:typeIdentifier xpath is passed to the $uri param.
                The sequunce select uses the fn:matches($uri, $regex) tests the $arg. If $arg matches the $regex, then
                fn:replace($uri, $regex, $flag),</xd:p>
            <xd:p><xd:b>Returns: </xd:b> Removes the first and last substrings, leaving the org
                name.</xd:p>
            <xd:p>
                <xd:b>Parameters</xd:b>
            </xd:p>
        </xd:desc>
        <xd:param name="uri"/>
        <xd:variable name="id">
           <xd:p>uses fn:replace to break up the uri and determine the uncontrolled identifier informtion to put into the type attribute.</xd:p>
        </xd:variable>
    </xd:doc>
    <xsl:function name="f:nameIdentifier" as="xs:string" xmlns:f="http://functions">
        <xsl:param name="uri" as="xs:string"/>
        <xsl:variable name="id" select="replace($uri, '(^https?)://(www)?(\w+)((\.\w+)(\.\w+)?(\.\w+)?)/?(\S+)/?(\?uri=)?(.*)', '$3$4')"/>
        
        <xsl:sequence select="
            if (matches($uri, '^https?://(www)?[id|agclass|lod|entities]+\.[a-z]+\.[a-z]+(\.[a-z]+)?.*')) 
            then f:authority($id)
            else if ((contains($uri, 'orcid') or contains($uri, 'viaf') or  contains($uri, 'isni') or  matches($uri, '[a-z]+')) = true())
            then substring-before($id,'.')
            else $uri"/>           
    </xsl:function>
    
    <xd:doc>
        <xd:desc/>
        <xd:param name="authority"/>
    </xd:doc>
    <xsl:function name="f:authority" as="xs:string">
        <xsl:param name="authority" as="xs:string"/>
        <xsl:sequence select="if (contains($authority, 'loc'))
            then 'lcnaf'
            else if (contains($authority,'nlm'))
            then 'mesh'
            else ''"/>
    </xsl:function>
    
    <!-- f:isNumber -->
    <xd:doc>
        <xd:desc>
            <xd:p><xd:b>Function: </xd:b>f:isNumber</xd:p>
            <xd:p><xd:b>Usage: </xd:b>f:isNumber(xPath)</xd:p>
            <xd:p><xd:b>Purpose: </xd:b>The f:isNumber funcion tests and rounds parameters</xd:p>
            <xd:p><xd:b>Returns: </xd:b>True or False</xd:p></xd:desc>
        <xd:param name="value"/>
    </xd:doc>
    <xsl:function name="f:isNumber" as="xs:boolean" xmlns:f="http://functions">
        <xsl:param name="value" as="xs:anyAtomicType?"/>
        <xsl:sequence select="string(abs(number($value))) != 'NaN'"/>
    </xsl:function>
    
    <!-- f:modsTotalPages -->
    <xd:doc scope="component">
        <xd:desc>
            <xd:p><xd:b>Function: </xd:b>f:modsTotalPages</xd:p>
            <xd:p><xd:b>Usage: </xd:b>f:modsTotalPages([xpath/value for first page], [xpath/value for last page])</xd:p>
            <xd:p><xd:b>Purpose: </xd:b>Calculate the total page count if the first and last pages are present and are integers</xd:p>
        </xd:desc>
        <xd:param name="fpage">value or XPath for the first page</xd:param>
        <xd:param name="lpage">value or XPath for the last page</xd:param>
    </xd:doc>
    <xsl:function name="f:modsTotalPgs" xmlns:f="http://functions">
        <xsl:param name="fpage"/>
        <xsl:param name="lpage"/>
        <xsl:if test="(string(number($fpage)) != 'NaN' and string(number($lpage)) != 'NaN')">
            <total>
                <xsl:value-of select="number($lpage) - number($fpage) + 1"/>
            </total>
        </xsl:if>
    </xsl:function>
    
    <!-- f:percentEncode -->
    <xd:doc>
        <xd:desc>
            <xd:p><xd:b>Function: </xd:b>f:percentEncode</xd:p>
            <xd:p><xd:b>Usage: </xd:b>f:percentEncode($uris parameter])</xd:p>
            <xd:p><xd:b>Purpose: </xd:b>When the $uris parameter contains brackets, they are percent encoded to avoid invalid uri errors.</xd:p>
        </xd:desc>
        <xd:param name="uris"/>
    </xd:doc>
    <xsl:function name="f:percentEncode" xmlns:f="http://functions">
        <xsl:param name="uris"/>
        <xsl:for-each select="$uris">
            <xsl:variable name="uri" select="."/>
            <xsl:variable name="sub1" select="replace($uri, '\[','%5B')"/>
            <xsl:variable name="sub2" select="replace($sub1, '\]','%5D')"/>
        <xsl:sequence select="if (contains($uri, '[') or (contains($uri, ']')))
            then ($sub2) 
            else $uri"/>
        </xsl:for-each>
    </xsl:function>
    
    <xd:doc>
        <xd:desc>
            <xd:p><xd:b>Function: </xd:b>f:punctuation-trim</xd:p>
            <xd:p><xd:b>Usage: </xd:b>f:punctation-trim($punctuated)</xd:p>
            <xd:p><xd:b>Purpose: </xd:b>When the parameter contains brackets or other puntuation it is removed.</xd:p>
        </xd:desc>
        <xd:param name="punctuated"/>
    </xd:doc>
    <xsl:function name="f:punctuation-trim">
        <xsl:param name="punctuated"/>
        <xsl:variable name="punctuation_removed" select="translate($punctuated, '[]:;', '')"/>
        <xsl:for-each select="$punctuated">           
            <xsl:sequence select="if ($punctuated = '')
                                  then ($punctuated)
                                  else if(matches($punctuated,'(^.*)?[\[\]:;](.*$)?'))
                                  then (replace($punctuated, '(^.*)?[\[\]:;](.*$)?', '$1'))
                                  else $punctuation_removed"/>
        </xsl:for-each>
    </xsl:function>
</xsl:stylesheet>

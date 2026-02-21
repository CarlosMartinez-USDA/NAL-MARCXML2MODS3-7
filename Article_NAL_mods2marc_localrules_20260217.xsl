<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs mods xlink default xd f" version="2.0"
	xmlns:default="https://data.crossref.org/schemas/AccessIndicators.xsd"
	xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:mods="http://www.loc.gov/mods/v3"
	xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
	xmlns:f="http://functions">
	
	<xsl:output encoding="UTF-8" indent="yes" method="xml"/>
	<xsl:variable name="accessLookup" select="document('commons/licenses.xml')"/>
	<xsl:include href="commons/functions.xsl"/>

	<!-- updated field 100, 300, 700, by yli, axu 2019-06-27 -->
	
	<!-- Starting Template -->
	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="mods:mods">
		<marc:record>
			<marc:leader>
				<!-- 00-04 -->
				<xsl:text>     </xsl:text>
				<!-- 05 -->
				<!-- NAL: when Voyager bib_id exists, use 'c', otherwise 'n' -->
				<xsl:choose>
					<xsl:when test="mods:recordInfo/recordIdentifier">
						<xsl:text>c</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>n</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<!-- 06 -->
				<xsl:choose>
					<xsl:when test="mods:typeOfResource">
						<xsl:apply-templates mode="leader" select="mods:typeOfResource[1]"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>a</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<!-- 07 -->
				<xsl:choose>
					<xsl:when test="mods:originInfo/issuance = 'monographic'">m</xsl:when>
					<xsl:when test="mods:originInfo/issuance = 'continuing'">s</xsl:when>
					<xsl:when test="mods:typeOfResource/@collection = 'yes'">c</xsl:when>
					<!-- v3.4 Added mapping for single unit, serial, integrating resource, multipart monograph  -->
					<xsl:when test="mods:originInfo/mods:issuance = 'multipart monograph'"
						>m</xsl:when>
					<xsl:when test="mods:originInfo/mods:issuance = 'single unit'">m</xsl:when>
					<xsl:when test="mods:originInfo/mods:issuance = 'integrating resource'"
						>i</xsl:when>
					<xsl:when test="mods:originInfo/mods:issuance = 'serial'">s</xsl:when>
					<!-- NAL -->
					<xsl:otherwise>b</xsl:otherwise>
				</xsl:choose>
				<!-- 08 -->
				<xsl:text> </xsl:text>
				<!-- 09 NAL -->
				<xsl:text>a</xsl:text>
				<!-- 10 -->
				<xsl:text>2</xsl:text>
				<!-- 11 -->
				<xsl:text>2</xsl:text>
				<!-- 12-16 -->
				<xsl:text>     </xsl:text>
				<!-- 17 NAL -->
				<xsl:text> </xsl:text>
				<!-- 18 NAL -->
				<xsl:choose>
					<xsl:when test="mods:recordInfo/mods:descriptionStandard">
						<xsl:apply-templates mode="leader"
							select="mods:recordInfo/mods:descriptionStandard"/>
					</xsl:when>
					<xsl:otherwise>u</xsl:otherwise>
				</xsl:choose>

				<!-- 19 -->
				<xsl:text> </xsl:text>
				<!-- 20-23 -->
				<xsl:text>4500</xsl:text>
			</marc:leader>
			<xsl:call-template name="controlRecordInfo"/>
			<xsl:if test="mods:genre[@authority = 'marc'] = 'atlas'">
				<marc:controlfield tag="007">ad||||||</marc:controlfield>
			</xsl:if>
			<xsl:if test="mods:genre[@authority = 'marc'] = 'model'">
				<marc:controlfield tag="007">aq||||||</marc:controlfield>
			</xsl:if>
			<xsl:if test="mods:genre[@authority = 'marc'] = 'remote sensing image'">
				<marc:controlfield tag="007">ar||||||</marc:controlfield>
			</xsl:if>
			<xsl:if test="mods:genre[@authority = 'marc'] = 'map'">
				<marc:controlfield tag="007">aj||||||</marc:controlfield>
			</xsl:if>
			<xsl:if test="mods:genre[@authority = 'marc'] = 'globe'">
				<marc:controlfield tag="007">d|||||</marc:controlfield>
			</xsl:if>
			<marc:controlfield tag="008">
				<xsl:variable name="typeOf008">
					<xsl:apply-templates mode="ctrl008" select="mods:typeOfResource"/>
				</xsl:variable>
				<!-- 00-05 -->
				<xsl:choose>
					<!-- 1/04 fix -->
					<!-- NAL -->
					<xsl:when test="mods:recordInfo/mods:recordCreationDate[@encoding = 'w3cdtf']">
						<xsl:value-of
							select="substring(mods:recordInfo/mods:recordCreationDate, 3, 2)"/>
						<xsl:value-of
							select="substring(mods:recordInfo/mods:recordCreationDate, 6, 2)"/>
						<xsl:value-of
							select="substring(mods:recordInfo/mods:recordCreationDate, 9, 2)"/>
					</xsl:when>
					<xsl:when test="mods:recordInfo/mods:recordCreationDate[@encoding = 'marc']">
						<xsl:value-of
							select="mods:recordInfo/mods:recordCreationDate[@encoding = 'marc']"/>
					</xsl:when>
					<xsl:when test="mods:recordInfo/mods:recordCreationDate">
						<xsl:value-of
							select="substring(mods:recordInfo/mods:recordCreationDate, 3, 2)"/>
						<xsl:value-of
							select="substring(mods:recordInfo/mods:recordCreationDate, 6, 2)"/>
						<xsl:value-of
							select="substring(mods:recordInfo/mods:recordCreationDate, 9, 2)"/>
					</xsl:when>
					<xsl:when test="mods:extension/mods:processingDate[@encoding = 'w3cdtf']">
						<xsl:value-of select="substring(mods:extension/mods:processingDate, 3, 2)"/>
						<xsl:value-of select="substring(mods:extension/mods:processingDate, 6, 2)"/>
						<xsl:value-of select="substring(mods:extension/mods:processingDate, 9, 2)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>      </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<!-- 06 -->
				<xsl:choose>
					<xsl:when
						test="mods:originInfo/mods:issuance = 'monographic' and count(mods:originInfo/mods:dateIssued) = 1"
						>s</xsl:when>
					<!-- v3 questionable -->
					<xsl:when test="mods:originInfo/mods:dateIssued[@qualifier = 'questionable']"
						>q</xsl:when>
					<xsl:when
						test="mods:originInfo/mods:issuance = 'monographic' and mods:originInfo/mods:dateIssued[@point = 'start'] and originInfo/dateIssued[@point = 'end']"
						>m</xsl:when>
					<xsl:when
						test="mods:originInfo/mods:issuance = 'continuing' and mods:originInfo/mods:dateIssued[@point = 'end' and @encoding = 'marc'] = '9999'"
						>c</xsl:when>
					<xsl:when
						test="mods:originInfo/mods:issuance = 'continuing' and mods:originInfo/mods:dateIssued[@point = 'end' and @encoding = 'marc'] = 'uuuu'"
						>u</xsl:when>
					<xsl:when
						test="mods:originInfo/mods:issuance = 'continuing' and mods:originInfo/mods:dateIssued[@point = 'end' and @encoding = 'marc']"
						>d</xsl:when>
					<!-- NAL  -->
					<xsl:when
						test="not(mods:originInfo/mods:issuance) and string-length(mods:originInfo/mods:dateIssued[@encoding = 'w3cdtf']) = 4"
						>s</xsl:when>
					<xsl:when
						test="not(mods:originInfo/mods:issuance) and string-length(mods:originInfo/mods:dateIssued[@encoding = 'w3cdtf']) &gt; 4"
						>e</xsl:when>
					<!-- v3 copyright date-->
					<xsl:when test="mods:originInfo/mods:copyrightDate">s</xsl:when>
					<xsl:otherwise>|</xsl:otherwise>
				</xsl:choose>
				<!-- 07-14 NAL: to adhere to NAL indexing practices -->
				<xsl:choose>
					<xsl:when
						test="mods:originInfo/mods:dateIssued[@encoding = 'marc' and @point = 'start']">
						<xsl:value-of
							select="mods:originInfo/mods:dateIssued[@encoding = 'marc' and @point = 'start']"/>
						<xsl:choose>
							<xsl:when
								test="mods:originInfo/mods:dateIssued[@encoding = 'marc' and @point = 'end']">
								<xsl:value-of
									select="mods:originInfo/mods:dateIssued[@encoding = 'marc' and @point = 'end']"
								/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>    </xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when
						test="mods:originInfo/mods:dateIssued[@encoding = 'marc' and @point = 'end']">
						<xsl:text>    </xsl:text>
						<xsl:value-of
							select="mods:originInfo/mods:dateIssued[@encoding = 'marc' and @point = 'end']"
						/>
					</xsl:when>
					<xsl:when
						test="string-length(mods:originInfo/mods:dateIssued[@encoding = 'w3cdtf']) = 10">
						<xsl:value-of
							select="substring(mods:originInfo/mods:dateIssued[@encoding = 'w3cdtf'], 1, 4)"/>
						<xsl:value-of
							select="substring(mods:originInfo/mods:dateIssued[@encoding = 'w3cdtf'], 6, 2)"/>
						<xsl:value-of
							select="substring(mods:originInfo/mods:dateIssued[@encoding = 'w3cdtf'], 9, 2)"
						/>
					</xsl:when>
					<xsl:when
						test="string-length(mods:originInfo/mods:dateIssued[@encoding = 'w3cdtf']) = 7">
						<xsl:value-of
							select="substring(mods:originInfo/mods:dateIssued[@encoding = 'w3cdtf'], 1, 4)"/>
						<xsl:value-of
							select="concat(substring(mods:originInfo/mods:dateIssued[@encoding = 'w3cdtf'], 6, 2), '  ')"
						/>
					</xsl:when>
					<xsl:when
						test="string-length(mods:originInfo/mods:dateIssued[@encoding = 'w3cdtf']) = 4">
						<xsl:value-of
							select="concat(substring(mods:originInfo/mods:dateIssued[@encoding = 'w3cdtf'], 1, 4), '    ')"
						/>
					</xsl:when>
					<!-- NAL
		<xsl:otherwise>
	            <xsl:text>          </xsl:text>  added 2 bytes for marc encoded dates JG 09/08/15
	        </xsl:otherwise>
	    -->
				</xsl:choose>
				<!-- 11-14 NAL -->
				<!--    <xsl:choose>
			   <xsl:when test="mods:originInfo/mods:dateIssued[@point='end' and @encoding='marc']">
				  <xsl:value-of select="mods:originInfo/mods:dateIssued[@point='end' and @encoding='marc']"/>
			   </xsl:when>
			   <xsl:otherwise>
				  <xsl:text>    </xsl:text>
			   </xsl:otherwise>
		    </xsl:choose>    -->
				<!-- 15-17 -->
				<xsl:choose>
					<!-- v3 place -->
					<xsl:when
						test="mods:originInfo/mods:place/mods:placeTerm[@type = 'code'][@authority = 'marccountry']">
						<!-- v3 fixed marc:code reference and authority change-->
						<xsl:value-of
							select="mods:originInfo/mods:place/mods:placeTerm[@type = 'code'][@authority = 'marccountry']"/>
						<!-- 1/04 fix -->
						<xsl:if
							test="string-length(mods:originInfo/mods:place/mods:placeTerm[@type = 'code'][@authority = 'marccountry']) = 2">
							<xsl:text> </xsl:text>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>xx </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<!-- 18-20 -->
				<xsl:text>|||</xsl:text>
				<!-- 21 -->
				<xsl:choose>
					<xsl:when test="$typeOf008 = 'SE'">
						<xsl:choose>
							<xsl:when test="mods:genre[@authority = 'marc'] = 'database'"
								>d</xsl:when>
							<xsl:when test="mods:genre[@authority = 'marc'] = 'loose-leaf'"
								>l</xsl:when>
							<xsl:when test="mods:genre[@authority = 'marc'] = 'newspaper'"
								>n</xsl:when>
							<xsl:when test="mods:genre[@authority = 'marc'] = 'periodical'"
								>p</xsl:when>
							<xsl:when test="mods:genre[@authority = 'marc'] = 'series'">m</xsl:when>
							<xsl:when test="mods:genre[@authority = 'marc'] = 'web site'"
								>w</xsl:when>
							<xsl:otherwise>|</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>|</xsl:otherwise>
				</xsl:choose>
				<!-- 22 -->
				<!-- 1/04 fix -->
				<xsl:choose>
					<xsl:when test="mods:targetAudience[@authority = 'marctarget']">
						<xsl:apply-templates mode="ctrl008"
							select="mods:targetAudience[@authority = 'marctarget']"/>
					</xsl:when>
					<xsl:otherwise>|</xsl:otherwise>
				</xsl:choose>
				<!-- 23 -->
				<xsl:choose>
					<xsl:when
						test="$typeOf008 = 'BK' or $typeOf008 = 'MU' or $typeOf008 = 'SE' or $typeOf008 = 'MM'">
						<xsl:choose>
							<xsl:when
								test="mods:physicalDescription/mods:form[@authority = 'marcform'] = 'braille'"
								>f</xsl:when>
							<xsl:when
								test="mods:physicalDescription/mods:form[@authority = 'marcform'] = 'electronic'"
								>s</xsl:when>
							<xsl:when
								test="mods:physicalDescription/mods:form[@authority = 'marcform'] = 'microfiche'"
								>b</xsl:when>
							<xsl:when
								test="mods:physicalDescription/mods:form[@authority = 'marcform'] = 'microfilm'"
								>a</xsl:when>
							<xsl:when
								test="mods:physicalDescription/mods:form[@authority = 'marcform'] = 'print'">
								<xsl:text> </xsl:text>
							</xsl:when>
							<xsl:otherwise>|</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="not(mods:location/mods:url = '')">o</xsl:when>
					<xsl:otherwise>|</xsl:otherwise>
				</xsl:choose>
				<!-- 24-27 -->
				<xsl:choose>
					<xsl:when test="$typeOf008 = 'BK'">
						<xsl:call-template name="controlField008-24-27"/>
					</xsl:when>
					<xsl:when test="$typeOf008 = 'MP'">
						<xsl:text>|</xsl:text>
						<xsl:choose>
							<xsl:when test="mods:genre[@authority = 'marc'] = 'atlas'">e</xsl:when>
							<xsl:when test="mods:genre[@authority = 'marc'] = 'globe'">d</xsl:when>
							<xsl:otherwise>|</xsl:otherwise>
						</xsl:choose>
						<xsl:text>||</xsl:text>
					</xsl:when>
					<xsl:when test="$typeOf008 = 'CF'">
						<xsl:text>||</xsl:text>
						<xsl:choose>
							<xsl:when test="mods:genre[@authority = 'marc'] = 'database'"
								>e</xsl:when>
							<xsl:when test="mods:genre[@authority = 'marc'] = 'font'">f</xsl:when>
							<xsl:when test="mods:genre[@authority = 'marc'] = 'game'">g</xsl:when>
							<xsl:when test="mods:genre[@authority = 'marc'] = 'numerical data'"
								>a</xsl:when>
							<xsl:when test="mods:genre[@authority = 'marc'] = 'sound'">h</xsl:when>
							<xsl:otherwise>|</xsl:otherwise>
						</xsl:choose>
						<xsl:text>|</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>||||</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<!-- 28 -->
				<xsl:text>|</xsl:text>
				<!-- 29 -->
				<xsl:choose>
					<xsl:when test="$typeOf008 = 'BK' or $typeOf008 = 'SE'">
						<xsl:choose>
							<xsl:when
								test="mods:genre[@authority = 'marc'] = 'conference publication'"
								>1</xsl:when>
							<xsl:otherwise>|</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$typeOf008 = 'MP' or $typeOf008 = 'VM'">
						<xsl:choose>
							<xsl:when test="mods:physicalDescription/mods:form = 'braille'"
								>f</xsl:when>
							<xsl:when test="mods:physicalDescription/mods:form = 'electronic'"
								>m</xsl:when>
							<xsl:when test="mods:physicalDescription/mods:form = 'microfiche'"
								>b</xsl:when>
							<xsl:when test="mods:physicalDescription/mods:form = 'microfilm'"
								>a</xsl:when>
							<xsl:when test="mods:physicalDescription/mods:form = 'print'">
								<xsl:text> </xsl:text>
							</xsl:when>
							<xsl:otherwise>|</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>|</xsl:otherwise>
				</xsl:choose>
				<!-- 30-31 -->
				<xsl:choose>
					<xsl:when test="$typeOf008 = 'MU'">
						<xsl:call-template name="controlField008-30-31"/>
					</xsl:when>
					<xsl:when test="$typeOf008 = 'BK'">
						<xsl:choose>
							<xsl:when test="mods:genre[@authority = 'marc'] = 'festschrift'"
								>1</xsl:when>
							<xsl:otherwise>|</xsl:otherwise>
						</xsl:choose>
						<xsl:text>|</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>||</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<!-- 32 -->
				<xsl:text>|</xsl:text>
				<!-- 33 -->
				<xsl:choose>
					<xsl:when test="$typeOf008 = 'VM'">
						<xsl:choose>
							<xsl:when test="mods:genre[@authority = 'marc'] = 'art originial'"
								>a</xsl:when>
							<xsl:when test="mods:genre[@authority = 'marc'] = 'art reproduction'"
								>c</xsl:when>
							<xsl:when test="mods:genre[@authority = 'marc'] = 'chart'">n</xsl:when>
							<xsl:when test="mods:genre[@authority = 'marc'] = 'diorama'"
								>d</xsl:when>
							<xsl:when test="mods:genre[@authority = 'marc'] = 'filmstrip'"
								>f</xsl:when>
							<xsl:when test="mods:genre[@authority = 'marc'] = 'flash card'"
								>o</xsl:when>
							<xsl:when test="mods:genre[@authority = 'marc'] = 'graphic'"
								>k</xsl:when>
							<xsl:when test="mods:genre[@authority = 'marc'] = 'kit'">b</xsl:when>
							<xsl:when test="mods:genre[@authority = 'marc'] = 'technical drawing'"
								>l</xsl:when>
							<xsl:when test="mods:genre[@authority = 'marc'] = 'slide'">s</xsl:when>
							<xsl:when test="mods:genre[@authority = 'marc'] = 'realia'">r</xsl:when>
							<xsl:when test="mods:genre[@authority = 'marc'] = 'picture'"
								>i</xsl:when>
							<xsl:when test="mods:genre[@authority = 'marc'] = 'motion picture'"
								>m</xsl:when>
							<xsl:when test="mods:genre[@authority = 'marc'] = 'model'">q</xsl:when>
							<xsl:when test="mods:genre[@authority = 'marc'] = 'microscope slide'"
								>p</xsl:when>
							<xsl:when test="mods:genre[@authority = 'marc'] = 'toy'">w</xsl:when>
							<xsl:when test="mods:genre[@authority = 'marc'] = 'transparency'"
								>t</xsl:when>
							<xsl:when test="mods:genre[@authority = 'marc'] = 'videorecording'"
								>v</xsl:when>
							<xsl:otherwise>|</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$typeOf008 = 'BK'">
						<xsl:choose>
							<xsl:when test="mods:genre[@authority = 'marc'] = 'comic strip'"
								>c</xsl:when>
							<xsl:when test="mods:genre[@authority = 'marc'] = 'fiction'"
								>1</xsl:when>
							<xsl:when test="mods:genre[@authority = 'marc'] = 'essay'">e</xsl:when>
							<xsl:when test="mods:genre[@authority = 'marc'] = 'drama'">d</xsl:when>
							<xsl:when test="mods:genre[@authority = 'marc'] = 'humor, satire'"
								>h</xsl:when>
							<xsl:when test="mods:genre[@authority = 'marc'] = 'letter'">i</xsl:when>
							<xsl:when test="mods:genre[@authority = 'marc'] = 'novel'">f</xsl:when>
							<xsl:when test="mods:genre[@authority = 'marc'] = 'short story'"
								>j</xsl:when>
							<xsl:when test="mods:genre[@authority = 'marc'] = 'speech'">s</xsl:when>
							<xsl:otherwise>|</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>|</xsl:otherwise>
				</xsl:choose>
				<!-- 34 -->
				<xsl:choose>
					<xsl:when test="$typeOf008 = 'BK'">
						<xsl:choose>
							<xsl:when test="mods:genre[@authority = 'marc'] = 'biography'"
								>d</xsl:when>
							<xsl:otherwise>|</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>|</xsl:otherwise>
				</xsl:choose>
				<!-- 35-37 -->
				<xsl:choose>
					<!-- v3 language -->
					<xsl:when test="mods:language/mods:languageTerm[@authority = 'iso639-2b']">
						<xsl:value-of
							select="mods:language[1]/mods:languageTerm[@authority = 'iso639-2b'][1]"
						/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>|||</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<!-- 38-39 -->
				<xsl:text>||</xsl:text>
			</marc:controlfield>

			<!-- 1/04 fix sort -->
			<xsl:call-template name="source"/>
			<xsl:apply-templates/>
			<xsl:if test="mods:classification[@authority = 'lcc']">
				<xsl:call-template name="lcClassification"/>
			</xsl:if>

			<!-- Constants -->
			<xsl:call-template name="datafields">
				<xsl:with-param name="tag">787</xsl:with-param>
				<xsl:with-param name="ind1">1</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code="o">
						<xsl:text>islandora_article_repository</xsl:text>
					</marc:subfield>
				</xsl:with-param>
			</xsl:call-template>

			<xsl:call-template name="datafields">
				<xsl:with-param name="tag">912</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code="a">
						<xsl:text>Article</xsl:text>
					</marc:subfield>
				</xsl:with-param>
			</xsl:call-template>

			<!-- NAL note templates -->
			<xsl:call-template name="note910"/>
			<xsl:call-template name="nal914"/>
			<xsl:call-template name="note917"/>
			<xsl:call-template name="note930"/>
			<xsl:call-template name="note945"/>
			<xsl:call-template name="note946"/>
			<xsl:call-template name="note952"/>
			<xsl:call-template name="note953"/>
			<xsl:call-template name="note954"/>
			<xsl:call-template name="note955"/>
			<xsl:apply-templates select="mods:extension/mods:note[@type = 'warning']" mode="nal979"/>
			<xsl:call-template name="note593"/>
			<xsl:call-template name="note594"/>
			<xsl:call-template name="collectionFromNote"/>
			<!--			<xsl:apply-templates select="mods:extension"/>  in NAL_MARC21slim_XSLT2-0_import.xsl and Journal-NAL_MARC21slim_XSLT2-0_import.xsl -->
			<!--			<xsl:apply-templates select="mods:originInfo"/>  in NAL_MARC21slim_XSLT2-0_import.xsl and Journal-NAL_MARC21slim_XSLT2-0_import.xsl -->

			<xsl:apply-templates
				select="mods:recordInfo/mods:recordCreationDate[@encoding = 'w3cdtf']"/>
			<xsl:apply-templates
				select="mods:recordInfo/mods:recordChangeDate[@encoding = 'w3cdtf']"/>
			<!--<xsl:call-template name="modsFundingGroup"/>-->
			<xsl:for-each select="mods:extension/mods:funding-group">
				<xsl:apply-templates select="mods:award-group"/>
				<xsl:apply-templates select="mods:funding-statement"/>
			</xsl:for-each>
			<xsl:apply-templates select="mods:extension/mods:fn[@fn-type = 'financial-disclosure']"/>
			<xsl:apply-templates select="mods:extension/mods:ObjectList"/>


		</marc:record>
	</xsl:template>


	<!-- NAL extension notes fields -->
	<!-- add note 910 -->
	<xsl:template match="mods:extension/mods:note[@type = 'submissionSource']" name="note910">
		<xsl:for-each select="mods:extension/mods:note[@type = 'submissionSource']">
			<xsl:variable name="note" select="."/>
			<xsl:call-template name="datafields">
				<xsl:with-param name="tag">910</xsl:with-param>
				<xsl:with-param name="ind1">
					<xsl:text> </xsl:text>
				</xsl:with-param>
				<xsl:with-param name="ind2">
					<xsl:text> </xsl:text>
				</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code="a">
						<xsl:value-of select="substring-before($note, '/')"/>
					</marc:subfield>
					<marc:subfield code="b">
						<xsl:value-of select="substring-after($note, '/')"/>
					</marc:subfield>
				</xsl:with-param>
			</xsl:call-template>
<!--			<xsl:call-template name="createMARC596FromFunding"/>-->
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="note917">
		<xsl:for-each select="mods:extension/mods:note[@type = 'status']">
			<xsl:variable name="note" select="."/>
			<xsl:call-template name="datafields">
				<xsl:with-param name="tag">917</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code="a">
						<xsl:value-of select="$note"/>
					</marc:subfield>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<!-- NAL note 930, bad string processiong functions in xslt 1.0, will code values be uniform?
  and follow the same string pattern?  -->
	<xsl:template match="mods:extension/mods:note[@type = 'saleTape930']" name="note930">
		<xsl:for-each select="mods:extension/mods:note[@type = 'saleTape930']">
			<xsl:variable name="note" select="."/>
			<xsl:choose>
				<xsl:when test="not(substring($note, 1, 8) = '00000000')">
					<xsl:call-template name="datafields">
						<xsl:with-param name="tag">930</xsl:with-param>
						<xsl:with-param name="ind1">
							<xsl:text> </xsl:text>
						</xsl:with-param>
						<xsl:with-param name="ind2">
							<xsl:text> </xsl:text>
						</xsl:with-param>
						<xsl:with-param name="subfields">
							<marc:subfield code="a">
								<xsl:value-of select="substring($note, 1, 8)"/>
							</marc:subfield>
							<marc:subfield code="b">
								<xsl:value-of select="substring($note, 10, 8)"/>
							</marc:subfield>
							<marc:subfield code="c">
								<xsl:value-of select="substring($note, 19, 8)"/>
							</marc:subfield>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="datafields">
						<xsl:with-param name="tag">939</xsl:with-param>
						<xsl:with-param name="ind1">
							<xsl:text> </xsl:text>
						</xsl:with-param>
						<xsl:with-param name="ind2">
							<xsl:text> </xsl:text>
						</xsl:with-param>
						<xsl:with-param name="subfields">
							<marc:subfield code="a">
								<xsl:value-of select="substring($note, 1, 8)"/>
							</marc:subfield>
							<marc:subfield code="b">
								<xsl:value-of select="substring($note, 10, 8)"/>
							</marc:subfield>
							<marc:subfield code="c">
								<xsl:value-of select="substring($note, 19, 8)"/>
							</marc:subfield>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>


	<!-- NAL note 945, bad string processiong functions in xslt 1.0, will code values be uniform?
  and follow the same string pattern? -->
	<xsl:template name="note945">
		<xsl:for-each select="mods:extension/mods:note[@type = 'indexer']">
			<xsl:variable name="note" select="."/>
			<xsl:call-template name="datafields">
				<xsl:with-param name="tag">945</xsl:with-param>
				<xsl:with-param name="ind1">
					<xsl:text> </xsl:text>
				</xsl:with-param>
				<xsl:with-param name="ind2">
					<xsl:text> </xsl:text>
				</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code="a">
						<xsl:value-of select="substring($note, 1, 3)"/>
					</marc:subfield>
					<xsl:if test="not(substring($note, 5, 3) = '')">
						<marc:subfield code="d">
							<xsl:value-of select="substring($note, 5, 3)"/>
						</marc:subfield>
					</xsl:if>
					<xsl:if test="not(substring($note, 9, 10) = '')">
						<marc:subfield code="e">
							<xsl:value-of select="substring($note, 9, 10)"/>
						</marc:subfield>
					</xsl:if>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>


	<!-- NAL extension note 952, archiveFile 953, originalFile 954, workingDir 955, sources 593 -->
	<xsl:template name="note952">
		<xsl:for-each select="mods:extension/mods:note[@type = 'indexedBy']">
			<xsl:variable name="note" select="."/>
			<xsl:call-template name="datafields">
				<xsl:with-param name="tag">952</xsl:with-param>
				<xsl:with-param name="ind1">
					<xsl:text> </xsl:text>
				</xsl:with-param>
				<xsl:with-param name="ind2">
					<xsl:text> </xsl:text>
				</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code="d">
						<xsl:value-of select="$note"/>
					</marc:subfield>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="note953">
		<xsl:for-each select="mods:extension/mods:archiveFile">
			<xsl:call-template name="datafields">
				<xsl:with-param name="tag">953</xsl:with-param>
				<xsl:with-param name="ind1">
					<xsl:text> </xsl:text>
				</xsl:with-param>
				<xsl:with-param name="ind2">
					<xsl:text> </xsl:text>
				</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code="a">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="note954">
		<xsl:for-each select="mods:extension/mods:originalFile">
			<xsl:call-template name="datafields">
				<xsl:with-param name="tag">954</xsl:with-param>
				<xsl:with-param name="ind1">
					<xsl:text> </xsl:text>
				</xsl:with-param>
				<xsl:with-param name="ind2">
					<xsl:text> </xsl:text>
				</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code="a">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="note955">
		<xsl:for-each select="mods:extension/mods:workingDirectory">
			<xsl:call-template name="datafields">
				<xsl:with-param name="tag">955</xsl:with-param>
				<xsl:with-param name="ind1">
					<xsl:text> </xsl:text>
				</xsl:with-param>
				<xsl:with-param name="ind2">
					<xsl:text> </xsl:text>
				</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code="a">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="//mods:extension/mods:dateOther[@type = 'submission_created']">
		<marc:subfield code="c">
			<xsl:if test="@encoding = 'epoch'">
				<xsl:value-of select="f:epochToISODate(.)"/>
			</xsl:if>
			<!-- resolves atomic value issue; needs testing --> 
			<xsl:if test="@encoding = 'w3ctdf'">
				<xsl:value-of select="./text()"/>
			</xsl:if>
		</marc:subfield>
	</xsl:template>

	<xsl:template match="//mods:extension/mods:dateOther[@type='submission_modified']">
		<marc:subfield code="e">
			<xsl:if test="@encoding = 'epoch'">
				<xsl:value-of select="f:epochToISODate(.)"/>
			</xsl:if>
			<xsl:if test="@encoding = 'w3cdtf'">
				<xsl:value-of select="."/>
			</xsl:if>
		</marc:subfield>
	</xsl:template>


	<xsl:template name="note593">
		<xsl:if test="mods:extension/mods:note[@type = 'submitter_email']">
			<xsl:call-template name="datafields">
				<xsl:with-param name="tag">593</xsl:with-param>
				<xsl:with-param name="ind1">
					<xsl:text> </xsl:text>
				</xsl:with-param>
				<xsl:with-param name="ind2">
					<xsl:text> </xsl:text>
				</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code="a">
						<xsl:text>PubAg article</xsl:text>
					</marc:subfield>
					<marc:subfield code="c">
						<xsl:text>USDA submission</xsl:text>
					</marc:subfield>
					<xsl:if test="mods:extension/mods:note[@type = 'status'  and text() = 'issued']">
						<marc:subfield code="f">Agricola IND</marc:subfield>
					</xsl:if>
				</xsl:with-param>
			</xsl:call-template>

			<xsl:call-template name="datafields">
				<xsl:with-param name="tag">961</xsl:with-param>
				<xsl:with-param name="ind1">
					<xsl:text> </xsl:text>
				</xsl:with-param>
				<xsl:with-param name="ind2">
					<xsl:text> </xsl:text>
				</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code="a">
						<xsl:text>USDA</xsl:text>
					</marc:subfield>
					<xsl:apply-templates
						select="//mods:extension/mods:dateOther[@type = 'submission_created']"/>
					<xsl:if test="//mods:recordIdentifier/text()">
						<marc:subfield code="d">
							<xsl:value-of select="//mods:recordIdentifier/text()"/>
						</marc:subfield>
					</xsl:if>
					<xsl:if test="//mods:identifier[@type = 'submission-node']/text()">
						<marc:subfield code="d">
							<xsl:value-of
								select="//mods:identifier[@type = 'submission-node']/text()"/>
						</marc:subfield>
					</xsl:if>
					<xsl:apply-templates
						select="//mods:extension/mods:dateOther[@type = 'submission_modified']"/>
				</xsl:with-param>
			</xsl:call-template>

			<xsl:call-template name="datafields">
				<xsl:with-param name="tag">787</xsl:with-param>
				<xsl:with-param name="ind1">
					<xsl:text>1</xsl:text>
				</xsl:with-param>
				<xsl:with-param name="ind2">
					<xsl:text> </xsl:text>
				</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code="o">
						<xsl:text>product_pubag</xsl:text>
					</marc:subfield>
				</xsl:with-param>
			</xsl:call-template>

		</xsl:if>

		<!--<xsl:if test="mods:extension/mods:manuscriptSource">
				<xsl:call-template name="datafields">
					<xsl:with-param name="tag">593</xsl:with-param>
					<xsl:with-param name="ind1">
						<xsl:text> </xsl:text>
					</xsl:with-param>
					<xsl:with-param name="ind2">
						<xsl:text> </xsl:text>
					</xsl:with-param>
					<xsl:with-param name="subfields">
						<marc:subfield code="a">
							<xsl:text>PubAg article</xsl:text>
						</marc:subfield>
						<marc:subfield code="e">
							<xsl:text>ARIS manuscript</xsl:text>
						</marc:subfield>
					</xsl:with-param>
				</xsl:call-template>
				
				<xsl:call-template name="datafields">
					<xsl:with-param name="tag">961</xsl:with-param>
					<xsl:with-param name="ind1">
						<xsl:text> </xsl:text>
					</xsl:with-param>
					<xsl:with-param name="ind2">
						<xsl:text> </xsl:text>
					</xsl:with-param>
					<xsl:with-param name="subfields">
						<marc:subfield code="b">
							<xsl:text>USDA</xsl:text>
						</marc:subfield>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:if>-->

		<xsl:if
			test="mods:extension/mods:note[@type = 'collectionStatus' and text() = 'Accepted'] and not(//mods:submissionSource)">
			<xsl:call-template name="datafields">
				<xsl:with-param name="tag">593</xsl:with-param>
				<xsl:with-param name="ind1">
					<xsl:text> </xsl:text>
				</xsl:with-param>
				<xsl:with-param name="ind2">
					<xsl:text> </xsl:text>
				</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code="a">
						<xsl:text>PubAg article</xsl:text>
					</marc:subfield>
					<xsl:if test="mods:extension/mods:note[@type = 'status' and text() = 'issued']">
						<marc:subfield code="f">Agricola IND</marc:subfield>
					</xsl:if>					
				</xsl:with-param>
			</xsl:call-template>

			<xsl:call-template name="datafields">
				<xsl:with-param name="tag">787</xsl:with-param>
				<xsl:with-param name="ind1">
					<xsl:text>1</xsl:text>
				</xsl:with-param>
				<xsl:with-param name="ind2">
					<xsl:text> </xsl:text>
				</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code="o">
						<xsl:text>product_pubag</xsl:text>
					</marc:subfield>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<!--</xsl:template>-->
	</xsl:template>

	<xsl:template name="note594">
		<xsl:if
			test="mods:extension/mods:note[@type = 'contentOnHold'][starts-with(lower-case(text()), 'embargoed')]">
			<xsl:call-template name="datafields">
				<xsl:with-param name="tag">594</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code="a">
						<xsl:text>Embargoed article</xsl:text>
					</marc:subfield>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>



	<!-- LC note 946 -->
	<xsl:template match="mods:extension/mods:note[@type = 'publicationSource']" name="note946">
		<xsl:for-each select="mods:extension/mods:note[@type = 'publicationSource']">
			<xsl:variable name="note" select="."/>
			<xsl:call-template name="datafields">
				<xsl:with-param name="tag">946</xsl:with-param>
				<xsl:with-param name="ind1">
					<xsl:text> </xsl:text>
				</xsl:with-param>
				<xsl:with-param name="ind2">
					<xsl:text> </xsl:text>
				</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code="a">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="collectionFromNote">
		<xsl:if test="mods:extension/mods:note[@type = 'MemberOfCollection']">
			<xsl:for-each select="mods:extension/mods:note[@type = 'MemberOfCollection']">
				<xsl:call-template name="datafields">
					<xsl:with-param name="tag">787</xsl:with-param>
					<xsl:with-param name="ind1">
						<xsl:text>1</xsl:text>
					</xsl:with-param>
					<xsl:with-param name="subfields">
						<marc:subfield code="o">
							<xsl:choose>
								<xsl:when test="contains(., '_')">
									<xsl:value-of select="."/>
								</xsl:when>
								<xsl:when test=". = 'PubAg articles with full text in PDF'">
									<xsl:text>islandora_pubag_with_text</xsl:text>
								</xsl:when>
								<xsl:when test=". = 'Incomplete articles'">
									<xsl:text>islandora_incomplete_articles</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="."/>
								</xsl:otherwise>
							</xsl:choose>
						</marc:subfield>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<!-- DOI and Handle 024 -->
	<!-- Set the indicator1 value = 7, by yli 2019-06-24 -->
	<!-- Added more identifiers, by yli 2022-04-07 -->
	<xsl:template
		match="mods:identifier[@type = 'doi'] | mods:identifier[@type = 'hdl' and not(@invalid = 'yes')] | mods:identifier[@type = 'aris'] | mods:identifier[@type = 'aris_accn_no'] | mods:identifier[@type = 'chorus'] | mods:identifier[@type = 'chorusOpen'] | mods:identifier[@type = 'pmid'] | mods:identifier[@type = 'pmcid']">
		<xsl:variable name="idPrefix">
			<xsl:choose>
				<xsl:when test="@type = 'chorus' or @type = 'chorusOpen'">
					<xsl:text>CHORUS</xsl:text>
				</xsl:when>
				<xsl:when test="@type = 'pmid'">
					<xsl:text>PM</xsl:text>
				</xsl:when>
				<xsl:when test="@type = 'pmcid'">
					<xsl:text>PMC</xsl:text>
				</xsl:when>
				<xsl:otherwise/>
			</xsl:choose>
		</xsl:variable>

		<xsl:call-template name="datafields">
			<xsl:with-param name="tag">024</xsl:with-param>
			<xsl:with-param name="ind1">
				<xsl:text>7</xsl:text>
			</xsl:with-param>
			<xsl:with-param name="ind2">
				<xsl:text> </xsl:text>
			</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<!--removing the prefix per discussion https://3.basecamp.com/3765443/buckets/24678933/uploads/5403806303#__recording_5448180713 <xsl:value-of select="$idPrefix"/>-->
					<xsl:value-of select="."/>
				</marc:subfield>
				<marc:subfield code="2">
					<xsl:value-of select="@type"/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- Name personal 100 -->
	<xsl:template match="mods:name[@type = 'personal' and @usage = 'primary'][1]">
		<xsl:call-template name="datafields">
			<xsl:with-param name="tag">100</xsl:with-param>
			<xsl:with-param name="ind1">1</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="mods:displayForm"/>
				</marc:subfield>
				<xsl:for-each select="mods:namePart[@type = 'date']">
					<marc:subfield code="d">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<xsl:for-each select="mods:role/mods:roleTerm[@type = 'text']">
					<marc:subfield code="e">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<!-- Error: not related to author, by axu
		<xsl:for-each select="mods:description">
		   <marc:subfield code="g">
		       <xsl:value-of select="."/>
		   </marc:subfield>
		</xsl:for-each>
           -->
				<!-- only get the author's first affiliation into subfield "u", the subsequent affiliations are concatenated to the same $u subfield, each prefixed with backticks and a space by axu -->
				<xsl:if
					test="mods:affiliation and (mods:affiliation != ' ') and (mods:affiliation != '')">
					<marc:subfield code="u">
							<xsl:value-of select="mods:affiliation[1]"/>
							<xsl:for-each select="mods:affiliation[position() > 1]">
								<xsl:text> ``</xsl:text>
								<xsl:value-of select="."/>
							</xsl:for-each>
						</marc:subfield>
				</xsl:if>	
			<!-- Add ORCID element in name node, yli 2022-03-11 -->
				<xsl:if test="mods:nameIdentifier[@type = 'orcid']">
					<xsl:for-each select="../mods:nameIdentifier">
					<marc:subfield code="1">
<!--	<xsl:value-of select="mods:nameIdentifier"/>-->
						<xsl:value-of select="if (matches(mods:nameIdentifier, '(\d{4}\-?){4}')) then concat('https://orcid.org/', mods:nameIdentifier) else if (starts-with(mods:nameIdentifier, 'https://orcid.org/')) then mods:nameIdentifier else mods:nameIdentifier"/>
					</marc:subfield>
					</xsl:for-each>
				</xsl:if>

			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="mods:name[@type = 'personal' and @usage = 'primary'][position() > 1]">
		<xsl:call-template name="datafields">
			<xsl:with-param name="tag">700</xsl:with-param>
			<xsl:with-param name="ind1">1</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="mods:displayForm"/>
					<!-- changed from NamePart by axu -->
				</marc:subfield>

				<!-- v3 termsofAddress -->
				<xsl:for-each select="mods:namePart[@type = 'termsOfAddress']">
					<marc:subfield code="c">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<xsl:for-each select="mods:namePart[@type = 'date']">
					<marc:subfield code="d">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<!-- v3 role -->
				<xsl:for-each select="mods:role/mods:roleTerm[@type = 'text']">
					<marc:subfield code="e">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<!-- remove the subfield "4", 2019-08-07
    		<xsl:for-each select="mods:role/mods:roleTerm[@type='code']">
    		      <marc:subfield code="4">
    			    <xsl:value-of select="."/>
    		      </marc:subfield>
    		</xsl:for-each>
        -->
				<!-- only get the author's first affiliation into subfield "u", the subsequent affiliations are concatenated to the same $u subfield, each prefixed with backticks and a space by axu -->
				<xsl:if test="mods:affiliation and (mods:affiliation != ' ')">
						<marc:subfield code="u">
							<xsl:value-of select="mods:affiliation[1]"/>
							<xsl:for-each select="mods:affiliation[position() > 1]">
								<xsl:text>  ``</xsl:text>
								<xsl:value-of select="."/>
							</xsl:for-each>
						</marc:subfield>
					</xsl:if>
					
				<!-- Add ORCID element in name node, yli 2022-03-11 -->
				<xsl:if test="mods:nameIdentifier[@type = 'orcid']">
					<xsl:variable name="nameId" select="mods:nameIdentifier[@type = 'orcid']"/>
					<marc:subfield code="1">
						<xsl:value-of select="if (matches($nameID"/>
					</marc:subfield>
				</xsl:if>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- Name personal 700 -->
	<xsl:template
		match="mods:name[@type = 'personal' and not(@usage)][mods:role/mods:roleTerm[@type = 'text'] != 'creator' or not(mods:role)]">
		<xsl:call-template name="datafields">
			<xsl:with-param name="tag">700</xsl:with-param>
			<xsl:with-param name="ind1">1</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="mods:displayForm"/>
					<!-- changed from NamePart by axu -->
				</marc:subfield>

				<!-- v3 termsofAddress -->
				<xsl:for-each select="mods:namePart[@type = 'termsOfAddress']">
					<marc:subfield code="c">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<xsl:for-each select="mods:namePart[@type = 'date']">
					<marc:subfield code="d">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<!-- v3 role -->
				<xsl:for-each select="mods:role/mods:roleTerm[@type = 'text']">
					<marc:subfield code="e">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<!-- remove the subfield "4", 2019-08-07
    		<xsl:for-each select="mods:role/mods:roleTerm[@type='code']">
    		      <marc:subfield code="4">
    			    <xsl:value-of select="."/>
    		      </marc:subfield>
    		</xsl:for-each>
        -->
				<!-- only get the author's first affiliation into subfield "u", the subsequent affiliations are concatenated to the same $u subfield, each prefixed with backticks and a space by axu -->
				<xsl:if test="mods:affiliation and (mods:affiliation != ' ')">
					<marc:subfield code="u">
							<xsl:value-of select="mods:affiliation[1]"/>
							<xsl:for-each select="mods:affiliation[position() > 1]">
								<xsl:text> ``</xsl:text>
								<xsl:value-of select="."/>
							</xsl:for-each>
					</marc:subfield>
				</xsl:if>
				<!-- Add ORCID element in name node, yli 2022-03-11 -->
				<xsl:if test="mods:nameIdentifier[@type = 'orcid']">
					<marc:subfield code="1">
						<xsl:value-of select="mods:nameIdentifier"/>
					</marc:subfield>
				</xsl:if>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- Added on Aug 02, 2017, by yli -->
	<!-- Name personal 110 -->
	<xsl:template match="mods:name[@type = 'corporate' and @usage = 'primary']">
		<xsl:call-template name="datafields">
			<xsl:with-param name="tag">110</xsl:with-param>
			<xsl:with-param name="ind1">2</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="mods:namePart[1]"/>
				</marc:subfield>
				<xsl:for-each select="mods:namePart[position() > 1]">
					<marc:subfield code="b">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<!-- v3 role -->
				<xsl:for-each select="mods:role/mods:roleTerm[@type = 'text']">
					<marc:subfield code="e">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<xsl:for-each select="mods:role/mods:roleTerm[@type = 'code']">
					<marc:subfield code="4">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<!-- Error: not related to author, by axu
         <xsl:for-each select="mods:description">
             <marc:subfield code="g">
                   <xsl:value-of select="."/>
             </marc:subfield>
         </xsl:for-each>
      -->
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- Name personal 710 -->
	<xsl:template
		match="mods:name[@type = 'corporate' and not(@usage)][mods:role/mods:roleTerm[@type = 'text'] != 'creator' or not(mods:role)]">
		<xsl:call-template name="datafields">
			<xsl:with-param name="tag">710</xsl:with-param>
			<xsl:with-param name="ind1">2</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<!-- 1/04 fix -->
					<xsl:value-of select="mods:namePart[1]"/>
				</marc:subfield>
				<xsl:for-each select="mods:namePart[position() > 1]">
					<marc:subfield code="b">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<!-- v3 role -->
				<xsl:for-each select="mods:role/mods:roleTerm[@type = 'text']">
					<marc:subfield code="e">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<!-- remove the subfield "4"
                       <xsl:for-each select="mods:role/mods:roleTerm[@type='code']">
                             <marc:subfield code="4">
                                   <xsl:value-of select="."/>
                             </marc:subfield>
                       </xsl:for-each>
                       -->
				<!-- Error: not related to author, by axu
                       <xsl:for-each select="mods:description">
                             <marc:subfield code="g">
                                   <xsl:value-of select="."/>
                             </marc:subfield>
                       </xsl:for-each>
                   -->
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- NAL modify field 650 topic -->
	<!-- add "nal" and "nalt" for the subject authorities not "atg", by yli 2019-06-24 -->
	<xsl:template name="authorityInd">
		<xsl:choose>
			<xsl:when test="@authority = 'lcsh'">0</xsl:when>
			<xsl:when test="@authority = 'lcshac'">1</xsl:when>
			<xsl:when test="@authority = 'mesh'">2</xsl:when>
			<xsl:when test="@authority = 'atg'">3</xsl:when>
			<xsl:when test="@authority = 'nal'">3</xsl:when>
			<xsl:when test="@authority = 'nalt'">3</xsl:when>
			<xsl:when test="@authority = 'rvm'">6</xsl:when>
			<xsl:when test="@authority">7</xsl:when>
			<xsl:otherwise>
				<xsl:text> </xsl:text>
			</xsl:otherwise>
			<!-- v3 blank ind2 fix-->
		</xsl:choose>
	</xsl:template>

	<!-- Set the ndicator2 value for the subjects with authority atg, mesh and lcsh, by yli 2019-06-24 -->
	<!-- Subjects with the authority = atg: <xsl:template match="mods:subject[local-name(*[1])='topic']"> -->
	<xsl:template match="mods:subject[@authority = 'atg'][local-name(*[1]) = 'topic']">
		<xsl:call-template name="datafields">
			<xsl:with-param name="tag">650</xsl:with-param>
			<xsl:with-param name="ind2">
				<xsl:text>3</xsl:text>
			</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="*[1]"/>
				</marc:subfield>
				<xsl:if test="@valueURI">
					<marc:subfield code="0">
						<xsl:value-of select="@valueURI"/>
					</marc:subfield>
				</xsl:if>
				<xsl:if test="./mods:topic[@valueURI]">
					<marc:subfield code="0">
						<xsl:value-of select="./mods:topic/@valueURI"/>
					</marc:subfield>
				</xsl:if>
				<xsl:apply-templates select="*[position() > 1]"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- Subjects with the authority = mesh: <xsl:template match="mods:subject[local-name(*[1])='topic']"> -->
	<xsl:template match="mods:subject[@authority = 'mesh'][local-name(*[1]) = 'topic']">
		<xsl:call-template name="datafields">
			<xsl:with-param name="tag">650</xsl:with-param>
			<xsl:with-param name="ind2">
				<xsl:text>2</xsl:text>
			</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="*[1]"/>
				</marc:subfield>
				<xsl:if test="@valueURI">
					<marc:subfield code="0">
						<xsl:value-of select="@valueURI"/>
					</marc:subfield>
				</xsl:if>
				<xsl:apply-templates select="*[position() > 1]"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- Subjects with the authority = lcsh: <xsl:template match="mods:subject[local-name(*[1])='topic']"> -->
	<xsl:template match="mods:subject[@authority = 'lcsh'][local-name(*[1]) = 'topic']">
		<xsl:call-template name="datafields">
			<xsl:with-param name="tag">650</xsl:with-param>
			<xsl:with-param name="ind2">
				<xsl:text>0</xsl:text>
			</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="*[1]"/>
				</marc:subfield>
				<xsl:if test="@valueURI">
					<marc:subfield code="0">
						<xsl:value-of select="@valueURI"/>
					</marc:subfield>
				</xsl:if>
				<xsl:apply-templates select="*[position() > 1]"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- Move the subjects without authority attribute to 653 field, by yli 2019-06-24 -->
	<!-- Subjects without the authority: <xsl:template match="mods:subject[local-name(*[1])='topic']"> -->
	<xsl:template match="mods:subject[not(@authority)][local-name(*[1]) = 'topic']">
		<xsl:call-template name="datafields">
			<xsl:with-param name="tag">653</xsl:with-param>
			<xsl:with-param name="ind1">
				<xsl:text> </xsl:text>
			</xsl:with-param>
			<xsl:with-param name="ind2">
				<xsl:text>0</xsl:text>
			</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="*[1]"/>
				</marc:subfield>
				<xsl:if test="@valueURI">
					<marc:subfield code="0">
						<xsl:value-of select="@valueURI"/>
					</marc:subfield>
				</xsl:if>
				<xsl:apply-templates select="*[position() > 1]"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- LC: agricola subject code to 072-->
	<xsl:template match="mods:subject[@authority = 'agricola']">
		<xsl:call-template name="datafields">
			<xsl:with-param name="tag">072</xsl:with-param>
			<xsl:with-param name="ind1">
				<xsl:text> </xsl:text>
			</xsl:with-param>
			<xsl:with-param name="ind2">
				<xsl:text>0</xsl:text>
			</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- NAL subject geopgrahic field 651 -->
	<xsl:template match="mods:subject[@authority = 'atg'][local-name(*[1]) = 'geographic']">
		<xsl:call-template name="datafields">
			<xsl:with-param name="tag">651</xsl:with-param>
			<xsl:with-param name="ind1">
				<xsl:text> </xsl:text>
			</xsl:with-param>
			<xsl:with-param name="ind2">
				<xsl:text>3</xsl:text>
			</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="*[1]"/>
				</marc:subfield>
				<xsl:if test="@valueURI">
					<marc:subfield code="0">
						<xsl:value-of select="@valueURI"/>
					</marc:subfield>
				</xsl:if>
				<xsl:apply-templates select="*[position() > 1]"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- Other subject geopgrahic field 651 -->
	<xsl:template match="mods:subject[not(@authority = 'atg')][local-name(*[1]) = 'geographic']">
		<xsl:call-template name="datafields">
			<xsl:with-param name="tag">651</xsl:with-param>
			<xsl:with-param name="ind1">
				<xsl:text> </xsl:text>
			</xsl:with-param>
			<xsl:with-param name="ind2">
				<xsl:text>0</xsl:text>
			</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="*[1]"/>
				</marc:subfield>
				<xsl:if test="@valueURI">
					<marc:subfield code="0">
						<xsl:value-of select="@valueURI"/>
					</marc:subfield>
				</xsl:if>
				<xsl:apply-templates select="*[position() > 1]"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- NAL add the ur_id subfields and datafields mapping -->
	<xsl:template match="mods:identifier[@type = 'local' and not(@invalid = 'yes')]">
		<xsl:call-template name="datafields">
			<xsl:with-param name="tag">974</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="datafields">
			<xsl:with-param name="tag">035</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
					<xsl:text>-01nal_inst</xsl:text>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- NAL add the Agricola subfields and datafields mapping -->
	<!-- Set the indicator1 value = 7, by yli 2019-06-24 -->
	<xsl:template match="mods:identifier[@type = 'agricola']">
		<xsl:call-template name="datafields">
			<xsl:with-param name="tag">016</xsl:with-param>
			<xsl:with-param name="ind1">
				<xsl:text>7</xsl:text>
			</xsl:with-param>
			<xsl:with-param name="ind2">
				<xsl:text> </xsl:text>
			</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
				<marc:subfield code="2">DNAL</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- relatedItem @type='host' = fields 300, 773 modified by NAL -->
	<xsl:template match="mods:relatedItem[@type = 'host']">
		<xsl:choose>
			<xsl:when test="mods:part/mods:extent/mods:start = mods:part/mods:extent/mods:end">
				<xsl:call-template name="datafields">
					<xsl:with-param name="tag">300</xsl:with-param>
					<xsl:with-param name="subfields">
						<marc:subfield code="a">p. <xsl:value-of
								select="mods:part/mods:extent/mods:start"/>.</marc:subfield>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="mods:part/mods:extent/mods:end">
				<xsl:call-template name="datafields">
					<xsl:with-param name="tag">300</xsl:with-param>
					<xsl:with-param name="subfields">
						<marc:subfield code="a">p. <xsl:value-of
								select="mods:part/mods:extent/mods:start"/>-<xsl:value-of
								select="mods:part/mods:extent/mods:end"/>.</marc:subfield>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<!-- Error: empty 300 field created  removed by axu
	  <xsl:otherwise>
		<xsl:call-template name="datafields">
		  <xsl:with-param name="tag">300</xsl:with-param>
		  <xsl:with-param name="subfields">
			<marc:subfield code='a'>p. <xsl:value-of select="mods:part/mods:extent/mods:start"/>.</marc:subfield>
		  </xsl:with-param>
		</xsl:call-template>
	  </xsl:otherwise>
        -->
		</xsl:choose>
		<xsl:apply-templates
			select="mods:identifier[@type = 'local' and not(@invalid = 'yes')] | mods:identifier[@type = 'mmsid' and not(../mods:identifier[@type = 'local' and not(@invalid = 'yes')])]"
			mode="relatedItem"/>

		<xsl:call-template name="datafields">
			<xsl:with-param name="tag">773</xsl:with-param>
			<xsl:with-param name="ind1">0</xsl:with-param>
			<xsl:with-param name="subfields">
				<!-- v3 displaylabel -->
				<xsl:for-each select="@displaylabel">
					<marc:subfield code="3">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<xsl:call-template name="nal773"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="nal773">
		<xsl:for-each select="mods:titleInfo">
			<xsl:choose>
				<xsl:when test="not(ancestor-or-self::mods:titleInfo[@type])">
					<marc:subfield code="t">
						<xsl:value-of select="mods:title"/>
						<xsl:text>.</xsl:text>
					</marc:subfield>
				</xsl:when>
				<xsl:when test="ancestor-or-self::mods:titleInfo[@type = 'uniform']">
					<marc:subfield code="s">
						<xsl:value-of select="mods:title"/>
					</marc:subfield>
				</xsl:when>
				<xsl:when
					test="ancestor-or-self::mods:titleInfo[@type = 'abbreviated'] and position() = 1">
					<marc:subfield code="p">
						<xsl:value-of select="mods:title"/>
					</marc:subfield>
				</xsl:when>
			</xsl:choose>
			<!-- added 12/2022 by RMD -->

		</xsl:for-each>

		<xsl:call-template name="nalIssueInfo"/>

		<xsl:if
			test="mods:originInfo/mods:publisher[1] and (mods:originInfo/mods:publisher[1] != ' ')">
			<marc:subfield code="d">
				<xsl:value-of select="mods:originInfo/mods:publisher[1]"/>
			</marc:subfield>
		</xsl:if>

		<!--
	  <xsl:for-each select="mods:originInfo/mods:publisher">
	    <marc:subfield code="d">
	      <xsl:value-of select="."/>
	    </marc:subfield>
	  </xsl:for-each>
    -->

		<xsl:call-template name="relatedItemNames"/>

		<xsl:choose>
			<xsl:when test="@type = 'original'">
				<!-- 534 -->
				<xsl:for-each select="mods:physicalDescription/mods:extent">
					<marc:subfield code="e">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="@type != 'original'">
				<xsl:for-each select="mods:physicalDescription/mods:extent">
					<marc:subfield code="h">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
			</xsl:when>
		</xsl:choose>
		<!-- v3 displaylabel -->
		<xsl:for-each select="@displayLabel">
			<marc:subfield code="i">
				<xsl:value-of select="."/>
			</marc:subfield>
		</xsl:for-each>
		<xsl:for-each select="mods:note">
			<marc:subfield code="n">
				<xsl:value-of select="."/>
			</marc:subfield>
		</xsl:for-each>
		<xsl:for-each
			select="mods:identifier[not(@type)] | mods:identifier[@type = 'mmsid' and not(@invalid = 'yes')]">
			<marc:subfield code="w">
				<xsl:value-of select="."/>
			</marc:subfield>
		</xsl:for-each>
		<xsl:for-each select="mods:identifier[@type = 'local' and not(@invalid = 'yes')]">
			<!--<xsl:apply-templates select="mods:identifier[@type = 'local' and not(@invalid = 'yes')]" mode="relatedItem"/>-->
			<marc:subfield code="w">
				<xsl:choose>
					<xsl:when test="not(starts-with(text(), 'Journal'))">
						<xsl:text>Journal:</xsl:text>
						<xsl:value-of select="."/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="."/>
					</xsl:otherwise>
				</xsl:choose>
			</marc:subfield>

			<!--	<xsl:call-template name="nal787from773">
				<xsl:with-param name=""
					<xsl:text>1234</xsl:text>
				</xsl:with-param>
			</xsl:call-template>-->
		</xsl:for-each>
		<xsl:for-each select="mods:identifier[contains(@type, 'issn')]">
			<xsl:choose>
				<xsl:when test="@type = 'issn-e' and not(@invalid = 'yes')">
					<marc:subfield code="x">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:when>
				<xsl:when test="@type != 'issn' or @invalid = 'yes' and @type = 'issn-p'">
					<marc:subfield code="x">
						<xsl:value-of select="."/>
					</marc:subfield>		
				</xsl:when>
			</xsl:choose>
					</xsl:for-each>
		<xsl:for-each select="mods:identifier[@type = 'isbn' and not(@invalid = 'yes')]">
			<marc:subfield code="z">
				<xsl:value-of select="."/>
			</marc:subfield>
		</xsl:for-each>

		<!-- Changed by NAL -->
		<marc:subfield code="7">nnas</marc:subfield>
		<!-- remove the 773$9, by yli, 2019-08-07
   	<xsl:for-each select="mods:identifier[@type='local']">
   	  <xsl:if test="starts-with(text(), 'Journal:')">
   	  <marc:subfield code="9">
   		<xsl:value-of select="substring-after(text(), 'Journal:')"/>
   	  </marc:subfield>
   	  </xsl:if>
   	</xsl:for-each>
    -->
		<xsl:for-each select="mods:note">
			<marc:subfield code="n">
				<xsl:value-of select="."/>
			</marc:subfield>
		</xsl:for-each>
	</xsl:template>

	<xsl:template
		match="mods:identifier[@type = 'local' and not(@invalid = 'yes')] | mods:identifier[@type = 'mmsid' and not(../mods:identifier[@type = 'local' and not(@invalid = 'yes')])]"
		mode="relatedItem">
		<xsl:call-template name="datafields">
			<xsl:with-param name="tag">787</xsl:with-param>
			<xsl:with-param name="ind1">
				<xsl:text>1</xsl:text>
			</xsl:with-param>
			<xsl:with-param name="ind2">
				<xsl:text> </xsl:text>
			</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="o">
					<xsl:choose>
						<xsl:when
							test="not(starts-with(lower-case(text()), 'journal')) and not(starts-with(lower-case(text()), '(journal)'))">
							<xsl:text>(Journal)</xsl:text>
							<xsl:value-of select="."/>
						</xsl:when>
						<xsl:when test="starts-with(lower-case(text()), 'journal')">
							<xsl:value-of select="replace(., '[Jj]ournal(:){0,1}', '(Journal)')"/>
						</xsl:when>
						<xsl:when test="starts-with(lower-case(text()), '(journal)')">
							<xsl:sequence select="
									concat('(', upper-case(substring(., 2, 1)),
									substring(., 3),
									' '[not(last())]
									)
									"/>
						</xsl:when>
					</xsl:choose>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="mods:extension/mods:note[@type = 'warning']" mode="nal979">
		<xsl:call-template name="datafields">
			<xsl:with-param name="tag">979</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>

	</xsl:template>

	<xsl:template name="nalIssueInfo">
		<xsl:for-each select="mods:part">
			<marc:subfield code="g">
				<xsl:for-each select="mods:text[@type = 'year']">
					<xsl:value-of select="."/>
				</xsl:for-each>

				<xsl:choose>
					<xsl:when test="mods:text[@type = 'month']">
						<xsl:for-each select="mods:text[@type = 'month']">
							<xsl:text> </xsl:text>
							<xsl:choose>
								<xsl:when
									test=". = '1' or . = '01' or . = 'January' or . = 'Jan.' or . = 'Jan'"
									>Jan.</xsl:when>
								<xsl:when
									test=". = '2' or . = '02' or . = 'February' or . = 'Feb.' or . = 'Feb'"
									>Feb.</xsl:when>
								<xsl:when
									test=". = '3' or . = '03' or . = 'March' or . = 'Mar.' or . = 'Mar'"
									>Mar.</xsl:when>
								<xsl:when
									test=". = '4' or . = '04' or . = 'April' or . = 'Apr.' or . = 'Apr'"
									>Apr.</xsl:when>
								<xsl:when test=". = '5' or . = '05' or . = 'May'">May</xsl:when>
								<xsl:when
									test=". = '6' or . = '06' or . = 'June' or . = 'Jun.' or . = 'Jun'"
									>June</xsl:when>
								<xsl:when
									test=". = '7' or . = '07' or . = 'July' or . = 'Jul.' or . = 'Jul'"
									>July</xsl:when>
								<xsl:when
									test=". = '8' or . = '08' or . = 'August' or . = 'Aug.' or . = 'Aug'"
									>Aug.</xsl:when>
								<xsl:when
									test=". = '9' or . = '09' or . = 'September' or . = 'Sept.' or . = 'Sept'"
									>Sept.</xsl:when>
								<xsl:when
									test=". = '10' or . = 'October' or . = 'Oct.' or . = 'Oct'"
									>Oct.</xsl:when>
								<xsl:when
									test=". = '11' or . = 'November' or . = 'Nov.' or . = 'Nov'"
									>Nov.</xsl:when>
								<xsl:when
									test=". = '12' or . = 'December' or . = 'Dec.' or . = 'Dec'"
									>Dec.</xsl:when>
							</xsl:choose>

							<xsl:if test="../mods:text[@type = 'day']">
								<xsl:for-each select="../mods:text[@type = 'day']">
									<xsl:text> </xsl:text>
									<xsl:value-of select="text()"/>
								</xsl:for-each>
							</xsl:if>
							<xsl:text>, </xsl:text>
						</xsl:for-each>
					</xsl:when>

					<xsl:when test="not(mods:text[@type = 'month'])">
						<xsl:choose>
							<xsl:when test="mods:text[@type = 'season']">
								<xsl:for-each select="mods:text[@type = 'season']">
									<xsl:text> </xsl:text>
									<xsl:value-of select="text()"/>
									<xsl:text>, </xsl:text>
								</xsl:for-each>
							</xsl:when>

							<xsl:otherwise>
								<xsl:text>, </xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>

					<xsl:otherwise>
						<xsl:text>, </xsl:text>
					</xsl:otherwise>
				</xsl:choose>

				<!-- <xsl:if test="../detail[@type='volume']/number">
              <xsl:text>, </xsl:text>
              </xsl:if>  -->

				<xsl:if test="mods:detail">
					<xsl:variable name="parts">
						<xsl:if test="mods:detail[@type = 'volume']/mods:number">
							<xsl:for-each select="mods:detail[@type = 'volume']">
								<xsl:value-of select="mods:caption"/>
							</xsl:for-each>
							<xsl:text> </xsl:text>
							<xsl:for-each select="mods:detail[@type = 'volume']">
								<xsl:value-of select="mods:number"/>
							</xsl:for-each>
						</xsl:if>
						<xsl:if test="mods:detail[@type = 'issue']/mods:number">
							<xsl:for-each select="mods:detail[@type = 'issue']">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="mods:caption"/>
								<xsl:text> </xsl:text>
							</xsl:for-each>
							<xsl:for-each select="mods:detail[@type = 'issue']">
								<xsl:value-of select="mods:number"/>
							</xsl:for-each>
						</xsl:if>
					</xsl:variable>
					<xsl:value-of select="concat(substring($parts, 1, string-length($parts)), '')"/>
				</xsl:if>
				<xsl:if test="mods:extent/mods:start | mods:extent/mods:end"> p.<xsl:value-of
						select="mods:extent/mods:start"/>-<xsl:value-of
						select="mods:extent/mods:end"/>
				</xsl:if>
			</marc:subfield>
			<!-- </xsl:if> -->
			<!-- v3 sici part/detail 773$q  1:2:3<4-->
		</xsl:for-each>
	</xsl:template>

	<!--NAL Local Journal Info added January 2023 RMD-->
	<xsl:template name="nal914">
		<xsl:for-each select="mods:relatedItem[@type = 'host']">
			<xsl:call-template name="datafields">
				<xsl:with-param name="tag">914</xsl:with-param>
				<xsl:with-param name="subfields">
					<xsl:for-each select="mods:identifier[@type = 'local']">
						<marc:subfield code="a">
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:for-each>
					<xsl:for-each select="mods:identifier[@type = 'issn']">
						<marc:subfield code="b">
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:for-each>
					<xsl:for-each select="mods:part/mods:detail[@type = 'volume']/mods:number">
						<marc:subfield code="c">
							<xsl:text>v. </xsl:text>
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:for-each>
					<xsl:for-each select="mods:part/mods:detail[@type = 'issue']/mods:number">
						<marc:subfield code="d">
							<xsl:text>no. </xsl:text>
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:for-each>
					<xsl:for-each select="mods:part/mods:extent[@unit = 'pages' and mods:start]">
						<marc:subfield code="e">
							<xsl:text>p. </xsl:text>
							<xsl:value-of select="mods:start"/>
							<xsl:if test="mods:end">
								<xsl:text>-</xsl:text>
								<xsl:value-of select="mods:end"/>
							</xsl:if>
						</marc:subfield>
					</xsl:for-each>
					<xsl:for-each select="mods:titleInfo">
						<xsl:variable name="titleText">
							<xsl:choose>
								<xsl:when test="mods:nonSort">
									<xsl:value-of select="concat(mods:nonSort, ' ', mods:title)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="mods:title"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<marc:subfield code="f">
							<xsl:if test="mods:nonSort">
								<xsl:value-of select="mods:nonSort"/>
								<xsl:text> </xsl:text>
							</xsl:if>
							<xsl:value-of select="mods:title"/>
							<xsl:if test="mods:subTitle">
								<xsl:text>: </xsl:text>
								<xsl:value-of select="mods:subTitle"/>
							</xsl:if>
						</marc:subfield>
					</xsl:for-each>

					<xsl:for-each select="mods:part[mods:text]">
						<marc:subfield code="g">
							<xsl:for-each select="mods:text[@type = 'year']">
								<xsl:value-of select="."/>
							</xsl:for-each>

							<xsl:choose>
								<xsl:when test="mods:text[@type = 'month']">
									<xsl:for-each select="mods:text[@type = 'month']">
										<xsl:text> </xsl:text>
										<xsl:choose>
											<xsl:when
												test=". = '1' or . = '01' or . = 'January' or . = 'Jan.' or . = 'Jan'"
												>Jan.</xsl:when>
											<xsl:when
												test=". = '2' or . = '02' or . = 'February' or . = 'Feb.' or . = 'Feb'"
												>Feb.</xsl:when>
											<xsl:when
												test=". = '3' or . = '03' or . = 'March' or . = 'Mar.' or . = 'Mar'"
												>Mar.</xsl:when>
											<xsl:when
												test=". = '4' or . = '04' or . = 'April' or . = 'Apr.' or . = 'Apr'"
												>Apr.</xsl:when>
											<xsl:when test=". = '5' or . = '05' or . = 'May'"
												>May</xsl:when>
											<xsl:when
												test=". = '6' or . = '06' or . = 'June' or . = 'Jun.' or . = 'Jun'"
												>June</xsl:when>
											<xsl:when
												test=". = '7' or . = '07' or . = 'July' or . = 'Jul.' or . = 'Jul'"
												>July</xsl:when>
											<xsl:when
												test=". = '8' or . = '08' or . = 'August' or . = 'Aug.' or . = 'Aug'"
												>Aug.</xsl:when>
											<xsl:when
												test=". = '9' or . = '09' or . = 'September' or . = 'Sept.' or . = 'Sept'"
												>Sept.</xsl:when>
											<xsl:when
												test=". = '10' or . = 'October' or . = 'Oct.' or . = 'Oct'"
												>Oct.</xsl:when>
											<xsl:when
												test=". = '11' or . = 'November' or . = 'Nov.' or . = 'Nov'"
												>Nov.</xsl:when>
											<xsl:when
												test=". = '12' or . = 'December' or . = 'Dec.' or . = 'Dec'"
												>Dec.</xsl:when>
										</xsl:choose>

										<xsl:if test="../mods:text[@type = 'day']">
											<xsl:for-each select="../mods:text[@type = 'day']">
												<xsl:text> </xsl:text>
												<xsl:value-of select="text()"/>
											</xsl:for-each>
										</xsl:if>
									</xsl:for-each>
								</xsl:when>

								<xsl:when test="not(mods:text[@type = 'month'])">
									<xsl:choose>
										<xsl:when test="mods:text[@type = 'season']">
											<xsl:for-each select="mods:text[@type = 'season']">
												<xsl:text> </xsl:text>
												<xsl:value-of select="text()"/>
											</xsl:for-each>
										</xsl:when>
										<xsl:otherwise/>
									</xsl:choose>
								</xsl:when>

								<xsl:otherwise>
									<xsl:text>, </xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</marc:subfield>
					</xsl:for-each>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<!-- Publisher License (Rachel changed to 506 in August 2022) // Moved to main stylesheet in July 2023 to deal with multiple license refs. -->
	<!--<xsl:template match="mods:accessCondition[@type='use and reproduction']">
		<marc:datafields tag="540" ind1=" " ind2=" ">
			<marc:subfield code="a">
				<xsl:value-of select="@displayLabel"/>
			</marc:subfield>
			<xsl:apply-templates select="default:program/default:license_ref | program/license_ref"/>
			<marc:subfield code="u">
				<xsl:value-of select="."/>
			</marc:subfield>
		</marc:datafields>
	</xsl:template>

	<xsl:template match="default:program/default:license_ref | program/license_ref">
		<xsl:if test="not(@applies_to='')">
			<xsl:if test="@start_date">
				<marc:subfield code="g">
					<xsl:value-of select="replace(@start_date, '-', '')"/>
				</marc:subfield>
			</xsl:if>
			<xsl:if test="@applies_to">
				<xsl:choose>
					<xsl:when test="@applies_to='am'">
						<marc:subfield code="c">Accepted Manuscript</marc:subfield>
					</xsl:when>
					<xsl:when test="@applies_to='vor'">
						<marc:subfield code="c">Version of Record</marc:subfield>
					</xsl:when>
				</xsl:choose>
			</xsl:if>
		</xsl:if>
	</xsl:template>-->
	<!--<xsl:template match="mods:accessCondition[@type = 'use and reproduction' and *]">
		<marc:datafields ind1="0" ind2=" " tag="506">
			<marc:subfield code="a">
				<xsl:value-of select="@displayLabel"/>
			</marc:subfield>
			<xsl:apply-templates select="*[namespace-uri()='https://data.crossref.org/schemas/AccessIndicators.xsd' and local-name()='program']/*[namespace-uri()='https://data.crossref.org/schemas/AccessIndicators.xsd' and local-name()='licence_ref'] | program/license_ref | mods:program/mods:license_ref"/><!-\-
				select="default:program/default:license_ref | program/license_ref | mods:program/mods:license_ref | program[namespace-uri()='https://data.crossref.org/schemas/AccessIndicators.xsd']/license_ref[namespace-uri()='https://data.crossref.org/schemas/AccessIndicators.xsd']"/>-\->
			<marc:subfield code="f">
				<xsl:text>Unrestricted online access</xsl:text>
			</marc:subfield>
			<marc:subfield code="2">
				<xsl:text>star</xsl:text>
			</marc:subfield>
		</marc:datafields>
	</xsl:template>
	
	<xsl:template match="mods:accessCondition[starts-with(text(), 'Works produced by employees of the U.S. Government')]">
		<marc:datafields ind1="0" ind2=" " tag="506">
			<marc:subfield code="a">
				<xsl:value-of select="."/>
			</marc:subfield>            
			<marc:subfield code="f">
				<xsl:text>Unrestricted online access</xsl:text>
			</marc:subfield>
			<marc:subfield code="2">
				<xsl:text>star</xsl:text>
			</marc:subfield>
		</marc:datafields>
	</xsl:template>

	<xsl:template match="mods:accessCondition[@type = 'use and reproduction' and not(*)]">
		<marc:datafields ind1="0" ind2=" " tag="506">
			<marc:subfield code="a">
				<xsl:value-of select="normalize-space(.)"/>
			</marc:subfield>
		</marc:datafields>
	</xsl:template>-->

	<!--<xsl:template match="mods:accessCondition[@type = 'use and reproduction']">
		<xsl:apply-templates select="default:program/default:license_ref"/>
	</xsl:template>
	
	<xsl:template match="default:program/default:license_ref">
		<xsl:variable name="licenses" select=".[starts-with(., 'http')][1]"/>
		<xsl:variable name="theText" select="normalize-space(string-join(., ' '))"/>
		<xsl:variable name="result"
			select="$accessLookup/accessRights/licenses/lic[u = $licenses]"/>
		
		<xsl:call-template name="datafields">
			<xsl:with-param name="tag">506</xsl:with-param>
			
			<xsl:with-param name="subfields">
				<xsl:choose>
					<xsl:when test="$result != ''">
						
						<marc:subfield code="a">
							<xsl:value-of select="$result/a"/>
						</marc:subfield>
						<xsl:if test="$result/f != ''">
							<marc:subfield code="f">
								<xsl:value-of select="$result/f"/>
							</marc:subfield>
						</xsl:if>
						<xsl:if test="$result/two != ''">
							<marc:subfield code="2">
								<xsl:value-of select="$result/two"/>
							</marc:subfield>
						</xsl:if>
						<marc:subfield code="u"><xsl:value-of select="$licenses/text()"/></marc:subfield>
					</xsl:when>
					<xsl:when test="starts-with(lower-case(.), 'works produced by employees')">
						<marc:subfield code="a">Works produced by employees of the U.S. Government as part of their official duties are not copyrighted within the U.S. The content of this document is not copyrighted.</marc:subfield>
						<marc:subfield code="f">Unrestricted online access</marc:subfield>
						<marc:subfield code="2">star</marc:subfield>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="starts-with($theText, 'http')">
								<marc:subfield code="a">Use and reproduction</marc:subfield>
								<marc:subfield code="u">
									<xsl:value-of select="$theText"/>
								</marc:subfield>
							</xsl:when>
							<xsl:otherwise>
								<marc:subfield code="a">Use and reproduction: <xsl:value-of select="$theText"/></marc:subfield>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="$licenses[@start_date]">
					<marc:subfield code="g">
						<xsl:value-of select="replace($licenses/@start_date, '-', '')"/>
					</marc:subfield>
				</xsl:if>
				<!-\-				<xsl:if test="starts-with(lower-case(.), 'works produced by employees') = false()">
					<marc:subfield code="u">
						<xsl:value-of select="$licenses"/> line 1904
					</marc:subfield>
				</xsl:if>-\->
				<xsl:apply-templates select="@applies_to"/>
			</xsl:with-param>
			<xsl:with-param name="ind1">
				<xsl:choose>
					<xsl:when test="($result != '' and $result/ind1 != '') or starts-with(lower-case(.), 'works produced by employees')">
						<xsl:text>0</xsl:text>
					</xsl:when>
					<xsl:otherwise>1</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="mods:accessCondition[not(@type)]">
		<xsl:variable name="licenses" select="default:program/default:license_ref[1]"/>
		<xsl:variable name="theText" select="normalize-space(string-join(., ' '))"/>
		<xsl:call-template name="datafields">
			<xsl:with-param name="tag">506</xsl:with-param>
			<xsl:with-param name="subfields">
				<xsl:choose>
					<xsl:when test="$accessLookup/accessRights/licenses/lic[u = $licenses] != ''">
						<xsl:variable name="result"
							select="$accessLookup/accessRights/licenses/lic[u = $licenses]"/>
						<marc:subfield code="a">
							<xsl:value-of select="$result/a"/>
						</marc:subfield>
						<xsl:if test="$result/f != ''">
							<marc:subfield code="f">
								<xsl:value-of select="$result/f"/>
							</marc:subfield>
						</xsl:if>
						<xsl:if test="$result/two != ''">
							<marc:subfield code="2">
								<xsl:value-of select="$result/two"/>
							</marc:subfield>
						</xsl:if>
					</xsl:when>
					<xsl:when test="starts-with(lower-case(.), 'works produced by employees')">
						<marc:subfield code="a">Works produced by employees of the U.S. Governmentas part of their official duties are not copyrighted within the U.S. The content of this document is not copyrighted.</marc:subfield>
						<marc:subfield code="f">Unrestricted online access</marc:subfield>
						<marc:subfield code="2">star</marc:subfield>
					</xsl:when>
					<xsl:otherwise>
						<marc:subfield code="a">Use and reproduction</marc:subfield>
						<xsl:if test="starts-with(text(), 'http') = true()">
							<xsl:if test="starts-with($theText, 'http')">
								<marc:subfield code="u">
									<xsl:value-of select="$theText"/>
								</marc:subfield>
							</xsl:if>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="default:program/default:license_ref/@applies_to">
		<xsl:variable name="appTo" select="lower-case(.)"/>
		<xsl:if test="$accessLookup/accessRights/for/app[applies_to = $appTo] != ''">
			<marc:subfield code="3">
				<xsl:value-of select="$accessLookup/accessRights/for/app[applies_to = $appTo]/three"
				/>
			</marc:subfield>
		</xsl:if>
	</xsl:template>-->
</xsl:stylesheet>
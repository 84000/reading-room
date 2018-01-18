<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.daisy.org/z3986/2005/ncx/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:epub="http://www.idpf.org/2007/ops" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:m="http://read.84000.co/ns/1.0" xmlns:xhtml="http://www.w3.org/1999/xhtml" exclude-result-prefixes="#all" version="2.0">
    
    <xsl:param name="epub-id"/>
    
    <xsl:template match="/m:response">
        
        <ncx version="2005-1" xml:lang="en">
            <head>
                <meta name="dtb:uid" content="{$epub-id}"/>
                <meta name="dtb:depth" content="1"/>
                <meta name="dtb:totalPageCount" content="0"/>
                <meta name="dtb:maxPageNumber" content="0"/>
            </head>
            <docTitle>
                <text>
                    <xsl:value-of select="m:translation/m:titles/m:title[@xml:lang eq 'en']"/>
                </text>
            </docTitle>
            <navMap>
                <navPoint id="title">
                    <navLabel>
                        <text>Title</text>
                    </navLabel>
                    <content src="half-title.xhtml"/>
                </navPoint>
                <navPoint id="imprint">
                    <navLabel>
                        <text>Imprint</text>
                    </navLabel>
                    <content src="imprint.xhtml"/>
                </navPoint>
                <navPoint id="contents">
                    <navLabel>
                        <text>Contents</text>
                    </navLabel>
                    <content src="contents.xhtml"/>
                </navPoint>
                <navPoint id="summary">
                    <navLabel>
                        <text>Summary</text>
                    </navLabel>
                    <content src="summary.xhtml"/>
                </navPoint>
                <navPoint id="acknowledgements">
                    <navLabel>
                        <text>Acknowledgements</text>
                    </navLabel>
                    <content src="acknowledgements.xhtml"/>
                </navPoint>
                <navPoint id="introduction">
                    <navLabel>
                        <text>Introduction</text>
                    </navLabel>
                    <content src="introduction.xhtml"/>
                </navPoint>
                <xsl:if test="m:translation/m:prologue/xhtml:p">
                    <navPoint id="prologue">
                        <navLabel>
                            <text>Prologue</text>
                        </navLabel>
                        <content src="body.xhtml#prologue"/>
                    </navPoint>
                </xsl:if>
                <navPoint id="body-title">
                    <navLabel>
                        <text>The Translation</text>
                    </navLabel>
                    <content src="body.xhtml#body-title"/>
                </navPoint>
                <xsl:if test="m:translation/m:body/m:chapter[xhtml:h2 | xhtml:h4]">
                    <xsl:for-each select="m:translation/m:body/m:chapter">
                        <navPoint>
                            <xsl:attribute name="id" select="concat('chapter-', @chapter-index/string())"/>
                            <navLabel>
                                <text>
                                    <xsl:choose>
                                        <xsl:when test="xhtml:h2">
                                            <xsl:value-of select="@chapter-index"/>. <xsl:value-of select="xhtml:h2"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="xhtml:h4[@class = 'chapter-number']">
                                                    <xsl:value-of select="xhtml:h4[@class = 'chapter-number']"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    Chapter <xsl:value-of select="@chapter-index"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </text>
                            </navLabel>
                            <content>
                                <xsl:attribute name="src" select="concat('body.xhtml#chapter-', @chapter-index/string())"/>
                            </content>
                        </navPoint>
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="m:translation/m:colophon/xhtml:p">
                    <navPoint id="colophon">
                        <navLabel>
                            <text>Colophon</text>
                        </navLabel>
                        <content src="body.xhtml#colophon"/>
                    </navPoint>
                </xsl:if>
                <xsl:if test="m:translation/m:abbreviations/m:item">
                    <navPoint id="colophon">
                        <navLabel>
                            <text>Abbreviations</text>
                        </navLabel>
                        <content src="body.xhtml#abbreviations"/>
                    </navPoint>
                </xsl:if>
                <navPoint id="notes">
                    <navLabel>
                        <text>Notes</text>
                    </navLabel>
                    <content src="body.xhtml#notes"/>
                </navPoint>
                <xsl:if test="m:translation/m:appendix//xhtml:p">
                    <navPoint id="appendix">
                        <navLabel>
                            <text>Appendix</text>
                        </navLabel>
                        <content src="body.xhtml#appendix"/>
                    </navPoint>
                </xsl:if>
                <navPoint id="bibliography">
                    <navLabel>
                        <text>Bibliography</text>
                    </navLabel>
                    <content src="bibliography.xhtml"/>
                </navPoint>
                <navPoint id="glossary">
                    <navLabel>
                        <text>Glossary</text>
                    </navLabel>
                    <content src="glossary.xhtml"/>
                </navPoint>
            </navMap>
        </ncx>
    </xsl:template>
</xsl:stylesheet>
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:epub="http://www.idpf.org/2007/ops" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:m="http://read.84000.co/ns/1.0" xmlns:xhtml="http://www.w3.org/1999/xhtml" exclude-result-prefixes="#all" version="2.0">
    <xsl:include href="epub-page.xsl"/>
    <xsl:variable name="page-title" select="'Contents'"/>
    <xsl:template match="/m:response">
        <xsl:variable name="content">
            <div class="center header-lg">
                <h2>Table of Contents</h2>
            </div>
            <nav epub:type="toc" class="contents">
                <ol>
                    <li>
                        <a href="half-title.xhtml">Title</a>
                    </li>
                    <li>
                        <a href="imprint.xhtml">Imprint</a>
                    </li>
                    <li>
                        <a href="contents.xhtml">Contents</a>
                    </li>
                    <li>
                        <a href="summary.xhtml">Summary</a>
                    </li>
                    <li>
                        <a href="acknowledgements.xhtml">Acknowledgements</a>
                    </li>
                    <li>
                        <a href="introduction.xhtml">Introduction</a>
                    </li>
                    <xsl:if test="m:translation/m:prologue/xhtml:p">
                        <li>
                            <a href="prologue.xhtml">Prologue</a>
                        </li>
                    </xsl:if>
                    <li>
                        <a href="body.xhtml#body-title">The Translation</a>
                    </li>
                    <xsl:if test="m:translation/m:body/m:chapter[xhtml:h2 | xhtml:h4]">
                        <xsl:for-each select="m:translation/m:body/m:chapter">
                            <li>
                                <a>
                                    <xsl:attribute name="href" select="concat('body.xhtml#chapter-', @chapter-index/string())"/>
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
                                </a>
                            </li>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:if test="m:translation/m:colophon/xhtml:p">
                        <li>
                            <a href="body.xhtml#colophon">Colophon</a>
                        </li>
                    </xsl:if>
                    <xsl:if test="m:translation/m:abbreviations/m:item">
                        <li>
                            <a href="body.xhtml#abbreviations">Abbreviations</a>
                        </li>
                    </xsl:if>
                    <li>
                        <a href="body.xhtml#notes">Notes</a>
                    </li>
                    <xsl:if test="m:translation/m:appendix//xhtml:p">
                        <li>
                            <a href="body.xhtml#appendix">Appendix</a>
                        </li>
                    </xsl:if>
                    <li>
                        <a href="bibliography.xhtml">Bibliography</a>
                    </li>
                    <li>
                        <a href="glossary.xhtml">Glossary</a>
                    </li>
                </ol>
            </nav>
        </xsl:variable>
        <xsl:call-template name="epub-page">
            <xsl:with-param name="translation-title" select="m:translation/m:titles/m:title[@xml:lang eq 'en']"/>
            <xsl:with-param name="page-title" select="$page-title"/>
            <xsl:with-param name="content" select="$content"/>
        </xsl:call-template>
    </xsl:template>
</xsl:stylesheet>
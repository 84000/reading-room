<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:epub="http://www.idpf.org/2007/ops" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:m="http://read.84000.co/ns/1.0" xmlns:xhtml="http://www.w3.org/1999/xhtml" exclude-result-prefixes="#all" version="2.0">
    <xsl:import href="epub-page.xsl"/>
    <xsl:variable name="page-title" select="'Body'"/>
    <xsl:template match="/m:response">
        <xsl:variable name="content">
            <section id="body-title">
                <div class="center half-title">
                    <xsl:if test="m:translation/m:body/m:honoration/text()">
                        <h2>
                            <xsl:value-of select="m:translation/m:body/m:honoration"/>
                        </h2>
                    </xsl:if>
                    <h1>
                        <xsl:value-of select="m:translation/m:body/m:main-title"/>
                    </h1>
                </div>
            </section>
            <xsl:if test="m:translation/m:prologue/xhtml:p">
                <section id="prologue" epub:type="prologue">
                    <xsl:copy-of select="m:translation/m:prologue/xhtml:*"/>
                </section>
            </xsl:if>
            <xsl:for-each select="m:translation/m:body/m:chapter">
                <section epub:type="chapter">
                    <xsl:attribute name="id" select="concat('chapter-', @chapter-index/string())"/>
                    <xsl:if test="xhtml:h2">
                        <xsl:if test="not(xhtml:h4[@class = 'chapter-number'])">
                            <h4>
                                Chapter <xsl:value-of select="@chapter-index"/>
                            </h4>
                        </xsl:if>
                    </xsl:if>
                    <xsl:copy-of select="xhtml:*"/>
                </section>
            </xsl:for-each>
            <xsl:if test="m:translation/m:colophon/xhtml:p">
                <section id="colophon" epub:type="colophon">
                    <div class="center header-lg">
                        <h2>Colophon</h2>
                    </div>
                    <xsl:copy-of select="m:translation/m:colophon/xhtml:*"/>
                </section>
            </xsl:if>
            <aside id="notes">
                <div class="center header-lg">
                    <h2>Notes</h2>
                </div>
                <xsl:for-each select="m:translation/m:notes/m:note">
                    <p class="footnote" epub:type="footnote">
                        <xsl:attribute name="id" select="@uid"/>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="concat('#link-to-', @uid)"/>
                            </xsl:attribute>
                            <xsl:value-of select="@index"/>
                        </a>
                        <xsl:copy-of select="node()"/>
                    </p>
                </xsl:for-each>
            </aside>
            <xsl:if test="m:translation/m:appendix//xhtml:p">
                <section id="appendix">
                    <div class="center header-lg">
                        <h2>Appendix</h2>
                    </div>
                    <xsl:for-each select="m:translation/m:appendix/m:chapter | m:translation/m:appendix/m:prologue">
                        <div class="chapter">
                            <xsl:copy-of select="xhtml:*"/>
                        </div>
                    </xsl:for-each>
                </section>
            </xsl:if>
        </xsl:variable>
        <xsl:call-template name="epub-page">
            <xsl:with-param name="translation-title" select="m:translation/m:titles/m:title[@xml:lang eq 'en']"/>
            <xsl:with-param name="page-title" select="$page-title"/>
            <xsl:with-param name="content" select="$content"/>
        </xsl:call-template>
    </xsl:template>
</xsl:stylesheet>
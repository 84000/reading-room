<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:epub="http://www.idpf.org/2007/ops" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:m="http://read.84000.co/ns/1.0" xmlns:xhtml="http://www.w3.org/1999/xhtml" exclude-result-prefixes="#all" version="2.0">
    
    <xsl:import href="../../../xslt/tei-to-xhtml.xsl"/>
    <xsl:import href="epub-page.xsl"/>
    <xsl:variable name="page-title" select="'Body'"/>
    
    <xsl:template match="/m:response">
        
        <xsl:variable name="content">
            
            <section id="introduction">
                <div class="center header">
                    <h2>
                        <xsl:value-of select="$page-title"/>
                    </h2>
                </div>
                <div class="text">
                    <xsl:apply-templates select="m:translation/m:introduction"/>
                </div>
            </section>
            
            <section id="body-title">
                <div class="center half-title">
                    <xsl:if test="m:translation/m:body/m:honoration/text()">
                        <h2>
                            <xsl:apply-templates select="m:translation/m:body/m:honoration"/>
                        </h2>
                    </xsl:if>
                    <h1>
                        <xsl:apply-templates select="m:translation/m:body/m:main-title"/>
                    </h1>
                </div>
            </section>
            
            <xsl:if test="m:translation/m:prologue/tei:p">
                <section id="prologue" epub:type="prologue">
                    <xsl:apply-templates select="m:translation/m:prologue"/>
                </section>
            </xsl:if>
            
            <xsl:for-each select="m:translation/m:body/m:chapter">
                <section class="translation" epub:type="chapter">
                    <xsl:attribute name="id" select="concat('chapter-', @chapter-index/string())"/>
                    <xsl:variable name="chapter-index" select="@chapter-index/string()"/>
                    
                    <xsl:if test="m:title/text() or m:title-number/text()">
                        <div class="center header">
                            <xsl:if test="m:title-number/text()">
                                <h4 class="chapter-number">
                                    <xsl:apply-templates select="m:title-number/text()"/>
                                </h4>
                            </xsl:if>
                            <xsl:if test="m:title/text()">
                                <h2>
                                    <xsl:apply-templates select="m:title/text()"/>
                                </h2>
                            </xsl:if>
                        </div>
                    </xsl:if>
                    
                    <div class="text">
                        <xsl:apply-templates select="tei:*"/>
                    </div>
                    
                </section>
            </xsl:for-each>
            
            <xsl:if test="m:translation/m:colophon/tei:p">
                <section id="colophon" class="translation" epub:type="colophon">
                    <div class="center header">
                        <h2>Colophon</h2>
                    </div>
                    <div class="text">
                        <xsl:apply-templates select="m:translation/m:colophon"/>
                    </div>
                </section>
            </xsl:if>
            
            <xsl:if test="m:translation/m:appendix//tei:p">
                <section id="appendix" class="translation" epub:type="appendix">
                    <div class="center header">
                        <h2>Appendix</h2>
                    </div>
                    <xsl:for-each select="m:translation/m:appendix/m:chapter">
                        
                        <div class="chapter">
                            
                            <h4>
                                <xsl:apply-templates select="m:title"/>
                            </h4>
                            
                            <div class="text">
                                <xsl:apply-templates select="tei:*"/>
                            </div>
                        </div>
                    </xsl:for-each>
                </section>
            </xsl:if>
            
            <xsl:if test="m:translation/m:abbreviations/m:item">
                <section id="abbreviations">
                    <div class="center header">
                        <h2>
                            Abbreviations
                        </h2>
                    </div>
                    <xsl:if test="m:translation/m:abbreviations/m:head">
                        <h5>
                            <xsl:apply-templates select="m:translation/m:abbreviations/m:head/text()"/>
                        </h5>
                    </xsl:if>
                    <table>
                        <tbody>
                            <xsl:for-each select="m:translation/m:abbreviations/m:item">
                                <xsl:sort select="m:abbreviation/text()"/>
                                <tr>
                                    <th>
                                        <xsl:apply-templates select="m:abbreviation/text()"/>
                                    </th>
                                    <td>
                                        <xsl:apply-templates select="m:explanation/node()"/>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </tbody>
                    </table>
                    <xsl:if test="m:translation/m:abbreviations/m:foot">
                        <p>
                            <xsl:apply-templates select="m:translation/m:abbreviations/m:foot/text()"/>
                        </p>
                    </xsl:if>
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
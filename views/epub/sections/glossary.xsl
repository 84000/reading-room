<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:common="http://read.84000.co/common" xmlns:epub="http://www.idpf.org/2007/ops" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:m="http://read.84000.co/ns/1.0" xmlns:xhtml="http://www.w3.org/1999/xhtml" exclude-result-prefixes="#all" version="2.0">
    
    <xsl:import href="../../../xslt/functions.xsl"/>
    <xsl:import href="epub-page.xsl"/>
    <xsl:variable name="page-title" select="'Glossary'"/>
    
    <xsl:template match="/m:response">
        <xsl:variable name="content">
            <section>
                <div class="center header-lg">
                    <h2>
                        <xsl:value-of select="$page-title"/>
                    </h2>
                </div>
                <xsl:for-each select="m:translation/m:glossary/m:item">
                    <xsl:sort select="common:standardized-sa(m:term[lower-case(@xml:lang) = 'en'][1])"/>
                    <div class="glossary-item">
                        <h4 class="term">
                            <xsl:value-of select="m:term[lower-case(@xml:lang) = 'en']"/>
                        </h4>
                        <xsl:for-each select="m:term[lower-case(@xml:lang) != 'en']">
                            <p>
                                <xsl:attribute name="class" select="common:lang-class(@xml:lang)"/>
                            </p>
                        </xsl:for-each>
                        <xsl:for-each select="m:alternatives/m:alternative">
                            <p>
                                <xsl:value-of select="text()"/>
                            </p>
                        </xsl:for-each>
                        <xsl:for-each select="m:definitions/m:definition">
                            <p>
                                <xsl:copy-of select="node()"/>
                            </p>
                        </xsl:for-each>
                    </div>
                </xsl:for-each>
            </section>
        </xsl:variable>
        <xsl:call-template name="epub-page">
            <xsl:with-param name="translation-title" select="m:translation/m:titles/m:title[@xml:lang eq 'en']"/>
            <xsl:with-param name="page-title" select="$page-title"/>
            <xsl:with-param name="content" select="$content"/>
        </xsl:call-template>
    </xsl:template>
</xsl:stylesheet>
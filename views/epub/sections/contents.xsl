<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:epub="http://www.idpf.org/2007/ops" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:m="http://read.84000.co/ns/1.0" exclude-result-prefixes="#all" version="2.0">
    <xsl:include href="epub-page.xsl"/>
    <xsl:variable name="page-title" select="'Contents'"/>
    <xsl:template match="/m:response">
        <xsl:variable name="content">
            <nav epub:type="toc" class="contents">
                <ol>
                    <li>
                        <a href="half-title.xhtml">Title</a>
                    </li>
                    <li>
                        <a href="imprint.xhtml">Imprint</a>
                    </li>
                    <li>
                        <a href="summary.xhtml">Summary</a>
                    </li>
                    <li>
                        <a href="acknowledgments.xhtml">Acknowledgments</a>
                    </li>
                    <li>
                        <a href="introduction.xhtml">Introduction</a>
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
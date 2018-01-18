<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:epub="http://www.idpf.org/2007/ops" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:m="http://read.84000.co/ns/1.0" exclude-result-prefixes="#all" version="2.0">
    <xsl:include href="epub-page.xsl"/>
    <xsl:variable name="page-title" select="'Full Title'"/>
    <xsl:template match="/m:response">
        <xsl:variable name="content">
            <section class="center full-title" epub:type="titlepage">
                <h2 class="text-bo">
                    <xsl:value-of select="m:translation/m:long-titles/m:title[@xml:lang eq 'bo']"/>
                </h2>
                <h2>
                    <xsl:value-of select="m:translation/m:long-titles/m:title[@xml:lang eq 'bo-ltn']"/>
                </h2>
                <h1>
                    <xsl:value-of select="m:translation/m:long-titles/m:title[@xml:lang eq 'en']"/>
                </h1>
                <h2 class="text-sa">
                    <xsl:value-of select="m:translation/m:long-titles/m:title[@xml:lang eq 'sa-ltn']"/>
                </h2>
                <h3>
                    <xsl:value-of select="m:translation/m:source/m:toh"/>
                </h3>
                <p>
                    <xsl:value-of select="string-join(m:translation/m:source/m:series/text() | m:translation/m:source/m:scope/text() | m:translation/m:source/m:range/text(), ', ')"/>.
                </p>
                <xsl:for-each select="m:translation/m:translation/m:authors/m:summary">
                    <p class="translator">
                        <xsl:copy-of select="node()"/>
                    </p>
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
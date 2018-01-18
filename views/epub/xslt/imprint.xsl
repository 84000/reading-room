<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:epub="http://www.idpf.org/2007/ops" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:m="http://read.84000.co/ns/1.0" xmlns:xhtml="http://www.w3.org/1999/xhtml" exclude-result-prefixes="#all" version="2.0">
    <xsl:include href="epub-page.xsl"/>
    <xsl:variable name="page-title" select="'Imprint'"/>
    <xsl:template match="/m:response">
        <xsl:variable name="content">
            <section class="imprint center">
                <h5>
                    <xsl:copy-of select="m:translation/m:translation/m:edition/node()"/>
                </h5>
                <div class="space-before">
                    <img src="image/logo-stacked.png" alt="84000 Translating the Words of the Buddha Logo" class="logo logo-84000"/>
                    <p>
                        <xsl:copy-of select="m:translation/m:translation/m:publication-statement/node()"/>
                    </p>
                </div>
                <div class="space-before">
                    <img src="image/CC_logo.png" alt="Creative Commons Logo" class="logo"/>
                    <p class="small italic">
                        <xsl:copy-of select="m:translation/m:translation/m:license/xhtml:p/node()"/>
                    </p>
                </div>
            </section>
        </xsl:variable>
        <xsl:call-template name="epub-page">
            <xsl:with-param name="translation-title" select="m:translation/m:titles/m:title[@xml:lang eq 'en']"/>
            <xsl:with-param name="page-title" select="$page-title"/>
            <xsl:with-param name="content" select="$content"/>
        </xsl:call-template>
    </xsl:template>
</xsl:stylesheet>
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:epub="http://www.idpf.org/2007/ops" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:m="http://read.84000.co/ns/1.0" xmlns:xhtml="http://www.w3.org/1999/xhtml" exclude-result-prefixes="#all" version="2.0">
    
    <xsl:import href="../../../xslt/tei-to-xhtml.xsl"/>
    <xsl:include href="epub-page.xsl"/>
    <xsl:variable name="page-title" select="'Notes'"/>
    
    <xsl:template match="/m:response">
        
        <xsl:variable name="content">
            <aside id="notes">
                <div class="center header">
                    <h2>Notes</h2>
                </div>
                <xsl:for-each select="m:translation/m:notes/m:note">
                    <div class="footnote rw">
                        <xsl:attribute name="id" select="@uid"/>
                        
                        <xsl:variable name="target-id" select="@uid"/>
                        <xsl:variable name="target" select="/m:response//*[@xml:id eq $target-id]"/>
                        <xsl:variable name="group" select="$target/ancestor::*[exists(@prefix)][1]"/>
                        <xsl:variable name="location" select="$group/local-name()"/>
                        <xsl:variable name="chapter-index" select="$group/@chapter-index"/>
                        
                        <div class="gtr">
                            <a class="footnote-number">
                                <xsl:attribute name="href">
                                    <xsl:choose>
                                        <xsl:when test="$location eq 'introduction'">
                                            <xsl:value-of select="concat('introduction.xhtml#link-to-', @uid)"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="concat('body.xhtml#link-to-', @uid)"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                                <xsl:apply-templates select="@index"/>
                            </a>
                        </div>
                        
                        <div epub:type="footnote">
                            <xsl:apply-templates select="node()"/>
                        </div>
                        
                    </div>
                </xsl:for-each>
            </aside>
        </xsl:variable>
        
        <xsl:call-template name="epub-page">
            <xsl:with-param name="translation-title" select="m:translation/m:titles/m:title[@xml:lang eq 'en']"/>
            <xsl:with-param name="page-title" select="$page-title"/>
            <xsl:with-param name="content" select="$content"/>
        </xsl:call-template>
        
    </xsl:template>
</xsl:stylesheet>
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exist="http://exist.sourceforge.net/NS/exist" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
    
    
    <xsl:template match="tei:p | tei:lg | tei:ab | tei:trailer | tei:head">
        <p>
            <xsl:apply-templates select="node()"/>
        </p>
        <div class="indent">
            <xsl:for-each select="//tei:note">
                <p class="footnote">
                    <a class="footnote-number">
                        <xsl:value-of select="@index"/>
                    </a>
                    <xsl:apply-templates select="node()"/>
                </p>
            </xsl:for-each>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:note">
        <sup>
            <a class="footnote">
                <xsl:attribute name="href">
                    <xsl:value-of select="concat('#footnote-', @index)"/>
                </xsl:attribute>
                <xsl:attribute name="id">
                    <xsl:value-of select="concat('footnote-link', @index)"/>
                </xsl:attribute>
                <xsl:value-of select="@index"/>
            </a>
        </sup>
    </xsl:template>
    
    <xsl:template match="exist:match">
        <span class="mark">
            <xsl:apply-templates select="text()"/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:title">
        <em>
            <xsl:apply-templates select="node()"/>
        </em>
    </xsl:template>
    
    <xsl:template match="tei:foreign">
        <span>
            <xsl:apply-templates select="node()"/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:gloss">
        <xsl:for-each select="tei:term">
            <span>
                <xsl:apply-templates select="node()"/>
            </span>
            <br/>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>
    
    <xsl:template match="tei:date">
        <span class="date">
            <xsl:apply-templates select="text()"/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:l">
        <xsl:apply-templates select="node()"/>
        <br/>
    </xsl:template>
    
</xsl:stylesheet>
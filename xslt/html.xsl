<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exist="http://exist.sourceforge.net/NS/exist" xmlns:common="http://read.84000.co/common" xmlns:epub="http://www.idpf.org/2007/ops" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="#all">
    <!-- 
        Converts other xml to valid xhtml
    -->
    
    <xsl:import href="functions.xsl"/>
    <xsl:output method="html" indent="no"/>
    
    <xsl:param name="doc-type"/>
    <xsl:param name="glossarize"/>
    
    <xsl:template match="text()">
        <xsl:value-of select="translate(normalize-space(concat('', translate(., '&#xA;', ''), '')), '', '')"/>
    </xsl:template>
    
    <xsl:template match="exist:match">
        <span class="mark">
            <xsl:apply-templates select="text()"/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:title">
        <span>
            <xsl:attribute name="class">
                <xsl:value-of select="concat(normalize-space(common:lang-class(@xml:lang)), common:echo-for-doc-type($doc-type, 'www', common:glossarize-class($glossarize, 'glossarize-complete')), ' title')"/>
            </xsl:attribute>
            <xsl:apply-templates select="node()"/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:foreign">
        <span>
            <xsl:attribute name="class">
                <xsl:value-of select="concat(normalize-space(common:lang-class(@xml:lang)), common:echo-for-doc-type($doc-type, 'www', common:glossarize-class($glossarize, 'glossarize-complete')), ' foreign')"/>
            </xsl:attribute>
            <xsl:apply-templates select="node()"/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:emph">
        <em>
            <xsl:attribute name="class">
                <xsl:value-of select="concat(normalize-space(common:lang-class(@xml:lang)), common:echo-for-doc-type($doc-type, 'www', common:glossarize-class($glossarize, 'glossarize-complete')))"/>
            </xsl:attribute>
            <xsl:apply-templates select="node()"/>
        </em>
    </xsl:template>
    
    <xsl:template match="tei:distinct">
        <em>
            <xsl:attribute name="class">
                <xsl:value-of select="concat(normalize-space(common:lang-class(@xml:lang)), common:echo-for-doc-type($doc-type, 'www', common:glossarize-class($glossarize, 'glossarize-complete')))"/>
            </xsl:attribute>
            <xsl:apply-templates select="node()"/>
        </em>
    </xsl:template>
    
    <xsl:template match="tei:name">
        <span>
            <xsl:attribute name="class">
                <xsl:value-of select="concat('name ', normalize-space(common:lang-class(@xml:lang)), common:echo-for-doc-type($doc-type, 'www', common:glossarize-class($glossarize, 'glossarize-complete')))"/>
            </xsl:attribute>
            <xsl:apply-templates select="node()"/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:term">
        <span>
            <xsl:choose>
                <xsl:when test="@type eq 'ignore'">
                    <xsl:attribute name="class" select="'ignore'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="class" select="concat('term', common:echo-for-doc-type($doc-type, 'www', common:glossarize-class($glossarize, 'glossarize-complete')))"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:value-of select="text()"/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:note">
        <a class="footnote-link pop-up">
            <xsl:attribute name="href" select="concat('#', @xml:id)"/>
            <xsl:attribute name="id" select="concat('link-to-', @xml:id)"/>
            <xsl:if test="$doc-type eq 'epub'">
                <xsl:attribute name="epub:type" select="'noteref'"/>
            </xsl:if>
            <xsl:apply-templates select="@index"/>
        </a>
    </xsl:template>
    
    <xsl:template match="tei:date">
        <span class="date">
            <xsl:apply-templates select="text()"/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:item">
        <xsl:apply-templates select="node()"/>
        <br/>
    </xsl:template>
    
    <xsl:template match="tei:gloss">
        <a class="glossary">
            <xsl:attribute name="href" select="concat('#glossary-', @uid)"/>
            <xsl:apply-templates select="text()"/>
        </a>
    </xsl:template>
    
    <xsl:template match="tei:ref">
        <xsl:choose>
            <xsl:when test="@cRef">
                <span class="ref">[<xsl:value-of select="@cRef"/>]</span>
            </xsl:when>
            <xsl:when test="@target">
                <a target="_blank">
                    <xsl:attribute name="href">
                        <xsl:value-of select="@target"/>
                    </xsl:attribute>
                    <xsl:attribute name="title">
                        <xsl:value-of select="@target"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="text()"/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="text()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:lb">
        <!-- Only if there's not already a space before -->
        <xsl:if test="not(common:space-before(following-sibling::*[1]))">
            <br/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:ptr">
        <a class="internal-ref scroll-to-anchor">
            <xsl:attribute name="href" select="@target"/>
            <xsl:value-of select="text()"/>
        </a>
    </xsl:template>
    
</xsl:stylesheet>
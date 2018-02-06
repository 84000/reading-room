<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:common="http://read.84000.co/common" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:m="http://read.84000.co/ns/1.0" version="2.0" exclude-result-prefixes="#all">
    
    <xsl:output method="html" indent="no" doctype-system="about:legacy-compat"/>
    
    <xsl:template match="/m:response">
        <h3>
            <xsl:value-of select="concat('Folio ', @folio)"/>
        </h3>
        <hr/>
        <xsl:apply-templates select="m:source[@name eq 'ekangyur']/m:language[@xml:lang eq 'bo']"/>
        <hr/>
        <p class="text-muted text-small">
            <xsl:value-of select="concat('eKangyur ', m:source[@name eq 'ekangyur']/@title, ', page ', m:source[@name eq 'ekangyur']/@page, '.')"/>
        </p>
    </xsl:template>
    
    <xsl:template match="tei:p">
        <p class="text-bo source">
            <xsl:apply-templates select="node()"/>
        </p>
    </xsl:template>
    
    <xsl:template match="tei:milestone[@unit eq 'line']">
        <xsl:if test="@n ne '1'">
            <br/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="text()">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>
    
</xsl:stylesheet>
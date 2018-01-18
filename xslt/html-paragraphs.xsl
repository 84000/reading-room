<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:common="http://read.84000.co/common" xmlns:epub="http://www.idpf.org/2007/ops" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="#all">
    <!-- 
        Converts other xml to valid xhtml p elements
    -->
    
    <xsl:import href="html.xsl"/>
    
    <xsl:param name="prefix"/>
    <xsl:param name="doc-type"/>
    <xsl:param name="glossarize"/>
    
    <xsl:template match="tei:q">
        <xsl:choose>
            <xsl:when test="parent::tei:p">
                <span class="blockquote">
                    <xsl:apply-templates select="node()"/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <blockquote>
                    <xsl:attribute name="class" select="normalize-space(common:echo-for-doc-type($doc-type, 'www', concat(common:glossarize-class($glossarize, 'glossarize'),' relative')))"/>
                    <xsl:call-template name="milestone"/>
                    <xsl:apply-templates select="node()"/>
                </blockquote>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:list[tei:item]">
        <div class="relative">
            <xsl:call-template name="milestone"/>
            <xsl:if test="tei:head">
                <h5 class="relative">
                    <!-- temporary id -->
                    <xsl:if test="tei:head/@tid">
                        <xsl:attribute name="id" select="concat('node', '-', tei:head/@tid)"/>
                    </xsl:if>
                    <xsl:value-of select="tei:head"/>
                </h5>
            </xsl:if>
            <ul class="line-group">
                <xsl:apply-templates select="node()"/>
            </ul>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:item[parent::tei:list]">
        <li>
            <xsl:call-template name="milestone"/>
            <xsl:apply-templates select="node()"/>
        </li>
    </xsl:template>
    
    <xsl:template match="tei:p | tei:ab | tei:trailer | tei:label | tei:bibl">
        <p>
            <!-- temporary id -->
            <xsl:if test="@tid">
                <xsl:attribute name="id" select="concat('node', '-', @tid)"/>
            </xsl:if>
            <!-- class -->
            <xsl:variable name="cssClass">
                <!-- Space the paragraphs -->
                <xsl:if test="common:space-before(.)">
                    space 
                </xsl:if>
                <xsl:if test="self::tei:ab[@type = 'mantra']">
                    mantra 
                </xsl:if>
                <xsl:if test="self::tei:label">
                    section-label 
                </xsl:if>
                <xsl:if test="self::tei:trailer">
                    trailer 
                </xsl:if>
                <xsl:if test="self::tei:lg">
                    line-group 
                </xsl:if>
            </xsl:variable>
            <xsl:attribute name="class" select="normalize-space(concat($cssClass, common:echo-for-doc-type($doc-type, 'www', common:glossarize-class($glossarize, 'glossarize'))))"/>
            <xsl:call-template name="milestone"/>
            <xsl:apply-templates select="node()"/>
        </p>
    </xsl:template>
    
    <xsl:template match="tei:lg">
        <div>
            <!-- temporary id -->
            <xsl:if test="@tid">
                <xsl:attribute name="id" select="concat('node', '-', @tid)"/>
            </xsl:if>
            <!-- class -->
            <xsl:variable name="cssClass">
                line-group 
                <!-- Space the paragraphs -->
                <xsl:if test="common:space-before(.)">
                    space 
                </xsl:if>
            </xsl:variable>
            <xsl:attribute name="class" select="normalize-space($cssClass)"/>
            <xsl:call-template name="milestone"/>
            <xsl:apply-templates select="node()"/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:l[parent::tei:lg]">
        <p>
            <xsl:attribute name="class">
                <xsl:value-of select="normalize-space(common:echo-for-doc-type($doc-type, 'www', common:glossarize-class($glossarize, 'glossarize')))"/>
            </xsl:attribute>
            <xsl:call-template name="milestone"/>
            <xsl:apply-templates select="node()"/>
        </p>
    </xsl:template>
    
    <xsl:template match="tei:head">
        <xsl:choose>
            <xsl:when test="@type = ('chapter')">
                <h4 class="chapter-number">
                    <xsl:value-of select="text()"/>
                </h4>
            </xsl:when>
            <xsl:when test="@type = ('chapterTitle')">
                <h2>
                    <xsl:value-of select="text()"/>
                </h2>
            </xsl:when>
            <xsl:when test="@type = ('section')">
                <h4>
                    <xsl:value-of select="text()"/>
                </h4>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <!-- Milestone -->
    <xsl:template name="milestone">
        <xsl:if test="preceding-sibling::*[1][self::tei:milestone] or (preceding-sibling::*[1][self::tei:lb] and preceding-sibling::*[2][self::tei:milestone])">
            <xsl:variable name="id" select="preceding-sibling::*[1]/@xml:id"/>
            <xsl:variable name="milestone-index" select="common:index-of-node(//tei:milestone, preceding-sibling::tei:milestone[1])"/>
            <xsl:choose>
                <xsl:when test="$doc-type eq 'epub'">
                    <span class="milestone">
                        <xsl:value-of select="concat($prefix, '.', '​', $milestone-index)"/>
                    </span>
                </xsl:when>
                <xsl:otherwise>
                    <a class="milestone" title="Bookmark this section">
                        <xsl:attribute name="href" select="concat('#', $id)"/>
                        <xsl:attribute name="id" select="$id"/>
                        <xsl:value-of select="concat($prefix, '.', '​', $milestone-index)"/>
                    </a>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exist="http://exist.sourceforge.net/NS/exist" xmlns:common="http://read.84000.co/common" xmlns:epub="http://www.idpf.org/2007/ops" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:m="http://read.84000.co/ns/1.0" version="2.0" exclude-result-prefixes="#all">
    
    <!-- 
        Converts other tei to xhtml
    -->
    
    <xsl:import href="functions.xsl"/>
    
    <xsl:template match="text()">
        <xsl:value-of select="translate(normalize-space(concat('', translate(., '&#xA;', ''), '')), '', '')"/>
    </xsl:template>
    
    <xsl:template match="tei:title">
        <span>
            <xsl:attribute name="class">
                <xsl:value-of select="concat(normalize-space(common:lang-class(@xml:lang)), ' glossarize-complete', ' title')"/>
            </xsl:attribute>
            <xsl:apply-templates select="node()"/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:name">
        <span>
            <xsl:attribute name="class">
                <xsl:value-of select="concat('name ', normalize-space(common:lang-class(@xml:lang)), ' glossarize-complete')"/>
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
                    <xsl:attribute name="class" select="'term'"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="node()"/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:foreign">
        <span>
            <xsl:attribute name="class">
                <xsl:value-of select="concat(normalize-space(common:lang-class(@xml:lang)), ' glossarize', ' foreign')"/>
            </xsl:attribute>
            <xsl:apply-templates select="node()"/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:emph">
        <em>
            <xsl:attribute name="class">
                <xsl:value-of select="concat(normalize-space(common:lang-class(@xml:lang)), ' glossarize')"/>
            </xsl:attribute>
            <xsl:apply-templates select="node()"/>
        </em>
    </xsl:template>
    
    <xsl:template match="tei:distinct">
        <em>
            <xsl:attribute name="class">
                <xsl:value-of select="concat(normalize-space(common:lang-class(@xml:lang)), ' glossarize')"/>
            </xsl:attribute>
            <xsl:apply-templates select="node()"/>
        </em>
    </xsl:template>
    
    <xsl:template match="tei:note">
        <a class="footnote-link pop-up">
            <xsl:attribute name="href" select="concat('#', @xml:id)"/>
            <xsl:attribute name="id" select="concat('link-to-', @xml:id)"/>
            <xsl:if test="ancestor::*[exists(@doc-type)][1]/@doc-type eq 'epub'">
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
    
    <!-- 
    <xsl:template match="tei:item">
        <xsl:apply-templates select="node()"/>
        <br/>
    </xsl:template> -->
    
    <xsl:template match="tei:gloss">
        <a class="glossary">
            <xsl:attribute name="href" select="concat('#glossary-', @uid)"/>
            <xsl:apply-templates select="text()"/>
        </a>
    </xsl:template>
    
    <xsl:template match="tei:ref">
        <xsl:choose>
            <xsl:when test="@cRef">
                <xsl:if test="(not(@rend) or @rend != 'hidden') and (not(@key) or @key eq /m:response/m:translation/m:source/@key)">
                    <xsl:choose>
                        <xsl:when test="@cRef and not(@type) and upper-case(substring-before(@cRef, '.')) eq 'F' and 'function' eq 'live'">
                            <a class="ref">
                                <xsl:attribute name="href" select="concat('/source/', /m:response/m:translation/@id, '.html?folio=', substring-after(@cRef, '.'))"/>
                                <xsl:attribute name="data-ajax-target" select="'#popup-footer-source .data-container'"/>
                                [<xsl:apply-templates select="@cRef"/>]</a>
                        </xsl:when>
                        <xsl:otherwise>
                            <span class="ref">[<xsl:apply-templates select="@cRef"/>]</span>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
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
                <xsl:apply-templates select="text()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>
    
    <xsl:template match="tei:ptr">
        <a class="internal-ref scroll-to-anchor">
            <xsl:attribute name="href" select="@target"/>
            <xsl:apply-templates select="text()"/>
        </a>
    </xsl:template>
    
    <xsl:template match="tei:q">
        <xsl:choose>
            <xsl:when test="parent::tei:p">
                <span class="blockquote">
                    <xsl:apply-templates select="node()"/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <blockquote>
                    <xsl:attribute name="class" select="'relative'"/>
                    <xsl:call-template name="milestone"/>
                    <xsl:apply-templates select="node()"/>
                </blockquote>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:p | tei:ab | tei:trailer | tei:bibl">
        <p>
            <!-- id -->
            <xsl:call-template name="tid"/>
            <!-- class -->
            <xsl:variable name="cssClass">
                glossarize 
                <xsl:if test="self::tei:ab[@type = 'mantra']">
                    mantra
                </xsl:if>
                <xsl:if test="self::tei:trailer">
                    trailer 
                </xsl:if>
            </xsl:variable>
            <xsl:attribute name="class" select="normalize-space($cssClass)"/>
            <xsl:call-template name="milestone"/>
            <xsl:apply-templates select="node()"/>
        </p>
    </xsl:template>
    
    <xsl:template match="tei:label">
        <h5 class="relative section-label">
            <xsl:call-template name="tid"/>
            <xsl:call-template name="milestone"/>
            <xsl:apply-templates select="node()"/>
        </h5>
    </xsl:template>
    
    <xsl:template match="tei:list[tei:item]">
        <div class="relative list">
            <xsl:call-template name="milestone"/>
            <xsl:apply-templates select="node()"/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:item[parent::tei:list]">
        <div class="relative list-item">
            <xsl:call-template name="milestone"/>
            <xsl:apply-templates select="node()"/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:head[parent::tei:list]">
        <h5 class="relative section-label">
            <xsl:call-template name="tid"/>
            <xsl:call-template name="milestone"/>
            <xsl:apply-templates select="node()"/>
        </h5>
    </xsl:template>
    
    <xsl:template match="tei:lg">
        <div class="relative line-group">
            <!-- id -->
            <xsl:call-template name="tid"/>
            <xsl:call-template name="milestone"/>
            <xsl:apply-templates select="node()"/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:l[parent::tei:lg]">
        <p class="glossarize">
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
    
    <!-- Temporary id -->
    <xsl:template name="tid">
        <xsl:if test="@tid">
            <xsl:attribute name="id" select="concat('node', '-', @tid)"/>
        </xsl:if>
    </xsl:template>
    
    <!-- Milestone -->
    <xsl:template name="milestone">
        <xsl:if test="preceding-sibling::*[1][self::tei:milestone] or (preceding-sibling::*[1][self::tei:lb] and preceding-sibling::*[2][self::tei:milestone])">
            <xsl:variable name="id" select="preceding-sibling::*[1]/@xml:id"/>
            <a class="milestone from-tei" title="Bookmark this section">
                <xsl:attribute name="href" select="concat('#', $id)"/>
                <xsl:attribute name="id" select="$id"/>
                <xsl:variable name="group" select="ancestor::*[exists(@prefix)][1]"/>
                <xsl:value-of select="concat($group/@prefix, '.', common:index-of-node($group//tei:milestone, preceding-sibling::tei:milestone[1]))"/>
            </a>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>
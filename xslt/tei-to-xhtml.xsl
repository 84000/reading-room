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
                <xsl:value-of select="concat(normalize-space(common:lang-class(@xml:lang)), ' glossarize', if(@rend eq 'bold') then ' text-bold' else '')"/>
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
        <a class="footnote-link">
            <xsl:attribute name="id" select="concat('link-to-', @xml:id)"/>
            <xsl:choose>
                <xsl:when test="/m:response/@doc-type eq 'epub'">
                    <xsl:attribute name="href" select="concat('notes.xhtml#', @xml:id)"/>
                    <xsl:attribute name="epub:type" select="'noteref'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="href" select="concat('#', @xml:id)"/>
                    <xsl:attribute name="class" select="'footnote-link pop-up'"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="@index"/>
        </a>
    </xsl:template>
    
    <xsl:template match="tei:date">
        <span class="date">
            <xsl:apply-templates select="text()"/>
        </span>
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
                <xsl:if test="(not(@rend) or @rend != 'hidden') and (not(@key) or @key eq /m:response/m:translation/m:source/@key)">
                    <xsl:choose>
                        <!-- Conditions for creating a link... -->
                        <xsl:when test="/m:response/@doc-type ne 'epub' and @cRef and not(@type) and upper-case(substring-before(@cRef, '.')) eq 'F'">
                            <a class="ref log-click">
                                <xsl:attribute name="href" select="concat('/source/', /m:response/m:translation/@id, '.html?folio=', substring-after(@cRef, '.'))"/>
                                <xsl:attribute name="data-ajax-target" select="'#popup-footer-source .data-container'"/>
                                [<xsl:apply-templates select="@cRef"/>]</a>
                        </xsl:when>
                        <!-- ...or just output the text. -->
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
                <span class="ref">
                    <xsl:apply-templates select="text()"/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>
    
    <xsl:template match="tei:ptr">
        <a class="internal-ref">
            
            <xsl:choose>
                <xsl:when test="/m:response/@doc-type eq 'epub'">
                    <xsl:attribute name="href">
                        <xsl:choose>
                            <xsl:when test="@location eq 'chapter'">
                                <xsl:value-of select="concat('chapter-', @chapter-index, '.xhtml', @target)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat(@location, '.xhtml', @target)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="href" select="@target"/>
                    <xsl:attribute name="class" select="'internal-ref scroll-to-anchor'"/>
                </xsl:otherwise>
            </xsl:choose>
            
            <xsl:if test="@location eq 'missing'">
                <xsl:attribute name="href" select="'#'"/>
                <xsl:attribute name="class" select="'internal-ref disabled'"/>
            </xsl:if>
            
            <xsl:apply-templates select="text()"/>
        </a>
    </xsl:template>
    
    <xsl:template match="tei:q">
        <xsl:call-template name="milestone">
            <xsl:with-param name="content">
                <blockquote>
                    <xsl:apply-templates select="node()"/>
                </blockquote>
            </xsl:with-param>
            <xsl:with-param name="row-classes" select="'space'"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="tei:p | tei:ab | tei:trailer | tei:bibl">
        <xsl:call-template name="milestone">
            <xsl:with-param name="content">
                <p>
                    <!-- id -->
                    <xsl:call-template name="tid"/>
                    <!-- class -->
                    <xsl:variable name="cssClass">
                        <xsl:if test="/m:response/@doc-type ne 'epub'">
                            glossarize
                        </xsl:if>
                        <xsl:if test="self::tei:ab[@type = 'mantra']">
                            mantra
                        </xsl:if>
                        <xsl:if test="self::tei:trailer">
                            trailer 
                        </xsl:if>
                    </xsl:variable>
                    <xsl:attribute name="class" select="normalize-space($cssClass)"/>
                    <xsl:apply-templates select="node()"/>
                </p>
            </xsl:with-param>
            <xsl:with-param name="row-classes" select="if (self::tei:trailer) then 'space' else if (self::tei:ab[@type = 'mantra']) then 'space space-after' else ''"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="tei:label">
        <xsl:call-template name="milestone">
            <xsl:with-param name="content">
                <h5 class="section-label">
                    <xsl:call-template name="tid"/>
                    <xsl:apply-templates select="node()"/>
                </h5>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="tei:list[tei:item]">
        <xsl:call-template name="milestone">
            <xsl:with-param name="content">
                <div class="list">
                    <xsl:if test="parent::tei:item">
                        <xsl:attribute name="class" select="'list list-sublist'"/>
                    </xsl:if>
                    <xsl:apply-templates select="node()"/>
                </div>
            </xsl:with-param>
            <xsl:with-param name="row-classes" select="if(not(parent::tei:item)) then 'space' else ''"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="tei:item[parent::tei:list]">
        <xsl:call-template name="milestone">
            <xsl:with-param name="content">
                <div class="list-item">
                    <xsl:variable name="css-classes">
                        list-item 
                        <xsl:if test="parent::tei:list/tei:item[1] = .">
                            list-item-first 
                        </xsl:if>
                        <xsl:if test="parent::tei:list/tei:item[count(parent::tei:list/tei:item)] = .">
                            list-item-last 
                        </xsl:if>
                    </xsl:variable>
                    <xsl:attribute name="class" select="normalize-space($css-classes)"/>
                    <xsl:apply-templates select="node()"/>
                </div>
            </xsl:with-param>
            <xsl:with-param name="row-classes" select="'space-after'"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="tei:head[parent::tei:list]">
        <xsl:call-template name="milestone">
            <xsl:with-param name="content">
                <h5 class="section-label">
                    <xsl:call-template name="tid"/>
                    <xsl:apply-templates select="node()"/>
                </h5>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="tei:lg">
        <xsl:call-template name="milestone">
            <xsl:with-param name="content">
                <div class="line-group">
                    <!-- id -->
                    <xsl:call-template name="tid"/>
                    <xsl:apply-templates select="node()"/>
                </div>
            </xsl:with-param>
            <xsl:with-param name="row-classes" select="if (not(parent::tei:q)) then 'space' else ''"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="tei:l[parent::tei:lg]">
        <xsl:call-template name="milestone">
            <xsl:with-param name="content">
                <div class="line">
                    <xsl:if test="/m:response/@doc-type ne 'epub'">
                        <xsl:attribute name="class" select="'line glossarize'"/>
                    </xsl:if>
                    <xsl:apply-templates select="node()"/>
                </div>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="tei:head">
        <xsl:choose>
            <xsl:when test="@type = ('chapter')">
                <xsl:call-template name="milestone">
                    <xsl:with-param name="content">
                        <div class="rw-heading">
                            <h4 class="chapter-number">
                                <xsl:value-of select="text()"/>
                            </h4>
                        </div>
                    </xsl:with-param>
                    <xsl:with-param name="row-classes" select="'space'"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="@type = ('chapterTitle')">
                <xsl:call-template name="milestone">
                    <xsl:with-param name="content">
                        <div class="rw-heading">
                            <h2>
                                <xsl:value-of select="text()"/>
                            </h2>
                        </div>
                    </xsl:with-param>
                    <xsl:with-param name="row-classes" select="'space'"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="@type = ('section')">
                <xsl:call-template name="milestone">
                    <xsl:with-param name="content">
                        <div class="rw-heading">
                            <h4>
                                <xsl:value-of select="text()"/>
                            </h4>
                        </div>
                    </xsl:with-param>
                    <xsl:with-param name="row-classes" select="'space'"/>
                </xsl:call-template>
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
        
        <xsl:param name="content"/>
        <xsl:param name="row-classes"/>
        
        <div class="rw">
            
            <!-- Concat classes for the row -->
            <xsl:attribute name="class" select="concat('rw', if((../*[1] = .) or (../*[1][self::tei:milestone] and ../*[2] = .)) then ' first-child' else '', if($row-classes gt '') then concat(' ', $row-classes) else '')"/>
            
            <xsl:variable name="milestone" select="preceding-sibling::*[1][self::tei:milestone] | preceding-sibling::*[2][self::tei:milestone[following-sibling::*[1][self::tei:lb]]]"/>
            
            <!-- Add a gutter is there's a milestone -->
            <xsl:if test="$milestone/@xml:id">
                <div class="gtr">
                    <xsl:choose>
                        <xsl:when test="/m:response/@doc-type ne 'epub'">
                            <a class="milestone from-tei" title="Bookmark this section">
                                <xsl:attribute name="href" select="concat('#', $milestone/@xml:id)"/>
                                <xsl:attribute name="id" select="$milestone/@xml:id"/>
                                <xsl:value-of select="$milestone/@label"/>
                            </a>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="id" select="$milestone/@xml:id"/>
                            <xsl:value-of select="$milestone/@label"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
            </xsl:if>
            
            <xsl:copy-of select="$content"/>
            
        </div>
    </xsl:template>
    
    <!-- Nested Sections -->
    <xsl:template match="m:nested-section">
        <div class="nested-section">
            <xsl:apply-templates select="tei:*"/>
            <xsl:apply-templates select="m:nested-section"/>
        </div>
    </xsl:template>
    
    <!-- Bibliography -->
    <xsl:template match="m:nested-section[ancestor::m:bibliography]">
        <div class="nested-section">
            <xsl:if test="m:title/text()">
                <h5 class="section-label">
                    <xsl:apply-templates select="m:title/text()"/>
                </h5>
            </xsl:if>
            <xsl:for-each select="m:item">
                <p>
                    <xsl:apply-templates select="node()"/>
                </p>
            </xsl:for-each>
            <xsl:apply-templates select="m:nested-section"/>
        </div>
    </xsl:template>
    
</xsl:stylesheet>
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:common="http://read.84000.co/common" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:m="http://read.84000.co/ns/1.0" xmlns:tmx="http://www.lisa.org/tmx14" version="2.0" exclude-result-prefixes="#all">
    
    <xsl:include href="reading-room-page.xsl"/>
    <xsl:include href="../../xslt/functions.xsl"/>
    
    <xsl:output method="html" indent="no" doctype-system="about:legacy-compat"/>
    
    <xsl:template match="/m:response">
        <xsl:variable name="content">
            <div class="container">
                <div class="panel panel-default" id="translation-memory">
                    
                    <div class="panel-heading panel-heading-bold hidden-print center-vertical">
                        <ul class="breadcrumb">
                            <li>
                                Create Translation Memory
                            </li>
                        </ul>
                    </div>
                    
                    <div class="panel-body min-height-md">
                        
                        <div class="row">
                            <div class="col-sm-9">
                                <form action="translation-memory.html" method="post" id="translation-memory-form" class="form-inline filter-form">
                                    
                                    <div class="form-group">
                                        <label for="translation-id" class="sr-only">Translation</label>
                                        <select name="translation-id" class="form-control" id="translation-id">
                                            <xsl:for-each select="m:translations/m:translation">
                                                <xsl:sort select="@id"/>
                                                <option>
                                                    <xsl:attribute name="value" select="@id"/>
                                                    <xsl:if test="@id eq /m:response/m:request/@translation-id">
                                                        <xsl:attribute name="selected" select="'selected'"/>
                                                    </xsl:if>
                                                    <xsl:value-of select="concat(@id, ' / ', data(m:toh))"/>
                                                </option>
                                            </xsl:for-each>
                                        </select>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label for="folio" class="sr-only">Folio</label>
                                        <select name="folio" class="form-control" id="folio">
                                            <xsl:for-each select="m:folios/m:folio">
                                                <xsl:sort select="xs:integer(@page)"/>
                                                <xsl:sort select="@side"/>
                                                <option>
                                                    <xsl:attribute name="value" select="@id"/>
                                                    <xsl:if test="@id eq /m:response/m:request/@folio">
                                                        <xsl:attribute name="selected" select="'selected'"/>
                                                    </xsl:if>
                                                    <xsl:value-of select="@id"/>
                                                </option>
                                            </xsl:for-each>
                                        </select>
                                    </div>
                                    
                                    <div class="form-group text text-muted italic">
                                        <xsl:value-of select="concat('eKangyur volume ', m:source/@volume, ', page ', m:source/@page, '.')"/>
                                    </div>
                                </form>
                            </div>
                            <div class="col-sm-3">
                                <a href="/tmx.zip" class="btn btn-success pull-right">Download .tmx files</a>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-8">
                                
                                <div class="text-overlay glossarize-section">
                                    <div class="text divided">
                                        <xsl:call-template name="text-marked">
                                            <xsl:with-param name="data" select="m:folio-content"/>
                                        </xsl:call-template>
                                    </div>
                                    <div class="text plain glossarize" data-mouseup-set-input="#remember-translation-form [name='translation']" data-mouseup-clear-input="#remember-translation-form [name='tuid']">
                                        <xsl:call-template name="text-plain">
                                            <xsl:with-param name="data" select="m:folio-content"/>
                                        </xsl:call-template>
                                    </div>
                                </div>
                                
                                <hr/>
                                
                                <div class="text-overlay">
                                    <div class="text divided text-bo">
                                        <xsl:call-template name="text-marked">
                                            <xsl:with-param name="data" select="m:source/m:language[@xml:lang eq 'bo']"/>
                                        </xsl:call-template>
                                    </div>
                                    <div class="text plain text-bo" data-mouseup-set-input="#remember-translation-form [name='source']" data-mouseup-clear-input="#remember-translation-form [name='tuid']">
                                        <xsl:call-template name="text-plain">
                                            <xsl:with-param name="data" select="m:source/m:language[@xml:lang eq 'bo']//tei:p"/>
                                        </xsl:call-template>
                                    </div>
                                </div>
                                
                            </div>
                            <div class="col-sm-4">
                                <form action="translation-memory.html" method="post" id="remember-translation-form">
                                    
                                    <input type="hidden" name="action" value="remember-translation"/>
                                    
                                    <input type="hidden" name="translation-id">
                                        <xsl:attribute name="value" select="m:request/@translation-id"/>
                                    </input>
                                    
                                    <input type="hidden" name="volume">
                                        <xsl:attribute name="value" select="m:folio-content/@volume"/>
                                    </input>
                                    
                                    <input type="hidden" name="folio">
                                        <xsl:attribute name="value" select="m:request/@folio"/>
                                    </input>
                                    
                                    <input type="hidden" name="tuid"/>
                                    
                                    <div class="form-group">
                                        <label for="translation" class="sr-only">Translation</label>
                                        <textarea name="translation" class="form-control" rows="6" required="required"/>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label for="source" class="sr-only">Source</label>
                                        <textarea name="source" class="form-control" rows="6" required="required"/>
                                    </div>
                                    
                                    <div class="form-group">
                                        <button type="button" class="btn btn-danger pull-left" data-mouseup-clear-input="#remember-translation-form [name='translation']" data-mouseup-submit="#remember-translation-form">Delete</button>
                                    </div>
                                    
                                    <div class="form-group">
                                        <button type="submit" class="btn btn-primary pull-right">Add to memory</button>
                                    </div>
                                    
                                </form>
                                
                                <div id="glossary">
                                    <xsl:for-each select="m:translation-memory/tmx:tu">
                                        <div class="glossary-item">
                                            <xsl:attribute name="id" select="concat('glossary-', @id)"/>
                                            <xsl:attribute name="data-tuid" select="@id"/>
                                            <p class="term translated">
                                                <a href="#glossary-2" class="glossary-link">
                                                    <xsl:attribute name="href" select="concat('#glossary-', @id)"/>
                                                    <xsl:value-of select="tmx:tuv[@xml:lang eq 'en']/tmx:seg/text()"/>
                                                </a>
                                            </p>
                                            <p class="source text-bo">
                                                <xsl:value-of select="tmx:tuv[@xml:lang eq 'bo']/tmx:seg/text()"/>
                                            </p>
                                        </div>
                                    </xsl:for-each>
                                </div>
                                
                            </div>
                        </div>
                        
                    </div>
                        
                </div>
            </div>
        </xsl:variable>
        
        <xsl:call-template name="reading-room-page">
            <xsl:with-param name="app-id" select="@app-id"/>
            <xsl:with-param name="page-url" select="''"/>
            <xsl:with-param name="page-type" select="'reading-room utilities tests'"/>
            <xsl:with-param name="page-title" select="'Reading Room Tests'"/>
            <xsl:with-param name="page-description" select="'Automated tests of the 84000 Reading Room app.'"/>
            <xsl:with-param name="content" select="$content"/>
        </xsl:call-template>
        
    </xsl:template>
    
    <xsl:template name="text-marked">
        <xsl:param name="data"/>
        <xsl:for-each select="$data/node()">
            <xsl:choose>
                
                <!-- Segment folios by ref -->
                <xsl:when test="self::text()[parent::m:folio-content][normalize-space(.)]">
                    <span class="section">
                        <xsl:if test="preceding-sibling::tei:ref[1][@cRef eq //m:folio-content/@start-ref]">
                            <xsl:attribute name="class" select="'selected'"/>
                        </xsl:if>
                        <xsl:call-template name="normalize">
                            <xsl:with-param name="text" select="concat(., ' ')"/>
                        </xsl:call-template>
                    </span>
                </xsl:when>
                
                <!-- Segment source by p -->
                <xsl:when test="self::tei:p[parent::m:language]">
                    <span class="section">
                        <xsl:if test="@class eq 'selected'">
                            <xsl:attribute name="class" select="'selected'"/>
                        </xsl:if>
                        <xsl:for-each select="text()[normalize-space(.)]">
                            <span>
                                <xsl:attribute name="data-line" select="preceding-sibling::tei:milestone[@unit eq 'line'][1]/@n"/>
                                <xsl:call-template name="normalize">
                                    <xsl:with-param name="text" select="concat(., ' ')"/>
                                </xsl:call-template>
                            </span>
                        </xsl:for-each>
                    </span>
                </xsl:when>
                
                <!-- ignore -->
                <xsl:otherwise>
                    
                </xsl:otherwise>
                
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="text-plain">
        <xsl:param name="data"/>
        <xsl:for-each select="$data/node()">
            <xsl:choose>
                
                <!-- Output text nodes only -->
                <xsl:when test="self::text()[normalize-space(.)]">
                    <xsl:call-template name="normalize">
                        <xsl:with-param name="text" select="concat(., ' ')"/>
                    </xsl:call-template>
                </xsl:when>
                
                <!-- ignore -->
                <xsl:otherwise>
                    
                </xsl:otherwise>
                
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="normalize">
        <xsl:param name="text" as="xs:string"/>
        <xsl:value-of select="translate(normalize-space(concat('', translate($text, '&#xA;', ''), '')), '', '')"/>
    </xsl:template>
    
</xsl:stylesheet>
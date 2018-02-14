<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:m="http://read.84000.co/ns/1.0" version="2.0" exclude-result-prefixes="#all">
    
    <xsl:include href="website-page.xsl"/>
    
    <xsl:output method="html" indent="no" doctype-system="about:legacy-compat"/>
    
    <xsl:template match="/m:response">
        <xsl:variable name="content">
            
            <div class="panel-heading panel-heading-bold hidden-print center-vertical">
                
                <span class="title">
                    84000 Translator Tools
                </span>
                
                <span class="text-right">
                    <a href="/" target="_self">Reading Room</a>
                </span>
                
            </div>
            
            <div class="panel-body">
                
                <ul class="nav nav-tabs" role="tablist">
                    <li role="presentation">
                        <xsl:if test="m:search">
                            <xsl:attribute name="class" select="'active'"/>
                        </xsl:if>
                        <a href="?tab=search">Search</a>
                    </li>
                    <li role="presentation">
                        <xsl:if test="m:glossary">
                            <xsl:attribute name="class" select="'active'"/>
                        </xsl:if>
                        <a href="?tab=glossary">Glossary</a>
                    </li>
                </ul>
                
                <div class="tab-content">
                    
                    <!-- Cumulative Glossary -->
                    <xsl:if test="m:glossary">
                        <div id="cumulative-glossary" class="row">
                            <div class="col-items">
                                    
                                <xsl:for-each select="m:glossary/m:term">
                                    <div class="glossary-term">
                                        
                                        <xsl:variable name="start-letter" select="@start-letter"/>
                                        
                                        <xsl:if test="not(preceding-sibling::*[@start-letter = $start-letter])">
                                            <a class="milestone">
                                                <xsl:attribute name="name" select="$start-letter"/>
                                                <xsl:attribute name="id" select="concat('group-', $start-letter)"/>
                                                <xsl:value-of select="$start-letter"/>
                                            </a>
                                        </xsl:if>
                                        
                                        <div class="row">
                                            <div class="col-sm-6">
                                                <p>
                                                    <xsl:value-of select="normalize-space(m:main-term/text())"/>
                                                </p>
                                            </div>
                                            <div class="col-sm-6 text-right">
                                                <a target="_self">
                                                    <xsl:attribute name="href" select="concat('glossary/items.html?term=', fn:encode-for-uri(m:main-term/text()))"/>
                                                    <xsl:attribute name="data-ajax-target" select="concat('#occurrences-', position())"/>
                                                    <xsl:choose>
                                                        <xsl:when test="@count-items &gt; 1">
                                                            <xsl:value-of select="@count-items"/> matches
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="@count-items"/> match
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                    
                                                </a>
                                            </div>
                                        </div>
                                        
                                        <div class="collpase">
                                            <xsl:attribute name="id" select="concat('occurrences-', position())"/>
                                        </div>
                                    
                                    </div>                                    
                                </xsl:for-each>
                            </div>
                            
                            <div id="milestone-list" class="col-nav">
                                <div data-spy="affix" data-offset-top="300">
                                    <div class="btn-group-vertical  btn-group-xs" role="group" aria-label="navigation">
                                        <xsl:for-each select="m:glossary/m:term">
                                            <xsl:variable name="start-letter" select="@start-letter"/>
                                            <xsl:if test="not(preceding-sibling::*[@start-letter = $start-letter])">
                                                
                                                <a class="btn btn-default scroll-to-anchor">
                                                    <xsl:attribute name="href" select="concat('#group-', $start-letter)"/>
                                                    <xsl:value-of select="$start-letter"/>
                                                </a>
                                                
                                            </xsl:if>
                                        </xsl:for-each>
                                    </div>
                                </div>
                                
                            </div>
                            
                            <form action="translator-tools.html" method="get" class="filter-form">
                                <input type="hidden" name="tab" value="glossary"/>
                                <select name="type" class="form-control">
                                    <option value="term">
                                        <xsl:if test="m:glossary/@type eq 'term'">
                                            <xsl:attribute name="selected" select="'selected'"/>
                                        </xsl:if>
                                        Terms
                                    </option>
                                    <option value="person">
                                        <xsl:if test="m:glossary/@type eq 'person'">
                                            <xsl:attribute name="selected" select="'selected'"/>
                                        </xsl:if>
                                        Persons
                                    </option>
                                    <option value="place">
                                        <xsl:if test="m:glossary/@type eq 'place'">
                                            <xsl:attribute name="selected" select="'selected'"/>
                                        </xsl:if>
                                        Places
                                    </option>
                                    <option value="text">
                                        <xsl:if test="m:glossary/@type eq 'text'">
                                            <xsl:attribute name="selected" select="'selected'"/>
                                        </xsl:if>
                                        Texts
                                    </option>
                                </select>
                            </form>
                            
                        </div>
                        
                    </xsl:if>
                    
                    <!-- Search results -->
                    <xsl:if test="m:search">
                        
                        <div id="search-form-container" class="row">
                            <div class="col-sm-8">
                                <br/>
                                <form action="translator-tools.html" method="post" class="form-horizontal">
                                    <input type="hidden" name="tab" value="search"/>
                                    <div class="input-group">
                                        <input type="text" name="search" id="search" class="form-control" placeholder="Search">
                                            <xsl:attribute name="value" select="m:search/m:request/text()"/>
                                        </input>
                                        <span class="input-group-btn">
                                            <button type="submit" class="btn btn-primary">
                                                Search
                                            </button>
                                        </span>
                                    </div>
                                </form>
                                <br/>
                                <xsl:choose>
                                    <xsl:when test="m:search/m:results/m:item">
                                        
                                        <xsl:for-each select="m:search/m:results/m:item">
                                            <div class="search-result">
                                                <p class="title">
                                                    <a>
                                                        <xsl:attribute name="href" select="m:source/@url"/>
                                                        <xsl:value-of select="m:source/text()"/>
                                                    </a>
                                                     
                                                    <xsl:choose>
                                                        <xsl:when test="m:source[@type eq 'title']">
                                                            <span class="label label-default">Title</span>
                                                        </xsl:when>
                                                        <xsl:when test="m:source[@type eq 'author']">
                                                            <span class="label label-default">Author</span>
                                                        </xsl:when>
                                                        <xsl:when test="m:source[@type eq 'edition']">
                                                            <span class="label label-default">Edition</span>
                                                        </xsl:when>
                                                        <xsl:when test="m:source[@type eq 'expan']">
                                                            <span class="label label-default">Abbreviation</span>
                                                        </xsl:when>
                                                        <xsl:when test="m:source[@type eq 'bibl']">
                                                            <span class="label label-default">Bibliography</span>
                                                        </xsl:when>
                                                        <xsl:when test="m:source[@type eq 'gloss']">
                                                            <span class="label label-default">Glossary</span>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <span class="label label-default">Text</span>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </p>
                                                <p>
                                                    <xsl:copy-of select="m:text/node()"/>
                                                </p>
                                            </div>
                                        </xsl:for-each>
                                        
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <p>
                                            <strong>No search results</strong>
                                        </p>
                                    </xsl:otherwise>
                                </xsl:choose>
                                
                            </div>
                            <div class="col-sm-offset-1 col-sm-3">
                                <div class="well">
                                    <p class="small">
                                        This is rudimentary, proof-of-concept search functionality. Improvements coming soon!
                                    </p>
                                </div>
                            </div>
                        </div>
                    </xsl:if>
                    
                </div>
            </div>
            
        </xsl:variable>
        
        <xsl:call-template name="website-page">
            <xsl:with-param name="app-id" select="@app-id"/>
            <xsl:with-param name="page-url" select="''"/>
            <xsl:with-param name="page-type" select="'reading-room utilities'"/>
            <xsl:with-param name="page-title" select="'84000 Translator Tools'"/>
            <xsl:with-param name="page-description" select="'Online resources for 84000 translators.'"/>
            <xsl:with-param name="content" select="$content"/>
        </xsl:call-template>
        
    </xsl:template>
</xsl:stylesheet>
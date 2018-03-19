<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:m="http://read.84000.co/ns/1.0" version="2.0" exclude-result-prefixes="#all">
    
    <xsl:output method="html" indent="no" doctype-system="about:legacy-compat"/>
    
    <xsl:template name="glossary">
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
    </xsl:template>
    
</xsl:stylesheet>
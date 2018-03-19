<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:m="http://read.84000.co/ns/1.0" version="2.0" exclude-result-prefixes="#all">
    
    <xsl:include href="translator-tools-sections/search.xsl"/>
    <xsl:include href="translator-tools-sections/glossary.xsl"/>
    <xsl:include href="translator-tools-sections/translation-search.xsl"/>
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
                    <!-- 
                    <li role="presentation">
                        <xsl:if test="m:translation-search">
                            <xsl:attribute name="class" select="'active'"/>
                        </xsl:if>
                        <a href="?tab=translation-search">Translation Search</a>
                    </li> -->
                </ul>
                
                <div class="tab-content">
                    
                    <!-- Cumulative Glossary -->
                    <xsl:if test="m:glossary">
                        <xsl:call-template name="glossary"/>
                    </xsl:if>
                    
                    <!-- Search results -->
                    <xsl:if test="m:search">
                        <xsl:call-template name="search"/>
                    </xsl:if>
                    
                    <!-- Translation search -->
                    <xsl:if test="m:translation-search">
                        <xsl:call-template name="translation-search"/>
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
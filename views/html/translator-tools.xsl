<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:m="http://read.84000.co/ns/1.0" xmlns:xhtml="http://www.w3.org/1999/xhtml" version="3.0" exclude-result-prefixes="#all">
    
    <xsl:include href="translator-tools-sections/search.xsl"/>
    <xsl:include href="translator-tools-sections/glossary.xsl"/>
    <xsl:include href="website-page.xsl"/>
    
    <xsl:output method="html" indent="no" doctype-system="about:legacy-compat"/>
    
    <xsl:template match="/m:response">
        
        <xsl:variable name="additional-tabs" select="doc('../../../data/translator-tools/additional-tabs.xml')"/>
        
        <xsl:variable name="content">
            
            <xsl:variable name="requested-tab" select="/m:response/@tab"/>
            
            <div class="panel-heading panel-heading-bold hidden-print center-vertical">
                
                <span class="title">
                    84000 Translator Tools
                </span>
                
                <span class="text-right">
                    <a href="/" target="_self">Reading Room</a>
                </span>
                
            </div>
            
            <div class="panel-body">
                
                <!-- Tabs -->
                <ul class="nav nav-tabs" role="tablist">
                    
                    <!-- Search tab -->
                    <li role="presentation">
                        <xsl:if test="$requested-tab eq 'search'">
                            <xsl:attribute name="class" select="'active'"/>
                        </xsl:if>
                        <a href="?tab=search">Search</a>
                    </li>
                    
                    <!-- Glossary tab -->
                    <li role="presentation">
                        <xsl:if test="$requested-tab eq 'glossary'">
                            <xsl:attribute name="class" select="'active'"/>
                        </xsl:if>
                        <a href="?tab=glossary">Glossary</a>
                    </li>
                    
                    <!-- Additional tabs -->
                    <xsl:for-each select="$additional-tabs//m:tab">
                        <li role="presentation">
                            <xsl:if test="$requested-tab eq @id">
                                <xsl:attribute name="class" select="'active'"/>
                            </xsl:if>
                            <a>
                                <xsl:attribute name="href" select="concat('?tab=', @id)"/>
                                <xsl:value-of select="text()"/>
                            </a>
                        </li>
                    </xsl:for-each>
                    
                </ul>
                
                <!-- Content -->
                <div class="tab-content">
                    
                    <xsl:choose>
                        
                        <!-- Search results -->
                        <xsl:when test="$requested-tab eq 'search'">
                            <xsl:call-template name="search"/>
                        </xsl:when>
                        
                        <!-- Cumulative Glossary -->
                        <xsl:when test="$requested-tab eq 'glossary'">
                            <xsl:call-template name="glossary"/>
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:copy-of select="article/*"/>
                        </xsl:otherwise>
                        
                    </xsl:choose>
                    
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
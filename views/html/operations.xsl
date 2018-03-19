<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:m="http://read.84000.co/ns/1.0" version="2.0" exclude-result-prefixes="#all">
    
    <xsl:include href="utilities-sections/progress.xsl"/>
    <xsl:include href="website-page.xsl"/>
    
    <xsl:output method="html" indent="no" doctype-system="about:legacy-compat"/>
    
    <xsl:template match="/m:response">
        <xsl:variable name="content">
            
            <div class="panel-heading panel-heading-bold hidden-print center-vertical">
                
                <span class="title">
                    84000 Database Utilities
                </span>
                
                <span class="text-right">
                    <a href="/translator-tools.html" target="_self">Translator Tools</a>
                </span>
            </div>
            
            <div class="panel-body">
                
                <ul class="nav nav-tabs" role="tablist">
                    <xsl:for-each select="m:tabs/m:tab">
                        <li role="presentation">
                            <xsl:if test="@active eq '1'">
                                <xsl:attribute name="class" select="'active'"/>
                            </xsl:if>
                            <a>
                                <xsl:attribute name="href" select="concat('?tab=', @id)"/>
                                <xsl:value-of select="text()"/>
                            </a>
                        </li>
                    </xsl:for-each>
                </ul>
                
                <div class="tab-content">
                    
                    <!-- Progress -->
                    <xsl:if test="m:tabs/m:tab[@id eq 'progress']/@active eq '1'">
                        <xsl:call-template name="progress"/>
                    </xsl:if>
                    
                    <!-- Sponsors -->
                    <xsl:if test="m:tabs/m:tab[@id eq 'sponsors']/@active eq '1'">
                        
                    </xsl:if>
                    
                </div>
            </div>
            
        </xsl:variable>
        
        <xsl:call-template name="website-page">
            <xsl:with-param name="app-id" select="@app-id"/>
            <xsl:with-param name="page-url" select="''"/>
            <xsl:with-param name="page-type" select="'reading-room utilities'"/>
            <xsl:with-param name="page-title" select="'84000 Operations'"/>
            <xsl:with-param name="page-description" select="'Online utilities for 84000 operations team.'"/>
            <xsl:with-param name="content" select="$content"/>
        </xsl:call-template>
        
    </xsl:template>
</xsl:stylesheet>
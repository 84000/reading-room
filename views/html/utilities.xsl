<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:m="http://read.84000.co/ns/1.0" version="2.0" exclude-result-prefixes="#all">
    
    <xsl:include href="utilities-sections/sections.xsl"/>
    <xsl:include href="utilities-sections/translations.xsl"/>
    <xsl:include href="utilities-sections/tests.xsl"/>
    <xsl:include href="utilities-sections/layout-checks.xsl"/>
    <xsl:include href="utilities-sections/requests.xsl"/>
    <xsl:include href="utilities-sections/client-errors.xsl"/>
    <xsl:include href="utilities-sections/snapshot.xsl"/>
    <xsl:include href="utilities-sections/deployment.xsl"/>
    <xsl:include href="website-page.xsl"/>
    
    <xsl:output method="html" indent="no" doctype-system="about:legacy-compat"/>
    
    <xsl:template match="/m:response">
        <xsl:variable name="content">
            
            <div class="container">
                <div class="panel panel-default">
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
                            
                            <!-- Outline -->
                            <xsl:if test="m:tabs/m:tab[@id eq 'sections']/@active eq '1'">
                                <xsl:call-template name="sections"/>
                            </xsl:if>
                            
                            <!-- Translations -->
                            <xsl:if test="m:tabs/m:tab[@id eq 'translations']/@active eq '1'">
                                <xsl:call-template name="translations"/>
                            </xsl:if>
                            
                            <!-- Tests -->
                            <xsl:if test="m:tabs/m:tab[@id eq 'tests']/@active eq '1'">
                                <xsl:call-template name="tests"/>
                            </xsl:if>
                            
                            <!-- Tests -->
                            <xsl:if test="m:tabs/m:tab[@id eq 'layout-checks']/@active eq '1'">
                                <xsl:call-template name="layout-checks"/>
                            </xsl:if>
                            
                            <!-- Logs -->
                            <xsl:if test="m:tabs/m:tab[@id eq 'requests']/@active eq '1'">
                                <xsl:call-template name="requests"/>
                            </xsl:if>
                            
                            <!-- Client errors -->
                            <xsl:if test="m:tabs/m:tab[@id eq 'client-errors']/@active eq '1'">
                                <xsl:call-template name="client-errors"/>
                            </xsl:if>
                            
                            <!-- Snapshot -->
                            <xsl:if test="m:tabs/m:tab[@id eq 'snapshot']/@active eq '1'">
                                <xsl:call-template name="snapshot"/>
                            </xsl:if>
                            
                            <!-- Deployment -->
                            <xsl:if test="m:tabs/m:tab[@id eq 'deployment']/@active eq '1'">
                                <xsl:call-template name="deployment"/>
                            </xsl:if>
                            
                        </div>
                    </div>
                </div>
            </div>
        </xsl:variable>
        
        <xsl:call-template name="website-page">
            <xsl:with-param name="app-id" select="@app-id"/>
            <xsl:with-param name="page-url" select="''"/>
            <xsl:with-param name="page-type" select="'reading-room utilities'"/>
            <xsl:with-param name="page-title" select="'Reading Room Utilities'"/>
            <xsl:with-param name="page-description" select="'Online utilities for 84000 editors and developers.'"/>
            <xsl:with-param name="content" select="$content"/>
            <xsl:with-param name="nav-tab" select="''"/>
        </xsl:call-template>
        
    </xsl:template>
</xsl:stylesheet>
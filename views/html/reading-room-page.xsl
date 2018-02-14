<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:m="http://read.84000.co/ns/1.0" version="2.0" exclude-result-prefixes="#all">
    
    <xsl:import href="common.xsl"/>
    
    <xsl:template name="reading-room-page">
        
        <xsl:param name="app-id"/>
        <xsl:param name="page-url"/>
        <xsl:param name="page-type"/>
        <xsl:param name="page-title"/>
        <xsl:param name="page-description"/>
        <xsl:param name="content"/>
        
        <!-- Look up environment variables -->
        <xsl:variable name="environment" select="doc('/db/env/environment.xml')/m:environments/m:environment[@id = $app-id]"/>
        
        <html>
            
            <!-- Get the common <head> -->
            <xsl:call-template name="html-head">
                <xsl:with-param name="app-id" select="$app-id"/>
                <xsl:with-param name="page-url" select="$page-url"/>
                <xsl:with-param name="page-title" select="$page-title"/>
                <xsl:with-param name="page-description" select="$page-description"/>
            </xsl:call-template>
            
            <body id="top">
                
                <xsl:attribute name="class" select="$page-type"/>
                
                <!-- Environment alert -->
                <xsl:if test="$environment/m:warning/text()">
                    <div class="environment-warning">
                        <xsl:value-of select="$environment/m:warning/text()"/> : <xsl:value-of select="@user-name"/>
                    </div>
                </xsl:if>
                
                <!-- Alert -->
                <div id="page-alert" class="collapse">
                    <div class="container"/>
                </div>
                
                <!-- Place content -->
                <xsl:copy-of select="$content"/>
                
                <!-- Get the common <footer> -->
                <xsl:call-template name="html-footer">
                    <xsl:with-param name="app-id" select="$app-id"/>
                </xsl:call-template>
                
            </body>
        </html>
        
    </xsl:template>
</xsl:stylesheet>
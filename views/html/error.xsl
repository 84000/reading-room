<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:util="http://exist-db.org/xquery/util" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:m="http://read.84000.co/ns/1.0" version="2.0" exclude-result-prefixes="#all">
    
    <xsl:include href="website-page.xsl"/>
    
    <xsl:output method="html"/>
    
    <xsl:param name="error-type"/>
    
    <xsl:template match="/">
        
        <xsl:variable name="app-id" select="if(exception/path[contains(text(),'/84000-reading-room-collab/')]) then '84000-reading-room-collab' else '84000-reading-room' "/>
        
        <!-- Look up environment variables -->
        <xsl:variable name="environment" select="doc('/db/env/environment.xml')/m:environments/m:environment[@id = $app-id]"/>
        
        <!-- PAGE CONTENT -->
        <xsl:variable name="content">
            <div class="container">
                <div class="panel panel-default">
                    <div class="panel-body text-center client-error">
                        
                        <h1>Sorry, there was an error.</h1>
                        
                        <p>
                            Please select a navigation option above.
                        </p>
                        
                        <xsl:if test="$environment/@debug eq '1'">
                            <h4>
                                <xsl:value-of select="exception/path"/>
                            </h4>
                            <p>
                                <xsl:value-of select="exception/message"/>
                            </p>
                        </xsl:if>
                        
                    </div>
                </div>
            </div>
        </xsl:variable>
        
        <!-- Compile with page template -->
        <xsl:call-template name="website-page">
            <xsl:with-param name="app-id" select="$app-id"/>
            <xsl:with-param name="page-url" select="''"/>
            <xsl:with-param name="page-type" select="'reading-room error'"/>
            <xsl:with-param name="page-title" select="'Error'"/>
            <xsl:with-param name="page-description" select="'Sorry, there was an error.'"/>
            <xsl:with-param name="content" select="$content"/>
            <xsl:with-param name="nav-tab" select="''"/>
        </xsl:call-template>
        
    </xsl:template>
    
</xsl:stylesheet>
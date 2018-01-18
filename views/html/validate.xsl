<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:m="http://read.84000.co/ns/1.0" version="2.0" exclude-result-prefixes="#all">
    
    <xsl:include href="reading-room-page.xsl"/>
    
    <xsl:output method="html" indent="no" doctype-system="about:legacy-compat"/>
    
    <xsl:template match="/m:response">
        <xsl:variable name="content">
            
            <div class="container">
                <div class="panel panel-default">
                    <div class="panel-heading panel-heading-bold hidden-print center-vertical">
                        
                        <ul class="breadcrumb">
                            <li>
                                <a href="/utilities.html?tab=tests">
                                    Utilities
                                </a>
                            </li>
                            <li>
                                Schema validation
                            </li>
                        </ul>
                        
                    </div>
                    
                    <div class="panel-body">
                        
                        <table class="table table-responsive">
                            <tbody>
                                <xsl:for-each select="//m:results/m:translation">
                                    <xsl:sort select="m:result/@status eq 'valid'"/>
                                    <tr class="heading">
                                        <td>
                                            <xsl:choose>
                                                <xsl:when test="m:result/@status eq 'valid'">
                                                    <i class="fa fa-check-circle"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <i class="fa fa-times-circle"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </td>
                                        <td>
                                            <a>
                                                <xsl:attribute name="href" select="concat('/translation/', @id, '.html')"/>
                                                <xsl:attribute name="target" select="@id"/>
                                                <xsl:value-of select="@id"/> 
                                            </a>
                                        </td>
                                        <td>
                                            <xsl:value-of select="m:title/text()"/>
                                        </td>
                                    </tr>
                                    <xsl:for-each select="m:result/m:error">
                                        <tr class="sub">
                                            <td colspan="3">
                                                <strong>Line <xsl:value-of select="@line"/>
                                                </strong> : <xsl:value-of select="text()"/>
                                            </td>
                                        </tr>
                                    </xsl:for-each>
                                </xsl:for-each>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            
            <div id="popup-footer" class="fixed-footer collapse hidden-print">
                
                <div class="container">
                    <div class="panel">
                        <div class="panel-body">
                            <div class="fix-height data-container">
                                
                            </div>
                        </div>
                    </div>
                </div>
                
                <div id="fixed-footer-close-container" class="fixed-btn-container">
                    <button type="button" class="btn-round close" aria-label="Close">
                        <span aria-hidden="true">
                            <i class="fa fa-times"/>
                        </span>
                    </button>
                </div>
                
            </div>
            
        </xsl:variable>
        
        <xsl:call-template name="reading-room-page">
            <xsl:with-param name="page-type" select="'reading-room utilities tests'"/>
            <xsl:with-param name="page-title" select="'Reading Room Tests'"/>
            <xsl:with-param name="app-id" select="@app-id"/>
            <xsl:with-param name="content" select="$content"/>
        </xsl:call-template>
        
    </xsl:template>
    
    
    
</xsl:stylesheet>
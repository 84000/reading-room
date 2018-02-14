<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:m="http://read.84000.co/ns/1.0" version="2.0" exclude-result-prefixes="#all">
    
    <xsl:import href="common.xsl"/>
    
    <xsl:template name="website-page">
        
        <xsl:param name="app-id"/>
        <xsl:param name="page-url"/>
        <xsl:param name="page-type"/>
        <xsl:param name="page-title"/>
        <xsl:param name="page-description"/>
        <xsl:param name="content"/>
        
        <!-- Look up environment variables -->
        <xsl:variable name="environment" select="doc('/db/env/environment.xml')/m:environments/m:environment[@id = $app-id]"/>
        <xsl:variable name="resource-path" select="$environment/m:resource-path/text()"/>
        
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
                
                <!-- Navigation -->
                <nav class="navbar navbar-default">
                    
                    <div class="brand-header">
                        <div class="container">
                            <div class="navbar-header">
                                <div class="navbar-brand center-vertical">
                                    
                                    <a href="http://84000.co" class="logo">
                                        <img>
                                            <xsl:attribute name="src" select="concat($resource-path, '/imgs/logo.png')"/>
                                        </img>
                                    </a>
                                    
                                    <span class="tag-line">
                                        Translating the words of the Buddha
                                    </span>
                                    
                                    <span class="nav-button">
                                        <button id="navigation-button" class="btn-round navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                                            <i class="fa fa-bars" aria-hidden="true"/>
                                        </button>
                                    </span>
                                    
                                </div>
                            </div>
                        </div>
                        
                    </div>
                    
                    <div class="container">
                        <div id="navbar" class="navbar-collapse collapse" aria-expanded="false">
                            
                            <ul class="nav navbar-nav">
                                <li class="home">
                                    <a href="http://84000.co">Home</a>
                                </li>
                                <li class="news">
                                    <a href="http://84000.co/news">News</a>
                                </li>
                                <li class="reading-room active">
                                    <a href="/section/lobby.html">Reading Room</a>
                                </li>
                                <li class="about">
                                    <a href="http://84000.co/about/vision">About</a>
                                </li>
                                <li class="resources">
                                    <a href="http://84000.co/resources/translator-training">Resources</a>
                                </li>
                                <li class="how-to-help">
                                    <a href="http://84000.co/how-you-can-help/donate/#sap">How you can help</a>
                                </li>
                            </ul>
                            
                            <form action="http://84000.co/" method="get" role="search" name="searchformTop" class="navbar-form navbar-right">
                                
                                <div id="search-controls" class="input-group">
                                    <input type="text" name="s" class="form-control" placeholder="Search..."/>
                                    <span class="input-group-btn">
                                        <button class="btn btn-primary" type="submit">
                                            <i class="fa fa-search"/>
                                        </button>
                                    </span>
                                </div>
                                
                                <div id="language-links">
                                    <a href="http://84000.co">English</a> | <a href="http://84000.co/ch">中文</a>
                                </div>
                                
                            </form>
                            
                            <div id="social" class="center-vertical">
                                <span>Follow our work:</span>
                                <a href="mailto:info@84000.co" target="_blank">
                                    <i class="fa fa-envelope-square" aria-hidden="true"/>
                                </a>
                                <a href="http://www.facebook.com/Translate84000" target="_blank">
                                    <i class="fa fa-facebook-square" aria-hidden="true"/>
                                </a>
                                <a href="https://twitter.com/Translate84000" target="_blank">
                                    <i class="fa fa-twitter-square" aria-hidden="true"/>
                                </a>
                                <a href="http://www.youtube.com/Translate84000" target="_blank">
                                    <i class="fa fa-youtube-square" aria-hidden="true"/>
                                </a>
                            </div>
                            
                        </div>
                    </div>
                    
                </nav>
                
                <!-- Content -->
                <div class="container">
                    <div class="panel panel-default">
                        <xsl:copy-of select="$content"/>
                    </div>
                </div>
                
                <!-- Link to top of page -->
                <div class="hidden-print">
                    <div id="link-to-top-container" class="fixed-btn-container">
                        <a href="#top" id="link-to-top" class="btn-round" title="Return to the top of the page">
                            <i class="fa fa-arrow-up" aria-hidden="true"/>
                        </a>
                    </div>
                </div>
                
                <!-- Get the common <footer> -->
                <xsl:call-template name="html-footer">
                    <xsl:with-param name="app-id" select="$app-id"/>
                </xsl:call-template>
                
            </body>
        </html>
        
    </xsl:template>
</xsl:stylesheet>
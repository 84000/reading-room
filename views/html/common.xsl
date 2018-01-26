<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:m="http://read.84000.co/ns/1.0" exclude-result-prefixes="#all" version="2.0">
    
    <!-- Set cache-clearing version number -->
    <xsl:variable name="version" select="'1.4'"/>
    
    <xsl:output method="html" indent="no" doctype-system="about:legacy-compat"/>
    
    <xsl:template name="html-head">
        
        <xsl:param name="app-id"/>
        <xsl:param name="page-title"/>
        
        <!-- Look up environment variables -->
        <xsl:variable name="environment" select="doc('/db/env/environment.xml')/m:environments/m:environment[@id = $app-id]"/>
        <xsl:variable name="resource-path" select="$environment/m:resource-path/text()"/>
        
        <head xmlns="http://www.w3.org/1999/xhtml">
            
            <meta charset="utf-8"/>
            <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
            <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1.0, user-scalable=0"/>
            <meta name="description" content="84000 is a non-profit global initiative to translate the words of the Buddha and make them available to everyone."/>
            
            <title>
                84000 Reading Room | <xsl:value-of select="$page-title"/>
            </title>
            
            <link rel="stylesheet" type="text/css">
                <xsl:attribute name="href" select="concat($resource-path, '/css/84000.css', '?v=', $version)"/>
            </link>
            <link rel="stylesheet" type="text/css">
                <xsl:attribute name="href" select="concat($resource-path, '/css/ie10-viewport-bug-workaround.css')"/>
            </link>
            <!--[if lt IE 9]>
                <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
                <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
            <![endif]-->
            <link rel="apple-touch-icon" sizes="180x180">
                <xsl:attribute name="href" select="concat($resource-path, '/favicon/apple-touch-icon.png')"/>
            </link>
            <link rel="icon" type="image/png" sizes="32x32">
                <xsl:attribute name="href" select="concat($resource-path, '/favicon/favicon-32x32.png')"/>
            </link>
            <link rel="icon" type="image/png" sizes="16x16">
                <xsl:attribute name="href" select="concat($resource-path, '/favicon/favicon-16x16.png')"/>
            </link>
            <link rel="manifest">
                <xsl:attribute name="href" select="concat($resource-path, '/favicon/manifest.json')"/>
            </link>
            <link rel="mask-icon" color="#ffffff">
                <xsl:attribute name="href" select="concat($resource-path, '/favicon/safari-pinned-tab.svg')"/>
            </link>
            <link rel="shortcut icon">
                <xsl:attribute name="href" select="concat($resource-path, '/favicon/favicon.ico')"/>
            </link>
            <meta name="msapplication-config">
                <xsl:attribute name="content" select="concat($resource-path, '/favicon/browserconfig.xml')"/>
            </meta>
            <meta name="theme-color" content="#ffffff"/>
            
            <script>
                <xsl:attribute name="src" select="concat($resource-path, '/js/jquery.min.js')"/>
            </script>
            <script>
                <xsl:attribute name="src" select="concat($resource-path, '/js/bootstrap.min.js')"/>
            </script>
            <script>
                <xsl:attribute name="src" select="concat($resource-path, '/js/js-cookies.js')"/>
            </script>
            <script>
                <xsl:attribute name="src" select="concat($resource-path, '/js/replace-text.min.js')"/>
            </script>
            <script>
                <xsl:attribute name="src" select="concat($resource-path, '/js/ie10-viewport-bug-workaround.js')"/>
            </script>
            <script defer="defer">
                <xsl:attribute name="src" select="concat($resource-path, '/js/84000.js', '?v=', $version)"/>
            </script>
            
        </head>
        
    </xsl:template>
    
    <xsl:template name="html-footer">
        
        <xsl:param name="app-id"/>
        
        <!-- Look up environment variables -->
        <xsl:variable name="environment" select="doc('/db/env/environment.xml')/m:environments/m:environment[@id = $app-id]"/>
        <xsl:variable name="resource-path" select="$environment/m:resource-path/text()"/>
        <xsl:variable name="ga-tracking-id" select="$environment/m:google-analytics/@tracking-id"/>
        
        <footer xmlns="http://www.w3.org/1999/xhtml" class="hidden-print">
            <div class="container">
                Copyright © 2011-2018 84000: Translating the Words of the Buddha - All Rights Reserved | <a href="mailto:info@84000.co">Contact Us</a>
            </div>
        </footer>
        
        <span xmlns="http://www.w3.org/1999/xhtml" id="media_test">
            <span class="visible-xs"/>
            <span class="visible-sm"/>
            <span class="visible-md"/>
            <span class="visible-lg"/>
            <span class="visible-print"/>
            <span class="visible-mobile"/>
            <span class="visible-desktop"/>
            <span class="event-hover"/>
        </span>
        
        <xsl:if test="$ga-tracking-id != ''">
            <script xmlns="http://www.w3.org/1999/xhtml">
                (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
                (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
                m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
                })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');
                ga('create', '<xsl:value-of select="$ga-tracking-id"/>', 'auto');
                ga('send', 'pageview');
            </script>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>
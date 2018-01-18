<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:util="http://exist-db.org/xquery/util" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:m="http://read.84000.co/ns/1.0" version="2.0" exclude-result-prefixes="#all">
    
    <xsl:include href="website-page.xsl"/>
    
    <xsl:output method="html" indent="no" doctype-system="about:legacy-compat"/>
    
    <xsl:template match="/m:response">
        
        <!-- PAGE CONTENT -->
        <xsl:variable name="content">
            
            <xsl:variable name="app-id" select="@app-id"/>
            <xsl:variable name="environment" select="doc('/db/env/environment.xml')/m:environments/m:environment[@id = $app-id]"/>
            <xsl:variable name="resource-path" select="$environment/m:resource-path/text()"/>
            
            <xsl:variable name="section-id" select="m:section/m:id"/>
            
            <div class="panel-heading panel-heading-bold center-vertical">
                
                <xsl:if test="$section-id eq 'lobby'">
                    <span class="title">
                        The Lobby
                    </span>
                </xsl:if>
                
                <xsl:if test="$section-id ne 'lobby'">
                    <span>
                        <ul class="breadcrumb">
                            <xsl:if test="$section-id ne 'lobby' and not(m:section//m:parent[@id eq 'lobby'])">
                                <li>
                                    <a href="/section/lobby.html">The Lobby</a>
                                </li>
                            </xsl:if>
                            <xsl:for-each select="m:section/m:parent | m:section/m:parent//m:parent">
                                <xsl:sort select="@nesting" order="descending"/>
                                <li>
                                    <a>
                                        <xsl:attribute name="href" select="concat('/section/', @id/string(), '.html')"/>
                                        <xsl:value-of select="m:title[@xml:lang='en']/text()"/>
                                    </a>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </span>
                </xsl:if>
                
                <span>
                    
                    <div class="pull-right center-vertical">
                        
                        <xsl:if test="not($section-id = 'all-translated')">
                            
                            <a href="/section/all-translated.html" class="center-vertical together">
                                <span>
                                    <span class="btn-round white-red sml">
                                        <i class="fa fa-list"/>
                                    </span>
                                </span>
                                <span class="btn-round-text">
                                    View Translated Texts
                                </span>
                            </a>
                            
                        </xsl:if>
                        
                        <span>
                                
                            <div aria-haspopup="true" aria-expanded="false">
                                <a href="#bookmarks-sidebar" id="bookmarks-btn" class="show-sidebar center-vertical together">
                                    <span>
                                        <span class="btn-round white-red sml">
                                            <i class="fa fa-bookmark"/>
                                            <span class="badge badge-notification">0</span>
                                        </span>
                                    </span>
                                    <span class="btn-round-text">
                                        Bookmarks
                                    </span>
                                </a>
                            </div>
                            
                        </span>
                        
                    </div>
                    
                </span>
                
            </div>
            
            <div class="panel-body">
                
                <div id="title">
                    <div class="row">
                        <div class="col-sm-offset-2 col-sm-8">
                            
                            <!-- Page title -->
                            
                            <xsl:choose>
                                <xsl:when test="$section-id = 'lobby'">
                                    <div>
                                        <img class="logo">
                                            <xsl:attribute name="src" select="concat($resource-path,'/imgs/logo.png')"/>
                                        </img>
                                    </div>
                                    <h1>
                                        Welcome to the Reading Room
                                    </h1>
                                </xsl:when>
                                <xsl:otherwise>
                                    <h1>
                                        <xsl:value-of select="m:section/m:titles/m:title[@xml:lang = 'en']"/>
                                    </h1>
                                </xsl:otherwise>
                            </xsl:choose>
                            
                            <xsl:if test="m:section/m:titles/m:title[@xml:lang = 'bo']/text() or m:section/m:titles/m:title[@xml:lang = 'bo-ltn']/text()">
                                <hr/>
                                <h4>
                                    <span class="text-bo">
                                        <xsl:value-of select="m:section/m:titles/m:title[@xml:lang = 'bo']/text()"/>
                                    </span>
                                    <xsl:if test="m:section/m:titles/m:title[@xml:lang = 'bo-ltn']/text()">
                                        · 
                                        <span class="text-wy">
                                            <xsl:value-of select="m:section/m:titles/m:title[@xml:lang = 'bo-ltn']/text()"/>
                                        </span>
                                    </xsl:if>
                                </h4>
                            </xsl:if>
                            
                            <xsl:if test="m:section/m:titles/m:title[@xml:lang = 'sa-ltn']/text()">
                                <hr/>
                                <h4 class="text-sa">
                                    <xsl:value-of select="m:section/m:titles/m:title[@xml:lang = 'sa-ltn']/text()"/>
                                </h4>
                            </xsl:if>
                            
                            <hr/>
                            
                            <!-- Contents -->
                            <p>
                                <xsl:copy-of select="m:section/m:contents/node()"/>
                            </p>
                            
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-12 col-md-offset-2 col-md-8">
                            
                            <!-- stats -->
                            <xsl:if test="not($section-id = ('lobby', 'all-translated'))">
                                <table class="table table-stats">
                                    <tbody>
                                        <tr>
                                            <td>
                                                Texts: <xsl:value-of select="format-number(m:section/m:texts/@count-descendant-texts/number(), '#,###')"/>
                                            </td>
                                            <td>
                                                Translated: <xsl:value-of select="format-number(m:section/m:texts/@count-descendant-translated/number(), '#,###')"/>
                                            </td>
                                            <td>
                                                In Progress: <xsl:value-of select="format-number(m:section/m:texts/@count-descendant-inprogress/number(), '#,###')"/>
                                            </td>
                                            <td>
                                                Not Begun: <xsl:value-of select="format-number(m:section/m:texts/@count-descendant-texts/number() - (m:section/m:texts/@count-descendant-translated/number() + m:section/m:texts/@count-descendant-inprogress/number()), '#,###')"/>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </xsl:if>
                            <xsl:if test="$section-id = 'all-translated'">
                                <table class="table table-stats">
                                    <tbody>
                                        <tr>
                                            <td>
                                                Translated: <xsl:value-of select="format-number(count(m:section/m:texts/m:text), '#,###')"/>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </xsl:if>
                        </div>
                    </div>
                    
                </div>
                
                <!-- Content tabs (sections/texts/summary) -->
                <xsl:if test="(m:section/m:sections/m:section and (m:section/m:texts/m:text or m:section/m:summary/text())) or (m:section/m:texts/m:text and (m:section/m:sections/m:section or m:section/m:summary/text()))">
                    <div class="tabs-container-center">
                        <ul class="nav nav-tabs" role="tablist">
                            
                            <xsl:if test="m:section/m:texts/m:text or m:section/m:texts/@translated-only eq '1'">
                                <li role="presentation" class="active">
                                    <a href="#texts" aria-controls="texts" role="tab" data-toggle="tab">Texts</a>
                                </li>
                            </xsl:if>
                            
                            <xsl:if test="m:section/m:sections/m:section">
                                <li role="presentation">
                                    <xsl:attribute name="class">
                                        <xsl:if test="not(m:section/m:texts/m:text or m:section/m:texts/@translated-only eq '1')">active</xsl:if>
                                    </xsl:attribute>
                                    <a href="#sections" aria-controls="sections" role="tab" data-toggle="tab">Sections</a>
                                </li>
                            </xsl:if>
                            
                            <xsl:if test="m:section/m:summary/text()">
                                <li role="presentation">
                                    <a href="#summary" aria-controls="summary" role="tab" data-toggle="tab">About</a>
                                </li>
                            </xsl:if>
                            
                        </ul>
                        
                    </div>
                </xsl:if>

                <!-- Tab content -->
                <div class="tab-content">
                    
                    <!-- Texts -->
                    <div role="tabpanel" id="texts">
                        
                        <xsl:attribute name="class">
                            <xsl:choose>
                                <xsl:when test="m:section/m:texts/m:text or m:section/m:texts/@translated-only eq '1'">
                                    tab-pane fade in active
                                </xsl:when>
                                <xsl:otherwise>
                                    hidden
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        
                        
                        <div class="text-list">
                            
                            <div class="row table-headers">
                                
                                <div class="col-sm-1 hidden-xs">
                                    Toh
                                </div>
                                <div class="col-sm-7 col-md-8">
                                    Title
                                </div>
                                <div class="col-xs-12 col-sm-4 col-md-3">
                                    
                                    <!-- Filter translated -->
                                    <form action="" method="post" class="filter-form">
                                        
                                        <xsl:if test="$section-id = 'all-translated'">
                                            <xsl:attribute name="class" select="'filter-form hidden-xs'"/>
                                        </xsl:if>
                                        
                                        <div class="checkbox">
                                            <label>
                                                <input type="checkbox" name="translated-only" value="1">
                                                    <xsl:if test="m:section/m:texts[@translated-only = '1']">
                                                        <xsl:attribute name="checked" select="'checked'"/>
                                                    </xsl:if>
                                                </input>
                                                Translated texts only
                                            </label>
                                        </div>
                                    </form>
                                
                                </div>
                                
                            </div>
                            
                            <xsl:for-each select="m:section/m:texts/m:text[not(m:chapters/m:text)] | m:section/m:texts/m:text/m:chapters/m:text">
                                <div class="row">
                                    
                                    <div class="col-sm-1">
                                        
                                        <span class="visible-xs-inline">
                                            Toh 
                                        </span>
                                        
                                        <xsl:choose>
                                            <xsl:when test="parent::m:chapters">
                                                <xsl:value-of select="../../m:toh"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="m:toh"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        
                                        <hr class="visible-xs-block"/>
                                        
                                    </div>
                                    
                                    <div class="col-sm-7 col-md-8">
                                        
                                        <xsl:if test="parent::m:chapters">
                                            <xsl:value-of select="../../m:titles/m:title[@xml:lang='en']/text()"/>
                                            <hr/>
                                        </xsl:if>
                                        
                                        <h4 class="title-en">
                                            <xsl:if test="parent::m:chapters">
                                                <i class="fa fa-angle-right"/> 
                                            </xsl:if>
                                            <xsl:choose>
                                                <xsl:when test="m:titles/m:title[@xml:lang='en']/text()">
                                                    <xsl:choose>
                                                        <xsl:when test="m:status = 'available'">
                                                            <a class="title">
                                                                <xsl:attribute name="href" select="concat('/translation/', @translation-id/string(), '.html')"/> 
                                                                <xsl:copy-of select="m:titles/m:title[@xml:lang='en']/text()"/> 
                                                            </a>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:copy-of select="m:titles/m:title[@xml:lang='en']/text()"/> 
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <em class="text-muted">
                                                        Awaiting English title
                                                    </em>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </h4>
                                        
                                        <xsl:if test="$section-id = 'all-translated'">
                                            <hr/>
                                            in
                                            <ul class="breadcrumb">
                                                <xsl:for-each select="m:parent | m:parent//m:parent">
                                                    <xsl:sort select="@nesting" order="descending"/>
                                                    <li>
                                                        <a>
                                                            <xsl:attribute name="href" select="concat('/section/', @id/string(), '.html')"/>
                                                            <xsl:value-of select="m:title[@xml:lang='en']/text()"/>
                                                        </a>
                                                    </li>
                                                </xsl:for-each>
                                            </ul>
                                        </xsl:if>
                                        
                                        <xsl:if test="m:titles/m:title[@xml:lang='bo']/text()">
                                            <hr/>
                                            <span class="text-bo">
                                                <xsl:value-of select="m:titles/m:title[@xml:lang='bo']/text()"/>
                                            </span>
                                        </xsl:if>
                                        
                                        <xsl:if test="m:titles/m:title[@xml:lang='bo-ltn']/text()">
                                            <xsl:choose>
                                                <xsl:when test="m:titles/m:title[@xml:lang='bo']/text()">
                                                    · 
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <hr/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            <span class="text-wy">
                                                <xsl:value-of select="m:titles/m:title[@xml:lang='bo-ltn']/text()"/>
                                            </span>
                                        </xsl:if>
                                        
                                        <xsl:if test="m:titles/m:title[@xml:lang='sa-ltn']/text()">
                                            <hr/>
                                            <span class="text-sa">
                                                <xsl:value-of select="m:titles/m:title[@xml:lang='sa-ltn']/text()"/> 
                                            </span>
                                            
                                        </xsl:if>
                                        
                                        <xsl:if test="m:summary/text() or m:title-variants/m:title/text()">
                                            
                                            <hr/>
                                            
                                            <a class="summary-link collapsed" role="button" data-toggle="collapse" aria-expanded="false" aria-controls="collapseExample">
                                                <xsl:attribute name="href" select="concat('#summary-detail-', position())"/>
                                                <i class="fa fa-chevron-down"/> Summary &amp; variant titles
                                            </a>
                                            
                                            <div class="collapse summary-detail">
                                                
                                                <xsl:attribute name="id" select="concat('summary-detail-', position())"/>
                                                
                                                <div class="well well-sm">
                                                    
                                                    <xsl:if test="m:summary/text()">
                                                        <h5>Summary</h5>
                                                        <p>
                                                            <xsl:value-of select="m:summary/text()"/>
                                                        </p>
                                                    </xsl:if>
                                                    
                                                    <xsl:if test="m:title-variants/m:title/text()">
                                                        <h5>Title variants</h5>
                                                        <ul class="list-unstyled">
                                                            <xsl:for-each select="m:title-variants/m:title">
                                                                <li>
                                                                    <xsl:value-of select="text()"/>
                                                                </li>
                                                            </xsl:for-each>
                                                        </ul>
                                                    </xsl:if>
                                                    
                                                </div>
                                            </div>
                                            
                                        </xsl:if>
                                        
                                        <hr class="visible-xs-block"/>
                                        
                                    </div>
                                    
                                    <div class="col-sm-4 col-md-3 position-static">
                                        
                                        <xsl:if test="not(m:chapters/m:text)">
                                            
                                            <div class="translation-status">
                                                <xsl:choose>
                                                    <xsl:when test="m:status = 'not-started'">
                                                        <div class="label label-default">
                                                            Not Started
                                                        </div>
                                                    </xsl:when>
                                                    <xsl:when test="m:status = 'in-progress'">
                                                        <div class="label label-warning">
                                                            In progress
                                                        </div>
                                                    </xsl:when>
                                                    <xsl:when test="m:status = 'missing'">
                                                        <div class="label label-danger">
                                                            Missing
                                                        </div>
                                                    </xsl:when>
                                                    <xsl:when test="m:status = 'available' and $section-id ne 'all-translated'">
                                                        <div class="label label-success visible-xs-inline">
                                                            Translated
                                                        </div>
                                                    </xsl:when>
                                                </xsl:choose>
                                            </div>
                                            
                                            <xsl:if test="m:status = 'available'">
                                                <ul class="translation-options">
                                                    <li>
                                                        <a>
                                                            <xsl:attribute name="href" select="concat('/translation/', @translation-id/string(), '.html')"/>
                                                            <i class="fa fa-laptop"/>
                                                            Read online
                                                        </a>
                                                    </li>
                                                    <!-- 
                                                    <li>
                                                        <a class="print-href">
                                                            <xsl:attribute name="href" select="concat('/translation/', @translation-id/string(), '.html')"/>
                                                            <i class="fa fa-print"/>
                                                            Print
                                                        </a>
                                                    </li>
                                                    -->
                                                    <li>
                                                        <a href="#" title="Download PDF" class="disabled" target="_blank">
                                                            <xsl:if test="m:downloads/m:download[@type = 'pdf']">
                                                                <xsl:attribute name="href" select="m:downloads/m:download[@type = 'pdf']/@url"/>
                                                                <xsl:attribute name="download" select="m:downloads/m:download[@type = 'pdf']/@filename"/>
                                                                <xsl:attribute name="class" select="'log-click'"/>
                                                            </xsl:if>
                                                            <i class="fa fa-file-pdf-o"/>
                                                            Download PDF
                                                        </a>
                                                    </li>
                                                    <li>
                                                        <a href="#" title="Download EPub" class="disabled" target="_blank">
                                                            <xsl:if test="m:downloads/m:download[@type = 'epub']">
                                                                <xsl:attribute name="href" select="m:downloads/m:download[@type = 'epub']/@url"/>
                                                                <xsl:attribute name="download" select="m:downloads/m:download[@type = 'epub']/@filename"/>
                                                                <xsl:attribute name="class" select="'log-click'"/>
                                                            </xsl:if>
                                                            <i class="fa fa-book"/>
                                                            Download EPUB
                                                        </a>
                                                    </li>
                                                </ul>
                                            </xsl:if>
                                            
                                        </xsl:if>
                                        
                                    </div>
                                </div>
                            </xsl:for-each>
                        </div>
                    </div>
                    
                    <!-- Sections -->
                    <div role="tabpanel" id="sections">
                        
                        <xsl:attribute name="class">
                            <xsl:choose>
                                <xsl:when test="m:section/m:texts/m:text or m:section/m:texts/@translated-only eq '1'">tab-pane fade</xsl:when>
                                <xsl:when test="m:section/m:sections/m:section">tab-pane fade in active</xsl:when>
                                <xsl:otherwise>hidden</xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        
                        <div id="sections" class="row">
                            
                            <!-- Sub-sections -->
                            <xsl:variable name="count-sections" select="count(m:section/m:sections/m:section)"/>
                            <xsl:for-each select="m:section/m:sections/m:section">
                                <div>
                                    
                                    <xsl:variable name="col-offset-2">
                                        <xsl:choose>
                                            <xsl:when test="($count-sections mod 2) eq 1 and (position() mod 2) eq 1 and position() &gt; ($count-sections - 2)">
                                                <!-- 1 left over in rows of 2 -->
                                                col-sm-6 col-sm-offset-3
                                            </xsl:when>
                                            <xsl:otherwise>
                                                col-sm-6 col-sm-offset-0
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    
                                    <xsl:variable name="col-offset-3">
                                        <xsl:choose>
                                            <xsl:when test="position() &gt; (floor($count-sections div 3) * 3)">
                                                <!-- In the last row of rows of 3 -->
                                                <xsl:choose>
                                                    <xsl:when test="($count-sections mod 3) eq 2">
                                                        <!-- 2 left over -->
                                                        <xsl:choose>
                                                            <xsl:when test="(position() mod 3) eq 1">
                                                                <!-- first in the row -->
                                                                col-md-4 col-md-offset-2
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                col-md-4 col-md-offset-0
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </xsl:when>
                                                    <xsl:when test="($count-sections mod 3) eq 1">
                                                        <!-- 1 left over -->
                                                        <xsl:choose>
                                                            <xsl:when test="(position() mod 3) eq 1">
                                                                <!-- first in the row -->
                                                                col-md-4 col-md-offset-4
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                col-md-4 col-md-offset-0
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <!-- 0 left over -->
                                                        col-md-4 col-md-offset-0
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <!-- Not in the last row -->
                                                col-md-4 col-md-offset-0
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    
                                    
                                    <xsl:variable name="col-offset-4">
                                        <xsl:choose>
                                            <xsl:when test="position() &gt; (floor($count-sections div 4) * 4)">
                                                <!-- In the last row of rows of 4 -->
                                                <xsl:choose>
                                                    <xsl:when test="($count-sections mod 4) eq 3">
                                                        <!-- 3 left over -->
                                                        col-lg-4 col-lg-offset-0
                                                    </xsl:when>
                                                    <xsl:when test="($count-sections mod 4) eq 2">
                                                        <!-- 2 left over -->
                                                        <xsl:choose>
                                                            <xsl:when test="(position() mod 4) eq 1">
                                                                <!-- first in the row -->
                                                                col-lg-4 col-lg-offset-2
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                col-lg-4 col-lg-offset-0
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </xsl:when>
                                                    <xsl:when test="($count-sections mod 4) eq 1">
                                                        <!-- 1 left over -->
                                                        <xsl:choose>
                                                            <xsl:when test="(position() mod 4) eq 1">
                                                                <!-- first in the row -->
                                                                col-lg-4 col-lg-offset-4
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                col-lg-4 col-lg-offset-0
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <!-- 0 left over -->
                                                        col-lg-3 col-lg-offset-0
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <!-- Not in the last row -->
                                                col-lg-3 col-lg-offset-0
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    
                                    <xsl:attribute name="class" select="normalize-space(concat($col-offset-2, ' ', $col-offset-3, ' ', $col-offset-4, ' '))"/>
                                    
                                    <div class="section-panel">
                                        
                                        <xsl:variable name="panel-class">
                                            <xsl:choose>
                                                <xsl:when test="@type eq 'pseudo-section'">
                                                    section-panel pseudo-section
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    section-panel
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:variable>
                                        
                                        <xsl:attribute name="class" select="normalize-space($panel-class)"/>
                                        
                                        <div data-match-height="outline-section">
                                            <a target="_self" class="block-link">
                                                <xsl:attribute name="href" select="concat('/section/', @id/string(), '.html')"/> 
                                                <h3 class="title">
                                                    <xsl:value-of select="m:titles/m:title[@xml:lang='en']/text()"/> 
                                                </h3>
                                                <xsl:if test="m:titles/m:title[@xml:lang='bo']/text()">
                                                    <p class="title text-bo">
                                                        <xsl:value-of select="m:titles/m:title[@xml:lang='bo']/text()"/>
                                                    </p>
                                                </xsl:if>
                                                <xsl:if test="m:titles/m:title[@xml:lang='bo-ltn']/text()">
                                                    <p class="title text-wy">
                                                        <xsl:value-of select="m:titles/m:title[@xml:lang='bo-ltn']/text()"/>
                                                    </p>
                                                </xsl:if>
                                                <xsl:if test="m:titles/m:title[@xml:lang='sa-ltn']/text()">
                                                    <p class="title text-sa">
                                                        <xsl:value-of select="m:titles/m:title[@xml:lang='sa-ltn']/text()"/>
                                                    </p>
                                                </xsl:if>
                                                <p class="notes">
                                                    <xsl:copy-of select="m:contents/node()"/>
                                                </p>
                                                <xsl:if test="@warning eq 'tantra'">
                                                    <p class="notes">
                                                        <a href="#tantra-warning" data-toggle="modal" data-target="#tantra-warning" class="warning">
                                                            <i class="fa fa-info-circle" aria-hidden="true"/>
                                                            Tantra Text Warning
                                                        </a>
                                                    </p>
                                                </xsl:if>
                                            </a>
                                        </div>
                                        
                                        <div class="footer">
                                            <table class="table">
                                                <tbody>
                                                    <tr>
                                                        <th>Texts</th>
                                                        <td>
                                                            <xsl:value-of select="format-number(m:texts/@count-descendant-texts/number(), '#,###')"/>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>Translated</th>
                                                        <td>
                                                            <xsl:value-of select="format-number(m:texts/@count-descendant-translated/number(), '#,###')"/>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>In Progress</th>
                                                        <td>
                                                            <xsl:value-of select="format-number(m:texts/@count-descendant-inprogress/number(), '#,###')"/>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>Not begun</th>
                                                        <td>
                                                            <xsl:value-of select="format-number(m:texts/@count-descendant-texts/number() - (m:texts/@count-descendant-translated/number() + m:texts/@count-descendant-inprogress/number()), '#,###')"/>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                        
                                    </div>
                                </div>
                            </xsl:for-each>
                        </div>
                        
                        <div class="row">
                            <div class="col-sm-offset-2 col-sm-8 text-center">
                                
                                <a href="/section/all-translated.html" class="text-danger">
                                    <span class="btn-round red sml">
                                        <i class="fa fa-list"/>
                                    </span>
                                    View Translated Texts
                                </a>
                                
                                <hr/>
                                
                                <a href="http://84000.co/how-you-can-help/donate/#sap" class="btn btn-primary btn-uppercase">
                                    Sponsor translation
                                </a>
                                
                            </div>
                        </div>
                    </div>
                    
                    <!-- Summary -->
                    <div role="tabpanel" id="summary">
                        <xsl:attribute name="class">
                            <xsl:choose>
                                <xsl:when test="m:section/m:summary">tab-pane fade</xsl:when>
                                <xsl:otherwise>hidden</xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <div class="row">
                            <div class="col-sm-offset-2 col-sm-8 text-left">
                                <xsl:copy-of select="m:section/m:summary/node()"/>
                            </div>
                        </div>
                        
                    </div>
                    
                </div>
                
                <div class="modal fade" id="tantra-warning" tabindex="-1" role="dialog" aria-labelledby="tantra-warning-label">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">
                                        <i class="fa fa-times"/>
                                    </span>
                                </button>
                                <h4 class="modal-title" id="tantra-warning-label">Tantra Text Warning</h4>
                            </div>
                            <div class="modal-body">
                                <p>Readers are reminded that according to Vajrayāna Buddhist tradition there are restrictions and commitments concerning tantra.</p>
                                <p>Practitioners who are not sure if they should read translations in this section are advised to consult the authorities of their lineage.</p>
                                <p>The responsibility for reading these texts or sharing them with others—and hence the consequences—lies in the hands of readers.</p>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div id="bookmarks-sidebar" class="fixed-sidebar collapse width hidden-print">
                    
                    <div class="container">
                        <div class="fix-width">
                            <h4>Bookmarks</h4>
                            <table id="bookmarks-list" class="contents-table">
                                <tbody/>
                                <tfoot/>
                            </table>
                        </div>
                    </div>
                    
                    <div class="fixed-btn-container close-btn-container right">
                        <button type="button" class="btn-round close" aria-label="Close">
                            <span aria-hidden="true">
                                <i class="fa fa-times"/>
                            </span>
                        </button>
                    </div>
                    
                </div>
                
            </div>
        </xsl:variable>
        
        <!-- Compile with page template -->
        <xsl:call-template name="website-page">
            <xsl:with-param name="page-type" select="'reading-room section'"/>
            <xsl:with-param name="page-title" select="m:section/m:titles/m:title[@xml:lang = 'en']"/>
            <xsl:with-param name="app-id" select="@app-id"/>
            <xsl:with-param name="content" select="$content"/>
        </xsl:call-template>
        
    </xsl:template>
</xsl:stylesheet>
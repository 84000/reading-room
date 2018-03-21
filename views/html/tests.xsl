<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:m="http://read.84000.co/ns/1.0" version="2.0" exclude-result-prefixes="#all">
    
    <xsl:include href="reading-room-page.xsl"/>
    
    <xsl:output method="html" indent="no" doctype-system="about:legacy-compat"/>
    
    <xsl:function name="m:test-result" as="item()*">
        
        <xsl:param name="success" as="xs:boolean"/>
        <xsl:param name="cell-id" as="xs:string"/>
        <xsl:param name="text-id" as="xs:string*"/>
        <xsl:param name="text-title" as="xs:string*"/>
        <xsl:param name="test-title" as="xs:string"/>
        <xsl:param name="test-detail" as="node()"/>
        
        <a role="button" class="pop-up">
            <xsl:attribute name="href" select="concat('#', $cell-id)"/>
            <xsl:choose>
                <xsl:when test="$success">
                    <i class="fa fa-check-circle"/>
                </xsl:when>
                <xsl:otherwise>
                    <i class="fa fa-times-circle"/>
                </xsl:otherwise>
            </xsl:choose>
        </a>
        
        <div class="hidden">
            <div>
                <xsl:attribute name="id" select="$cell-id"/>
                <h3>
                    <xsl:choose>
                        <xsl:when test="$success">
                            <i class="fa fa-check-circle"/>
                            Success
                        </xsl:when>
                        <xsl:otherwise>
                            <i class="fa fa-times-circle"/>
                            Fail
                        </xsl:otherwise>
                    </xsl:choose>
                </h3>
                <p>
                    <xsl:value-of select="$test-title"/>
                </p>
                <p>
                    <xsl:value-of select="$text-title"/>
                    <br/>
                    <ul class="list-inline">
                        <li>
                            <xsl:value-of select="$text-id"/>
                        </li>
                        <li>
                            <a>
                                <xsl:attribute name="href" select="concat('/translation/', $text-id, '.html')"/>
                                <xsl:attribute name="target" select="concat($text-id, '-html')"/>
                                .html
                            </a>
                        </li>
                        <li>
                            <a>
                                <xsl:attribute name="href" select="concat('/translation/', $text-id, '.xml')"/>
                                <xsl:attribute name="target" select="concat($text-id, '-xml')"/>
                                .xml
                            </a>
                        </li>
                        <li>
                            <a>
                                <xsl:attribute name="href" select="concat('/translation/', $text-id, '.tei')"/>
                                <xsl:attribute name="target" select="concat($text-id, '-tei')"/>
                                .tei
                            </a>
                        </li>
                    </ul>
                </p>
                <ul>
                    <xsl:for-each select="$test-detail/m:detail">
                        <li>
                            <xsl:if test="@type eq 'debug'">
                                <xsl:attribute name="class" select="'debug'"/>
                            </xsl:if>
                            <xsl:copy-of select="node()"/>
                        </li>
                    </xsl:for-each>
                </ul>
            </div>
        </div>
        
    </xsl:function>
    
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
                                Automated tests
                            </li>
                        </ul>
                    </div>
                    
                    <div class="panel-body min-height-md">
                        
                        <form action="/tests.html" method="post" class="form-inline filter-form">
                            <div class="input-group">
                                <select name="translation-id" id="translation-id" class="form-control">
                                    <option value="all">All translations</option>
                                    <xsl:for-each select="//m:translations/m:translation">
                                        <xsl:sort select="@id"/>
                                        <option>
                                            <xsl:attribute name="value" select="@id"/>
                                            <xsl:if test="@id eq /m:response/@translation-id">
                                                <xsl:attribute name="selected" select="'selected'"/>
                                            </xsl:if>
                                            <xsl:value-of select="concat(@id, ' / ', m:toh, ' / ', m:title)"/>
                                        </option>
                                    </xsl:for-each>
                                </select>
                                <span class="input-group-btn">
                                    <button class="btn btn-primary" type="submit">Go!</button>
                                </span>
                            </div>
                        </form>
                        
                        <hr/>
                        
                        <table class="table table-responsive">
                            <thead>
                                <tr>
                                    <th>Text</th>
                                    <th>Status</th>
                                    <xsl:for-each select="//m:results/m:translation[1]/m:tests/m:test">
                                        <th class="test">
                                            <xsl:value-of select="position()"/>
                                        </th>
                                    </xsl:for-each>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each select="//m:results/m:translation">
                                    <xsl:sort select="count(m:tests/m:test/m:result[text() eq '1'])"/>
                                    <xsl:variable name="table-row" select="position()"/>
                                    <xsl:variable name="text-id" select="@id"/>
                                    <xsl:variable name="text-title" select="m:title/text()"/>
                                    <tr>
                                        <td>
                                            <a target="_blank">
                                                <xsl:attribute name="href" select="concat('/translation/', $text-id, '.html')"/>
                                                <xsl:attribute name="title" select="$text-title"/>
                                                <xsl:value-of select="$text-id"/>
                                            </a>
                                        </td>
                                        <td>
                                            <xsl:choose>
                                                <xsl:when test="@status = 'not-started'">
                                                    <div class="label label-default">
                                                        Not Started
                                                    </div>
                                                </xsl:when>
                                                <xsl:when test="@status = 'in-progress'">
                                                    <div class="label label-warning">
                                                        In progress
                                                    </div>
                                                </xsl:when>
                                                <xsl:when test="@status = 'missing'">
                                                    <div class="label label-danger">
                                                        Missing
                                                    </div>
                                                </xsl:when>
                                                <xsl:when test="@status = 'available'">
                                                    <div class="label label-success">
                                                        Translated
                                                    </div>
                                                </xsl:when>
                                            </xsl:choose>
                                        </td>
                                        <xsl:for-each select="m:tests/m:test">
                                            <xsl:variable name="test-id" select="position()"/>
                                            <xsl:variable name="cell-id" select="concat('col-', $test-id,'row-', $table-row)"/>
                                            <xsl:variable name="test-title" select="concat($test-id, '. ', m:title/text())"/>
                                            <xsl:variable name="test-result" select="xs:boolean(m:result/text())"/>
                                            <xsl:variable name="test-details" select="m:details"/>
                                            <td class="test">
                                                <xsl:copy-of select="m:test-result($test-result, $cell-id, $text-id, $text-title, $test-title, $test-details)"/>
                                            </td>
                                        </xsl:for-each>
                                    </tr>
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
                
                <div id="fixed-footer-close-container" class="fixed-btn-container close-btn-container">
                    <button type="button" class="btn-round close" aria-label="Close">
                        <span aria-hidden="true">
                            <i class="fa fa-times"/>
                        </span>
                    </button>
                </div>
                
            </div>
            
        </xsl:variable>
        
        <xsl:call-template name="reading-room-page">
            <xsl:with-param name="app-id" select="@app-id"/>
            <xsl:with-param name="page-url" select="''"/>
            <xsl:with-param name="page-type" select="'reading-room utilities tests'"/>
            <xsl:with-param name="page-title" select="'Reading Room Tests'"/>
            <xsl:with-param name="page-description" select="'Automated tests of the 84000 Reading Room app.'"/>
            <xsl:with-param name="content" select="$content"/>
        </xsl:call-template>
        
    </xsl:template>
    
</xsl:stylesheet>
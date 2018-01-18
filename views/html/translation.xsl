<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:common="http://read.84000.co/common" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:m="http://read.84000.co/ns/1.0" xmlns:xhtml="http://www.w3.org/1999/xhtml" exclude-result-prefixes="#all" version="2.0">
    
    <xsl:import href="../../xslt/functions.xsl"/>
    <xsl:import href="reading-room-page.xsl"/>
    
    <xsl:template match="/m:response">
        
        <xsl:variable name="app-id" select="@app-id"/>
        <xsl:variable name="environment" select="doc('/db/env/environment.xml')/m:environments/m:environment[@id = $app-id]"/>
        <xsl:variable name="resource-path" select="$environment/m:resource-path/text()"/>
        
        <!-- PAGE CONTENT -->
        <xsl:variable name="content">
            
            <article class="container">
                
                <div class="panel panel-default">
                    
                    <div>
                        <xsl:choose>
                            <xsl:when test="m:translation/@status = 'available'">
                                <xsl:attribute name="class" select="'panel-heading panel-heading-bold hidden-print'"/>
                                <ul class="breadcrumb">
                                    <li>
                                        <a href="/section/lobby.html">The Lobby</a>
                                    </li>
                                    <xsl:for-each select="m:translation//m:parent">
                                        <xsl:sort select="@nesting" order="descending"/>
                                        <li>
                                            <a>
                                                <xsl:attribute name="href" select="concat('/section/', @id/string(), '.html')"/>
                                                <xsl:value-of select="m:title[@xml:lang='en']/text()"/>
                                            </a>
                                        </li>
                                    </xsl:for-each>
                                </ul>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="class" select="'panel-heading panel-heading-bold panel-heading-danger'"/>
                                This text is not yet ready for publication!
                            </xsl:otherwise>
                        </xsl:choose>
                    </div>
    
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-sm-offset-1 col-sm-10 print-width-override">
    
                                <section id="title" class="indent">
                                    
                                    <div class="page page-first">
                                        
                                        <div id="titles" class="section-panel">
                                            <h2 class="text-bo">
                                                <xsl:value-of select="m:translation/m:titles/m:title[@xml:lang eq 'bo']"/>
                                            </h2>
                                            <h1>
                                                <xsl:value-of select="m:translation/m:titles/m:title[@xml:lang eq 'en']"/>
                                            </h1>
                                            <xsl:if test="m:translation/m:titles/m:title[@xml:lang eq 'sa-ltn']/text()">
                                                <h2 class="text-sa italic">
                                                    <xsl:value-of select="m:translation/m:titles/m:title[@xml:lang eq 'sa-ltn']"/>
                                                </h2>
                                            </xsl:if>
                                        </div>
                                        
                                        <xsl:if test="count(m:translation/m:long-titles/m:title/text()) eq 1 and m:translation/m:long-titles/m:title[@xml:lang eq 'bo-ltn']/text()">
                                            <h4 class="text-bo">
                                                <xsl:value-of select="m:translation/m:long-titles/m:title[@xml:lang eq 'bo-ltn']/text()"/>
                                            </h4>
                                        </xsl:if>
                                        
                                        <div class="hidden-print">
                                            <img class="logo">
                                                <xsl:attribute name="src" select="concat($resource-path,'/imgs/logo-stacked.png')"/>
                                            </img>
                                        </div>
                                        
                                    </div>
                                    
                                    <xsl:if test="count(m:translation/m:long-titles/m:title/text()) gt 1">
                                        <div class="page">
                                            
                                            <div id="long-titles">
                                                <xsl:if test="m:translation/m:long-titles/m:title[@xml:lang eq 'bo']/text()">
                                                    <h4 class="text-bo">
                                                        <xsl:value-of select="m:translation/m:long-titles/m:title[@xml:lang eq 'bo']"/>
                                                    </h4>
                                                </xsl:if>
                                                <xsl:if test="m:translation/m:long-titles/m:title[@xml:lang eq 'bo-ltn']/text()">
                                                    <h4 class="text-wy italic">
                                                        <xsl:value-of select="m:translation/m:long-titles/m:title[@xml:lang eq 'bo-ltn']"/>
                                                    </h4>
                                                </xsl:if>
                                                <xsl:if test="m:translation/m:long-titles/m:title[@xml:lang eq 'en']/text()">
                                                    <h4>
                                                        <xsl:value-of select="m:translation/m:long-titles/m:title[@xml:lang eq 'en']"/>
                                                    </h4>
                                                </xsl:if>
                                                <xsl:if test="m:translation/m:long-titles/m:title[@xml:lang eq 'sa-ltn']/text()">
                                                    <h4 class="text-sa italic">
                                                        <xsl:value-of select="m:translation/m:long-titles/m:title[@xml:lang eq 'sa-ltn']"/>
                                                    </h4>
                                                </xsl:if>
                                            </div>
                                            
                                        </div>
                                    </xsl:if>
    
                                    <div class="page">
                                        
                                        <div class="visible-print-block">
                                            <img class="logo">
                                                <xsl:attribute name="src" select="concat($resource-path,'/imgs/logo.png')"/>
                                            </img>
                                        </div>
                                        
                                        <div>
                                            <h4>
                                                <strong>
                                                    <xsl:value-of select="m:translation/m:source/m:toh"/>
                                                </strong>
                                            </h4>
                                            <p>
                                                <xsl:value-of select="string-join(m:translation/m:source/m:series/text() | m:translation/m:source/m:scope/text() | m:translation/m:source/m:range/text(), ', ')"/>.
                                            </p>
                                        </div>
    
                                        <div class="well">
                                            <xsl:for-each select="m:translation/m:translation/m:authors/m:summary">
                                                <p>
                                                    <xsl:copy-of select="node()"/>
                                                </p>
                                            </xsl:for-each>
                                        </div>
    
                                        <div>
                                            <p>
                                                <xsl:copy-of select="m:translation/m:translation/m:edition/node()"/>
                                            </p>
                                            <p>
                                                <xsl:copy-of select="m:translation/m:translation/m:publication-statement/node()"/>
                                            </p>
                                        </div>
    
                                        <div class="license">
                                            <img>
                                                <xsl:attribute name="src" select="m:translation/m:translation/m:license/@img-url"/>
                                            </img>
                                            <p class="text-muted small">
                                                <xsl:copy-of select="m:translation/m:translation/m:license/xhtml:p/node()"/>
                                            </p>
                                        </div>
                                    </div>
    
                                </section>
    
                                <aside class="download-options hidden-print text-center">
                                    <h4 class="sr-only">Download Options</h4>
                                    <a href="#top" class="milestone btn-round" title="Bookmark this page">
                                        <i class="fa fa-bookmark"/>
                                    </a>
                                    <a href="javascript:window.print()" class="btn-round" title="Print">
                                        <i class="fa fa-print"/>
                                    </a>
                                    <a href="#" title="Download PDF" class="disabled btn-round" target="_blank">
                                        <xsl:if test="m:translation/m:downloads/m:download[@type = 'pdf']">
                                            <xsl:attribute name="href" select="m:translation/m:downloads/m:download[@type = 'pdf']/@url"/>
                                            <xsl:attribute name="download" select="m:translation/m:downloads/m:download[@type = 'pdf']/@filename"/>
                                            <xsl:attribute name="class" select="'btn-round log-click'"/>
                                        </xsl:if>
                                        <i class="fa fa-file-pdf-o"/>
                                    </a>
                                    <a href="#" title="Download EPub" class="disabled btn-round" target="_blank">
                                        <xsl:if test="m:translation/m:downloads/m:download[@type = 'epub']">
                                            <xsl:attribute name="href" select="m:translation/m:downloads/m:download[@type = 'epub']/@url"/>
                                            <xsl:attribute name="download" select="m:translation/m:downloads/m:download[@type = 'epub']/@filename"/>
                                            <xsl:attribute name="class" select="'btn-round log-click'"/>
                                        </xsl:if>
                                        <i class="fa fa-book"/>
                                    </a>
                                    
                                </aside>
    
                                <hr class="hidden-print"/>
    
                                <aside id="contents" class="page indent">
                                    <a href="#contents" class="milestone" title="Bookmark this section">co.</a>
                                    <h3>Contents</h3>
                                    <table class="contents-table">
                                        <tbody>
                                            <tr>
                                                <td>ti.</td>
                                                <td>
                                                    <a href="#top" class="scroll-to-anchor">Title</a>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>co.</td>
                                                <td>
                                                    <a href="#contents" class="scroll-to-anchor">Contents</a>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>s.</td>
                                                <td>
                                                    <a href="#summary" class="scroll-to-anchor">Summary</a>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>ac.</td>
                                                <td>
                                                    <a href="#acknowledgements" class="scroll-to-anchor">Acknowledgements</a>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>i.</td>
                                                <td>
                                                    <a href="#introduction" class="scroll-to-anchor">Introduction</a>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>tr.</td>
                                                <td>
                                                    <a href="#body-title" class="scroll-to-anchor">The Translation</a>
                                                    <table>
                                                        <tbody>
                                                            <xsl:if test="m:translation/m:prologue/xhtml:p">
                                                                <tr>
                                                                    <td>
                                                                        <a href="#prologue" class="scroll-to-anchor">Prologue</a>
                                                                    </td>
                                                                </tr>
                                                            </xsl:if>
                                                            <xsl:if test="m:translation/m:body/m:chapter[xhtml:h2 | xhtml:h4]">
                                                                <xsl:for-each select="m:translation/m:body/m:chapter">
                                                                    <tr>
                                                                        <td>
                                                                            <a class="scroll-to-anchor">
                                                                                <xsl:attribute name="href" select="concat('#chapter-', @chapter-index/string())"/>
                                                                                <xsl:choose>
                                                                                    <xsl:when test="xhtml:h2">
                                                                                       <xsl:value-of select="@chapter-index"/>. <xsl:value-of select="xhtml:h2"/>
                                                                                    </xsl:when>
                                                                                    <xsl:otherwise>
                                                                                        <xsl:choose>
                                                                                            <xsl:when test="xhtml:h4[@class = 'chapter-number']">
                                                                                                <xsl:value-of select="xhtml:h4[@class = 'chapter-number']"/>
                                                                                            </xsl:when>
                                                                                            <xsl:otherwise>
                                                                                                Chapter <xsl:value-of select="@chapter-index"/>
                                                                                            </xsl:otherwise>
                                                                                        </xsl:choose>
                                                                                    </xsl:otherwise>
                                                                                </xsl:choose>
                                                                            </a>
                                                                        </td>
                                                                    </tr>
                                                                </xsl:for-each>
                                                            </xsl:if>
                                                            
                                                        </tbody>
                                                    </table>
                                                </td>
                                            </tr>
                                            <xsl:if test="m:translation/m:colophon/xhtml:p">
                                                <tr>
                                                    <td>c.</td>
                                                    <td>
                                                        <a href="#colophon" class="scroll-to-anchor">Colophon</a>
                                                    </td>
                                                </tr>
                                            </xsl:if>
                                            <xsl:if test="m:translation/m:abbreviations/m:item">
                                                <tr>
                                                    <td>ab.</td>
                                                    <td>
                                                        <a href="#abbreviations" class="scroll-to-anchor">Abbreviations</a>
                                                    </td>
                                                </tr>
                                            </xsl:if>
                                            <tr>
                                                <td>n.</td>
                                                <td>
                                                    <a href="#notes" class="scroll-to-anchor">Notes</a>
                                                </td>
                                            </tr>
                                            <xsl:if test="m:translation/m:appendix//xhtml:p">
                                                <tr>
                                                    <td>ap.</td>
                                                    <td>
                                                        <a href="#appendix" class="scroll-to-anchor">Appendix</a>
                                                        <xsl:if test="m:translation/m:appendix/m:chapter/xhtml:h4">
                                                            <table>
                                                                <tbody>
                                                                    <xsl:for-each select="m:translation/m:appendix/m:chapter">
                                                                        <tr>
                                                                            <td>
                                                                                <a class="scroll-to-anchor">
                                                                                    <xsl:attribute name="href" select="concat('#appendix-chapter-', @chapter-index/string())"/>
                                                                                    <xsl:choose>
                                                                                        <xsl:when test="xhtml:h4">
                                                                                            <xsl:value-of select="xhtml:h4"/>
                                                                                        </xsl:when>
                                                                                        <xsl:otherwise>
                                                                                            Chapter <xsl:value-of select="@chapter-index"/>
                                                                                        </xsl:otherwise>
                                                                                    </xsl:choose>
                                                                                </a>
                                                                            </td>
                                                                        </tr>
                                                                    </xsl:for-each>
                                                                </tbody>
                                                            </table>
                                                        </xsl:if>
                                                    </td>
                                                </tr>
                                            </xsl:if>
                                            <tr>
                                                <td>b.</td>
                                                <td>
                                                    <a href="#bibliography" class="scroll-to-anchor">Bibliography</a>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>g.</td>
                                                <td>
                                                    <a href="#glossary" class="scroll-to-anchor">Glossary</a>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </aside>
    
                                <hr class="hidden-print"/>
    
                                <section id="summary" class="page indent text">
                                    <a href="#summary" class="milestone" title="Bookmark this section">s.</a>
                                    <h3>Summary</h3>
                                    <xsl:copy-of select="m:translation/m:summary/xhtml:*"/>
                                </section>
    
                                 <hr class="hidden-print"/>
    
                                <section id="acknowledgements" class="indent text">
                                    <a href="#acknowledgements" class="milestone" title="Bookmark this section">ac.</a>
                                    <h3>Acknowledgements</h3>
                                    <xsl:copy-of select="m:translation/m:acknowledgment/xhtml:*"/>  
                                </section>
    
                                <hr class="hidden-print"/>
    
                                <section id="introduction" class="page indent text">
                                    <a href="#introduction" class="milestone" title="Bookmark this section">i.</a>
                                    <h3>Introduction</h3>
                                    <xsl:copy-of select="m:translation/m:introduction/xhtml:*"/>
                                </section>
    
                                <hr class="hidden-print"/>
    
                                <section id="body-title" class="page indent">
                                    <a href="#body-title" class="milestone hidden-print" title="Bookmark this section">tr.</a>
                                    <h3>The Translation</h3>
                                    <xsl:if test="m:translation/m:body/m:honoration/text()">
                                        <h2>
                                            <xsl:value-of select="m:translation/m:body/m:honoration"/>
                                        </h2>
                                    </xsl:if>
                                    <h1>
                                        <xsl:value-of select="m:translation/m:body/m:main-title"/>
                                    </h1>
                                </section>
                                
                                <xsl:if test="m:translation/m:prologue/xhtml:p">
                                    <hr class="hidden-print"/>
                                    <section id="prologue" class="page indent text">
                                        <a href="#prologue" class="milestone" title="Bookmark this section">p.</a>
                                        <xsl:copy-of select="m:translation/m:prologue/xhtml:*"/>
                                    </section>
                                </xsl:if>
                                
                                <xsl:for-each select="m:translation/m:body/m:chapter">
                                    
                                    <xsl:if test="xhtml:h2">
                                        <hr class="hidden-print"/>
                                    </xsl:if>
                                    
                                    <section>
                                        <xsl:attribute name="id" select="concat('chapter-', @chapter-index/string())"/>
                                        <xsl:choose>
                                            <xsl:when test="xhtml:h2 or m:translation/m:prologue/xhtml:p">
                                                <xsl:attribute name="class" select="'chapter page indent text'"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:attribute name="class" select="'chapter indent text'"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        
                                        <xsl:if test="xhtml:h2">
                                            
                                            <a class="milestone" title="Bookmark this section">
                                                <xsl:attribute name="href" select="concat('#chapter-', @chapter-index/string())"/>
                                                <xsl:value-of select="concat(@chapter-index, '.')"/>
                                            </a>
                                            
                                            <xsl:if test="not(xhtml:h4[@class = 'chapter-number'])">
                                                <h4 class="chapter-number">
                                                    Chapter <xsl:value-of select="@chapter-index"/>
                                                </h4>
                                            </xsl:if>
                                            
                                        </xsl:if>
                                        
                                        <xsl:copy-of select="xhtml:*"/>
                                        
                                    </section>
                                    
                                </xsl:for-each>
                                
                                <xsl:if test="m:translation/m:colophon/xhtml:p">
                                    
                                    <hr class="hidden-print"/>
                                    
                                    <section id="colophon" class="indent text">
                                        <a href="#colophon" class="milestone" title="Bookmark this section">c.</a>
                                        <h4>Colophon</h4>
                                        <xsl:copy-of select="m:translation/m:colophon/xhtml:*"/>
                                    </section>
                                </xsl:if>
                                
                                <xsl:if test="m:translation/m:appendix//xhtml:p">
                                    
                                    <hr class="hidden-print"/>
                                    
                                    <section id="appendix" class="page indent text">
                                        <a href="#appendix" class="milestone" title="Bookmark this section">ap.</a>
                                        <h3>Appendix</h3>
                                        <xsl:for-each select="m:translation/m:appendix/m:chapter | m:translation/m:appendix/m:prologue">
                                            
                                            <div class="relative chapter">
                                                
                                                <xsl:attribute name="id" select="concat('appendix-chapter-', @chapter-index/string())"/>
                                                
                                                <xsl:if test="xhtml:h4">
                                                    
                                                    <a class="milestone" title="Bookmark this section">
                                                        <xsl:attribute name="href" select="concat('#appendix-chapter-', @chapter-index/string())"/>
                                                        <xsl:value-of select="concat('ap', @chapter-index, '.')"/>
                                                    </a>
                                                    
                                                </xsl:if>
                                                
                                                <xsl:copy-of select="xhtml:*"/>
                                                
                                            </div>
                                        </xsl:for-each>
                                    </section>
                                </xsl:if>
                                
                                <xsl:if test="m:translation/m:abbreviations/m:item">
                                    
                                    <hr class="hidden-print"/>
                                    
                                    <section id="abbreviations" class="page indent">
                                        <a href="#abbreviations" class="milestone" title="Bookmark this section">ab.</a>
                                        <h3>Abbreviations</h3>
                                        <dl>
                                            <xsl:for-each select="m:translation/m:abbreviations/m:item">
                                                <xsl:sort select="m:abbreviation/text()"/>
                                                <dt>
                                                    <xsl:value-of select="m:abbreviation/text()"/>
                                                </dt>
                                                <dd>
                                                    <xsl:copy-of select="m:explanation/node()"/>
                                                </dd>
                                            </xsl:for-each>
                                        </dl>
                                    </section>
                                    
                                </xsl:if>
    
                                <hr class="hidden-print"/>
    
                                <section id="notes" class="page indent">
                                    <a href="#notes" class="milestone" title="Bookmark this section">n.</a>
                                    <h3>Notes</h3>
                                    <xsl:for-each select="m:translation/m:notes/m:note">
                                        <p class="footnote indent glossarize">
                                            <xsl:attribute name="id" select="@uid"/>
                                            <a class="scroll-to-anchor footnote-number">
                                                <xsl:attribute name="href">
                                                    <xsl:value-of select="concat('#link-to-', @uid)"/>
                                                </xsl:attribute>
                                                <xsl:attribute name="data-mark">
                                                    <xsl:value-of select="concat('#link-to-', @uid)"/>
                                                </xsl:attribute>
                                                <xsl:value-of select="@index"/>
                                            </a>
                                            <xsl:copy-of select="node()"/>
                                        </p>
                                    </xsl:for-each>
                                </section>
                                
                                <hr class="hidden-print"/>
                                
                                <section id="bibliography" class="page indent">
                                    <a href="#bibliography" class="milestone" title="Bookmark this section">b.</a>
                                    <h3>Bibliography</h3>
                                    <xsl:for-each select="m:translation/m:bibliography/m:section">
                                        <div>
                                            <h4>
                                                <xsl:value-of select="m:title/text()"/>
                                            </h4>
                                            <xsl:for-each select="m:item">
                                                <p class="bibl">
                                                    <xsl:copy-of select="node()"/>
                                                </p>
                                            </xsl:for-each>
                                        </div>
                                    </xsl:for-each>
                                    
                                </section>
    
                                <hr class="hidden-print"/>
    
                                <section id="glossary" class="page indent">
                                    <a href="#glossary" class="milestone" title="Bookmark this section">g.</a>
                                    <h3>Glossary</h3>
                                    <xsl:for-each select="m:translation/m:glossary/m:item">
                                        <xsl:sort select="common:standardized-sa(m:term[lower-case(@xml:lang) = 'en'][1])"/>
                                        <div class="glossary-item">
                                            <xsl:attribute name="id" select="@uid/string()"/>
                                            <xsl:attribute name="data-match" select="if(@mode/string() eq 'marked') then 'marked' else 'match'"/>
                                            <a class="milestone" title="Bookmark this section">
                                                <xsl:attribute name="href" select="concat('#', @uid/string())"/>
                                                <xsl:value-of select="concat('g.', position())"/>
                                            </a>
                                            <div class="row">
                                                
                                                <div class="col-sm-6 col-md-8 match-this-height print-width-override print-height-override">
                                                    
                                                    <xsl:attribute name="data-match-height" select="concat('g-', position())"/>
                                                    
                                                    <h4 class="term">
                                                        <xsl:value-of select="m:term[lower-case(@xml:lang) = 'en']"/>
                                                    </h4>
                                                    
                                                    <xsl:for-each select="m:term[lower-case(@xml:lang) != 'en']">
                                                        <p>
                                                            <xsl:attribute name="class" select="common:lang-class(@xml:lang)"/>
                                                            <xsl:value-of select="text()"/>
                                                        </p>
                                                    </xsl:for-each>
                                                    
                                                    <xsl:for-each select="m:alternatives/m:alternative">
                                                        <p class="term alternative">
                                                            <xsl:value-of select="text()"/>
                                                        </p>
                                                    </xsl:for-each>
                                                    
                                                    <xsl:for-each select="m:definitions/m:definition">
                                                        <p>
                                                            <xsl:copy-of select="node()"/>
                                                        </p>
                                                    </xsl:for-each>
                                                    
                                                </div>
                                                
                                                <div class="col-sm-6 col-md-4 occurences hidden-print match-height-overflow print-height-override">
                                                    <xsl:attribute name="data-match-height" select="concat('g-', position())"/>
                                                    <h6>Passages containing this term</h6>
                                                </div>
                                                
                                            </div>
                                        </div>
                                    </xsl:for-each>
                                </section>
    
                            </div>
                        </div>
                    </div>
                </div>
            </article>
            
            <div class="nav-controls hidden-print">
                
                <div id="navigation-btn-container" class="fixed-btn-container">
                    
                    <a href="#contents-sidebar" class="btn-round show-sidebar">
                        <i class="fa fa-bars" aria-hidden="true"/>
                    </a>
                    
                </div>
                
                <div id="bookmarks-btn-container" class="fixed-btn-container">
                    
                    <a href="#bookmarks-sidebar" id="bookmarks-btn" class="btn-round show-sidebar" aria-haspopup="true">
                        <i class="fa fa-bookmark"/>
                        <span class="badge badge-notification">0</span>
                    </a>
                    
                </div>
                
                <div id="rewind-btn-container" class="fixed-btn-container hidden">
                    
                    <button class="btn-round" title="Return to the last location">
                        <i class="fa fa-undo" aria-hidden="true"/>
                    </button>
                    
                </div>
                
                <div id="link-to-top-container" class="fixed-btn-container">
                    
                    <a href="#top" id="link-to-top" class="btn-round" title="Return to the top of the page">
                        <i class="fa fa-arrow-up" aria-hidden="true"/>
                    </a>
                    
                </div>
                
            </div>
    
            <div id="popup-footer" class="fixed-footer collapse hidden-print">
                
                <div class="container">
                    <div class="panel">
                        <div class="panel-body">
                            <div class="row fix-height">
                                <div class="col-sm-offset-1 col-sm-10">
                                    <div class="indent data-container">
                                        
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="fixed-btn-container close-btn-container">
                    <button type="button" class="btn-round close" aria-label="Close">
                        <span aria-hidden="true">
                            <i class="fa fa-times"/>
                        </span>
                    </button>
                </div>
                
            </div>
            
            <div id="contents-sidebar" class="fixed-sidebar collapse width hidden-print">
                
                <div class="container">
                    <div class="fix-width">
                        <h4>Contents</h4>
                        <div class="data-container"/>
                        <h4>Other Links</h4>
                        <table class="contents-table">
                            <tbody>
                                <tr>
                                    <td>
                                        <a href="http://84000.co">84000 Homepage</a>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <a href="/">Reading Room Lobby</a>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <a href="/section/all-translated.html">View Translated Texts</a>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        <a href="http://84000.co/how-you-can-help/donate/#sap" class="btn btn-primary btn-uppercase">Sponsor Translation</a>
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
            
        </xsl:variable>
        
        <!-- Pass the content to the page -->
        <xsl:call-template name="reading-room-page">
            <xsl:with-param name="page-type" select="concat('reading-room translation ', if(@view-mode eq 'editor') then 'editor-mode' else '')"/>
            <xsl:with-param name="page-title" select="m:translation/m:titles/m:title[@xml:lang eq 'en']/text()"/>
            <xsl:with-param name="app-id" select="@app-id"/>
            <xsl:with-param name="content" select="$content"/>
        </xsl:call-template>
        
    </xsl:template>
    
</xsl:stylesheet>
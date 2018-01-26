<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exist="http://exist.sourceforge.net/NS/exist" xmlns:common="http://read.84000.co/common" xmlns:epub="http://www.idpf.org/2007/ops" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:m="http://read.84000.co/ns/1.0" xmlns:xhtml="http://www.w3.org/1999/xhtml" exclude-result-prefixes="#all" version="2.0">
    
    <xsl:import href="../../xslt/tei-to-xhtml.xsl"/>
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
                                <ul id="outline" class="breadcrumb">
                                    <li>
                                        <a href="/section/lobby.html">The Lobby</a>
                                    </li>
                                    <xsl:for-each select="m:translation//m:parent">
                                        <xsl:sort select="@nesting" order="descending"/>
                                        <li>
                                            <a>
                                                <xsl:attribute name="href" select="concat('/section/', @id/string(), '.html')"/>
                                                <xsl:apply-templates select="m:title[@xml:lang='en']/text()"/>
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
                                                <xsl:apply-templates select="m:translation/m:titles/m:title[@xml:lang eq 'bo']"/>
                                            </h2>
                                            <h1>
                                                <xsl:apply-templates select="m:translation/m:titles/m:title[@xml:lang eq 'en']"/>
                                            </h1>
                                            <xsl:if test="m:translation/m:titles/m:title[@xml:lang eq 'sa-ltn']/text()">
                                                <h2 class="text-sa italic">
                                                    <xsl:apply-templates select="m:translation/m:titles/m:title[@xml:lang eq 'sa-ltn']"/>
                                                </h2>
                                            </xsl:if>
                                        </div>
                                        
                                        <xsl:if test="count(m:translation/m:long-titles/m:title/text()) eq 1 and m:translation/m:long-titles/m:title[@xml:lang eq 'bo-ltn']/text()">
                                            <div id="long-titles">
                                                <h4 class="text-wy italic">
                                                    <xsl:apply-templates select="m:translation/m:long-titles/m:title[@xml:lang eq 'bo-ltn']/text()"/>
                                                </h4>
                                            </div>
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
                                                        <xsl:apply-templates select="m:translation/m:long-titles/m:title[@xml:lang eq 'bo']"/>
                                                    </h4>
                                                </xsl:if>
                                                <xsl:if test="m:translation/m:long-titles/m:title[@xml:lang eq 'bo-ltn']/text()">
                                                    <h4 class="text-wy italic">
                                                        <xsl:apply-templates select="m:translation/m:long-titles/m:title[@xml:lang eq 'bo-ltn']"/>
                                                    </h4>
                                                </xsl:if>
                                                <xsl:if test="m:translation/m:long-titles/m:title[@xml:lang eq 'en']/text()">
                                                    <h4>
                                                        <xsl:apply-templates select="m:translation/m:long-titles/m:title[@xml:lang eq 'en']"/>
                                                    </h4>
                                                </xsl:if>
                                                <xsl:if test="m:translation/m:long-titles/m:title[@xml:lang eq 'sa-ltn']/text()">
                                                    <h4 class="text-sa italic">
                                                        <xsl:apply-templates select="m:translation/m:long-titles/m:title[@xml:lang eq 'sa-ltn']"/>
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
                                                <strong id="toh">
                                                    <xsl:apply-templates select="m:translation/m:source/m:toh"/>
                                                </strong>
                                            </h4>
                                            <p id="location">
                                                <xsl:value-of select="string-join(m:translation/m:source/m:series/text() | m:translation/m:source/m:scope/text() | m:translation/m:source/m:range/text(), ', ')"/>.
                                            </p>
                                        </div>
    
                                        <div class="well">
                                            <xsl:for-each select="m:translation/m:translation/m:authors/m:summary">
                                                <p id="authours-summary">
                                                    <xsl:apply-templates select="node()"/>
                                                </p>
                                            </xsl:for-each>
                                        </div>
    
                                        <div>
                                            <p id="edition">
                                                <xsl:apply-templates select="m:translation/m:translation/m:edition"/>
                                            </p>
                                            <p id="publication-statement">
                                                <xsl:apply-templates select="m:translation/m:translation/m:publication-statement"/>
                                            </p>
                                        </div>
    
                                        <div id="license">
                                            <img>
                                                <xsl:attribute name="src" select="m:translation/m:translation/m:license/@img-url"/>
                                            </img>
                                            <xsl:for-each select="m:translation/m:translation/m:license/tei:p">
                                                <p class="text-muted small">
                                                    <xsl:apply-templates select="node()"/>
                                                </p>
                                            </xsl:for-each>
                                        </div>
                                    </div>
    
                                </section>
    
                                <aside class="download-options hidden-print text-center">
                                    <h5 class="sr-only">Download Options</h5>
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
                                            <xsl:if test="m:translation/m:summary//tei:p">
                                                <tr>
                                                    <td>
                                                        <xsl:value-of select="concat(m:translation/m:summary/@prefix, '.')"/>
                                                    </td>
                                                    <td>
                                                        <a href="#summary" class="scroll-to-anchor">Summary</a>
                                                    </td>
                                                </tr>
                                            </xsl:if>
                                            <xsl:if test="m:translation/m:acknowledgment//tei:p">
                                                <tr>
                                                    <td>
                                                        <xsl:value-of select="concat(m:translation/m:acknowledgment/@prefix, '.')"/>
                                                    </td>
                                                    <td>
                                                        <a href="#acknowledgements" class="scroll-to-anchor">Acknowledgements</a>
                                                    </td>
                                                </tr>
                                            </xsl:if>
                                            <xsl:if test="m:translation/m:introduction//tei:p">
                                                <tr>
                                                    <td>
                                                        <xsl:value-of select="concat(m:translation/m:introduction/@prefix, '.')"/>
                                                    </td>
                                                    <td>
                                                        <a href="#introduction" class="scroll-to-anchor">Introduction</a>
                                                    </td>
                                                </tr>
                                            </xsl:if>
                                            <tr>
                                                <td>
                                                    <xsl:value-of select="concat(m:translation/m:body/@prefix, '.')"/>
                                                </td>
                                                <td>
                                                    <a href="#body-title" class="scroll-to-anchor">The Translation</a>
                                                    <table>
                                                        <tbody>
                                                            <xsl:if test="m:translation/m:prologue/tei:p">
                                                                <tr>
                                                                    <td>
                                                                        <a href="#prologue" class="scroll-to-anchor">Prologue</a>
                                                                    </td>
                                                                </tr>
                                                            </xsl:if>
                                                            <xsl:for-each select="m:translation/m:body/m:chapter[m:title/text() | m:title-number/text()]">
                                                                <tr>
                                                                    <td>
                                                                        <a class="scroll-to-anchor">
                                                                            <xsl:attribute name="href" select="concat('#chapter-', @chapter-index/string())"/>
                                                                            <xsl:choose>
                                                                                <xsl:when test="m:title/text()">
                                                                                    <xsl:apply-templates select="@chapter-index"/>. <xsl:apply-templates select="m:title/text()"/>
                                                                                </xsl:when>
                                                                                <xsl:otherwise>
                                                                                    <xsl:apply-templates select="m:title-number/text()"/>
                                                                                </xsl:otherwise>
                                                                            </xsl:choose>
                                                                        </a>
                                                                    </td>
                                                                </tr>
                                                            </xsl:for-each>
                                                        </tbody>
                                                    </table>
                                                </td>
                                            </tr>
                                            <xsl:if test="m:translation/m:colophon/tei:p">
                                                <tr>
                                                    <td>
                                                        <xsl:value-of select="concat(m:translation/m:colophon/@prefix, '.')"/>
                                                    </td>
                                                    <td>
                                                        <a href="#colophon" class="scroll-to-anchor">Colophon</a>
                                                    </td>
                                                </tr>
                                            </xsl:if>
                                            <xsl:if test="m:translation/m:appendix//tei:p">
                                                <tr>
                                                    <td>
                                                        <xsl:value-of select="concat(m:translation/m:appendix/@prefix, '.')"/>
                                                    </td>
                                                    <td>
                                                        <a href="#appendix" class="scroll-to-anchor">Appendix</a>
                                                        <xsl:if test="count(m:translation/m:appendix/m:chapter) gt 1">
                                                            <table>
                                                                <tbody>
                                                                    <xsl:for-each select="m:translation/m:appendix/m:chapter">
                                                                        <tr>
                                                                            <td>
                                                                                <a class="scroll-to-anchor">
                                                                                    <xsl:attribute name="href" select="concat('#appendix-chapter-', @chapter-index/string())"/>
                                                                                    <xsl:apply-templates select="m:title"/>
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
                                            <xsl:if test="m:translation/m:abbreviations/m:item">
                                                <tr>
                                                    <td>
                                                        <xsl:value-of select="concat(m:translation/m:abbreviations/@prefix, '.')"/>
                                                    </td>
                                                    <td>
                                                        <a href="#abbreviations" class="scroll-to-anchor">Abbreviations</a>
                                                    </td>
                                                </tr>
                                            </xsl:if>
                                            <tr>
                                                <td>
                                                    <xsl:value-of select="concat(m:translation/m:notes/@prefix, '.')"/>
                                                </td>
                                                <td>
                                                    <a href="#notes" class="scroll-to-anchor">Notes</a>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <xsl:value-of select="concat(m:translation/m:bibliography/@prefix, '.')"/>
                                                </td>
                                                <td>
                                                    <a href="#bibliography" class="scroll-to-anchor">Bibliography</a>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <xsl:value-of select="concat(m:translation/m:glossary/@prefix, '.')"/>
                                                </td>
                                                <td>
                                                    <a href="#glossary" class="scroll-to-anchor">Glossary</a>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </aside>
    
                                <hr class="hidden-print"/>
    
                                <section id="summary" class="page indent text glossarize-section">
                                    <a href="#summary" class="milestone" title="Bookmark this section">
                                        <xsl:value-of select="concat(m:translation/m:summary/@prefix, '.')"/>
                                    </a>
                                    <h3>Summary</h3>
                                    <xsl:apply-templates select="m:translation/m:summary"/>
                                </section>
    
                                 <hr class="hidden-print"/>
    
                                <section id="acknowledgements" class="indent text">
                                    <a href="#acknowledgements" class="milestone" title="Bookmark this section">
                                        <xsl:value-of select="concat(m:translation/m:acknowledgment/@prefix, '.')"/>
                                    </a>
                                    <h3>Acknowledgements</h3>
                                    <xsl:apply-templates select="m:translation/m:acknowledgment"/>  
                                </section>
    
                                <hr class="hidden-print"/>
    
                                <section id="introduction" class="page indent text glossarize-section">
                                    <a href="#introduction" class="milestone" title="Bookmark this section">
                                        <xsl:value-of select="concat(m:translation/m:introduction/@prefix, '.')"/>
                                    </a>
                                    <h3>Introduction</h3>
                                    <xsl:apply-templates select="m:translation/m:introduction"/>
                                </section>
    
                                <hr class="hidden-print"/>
    
                                <section id="body-title" class="page indent">
                                    <a href="#body-title" class="milestone hidden-print" title="Bookmark this section">
                                        <xsl:value-of select="concat(m:translation/m:body/@prefix, '.')"/>
                                    </a>
                                    <h3>The Translation</h3>
                                    <xsl:if test="m:translation/m:body/m:honoration/text()">
                                        <h2>
                                            <xsl:apply-templates select="m:translation/m:body/m:honoration"/>
                                        </h2>
                                    </xsl:if>
                                    <h1>
                                        <xsl:apply-templates select="m:translation/m:body/m:main-title"/>
                                    </h1>
                                </section>
                                
                                <xsl:if test="m:translation/m:prologue/tei:p">
                                    <hr class="hidden-print"/>
                                    <section id="prologue" class="page indent text glossarize-section">
                                        <a href="#prologue" class="milestone" title="Bookmark this section">
                                            <xsl:value-of select="concat(m:translation/m:prologue/@prefix, '.')"/>
                                        </a>
                                        <xsl:apply-templates select="m:translation/m:prologue"/>
                                    </section>
                                </xsl:if>
                                
                                <div id="translation">
                                    
                                    <xsl:for-each select="m:translation/m:body/m:chapter">
                                        
                                        <xsl:if test="m:title/text()">
                                            <hr class="hidden-print"/>
                                        </xsl:if>
                                        
                                        <section>
                                            <xsl:attribute name="id" select="concat('chapter-', @chapter-index/string())"/>
                                            <xsl:choose>
                                                <xsl:when test="m:title/text() or m:title-number/text() or m:translation/m:prologue/tei:p">
                                                    <xsl:attribute name="class" select="'chapter indent text glossarize-section page'"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:attribute name="class" select="'chapter indent text glossarize-section'"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            
                                            <xsl:if test="m:title/text() or m:title-number/text()">
                                                
                                                <a class="milestone" title="Bookmark this section">
                                                    <xsl:attribute name="href" select="concat('#chapter-', @chapter-index/string())"/>
                                                    <xsl:value-of select="concat(@prefix, '.')"/>
                                                </a>
                                                
                                                <xsl:if test="m:title-number/text()">
                                                    <h4 class="chapter-number">
                                                        <xsl:apply-templates select="m:title-number/text()"/>
                                                    </h4>
                                                </xsl:if>
                                                
                                                <xsl:if test="m:title/text()">
                                                    <h2>
                                                        <xsl:apply-templates select="m:title/text()"/>
                                                    </h2>
                                                </xsl:if>
                                                
                                            </xsl:if>
                                            
                                            <xsl:apply-templates select="tei:*"/>
                                            
                                        </section>
                                        
                                    </xsl:for-each>
                                </div>
                                
                                <xsl:if test="m:translation/m:colophon/tei:p">
                                    
                                    <hr class="hidden-print"/>
                                    
                                    <section id="colophon" class="indent text glossarize-section">
                                        <a href="#colophon" class="milestone" title="Bookmark this section">
                                            <xsl:value-of select="concat(m:translation/m:colophon/@prefix, '.')"/>
                                        </a>
                                        <h2>Colophon</h2>
                                        <xsl:apply-templates select="m:translation/m:colophon"/>
                                    </section>
                                </xsl:if>
                                
                                <xsl:if test="m:translation/m:appendix//tei:p">
                                    
                                    <hr class="hidden-print"/>
                                    
                                    <section id="appendix" class="page indent text glossarize-section">
                                        <a href="#appendix" class="milestone" title="Bookmark this section">
                                            <xsl:value-of select="concat(m:translation/m:appendix/@prefix, '.')"/>
                                        </a>
                                        <h3>Appendix</h3>
                                        <xsl:for-each select="m:translation/m:appendix/m:chapter">
                                            
                                            <div class="relative chapter">
                                                
                                                <xsl:attribute name="id" select="concat('appendix-chapter-', @chapter-index/string())"/>
                                                
                                                <a class="milestone" title="Bookmark this section">
                                                    <xsl:attribute name="href" select="concat('#appendix-chapter-', @chapter-index/string())"/>
                                                    <xsl:value-of select="concat(@prefix, '.')"/>
                                                </a>
                                                
                                                <h4>
                                                    <xsl:apply-templates select="m:title"/>
                                                </h4>
                                                
                                                <xsl:apply-templates select="tei:*"/>
                                                
                                            </div>
                                        </xsl:for-each>
                                    </section>
                                </xsl:if>
                                
                                <xsl:if test="m:translation/m:abbreviations/m:item">
                                    
                                    <hr class="hidden-print"/>
                                    
                                    <section id="abbreviations" class="page indent">
                                        <a href="#abbreviations" class="milestone" title="Bookmark this section">
                                            <xsl:value-of select="concat(m:translation/m:abbreviations/@prefix, '.')"/>
                                        </a>
                                        <h3>Abbreviations</h3>
                                        <xsl:if test="m:translation/m:abbreviations/m:head">
                                            <h5>
                                                <xsl:apply-templates select="m:translation/m:abbreviations/m:head/text()"/>
                                            </h5>
                                        </xsl:if>
                                        <dl>
                                            <xsl:for-each select="m:translation/m:abbreviations/m:item">
                                                <xsl:sort select="m:abbreviation/text()"/>
                                                <dt>
                                                    <xsl:apply-templates select="m:abbreviation/text()"/>
                                                </dt>
                                                <dd>
                                                    <xsl:apply-templates select="m:explanation/node()"/>
                                                </dd>
                                            </xsl:for-each>
                                        </dl>
                                        <xsl:if test="m:translation/m:abbreviations/m:foot">
                                            <p>
                                                <xsl:apply-templates select="m:translation/m:abbreviations/m:foot/text()"/>
                                            </p>
                                        </xsl:if>
                                    </section>
                                    
                                </xsl:if>
    
                                <hr class="hidden-print"/>
    
                                <section id="notes" class="page indent glossarize-section">
                                    <a href="#notes" class="milestone" title="Bookmark this section">
                                        <xsl:value-of select="concat(m:translation/m:notes/@prefix, '.')"/>
                                    </a>
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
                                                <xsl:apply-templates select="@index"/>
                                            </a>
                                            <xsl:apply-templates select="node()"/>
                                        </p>
                                    </xsl:for-each>
                                </section>
                                
                                <hr class="hidden-print"/>
                                
                                <section id="bibliography" class="page indent">
                                    <a href="#bibliography" class="milestone" title="Bookmark this section">
                                        <xsl:value-of select="concat(m:translation/m:bibliography/@prefix, '.')"/>
                                    </a>
                                    <h3>Bibliography</h3>
                                    <xsl:for-each select="m:translation/m:bibliography/m:section">
                                        <div>
                                            <h4>
                                                <xsl:apply-templates select="m:title/text()"/>
                                            </h4>
                                            <xsl:for-each select="m:item">
                                                <p class="bibl">
                                                    <xsl:apply-templates select="node()"/>
                                                </p>
                                            </xsl:for-each>
                                        </div>
                                    </xsl:for-each>
                                    
                                </section>
    
                                <hr class="hidden-print"/>
    
                                <section id="glossary" class="page indent glossarize-section">
                                    <a href="#glossary" class="milestone" title="Bookmark this section">
                                        <xsl:value-of select="concat(m:translation/m:glossary/@prefix, '.')"/>
                                    </a>
                                    <h3>Glossary</h3>
                                    <div class="">
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
                                                            <xsl:apply-templates select="m:term[lower-case(@xml:lang) = 'en']"/>
                                                        </h4>
                                                        
                                                        <xsl:if test="m:term[lower-case(@xml:lang) eq 'bo-ltn']">
                                                            <p class="text-wylie">
                                                                <xsl:value-of select="string-join(m:term[lower-case(@xml:lang) eq 'bo-ltn'], ' · ')"/>
                                                            </p>
                                                        </xsl:if>
                                                        
                                                        <xsl:if test="m:term[lower-case(@xml:lang) eq 'bo']">
                                                            <p class="text-bo">
                                                                <xsl:value-of select="string-join(m:term[lower-case(@xml:lang) eq 'bo'], ' ')"/>
                                                            </p>
                                                        </xsl:if>
                                                        
                                                        <xsl:if test="m:term[lower-case(@xml:lang) eq 'sa-ltn']">
                                                            <p class="text-sa">
                                                                <xsl:value-of select="string-join(m:term[lower-case(@xml:lang) eq 'sa-ltn'], ' · ')"/>
                                                            </p>
                                                        </xsl:if>
                                                        
                                                        <xsl:for-each select="m:alternatives/m:alternative">
                                                            <p class="term alternative">
                                                                <xsl:apply-templates select="text()"/>
                                                            </p>
                                                        </xsl:for-each>
                                                        
                                                        <xsl:for-each select="m:definitions/m:definition">
                                                            <p class="glossarize">
                                                                <xsl:apply-templates select="node()"/>
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
                                    </div>
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
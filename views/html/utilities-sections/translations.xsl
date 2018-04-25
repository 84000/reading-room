<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:m="http://read.84000.co/ns/1.0" version="2.0" exclude-result-prefixes="#all">
    
    <xsl:output method="html" indent="no" doctype-system="about:legacy-compat"/>
    
    <xsl:template name="translations">
        <p class="text-muted">
            This view lists files in the data/translations folder.
        </p>
        <table class="table table-responsive">
            <thead>
                <tr>
                    <th>Translation</th>
                    <th>Glossary</th>
                    <th>Path</th>
                    <th>ID</th>
                    <th>TEI</th>
                    <th>XML</th>
                    <th>JSON</th>
                    <th>HTML</th>
                    <th>PDF</th>
                    <th class="nowrap">E-PUB</th>
                    <th>Edit</th>
                </tr>
            </thead>
            <tbody>
                <xsl:for-each select="//m:translations/m:translation">
                    <xsl:sort select="@id"/>
                    <tr class="header">
                        <td colspan="11">
                            <xsl:value-of select="concat(m:toh/text(), ' / ', m:title/text())"/>  
                            <xsl:choose>
                                <xsl:when test="@status = 'not-started'">
                                    <div class="label label-default">Not Started</div>
                                </xsl:when>
                                <xsl:when test="@status = 'in-progress'">
                                    <div class="label label-warning">In progress</div>
                                </xsl:when>
                                <xsl:when test="@status = 'missing'">
                                    <div class="label label-danger">Missing</div>
                                </xsl:when>
                                <xsl:when test="@status = 'available'">
                                    <div class="label label-success">Translated</div>
                                </xsl:when>
                            </xsl:choose>
                        </td>
                    </tr>
                    <tr class="sub">
                        <td>
                            <xsl:value-of select="fn:format-number(xs:integer(@wordCount),'#,##0')"/> words
                        </td>
                        <td>
                            <xsl:value-of select="fn:format-number(xs:integer(@glossaryCount),'#,##0')"/> items
                        </td>
                        <td>translation/</td>
                        <td>
                            <xsl:value-of select="@id"/>
                        </td>
                        <td>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="concat('translation/', @id, '.tei')"/>
                                </xsl:attribute>
                                .tei
                            </a>
                        </td>
                        <td>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="concat('translation/', @id, '.xml')"/>
                                </xsl:attribute>
                                .xml
                            </a>
                        </td>
                        <td>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="concat('translation/', @id, '.json')"/>
                                </xsl:attribute>
                                .json
                            </a>
                        </td>
                        <td>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="concat('translation/', @id, '.html')"/>
                                </xsl:attribute>
                                .html
                            </a>
                        </td>
                        <td>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="concat('translation/', @id, '.pdf')"/>
                                </xsl:attribute>
                                .pdf
                            </a>
                        </td>
                        <td>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="concat('translation/', @id, '.epub')"/>
                                </xsl:attribute>
                                .epub
                            </a>
                        </td>
                        <td>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="concat('translation/', @id, '.edit')"/>
                                </xsl:attribute>
                                .edit
                            </a>
                        </td>
                    </tr>
                    <!-- 
                    <tr class="sub">
                        <td>
                            <xsl:value-of select="fn:format-number(xs:integer(@glossaryCount),'#,##0')"/>
                        </td>
                        <td>glossary/</td>
                        <td>
                            <xsl:value-of select="@id"/>
                        </td>
                        <td/>
                        <td>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="concat('glossary/', @id, '.xml')"/>
                                </xsl:attribute>
                                .xml
                            </a>
                        </td>
                        <td>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="concat('glossary/', @id, '.json')"/>
                                </xsl:attribute>
                                .json
                            </a>
                        </td>
                        <td>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="concat('glossary/', @id, '.html')"/>
                                </xsl:attribute>
                                .html
                            </a>
                        </td>
                        <td/>
                        <td/>
                        <td/>
                    </tr>
                     -->
                </xsl:for-each>
            </tbody>
            <tfoot>
                <tr>
                    <th>
                        <xsl:value-of select="fn:format-number(xs:integer(sum(//m:translations/m:translation/@wordCount)),'#,##0')"/> words
                    </th>
                    <th>
                        <xsl:value-of select="fn:format-number(xs:integer(sum(//m:translations/m:translation/@glossaryCount)),'#,##0')"/> glossary items
                    </th>
                    <td colspan="9"/>
                </tr>
            </tfoot>
        </table>
    </xsl:template>
</xsl:stylesheet>
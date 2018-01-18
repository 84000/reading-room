<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:m="http://read.84000.co/ns/1.0" version="2.0" exclude-result-prefixes="#all">
    
    <xsl:output method="html" indent="no" doctype-system="about:legacy-compat"/>
    
    <xsl:template name="sections">
        <p class="text-muted">
            This view lists nodes in the outline files.
        </p>
        <table class="table table-responsive">
            <thead>
                <tr>
                    <th>Section</th>
                    <th>Texts</th>
                    <th>Path</th>
                    <th>ID</th>
                    <th>XML</th>
                    <th>JSON</th>
                    <th>HTML</th>
                </tr>
            </thead>
            <tbody>
                <xsl:for-each select="//m:outline/m:section">
                    <tr>
                        <td>
                            <xsl:if test="not(@id = ('lobby', 'all-translated'))">
                                · 
                            </xsl:if>
                            <xsl:for-each select=".//m:parent">
                                · 
                            </xsl:for-each>
                            <xsl:value-of select="m:title/text()"/>
                        </td>
                        <td>
                            <xsl:value-of select="m:texts/@count-descendant-texts"/>
                        </td>
                        <td>section/</td>
                        <td>
                            <xsl:value-of select="@id"/>
                        </td>
                        <td>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="concat('section/', @id, '.xml')"/>
                                </xsl:attribute>
                                .xml
                            </a>
                        </td>
                        <td>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="concat('section/', @id, '.json')"/>
                                </xsl:attribute>
                                .json
                            </a>
                        </td>
                        <td>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="concat('section/', @id, '.html')"/>
                                </xsl:attribute>
                                .html
                            </a>
                        </td>
                    </tr>
                </xsl:for-each>
            </tbody>
        </table>
    </xsl:template>
</xsl:stylesheet>
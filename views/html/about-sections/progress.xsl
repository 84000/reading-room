<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:m="http://read.84000.co/ns/1.0" version="2.0" exclude-result-prefixes="#all">
    
    <xsl:output method="html" indent="no" doctype-system="about:legacy-compat"/>
    
    <xsl:template name="progress">
        
        <table class="table table-responsive">
            <thead>
                <tr>
                    <th>Tohoku</th>
                    <th>Title</th>
                    <th>Pages</th>
                </tr>
            </thead>
            <tbody>
                <xsl:for-each select="//m:progress/m:texts/m:text">
                    <tr>
                        <td class="nowrap">
                            <xsl:value-of select="m:toh/text()"/>
                        </td>
                        <td>
                            <xsl:choose>
                                <xsl:when test="m:status/@translation-id gt ''">
                                    <a>
                                        <xsl:attribute name="href" select="concat('/translation/', m:status/@translation-id, '.html')"/>
                                        <xsl:value-of select="m:title/text()"/>
                                    </a>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="m:title/text()"/>
                                </xsl:otherwise>
                            </xsl:choose>
                            
                        </td>
                        <td class="nowrap">
                            <xsl:value-of select="format-number(m:location/@count-pages, '#,###')"/>
                        </td>
                    </tr>
                </xsl:for-each>
            </tbody>
            <tfoot>
                <tr>
                    <td colspan="2" class="text-right">
                        Total:
                    </td>
                    <td>
                        <strong>
                            <xsl:value-of select="format-number(sum(//m:progress/m:texts/@count-pages), '#,###')"/>
                        </strong>
                    </td>
                </tr>
            </tfoot>
        </table>
        
    </xsl:template>
    
    
</xsl:stylesheet>
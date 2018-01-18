<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:m="http://read.84000.co/ns/1.0" version="2.0" exclude-result-prefixes="#all">
    
    <xsl:output method="html" indent="no" doctype-system="about:legacy-compat"/>
    
    <xsl:template name="client-errors">
        <p>
            This view lists client errors i.e. urls that were requested that returned an error to the client.
        </p>
        <table class="table table-responsive">
            <thead>
                <tr>
                    <th>Url</th>
                    <th>Count</th>
                    <th>Last requested</th>
                    <th>First requested</th>
                </tr>
            </thead>
            <tbody>
                <xsl:for-each select="//error">
                    <tr>
                        <td class="wrap">
                            <xsl:value-of select="text()"/>
                        </td>
                        <td class="nowrap">
                            <xsl:value-of select="@count"/>
                        </td>
                        <td class="nowrap">
                            <xsl:value-of select="@latest"/>
                        </td>
                        <td class="nowrap">
                            <xsl:value-of select="@first"/>
                        </td>
                    </tr>
                </xsl:for-each>
            </tbody>
        </table>
    </xsl:template>
</xsl:stylesheet>
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:m="http://read.84000.co/ns/1.0" version="2.0" exclude-result-prefixes="#all">
    
    <xsl:output method="html" indent="no" doctype-system="about:legacy-compat"/>
    
    <xsl:template name="sponsors">
        
        <table class="table table-responsive" id="sponsors-table">
            <thead>
                <tr>
                    <th>Sponsor</th>
                    <th>Pledges</th>
                </tr>
            </thead>
            <tbody>
                <xsl:for-each select="m:sponsors/m:sponsor">
                    <xsl:sort select="xs:integer(@id)"/>
                    <xsl:variable name="sponsor-id" select="@id"/>
                    <tr class="header">
                        <td colspan="2">
                            <xsl:value-of select="concat(m:name, ', ', m:country)"/>
                        </td>
                    </tr>
                    <tr class="sub">
                        <td>
                            <ul class="list-unstyled">
                                <xsl:for-each select="m:phone[normalize-space(text())]">
                                    <li>
                                        <i class="fa fa-phone"/> 
                                        <xsl:value-of select="normalize-space(text())"/>
                                    </li>
                                </xsl:for-each>
                                <xsl:for-each select="m:email">
                                    <li>
                                        <i class="fa fa-envelope"/> 
                                        <xsl:choose>
                                            <xsl:when test="m:name">
                                                <xsl:value-of select="m:name"/>, 
                                                <a href="mailto:{ text() }">
                                                    <xsl:value-of select="text()"/>
                                                </a>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <a href="mailto:{ text() }">
                                                    <xsl:value-of select="text()"/>
                                                </a>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </li>
                                </xsl:for-each>
                                <xsl:for-each select="m:address[normalize-space(text())]">
                                    <li class="adjacent-panels">
                                        <i class="fa fa-map-marker"/> 
                                        <xsl:value-of select="normalize-space(text())"/>
                                    </li>
                                </xsl:for-each>
                            </ul>
                        </td>
                        <td class="nowrap">
                            <xsl:for-each select="//m:sponsors/m:sutra[m:pledge[@id = //m:sponsors/m:pledge[@sponsor-id eq $sponsor-id]/@id]]">
                                <xsl:sort select="m:pledge[@id = //m:sponsors/m:pledge[@sponsor-id eq $sponsor-id]/@id]/@id"/>
                                <xsl:variable name="pledge-id" select="m:pledge[@id = //m:sponsors/m:pledge[@sponsor-id eq $sponsor-id]/@id]/@id"/>
                                <xsl:variable name="pledge" select="//m:sponsors/m:pledge[@id eq $pledge-id]"/>
                                
                                <div class="row">
                                    <div class="col-sm-2">
                                        <xsl:value-of select="$pledge-id"/>
                                    </div>
                                    <div class="col-sm-3">
                                        <xsl:copy-of select="format-date($pledge/m:pledged-date, '[D] [MNn,*-3] [Y0001]', 'en', (), ())"/>
                                    </div>
                                    <div class="col-sm-3">
                                        <xsl:variable name="toh">
                                            Toh <xsl:value-of select="@toh"/> 
                                            <xsl:if test="@chapter">
                                                (<xsl:value-of select="@chapter"/>)
                                            </xsl:if>
                                        </xsl:variable>
                                        <xsl:value-of select="normalize-space($toh)"/>
                                    </div>
                                    <div class="col-sm-4">
                                        <xsl:choose>
                                            <xsl:when test="@sponsored eq 'full'">
                                                <div class="label label-success">
                                                    Fully sponsored
                                                </div>
                                            </xsl:when>
                                            <xsl:when test="@sponsored eq 'part'">
                                                <div class="label label-warning">
                                                    Part sponsored
                                                </div>
                                            </xsl:when>
                                        </xsl:choose>
                                    </div>
                                </div>
                            </xsl:for-each>
                            
                        </td>
                    </tr>
                </xsl:for-each>
            </tbody>
            <tfoot>
                <tr>
                    <th>
                        <xsl:value-of select="fn:format-number(xs:integer(count(m:sponsors/m:sponsor)),'#,##0')"/> sponsors
                    </th>
                    <th>
                        <xsl:value-of select="fn:format-number(xs:integer(count(m:sponsors/m:pledge)),'#,##0')"/> pledges
                    </th>
                </tr>
            </tfoot>
        </table>
    </xsl:template>
</xsl:stylesheet>
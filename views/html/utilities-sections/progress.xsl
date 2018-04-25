<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:m="http://read.84000.co/ns/1.0" version="2.0" exclude-result-prefixes="#all">
    
    <xsl:output method="html" indent="no" doctype-system="about:legacy-compat"/>
    
    <xsl:template name="progress">
        <div class="row">
            <div class="col-sm-9">
                <div class="well">
                    <div class="row">
                        <div class="col-sm-4">
                            <div style="width:260px;height:260px;">
                                <canvas id="progress-pie"/>
                                <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.6.0/Chart.min.js"/>
                                <script>
                                    var ctx = document.getElementById("progress-pie").getContext('2d');
                                    var data = {
                                        datasets: [{
                                             data: [
                                                 <xsl:value-of select="//m:progress/m:summary/m:pages/@published"/>, 
                                                 <xsl:value-of select="//m:progress/m:summary/m:pages/@in-progress"/>, 
                                                 <xsl:value-of select="//m:progress/m:summary/m:pages/@not-started"/>
                                             ],
                                                 backgroundColor: ['#4d6253','#b76c1e','#bbbbbb']
                                             }],
                                        labels: ['Published','In-progress','Not-started']
                                    };
                                    var options = {
                                      legend: {
                                          display: false,
                                          position: 'right'
                                      }
                                    };
                                    var myPieChart = new Chart(ctx,{
                                        type: 'pie',
                                        data: data,
                                        options: options
                                    });
                                </script>
                            </div>
                        </div>
                        <div class="col-sm-7">
                            <table class="table progress">
                                <tbody>
                                    <xsl:variable name="total-pages" select="//m:progress/m:summary/m:pages/@count"/>
                                    <tr class="total">
                                        <td>Total</td>
                                        <td>
                                            <xsl:value-of select="format-number($total-pages, '#,###')"/> pages
                                        </td>
                                        <td> - </td>
                                        <td>
                                            <xsl:value-of select="format-number(//m:progress/m:summary/m:texts/@count, '#,###')"/> texts
                                        </td>
                                    </tr>
                                    
                                    <xsl:variable name="published-pages" select="//m:progress/m:summary/m:pages/@published"/>
                                    <tr class="translated">
                                        <td>Published</td>
                                        <td>
                                            <xsl:value-of select="format-number($published-pages, '#,###')"/> pages
                                        </td>
                                        <td>
                                            <xsl:value-of select="format-number(($published-pages div $total-pages) * 100, '###,##0')"/>%
                                        </td>
                                        <td>
                                            <xsl:value-of select="format-number(//m:progress/m:summary/m:texts/@published, '#,###')"/> texts
                                        </td>
                                    </tr>
                                    <xsl:variable name="in-progress-pages" select="//m:progress/m:summary/m:pages/@in-progress"/>
                                    <tr class="in-progress">
                                        <td>In-progress</td>
                                        <td>
                                            <xsl:value-of select="format-number($in-progress-pages, '#,###')"/> pages
                                        </td>
                                        <td>
                                            <xsl:value-of select="format-number(($in-progress-pages div $total-pages) * 100, '###,##0')"/>%
                                        </td>
                                        <td>
                                            <xsl:value-of select="format-number(//m:progress/m:summary/m:texts/@in-progress, '#,###')"/> texts
                                        </td>
                                    </tr>
                                    <xsl:variable name="sponsored-pages" select="//m:progress/m:summary/m:pages/@sponsored"/>
                                    <tr class="sponsored">
                                        <td>Sponsored</td>
                                        <td>
                                            <xsl:value-of select="format-number($sponsored-pages, '#,###')"/> pages
                                        </td>
                                        <td>
                                            <xsl:value-of select="format-number(($sponsored-pages div $total-pages) * 100, '###,##0')"/>%
                                        </td>
                                        <td>
                                            <xsl:value-of select="format-number(//m:progress/m:summary/m:texts/@sponsored, '#,###')"/> texts
                                        </td>
                                    </tr>
                                    <xsl:variable name="commissioned-pages" select="//m:progress/m:summary/m:pages/@commissioned"/>
                                    <tr class="commissioned">
                                        <td>Commissioned</td>
                                        <td>
                                            <xsl:value-of select="format-number($commissioned-pages, '#,###')"/> pages
                                        </td>
                                        <td>
                                            <xsl:value-of select="format-number(($commissioned-pages div $total-pages) * 100, '###,##0')"/>%
                                        </td>
                                        <td>
                                            <xsl:value-of select="format-number(//m:progress/m:summary/m:texts/@commissioned, '#,###')"/> texts
                                        </td>
                                    </tr>
                                    <xsl:variable name="not-started-pages" select="//m:progress/m:summary/m:pages/@not-started"/>
                                    <tr class="not-started">
                                        <td>Not-started</td>
                                        <td>
                                            <xsl:value-of select="format-number($not-started-pages, '#,###')"/> pages
                                        </td>
                                        <td>
                                            <xsl:value-of select="format-number(($not-started-pages div $total-pages) * 100, '###,##0')"/>%
                                        </td>
                                        <td>
                                            <xsl:value-of select="format-number(//m:progress/m:summary/m:texts/@not-started, '#,###')"/> texts
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-sm-3">
                <form action="operations.html" method="post">
                    <input type="hidden" name="tab" value="progress"/>
                    <div class="form-group">
                        <select class="form-control" disabled="disabled">
                            <option value="kangyur">Kangyur</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <select name="status" class="form-control">
                            <option value="">
                                No progress filter
                            </option>
                            <option value="published">
                                <xsl:if test="//m:progress/m:texts/@status eq 'published'">
                                    <xsl:attribute name="selected" select="'selected'"/>
                                </xsl:if>
                                Published texts
                            </option>
                            <option value="in-progress">
                                <xsl:if test="//m:progress/m:texts/@status eq 'in-progress'">
                                    <xsl:attribute name="selected" select="'selected'"/>
                                </xsl:if>
                                Texts in progress
                            </option>
                            <option value="not-started">
                                <xsl:if test="//m:progress/m:texts/@status eq 'not-started'">
                                    <xsl:attribute name="selected" select="'selected'"/>
                                </xsl:if>
                                Texts not started
                            </option>
                        </select>
                    </div>
                    <div class="form-group">
                        <select name="filter" class="form-control">
                            <option value="none">
                                <xsl:if test="//m:progress/m:texts/@filter eq 'none'">
                                    <xsl:attribute name="selected" select="'selected'"/>
                                </xsl:if>
                                No sponsor filter
                            </option>
                            <option value="sponsored">
                                <xsl:if test="//m:progress/m:texts/@filter eq 'sponsored'">
                                    <xsl:attribute name="selected" select="'selected'"/>
                                </xsl:if>
                                Sponsored texts
                            </option>
                            <option value="part-sponsored">
                                <xsl:if test="//m:progress/m:texts/@filter eq 'part-sponsored'">
                                    <xsl:attribute name="selected" select="'selected'"/>
                                </xsl:if>
                                Part sponsored texts
                            </option>
                            <option value="not-sponsored">
                                <xsl:if test="//m:progress/m:texts/@filter eq 'not-sponsored'">
                                    <xsl:attribute name="selected" select="'selected'"/>
                                </xsl:if>
                                Not sponsored texts
                            </option>
                        </select>
                    </div>
                    <div class="form-group">
                        <select name="range" class="form-control">
                            <option value="0">
                                No size filter
                            </option>
                            <xsl:for-each select="//m:page-size-ranges/m:range">
                                <option>
                                    <xsl:attribute name="value" select="@id"/>
                                    <xsl:if test="//m:progress/m:texts/@range eq xs:string(@id)">
                                        <xsl:attribute name="selected" select="'selected'"/>
                                    </xsl:if>
                                    <xsl:value-of select="concat(@min, ' to ', format-number(@max, '#,###'), ' pages')"/>
                                </option>
                            </xsl:for-each>
                        </select>
                    </div>
                    <div class="form-group">
                        <select name="sort" class="form-control">
                            <option value="toh">
                                <xsl:if test="//m:progress/m:texts/@sort eq 'toh'">
                                    <xsl:attribute name="selected" select="'selected'"/>
                                </xsl:if>
                                Sort by Tohoku
                            </option>
                            <option value="longest">
                                <xsl:if test="//m:progress/m:texts/@sort eq 'longest'">
                                    <xsl:attribute name="selected" select="'selected'"/>
                                </xsl:if>
                                Longest first
                            </option>
                            <option value="shortest">
                                <xsl:if test="//m:progress/m:texts/@sort eq 'shortest'">
                                    <xsl:attribute name="selected" select="'selected'"/>
                                </xsl:if>
                                Shortest first
                            </option>
                        </select>
                    </div>
                    <input type="submit" value="Apply" class="btn btn-primary"/>
                </form>
            </div>
        </div>
        <table class="table table-responsive">
            <thead>
                <tr>
                    <th>Tohoku</th>
                    <th>Title</th>
                    <th>Pages</th>
                    <th>Start</th>
                    <th>End</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <xsl:for-each select="//m:progress/m:texts/m:text">
                    <tr>
                        <td class="nowrap">
                            <xsl:value-of select="m:toh/text()"/>
                        </td>
                        <td>
                            <xsl:value-of select="m:title/text()"/>
                        </td>
                        <td class="nowrap">
                            <xsl:value-of select="format-number(m:location/@count-pages, '#,###')"/>
                        </td>
                        <td class="nowrap">
                            vol. <xsl:value-of select="m:location/m:start/@volume"/>,
                            p. <xsl:value-of select="m:location/m:start/@page"/>
                        </td>
                        <td class="nowrap">
                            vol. <xsl:value-of select="m:location/m:end/@volume"/>,
                            p. <xsl:value-of select="m:location/m:end/@page"/>
                        </td>
                        <td>
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
                                <xsl:when test="m:status = 'available'">
                                    <div class="label label-success">
                                        Published
                                    </div>
                                </xsl:when>
                                <xsl:when test="m:status = 'missing'">
                                    <div class="label label-danger">
                                        Missing
                                    </div>
                                </xsl:when>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="m:sponsored/text() eq 'full'">
                                    <br/>
                                    <div class="label label-info">
                                        Fully sponsored
                                    </div>
                                </xsl:when>
                                <xsl:when test="m:sponsored/text() eq 'part'">
                                    <br/>
                                    <div class="label label-info">
                                        Part sponsored
                                    </div>
                                </xsl:when>
                            </xsl:choose>
                        </td>
                    </tr>
                </xsl:for-each>
            </tbody>
            <tfoot>
                <tr>
                    <td colspan="2"/>
                    <td colspan="4">
                        <strong>
                            <xsl:value-of select="format-number(sum(//m:progress/m:texts/@count-pages), '#,###')"/>
                        </strong> pages*, 
                        <strong>
                            <xsl:value-of select="format-number(count(//m:progress/m:texts/m:text), '#,###')"/>
                        </strong> texts. 
                        *<small>based on the Kangyur outline file</small>
                    </td>
                </tr>
            </tfoot>
        </table>
    </xsl:template>
</xsl:stylesheet>
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:m="http://read.84000.co/ns/1.0" version="2.0" exclude-result-prefixes="#all">
    <!-- Include sections -->
    <xsl:include href="about-sections/progress.xsl"/>
    <xsl:include href="website-page.xsl"/>
    <!-- Output type -->
    <xsl:output method="html" indent="no" doctype-system="about:legacy-compat"/>
    <!-- Template -->
    <xsl:template match="/m:response">
        <!-- Content variable -->
        <xsl:variable name="content">
            <div class="container">
                <div class="row">
                    <div class="col-md-9 col-md-merge-right">
                        <div class="panel panel-default main-panel foreground">
                            
                            <div class="panel-img-header thumbnail">
                                <img>
                                    <xsl:attribute name="src" select="m:header/m:img/text()"/>
                                </img>
                                <h1 class="bg-red">
                                    <xsl:value-of select="m:header/m:title/text()"/>
                                </h1>
                            </div>
                            
                            <div class="panel-body">
                                
                                <blockquote>
                                    <xsl:value-of select="m:header/m:quote/m:text/text()"/>
                                    <footer>
                                        <xsl:value-of select="m:header/m:quote/m:author/text()"/>
                                    </footer>
                                </blockquote>
                                
                                <div class="row">
                                    <div class="col-md-8">
                                        <xsl:variable name="total-pages" select="//m:progress/m:summary/m:pages/@count"/>
                                        <xsl:variable name="published-pages" select="//m:progress/m:summary/m:pages/@published"/>
                                        <xsl:variable name="commissioned-pages" select="//m:progress/m:summary/m:pages/@commissioned"/>
                                        <div id="progress-stats">
                                            <div>
                                                <div class="heading">Translations Commissioned:</div>
                                                <div class="data">
                                                    <span>
                                                        <xsl:value-of select="format-number($commissioned-pages, '#,###')"/>
                                                    </span> pages, 
                                                    <span>
                                                        <xsl:value-of select="format-number(//m:progress/m:summary/m:texts/@commissioned, '#,###')"/>
                                                    </span> texts, 
                                                    <span>
                                                        <xsl:value-of select="format-number(($commissioned-pages div $total-pages) * 100, '###,##0')"/>%</span> of the Kangyur.
                                                </div>
                                            </div>
                                            <div>
                                                <div class="heading">Translations Completed:</div>
                                                <div class="data">
                                                    <span>8,056</span> pages, 
                                                    <span>99</span> texts, 
                                                    <span>24%</span> of the Kangyur.
                                                </div>
                                            </div>
                                            <div>
                                                <div class="heading">Translations Published:</div>
                                                <div class="data">
                                                    <span>
                                                        <xsl:value-of select="format-number($published-pages, '#,###')"/>
                                                    </span> pages, 
                                                    <span>
                                                        <xsl:value-of select="format-number(m:progress/m:summary/m:texts/@published, '#,###')"/>
                                                    </span> texts, 
                                                    <span>
                                                        <xsl:value-of select="format-number(($published-pages div $total-pages) * 100, '###,##0')"/>%</span> of the Kangyur.
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
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
                                </div>
                                
                                
                                <ul class="nav nav-tabs" role="tablist" id="progress-tabs">
                                    <xsl:for-each select="m:tabs/m:tab">
                                        <li role="presentation">
                                            <xsl:if test="@active eq '1'">
                                                <xsl:attribute name="class" select="'active'"/>
                                            </xsl:if>
                                            <a>
                                                <xsl:attribute name="href" select="concat('?tab=', @id, '#progress-tabs')"/>
                                                <xsl:value-of select="text()"/>
                                            </a>
                                        </li>
                                    </xsl:for-each>
                                </ul>
                                
                                <div class="tab-content">
                                    <!-- Progress -->
                                    <xsl:if test="m:tabs/m:tab[@id = ('published', 'in-progress')][@active eq '1']">
                                        <xsl:call-template name="progress"/>
                                    </xsl:if>
                                </div>
                                
                            </div>
                            <!-- Social sharing -->
                            <div class="panel-footer sharing"> Share this page: 
                                <a href="#" target="_blank">
                                    <i class="fa fa-facebook-square" aria-hidden="true"/>
                                </a>
                                <a href="#" target="_blank">
                                    <i class="fa fa-twitter-square" aria-hidden="true"/>
                                </a>
                                <a href="#" target="_blank">
                                    <i class="fa fa-google-plus-square" aria-hidden="true"/>
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-md-merge-left col-md-pad-top">
                        <!-- Summary -->
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h3 class="panel-title">Join Us</h3>
                            </div>
                            <div class="panel-body">
                                <p>With the help of our 108 <a href="http://84000.co/about/sponsors/">founding sponsors</a> and thousands of individual donors,
                                    we provide funding to the translators who are working to safeguard these important teachings
                                    for future generations.</p>
                                <xsl:variable name="pages-count" select="m:progress/m:summary/m:pages/@count"/>
                                <xsl:variable name="pages-sponsored" select="m:progress/m:summary/m:pages/@sponsored"/>
                                <table id="translation-stats">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <xsl:value-of select="format-number($pages-count, '#,###')"/>
                                            </td>
                                            <th>Kangyur pages to be translated</th>
                                        </tr>
                                        <tr>
                                            <td>
                                                <xsl:value-of select="format-number($pages-sponsored, '#,###')"/>
                                            </td>
                                            <th>Pages have been sponsored</th>
                                        </tr>
                                        <tr>
                                            <td>
                                                <xsl:value-of select="format-number($pages-count - $pages-sponsored, '#,###')"/>
                                            </td>
                                            <th>Pages to go</th>
                                        </tr>
                                    </tbody>
                                </table>
                                <div class="text-center">
                                    <a href="http://84000.co/page-onetime" class="btn btn-primary">Sponsor a page now</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </xsl:variable>
        <xsl:call-template name="website-page">
            <xsl:with-param name="app-id" select="@app-id"/>
            <xsl:with-param name="page-url" select="concat('http://read.84000.co/about/', /m:response/@page-id, '.html')"/>
            <xsl:with-param name="page-type" select="'communications'"/>
            <xsl:with-param name="page-title" select="m:header/m:title/text()"/>
            <xsl:with-param name="page-description" select="''"/>
            <xsl:with-param name="content" select="$content"/>
            <xsl:with-param name="nav-tab" select="'about'"/>
        </xsl:call-template>
    </xsl:template>
</xsl:stylesheet>
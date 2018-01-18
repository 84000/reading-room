<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:m="http://read.84000.co/ns/1.0" version="2.0" exclude-result-prefixes="#all">
    
    <xsl:output method="html" indent="no" doctype-system="about:legacy-compat"/>
    
    <xsl:template name="snapshot">
        <p class="text-muted text-center">
            This function makes a snapshot of the selected resource(s) and pushes it to the public 
            <a target="_blank">
                <xsl:attribute name="href" select="//m:view-repo-url/text()"/>
                GitHub repository</a>.
        </p>
        <hr/>
        <form action="/utilities.html" method="post" class="form-horizontal">
            
            <input type="hidden" name="tab" value="snapshot"/>
            <input type="hidden" name="action" value="sync"/>
            
            <div class="form-group">
                <label for="resource" class="col-sm-2 control-label">
                    Resources
                </label>
                <div class="col-sm-10 col-md-6">
                    <select name="resource" id="resource" class="form-control">
                        <option value="all">All data (translations, schemas and outlines)</option>
                        <xsl:for-each select="//m:translations/m:translation">
                            <xsl:sort select="@fileName"/>
                            <option>
                                <xsl:attribute name="value" select="@fileName"/>
                                <xsl:value-of select="@fileName"/>
                            </option>
                        </xsl:for-each>
                    </select>
                </div>
            </div>
            
            <div class="form-group">
                <label for="message" class="col-sm-2 control-label">
                    Commit message
                </label>
                <div class="col-sm-10">
                    <input type="text" name="message" id="message" value="" maxlength="100" class="form-control" placeholder="e.g. Toh X updates Jan 2018"/>
                </div>
            </div>
            
            <div class="form-group">
                <div class="col-sm-10 col-sm-offset-2">
                    <button type="submit" class="btn btn-warning">Make a snapshot</button>
                </div>
            </div>
            
        </form>
        
        <xsl:if test="//m:execute">
            <div class="well well-sm">
                <code>
                    <xsl:for-each select="//m:execute">
                        $ <xsl:value-of select="execution/commandline/text()"/>
                        <br/>
                        <xsl:for-each select="execution/stdout/line">
                            $ <xsl:value-of select="text()"/>
                            <br/>
                        </xsl:for-each>
                        <xsl:if test="not(position() = last())">
                            <hr/>
                        </xsl:if>
                    </xsl:for-each>
                </code>
            </div>
        </xsl:if>
        
    </xsl:template>
</xsl:stylesheet>
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" exclude-result-prefixes="#all">
    
    <!-- 
        Resolves internal references within the tei file
    -->
    
    <xsl:template match="ptr[@target]">
        
    </xsl:template>
    
    <xsl:template match="/">
        <xsl:copy-of select="*"/>
    </xsl:template>
    
</xsl:stylesheet>
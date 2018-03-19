<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:m="http://read.84000.co/ns/1.0" version="2.0" exclude-result-prefixes="#all">
    
    <xsl:output method="html" indent="no" doctype-system="about:legacy-compat"/>
    
    <xsl:template name="tests">
        <ul>
            <li>
                <a href="/validate.html">TEI Validation</a>
                <p class="text-muted small">
                    This page validates each TEI file against the XML Schema to flag issues.
                </p>
            </li>
            <li>
                <a href="/tests.html">Automated Tests</a>
                <p class="text-muted small">
                    This page runs automated tests on the reading room app and shows the results.
                    <br/>All texts should pass all tests before a new version is relased.
                    <br/>
                    <span class="text-danger">Please load this page sparingly as it uses lots of server resources.</span>
                </p>
            </li>
            <li>
                <a href="http://resources.84000-translate.org" target="resources">84000 Resources</a>
                <p class="text-muted small">
                    Check the resources browser.
                </p>
            </li>
            <li>
                <a href="/invalid-route.html" target="server-error">Server Error Page</a>
                <p class="text-muted small">
                    This is the page returned by a server error.
                </p>
            </li>
            <li>
                <a href="/translation/invalid-translation.html" target="exist-error">eXist Error Page</a>
                <p class="text-muted small">
                    This is the page returned by an eXist-db exception.
                </p>
            </li>
        </ul>
    </xsl:template>
</xsl:stylesheet>
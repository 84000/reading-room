xquery version "3.0";

declare namespace m = "http://read.84000.co/ns/1.0";

import module namespace common = "http://read.84000.co/common" at "../../modules/common.xql";
import module namespace translation = "http://read.84000.co/translation" at "../../modules/translation.xql";

(:

import module namespace xmldb = "http://exist-db.org/xquery/xmldb";
let $epub-path := concat(common:data-path(), '/epub')
let $create-collection := xmldb:create-collection($epub-path, $translation-id)
let $output := transform:transform(
        $data, 
        doc("summary.xsl"), 
        ()
     )
:)

let $data := request:get-data()
let $translation-id := $data//m:translation/@id
let $translation-title := $data//m:translation/m:titles/m:title[@xml:lang eq 'en']
let $epub-id := concat('http://read.84000.co/translation', $translation-id, '.epub')

let $parameters := 
        <parameters>
            <param name="epub-id" value="{ $epub-id }"/>
        </parameters>

let $entries := (
    <entry name="mimetype" type="text" method="store">application/epub+zip</entry>,
    <entry name="META-INF/container.xml" type="xml">
        <container xmlns="urn:oasis:names:tc:opendocument:xmlns:container" version="1.0">
            <rootfiles>
                <rootfile full-path="OEBPS/content.opf" media-type="application/oebps-package+xml"/>
            </rootfiles>
        </container>
    </entry>,
    <entry name="OEBPS/content.opf" type="xml">
        <package xmlns="http://www.idpf.org/2007/opf" version="3.0" xml:lang="en" unique-identifier="bookid">
            <metadata xmlns:dc="http://purl.org/dc/elements/1.1/">
                <dc:title id="dc-title">{ $translation-title }</dc:title>
                <dc:creator id="dc-creator">84000 - Translating the Words of the Buddha</dc:creator>
                <dc:identifier id="bookid">{$epub-id}</dc:identifier>
                <dc:language>en-GB</dc:language>
                <dc:date>2017-11-06T12:00:00Z</dc:date><!-- We need a published date! -->
                <dc:publisher>84000 - Translating the Words of the Buddha</dc:publisher>
                <meta refines="#dc-title" property="title-type">main</meta>
                <meta refines="#dc-title" property="file-as">{ translation:title-listing($translation-title) }</meta>
                <meta property="dcterms:modified">{ current-dateTime() }</meta><!-- Published now? -->
            </metadata>
            <manifest>
                <item id="manualStyles" href="css/manualStyles.css" media-type="text/css"/>
                <item id="fontStyles" href="css/fontStyles.css" media-type="text/css"/>
                <item id="logo" href="image/logo-stacked.png" media-type="image/png"/>
                <item id="creative-commons-logo" href="image/CC_logo.png" media-type="image/png"/>
                <item id="tibetan-font" href="fonts/DDC_Uchen.ttf" media-type="application/vnd.ms-opentype"/>
                <item id="half-title" href="half-title.xhtml" media-type="application/xhtml+xml"/>
                <item id="full-title" href="full-title.xhtml" media-type="application/xhtml+xml"/>
                <item id="imprint" href="imprint.xhtml" media-type="application/xhtml+xml"/>
                <item id="contents" href="contents.xhtml" media-type="application/xhtml+xml" properties="nav"/>
                <item id="summary" href="summary.xhtml" media-type="application/xhtml+xml"/>
                <item id="acknowledgements" href="acknowledgements.xhtml" media-type="application/xhtml+xml"/>
                <item id="introduction" href="introduction.xhtml" media-type="application/xhtml+xml"/>
                <item id="body" href="body.xhtml" media-type="application/xhtml+xml"/>
                <item id="bibliography" href="bibliography.xhtml" media-type="application/xhtml+xml"/>
                <item id="glossary" href="glossary.xhtml" media-type="application/xhtml+xml"/>
                <item id="toc" href="toc.ncx" media-type="application/x-dtbncx+xml"/>
            </manifest>
            <spine toc="toc">
                <itemref idref="half-title"/>
                <itemref idref="full-title"/>
                <itemref idref="imprint"/>
                <itemref idref="contents"/>
                <itemref idref="summary"/>
                <itemref idref="acknowledgements"/>
                <itemref idref="introduction"/>
                <itemref idref="body"/>
                <itemref idref="bibliography"/>
                <itemref idref="glossary"/>
            </spine>
        </package>
    </entry>,
    <entry name="OEBPS/css/manualStyles.css" type="binary">{ common:epub-resource('css/manualStyles.css') }</entry>,
    <entry name="OEBPS/css/fontStyles.css" type="binary">{ common:epub-resource('css/fontStyles.css') }</entry>,
    <entry name="OEBPS/image/logo-stacked.png" type="binary">{ common:epub-resource('image/logo-stacked.png') }</entry>,
    <entry name="OEBPS/image/CC_logo.png" type="binary">{ common:epub-resource('image/CC_logo.png') }</entry>,
    <entry name="OEBPS/fonts/DDC_Uchen.ttf" type="binary">{ common:epub-resource('fonts/DDC_Uchen.ttf') }</entry>,
    <entry name="OEBPS/half-title.xhtml" type="xml">{transform:transform($data, doc("xslt/half-title.xsl"), ())}</entry>,
    <entry name="OEBPS/full-title.xhtml" type="xml">{transform:transform($data, doc("xslt/full-title.xsl"), ())}</entry>,
    <entry name="OEBPS/imprint.xhtml" type="xml">{transform:transform($data, doc("xslt/imprint.xsl"), ())}</entry>,
    <entry name="OEBPS/contents.xhtml" type="xml">{transform:transform($data, doc("xslt/contents.xsl"), ())}</entry>,
    <entry name="OEBPS/summary.xhtml" type="xml">{transform:transform($data, doc("xslt/summary.xsl"), ())}</entry>,
    <entry name="OEBPS/acknowledgements.xhtml" type="xml">{transform:transform($data, doc("xslt/acknowledgements.xsl"), ())}</entry>,
    <entry name="OEBPS/introduction.xhtml" type="xml">{transform:transform($data, doc("xslt/introduction.xsl"), ())}</entry>,
    <entry name="OEBPS/body.xhtml" type="xml">{transform:transform($data, doc("xslt/body.xsl"), ())}</entry>,
    <entry name="OEBPS/bibliography.xhtml" type="xml">{transform:transform($data, doc("xslt/bibliography.xsl"), ())}</entry>,
    <entry name="OEBPS/glossary.xhtml" type="xml">{transform:transform($data, doc("xslt/glossary.xsl"), ())}</entry>,
    <entry name="OEBPS/toc.ncx" type="xml">{transform:transform(transform:transform($data, doc("xslt/toc.xsl"), $parameters), doc("xslt/play-order.xsl"), ())}</entry>
)
let $zip := compression:zip($entries, true())
return
    response:stream-binary($zip, 'application/epub+zip')


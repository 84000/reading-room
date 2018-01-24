xquery version "3.0" encoding "UTF-8";
(:
    Accepts the resource-id parameter
    Returns the translation xml
    -------------------------------------------------------------
    This does most of the processing of the TEI into a simple xml
    format. This should then be transformed into json/html/pdf/epub
    or other formats.
:)

import module namespace common="http://read.84000.co/common" at "../modules/common.xql";
import module namespace translation="http://read.84000.co/translation" at "../modules/translation.xql";
import module namespace text="http://read.84000.co/outline-text" at "../modules/outline-text.xql";
import module namespace section="http://read.84000.co/outline-section" at "../modules/outline-section.xql";
import module namespace glossary="http://read.84000.co/glossary" at "../modules/glossary.xql";

declare option exist:serialize "method=xml indent=no";

let $resource-id := request:get-parameter('resource-id', '')
let $doc-type := 
    if (request:get-parameter('resource-suffix', '') eq 'epub') then
        'epub'
    else
        'www'

let $translation := translation:tei($resource-id)
let $translation-id := translation:id($translation)
let $outlines := collection(common:outlines-path())
let $outline-text := text:translation($translation-id, $outlines)
let $view-mode := request:get-parameter('view-mode', '')

return
    <response 
        xmlns="http://read.84000.co/ns/1.0" 
        model-type="translation"
        timestamp="{ current-dateTime() }"
        doc-type="{ $doc-type }"
        view-mode="{ $view-mode }"
        app-id="{ common:app-id() }"
        user-name="{ common:user-name() }" >
            <translation 
                xmlns="http://read.84000.co/ns/1.0" 
                id="{ $translation-id }"
                status="{ text:status-str(text:translation($translation-id, $outlines)) }">
                { section:ancestors($outline-text, 1) }
                { translation:titles($translation) }
                { translation:long-titles($translation) }
                { translation:source($translation) }
                { translation:translation($translation) }
                { translation:downloads($translation-id) }
                { translation:summary($translation) } 
                { translation:acknowledgment($translation) }
                { translation:introduction($translation) }
                { translation:prologue($translation) }
                { translation:body($translation) }
                { translation:colophon($translation) }
                { translation:appendix($translation) }
                { translation:abbreviations($translation) }
                { translation:notes($translation) }
                { translation:bibliography($translation) }
                { translation:glossary($translation) }
                {(::)()}
            </translation>
    </response>
    
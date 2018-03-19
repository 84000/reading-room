xquery version "3.0" encoding "UTF-8";
(:
    Accepts a folio string parameter
    Returns the source tibetan for that folio
    ---------------------------------------------------------------
:)

declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace common="http://read.84000.co/common" at "../modules/common.xql";
import module namespace translation="http://read.84000.co/translation" at "../modules/translation.xql";
import module namespace source="http://read.84000.co/source" at "../modules/source.xql";
import module namespace functx="http://www.functx.com";

declare option exist:serialize "method=xml indent=no";

let $translation-id := request:get-parameter('resource-id', '')
let $volume := translation:volume($translation-id)
let $ekangyur-volume-number := source:ekangyur-volume-number($volume)

let $folio := request:get-parameter('folio', '')
let $folio-page := substring-before($folio, '.')
let $folio-side := substring-after($folio, '.')
let $ekangyur-page-number := 
    if(functx:is-a-number($folio-page)) then 
        source:ekangyur-page-number($volume, $folio-page, $folio-side)
    else
        0

return
    <response 
        xmlns="http://read.84000.co/ns/1.0" 
        model-type="source"
        timestamp="{current-dateTime()}"
        app-id="{ common:app-id() }"
        user-name="{ common:user-name() }" 
        translation-id="{ $translation-id }"
        folio="{ $folio }">
        {
            source:ekangyur-page($ekangyur-volume-number, $ekangyur-page-number, false())
        }
    </response>

xquery version "3.0" encoding "UTF-8";
(:
    Accepts a folio string parameter
    Returns the source tibetan for that folio
    ---------------------------------------------------------------
:)

declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace common="http://read.84000.co/common" at "../modules/common.xql";
import module namespace source="http://read.84000.co/source" at "../modules/source.xql";
import module namespace functx="http://www.functx.com";

declare option exist:serialize "method=xml indent=no";

let $translation-id := request:get-parameter('resource-id', '')
let $folio := request:get-parameter('folio', '')

let $translation-id-tokenized := tokenize($translation-id, '-')
let $volume := 
    if(count($translation-id-tokenized) eq 3) then
        if(functx:is-a-number($translation-id-tokenized[2])) then
            xs:integer($translation-id-tokenized[2])
        else
            0
    else
        0

let $folio-page := substring-before($folio, '.')
let $folio-side := substring-after($folio, '.')

let $ekangyur-page-number := 
    if(functx:is-a-number($folio-page)) then 
        if($folio-side eq 'a') then
            (xs:integer($folio-page) * 2) -1 
        else if($folio-side eq 'b') then
            (xs:integer($folio-page)* 2)
        else
            0
    else
        0

let $ekangyur-volume-number := xs:integer($volume + 126)

return
    <response 
        xmlns="http://read.84000.co/ns/1.0" 
        model-type="source"
        timestamp="{current-dateTime()}"
        app-id="{ common:app-id() }"
        user-name="{ common:user-name() }" 
        translation-id="{ $translation-id }"
        folio="{ $folio }"
        volume="{ $volume }">
        {
            source:ekangyur-page($ekangyur-volume-number, $ekangyur-page-number)
        }
    </response>

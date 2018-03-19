xquery version "3.0" encoding "UTF-8";
(:
    Accepts a folio string parameter
    Returns the source tibetan for that folio
    ---------------------------------------------------------------
:)

declare namespace m = "http://read.84000.co/ns/1.0";

import module namespace common="http://read.84000.co/common" at "../modules/common.xql";
import module namespace translations="http://read.84000.co/translations" at "../modules/translations.xql";
import module namespace translation="http://read.84000.co/translation" at "../modules/translation.xql";
import module namespace source="http://read.84000.co/source" at "../modules/source.xql";
import module namespace translation-memory="http://read.84000.co/translation-memory" at "../modules/translation-memory.xql";
import module namespace functx="http://www.functx.com";

declare option exist:serialize "method=xml indent=no";

let $translations := translations:translations(false())
let $translation-id := request:get-parameter('translation-id', $translations/m:translation[1]/@id)
let $volume := translation:volume($translation-id)
let $translation := translation:tei($translation-id)
let $folios := translation:folios($translation, 0)
let $folio-request := request:get-parameter('folio', '')
let $folio := 
    if($folios/m:folio[@id eq $folio-request]) then
        $folio-request
    else
        $folios/m:folio[1]/@id

let $action := 
    if(request:get-parameter('action', '') eq 'remember-translation') then
        translation-memory:remember($translation-id, $folio, request:get-parameter('tuid', ''), request:get-parameter('source', ''), request:get-parameter('translation', ''))
    else
        ()

let $ekangyur-volume-number := source:ekangyur-volume-number($volume)
let $folio-str := substring-after($folio, 'F.')
let $folio-page := substring-before($folio-str, '.')
let $folio-side := substring-after($folio-str, '.')
let $ekangyur-page-number := 
    if(functx:is-a-number($folio-page)) then 
        source:ekangyur-page-number($volume, $folio-page, $folio-side)
    else
        0

return
    <response 
        xmlns="http://read.84000.co/ns/1.0" 
        model-type="translation-memory"
        timestamp="{current-dateTime()}"
        app-id="{ common:app-id() }"
        user-name="{ common:user-name() }">
        <request translation-id="{ $translation-id }" folio="{ $folio }" />
        <action>{ $action }</action>
        {
            $translations
        }
        {
            $folios
        }
        {
            translation:folio-content($translation, $folio, 0)
        }
        {
            source:ekangyur-page($ekangyur-volume-number, $ekangyur-page-number, true())
        }
        {
            translation-memory:folio($translation-id, $folio)
        }
    </response>

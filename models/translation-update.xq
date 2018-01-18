xquery version "3.0" encoding "UTF-8";
(:
    Updates a TEI file
    -------------------------------------------------------------
:)

import module namespace common="http://read.84000.co/common" at "../modules/common.xql";
import module namespace translation="http://read.84000.co/translation" at "../modules/translation.xql";

declare namespace tei="http://www.tei-c.org/ns/1.0";

declare option exist:serialize "method=xml indent=no";

let $tab := request:get-parameter('tab', 'translation')
let $resource-id := request:get-parameter('resource-id', '')
let $translation := translation:tei($resource-id)
let $translation-id := translation:id($translation)

let $updated := 
    if($tab eq 'titles') then
        translation:update($translation, ('title-en', 'title-bo', 'title-sa', 'title-long-en', 'title-long-bo', 'title-long-bo-ltn', 'title-long-sa-ltn'))
    else if($tab eq 'source') then
        translation:update($translation, ('toh', 'series', 'scope', 'range', 'authors'))
    else ()
    
return

    <response 
        xmlns="http://read.84000.co/ns/1.0" 
        model-type="translation-update"
        timestamp="{ current-dateTime() }"
        app-id="{ common:app-id() }"
        user-name="{ common:user-name() }" 
        tab="{$tab}">
        <updates>{ $updated }</updates>
        <translation xmlns="http://read.84000.co/ns/1.0" id="{ $translation-id }">
            {
                if($tab eq 'titles') then
                    translation:titles($translation)
                else ()
            }
            {
                if($tab eq 'titles') then
                    translation:long-titles($translation)
                else ()
            }
            {
                if($tab eq 'source') then
                    translation:source($translation)
                else ()
            }
        </translation>
    </response>
    
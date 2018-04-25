xquery version "3.0" encoding "UTF-8";
(:
    Accepts the resource-id parameter
    Returns the about page xml
    -------------------------------------------------------------
:)

import module namespace common="http://read.84000.co/common" at "../modules/common.xql";
import module namespace outline="http://read.84000.co/outline" at "../modules/outline.xql";

declare namespace m="http://read.84000.co/ns/1.0";

declare option exist:serialize "method=xml indent=no";

let $resource-id := request:get-parameter('resource-id', '')
let $tab := request:get-parameter('tab', 'published')
let $lang := request:get-parameter('lang', 'en')

return

    <response 
        xmlns="http://read.84000.co/ns/1.0" 
        model-type="about"
        page-id="{ $resource-id }"
        timestamp="{ current-dateTime() }"
        app-id="{ common:app-id() }"
        app-version="{ common:app-version() }"
        user-name="{ common:user-name() }" >
        <!-- Add tabs -->
        <tabs>
            <tab active="{ if($tab eq 'published')then 1 else 0 }" id="published">Published Texts</tab>
            <tab active="{ if($tab eq 'in-progress')then 1 else 0 }" id="in-progress">Translations In Progress</tab>
        </tabs>
        <!-- Add display -->
        <header>
            <img>{ concat(common:environment()/m:resource-path/text(),'/imgs/KangyurTengyurbyArneSchelling.jpg') }</img>
            <title>Translations</title>
            <quote>
                <text>
                    "Hearing the Wisdom of the Buddha through translation will be a great contribution to world society, now and in the future."
                </text>
                <author>
                    Dzogchen Pönlop Rinpoche
                </author>
            </quote>
        </header>
        <!-- Add text strings in selected language -->
        <!-- Add data -->
        {
            if($resource-id eq 'progress') then 
                if($tab eq 'published') then
                    outline:progress('published', 'toh', '0', '')
                else if ($tab eq 'in-progress') then
                    outline:progress('in-progress', 'toh', '0', '')
                else
                    ()
            else
                ()
                
        }
    </response>

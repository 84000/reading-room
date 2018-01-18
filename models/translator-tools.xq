xquery version "3.0" encoding "UTF-8";
(:
    Accepts the resource-id parameter
    Returns the home page xml
    -------------------------------------------------------------
    Transform this data into the homepage html.
:)
declare option exist:serialize "method=xml indent=no";

import module namespace common="http://read.84000.co/common" at "../modules/common.xql";
import module namespace glossary="http://read.84000.co/glossary" at "../modules/glossary.xql";
import module namespace search="http://read.84000.co/search" at "../modules/search.xql";

declare option exist:serialize "method=xml indent=no";

let $tab := request:get-parameter('tab', 'search')
let $type := request:get-parameter('type', 'term')
let $search := request:get-parameter('search', '')

return

    <response 
        xmlns="http://read.84000.co/ns/1.0" 
        model-type="home"
        timestamp="{ current-dateTime() }"
        app-id="{ common:app-id() }"
        user-name="{ common:user-name() }" 
        tab="{ $tab }">
        {
            if($tab eq 'search') then 
                search:search($search)
            else if($tab eq 'glossary') then 
                glossary:glossary-terms($type)
            else
                ()
                
        }
    </response>

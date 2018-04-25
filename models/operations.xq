xquery version "3.0" encoding "UTF-8";
(:
    Accepts the resource-id parameter
    Returns the operations page xml
    -------------------------------------------------------------
:)

import module namespace common="http://read.84000.co/common" at "../modules/common.xql";
import module namespace outline="http://read.84000.co/outline" at "../modules/outline.xql";
import module namespace sponsors="http://read.84000.co/sponsors" at "../modules/sponsors.xql";

declare option exist:serialize "method=xml indent=no";

let $tab := request:get-parameter('tab', 'progress')
let $status := request:get-parameter('status', '')
let $sort := request:get-parameter('sort', '')
let $range := request:get-parameter('range', '')
let $filter := request:get-parameter('filter', '')

return

    <response 
        xmlns="http://read.84000.co/ns/1.0" 
        model-type="operations"
        timestamp="{ current-dateTime() }"
        app-id="{ common:app-id() }"
        app-version="{ common:app-version() }"
        user-name="{ common:user-name() }" >
        <tabs>
            <tab active="{ if($tab eq 'progress')then 1 else 0 }" id="progress">Progress</tab>
            <tab active="{ if($tab eq 'sponsors')then 1 else 0 }" id="sponsors">Sponsors</tab>
        </tabs>
        {
            if($tab eq 'progress') then 
                outline:progress($status, $sort, $range, $filter)
            else if($tab eq 'sponsors') then 
                doc(concat(common:data-path(), '/operations/sponsors.xml'))
            else
                ()
                
        }
    </response>

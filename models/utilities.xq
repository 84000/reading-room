xquery version "3.0" encoding "UTF-8";
(:
    Accepts the resource-id parameter
    Returns the home page xml
    -------------------------------------------------------------
    Transform this data into the homepage html.
:)

import module namespace common="http://read.84000.co/common" at "../modules/common.xql";
import module namespace outline="http://read.84000.co/outline" at "../modules/outline.xql";
import module namespace translations="http://read.84000.co/translations" at "../modules/translations.xql";
import module namespace log="http://read.84000.co/log" at "../modules/log.xql";
import module namespace deployment="http://read.84000.co/deployment" at "../modules/deployment.xql";

declare option exist:serialize "method=xml indent=no";

let $tab := request:get-parameter('tab', 'translations')
let $action := request:get-parameter('action', '')
let $sync-resource := request:get-parameter('resource', 'all')
let $commit-msg := request:get-parameter('message', '')

return

    <response 
        xmlns="http://read.84000.co/ns/1.0" 
        model-type="utilities"
        timestamp="{ current-dateTime() }"
        app-id="{ common:app-id() }"
        app-version="{ common:app-version() }"
        user-name="{ common:user-name() }" >
        <tabs>
            <tab active="{ if($tab eq 'translations')then 1 else 0 }" id="translations">Translations</tab>
            <tab active="{ if($tab eq 'sections')then 1 else 0 }" id="sections">Sections</tab>
            <tab active="{ if($tab eq 'tests')then 1 else 0 }" id="tests">Tests</tab>
            <tab active="{ if($tab eq 'layout-checks')then 1 else 0 }" id="layout-checks">Layout Checks</tab>
            <tab active="{ if($tab eq 'requests')then 1 else 0 }" id="requests">Requests</tab>
            <tab active="{ if($tab eq 'client-errors')then 1 else 0 }" id="client-errors">Client Errors</tab>
            {
                if(common:snapshot-conf())then
                    <tab active="{ if($tab eq 'snapshot')then 1 else 0 }" id="snapshot">Snapshot</tab>
                else
                    ()
            }
            {
                if(common:deployment-conf())then
                    <tab active="{ if($tab eq 'deployment')then 1 else 0 }" id="deployment">Deployment</tab>
                else
                    ()
            }
        </tabs>
        {
            if($tab eq 'sections') then 
                outline:outline()
            else if($tab eq 'translations') then 
                translations:translations(true())
            else if($tab eq 'requests') then 
                log:requests()
            else if($tab eq 'client-errors') then 
                log:client-errors()
            else if($tab eq 'snapshot') then 
                deployment:snapshot($action, $sync-resource, $commit-msg)
            else if($tab eq 'deployment') then 
                deployment:push-app($action, $commit-msg)
            else
                ()
                
        }
    </response>

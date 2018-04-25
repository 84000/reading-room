xquery version "3.0" encoding "UTF-8";
(:
    Accepts the resource-id parameter
    Returns the section xml
    -------------------------------------------------------------
    Can be returned as xml or transformed into json or html.
:)
declare namespace o = "http://www.tbrc.org/models/outline";

import module namespace common="http://read.84000.co/common" at "../modules/common.xql";
import module namespace section="http://read.84000.co/outline-section" at "../modules/outline-section.xql";

declare option exist:serialize "method=xml indent=no";

let $section-id := lower-case(request:get-parameter('resource-id', 'lobby'))
let $outlines := collection(common:outlines-path())
let $section := $outlines//*[lower-case(@RID) eq $section-id]

return

    <response 
        xmlns="http://read.84000.co/ns/1.0" 
        model-type="section"
        timestamp="{ current-dateTime() }"
        app-id="{ common:app-id() }" 
        app-version="{ common:app-version() }"
        user-name="{ common:user-name() }" >
        <section>
            <id>{ $section-id }</id>
            { section:titles($section) }
            { section:ancestors($section, 1) }
            { section:contents($section) }
            { section:summary($section) }
            { section:sections($section) }
            { section:texts($section, $section-id, request:get-parameter('translated-only', '0')) }
        </section>
    </response>

xquery version "3.0";
(:
    Accepts the resource-id parameter
    Returns the translation tei
    -------------------------------------------------------------
    Simply return the TEI.
:)

declare option exist:serialize "method=xml indent=no";

import module namespace translation="http://read.84000.co/translation" at "../modules/translation.xql";

let $translation := translation:tei(request:get-parameter('resource-id', ''))

return
    $translation

xquery version "3.0" encoding "UTF-8";

declare option exist:serialize "method=xml indent=no";

import module namespace common="http://read.84000.co/common" at "../modules/common.xql";

let $redirect := lower-case(request:get-parameter('redirect', '/section/lobby.html'))

return

    <response 
        xmlns="http://read.84000.co/ns/1.0" 
        model-type="auth"
        timestamp="{ current-dateTime() }"
        app-id="{ common:app-id() }" 
        app-version="{ common:app-version() }"
        user-name="{ common:user-name() }" >
        <redirect>{ $redirect }</redirect>
    </response>

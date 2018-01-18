xquery version "3.0" encoding "UTF-8";

module namespace log = "http://read.84000.co/log";

import module namespace common="http://read.84000.co/common" at "common.xql";

declare function local:parameters() {
    for $parameter in request:get-parameter-names()
    return 
        <parameter name="{ $parameter }">
             { request:get-parameter($parameter, "") }
        </parameter>
};

declare function log:log-request($request as xs:string, $app as xs:string, $type as xs:string, $resource-id as xs:string, $resource-suffix as xs:string) as empty-sequence()
{
    let $logfile-collection := common:log-path()
    let $logfile-name := "requests.xml"
    let $logfile-full := concat($logfile-collection, '/', $logfile-name)
    let $logfile-created := 
        if(doc-available($logfile-full)) then 
            $logfile-full
        else
            xmldb:store($logfile-collection, $logfile-name, <log/>)
    let $parameters :=  local:parameters()
    return
        update insert
            <request timestamp="{current-dateTime()}">
                <request>{$request}</request>
                <app>{$app}</app>
                <type>{$type}</type>
                <resource-id>{$resource-id}</resource-id>
                <resource-suffix>{$resource-suffix}</resource-suffix>
                <parameters>{$parameters}</parameters>
            </request>
                into doc($logfile-full)/*
            
};
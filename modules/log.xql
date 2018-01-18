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

declare function local:dateTimes($timestamps){
    for $i in $timestamps return xs:dateTime($i)
};

declare function local:dateTimeStr($timestamp){
    format-dateTime($timestamp, '[D01]/[M01]/[Y0001] at [H01]:[m01]:[s01]')
};

declare function local:days-from-now($timestamp){
    current-dateTime() - $timestamp
};

declare function local:days-ago-str($duration){
    let $days := days-from-duration($duration)
    return if ($days eq 0) then
            'Today'
        else if ($days eq 1) then
            'Yesterday'
        else
            concat($days, ' days ago')
            
};

declare function log:requests() {
    <requests>
    {
        let $log := doc('/db/env/logs/requests.xml')
        for $request in $log/log/request
            let $request-string := string($request/request)
            group by $request-string
            let $count-request := count($request)
            let $ts := $request/@timestamp
            let $min-ts := if($ts) then min(local:dateTimes($ts)) else ''
            let $max-ts := if($ts) then max(local:dateTimes($ts)) else ''
            let $first-from-now := local:days-from-now($min-ts)
            let $latest-from-now := local:days-from-now($max-ts)
            order by $count-request descending
            
            return 
                <request 
                    count="{ $count-request }" 
                    first="{ local:days-ago-str($first-from-now) }" 
                    latest="{ local:days-ago-str($latest-from-now) }">
                    { 
                        substring-after($request-string, concat(common:app-id(), '/app'))
                    }
                </request>
    }
   </requests>
};

declare function log:client-errors() {
    <errors>
    {
        let $log := doc('/db/env/logs/requests.xml')
        for $error in $log/log/request[resource-id/text() eq 'log-error']
            let $url := string($error/parameters/parameter[@name = 'url'])
            group by $url
            let $count-url := count($error)
            let $ts := $error/@timestamp
            let $min-ts := if($ts) then min(local:dateTimes($ts)) else ''
            let $max-ts := if($ts) then max(local:dateTimes($ts)) else ''
            let $first-from-now := local:days-from-now($min-ts)
            let $latest-from-now := local:days-from-now($max-ts)
            order by days-from-duration($latest-from-now), $count-url descending
            
            return 
                <error 
                    count="{ $count-url }" 
                    first="{ local:days-ago-str($first-from-now) }" 
                    latest="{ local:days-ago-str($latest-from-now) }">
                    { 
                        $url
                    }
                </error>
    }
   </errors>
};
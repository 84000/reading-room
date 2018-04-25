xquery version "3.0" encoding "UTF-8";

import module namespace common="http://read.84000.co/common" at "../modules/common.xql";
import module namespace translation="http://read.84000.co/translation" at "../modules/translation.xql";
import module namespace validation="http://exist-db.org/xquery/validation" at "java:org.exist.xquery.functions.validation.ValidationModule";

declare namespace tei="http://www.tei-c.org/ns/1.0";

declare option exist:serialize "method=xml indent=no";

let $schema := doc(concat(common:data-path(), '/schema/1.0/tei.rng'))

return 

    <response 
        xmlns="http://read.84000.co/ns/1.0" 
        model-type="home"
        timestamp="{ current-dateTime() }"
        app-id="{ common:app-id() }"
        app-version="{ common:app-version() }"
        user-name="{ common:user-name() }" >
        <results>
        {
            for $translation in collection(common:translations-path())//tei:TEI
                let $translation-id := translation:id($translation)
                let $title := translation:title($translation)
                let $validation-report := validation:jing-report($translation, $schema)
            return
                <translation id="{ $translation-id }">
                    <title>{ $title }</title>
                    {
                        <result status="{ $validation-report//*:status/text() }">
                        { 
                            for $error in $validation-report//*:message
                            return 
                                <error line="{ $error/@line }">{ $error/text() }</error>
                        }
                        </result>
                    }                
                </translation>
        }
        </results>
    </response>
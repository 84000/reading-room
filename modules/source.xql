xquery version "3.0";

module namespace source="http://read.84000.co/source";

declare namespace m="http://read.84000.co/ns/1.0";
declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace common="http://read.84000.co/common" at "../modules/common.xql";
import module namespace translations="http://read.84000.co/translations" at "../modules/translations.xql";
import module namespace converter="http://tbrc.org/xquery/ewts2unicode" at "java:org.tbrc.xquery.extensions.EwtsToUniModule";

declare function source:ekangyur-page($volume-number as xs:integer, $page-number as xs:integer) as node() {
    
    let $title := concat('UT4CZ5369-I1KG9', xs:string($volume-number))
    let $volume := doc(concat('/db/apps/eKangyur/data/UT4CZ5369/', $title, '/', $title, '-0000.xml'))
    let $volume-page-count := count($volume//tei:p)
    
    return
        if($volume-page-count and ($page-number gt $volume-page-count))then
            source:ekangyur-page($volume-number + 1, ($page-number - $volume-page-count) + 1)
        else
        
            let $bo := $volume//tei:p[@n eq xs:string($page-number)]
            
            return 
                <source
                    xmlns="http://read.84000.co/ns/1.0" 
                    name="ekangyur"
                    volume="{ $volume-number }" 
                    title="{ $title }"
                    page="{ $page-number }" 
                    volume-page-count="{ $volume-page-count }" >
                    <language xml:lang="bo">{ $bo }</language>
                    <!-- <language xml:lang="bo-ltn">{ source:bo-ltn($bo as xs:string) }</language> -->
                </source>
        
};

declare function source:bo-ltn($bo as xs:string) as xs:string {
    <tei:p>
    { 
        for $line at $pos in $bo/text()[normalize-space(.)]
        return
        (
            element tei:milestone {
                attribute unit {'line'},
                attribute n { $pos }
            },
            text {
                converter:toWylie($line)
            }
        )
    }
    </tei:p>
};


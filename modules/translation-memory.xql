xquery version "3.0";

module namespace translation-memory="http://read.84000.co/translation-memory";

declare namespace tmx="http://www.lisa.org/tmx14";

import module namespace common="http://read.84000.co/common" at "../modules/common.xql";
import module namespace translation="http://read.84000.co/translation" at "../modules/translation.xql";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";

declare function translation-memory:folio($translation-id as xs:string, $folio as xs:string) as node() {
    
    let $doc := doc(concat(common:data-path(), '/translation-memory/', $translation-id, '.tmx'))
    
    return
        <translation-memory 
            xmlns="http://read.84000.co/ns/1.0"
            translation-id="{ $translation-id }"
            folio="{ $folio }">
        {
            $doc//tmx:tu[tmx:prop[@name="folio"][text() eq $folio]]
        }
        </translation-memory>
};

declare function translation-memory:remember($translation-id as xs:string, $folio as xs:string, $tuid-request as xs:string, $source as xs:string, $translation as xs:string) as node() {
    
    let $filepath := concat(common:data-path(), '/translation-memory/')
    let $filename := concat($translation-id, '.tmx')
    let $doc := doc(concat($filepath, $filename))
    
    let $tuid := 
        if($doc//tmx:tu[@id eq $tuid-request]) then
            $tuid-request
        else if($doc) then
            xs:string(max($doc//tmx:tu/@id ! xs:integer(concat('0', .))) + 1)
        else
            '1'
    
    let $tu := 
        <tu xmlns="http://www.lisa.org/tmx14" id="{ $tuid }">
            <prop name="folio">{ $folio }</prop>
            <tuv xml:lang="bo">
                <seg>{ $source }</seg>
            </tuv>
            <tuv xml:lang="en">
                <seg>{ $translation }</seg>
            </tuv>
        </tu>
    
    return
        if($tuid eq $tuid-request and $source ne '' and $translation ne '') then
            (: update :)
            <updated xmlns="http://read.84000.co/ns/1.0">
            {
                update replace $doc//tmx:tu[@id eq $tuid] with $tu
            }
            </updated>
        else if($tuid eq $tuid-request) then
            (: remove :)
            <updated xmlns="http://read.84000.co/ns/1.0">
            {
                update delete $doc//tmx:tu[@id eq $tuid]
            }
            </updated>
        else if($doc) then
            (: Add :)
            <added xmlns="http://read.84000.co/ns/1.0">
            {
                update insert $tu
                into $doc//tmx:body
            }
            </added>
        else
            <created xmlns="http://read.84000.co/ns/1.0">
            {
                xmldb:store($filepath, $filename, 
                    <tmx xmlns="http://www.lisa.org/tmx14">
                        <header creationtool="84000-translation-memory" creationtoolversion="1.0.0.0" segtype="phrase" adminlang="en" srclang="bo" o-tmf="tei" datatype="Text"/>
                        <body>
                        {
                            $tu
                        }
                        </body>
                    </tmx>
                ),
                sm:chgrp(xs:anyURI(concat($filepath, $filename)), 'translators'),
                sm:chmod(xs:anyURI(concat($filepath, $filename)), 'rw-rw----')
            }
            </created>
};
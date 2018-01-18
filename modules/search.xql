xquery version "3.0" encoding "UTF-8";
(:
    Accepts the search parameter
    Returns search items xml
    --------------------------------------------------------
:)
module namespace search="http://read.84000.co/search";

declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace xhtml="http://www.w3.org/1999/xhtml";

import module namespace common="http://read.84000.co/common" at "common.xql";
import module namespace translation="http://read.84000.co/translation" at "translation.xql";
import module namespace kwic="http://exist-db.org/xquery/kwic";

declare function search:search($request) {
    
    let $translations := collection(common:translations-path())
    
    let $options :=
        <options>
            <default-operator>or</default-operator>
            <phrase-slop>0</phrase-slop>
            <leading-wildcard>no</leading-wildcard>
            <filter-rewrite>yes</filter-rewrite>
        </options>
        
    let $query := 
        <query>
            <bool>
                <near slop="20" occur="should">{ lower-case($request) }</near>
                <wildcard occur="should">{ concat(lower-case($request),'*') }</wildcard>
            </bool>
        </query>
    (: let $query := <near slop="20">{ $request }</near> :)
    
    return
    
        <search xmlns="http://read.84000.co/ns/1.0">
            <request>{ $request }</request>
            <results>
            {
                if ($request) then
 
                    for $text in 
                        $translations//tei:teiHeader/tei:fileDesc//tei:title[ft:query(., $query, $options)]
                        | $translations//tei:teiHeader/tei:fileDesc//tei:author[ft:query(., $query, $options)]
                        | $translations//tei:teiHeader/tei:fileDesc//tei:edition[ft:query(., $query, $options)]
                        | $translations//tei:teiHeader/tei:fileDesc//tei:sourceDesc[ft:query(., $query, $options)]
                        | $translations//tei:text//tei:p[ft:query(., $query, $options)]
                        | $translations//tei:text//tei:lg[ft:query(., $query, $options)]
                        | $translations//tei:text//tei:ab[ft:query(., $query, $options)]
                        | $translations//tei:text//tei:trailer[ft:query(., $query, $options)]
                        | $translations//tei:front//tei:list/tei:head[ft:query(., $query, $options)]
                        | $translations//tei:body//tei:list/tei:head[ft:query(., $query, $options)]
                        | $translations//tei:back//tei:bibl[ft:query(., $query, $options)]
                        | $translations//tei:back//tei:gloss[ft:query(., $query, $options)]
 
                    let $document-uri := base-uri($text)
                    let $translation := doc($document-uri)
                    let $translation-id := translation:id($translation)
                    let $expanded := util:expand($text, "expand-xincludes=no")
                    let $node-name := node-name($expanded)
                    (: let $uid := $expanded/@xml:id/string() :)
                    let $uid := if($expanded/@xml:id/string()) then $expanded/@xml:id/string() else concat('node', '-', $expanded/@tid/string())
                    
                    order by ft:score($text) descending
                    
                    return
                        <item>
                            <source 
                                translation-id="{ $translation-id }" 
                                url="{
                                    if($uid) then
                                        concat('/translation/', $translation-id, '.html', '#', $uid)
                                    else
                                        concat('/translation/', $translation-id, '.html')
                                }"
                                type="{ $node-name }"
                                >
                            { 
                                $translation//tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type='mainTitle'][lower-case(@xml:lang)='en'][1]/text() 
                            }
                            </source>
                            <text>
                            {
                                common:search-result($expanded)
                            }
                            </text>
                        </item>
               else
                    ()
            }
            </results>
        </search>
};
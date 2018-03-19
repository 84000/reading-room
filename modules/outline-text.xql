xquery version "3.1";

module namespace text="http://read.84000.co/outline-text";

declare namespace m = "http://read.84000.co/ns/1.0";
declare namespace o = "http://www.tbrc.org/models/outline";
declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace common="http://read.84000.co/common" at "common.xql";
import module namespace section="http://read.84000.co/outline-section" at "outline-section.xql";

declare function text:translation-id($text) as xs:string* {
    $text/o:node[@type = 'translation']/o:description[@type='text']/text()
};

declare function text:translation($text-id, $outlines) as node()* {
    $outlines//o:node[@type = 'text'][o:node[@type = 'translation']/o:description[@type='text']/text() eq $text-id][1]
};

declare function text:section($text-id, $outlines) as node()* {
    
    let $nodes := 
        $outlines//o:node[@type = 'section'][o:node[@type = 'text']/o:node[@type = 'translation']/o:description[@type = 'text'][. = $text-id]]
        | $outlines//o:node[@type = 'section'][o:node[@type = 'text']/o:node[@type = 'chapter']/o:node[@type = 'translation']/o:description[@type = 'text'][. = $text-id]]
    
    return 
        if(count($nodes) > 0) then
            $nodes[1]
        else
            ()

};

declare function text:translation-exists($id) as xs:boolean {

    exists(collection(common:translations-path())/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@xml:id = $id])
    
};

declare function text:titles($text) as node() {

    <titles xmlns="http://read.84000.co/ns/1.0">
        <title xml:lang="en">{ $text/o:title[@lang eq 'english'][1]/text() }</title>
        <title xml:lang="bo">{ 
            let $bo-ltn := $text/o:title[not(@lang) or @encoding eq "extendedWylie"][1]/text()
            return 
                if($bo-ltn) then
                    common:bo-title($bo-ltn)
                else
                    $text/o:title[@lang eq 'tibetan'][1]/text()
        }</title>
        <title xml:lang="bo-ltn">{ $text/o:title[not(@lang) or @encoding eq "extendedWylie"][1]/text() }</title>
        <title xml:lang="sa-ltn">{ $text/o:title[@lang eq 'sanskrit'][1]/text() }</title>
    </titles>

};

declare function text:toh($text as node()) as node() {

    (: Parses the toh so we can sort by it :)
    let $toh := string-join($text/o:description[@type eq 'toh']/text(), ' + ')
    
    (: Set $first to the first numeric value :)
    (: Get the chunk before bracket :)
    let $first-1 := if(contains($toh, '(')) then substring-before($toh, '(') else $toh
    
    (: Parse that to get the chunk before slash :)
    let $first-2 := if(contains($first-1, '/')) then substring-before($first-1, '/') else $first-1
    
    (: Parse that to get the chunk before A :)
    let $first-3 := if(contains($first-2, 'A')) then substring-before($first-2, 'A') else $first-2
    
    (: Now we should have a number :)
    let $first := if(string(number($first-3)) != 'NaN') then number($first-3) else 0
    
    (: Set $sub as number between brackets :)
    let $sub-str := substring-before(substring-after($toh, '('), ')')
    let $sub := if(string(number($sub-str)) != 'NaN') then number($sub-str) else 0
    
    (: Now we can sort by first, sub ascending :)
    return
        <toh 
            xmlns="http://read.84000.co/ns/1.0" 
            first="{ $first }" 
            sub="{ $sub }"
            sponsored="{ text:sponsored-sutra($first, $sub) }">
            { 
                $toh 
            }
        </toh>

};

declare function text:status($text) as node() {
    <status xmlns="http://read.84000.co/ns/1.0">{ text:status-str($text) }</status>
};

declare function text:title($text) as node() {
    <title xmlns="http://read.84000.co/ns/1.0" xml:lang="en">
    { 
        if($text/@type = 'chapter') then
            concat(
                $text/../o:title[@lang = 'english'][not(@type) or @type = 'bibliographicalTitle'][1]/text(),
                ', ',
                $text/o:title[@lang = 'english'][not(@type) or @type = 'bibliographicalTitle'][1]/text()
            )
        else
            $text/o:title[@lang = 'english'][not(@type) or @type = 'bibliographicalTitle'][1]/text() 
    }
    </title>
};

declare function text:title-variants($text) as node()* {
    
    let $titles := text:titles($text)
    let $variants := $text/o:title[not(text() = $titles/m:title/text())]
    
    return
        if($variants) then
            <title-variants  xmlns="http://read.84000.co/ns/1.0">
            {
                for $variant in $variants
                return 
                    <title xml:lang="{ common:xml-lang($variant) }">{ $variant/text() }</title> 
            }
            </title-variants>
        else
            ()
        
};

declare function text:status-str($text) as xs:string* {

    switch ($text/o:node[@type = 'translation']/o:description[@type = 'status']/text()) 
        case "completed" 
            return 
                if(text:translation-exists(text:translation-id($text))) then 
                    "available" 
                else 
                    "missing"
        case "inProcess" 
            return "in-progress"
        default 
            return "not-started" 
    
};

declare function text:ancestors($text as node()*) {
    
    let $text-id := text:translation-id($text)
    let $outlines := collection(common:outlines-path())
    let $parent := text:section($text-id, $outlines)
    return
        if($parent/@RID) then
            <parent xmlns="http://read.84000.co/ns/1.0" id="{ $parent/@RID }" nesting="1">
                <title xml:lang="en">{ section:title($parent, "en") }</title>
                { 
                    section:ancestors($parent, 2) 
                }
            </parent>
        else
            ()
    
};

declare function text:location($text as node(), $outline as node()) as node()* {
    
    let $title-pages-per-volume := $outline//o:volumes/@title-pages-per-volume
    let $start := $text/o:location[not(@type) or @type = "page"][1]
    let $end := $text/o:location[not(@type) or @type = "page"][2]
    let $start-vol := xs:integer($start/@vol)
    let $end-vol := xs:integer($end/@vol)
    let $start-page := if($start/@page) then xs:integer($start/@page) else 0 
    let $start-page-adjusted := $start-page - $title-pages-per-volume
    let $end-page := if($end/@page) then xs:integer($end/@page) else 0 
    let $end-page-adjusted := $end-page - $title-pages-per-volume
    
    let $end-page-cumulative := 
        if($start-vol < $end-vol) then
            sum(
                for $count in $outline//o:volumes/o:volume[xs:integer(@number) > ($start-vol - 1)][xs:integer(@number) < ($end-vol)]/@count-pages
                return $count - $title-pages-per-volume
            ) + $end-page-adjusted
        else
            $end-page-adjusted
    
    let $count-pages := xs:integer($end-page-cumulative - ($start-page-adjusted - 1))
    
    return
        <location xmlns="http://read.84000.co/ns/1.0" count-pages="{ $count-pages }">
            <start volume="{ $start-vol }" page="{ $start-page }"/>
            <end volume="{ $end-vol }" page="{ $end-page }"/>
        </location>
    
};

declare function text:text($text as node()*, $translated as xs:boolean, $ancestors as xs:boolean) {
    let $translation-id := text:translation-id($text)
    return
        <text xmlns="http://read.84000.co/ns/1.0" type="{ $text/@type }" translation-id="{ $translation-id }">
            {
                text:titles($text)
            }
            {
                text:title-variants($text)
            }
            {
                if($ancestors) then
                    text:ancestors($text)
                else
                    ()
            }
            <toh>{ $text/o:description[@type = 'toh']/text() }</toh>
            <summary>{ $text/o:node[@type = 'translation']/o:description[@type = 'summary']/text() }</summary>
            <status>{ text:status-str($text) }</status>
            <chapters boolean="{$ancestors}">
                {
                    let $chapters := 
                        if($translated) then
                            $text/o:node[@type = "chapter"][./o:node[@type = 'translation']/o:description[@type = 'status']/text() eq 'completed']
                        else
                            $text/o:node[@type = "chapter"]
                        
                    for $chapter in $chapters
                    return
                        text:text($chapter, $translated, $ancestors)
                }
            </chapters>
            <downloads>
            {
                if(util:binary-doc-available(concat(common:data-path(), '/pdf/', $translation-id ,'.pdf'))) then
                    <download type="pdf" url="{ concat('/data/pdf/', $translation-id ,'.pdf') }"/>
                else
                    ()
            }
            {
                if(util:binary-doc-available(concat(common:data-path(), '/epub/', $translation-id ,'.epub'))) then
                    <download type="epub" url="{ concat('/data/epub/', $translation-id ,'.epub') }"/>
                else
                    ()
            }
            </downloads>
        </text>
};

declare function text:sponsored-sutra($toh as xs:integer, $chapter as xs:integer) as xs:boolean {
    
    let $sponsored-sutras := doc(concat(common:data-path(), '/operations/sponsors.xml'))
    return
        if($sponsored-sutras//m:sutra[xs:integer(@toh) eq $toh][$chapter eq 0 or xs:integer(@chapter) eq $chapter]) then
            true()
        else
            false()
};

xquery version "3.1";

module namespace section="http://read.84000.co/outline-section";

import module namespace common="http://read.84000.co/common" at "common.xql";

declare namespace o="http://www.tbrc.org/models/outline";
declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace text="http://read.84000.co/outline-text" at "outline-text.xql";

declare function section:parent($section) {
    $section/..
};

declare function section:count-child-texts($section) as xs:int {
    count($section/o:node[@type = "text"])
};

declare function section:count-descendant-texts($section) as xs:int {
    count($section//o:node[@type = "text"][not(o:node[@type = "chapter"])]) + count($section//o:node[@type = "chapter"])
};

declare function section:count-descendant-translated($section) as xs:int {
    count($section//o:node[@type="translation"][o:description[@type="status"][text() = "completed"]])
};

declare function section:count-descendant-inprogress($section) as xs:int {
    count($section//o:node[@type="translation"][o:description[@type="status"][text() = "inProcess"]])
};

declare function section:count-translations($section) as xs:int {
    count(contains(collection(common:translations-path())//tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno/@xml:id, $section//o:node/@RID))
};

declare function section:title($section, $lang as xs:string) as xs:string
{
    let $title :=
        if($lang eq "en") then
            (
                $section/o:title[@xml:lang = "en"] 
                | $section/o:title[@lang = "english"]
                | $section/o:name[@xml:lang = "en"]
                | $section/o:name[@lang = "english"]
            )[1]
        else if($lang eq "bo-ltn") then
            (
                $section/o:title[@xml:lang = "bo-ltn"] 
                | $section/o:title[@lang = "tibetan"]
                | $section/o:title[not(@xml:lang)][@type = "bibliographicalTitle"]
                | $section/o:name[@xml:lang = "bo-ltn"]
                | $section/o:name[@lang = "tibetan"]
            )[1]
        else if($lang eq "sa-ltn") then
            (
                $section/o:title[@xml:lang = "sa-ltn"] 
                | $section/o:title[@lang = "sanskrit"]
                | $section/o:name[@xml:lang = "sa-ltn"]
                | $section/o:name[@lang = "sanskrit"]
            )[1]
        else if($lang eq "bo") then
            (
                $section/o:title[@xml:lang = "bo"]
            )[1]
        else
            ""
    return 
        if($title) then
            $title/text()
        else
            ""
};

declare function section:titles($section) as node() {
    
    <titles xmlns="http://read.84000.co/ns/1.0">
        <title xml:lang="en">{ section:title($section, "en") }</title>
        <title xml:lang="bo">{ 
            let $bo := section:title($section, "bo") 
            let $bo-ltn := section:title($section, "bo-ltn")
            return 
                if(not($bo) and $bo-ltn) then
                    common:bo-title($bo-ltn)
                else
                    $bo
        }</title>
        <title xml:lang="bo-ltn">{ section:title($section, "bo-ltn") }</title>
        <title xml:lang="sa-ltn">{ section:title($section, "sa-ltn") }</title>
    </titles>
    
};

declare function section:ancestors($section as node()*,  $nest as xs:integer) as node()* {

    let $parent := section:parent($section)
    return
        if($parent/@RID) then
            <parent xmlns="http://read.84000.co/ns/1.0" id="{ $parent/@RID }" nesting="{ $nest }">
                <title xml:lang="en">{ section:title($parent, "en") }</title>
                { 
                    section:ancestors($parent, $nest + 1) 
                }
            </parent>
        else
            ()
    
};

declare function section:contents($section as node()*) as node() {

    <contents xmlns="http://read.84000.co/ns/1.0">
    { 
        common:unescape($section/o:description[@type = "contents"]/text()) 
    }
    </contents>
    
};

declare function section:summary($section as node()*) as node() {

    <summary xmlns="http://read.84000.co/ns/1.0">
    { 
        common:unescape($section/o:description[@type = "summary"]/text()) 
    }
    </summary>
    
};

declare function section:sections($section as node()*) as node() {

    let $outlines := collection(common:outlines-path())
    return
        <sections xmlns="http://read.84000.co/ns/1.0">
        {
            (: This looks a bit odd but child sections might not be children, so we need to get the ids and then query the whole outline :)
            for $child-section-id in $section/o:node[@type = ("section", "pseudo-section", "link")]/@RID
                let $child-section := $outlines//*[@RID eq $child-section-id][not(@type = "link")]
            return
                <section id="{ $child-section/@RID }" warning="{ $child-section/@warning }" type="{ $child-section/@type }">
                    { 
                        section:titles($child-section) 
                    }
                    <contents>
                    { 
                        common:unescape($child-section/o:description[@type = "contents"]/text()) 
                    }
                    </contents>
                    <texts 
                        count-child-texts="{ section:count-child-texts($section) }" 
                        count-descendant-texts="{ section:count-descendant-texts($child-section) }" 
                        count-descendant-translated="{ section:count-descendant-translated($child-section) }"
                        count-descendant-inprogress="{ section:count-descendant-inprogress($child-section) }">
                    </texts>
                </section>
        }
        </sections>
    
};

declare function section:texts($section as node()*, $section-id as xs:string, $translated-only as xs:string) as node() {
    
    let $outlines := collection(common:outlines-path())
    return
        <texts xmlns="http://read.84000.co/ns/1.0"
            count-child-texts="{ section:count-child-texts($section) }" 
            count-descendant-texts="{ section:count-descendant-texts($section) }" 
            count-descendant-translated="{ section:count-descendant-translated($section) }"
            count-descendant-inprogress="{ section:count-descendant-inprogress($section) }"
            translated-only="{ $translated-only }">
        {
            
            let $texts := 
                if($section-id eq 'all-translated') then
                    $outlines//o:node[@type = "text"][.//o:node[@type = 'translation']/o:description[@type = 'status']/text() eq 'completed']
                else
                    if($translated-only eq '1') then
                        $section/o:node[@type = "text"][.//o:node[@type = 'translation']/o:description[@type = 'status']/text() eq 'completed']
                    else
                        $section/o:node[@type = "text"]
            
            let $translated := ($section-id eq 'all-translated' or $translated-only eq '1')
            let $ancestors := $section-id eq 'all-translated'
                
            for $text in $texts
            return
                text:text($text, $translated, $ancestors)
        }
        </texts>
    
};


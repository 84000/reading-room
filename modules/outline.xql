xquery version "3.1";

module namespace outline="http://read.84000.co/outline";

declare namespace o = "http://www.tbrc.org/models/outline";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace m = "http://read.84000.co/ns/1.0";

import module namespace common="http://read.84000.co/common" at "common.xql";
import module namespace section="http://read.84000.co/outline-section" at "outline-section.xql";
import module namespace text="http://read.84000.co/outline-text" at "outline-text.xql";


declare function outline:outline() {
    
    let $outlines-path := common:outlines-path()
    let $outlines := collection($outlines-path)
    
    return 
        <outline xmlns="http://read.84000.co/ns/1.0" outlines-path="{$outlines-path}">
            <section id="lobby" parent-id="">
                <title xml:lang="en">{ data($outlines/o:outline[@RID = 'lobby']/o:title) }</title>
                <contents>{ $outlines/o:outline[@RID = 'lobby']/o:description[@type = "contents"]/node()  }</contents>
                <sections>
                {
                    for $section in $outlines/o:outline[@RID = 'lobby']/o:node
                    return
                        <section id="{ $section/@RID }"/>
                }
                </sections>
            </section>
            <section id="all-translated" parent-id="">
                <title xml:lang="en">{ data($outlines/o:outline[@RID = 'all-translated']/o:title) }</title>
                <contents>{ $outlines/o:outline[@RID = 'all-translated']/o:description[@type = "contents"]/node()  }</contents>
                <sections>
                {
                    for $section in $outlines/o:outline[@RID = 'all-translated']/o:node
                    return
                        <section id="{ $section/@RID }"/>
                }
                </sections>
            </section>
            {
                for $section in $outlines/o:outline | $outlines/o:outline//o:node[@type = "section" or @type = "text"]
                return
                    if($section/o:node[@type = ("section", "text", "chapter")]) then
                        <section id="{ $section/@RID }" parent-id="{ $section/../@RID }">
                            <title xml:lang="en">
                            { 
                                section:title($section, 'en')
                            }
                            </title>
                            { 
                                section:ancestors($section, 1)
                            }
                            <contents>
                            { 
                                $section/o:description[@type = "contents"]/node() 
                            }
                            </contents>
                            <sections>
                            {
                                for $section in $section/o:node[@type = "section"]
                                return
                                    <section id="{ $section/@RID }"/>
                            }
                            </sections>
                            <texts 
                                count-child-texts="{ section:count-child-texts($section) }" 
                                count-descendant-texts="{ section:count-descendant-texts($section) }" 
                                count-descendant-translated="{ section:count-descendant-translated($section) }"
                                count-descendant-inprogress="{ section:count-descendant-inprogress($section) }">
                            {
                                for $text in $section/o:node[@type = "text"] | $section/o:node[@type = "chapter"]
                                return
                                    <child-text type="{ $text/@type }" id="{ $text/@RID }" count-chapters="{ count($text/o:node[@type = "chapter"]) }"/>
                            }
                            </texts>
                        </section>
                    else 
                        ()
                }
        </outline>
};

declare function outline:progress($status as xs:string, $sort as xs:string) as node() {

    let $outlines-path := common:outlines-path()
    let $outline := collection($outlines-path)//o:outline[@RID eq "O1JC11494"]
    
    let $all-texts := for $text in $outline//o:node[@type = ("text", "chapter")][not(o:node[@type = "chapter"])]
    return
        <text xmlns="http://read.84000.co/ns/1.0" type="{ $text/@type }" id="{ $text/@RID }">
            { text:toh($text) }
            { text:title($text) }
            { text:location($text, $outline) }
            { text:status($text) }
        </text>
    
    let $all-text-count := count($all-texts)
    let $translated-text-count := count($all-texts[m:status/text() = ('available', 'missing')])
    let $in-progress-text-count := count($all-texts[m:status/text() = ('in-progress')])
    let $commissioned-text-count := $translated-text-count + $in-progress-text-count
    let $not-started-text-count := $all-text-count - $commissioned-text-count
    
    let $all-page-count := 
        sum(
            for $count in $outline//o:volumes/o:volume/@count-pages
            return $count - $outline//o:volumes/@title-pages-per-volume
        )
    let $translated-page-count := sum($all-texts[m:status/text() = ('available', 'missing')]/m:location[@count-pages != '?']/@count-pages)
    let $in-progress-page-count := sum($all-texts[m:status/text() = ('in-progress')]/m:location[@count-pages != '?']/@count-pages)
    let $commissioned-page-count := $translated-page-count + $in-progress-page-count
    let $not-started-page-count := $all-page-count - $commissioned-page-count
    
    let $texts := 
        if($status eq 'translated') then 
            $all-texts[m:status/text() = ('available', 'missing')]
        else if($status eq 'in-progress') then
            $all-texts[m:status/text() = ('in-progress')]
        else if($status eq 'not-started') then
            $all-texts[m:status/text() = ('not-started')]
        else
            $all-texts
    
    let $texts-count := count($texts)
    let $texts-pages-count := sum($texts/m:location/@count-pages)
    
    return 
        <progress xmlns="http://read.84000.co/ns/1.0">
            <summary>
                <texts count="{ $all-text-count }" translated="{ $translated-text-count }" in-progress="{ $in-progress-text-count }" commissioned="{ $commissioned-text-count }" not-started="{ $not-started-text-count }"/>
                <pages count="{ $all-page-count }" translated="{ $translated-page-count }" in-progress="{ $in-progress-page-count }" commissioned="{ $commissioned-page-count }" not-started="{ $not-started-page-count }"/>
            </summary>
            <texts count="{ $texts-count }" count-pages="{ $texts-pages-count }"  status="{ $status }" sort="{ $sort }">
            { 
                if($sort eq 'toh') then
                    for $text in $texts
                        order by xs:integer($text/m:toh/@first), xs:integer($text/m:toh/@sub)
                    return $text
                else if($sort eq 'longest') then
                    for $text in $texts
                        order by xs:integer($text/m:location/@count-pages) descending
                    return $text
                else if($sort eq 'shortest') then
                    for $text in $texts
                        order by xs:integer($text/m:location/@count-pages)
                    return $text
                else
                    $texts
            }
            </texts>
        </progress>

    
};

declare function outline:volumes(){

    let $title-pages := 3
    let $ekangyur := collection('/db/apps/eKangyur/data')
    return
        <outline:volumes title-pages-per-volume="{ $title-pages }" >
        {
            for $doc in $ekangyur//tei:TEI
            let $ekangyur-id := $doc//tei:publicationStmt//tei:idno[@type = 'TBRC_TEXT_RID']/text()
            let $title := $doc//tei:titleStmt/tei:title/text() 
            let $volume := xs:integer(substring-before(substring-after($title, '['),']'))
            let $count-pages := max($doc//tei:p/@n)
            order by $volume
            return 
                <outline:volume 
                    number="{ $volume }" 
                    count-pages="{ $count-pages }" 
                    ekangyur-id="{ $ekangyur-id  }" >
                    { $title }
                </outline:volume>
        }
        </outline:volumes>
  
};


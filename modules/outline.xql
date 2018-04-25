xquery version "3.1";

module namespace outline="http://read.84000.co/outline";

declare namespace o = "http://www.tbrc.org/models/outline";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace m = "http://read.84000.co/ns/1.0";

import module namespace common="http://read.84000.co/common" at "common.xql";
import module namespace section="http://read.84000.co/outline-section" at "outline-section.xql";
import module namespace text="http://read.84000.co/outline-text" at "outline-text.xql";
import module namespace sponsors="http://read.84000.co/sponsors" at "sponsors.xql";
import module namespace functx="http://www.functx.com";

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

declare function outline:progress($status as xs:string, $sort as xs:string, $range as xs:string, $filter as xs:string) as node() {

    let $outlines-path := common:outlines-path()
    let $outline := collection($outlines-path)//o:outline[@RID eq "O1JC11494"]
    
    let $all-texts := for $text in $outline//o:node[@type = ("text", "chapter")][not(o:node[@type = "chapter"])]
        let $toh := text:toh($text)
    return
        <text xmlns="http://read.84000.co/ns/1.0" type="{ $text/@type }" id="{ $text/@RID }">
            { $toh }
            { sponsors:sponsored-sutra($toh) }
            { text:title($text) }
            { text:location($text, $outline) }
            { text:status($text) }
        </text>
    
    let $all-text-count := count($all-texts)
    let $published-text-count := count($all-texts[m:status/text() = ('available', 'missing')])
    let $in-progress-text-count := count($all-texts[m:status/text() = ('in-progress')])
    let $sponsored-text-count := count($all-texts[m:sponsored/text() = ('full', 'part')])
    let $commissioned-text-count := $published-text-count + $in-progress-text-count
    let $not-started-text-count := $all-text-count - $commissioned-text-count
    
    let $all-page-count := 
        sum(
            for $count in $outline//o:volumes/o:volume/@count-pages
            return $count - $outline//o:volumes/@title-pages-per-volume
        )
    let $published-page-count := sum($all-texts[m:status/text() = ('available', 'missing')]/m:location[@count-pages != '?']/@count-pages)
    let $in-progress-page-count := sum($all-texts[m:status/text() = ('in-progress')]/m:location[@count-pages != '?']/@count-pages)
    let $sponsored-page-count := sum($all-texts[m:sponsored/text() = ('full', 'part')]/m:location[@count-pages != '?']/@count-pages)
    let $commissioned-page-count := $published-page-count + $in-progress-page-count
    let $not-started-page-count := $all-page-count - $commissioned-page-count
    
    let $status-texts := 
        if($status eq 'published') then 
            $all-texts[m:status/text() = ('available', 'missing')]
        else if($status eq 'in-progress') then
            $all-texts[m:status/text() = ('in-progress')]
        else if($status eq 'not-started') then
            $all-texts[m:status/text() = ('not-started')]
        else
            $all-texts
    
    let $page-size-ranges :=
        <page-size-ranges xmlns="http://read.84000.co/ns/1.0">
            <range id="1" min="0" max="99"/>
            <range id="2" min="100" max="149"/>
            <range id="3" min="150" max="199"/>
            <range id="4" min="200" max="10000"/>
        </page-size-ranges>
        
    let $selected-range := $page-size-ranges//m:range[xs:string(@id) eq $range]
    
    let $range-texts := 
        if($selected-range) then
            $status-texts[m:location/@count-pages[. >= xs:integer($selected-range/@min)][. <= xs:integer($selected-range/@max)]]
        else
            $status-texts
    
    let $texts := 
        if($filter eq 'sponsored')then
            $range-texts[m:sponsored/text() = ('full', 'part')]
        else if($filter eq 'part-sponsored')then
            $range-texts[m:sponsored/text() = ('part')]
        else if($filter eq 'not-sponsored')then
            $range-texts[not(m:sponsored/text()) or m:sponsored/text() eq '']
        else
            $range-texts
            
    let $texts-count := count($texts)
    let $texts-pages-count := sum($texts/m:location/@count-pages)
    
    return 
        <progress xmlns="http://read.84000.co/ns/1.0">
            {
                $page-size-ranges
            }
            <summary>
                <texts 
                    count="{ $all-text-count }" 
                    published="{ $published-text-count }" 
                    in-progress="{ $in-progress-text-count }" 
                    sponsored="{ $sponsored-text-count }" 
                    commissioned="{ $commissioned-text-count }" 
                    not-started="{ $not-started-text-count }"/>
                <pages 
                    count="{ $all-page-count }" 
                    published="{ $published-page-count }" 
                    in-progress="{ $in-progress-page-count }" 
                    sponsored="{ $sponsored-page-count }" 
                    commissioned="{ $commissioned-page-count }" 
                    not-started="{ $not-started-page-count }"/>
            </summary>
            <texts 
                count="{ $texts-count }" 
                count-pages="{ $texts-pages-count }"  
                status="{ $status }" 
                sort="{ $sort }" 
                range="{ $range }" 
                filter="{ $filter }">
            { 
                if($sort = ('toh', '')) then
                    for $text in $texts
                        order by if($text/m:toh/@first eq '0') then 1 else 0, xs:integer($text/m:toh/@first), xs:integer($text/m:toh/@sub)
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


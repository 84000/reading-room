xquery version "3.1";

module namespace translation="http://read.84000.co/translation";

declare namespace m = "http://read.84000.co/ns/1.0";
declare namespace o = "http://www.tbrc.org/models/outline";
declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace functx="http://www.functx.com";
import module namespace common="http://read.84000.co/common" at "common.xql";
import module namespace converter="http://tbrc.org/xquery/ewts2unicode" at "java:org.tbrc.xquery.extensions.EwtsToUniModule";
import module namespace text="http://read.84000.co/outline-text" at "outline-text.xql";
import module namespace section="http://read.84000.co/outline-section" at "outline-section.xql";

declare function translation:id($translation as node()){
    $translation//tei:publicationStmt/tei:idno/@xml:id/string()
};

declare function translation:tei($translation-id) {
    (:
    This is controls the method of looking up the resource-id 
    from the controller and finding the document.
    In this version this is done by looking for the tei:idno in 
    the document but can be expanded to allow for other methods
    such as readable urls.
    :)
    
    collection(common:translations-path())//tei:TEI[lower-case(tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno/@xml:id/string()) eq $translation-id]
};

declare function translation:title($translation as node()) as xs:string* {
    normalize-space(data($translation//tei:titleStmt/tei:title[@type='mainTitle'][lower-case(@xml:lang) = ('eng', 'en')]))
};

declare function translation:title-listing($translation-title as xs:string*) as xs:string* {
    let $first-word := substring-before($translation-title, ' ')
    return
        if(lower-case($first-word) = ('the')) then
            concat(substring-after($translation-title, concat($first-word, ' ')), ', ', $first-word)
        else
            $translation-title
};

declare function translation:titles($translation as node()) as node()* {
    <titles xmlns="http://read.84000.co/ns/1.0">
        <title xml:lang="en">{ normalize-space(data($translation//tei:titleStmt/tei:title[@type='mainTitle'][lower-case(@xml:lang) = ('eng', 'en')])) }</title>
        <title xml:lang="bo">{ normalize-space(data($translation//tei:titleStmt/tei:title[@type='mainTitle'][lower-case(@xml:lang) = 'bo'])) }</title>
        <title xml:lang="sa-ltn">{ normalize-space(data($translation//tei:titleStmt/tei:title[@type='mainTitle'][lower-case(@xml:lang)='sa-ltn'])) }</title>
    </titles>
};

declare function translation:long-titles($translation as node()) as node()* {
    <long-titles xmlns="http://read.84000.co/ns/1.0">
        <title xml:lang="en">{ normalize-space(data($translation//tei:titleStmt/tei:title[@type='longTitle'][lower-case(@xml:lang) = ('eng', 'en')])) }</title>
        <title xml:lang="bo">{ normalize-space(data($translation//tei:titleStmt/tei:title[@type='longTitle'][lower-case(@xml:lang) = 'bo'])) }</title>
        <title xml:lang="bo-ltn">{ normalize-space(data($translation//tei:titleStmt/tei:title[@type='longTitle'][lower-case(@xml:lang) = 'bo-ltn'])) }</title>
        <title xml:lang="sa-ltn">{ normalize-space(data($translation//tei:titleStmt/tei:title[@type='longTitle'][lower-case(@xml:lang) = 'sa-ltn'])) }</title>
    </long-titles>
};

declare function translation:source($translation as node()) as node()* {
    <source xmlns="http://read.84000.co/ns/1.0">
        <toh>{ normalize-space(data($translation//tei:sourceDesc/tei:bibl/tei:ref)) }</toh>
        <series>{ normalize-space(data($translation//tei:sourceDesc/tei:bibl/tei:series)) }</series>
        <scope>{ normalize-space(data($translation//tei:sourceDesc/tei:bibl/tei:biblScope)) }</scope>
        <range>{ normalize-space(data($translation//tei:sourceDesc/tei:bibl/tei:citedRange)) }</range>
        <authors>
        {
            for $author in $translation//tei:sourceDesc/tei:bibl/tei:author
            return 
                <author>{ normalize-space($author/text()) }</author>
        }
        </authors>
    </source>
};

declare function translation:translation($translation as node(), $doc-type as xs:string) as node()* {
    <translation xmlns="http://read.84000.co/ns/1.0">
        <authors>
            {
                for $author in $translation//tei:titleStmt/tei:author[not(@role = 'translatorMain')]
                return 
                    <author>{ normalize-space($author/text()) }</author>
            }
            <summary>{ common:html($translation//tei:titleStmt/tei:author[@role = 'translatorMain'][1]/node(), $doc-type, false()) }</summary>
        </authors>
        <editors>
        {
            for $editor in $translation//tei:titleStmt/tei:editor
            return 
                <editor>{ normalize-space($editor/text()) }</editor>
        }
        </editors>
        <edition>{ common:html($translation//tei:editionStmt/tei:edition[1]/node(), $doc-type, false()) }</edition>
        <license img-url="{ $translation//tei:publicationStmt/tei:availability/tei:licence/tei:graphic/@url }">
        {
            common:html-paragraphs($translation//tei:publicationStmt/tei:availability/tei:licence , 'l', $doc-type, false()) 
        }
        </license>
        <publication-statement>
        {
            common:html($translation//tei:publicationStmt/tei:publisher, $doc-type, false()) 
        }
        </publication-statement>
    </translation>
};

declare function translation:summary($translation as node(), $doc-type as xs:string) as node()* {
    <summary xmlns="http://read.84000.co/ns/1.0">
    { 
        common:html-paragraphs($translation//tei:front//*[@type='summary'], 's', $doc-type, true()) 
    }
    </summary>
};

declare function translation:acknowledgment($translation as node(), $doc-type as xs:string) as node()* {
    <acknowledgment xmlns="http://read.84000.co/ns/1.0">
    { 
        common:html-paragraphs($translation//tei:front//*[@type='acknowledgment'], 'ac', $doc-type, false()) 
    }
    </acknowledgment>
};

declare function translation:introduction($translation as node(), $doc-type as xs:string) as node()* {
    <introduction xmlns="http://read.84000.co/ns/1.0">
    { 
        common:html-paragraphs($translation//tei:front//*[@type='introduction'], 'i', $doc-type, true())
    }
    </introduction>
};

declare function translation:prologue($translation as node(), $doc-type as xs:string) as node()* {
    <prologue xmlns="http://read.84000.co/ns/1.0">
    { 
        common:html-paragraphs($translation//tei:body//*[@type='prologue' or tei:head/text()[lower-case(.) = "prologue"]], 'p', $doc-type, true())
    }
    </prologue>
};

declare function translation:body($translation as node(), $doc-type as xs:string) as node()* {
    <body xmlns="http://read.84000.co/ns/1.0">
        <honoration>{ data($translation//tei:body/*[@type='translation']/tei:head[@type='titleHon']) }</honoration>
        <main-title>{ data($translation//tei:body/*[@type='translation']/tei:head[@type='titleMain']) }</main-title>
        { 
            for $chapter at $chapter-index in $translation//tei:body//*[@type='translation']/*[@type=('section', 'chapter')][not(tei:head/text()[lower-case(.) = "prologue"])]
            return
                <chapter chapter-index="{ $chapter-index }">
                   {
                       common:html-paragraphs($chapter, xs:string($chapter-index), $doc-type, true())
                   }
                </chapter>
        }
    </body>
};

declare function translation:colophon($translation as node(), $doc-type as xs:string) as node()* {
    <colophon xmlns="http://read.84000.co/ns/1.0">
    { 
        common:html-paragraphs($translation//tei:body//*[@type='colophon'], 'c', $doc-type, true())
    }
    </colophon>
};

declare function translation:notes($translation as node(), $doc-type as xs:string) as node()* {
    <notes xmlns="http://read.84000.co/ns/1.0">
    {
        for $note in $translation//tei:text//tei:note
        return
            <note index="{ $note/@index/string() }" uid="{ $note/@xml:id/string() }">
            {  
                common:html($note/node(), $doc-type, true())
            }
            </note>
    }
    </notes>
};

declare function translation:abbreviations($translation as node(), $doc-type as xs:string) as node()* {
    <abbreviations xmlns="http://read.84000.co/ns/1.0">
    {
        for $item in $translation//tei:list[@type='abbreviations']/tei:item
        return
            <item>
                <abbreviation>{ normalize-space($item/tei:abbr/text()) }</abbreviation>
                <explanation>{ common:html($item/tei:expan/node(), $doc-type, false()) }</explanation>
            </item>
    }
    </abbreviations>
};

declare function translation:bibliography($translation as node(), $doc-type as xs:string) as node()* {
    <bibliography xmlns="http://read.84000.co/ns/1.0">
    {
        for $section in $translation//tei:back/*[@type='listBibl']//*[@type='section']
        return
            <section>
                <title>{ $section/tei:head[@type='section']/text() }</title>
                {
                    for $item in $section/tei:bibl
                    return
                        <item>{ common:html($item/node(), $doc-type, false()) }</item>
                }
            </section>
    }
    </bibliography>
};

declare function translation:glossary($translation as node(), $doc-type as xs:string) as node()* {
    <glossary xmlns="http://read.84000.co/ns/1.0">
    {
        for $item in $translation//tei:back//*[@type='glossary']//tei:gloss
        return
            <item 
                uid="{ $item/@xml:id/string() }" 
                type="{ $item/@type/string() }" 
                mode="{ $item/@mode/string() }">
                <term xml:lang="en">{ normalize-space(functx:capitalize-first(data($item/tei:term[@xml:lang eq 'en'][not(@type)] | $item/tei:term[not(@xml:lang)][not(@type)]))) }</term>
                <term xml:lang="bo">{ data($item/tei:term[@xml:lang = 'bo'][not(@type)]) }</term>
                <term xml:lang="bo-ltn">{ common:bo-ltn(data($item/tei:term[@xml:lang = 'Bo-Ltn'][not(@type)])) }</term>
                <term xml:lang="sa-ltn">{ data($item/tei:term[@xml:lang = 'Sa-Ltn'][not(@type)]) }</term>
                <definitions>
                {
                    for $definition in $item/tei:term[@type = 'definition']
                    return
                        <definition>{ common:html($definition/node(), $doc-type, false()) }</definition>
                }
                </definitions>
                <alternatives>
                {
                    for $alternative in $item/tei:term[@type = 'alternative']
                    return
                        <alternative xml:lang="{ lower-case($alternative/@xml:lang) }">
                        { 
                            normalize-space(data($alternative)) 
                        }
                        </alternative>
                }
                </alternatives>
            </item>
    }
    </glossary>
};

declare function translation:appendix($translation as node(), $doc-type as xs:string) as node()* {
    <appendix xmlns="http://read.84000.co/ns/1.0">
    { 
        let $count-appendix := 
            count($translation//tei:back//*[@type='appendix']/*[@type = 'prologue' or tei:head[lower-case(text()) eq "appendix prologue"]])
            
        for $chapter at $chapter-index in $translation//tei:back//*[@type='appendix']/*[@type=('section', 'chapter', 'prologue')]
            let $chapter-number := xs:string($chapter-index - $count-appendix)
        return
            if($chapter/tei:head[lower-case(text()) eq "appendix prologue"])then
                <prologue chapter-index="p">
                   {
                       common:html-paragraphs($chapter, 'app', $doc-type, true())
                   }
                </prologue>
            else
                <chapter chapter-index="{ $chapter-number }">
                   {
                       common:html-paragraphs($chapter, concat('ap', $chapter-number), $doc-type, true())
                   }
                </chapter>
    }
    </appendix>
};

declare function translation:downloads($translation-id as xs:string) as node()* {
    <downloads xmlns="http://read.84000.co/ns/1.0">
    {
        if(util:binary-doc-available(concat(common:data-path(), '/pdf/', $translation-id ,'.pdf'))) then
            <download type="pdf" url="{ concat('/data/pdf/', $translation-id ,'.pdf') }" filename="{ concat($translation-id, '.pdf') }"/>
        else
            ()
    }
    {
        if(util:binary-doc-available(concat(common:data-path(), '/epub/', $translation-id ,'.epub'))) then
            <download type="epub" url="{ concat('/data/epub/', $translation-id ,'.epub') }" filename="{ concat($translation-id, '.epub') }"/>
        else
            ()
    }
    </downloads>
};

declare function translation:update($translation as node(), $request-parameters as xs:string*){

for $request-parameter in $request-parameters

    let $node := 
        if($request-parameter eq 'title-en') then
            $translation//tei:titleStmt/tei:title[@type='mainTitle'][lower-case(@xml:lang)= ('eng', 'en')]
        else if($request-parameter eq 'title-bo') then
            $translation//tei:titleStmt/tei:title[@type='mainTitle'][lower-case(@xml:lang)='bo']
        else if($request-parameter eq 'title-sa') then
            $translation//tei:titleStmt/tei:title[@type='mainTitle'][lower-case(@xml:lang)='sa-ltn']
        else if($request-parameter eq 'title-long-en') then
            $translation//tei:titleStmt/tei:title[@type='longTitle'][lower-case(@xml:lang)= ('eng', 'en')]
        else if($request-parameter eq 'title-long-bo') then
            $translation//tei:titleStmt/tei:title[@type='longTitle'][lower-case(@xml:lang)='bo']
        else if($request-parameter eq 'title-long-bo-ltn') then
            $translation//tei:titleStmt/tei:title[@type='longTitle'][lower-case(@xml:lang)='bo-ltn']
        else if($request-parameter eq 'title-long-sa-ltn') then
            $translation//tei:titleStmt/tei:title[@type='longTitle'][lower-case(@xml:lang)='sa-ltn']
        else if($request-parameter eq 'toh') then
            $translation//tei:sourceDesc/tei:bibl/tei:ref
        else if($request-parameter eq 'series') then
            $translation//tei:sourceDesc/tei:bibl/tei:series
        else if($request-parameter eq 'scope') then    
            $translation//tei:sourceDesc/tei:bibl/tei:biblScope
        else if($request-parameter eq 'range') then
            $translation//tei:sourceDesc/tei:bibl/tei:citedRange
        else
            ()
            
    let $new-value := request:get-parameter($request-parameter, '')
    
    return
        if($new-value and $node) then
            <updated xmlns="http://read.84000.co/ns/1.0" node="{ $request-parameter }">
            {
                update replace $node/text() with $new-value 
            }
            </updated>
         else if($new-value) then
            <updated xmlns="http://read.84000.co/ns/1.0" node="{ $request-parameter }">
            {
            
                if($request-parameter eq 'title-en') then
                    update insert <title type='mainTitle' xml:lang='en' xmlns="http://www.tei-c.org/ns/1.0">{ $new-value }</title> 
                        into $translation//tei:titleStmt/tei:title
                else if($request-parameter eq 'title-bo') then
                    update insert <title type='mainTitle' xml:lang='bo' xmlns="http://www.tei-c.org/ns/1.0">{ $new-value }</title> 
                        into $translation//tei:titleStmt/tei:title
                else if($request-parameter eq 'title-sa') then
                    update insert <title type='mainTitle' xml:lang='Sa-Ltn' xmlns="http://www.tei-c.org/ns/1.0">{ $new-value }</title> 
                        into $translation//tei:titleStmt/tei:title
                else if($request-parameter eq 'title-long-en') then
                    update insert <title type='longTitle' xml:lang='en' xmlns="http://www.tei-c.org/ns/1.0">{ $new-value }</title> 
                        into $translation//tei:titleStmt/tei:title
                else if($request-parameter eq 'title-long-bo') then
                    update insert <title type='longTitle' xml:lang='bo' xmlns="http://www.tei-c.org/ns/1.0">{ $new-value }</title> 
                        into $translation//tei:titleStmt/tei:title
                else if($request-parameter eq 'title-long-bo-ltn') then
                    update insert <title type='longTitle' xml:lang='Bo-Ltn' xmlns="http://www.tei-c.org/ns/1.0">{ $new-value }</title> 
                        into $translation//tei:titleStmt/tei:title
                else if($request-parameter eq 'title-long-sa-ltn') then
                    update insert <title type='longTitle' xml:lang='Sa-Ltn' xmlns="http://www.tei-c.org/ns/1.0">{ $new-value }</title> 
                        into $translation//tei:titleStmt/tei:title
                else if($request-parameter eq 'toh') then
                    update insert <ref xmlns="http://www.tei-c.org/ns/1.0">{ $new-value }</ref> 
                        into $translation//tei:sourceDesc/tei:bibl
                else if($request-parameter eq 'series') then
                    update insert <series  xmlns="http://www.tei-c.org/ns/1.0">{ $new-value }</series> 
                        into $translation//tei:sourceDesc/tei:bibl
                else if($request-parameter eq 'scope') then    
                    update insert <biblScope  xmlns="http://www.tei-c.org/ns/1.0">{ $new-value }</biblScope> 
                        into $translation//tei:sourceDesc/tei:bibl
                else if($request-parameter eq 'range') then
                    update insert <citedRange  xmlns="http://www.tei-c.org/ns/1.0">{ $new-value }</citedRange> 
                        into $translation//tei:sourceDesc/tei:bibl
                else
                    ()
            }
            </updated>
         else if($request-parameter eq 'authors') then
            
            let $authours := $translation//tei:sourceDesc/tei:bibl/tei:author
            for $position in 1 to (count($authours) + 1)
                let $request-parameter-n := concat('author-', $position)
                let $new-value := request:get-parameter($request-parameter-n, 'not-posted')
                let $node := $authours[$position]
            return
                if($new-value != 'not-posted') then
                    if($new-value and $node) then 
                        <updated xmlns="http://read.84000.co/ns/1.0" node="{ $request-parameter-n }">
                        {
                            update replace $node/text() with $new-value
                        }
                        </updated>
                    else if($new-value) then
                        <updated xmlns="http://read.84000.co/ns/1.0" node="{ $request-parameter-n }">
                        {
                            update insert <author role="translatorTib" xmlns="http://www.tei-c.org/ns/1.0">{ $new-value }</author> 
                                into $translation//tei:sourceDesc/tei:bibl
                        }
                        </updated>
                    else if($node) then 
                        <updated xmlns="http://read.84000.co/ns/1.0" node="{ $request-parameter-n }">
                        {
                            update delete $node
                        }
                        </updated>
                    else
                        ()
                 else 
                    ()
                    
         else
            ()
             
             
        
};

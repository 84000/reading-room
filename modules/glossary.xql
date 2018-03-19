xquery version "3.1" encoding "UTF-8";
(:
    Returns the cumulative glossary xml
    -------------------------------------------------------------
:)
module namespace glossary="http://read.84000.co/glossary";

declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace common="http://read.84000.co/common" at "common.xql";
import module namespace translation="http://read.84000.co/translation" at "translation.xql";
import module namespace functx="http://www.functx.com";

declare function glossary:ft-options() as node() {
    <options>
        <default-operator>and</default-operator>
        <phrase-slop>0</phrase-slop>
        <leading-wildcard>no</leading-wildcard>
    </options>
};

declare function glossary:ft-query($string as xs:string) as node() {
    <query>
        <phrase occur="must">{ $string }</phrase>
    </query>
};

declare function glossary:glossary-terms($type as xs:string) as node() {

    let $translations := collection(common:translations-path())
    
    return
    
        <glossary
            xmlns="http://read.84000.co/ns/1.0"
            model-type="glossary-terms"
            type="{ $type }">
        {
            for $main-term in distinct-values($translations//*[@type="glossary"]//tei:gloss[@type = $type]/tei:term[(lower-case(@xml:lang) = ('eng', 'en') or not(@xml:lang))][not(@type = 'definition')][not(@type = 'alternative')]/text()/normalize-space(.))
                
                let $normalized-term := common:normalized-chars($main-term)
                let $start-letter := substring($normalized-term, 1, 1)
                let $count-occurrences := count($translations//tei:back//tei:gloss[ft:query(tei:term[not(@type = 'definition')], glossary:ft-query($main-term), glossary:ft-options())])
                
                order by $normalized-term
            
            return
                <term start-letter="{ $start-letter }" count-items="{ $count-occurrences }">
                    <main-term>{ $main-term }</main-term>
                    <normalized-term>{ $normalized-term }</normalized-term>
                </term>
                
        }
        </glossary>
        
};

declare function glossary:glossary-items($term as xs:string) as node() {
    
    let $translations := collection(common:translations-path())
    
    return
    
        <glossary
            xmlns="http://read.84000.co/ns/1.0"
            model-type="glossary-items">
            <term>{ $term }</term>
            {
                for $item in $translations//tei:back//tei:gloss[ft:query(tei:term[not(@type = 'definition')], glossary:ft-query($term), glossary:ft-options())]
                
                    let $translation := doc(base-uri($item))
                    
                    order by ft:score($item) descending
                    
                return 
                    <item 
                        translation-id="{ translation:id($translation) }"
                        uid="{ $item/@xml:id/string() }"
                        type="{ $item/@type/string() }">
                        <title>{ $translation//tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type='mainTitle'][lower-case(@xml:lang) = ('eng', 'en')][1]/text()[1] }</title>
                        <term xml:lang="en">{ normalize-space(functx:capitalize-first(data($item/tei:term[@xml:lang eq 'en'][not(@type)] | $item/tei:term[not(@xml:lang)][not(@type)]))) }</term>
                        {
                            for $item in $item/tei:term[@xml:lang = ('bo', 'Bo-Ltn', 'Sa-Ltn')][not(@type)]
                            return 
                                <term xml:lang="{ lower-case($item/@xml:lang) }">
                                { 
                                    if ($item/@xml:lang eq 'Bo-Ltn') then
                                        common:bo-ltn($item/text())
                                    else
                                        $item/text() 
                                }
                                </term>
                        }
                        <definitions>
                        {
                            for $definition in $item/tei:term[@type = 'definition']
                            return
                                <definition>{ $definition/node() }</definition>
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

declare function glossary:item-count($translation as node()) as xs:integer {

    count($translation//*[@type='glossary']//tei:item)
    
};

declare function glossary:item-query($item as node()) as node(){
    <query>
        <bool>
        {
            for $term in 
                $item/tei:term[@xml:lang eq 'en'][not(@type)] 
                | $item/tei:term[not(@xml:lang)][not(@type)]
                | $item/tei:term[@type = 'alternative']
            let $term-str := normalize-space(data($term))
            return 
                (
                    <phrase>{ $term-str }</phrase>,
                    <phrase>{ $term-str }s</phrase>
                )
        }
        </bool>
    </query>
};

declare function glossary:translation-glossary($translation as node()) as node()* {
    <glossary xmlns="http://read.84000.co/ns/1.0">
    {
        let $options := 
            <options>
                <default-operator>and</default-operator>
                <phrase-slop>0</phrase-slop>
                <leading-wildcard>no</leading-wildcard>
            </options>
            
        for $item in $translation//tei:back//*[@type='glossary']//tei:gloss
            let $query := glossary:item-query($item)
            (: glossary:ft-query(data($item/tei:term[@xml:lang eq 'en'][not(@type)] | $item/tei:term[not(@xml:lang)][not(@type)])) :)
        return
            <item 
                uid="{ $item/@xml:id/string() }" 
                type="{ $item/@type/string() }" 
                mode="{ $item/@mode/string() }">
                <term xml:lang="en">{ normalize-space(functx:capitalize-first(data($item/tei:term[@xml:lang eq 'en'][not(@type)] | $item/tei:term[not(@xml:lang)][not(@type)]))) }</term>
                {
                    for $item in $item/tei:term[@xml:lang = ('bo', 'Bo-Ltn', 'Sa-Ltn')][not(@type)]
                    return 
                        <term xml:lang="{ lower-case($item/@xml:lang) }">
                        { 
                            if ($item/@xml:lang eq 'Bo-Ltn') then
                                common:bo-ltn($item/text())
                            else
                                $item/text() 
                        }
                        </term>
                }
                <definitions>
                {
                    for $definition in $item/tei:term[@type = 'definition']
                    return
                        <definition>{ $definition/node() }</definition>
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
                <passages>
                {
                    for $paragraph in 
                        $translation//tei:text//tei:p[ft:query(., $query, $options)]
                        | $translation//tei:text//tei:lg[ft:query(., $query, $options)]
                        | $translation//tei:text//tei:ab[ft:query(., $query, $options)]
                        | $translation//tei:text//tei:trailer[ft:query(., $query, $options)]
                    return
                        <passage tid="{ $paragraph/@tid }"/>
                }
                </passages>
            </item>
    }
    </glossary>
};

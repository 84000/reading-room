xquery version "3.1";

module namespace translations="http://read.84000.co/translations";

import module namespace common="http://read.84000.co/common" at "common.xql";
import module namespace text="http://read.84000.co/outline-text" at "outline-text.xql";
import module namespace translation="http://read.84000.co/translation" at "translation.xql";
import module namespace glossary="http://read.84000.co/glossary" at "glossary.xql";

declare namespace tei="http://www.tei-c.org/ns/1.0";

declare function translations:word-count($element as element()*) as xs:integer
{
  count(tokenize($element, '\W+')[. != ''])
};

declare function translations:translations($count-words as xs:boolean)
{
    let $outlines-path := common:outlines-path()
    let $outlines := collection($outlines-path)
    
    return
        <translations xmlns="http://read.84000.co/ns/1.0">
        {
         for $translation in collection(common:translations-path())
            let $text-id := $translation/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno/@xml:id
            let $outline-text := text:translation($text-id, $outlines)
            let $word-count := 
                if ($count-words eq true()) then
                    translations:word-count($translation/tei:TEI/tei:text)
                else
                    0
         return
             <translation 
                  uri="{ base-uri($translation) }"
                  fileName="{ util:unescape-uri(replace(base-uri($translation), ".+/(.+)$", "$1"), 'UTF-8') }"
                  id="{ $text-id }" 
                  wordCount="{ $word-count }"
                  glossaryCount="{ glossary:item-count($translation) }"
                  status="{ text:status-str($outline-text) }">
               <title>
               {
                   translation:title($translation)
               }
               </title>
               <toh>
               {
                    $translation//tei:sourceDesc/tei:bibl/tei:ref/text()
               }
               </toh>
            </translation>
        }
        </translations>
    
};
xquery version "3.0" encoding "UTF-8";

import module namespace test="http://exist-db.org/xquery/xqsuite" at "resource:org/exist/xquery/lib/xqsuite/xqsuite.xql";
import module namespace common="http://read.84000.co/common" at "../modules/common.xql";
import module namespace translation="http://read.84000.co/translation" at "../modules/translation.xql";
import module namespace translations="http://read.84000.co/translations" at "../modules/translations.xql";
import module namespace section="http://read.84000.co/outline-section" at "../modules/outline-section.xql";
import module namespace text="http://read.84000.co/outline-text" at "../modules/outline-text.xql";
import module namespace validation="http://exist-db.org/xquery/validation" at "java:org.exist.xquery.functions.validation.ValidationModule";

declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace xhtml="http://www.w3.org/1999/xhtml";

declare option exist:serialize "method=xml indent=no";

let $outlines := collection(common:outlines-path())
let $schema := doc(concat(common:data-path(), '/schema/1.0/tei.rng'))

return 

    <response 
        xmlns="http://read.84000.co/ns/1.0" 
        model-type="home"
        timestamp="{ current-dateTime() }"
        app-id="{ common:app-id() }"
        user-name="{ common:user-name() }" >
        <results>
        {
         for $translation in collection(common:translations-path())
            let $translation-id := translation:id($translation)
            let $outline-text := text:translation($translation-id, $outlines)
         return
            <translation 
                id="{ $translation-id }" 
                status="{ text:status-str($outline-text) }">
                <title>{ $translation//tei:titleStmt/tei:title[@type='mainTitle'][lower-case(@xml:lang) = ('eng', 'en')]/text() }</title>
                <tests>
                {
                    let $validation-report := validation:jing-report($translation, $schema)
                    return
                        <test>
                            <title>The text validates against the schema.</title>
                            <result>{ if($validation-report//*:status/text() eq 'valid') then 1 else 0 }</result>
                            <details>
                                { 
                                for $message in $validation-report//*:message
                                return 
                                    <detail>{$message/text()}</detail>
                                }
                            </details>
                        </test>
                }
                {
                    let $ids := $translation//@xml:id/string()
                    let $count-ids := count($ids)
                    let $distinct-ids := distinct-values($translation//@xml:id/string())
                    let $count-distinct-ids := count($distinct-ids)
                    return
                        <test>
                            <title>The text has no duplicate ids.</title>
                            <result>{ if($count-ids eq $count-distinct-ids) then 1 else 0 }</result>
                            <details>
                                {
                                    if($count-ids ne $count-distinct-ids) then
                                        for $id in $distinct-ids
                                        return
                                            if($ids[. = $id][2]) then
                                                <detail>{$ids[. = $id][2]} is duplicated</detail>
                                            else ()
                                    else ()
                                }
                            </details>
                        </test>
                }
                {
                    let $titles := translation:titles($translation)
                    return
                        <test>
                            <title>The text has 3 main titles.</title>
                            <result>{ if(count($titles/title/text()) eq 3) then 1 else 0 }</result>
                            <details>
                            { 
                                for $title in $titles/title
                                return 
                                    <detail>{$title/text()}</detail>
                            }
                            </details>
                        </test>
                }
                {
                    let $long-titles := translation:long-titles($translation)
                    return
                        <test>
                            <title>The text has 4 long titles.</title>
                            <result>{ if(count($long-titles/title/text()) eq 4) then 1 else 0 }</result>
                            <details>
                            { 
                                for $title in $long-titles/title
                                return 
                                    <detail>{$title/text()}</detail>
                            }
                            </details>
                        </test>
                }
                {
                    let $ancestors := section:ancestors($outline-text, 1)
                    return
                        <test>
                            <title>The text has a position in the outline.</title>
                            <result>{ if(count($ancestors//parent) > 0) then 1 else 0 }</result>
                            <details>
                            { 
                                for $ancestor in $ancestors//parent
                                order by $ancestor/@nesting descending
                                return 
                                    <detail>{$ancestor/title/text()}</detail>
                            }
                            </details>
                        </test>
                }
                {
                    let $source := translation:source($translation)
                    let $source-toh := $source/toh/text()
                    let $source-scope := $source/scope/text() 
                    let $source-count-authors := count($source/authors/author/text())
                    return
                        <test>
                            <title>The text has complete documentation of the source.</title>
                            <result>{ if(
                                    $source-toh
                                    and $source-scope
                                    and $source-count-authors > 0
                                ) then 1 else 0 }</result>
                            <details>
                                <detail>Toh: {$source-toh}.</detail>
                                <detail>Scope: {$source-scope}.</detail>
                                <detail>Author(s): {string-join( $source/authors/author, ', ')}.</detail>
                            </details>
                        </test>
                }
                {
                    let $translation-node := translation:translation($translation, 'www')
                    let $translation-node-edition := $translation-node/edition/text()
                    let $translation-node-count-licence-p := count($translation-node/license/xhtml:p)
                    let $translation-node-publication-statement := $translation-node/publication-statement
                    let $translation-node-count-authors := count($translation-node/authors/author)
                    let $translation-node-authors-summary := $translation-node/authors/summary
                    return
                        <test>
                            <title>The text has complete documentation of the translation.</title>
                            <result>{ if(
                                    $translation-node-edition
                                    and $translation-node-count-licence-p > 0
                                    and $translation-node-publication-statement
                                    and $translation-node-count-authors > 0
                                    and $translation-node-authors-summary
                                ) then 1 else 0 }</result>
                            <details>
                                <detail>Edition: {$translation-node-edition}.</detail>
                                <detail>License: {$translation-node-count-licence-p} paragraph(s).</detail>
                                <detail>Publication statement: {common:limit-str($translation-node-publication-statement, 50) }</detail>
                                <detail>Author(s): {string-join( $translation-node/authors/author, ', ')}.</detail>
                                <detail>Author summary: {common:limit-str($translation-node-authors-summary, 50) }</detail>
                            </details>
                        </test>
                }
                {
                    let $summary := translation:summary($translation, 'www')
                    let $summary-count-tei-p := count($translation//*[@type = 'summary']//*[self::tei:p | self::tei:l])
                    let $summary-count-html-p := count($summary//xhtml:p)
                    return
                        <test>
                            <title>The summary has at least 1 paragraph and the same number of paragraphs in the TEI as in the HTML.</title>
                            <result>{ if(
                                    $summary-count-html-p > 0
                                    and $summary-count-html-p = $summary-count-tei-p
                                ) then 1 else 0 }</result>
                            <details>
                                <detail>{$summary-count-tei-p} paragraph(s) in the TEI summary.</detail>
                                <detail>{$summary-count-html-p} paragraph(s) in the HTML summary.</detail>
                            </details>
                        </test>
                }
                {
                    let $acknowledgment := translation:acknowledgment($translation, 'www')
                    let $acknowledgment-count-tei-p := count($translation//*[@type = 'acknowledgment']//*[self::tei:p | self::tei:l])
                    let $acknowledgment-count-html-p := count($acknowledgment//xhtml:p)
                    return
                        <test>
                            <title>The acknowledgment has at least 1 paragraph and the same number of paragraphs in the TEI as in the HTML.</title>
                            <result>{ if(
                                    $acknowledgment-count-html-p > 0
                                    and $acknowledgment-count-html-p = $acknowledgment-count-tei-p
                                ) then 1 else 0 }</result>
                            <details>
                                <detail>{$acknowledgment-count-tei-p} paragraph(s) in the TEI acknowledgment.</detail>
                                <detail>{$acknowledgment-count-html-p} paragraph(s) in the HTML acknowledgment.</detail>
                            </details>
                        </test>
                }
                {
                    let $introduction := translation:introduction($translation, 'www')
                    let $introduction-count-tei-p := count($translation//*[@type = 'introduction']//*[self::tei:p | self::tei:l])
                    let $introduction-count-html-p := count($introduction//xhtml:p)
                    let $introduction-count-tei-list := count($translation//*[@type = 'introduction']//tei:list)
                    let $introduction-count-html-list := count($introduction//xhtml:ul)
                    return
                        <test>
                            <title>The introduction has at least 1 paragraph and the same number of paragraphs and lists in the HTML as in the TEI.</title>
                            <result>{ if(
                                    $introduction-count-html-p > 0
                                    and $introduction-count-html-p = $introduction-count-tei-p
                                    and $introduction-count-html-list = $introduction-count-tei-list
                                ) then 1 else 0 }</result>
                            <details>
                                <detail>{$introduction-count-tei-p} paragraph(s) in the TEI.</detail>
                                <detail>{$introduction-count-html-p} paragraph(s) in the HTML.</detail>
                                <detail>{$introduction-count-tei-list} list(s) in the TEI.</detail>
                                <detail>{$introduction-count-html-list} list(s) in the HTML.</detail>
                            </details>
                        </test>
                }
                {
                    let $prologue := translation:prologue($translation, 'www')
                    let $tei-prologue := $translation//tei:body//*[@type='prologue' or tei:head/text()[lower-case(.) = "prologue"]]
                    let $prologue-count-tei-p := count($tei-prologue//*[self::tei:p | self::tei:l])
                    let $prologue-count-html-p := count($prologue//xhtml:p)
                    let $prologue-count-tei-milestones := count($tei-prologue//tei:milestone)
                    let $prologue-count-html-milestones := count($prologue//xhtml:a[@class = 'milestone'])
                    return
                        <test>
                            <title>The introduction has at least 1 paragraph and the same number of paragraphs and lists in the HTML as in the TEI.</title>
                            <result>{ if(
                                    $prologue-count-html-p = $prologue-count-tei-p
                                    and $prologue-count-tei-milestones = $prologue-count-html-milestones
                                ) then 1 else 0 }</result>
                            <details>
                                <detail>{$prologue-count-tei-p} paragraph(s) in the TEI.</detail>
                                <detail>{$prologue-count-html-p} paragraph(s) in the HTML.</detail>
                                <detail>{$prologue-count-tei-milestones} milestone(s) in the TEI.</detail>
                                <detail>{$prologue-count-html-milestones} milestone(s) in the HTML.</detail>
                            </details>
                        </test>
                }
                {
                    let $body := translation:body($translation, 'www')
                    let $tei-chapters := $translation//tei:body//*[@type='translation']/*[@type=('section', 'chapter')][not(tei:head/text()[lower-case(.) = "prologue"])]
                    let $body-count-tei-chapters := count($tei-chapters)
                    let $body-count-html-chapters := count($body/chapter)
                    let $body-count-tei-p := count($tei-chapters//*[self::tei:p | self::tei:l | self::tei:ab | self::tei:trailer | self::tei:label])
                    let $body-count-html-p := count($body//xhtml:p)
                    let $body-count-tei-milestones := count($tei-chapters//tei:milestone)
                    let $body-count-html-milestones := count($body//xhtml:a[@class = 'milestone'])
                    let $body-main-title := $body/main-title/text()
                    let $body-honoration := $body/honoration/text()
                    return
                        <test>
                            <title>The text body has at least 1 chapter with 1 paragraph, a main title and an honoration. It has the same number of chapters, paragraphs and milestones in the HTML as in the TEI.</title>
                            <result>{ if(
                                    $body-count-tei-chapters = $body-count-html-chapters
                                    and $body-count-tei-p = $body-count-html-p
                                    and $body-count-tei-milestones = $body-count-html-milestones
                                    and $body-main-title
                                    (:and $body-honoration:)
                                ) then 1 else 0 }</result>
                            <details>
                                <detail>Main title: {$body-main-title}.</detail>
                                <detail>Main honoration: {$body-honoration}.</detail>
                                <detail>{$body-count-tei-chapters} chapter(s) in the TEI.</detail>
                                <detail>{$body-count-html-chapters} chapter(s) in the HTML.</detail>
                                <detail>{$body-count-tei-p} paragraphs(s) in the TEI.</detail>
                                <detail>{$body-count-html-p} paragraphs(s) in the HTML.</detail>
                                <detail>{$body-count-tei-milestones} milestone(s) in the TEI.</detail>
                                <detail>{$body-count-html-milestones} milestone(s) in the HTML.</detail>
                            </details>
                        </test>
                }
                {
                    let $colophon := translation:colophon($translation, 'www')
                    let $tei-colophon := $translation//tei:body//*[@type='colophon']
                    let $colophon-count-tei-p := count($tei-colophon//*[self::tei:p | self::tei:l | self::tei:trailer])
                    let $colophon-count-html-p := count($colophon//xhtml:p)
                    let $colophon-count-tei-milestones := count($tei-colophon//tei:milestone)
                    let $colophon-count-html-milestones := count($colophon//xhtml:a[@class = 'milestone'])
                    return
                        <test>
                            <title>The text has at least 1 paragraph in the colophon.</title>
                            <result>{ if(
                                    $colophon-count-html-p = $colophon-count-tei-p
                                    and $colophon-count-html-milestones = $colophon-count-tei-milestones
                                ) then 1 else 0 }</result>
                            <details>
                                <detail>{$colophon-count-tei-p} paragraph(s) in the TEI.</detail>
                                <detail>{$colophon-count-html-p} paragraph(s) in the HTML.</detail>
                                <detail>{$colophon-count-tei-milestones} milestones(s) in the TEI.</detail>
                                <detail>{$colophon-count-html-milestones} milestones(s) in the HTML.</detail>
                            </details>
                        </test>
                }
                {
                    let $notes := translation:notes($translation, 'www')
                    let $notes-count-html := count($notes/note)
                    let $notes-count-tei := count($translation//tei:text//tei:note)
                    return
                        <test>
                            <title>The text has at least 1 note and the same number of notes are in the TEI and the HTML.</title>
                            <result>{ if(
                                    $notes-count-html > 0
                                    and $notes-count-html = $notes-count-tei
                                ) then 1 else 0 }</result>
                            <details>
                                <detail>{$notes-count-tei} note(s) in TEI.</detail>
                                <detail>{$notes-count-html} note(s) in HTML.</detail>
                            </details>
                        </test>
                }
                {
                    let $bibliography := translation:bibliography($translation, 'www')
                    let $biblography-count-html := count($bibliography/section/item)
                    let $biblography-count-tei := count($translation//tei:back/*[@type='listBibl']//tei:bibl)
                    return
                        <test>
                            <title>The text has at least 1 bibliography section with at least 1 item  and the same number of items are in the TEI and the HTML.</title>
                            <result>{ if(
                                    $biblography-count-html > 0
                                    and $biblography-count-html = $biblography-count-tei
                                ) then 1 else 0 }</result>
                            <details>
                                <detail>{$biblography-count-tei} items(s) in TEI.</detail>
                                <detail>{$biblography-count-html} items(s) in HTML.</detail>
                            </details>
                        </test>
                }
                {
                    let $glossary := translation:glossary($translation, 'www')
                    let $glossary-count-html := count($glossary/item/term[text()] | $glossary/item/definitions/definition[text()] | $glossary/item/alternatives/alternative[text()])
                    let $glossary-count-tei := count($translation//*[@type='glossary']//tei:term[text()])
                    return
                        <test>
                            <title>The text has at least 1 glossary item and there are the same number of terms in the HTML as in the TEI</title>
                            <result>{ if(
                                    $glossary-count-html > 0
                                    and $glossary-count-html = $glossary-count-tei
                                ) then 1 else 0 }</result>
                            <details>
                                <detail>{$glossary-count-tei} term(s) in the TEI.</detail>
                                <detail>{$glossary-count-html} term(s) in the HTML.</detail>
                            </details>
                        </test>
                }
                </tests>
            </translation>
        }
        </results>
    </response>
xquery version "3.0";

module namespace common="http://read.84000.co/common";

declare namespace m="http://read.84000.co/ns/1.0";
declare namespace o = "http://www.tbrc.org/models/outline";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace xhtml = "http://www.w3.org/1999/xhtml";
declare namespace sm = "http://exist-db.org/xquery/securitymanager";

import module namespace functx="http://www.functx.com";
import module namespace converter="http://tbrc.org/xquery/ewts2unicode" at "java:org.tbrc.xquery.extensions.EwtsToUniModule";

declare function common:app-id() as xs:string {

    (:
        Single point to set the app id
        -----------------------------------
        This is the name of the collection 
        containing the app (this file).
    :)
    
    let $servlet-path := system:get-module-load-path()
    let $tokens := tokenize($servlet-path, '/')
    return 
        $tokens[last() - 2]
    
};

declare function common:root-path() as xs:string {
    concat('/db/apps/', common:app-id())
};

declare function common:log-path() as xs:string {
    '/db/env/logs'
};

declare function common:app-path() as xs:string {
    concat('/db/apps/', common:app-id(), '/app')
};

declare function common:data-path() as xs:string {
    concat(common:root-path(), '/data')
};

declare function common:translations-path() as xs:string {
    concat(common:data-path(), '/translations')
};

declare function common:outlines-path() as xs:string {
    concat(common:data-path(), '/outlines')
};

declare function common:ekangyur-path() as xs:string {
    '/db/apps/eKangyur/data/W4CZ5369'
};

declare function common:xml-lang($node) as xs:string {

    if($node/@encoding="extendedWylie") then
        "bo-ltn"
    else if($node/@lang = "tibetan" and $node/@encoding="native") then
        "bo-ltn"
    else if($node[self::o:title and not(@lang)]) then
        "bo-ltn"
    else if ($node/@lang="sanskrit") then
        "sa-ltn"
    else if ($node/@lang="english") then
        "en"
    else
        $node/@lang/string()
};

declare function common:normalized-chars($string as xs:string) as xs:string{
    let $in  := 'āḍḥīḷḹṃṇñṅṛṝṣśṭūṁ'
    let $out := 'adhillmnnnrrsstum'
    return 
        translate(lower-case($string), $in, $out)
};

declare function common:alphanumeric($string as xs:string) as xs:string* {
    replace($string, '[^a-zA-Z0-9]', '')
};

declare function common:bo-title($bo-ltn as xs:string*) as xs:string
{
    (: correct the spacing and spacing around underscores :)
    let $bo-ltn-underscores:= 
        if ($bo-ltn) then
            replace(replace(normalize-space($bo-ltn), ' __,__', '__,__'), '__,__', ' __,__')
        else
            ""
    (: convert to Tibetan unicode :)
    let $bo :=
        if ($bo-ltn-underscores ne "") then
            converter:toUnicode($bo-ltn-underscores)
        else
            ""
    
    return 
        xs:string($bo)
};

declare function common:bo-term($bo-ltn as xs:string*) as xs:string
{   
    
    (: correct the spacing and spacing around underscores :)
    let $bo-ltn-underscores:= 
        if ($bo-ltn) then
            replace(replace(normalize-space($bo-ltn), ' __,__', '__,__'), '__,__', ' __,__')
        else
            ""
    
    (: add a shad :)
    let $bo-ltn-length := string-length($bo-ltn-underscores)
    let $bo-ltn-shad :=
        if (
            (: check there isn't already a shad :)
            substring($bo-ltn-underscores, $bo-ltn-length, 1) ne "/"
            
        ) then
        
            (: these cases add a tshek and a shad :)
            if(substring($bo-ltn-underscores, ($bo-ltn-length - 2), 3) = ('ang','eng','ing','ong','ung')) then
                concat($bo-ltn-underscores, " /")
            
            (: these cases no shad :)
            else if((
                    substring($bo-ltn-underscores, ($bo-ltn-length - 1), 2) = ('ag', 'eg', 'ig', 'og', 'ug')
                )
                or (
                    substring($bo-ltn-underscores, ($bo-ltn-length - 2), 1) = ('_', ' ', 'g','d','b','m',"'")
                    and substring($bo-ltn-underscores, ($bo-ltn-length - 1), 2) = ('ga','ge','gi','go','gu','ka','ke','ki','ko','ku')
                )
            ) then
                $bo-ltn-underscores
            
            (: otherwise end in a shad :)
            else
                concat($bo-ltn-underscores, "/")
                
        else
            $bo-ltn-underscores
    
    (: convert to Tibetan unicode :)
    let $bo :=
        if ($bo-ltn-shad ne "") then
            converter:toUnicode($bo-ltn-shad)
        else
            ""
    
    return 
        xs:string($bo)
};

declare function common:bo-ltn($string as xs:string*) as xs:string
{
    if ($string) then
        replace(normalize-space($string), '__', ' ')
    else
        ""
};

declare function common:unescape($text as xs:string*) as node()* 
{
    let $html := util:parse-html($text)
    return
        if($html/HTML/xhtml:body) then
            $html/HTML/xhtml:body/node()
        else
            $html/HTML/BODY/node()
};

declare function common:search-result($nodes as node()*) as node()*
{
    for $node in $nodes
       let $parameters := <parameters></parameters>
       let $attributes := <attributes></attributes>
    return
        transform:transform(
            $node, 
            doc(concat(common:app-path(), "/xslt/search-result.xsl")), 
            $parameters, 
            $attributes, 
            'method=xml indent=no'
        )
};

declare function common:limit-str($str as xs:string*, $limit as xs:integer) as xs:string* 
{
    if(string-length($str) > $limit) then
        concat(substring($str, 1, $limit), '...')
    else
        $str
};

declare function common:epub-resource($file as xs:string) as xs:base64Binary
{
    util:binary-doc(xs:anyURI(concat(common:app-path(), '/views/epub/resources/', $file)))
};

declare function common:environment() as node()* 
{
    doc('/db/env/environment.xml')/m:environments/m:environment[@id eq common:app-id()]
};

declare function common:app-version() as xs:string {
    doc(concat(common:app-path(), '/app-config.xml'))/m:app-config/m:version/text()
};

declare function common:test-conf() as node()* 
{
    common:environment()//m:test-conf
};

declare function common:snapshot-conf() as node()* 
{
    common:environment()//m:snapshot-conf
};

declare function common:deployment-conf() as node()* 
{
    common:environment()//m:deployment-conf
};

declare function common:user-name() as xs:string* {
    let $user := sm:id()
    return
        $user//sm:real/sm:username
};

declare function common:auth-environment() as xs:boolean {
    (: Check the environment to see if we need to login :)
    if(common:environment()/@auth eq '1')then
        true()
    else
        false()
};

declare function common:app-text($key as xs:string) as node()* {
    doc(concat(common:data-path(), '/config/app-text.xml'))//m:item[@key eq $key]/child::node()
};

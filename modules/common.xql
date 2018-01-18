xquery version "3.0";

module namespace common="http://read.84000.co/common";

declare namespace m="http://read.84000.co/ns/1.0";
declare namespace o = "http://www.tbrc.org/models/outline";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace xhtml = "http://www.w3.org/1999/xhtml";
declare namespace sm = "http://exist-db.org/xquery/securitymanager";

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

declare function common:bo($bo-ltn as xs:string*) as xs:string
{
    if ($bo-ltn) then
        converter:toUnicode(concat(replace(replace(normalize-space($bo-ltn), ' __,__', '__,__'), '__,__', ' __,__'), ' '))
    else
        ""
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

declare function common:html($node as node()*, $doc-type as xs:string, $glossarize as xs:boolean) as node()*
{
    transform:transform(
        $node, 
        doc(concat(common:app-path(), "/xslt/html.xsl")), 
        <parameters>
            <param name="doc-type" value="{ $doc-type }"/>
            <param name="glossarize" value="{ $glossarize }"/>
        </parameters>
    )
};

declare function common:html-paragraphs($node as node()*, $prefix as xs:string, $doc-type as xs:string, $glossarize as xs:boolean) as node()*
{
    transform:transform(
        $node, 
        doc(concat(common:app-path(), "/xslt/html-paragraphs.xsl")), 
        <parameters>
            <param name="prefix" value="{ $prefix }"/>
            <param name="doc-type" value="{ $doc-type }"/>
            <param name="glossarize" value="{ $glossarize }"/>
        </parameters>
     )
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

declare function common:binary-resource($file as xs:string) as xs:base64Binary
{
    util:binary-doc(xs:anyURI(concat(common:app-path(), '/epub/resources/', $file)))
};

declare function common:environment(){
    doc('/db/env/environment.xml')/m:environments/m:environment[@id eq common:app-id()]
};

declare function common:snapshot-conf(){
    common:environment()//m:snapshot-conf
};

declare function common:deployment-conf(){
    common:environment()//m:deployment-conf
};

declare function common:user-name(){
    let $user := sm:id()
    return
        $user//sm:real/sm:username
};

declare function common:auth-environment(){
    (: Check the environment to see if we need to login :)
    if(common:environment()/@auth eq '1')then
        true()
    else
        false()
};

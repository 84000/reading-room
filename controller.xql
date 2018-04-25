xquery version "3.0";

declare variable $exist:path external;
declare variable $exist:resource external;
declare variable $exist:controller external;
declare variable $exist:prefix external;
declare variable $exist:root external;
declare variable $resource-id := lower-case(substring-before($exist:resource, "."));
declare variable $resource-suffix := lower-case(substring-after($exist:resource, "."));
declare variable $collection-path := lower-case(substring-before(substring-after($exist:path, "/"), "/"));
declare variable $controller-root := lower-case(substring-before(substring-after($exist:controller, "/"), "/"));

import module namespace common="http://read.84000.co/common" at "modules/common.xql";

declare function local:dispatch($model as xs:string, $view as xs:string, $parameters as node()) as node(){
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{concat($exist:controller, $model)}">
        { 
            $parameters//add-parameter 
        }
        </forward>
        {
            if($view)then
                <view>
                    <forward url="{concat($exist:controller, $view)}"/>
                </view>
            else
                ()
        }
    </dispatch>
};

declare function local:dispatch-html($model as xs:string, $view as xs:string, $parameters as node()) as node(){
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{concat($exist:controller, $model)}">
        { 
            $parameters//add-parameter 
        }
        </forward>
        <view>
            <forward servlet="XSLTServlet">
                <set-attribute name="xslt.stylesheet" value="{concat($exist:root, $exist:controller, $view)}"/>
            </forward>
        </view>
        <error-handler>
            <forward servlet="XSLTServlet">
                <set-attribute name="xslt.stylesheet" value="{concat($exist:root, $exist:controller, "/views/html/error.xsl")}"/>
            </forward>
        </error-handler>
    </dispatch>
};

declare function local:redirect($url){
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <redirect url="{ $url }"/>
    </dispatch>
};

declare function local:has-access($model) as xs:boolean {
    sm:has-access(xs:anyURI(concat(common:app-path(), $model)), 'r-x')
};

declare function local:auth($redirect){
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <!-- 
            This file has permissions. 
            If the user is not authorised then it will return 401 with a login box.
        -->
        <forward url="{concat($exist:controller, "/models/auth.xq")}">
            <add-parameter name="redirect" value="{ $redirect }"/>
        </forward>
        <view>
            <forward servlet="XSLTServlet">
                <set-attribute name="xslt.stylesheet" value="{concat($exist:root, $exist:controller, "/views/html/auth.xsl")}"/>
            </forward>
        </view>
    </dispatch>
};

(: Log the request :)
import module namespace log = "http://read.84000.co/log" at "modules/log.xql";
log:log-request(concat($exist:controller, $exist:path), $controller-root, $collection-path, $resource-id, $resource-suffix),

(: Robots :)
if (lower-case($exist:resource) = ('robots.txt')) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="../../../env/robots.txt"/>
    </dispatch>

(: If environment wants login then check there is some authentication :)
else if(not(common:auth-environment()) or sm:is-authenticated()) then
    
    (: Redirect to root :)
    if (lower-case($exist:resource) = ('index.html', 'index.htm')) then
        local:redirect("section/lobby.html")
        
    (: Redirect to resources :)
    else if ($collection-path eq "resources" or $exist:resource eq "resources") then
        local:redirect("http://resources.84000-translate.org")
    
    (: Trap no path :) (: Trap index/home :)
    else if ($exist:path = ('', '/', '/old-app/')) then
        local:dispatch-html("/models/section.xq", "/views/html/section.xsl", 
            <parameters>
                <add-parameter name="resource-id" value="lobby"/>
            </parameters>
        )
    
    (: Accept the client error without 404. It is logged above. :)
    else if (lower-case($exist:resource) eq "log-error.html") then
        <response>
            <message>logged</message>
        </response>
        
    (: Translator Tools :)
    else if (lower-case($exist:resource) eq 'translator-tools.html') then
        local:dispatch-html("/models/translator-tools.xq", "/views/html/translator-tools.xsl", <parameters/>)
        
    (: Utilities :)
    else if (lower-case($exist:resource) eq 'utilities.html') then
        if(local:has-access("/models/utilities.xq")) then
            local:dispatch-html("/models/utilities.xq", "/views/html/utilities.xsl", <parameters/>)
        else
            local:auth('utilities.html')
    
    (: Operations :)
    else if (lower-case($exist:resource) eq 'operations.html') then
        if(local:has-access("/models/operations.xq")) then
            local:dispatch-html("/models/operations.xq", "/views/html/operations.xsl", <parameters/>)
        else
            local:auth('operations.html')
            
    (: Tests :)
    else if (lower-case($exist:resource) eq 'tests.html') then
        if(local:has-access("/models/tests.xq")) then
            local:dispatch-html("/models/tests.xq", "/views/html/tests.xsl", <parameters/>)
        else
            local:auth('tests.html')
    
    (: Schema validation :)
    else if (lower-case($exist:resource) eq 'validate.html') then
        if(local:has-access("/models/validate.xq")) then
            local:dispatch-html("/models/validate.xq", "/views/html/validate.xsl", <parameters/>)
        else
            local:auth('validate.html')
    
    (: Translation Memory :)
    else if (lower-case($exist:resource) eq 'translation-memory.html') then
        if(local:has-access("/models/translation-memory.xq")) then
            local:dispatch-html("/models/translation-memory.xq", "/views/html/translation-memory.xsl", <parameters/>)
        else
            local:auth('translation-memory.html')
    
    (: Cumulative glossary download :)
    else if (lower-case($exist:resource) eq 'cumulative-glossary.zip') then
        local:dispatch("/models/cumulative-glossary.xq", "", <parameters/>)
    
    (: .tmx files :)
    else if (lower-case($exist:resource) eq 'tmx.zip') then
        local:dispatch("/models/tmx-files.xq", "", <parameters/>)
    
    (: Spreadsheet test :)
    else if (lower-case($exist:resource) eq 'spreadsheet.xlsx') then
        local:dispatch("/views/spreadsheet/spreadsheet.xq", "", <parameters/>)

    (: Translation :)
    else if ($collection-path eq "translation") then
        if ($resource-suffix eq 'tei') then
            local:dispatch("/models/translation-tei.xq", "",
                <parameters xmlns="http://exist.sourceforge.net/NS/exist">
                    <add-parameter name="resource-id" value="{$resource-id}"/>
                </parameters>
            )
        else if ($resource-suffix eq 'html') then
            local:dispatch-html("/models/translation.xq", "/views/html/translation.xsl", 
                <parameters xmlns="http://exist.sourceforge.net/NS/exist">
                    <add-parameter name="resource-id" value="{$resource-id}"/>
                    <add-parameter name="resource-suffix" value="html"/>
                </parameters>
            )
        else if ($resource-suffix eq 'json') then
            local:dispatch("/models/translation.xq", "/views/json/xmlToJson.xq",
                <parameters xmlns="http://exist.sourceforge.net/NS/exist">
                    <add-parameter name="resource-id" value="{$resource-id}"/>
                    <add-parameter name="resource-suffix" value="json"/>
                </parameters>
            )
        else if ($resource-suffix eq 'pdf') then
            local:dispatch("/models/translation.xq", "/views/pdf/translation-fo.xq",
                <parameters xmlns="http://exist.sourceforge.net/NS/exist">
                    <add-parameter name="resource-id" value="{$resource-id}"/>
                    <add-parameter name="resource-suffix" value="pdf"/>
                </parameters>
            )
        else if ($resource-suffix eq 'epub') then
            local:dispatch("/models/translation.xq", "/views/epub/translation.xq",
                <parameters xmlns="http://exist.sourceforge.net/NS/exist">
                    <add-parameter name="resource-id" value="{$resource-id}"/>
                    <add-parameter name="resource-suffix" value="epub"/>
                </parameters>
            )
        else if ($resource-suffix eq 'edit') then
            local:dispatch-html("/models/translation-update.xq", "/views/html/translation-edit-new.xsl", 
                <parameters xmlns="http://exist.sourceforge.net/NS/exist">
                    <add-parameter name="resource-id" value="{$resource-id}"/>
                </parameters>
            )
        else
            (: return the xml :)
            local:dispatch("/models/translation.xq", "",
                <parameters xmlns="http://exist.sourceforge.net/NS/exist">
                    <add-parameter name="resource-id" value="{$resource-id}"/>
                    <add-parameter name="resource-suffix" value="xml"/>
                </parameters>
            )
                                                
    (: Section :)
    else if ($collection-path eq "section") then
        if ($resource-suffix eq 'html') then
            local:dispatch-html("/models/section.xq", "/views/html/section.xsl", 
                <parameters xmlns="http://exist.sourceforge.net/NS/exist">
                    <add-parameter name="resource-id" value="{$resource-id}"/>
                    <add-parameter name="resource-suffix" value="html"/>
                </parameters>
            )
        else if ($resource-suffix eq 'json') then
            local:dispatch("/models/section.xq", "/views/json/xmlToJson.xq", 
                <parameters xmlns="http://exist.sourceforge.net/NS/exist">
                    <add-parameter name="resource-id" value="{$resource-id}"/>
                    <add-parameter name="resource-suffix" value="json"/>
                </parameters>
            )
        else
            (: return the xml :)
            local:dispatch("/models/section.xq", "", 
                <parameters xmlns="http://exist.sourceforge.net/NS/exist">
                    <add-parameter name="resource-id" value="{$resource-id}"/>
                    <add-parameter name="resource-suffix" value="xml"/>
                </parameters>
            )
            
    (: Glossary :)
    else if ($collection-path eq "glossary") then
        if($resource-id eq 'items') then
            if($resource-suffix eq 'html') then
                local:dispatch-html("/models/glossary-items.xq", "/views/html/utilities-sections/glossary-items.xsl", 
                    <parameters/>
                )
            else
                local:dispatch("/models/glossary-items.xq", "", 
                    <parameters/>
                )
        else if ($resource-suffix eq 'html') then
            local:dispatch-html("/models/translation-glossary.xq", "/views/html/translation-glossary.xsl", 
                <parameters xmlns="http://exist.sourceforge.net/NS/exist">
                    <add-parameter name="resource-id" value="{$resource-id}"/>
                    <add-parameter name="resource-suffix" value="html"/>
                </parameters>
            )
        else if ($resource-suffix eq 'json') then
            local:dispatch("/models/translation-glossary.xq", "/views/json/xmlToJson.xq", 
                <parameters xmlns="http://exist.sourceforge.net/NS/exist">
                    <add-parameter name="resource-id" value="{$resource-id}"/>
                    <add-parameter name="resource-suffix" value="json"/>
                </parameters>
            )
        else
            (: return the xml :)
            local:dispatch("/models/translation-glossary.xq", "", 
                <parameters xmlns="http://exist.sourceforge.net/NS/exist">
                    <add-parameter name="resource-id" value="{$resource-id}"/>
                    <add-parameter name="resource-suffix" value="xml"/>
                </parameters>
            )
            
    (: Source texts :)
    else if ($collection-path eq "source") then
        if ($resource-suffix eq 'html') then
            local:dispatch-html("/models/source.xq", "/views/html/source.xsl", 
                <parameters xmlns="http://exist.sourceforge.net/NS/exist">
                    <add-parameter name="resource-id" value="{$resource-id}"/>
                    <add-parameter name="resource-suffix" value="html"/>
                </parameters>
            )
        else if ($resource-suffix eq 'json') then
            local:dispatch("/models/source.xq", "/views/json/xmlToJson.xq", 
                <parameters xmlns="http://exist.sourceforge.net/NS/exist">
                    <add-parameter name="resource-id" value="{$resource-id}"/>
                    <add-parameter name="resource-suffix" value="json"/>
                </parameters>
            )
        else
            (: return the xml :)
            local:dispatch("/models/source.xq", "", 
                <parameters xmlns="http://exist.sourceforge.net/NS/exist">
                    <add-parameter name="resource-id" value="{$resource-id}"/>
                    <add-parameter name="resource-suffix" value="xml"/>
                </parameters>
            )
    
    (: Translation :)
    else if ($collection-path eq "about") then
        if ($resource-suffix eq 'html') then
            local:dispatch-html("/models/about.xq", "/views/html/about.xsl", 
                <parameters xmlns="http://exist.sourceforge.net/NS/exist">
                    <add-parameter name="resource-id" value="{$resource-id}"/>
                    <add-parameter name="resource-suffix" value="html"/>
                </parameters>
            )
        else if ($resource-suffix eq 'json') then
            local:dispatch("/models/about.xq", "/views/json/xmlToJson.xq", 
                <parameters xmlns="http://exist.sourceforge.net/NS/exist">
                    <add-parameter name="resource-id" value="{$resource-id}"/>
                    <add-parameter name="resource-suffix" value="json"/>
                </parameters>
            )
        else
            (: return the xml :)
            local:dispatch("/models/about.xq", "", 
                <parameters xmlns="http://exist.sourceforge.net/NS/exist">
                    <add-parameter name="resource-id" value="{$resource-id}"/>
                    <add-parameter name="resource-suffix" value="xml"/>
                </parameters>
            )
        
    else
        (: Everything else is passed through :)
        (: It may be a pdf :)
        if($resource-suffix eq 'pdf') then
            <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
                <forward url="{ concat('/', $controller-root,  $exist:path) }">
                    <set-header name="Content-Type" value="application/pdf"/>
                    <set-header name="Content-Disposition" value="attachment"/>
                </forward>
            </dispatch>
        (: It may be an epub :)
        else if ($resource-suffix eq 'epub') then
             <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
                <forward url="{ concat('/', $controller-root,  $exist:path) }">
                    <set-header name="Content-Type" value="application/epub+zip"/>
                    <set-header name="Content-Disposition" value="attachment"/>
                </forward>
            </dispatch>
        else
            <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
                <forward url="{ concat('/', $controller-root,  $exist:path) }"/>
            </dispatch>
            
else
    (: Auth required and not given. Show login. :)
    local:auth(concat('/', $controller-root,  $exist:path))

    
xquery version "3.0";

module namespace sponsors="http://read.84000.co/sponsors";

import module namespace common="http://read.84000.co/common" at "../modules/common.xql";

declare namespace m = "http://read.84000.co/ns/1.0";

declare function sponsors:sponsored-sutra($toh as node()) as node(){
    
    let $sponsored-sutras := doc(concat(common:data-path(), '/operations/sponsors.xml'))
    let $status := 
        if($sponsored-sutras//m:sutra[@sponsored eq 'part'][xs:integer(@toh) eq xs:integer($toh/@first)][xs:integer($toh/@sub) eq 0 or xs:integer(@chapter) eq xs:integer($toh/@sub)]) then
            'part'
        else if($sponsored-sutras//m:sutra[xs:integer(@toh) eq xs:integer($toh/@first)][xs:integer($toh/@sub) eq 0 or xs:integer(@chapter) eq xs:integer($toh/@sub)]) then
            'full'
        else
            ''
    return
        <sponsored xmlns="http://read.84000.co/ns/1.0" >{ $status }</sponsored>
};
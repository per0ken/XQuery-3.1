(: Ez a lekérdezés végiglapozva kiíja az összes adatot az api-ról, a database.json fileba. :)
xquery version '3.1';

import module namespace deik-utility = "http://www.inf.unideb.hu/xquery/utility"
at "https://arato.inf.unideb.hu/jeszenszky.peter/FejlettXML/lab/lab10/utility/utility.xquery";

declare namespace map = "http://www.w3.org/2005/xpath-functions/map";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "json";
declare option output:indent "yes";


declare function local:get-data($limit as xs:integer, $offset as xs:integer) {
    let $uri := deik-utility:add-query-params("https://musicbrainz.org/ws/2/release/",
    map {
        "artist" : "169c4c28-858e-497b-81a4-8bc15e0026ea",
        "type" : "album",
        "status" : "official",
        "inc" : "labels+recordings",
        "fmt" : "json",
        "limit" : $limit,
        "offset" : $offset
    })
    return
        fn:json-doc($uri)
};

declare function local:get-page($limit as xs:integer, $offset as xs:integer) {
    let $releases := local:get-data($limit, $offset)?releases
    return
        if ($releases => array:size() > 0) then
            array:join(($releases, local:get-page($limit, $offset + $limit)))
        else
            array {}
};

let $limit := 25,
    $offset := 0
return
    local:get-page($limit, $offset)
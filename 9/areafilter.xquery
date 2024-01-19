(: Ez a lekérdezés az area mezőt szűri le egy függvény segítségével és visszaadja map-ként JSON formátumban
a name, iso-code, disambiguation mezőket :)

xquery version '3.1';

declare namespace array = "http://www.w3.org/2005/xpath-functions/array";

declare namespace map = "http://www.w3.org/2005/xpath-functions/map";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "json";
declare option output:indent "yes";

declare function local:transform-area($area as map(*)) as map(*)
{
    let $name := $area?name
    let $code := $area?iso-3166-1-codes
    let $disambiguation := if (string-length($area?disambiguation) = 0) then "none" else $area?disambiguation
    return
        map 
        {
            "name" : $name,
            "code" : $code,
            "disambiguation" : $disambiguation
        }
};

let $releases := fn:json-doc("../database.json")?*,
    $areas := $releases?release-events?*?area
return 
    array 
    { 
    $areas ! local:transform-area(.)
    }
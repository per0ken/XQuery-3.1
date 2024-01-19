(: Ez a lekérdezés kilistázza egy JSON állományba, hogy az egyes években
hány megjelenése volt az előadónak :)

xquery version '3.1';

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "json";
declare option output:indent "yes";

let $doc := fn:json-doc('../database.json')
return
    map:merge(
        for $release in $doc?*
        let $year := substring($release?date, 1, 4)
        group by $year
        order by $year ascending
        return map {
            $year: fn:count($release)
        }
    )
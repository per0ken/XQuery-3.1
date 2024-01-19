xquery version '3.1';

declare namespace map = "http://www.w3.org/2005/xpath-functions/map";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "json";
declare option output:indent "yes";

let $releases := fn:json-doc("../database.json")?*

let $tracks :=
    for $release in $releases
    for $media in $release?media?*
    for $track in $media?tracks?*
    where count(tokenize($track?title, '\s+')) > 5
    return $track?title

let $uniqueTracks := fn:distinct-values($tracks)

return
    map { 
        "tracks-with-more-than-5-words": array {
            for $title in $uniqueTracks return $title
        }
    }

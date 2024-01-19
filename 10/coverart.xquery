(: Ez a lekérdezés szűr a cover artokra a count alapján ahol nagyobb mint nulla, majd azokkal dolgozik tovább. 
Összeszámolja hány ilyen cover van, összeszámolja hány olyan cover van, ahol van artwork,
kvantorral vizsgálja hogy minden ilyen cover nem sötétített és megnézi hogy van-e olyan
cover art aminek csak eleje van. Az eredményt JSON-ben adja vissza. :)

xquery version '3.1';

declare namespace array = "http://www.w3.org/2005/xpath-functions/array";

declare namespace map = "http://www.w3.org/2005/xpath-functions/map";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "json";
declare option output:indent "yes";


let $releases := fn:json-doc("../database.json")?*
let $covers := $releases?cover-art-archive[ ?count > 0]

return 
    map 
    {
        "count" : count($covers),
        "artwork_count" : count($covers[ ?artwork ]),
        "no-cover-is-darkened" : every $cover in $covers satisfies $cover?darkened => fn:not(),
        "has-front-art-no-back-art" : some $cover in $covers satisfies fn:not($cover?back) and $cover?front
    }
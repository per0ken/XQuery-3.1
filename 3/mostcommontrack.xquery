(: Ez a lekérdezés kiíratja azt a tracket, amelyik a legtöbbször fordul elő a megjelenésekben.
Jelen esetben 2 ilyen is van. :)

xquery version '3.1';

import schema default element namespace "" at "mostcommontrack.xsd";


declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

declare option output:method "xml";
declare option output:indent "yes";

let $releases := fn:json-doc("../database.json")?*

let $tracks :=
for $release in $releases
for $media in $release?media?*
for $track in $media?tracks?*
return
    $track?title

let $track-frequencies :=
for $track in $tracks
    group by $track-title := $track
return
    <track>
        <title>{$track-title}</title>
        <count>{count($track)}</count>
    </track>

let $most-common-track :=
$track-frequencies[
count = max($track-frequencies/count)
]/title

return
    validate {
        <most-common-tracks>
            {$most-common-track}
            <count>{max($track-frequencies/count)}</count>
        </most-common-tracks>
    }

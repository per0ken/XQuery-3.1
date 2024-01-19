(: Ez a lekérdezés az albumon belüli trackeket íratja ki egy érvényes
XML file-ba, a hosszúságuk szerint, csökkenő sorrendben. :) 

xquery version '3.1';

import schema default element namespace "" at "trackdescending.xsd";

declare namespace map = "http://www.w3.org/2005/xpath-functions/map";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
declare option output:indent "yes";

let $releases := fn:json-doc("../database.json")?*

return
    validate {
        document {
            <releases>
                {
                    for $release in $releases
                    return
                        <release>
                            <title>{$release?title}</title>
                            {
                                for $media in $release?media?*
                                return
                                    <media>
                                        <tracks>
                                        {
                                            for $track in $media?tracks?*
                                            order by xs:integer($track?length) descending
                                            return
                                                <track>
                                                    <number>{$track?number}</number>
                                                    <title>{$track?title}</title>
                                                    <length>{$track?length}</length>
                                                </track>
                                        }
                                        </tracks>
                                    </media>
                            }
                        </release>
                }
            </releases>
        }
    }

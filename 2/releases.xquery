(: Ez a lekérdezés a Porcupine Tree minden CD megjelenését kiírja XML-ként az release.xml file-ba. :) 

xquery version '3.1';

import schema default element namespace "" at "releases.xsd";

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
                    where some $media in $release?media?*
                          satisfies $media?format = "CD"
                    return
                        <release>
                            <title>{$release?title}</title>
                            {
                                for $media in $release?media?*
                                return
                                    <media>
                                        <format>{$media?format}</format>
                                        <tracks>
                                        {
                                            for $track in $media?tracks?*
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

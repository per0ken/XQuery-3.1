(: Ez a lekérdezés visszaadja HTML formában dobozokban hogy milyen formátumokból mennyi
megjelenés volt. :)

xquery version '3.1';

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "html";
declare option output:indent "yes";

let $releases := fn:json-doc("../database.json")?*,
    $formats := $releases?media?*?format,
    $formatCounts :=
    array {
        for $format in $formats
        let $group := $format
            group by $group
        return
            map {
                "format": $group,
                "count": count($format)
            }
    }
return
    document {
        <html
            xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <meta
                    charset="UTF-8"/>
                <link
                    rel="stylesheet"
                    type="text/css"
                    href="../7/styles.css"/>
            </head>
            <body>
                {
                    for $formatCount in $formatCounts?*
                    return
                        <div
                            class="format-box">
                            <p>Format: {$formatCount?format}</p>
                            <p>Count: {$formatCount?count}</p>
                        </div>
                }
            </body>
        </html>
    }

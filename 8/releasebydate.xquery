(: Ez a lekérdezés lebontja évekre hónapra és napokra is a megjelenéseket és
sorba is rendezi őket :)

xquery version '3.1';

import schema default element namespace "" at "releasebydate.xsd";

declare namespace array = "http://www.w3.org/2005/xpath-functions/array";
declare namespace map = "http://www.w3.org/2005/xpath-functions/map";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

declare option output:method "xml";
declare option output:indent "yes";


let $releases := fn:json-doc("../database.json")?*,
    $dates := $releases?date[string-length(.) = 10] ! xs:date(.) => fn:sort()
return
validate {
    <years>
        {
            for $date in $dates
            let $year := year-from-date($date)
                group by $year
                order by $year
            return
                <year
                    value="{$year}"
                    count="{count($date)}">
                    {
                        for $date2 in $dates[year-from-date(.) = $year]
                        let $month := month-from-date($date2)
                            group by $month
                            order by $month
                        return
                            <month
                                value="{$month}"
                                count="{count($date2)}">
                                {
                                    for $date3 in $dates[year-from-date(.) = $year and month-from-date(.) = $month]
                                    let $day := day-from-date($date3)
                                        group by $day
                                        order by $day
                                    return
                                        <day
                                            value="{$day}"
                                            count="{count($date3)}"></day>
                                }
                            </month>
                    }
                </year>
        }
    </years>
    }
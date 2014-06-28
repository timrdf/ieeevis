#!/bin/bash
#3> <> rdfs:seeAlso <http://www.mediawiki.org/wiki/Manual:Parameters_to_Special:Export>,
#3>                 <http://en.wikipedia.org/wiki/Wikipedia:Lamest_edit_wars>;
#3> .

api='http://en.wikipedia.org/w/index.php'
page='Siena_College'

echo source/$page.xml

# Retrieves first 5 edits.
curl -d "" "$api?title=Special:Export&pages=$page%0ATalk:$page&offset=1&limit=5&action=submit" > source/${page}_1-5.xml

# Retrieves first 1000 edits.
#curl -d "" "$api?title=Special:Export&pages=$page%0ATalk:$page&history&action=submit" > source/${page}_0.xml

# Retrieves first 1000 edits.
#curl -d "" "$api?title=Special:Export&pages=$page%0ATalk:$page&offset=1000&limit=1000&action=submit" > source/${page}_1.xml

# Retrieves the latest edit.
#curl "$api?title=Special:Export&pages=$page%0ATalk:$page&offset=1000&limit=1000&action=submit" > source/${page}_1.xml

# ^^ Failures


# Success!
# Retrieves 1026 Siena_College edits and 319 Talk:Siena_College edits.
if [[ ! -e "source/$page.xml" ]];then
   curl "$api?title=Special:Export&pages=$page%0ATalk:$page&history&action=submit" > source/$page.xml
fi

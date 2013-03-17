# Scrape the given HTML files from IEEE Xplore, 
# e.g. a 100-per-page listing of publications in a given conference.
#
# Example output:
#
# 5290687,10.1109/TVCG.2009.132,
# 5290688,10.1109/TVCG.2009.133,
# 5290689,10.1109/TVCG.2009.193,
# 5290690,10.1109/TVCG.2009.116,ABySS-Explorer: Visualizing Genome Sequence Assemblies
# 5290691,10.1109/TVCG.2009.130,Constructing Overview + Detail Dendrogram-Matrix Views
# 5290692,10.1109/TVCG.2009.167,MizBee: A Multiscale Synteny Browser
#
# https://docs.google.com/spreadsheet/ccc?key=0ArTeDpS4-nUDdGVERXBDTEtUbGozLWlVUlB2MXpMN3c#gid=0

import sys
import re
from BeautifulSoup import BeautifulSoup
import csv

for arg in sys.argv[1:]:
   soup = BeautifulSoup(open(arg,'r').read())

   #table = csv.writer(open('publications.csv', 'wb'), delimiter=',', quotechar='|', quoting=csv.QUOTE_MINIMAL)
   table = csv.writer(open('publications.csv', 'wb'))

   for div in soup.findAll('div','detail'):
      title    = None
      doi      = None
      arnumber = None

      for title1 in div.findAll('h3'):
         for title2 in title1.findAll('a'):
            title = title2.string.strip()

      for a in div.findAll('a'):
         if a['href'].find('dx.doi.org') >= 0:         # http://dx.doi.org.libproxy.rpi.edu/10.1109/TVCG.2009.203
            match = re.search('\/(\d.*)$',a['href'])
            if match is not None:
               doi = match.group(1)

         match = re.search('arnumber=(\d+)',a['href']) # /xpl/multimedia.jsp?arnumber=5290691&isnumber=5290686
         if match is not None:
            arnumber = match.group(1)

      if title is not None or doi is not None or arnumber is not None:
         if title is not None:
            print 'title: ' + title
            upper = title.rfind(' ',0,40)
            print upper
         if doi is not None:
            print 'doi: '   + doi
         if arnumber is not None:
            print 'arnumber: ' + arnumber
         table.writerow([arnumber,doi,title])
      print
table.close()

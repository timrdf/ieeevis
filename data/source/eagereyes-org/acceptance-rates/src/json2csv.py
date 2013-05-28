import sys, json
import inspect
from pprint import pprint

def csvize(local_json):
   f = open(local_json)
   data = json.load(f)
   #pprint(data)
   print 'venue,year,count,type'
   for conference in data.keys(): # eurovis, infovis, uist, chi, vis, vast
      firstYear = data[conference]['firstYear']
      lastYear  = data[conference]['lastYear']
      for io in ['submitted', 'accepted']:
         for i, v in enumerate(data[conference][io]):
            print ','.join([data[conference]['shortName'],str(firstYear+i),str(v),io])
   f.close()

# Usage: 
#
if __name__ == '__main__':
   if len(sys.argv) == 1:
      csvize('source/conferences.json')

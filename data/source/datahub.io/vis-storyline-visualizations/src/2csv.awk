#3> <> prov:specializationOf <https://github.com/timrdf/ieeevis/blob/master/data/source/datahub.io/vis-storyline-visualizations/src/2csv.awk> .
#
# Input:
#
# TIME_COUNT=490
# NODE_COUNT=10
# INTERACTION_SESSION_COUNT=116
# LOCATION_COUNT=8
# WEIGHTS={}
# {'FISCHER': 9, 'EAMES': 7, 'YUSUF': 8, 'SAITO': 0, 'ARTHUR': 2, 'MAL': 3, 'ASIAN': 5, 'COBB': 1, 'ARCH': 4, 'ARIADNE': 6}
# {'OTHER': 0, 'SAITO DREAM': 1, 'COBB DREAM': 2, 'ARIADNE DREAM': 3, 'FISCHER DREAM': 4, 'FISCHER DREAM LAYER 2': 5, 'FISCHER DREAM LAYER 3': 6, 'LIMBO': 7}
#  Name      :  [0, 1, 2]_0
#  Id        :  0
#  Start     :  0
#  End       :  7
#  Members   :  [0, 1, 2]
#  Location  :  1
# 
#  Name      :  [0]_7
#  Id        :  1
#  Start     :  7
#  End       :  21
#  Members   :  [0]
#  Location  :  1
#
# Output:
#
# Name,Id,Start,End,Members,Location
# "[0, 1, 2]_0",0,0,7,"0, 1, 2",1
# "[0]_7",1,7,21,0,1

BEGIN {
   DEBUG="false"
   print "Name,Id,Start,End,Members,Location"
}

{
   if( NR < 6 ) {
      print "# "$0
   }else if( NR == 6 ) {
      gsub(/\{|\}/,"")
      if( DEBUG == "true" ) {
         print
      }
      M = split($0,members,",")
      for (m = 1; m <= M; m++) {
         # e.g. ____'FISCHER': 9_____
         member=members[m]
         gsub(/': .*$/,"",member)
         gsub(/^[^']*'/,"",member)
         id=members[m]
         sub(/^.*': /,"",id)
         MEMBERS[id]=member
         if ( DEBUG == "true" ) {
            print id, MEMBERS[id]
         }
      }
      if ( DEBUG == "true" ) {
         print "\\./"
         for (id in MEMBERS) {
            print "["id"]"MEMBERS[id]
         }
         print " ^"
      }
   }else if( NR == 7 ) {  # Same as NR == 6, but LOCATIONS instead of MEMBERS
      gsub(/\{|\}/,"")
      if( DEBUG == "true" ) {
         print
      }
      L = split($0,locations,",")
      for (i = 1; i <= L; i++) {
         # e.g. ____'FISCHER': 9_____
         location=locations[i]
         gsub(/': .*$/,"",location)
         gsub(/^[^']*'/,"",location)
         id=locations[i]
         sub(/^.*': /,"",id)
         LOCATIONS[id]=location
         if ( DEBUG == "true" ) {
            print id, LOCATIONS[id]
         }
      }
      if ( DEBUG == "true" ) {
         print "\\./"
         for (id in LOCATIONS) {
            print "["id"]"LOCATIONS[id]
         }
         print " ^"
      }
   }else if( NR >= 8 ) { 
      if ( NF > 0 ) {
         field=$1
         value=$0
         sub(/^[^:]*: */,"",value) # 'Name      :  [0, 1, 2]_0' -> '[0, 1, 2]_0'
         sub(/^ */,"",value)
         sub(/ *$/,"",value)
         if( field == "Members" ) {
            gsub(/\[|\]/,"",value)
            M = split(value,members,",")
            value=DEBUG=="true" ? value " ==> " : ""
            plus=""
            for (m = 1; m <= M; m++) {
               member=members[m]
               sub(/^ */,"",member)
               sub(/ *$/,"",member)
               if( DEBUG == "true" ) {
                  value = value "" plus "[" member "](" MEMBERS[member] ")"
                  plus=" plus"
               }else {
                  value = value plus MEMBERS[member]
                  plus=","
               }
            }
         }else if( field == "Location" ) {
            location=LOCATIONS[value]
            value=DEBUG=="true" ? "[" value "] ==> " location : location
         }
         comma=field=="Name"?"":","
         printf("%s\"%s\"",comma,value)
      }else {
         print
         if( DEBUG == "true" ) {
            print
         }
      }
   }
}

# http://celestrak.com/satcat/satcat-format.asp

BEGIN {
   debug = "debug"
   debug = "no"
   print "International Designator,International Designator Launch Year,International Designator Launch Launch of the Year,International Designator Launch Piece of the Launch,NORAD Catalog Number,Multiple Name Flag,Payload Flag,Operational Status Code,Satellite Names,Source or Ownership,Launch Date,Launch Site,Decay Date,Orbital Period minutes,Inclination degrees,Apogee Altitude kilometers,Perigee Altitude kilometers,Radar Cross Section meters2,Orbital Status Code,Orbital Status Code - Central Body,Orbital Status Code - Orbit Type"
}

function trim(string) {
   trimmed = string
   gsub(" *$","",trimmed)
   gsub("^ *","",trimmed)
   return trimmed
}

function wrap(string) {
   return ",\""string"\""
}

{
   if( debug == "debug" ) {
      print "==============================================================================================================================="
   }
   International_Designator                            = trim(substr($0,1,11))
   International_Designator_Launch_Year                = trim(substr($0,1,4))
   #                                                             "-"
   International_Designator_Launch_Launch_of_the_Year  = trim(substr($0,6,3))
   International_Designator_Launch_Piece_of_the_Launch = trim(substr($0,9,3))

   NORAD_Catalog_Number                                = trim(substr($0,14,5))
   Multiple_Name_Flag                                  = trim(substr($0,20,1))
   Payload_Flag                                        = trim(substr($0,21,1))
   Operational_Status_Code                             = trim(substr($0,22,1))
   Satellite_Names                                     = trim(substr($0,24,24))
   Source_or_Ownership                                 = trim(substr($0,50,5))
   Launch_Date                                         = trim(substr($0,57,10))
   Launch_Site                                         = trim(substr($0,69,5))
   Decay_Date                                          = trim(substr($0,76,10))
   Orbital_Period_minutes                              = trim(substr($0,88,7))
   Inclination_degrees                                 = trim(substr($0,97,5))
   Apogee_Altitude_kilometers                          = trim(substr($0,104,6))
   Perigee_Altitude_kilometers                         = trim(substr($0,112,6))
   Radar_Cross_Section_meters2                         = trim(substr($0,120,8))
   Orbital_Status_Code                                 = trim(substr($0,130,3))
   Orbital_Status_Code_Central_Body                    = trim(substr($0,130,2))
   Orbital_Status_Code_Orbit_Type                      = trim(substr($0,132,1))

   if( debug == "debug" ) {
      print
      print International_Designator
      print International_Designator_Launch_Year
      print "    -"
      print "     "International_Designator_Launch_Launch_of_the_Year
      print "        "International_Designator_Launch_Piece_of_the_Launch
      print ""
      print "NORAD #:     "NORAD_Catalog_Number
      print "Multiple Names   >"Multiple_Name_Flag"<"
      print "Payload           >"Payload_Flag"<"
      print "Operational Status >"Operational_Status_Code"<"
      print "Satellite Names:       "Satellite_Names
      print "Source or Ownership:                             "Source_or_Ownership
      print "Launch Date:                                            "Launch_Date
      print "Launch Site:                                                        "Launch_Site
      print "Decay Date:                                                         "Decay_Date
      print "Orbital Period (minutes):                                                              "Orbital_Period_minutes
      print "Inclination (degrees):                                                                          "Inclination_degrees
      print "Apogee Altitude (kilometers):                                                                          "Apogee_Altitude_kilometers
      print "Perigee Altitude (kilometers):                                                                                 "Perigee_Altitude_kilometers
      print "Radar Cross Section (m^2):                                                                                             "Radar_Cross_Section_meters2
      print "Orbital Status Code:                                                                                                             "Orbital_Status_Code
      if ( Orbital_Status_Code_Orbit_Type == "0" || Orbital_Status_Code_Orbit_Type == "1" || Orbital_Status_Code_Orbit_Type == "2" || Orbital_Status_Code_Orbit_Type == "3" ) {
         print "Orbital Status Code Central Body:                                                                                                "Orbital_Status_Code_Central_Body
         print "Orbital Status Code Orbit Type:                                                                                                    "Orbital_Status_Code_Orbit_Type
      }
   } else {
      printf("\""International_Designator"\"")
      printf(wrap(International_Designator_Launch_Year))
      printf(wrap(International_Designator_Launch_Launch_of_the_Year))
      printf(wrap(International_Designator_Launch_Piece_of_the_Launch))
      printf(wrap(NORAD_Catalog_Number))
      printf(wrap(Multiple_Name_Flag))
      printf(wrap(Payload_Flag))
      printf(wrap(Operational_Status_Code))
      printf(wrap(Satellite_Names))
      printf(wrap(Source_or_Ownership))
      printf(wrap(Launch_Date))
      printf(wrap(Launch_Site))
      printf(wrap(Decay_Date))
      printf(wrap(Orbital_Period_minutes))
      printf(wrap(Inclination_degrees))
      printf(wrap(Apogee_Altitude_kilometers))
      printf(wrap(Perigee_Altitude_kilometers))
      printf(wrap(Radar_Cross_Section_meters2))
      printf(wrap(Orbital_Status_Code))
      if ( Orbital_Status_Code_Orbit_Type == "0" || Orbital_Status_Code_Orbit_Type == "1" || Orbital_Status_Code_Orbit_Type == "2" || Orbital_Status_Code_Orbit_Type == "3" ) {
         printf(wrap(Orbital_Status_Code_Central_Body))
         printf(wrap(Orbital_Status_Code_Orbit_Type))
      }
      print ""
   }
}

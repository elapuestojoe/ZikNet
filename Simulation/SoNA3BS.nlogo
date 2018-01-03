;INCLUDEDFILES------------------------------------------------------------------------------------------------------
__includes["GoogleMap.nls" "turtlesCreation_HET.nls" "release_HET.nls" "schoolfield.nls" "go.nls" "reproductionRoutines.nls" "transitionsCreation.nls" "randomScenarios.nls" "auxiliaryFunctions.nls" "movement.nls" "xmlExport.nls" "humanBehaviour.nls" "mosquitoBehaviour.nls" "global.nls" "controlMeasures.nls"]
;BreedsDeclaration
breed[houses house]
breed[workZones workZone]
breed[landmarks landmark]
breed[breedingZones breedingZone]
breed[humans human]
breed[aedesp aedesi]
breed[sugars sugar]
breed[sugarBaits sugarBait]
breed[ovitraps ovitrap]
;BREEDSVARIABLES------------------------------------------------------------------------------------------------------
patches-own[
  road;; C:Bool: True if the patch is a road, false if it is regular ground
]
aedesp-own[
  age ;; V:Int: Stores the mosquito age in ticks
  mated? ;; V:Bool: Stores the female state in mating
  female? ;; C:Bool: Differentiates male mosquitos from females
  bloodfed? ;; V:Bool: Stores the female state in bloodfed as part of reproductive cycle
  laidEggs? ;; V:Bool: Stores the female state in oviposition
  sterile? ;; C:Bool: Differentiates sterile mosquitos (males) from non-sterile mosquitos
  sterileMate? ;; V:Bool: Stores if a female mated with a sterile male
  wolbachia? ;; C:Bool: Differentiates wolbachia-infected mosquitos from non-infected
  wolbachiaMate? ;; V:Bool: Stores if a female mated with a wolbachia-infected mate
  oxitech? ;; C:Bool: Differentiates oxitec males from regular males
  oxitechMate? ;; V:Bool: Stores if a female mated with an oxitec male
  fitness_selected? ;; Differentiates a fitness selected mosquito from a regular one
  fitness_selectedMate? ;; Stores if the female has mated with a fitness selected male
  movement_speeds ;; C:IntArray: Stores the movement speeds of the mosquitos in each life stage
  bitten_list ;; V:StringArray: Stores the individuals and times in which a mosquito has bitten persons
  feeding_cooldown ;; V:Int: Stores the number of ticks missing so that a female can lay eggs
  dengue ;; V:Int: Stores the dengue infection of a mosquito CURRENTLY UNUSED
  ovipositionCounter ;; V:Int: Counts the number of times a female has laid eggs
  maleReproductiveDelay ;; V:Int: Timer from egg hatching until the time when males are ready to mate
  gonotrophic_cooldown ;; V:Int: Timer from bloodfeed until oviposition ready
  metabolic_rate ;; V:Int: Stores the metabolic development of the mosquito (when equal to one it resets)
  life_stage ;; V:Int: Stores the current life phase of the mosquito for behaviour purposes
  life_stage_ticks ;; V:Int: Stores the number of ticks a mosquito has spent in a given life stage
  life_stage_ticks_list ;; V:IntArray: Stores the number of ticks a mosquito has spent in each life stage
  hunger ;; V:Int: Stores the hunger level of the mosquito
  transition_ages
  ridl_gene ;; C:Int: Stores the type of RIDL genotype a mosquito posseses (0: rr :: 1:Rr :: 2:RR)
  mate_ridl_gene ;; C:Int: Stores the type of RIDL genotype a mosquito posseses (0: rr :: 1:Rr :: 2:RR)
]
humans-own[
  replacementCooldown ;; V:Int: Timer that avoids a loop in the population replacement strategies
  ;workZoneID ;; C:Int: Determines to which work zone a human must go to CURRENTLY UNUSED
  visitingHouseNumber ;; V:Int: Determines which house a human will visit
  visitingCooldown ;; V:Int: Timer that avoids visiting loops
  visiting? ;; V:Bool: Determines if a human is currently visiting another house
  group ;;
  groupP ;;
  worker? ;; C:Bool: Differentiates workers from homestayers
  name ;; C:String: Person's name
  goWork? ;; V:Bool: Determines if a person should transit to work or not
  workHoursTimer ;; V:Int: Timer of the missing work hours for an individual to go home
  dengue ;; V:Bool: Stores the dengue sick state of an individual CURRENTLY UNUSED
  flu ;; V:Bool: Stores the flu sick state of an individual CURRENTLY UNUSED
  contacts_list ;; V:StringArray: Stores the direct contacts between the current individual and other ones
  contacts_houses_list ;; V:StringArray: Stores the direct contacts between the current individual and buildings
  contacted? ;; V:Bool: Temporary flow variable to avoid contacts loop
  contacted_house? ;; V:Bool: Temporary flow variable to avoid contacts loop
  contacted_workZone? ;; V:Bool: Temporary flow variable to avoid contacts loop
]
houses-own[
  group ;; C:Int: Number of human group or family
  area ;; C:Int: Determines the house size and the number of persons that live in it
  persons ;; C:Int: Number of persons living in a given house
  name ;; C:String: House name
  gravity ;; C:ListFloat: Probability to visit other households according to pre-computed gravity model
]
breedingZones-own[
]
workZones-own[
  name ;; C:String: Work zone name
]
sugars-own[
  food ;; V:Int: Available food in this sugar source
]
sugarBaits-own[
  food ;; V:Int: Available food in this sugar bait
]
ovitraps-own[

]
globals[
  BITES_NUMBER
	ACTION_RADIUS
	adultAgesList
	AGE_DEVIATION
	areas
	BLOODFEED_COOLDOWN
	BLOODFEED_COOLDOWN_DISPERSION
	BREEDING_DESTROY?
	CONTACT_REFRESH_RATE
	CONTROL_RELEASES_LIST
	DAILY_TEMPERATURE_DEVIATION
	DEATH_BY_HUMAN_PROBABILITY
	DEATH_BY_OVITRAP_PROBABILITY
	DEATH_BY_PREDATOR_PROBABILITY
	DEATH_BY_STARVATION_PROBABILITY
	EGG_DEATH_BY_INHIBITION_PROBABILITY
	EGG_SCALING_FACTOR
	EGGS_LAID
	EGGS_LAID_DEVIATION
	EGG_THERMODYNAMIC
	EMERGENCE_DEATH_PROBABILITY
	EXTERMINATION_FUMIGATION_RATIO
	FILE_NAME
	FILE_NAME_TEMP
	FITNESS_RELEASE_DELAY
	FITNESS_RELEASE_STOP
	FITNESS_REPLACE_QUANTITY
	FITNESS_SELECTED_OFFSPRING_PROBABILITY
	FITNESS_SELECTION_EFFECTIVITY
	FOGGING_KILL_PROBABILITY
	FOGGING_RELEASE_DELAY
	FOGGING_RELEASE_STOP
	FOGGING_REPLACE_QUANTITY
	FOOD_AMOUNT_PER_SOURCE
	GLOBAL_BITES_LIST
	GLOBAL_CONTACTS_HOUSES_LIST
	GLOBAL_CONTACTS_LIST
	GONOTROPHICA1_TICKS_DURATION
	GONOTROPHICA2_TICKS_DURATION
	GONOTROPICA1_THERMODYNAMIC
	GONOTROPICA2_THERMODYNAMIC
	groups
	HALF_DAY
	HOUSE_CONTACT_REFRESH_BOOL
	HOUSE_CONTACT_REFRESH_RATE
	HOUSE_SIZE
	HUMAN_ACTION_RADIUS
	HUMAN_CONTACT_RADIUS
	HUMAN_CONTACT_REFRESH_BOOL
	HUMAN_HOUSE_CONTACT_RADIUS
	HUMAN_KILLING_RANGE
	HUMAN_MOVEMENT_FOCUS
	HUMAN_MOVEMENT_SPEED
	HUMAN_MOVEMENT_SPEED_DEVIATION
	human_name_counter
	HUMAN_SIZE
	individuals
	LARVA_DEATH_DENSITY_DEATH_PROBABILITY
	LARVA_DENSITY_DEATHS
	LARVA_THERMODYNAMIC
	LAST_FOGGING_TIME
	MOSQUITO_ACTION_RADIUS
	MOSQUITO_COUNT_BREEDING_DESTROY_THRESHOLD
	MOSQUITO_DETECTION_RADIUS
	MOSQUITO_FEEDING_RATE
	MOSQUITO_FEEDING_THRESHOLD
	mosquitoLifespan
	MOSQUITO_MOVEMENT_FOCUS
	MOSQUITO_MOVEMENT_SPEED_DEVIATION
	MOSQUITO_NIGHT_MOVEMENT_PROBABILITY
	MOSQUITO_SIZE
	MOSQUITO_SPEEDS_GLOBAL
	names_houses
	names_listg
	names_workZones
	NEUTRAL_RELEASE_DELAY
	NEUTRAL_RELEASE_STOP
	NEUTRAL_REPLACE_QUANTITY
	NUMBER_OF_DAYS
	ovipositions_count
	OXITECH_RELEASE_DELAY
	OXITECH_RELEASE_STOP
	OXITECH_REPLACE_QUANTITY
	PATH
	POPULATION_CAP_PENALTY
	POPULATION_CAP_THRESHOLD
	POPULATION_MAX_EGGS
	POPULATION_POSITIONS
	PUPA_THERMODYNAMIC
	REPLACEMENT_COOLDOWN
	REPLACEMENT_COOLDOWN?
	scenario_number
	SCHOOLFIELD_MODEL_CONSTANTS
	SECONDS_PER_TICK
	SOURCE_DECREASE
	SOURCE_INCREASE_RATE
	SPEED_DEVIATION
	STERILE_RELEASE_DELAY
	STERILE_RELEASE_STOP
	STERILE_REPLACE_QUANTITY
	TICK_ADULT_DEATH_PROBABILITY
	TICK_EGG_DEATH_PROBABILITY
	tickPhasesTransitionAges
	tickPhasesTransitionRates
	tickTemperature
	TICK_TEMPERATURE_PHASES_REFRESH_RATE
	TIME_SINCE_LAST_FOGGING
	TRANSITION_AGES_GLOBAL
	VISITING_COOLDOWN_MAX
	WARMUP_COMPLETED?
	WARMUP_PERIOD
	WEEKEND?
	WOLBACHIA_EFFECTIVITY
	WOLBACHIA_RELEASE_DELAY
	WOLBACHIA_RELEASE_STOP
	WOLBACHIA_REPLACE_QUANTITY
	WORKING_HOUR?
	wxcord
	wycord
	xcord
	ycord
  gravities

  ;KEVIN 2017
  RELEASE_FITNESS
  BREEDING_REPLACEMENT_FITNESS
]
@#$#@#$#@
GRAPHICS-WINDOW
579
10
1403
564
-1
-1
2.711443
1
10
1
1
1
0
0
0
1
-150
150
-100
100
1
1
1
ticks
30.0

BUTTON
13
10
111
84
setup
setup\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
1405
61
1596
94
INITIAL_POPULATION
INITIAL_POPULATION
0
10000
400.0
1
1
NIL
HORIZONTAL

BUTTON
109
10
205
84
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
13
374
580
616
PopulationComposition
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Sterile" 1.0 0 -13840069 true "" "plot count aedesp with [sterile? = true]"
"MatedSterile" 1.0 0 -8330359 true "" "plot count aedesp with [sterileMate? = true]"
"Wolbachia" 1.0 0 -2674135 true "" "plot count aedesp with [wolbachia? = true and life_stage = 3]"
"MatedWolbachia" 1.0 0 -1604481 true "" "plot count aedesp with [wolbachiaMate? = true and life_stage = 3]"
"RIDL" 1.0 0 -8431303 true "" "plot count aedesp with [oxitech? = true and life_stage = 3]"
"MatedRIDL" 1.0 0 -3889007 true "" "plot count aedesp with [oxitechMate? = true and life_stage = 3]"
"MatedFemales" 1.0 0 -7500403 true "" "plot count aedesp with [(mated? = true) and (female? = true)]"
"Adults" 1.0 0 -6759204 true "" "plot count aedesp with[life_stage = 3]"
"AdultFemales" 1.0 0 -955883 true "" "plot (count aedesp with[female? = True and life_stage = 3])"
"Fogging" 1.0 0 -14835848 true "" "plot FOGGING_KILL_PROBABILITY"

SLIDER
1018
822
1163
855
STERILE_RATIO
STERILE_RATIO
0
1
0.0
.05
1
NIL
HORIZONTAL

SLIDER
1018
854
1163
887
WOLBACHIA_RATIO
WOLBACHIA_RATIO
0
1
0.0
.05
1
NIL
HORIZONTAL

PLOT
13
154
580
376
PopulationDynamics
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Egg/10" 1.0 0 -14454117 true "" "plot (count aedesp with[life_stage = 0] / 10)"
"Larva" 1.0 0 -8630108 true "" "plot count aedesp with[life_stage = 1]"
"Pupa" 1.0 0 -2674135 true "" "plot count aedesp with[life_stage = 2]"
"Adult" 1.0 0 -955883 true "" "plot count aedesp with[life_stage = 3]"

PLOT
203
10
579
155
Temperature
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot tickTemperature"

MONITOR
579
585
1405
630
MetabolicRates
tickPhasesTransitionRates
3
1
11

MONITOR
71
83
130
124
Day?
WORKING_HOUR?
17
1
10

MONITOR
128
83
206
124
DaysElapsed
NUMBER_OF_DAYS
2
1
10

MONITOR
13
83
71
124
Weekend?
WEEKEND?
17
1
10

BUTTON
578
629
772
662
Release 20% Sterile
release-control-mosquitos-program 0 0 (floor INITIAL_POPULATION * .2) \"Sterile\"
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
771
629
948
662
Release 20% Wolbachia
release-control-mosquitos-program 0 0 (floor INITIAL_POPULATION * .2) \"Wolbachia\"
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
1163
823
1308
856
FITNESS_SELECTED_RATIO
FITNESS_SELECTED_RATIO
0
1
0.0
.05
1
NIL
HORIZONTAL

SWITCH
1404
120
1595
153
STORE_BITES
STORE_BITES
0
1
-1000

SWITCH
1404
182
1595
215
STORE_HUMAN_CONTACT
STORE_HUMAN_CONTACT
1
1
-1000

SWITCH
1404
151
1595
184
STORE_HOUSE_CONTACT
STORE_HOUSE_CONTACT
1
1
-1000

SWITCH
579
783
759
816
HUMAN_VISIT
HUMAN_VISIT
0
1
-1000

SWITCH
758
822
1019
855
BREEDING_EXTERMINATION
BREEDING_EXTERMINATION
1
1
-1000

SWITCH
758
855
1019
888
FUMIGATION
FUMIGATION
1
1
-1000

SWITCH
759
661
1038
694
BREEDING_REPLACEMENT_WOLBACHIA
BREEDING_REPLACEMENT_WOLBACHIA
1
1
-1000

SWITCH
759
693
1020
726
BREEDING_REPLACEMENT_STERILE
BREEDING_REPLACEMENT_STERILE
1
1
-1000

SWITCH
1018
693
1307
726
RELEASE_STERILE
RELEASE_STERILE
1
1
-1000

SWITCH
1018
661
1308
694
RELEASE_WOLBACHIA
RELEASE_WOLBACHIA
1
1
-1000

SWITCH
1404
214
1595
247
STORE_CONTROL_RELEASES
STORE_CONTROL_RELEASES
1
1
-1000

SLIDER
1163
854
1308
887
OXITECH_RATIO
OXITECH_RATIO
0
1
0.0
.05
1
NIL
HORIZONTAL

SWITCH
759
725
1020
758
BREEDING_REPLACEMENT_OXITECH
BREEDING_REPLACEMENT_OXITECH
1
1
-1000

BUTTON
948
629
1129
662
Release 20% Oxitech
release-control-mosquitos-program 0 0 (floor INITIAL_POPULATION * .2) \"Oxitech\"
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
1018
725
1308
758
RELEASE_OXITECH
RELEASE_OXITECH
1
1
-1000

MONITOR
13
121
206
154
NIL
WARMUP_COMPLETED?
17
1
8

SWITCH
758
757
1019
790
OVITRAPS?
OVITRAPS?
1
1
-1000

SWITCH
758
790
1019
823
SUGAR_BAITS?
SUGAR_BAITS?
1
1
-1000

PLOT
1404
363
1596
629
Food
NIL
NIL
0.0
20.0
0.0
10.0
true
false
"" ""
PENS
"Food" 1.0 0 -13345367 true "" "plot sum [food] of sugars"

SWITCH
1405
331
1595
364
FOOD_DYNAMICS?
FOOD_DYNAMICS?
0
1
-1000

SLIDER
1405
29
1596
62
EXPORT_RATE
EXPORT_RATE
0
1000
144.0
50
1
NIL
HORIZONTAL

PLOT
1307
629
1596
887
DeathProbabilities
NIL
NIL
0.0
10.0
0.0
0.005
true
true
"" ""
PENS
"Egg" 1.0 0 -16777216 true "" "plot EGG_DEATH_BY_INHIBITION_PROBABILITY"
"Larva" 1.0 0 -13840069 true "" "plot (LARVA_DEATH_DENSITY_DEATH_PROBABILITY * 10)"

SWITCH
1405
267
1595
300
LARVA_COMPETITION?
LARVA_COMPETITION?
0
1
-1000

SWITCH
1405
299
1595
332
EGG_INHIBITION?
EGG_INHIBITION?
0
1
-1000

CHOOSER
579
661
759
706
TEMPERATURE_TYPE
TEMPERATURE_TYPE
"Constant" "YearlyVariation" "DailyAndYearlyVariation"
1

SLIDER
579
706
759
739
CONSTANT_TEMPERATURE
CONSTANT_TEMPERATURE
15
40
25.0
1
1
NIL
HORIZONTAL

CHOOSER
579
739
759
784
BreedingZonesNumber
BreedingZonesNumber
10 15 20 25 30 "GoogleMap"
3

TEXTBOX
1408
249
1558
267
Density-Dependent
12
0.0
0

TEXTBOX
1410
100
1560
118
Social Networks
12
0.0
0

TEXTBOX
1409
10
1588
28
Simulation Control
12
0.0
0

PLOT
13
615
579
880
RIDL Aleles
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"T: rr" 1.0 0 -4539718 true "" "plot count aedesp with [ridl_gene = 0]"
"T: Rr" 1.0 0 -11053225 true "" "plot count aedesp with [ridl_gene = 1]"
"T: RR" 1.0 0 -16777216 true "" "plot count aedesp with [ridl_gene = 2]"
"M: rr" 1.0 0 -14454117 true "" "plot count aedesp with [ridl_gene = 0 and female? = false]"
"F: rr" 1.0 0 -1184463 true "" "plot count aedesp with [ridl_gene = 0 and female? = true]"
"M: Rr" 1.0 0 -955883 true "" "plot count aedesp with [ridl_gene = 1 and female? = false]"
"F: Rr" 1.0 0 -10263788 true "" "plot count aedesp with [ridl_gene = 1 and female? = true]"
"M: RR" 1.0 0 -2674135 true "" "plot count aedesp with [ridl_gene = 2 and female? = false]"
"F: RR" 1.0 0 -1264960 true "" "plot count aedesp with [ridl_gene = 2 and female? = true]"

SLIDER
579
847
758
880
HUMAN_VISITING_PROBABILITY
HUMAN_VISITING_PROBABILITY
0
.1
0.05
.00028
1
NIL
HORIZONTAL

SWITCH
1018
789
1307
822
RELEASE_NEUTRAL
RELEASE_NEUTRAL
1
1
-1000

SWITCH
1018
757
1308
790
RELEASE_FOGGING
RELEASE_FOGGING
1
1
-1000

SWITCH
579
815
759
848
GRAVITY_VISIT?
GRAVITY_VISIT?
1
1
-1000

BUTTON
1129
629
1308
662
Apply Fogging
fogging-refill TRUE 1
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
# SoNA3BS :: Hector Manuel Sanchez Castellanos

## Notes
### Latest Changes
#### If wolbachia not added to bitten list

### Next Step

## Description
SoNA3BS (Social Network Aedes Aegypti Agent-Based Simulation) is an individual-based model created to simulate the population dynamics of Aedes Aegypti mosquitoes. This project is being developed by the Bioinformatics research group of "Tecnológico de Monterrey" university and as part of my Ph.D. thesis in Computer Sciences.

## Author
Hector Manuel Sanchez Castellanos
chipdelmal@gmail.com
https://sites.google.com/site/heimlichcountermaneuver/
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="CatemacoBaseline_HET" repetitions="8" runMetricsEveryStep="false">
    <setup>setup
XML-setup-name (word "GeneratedData/CatemacoBaseline_HET/CatemacoBaseline_HET ") 
XML-init-write
XML-write-header "Novel Control Measures." "HMSC" "Replicating RIDL/Wolbachia papers in smaller scale."
XML-write-parameters
XML-init-write-ticks-body</setup>
    <go>go
XML-write-tick-outputs EXPORT_RATE</go>
    <final>ask humans[die-human]
XML-finish-write-ticks-body
XML-init-write-tail-body
XML-write-tail-outputs
XML-finish-write-tail-body
XML-finish-write</final>
    <timeLimit steps="100000"/>
    <enumeratedValueSet variable="RELEASE_WOLBACHIA">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RELEASE_STERILE">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RELEASE_FOGGING">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RELEASE_OXITECH">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RELEASE_FITNESS">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RELEASE_NEUTRAL">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TEMPERATURE_TYPE">
      <value value="&quot;Constant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CONSTANT_TEMPERATURE">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BreedingZonesNumber">
      <value value="&quot;GoogleMap&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FOOD_DYNAMICS?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FUMIGATION">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_EXTERMINATION">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_REPLACEMENT_WOLBACHIA">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_REPLACEMENT_STERILE">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_REPLACEMENT_OXITECH">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_REPLACEMENT_FITNESS">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="OVITRAPS?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SUGAR_BAITS?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="OXITECH_RATIO">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FITNESS_SELECTED_RATIO">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WOLBACHIA_RATIO">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STERILE_RATIO">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="HUMAN_VISIT">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STORE_BITES">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STORE_HOUSE_CONTACT">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STORE_HUMAN_CONTACT">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STORE_CONTROL_RELEASES">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="EXPORT_RATE">
      <value value="144"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="CatemacoWolbachia_HET" repetitions="8" runMetricsEveryStep="false">
    <setup>setup
XML-setup-name (word "GeneratedData/CatemacoWolbachia_HET/CatemacoWolbachia_HET ") 
XML-init-write
XML-write-header "Novel Control Measures." "HMSC" "Replicating RIDL/Wolbachia papers in smaller scale."
XML-write-parameters
XML-init-write-ticks-body</setup>
    <go>go
XML-write-tick-outputs EXPORT_RATE</go>
    <final>ask humans[die-human]
XML-finish-write-ticks-body
XML-init-write-tail-body
XML-write-tail-outputs
XML-finish-write-tail-body
XML-finish-write</final>
    <timeLimit steps="100000"/>
    <enumeratedValueSet variable="RELEASE_WOLBACHIA">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RELEASE_FOGGING">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RELEASE_STERILE">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RELEASE_OXITECH">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RELEASE_FITNESS">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TEMPERATURE_TYPE">
      <value value="&quot;Constant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CONSTANT_TEMPERATURE">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BreedingZonesNumber">
      <value value="&quot;GoogleMap&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FOOD_DYNAMICS?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FUMIGATION">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_EXTERMINATION">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_REPLACEMENT_WOLBACHIA">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_REPLACEMENT_STERILE">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_REPLACEMENT_OXITECH">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_REPLACEMENT_FITNESS">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="OVITRAPS?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SUGAR_BAITS?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="OXITECH_RATIO">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FITNESS_SELECTED_RATIO">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WOLBACHIA_RATIO">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STERILE_RATIO">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="HUMAN_VISIT">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STORE_BITES">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STORE_HOUSE_CONTACT">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STORE_HUMAN_CONTACT">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STORE_CONTROL_RELEASES">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="EXPORT_RATE">
      <value value="144"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="CatemacoOxitec_HET" repetitions="8" runMetricsEveryStep="false">
    <setup>setup
XML-setup-name (word "GeneratedData/CatemacoOxitec_HET/CatemacoOxitec_HET ") 
XML-init-write
XML-write-header "Novel Control Measures." "HMSC" "Replicating RIDL/Wolbachia papers in smaller scale."
XML-write-parameters
XML-init-write-ticks-body</setup>
    <go>go
XML-write-tick-outputs EXPORT_RATE</go>
    <final>ask humans[die-human]
XML-finish-write-ticks-body
XML-init-write-tail-body
XML-write-tail-outputs
XML-finish-write-tail-body
XML-finish-write</final>
    <timeLimit steps="100000"/>
    <enumeratedValueSet variable="RELEASE_WOLBACHIA">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RELEASE_STERILE">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RELEASE_FOGGING">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RELEASE_OXITECH">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RELEASE_FITNESS">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TEMPERATURE_TYPE">
      <value value="&quot;Constant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CONSTANT_TEMPERATURE">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BreedingZonesNumber">
      <value value="&quot;GoogleMap&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FOOD_DYNAMICS?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FUMIGATION">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_EXTERMINATION">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_REPLACEMENT_WOLBACHIA">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_REPLACEMENT_STERILE">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_REPLACEMENT_OXITECH">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_REPLACEMENT_FITNESS">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="OVITRAPS?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SUGAR_BAITS?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="OXITECH_RATIO">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FITNESS_SELECTED_RATIO">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WOLBACHIA_RATIO">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STERILE_RATIO">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="HUMAN_VISIT">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STORE_BITES">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STORE_HOUSE_CONTACT">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STORE_HUMAN_CONTACT">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STORE_CONTROL_RELEASES">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="EXPORT_RATE">
      <value value="144"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="CatemacoFogging_HET" repetitions="8" runMetricsEveryStep="false">
    <setup>setup
XML-setup-name (word "GeneratedData/CatemacoFogging_HET/CatemacoFogging_HET ") 
XML-init-write
XML-write-header "Novel Control Measures." "HMSC" "Replicating RIDL/Wolbachia papers in smaller scale."
XML-write-parameters
XML-init-write-ticks-body</setup>
    <go>go
XML-write-tick-outputs EXPORT_RATE</go>
    <final>ask humans[die-human]
XML-finish-write-ticks-body
XML-init-write-tail-body
XML-write-tail-outputs
XML-finish-write-tail-body
XML-finish-write</final>
    <timeLimit steps="100000"/>
    <enumeratedValueSet variable="RELEASE_FOGGING">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RELEASE_WOLBACHIA">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RELEASE_STERILE">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RELEASE_OXITECH">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RELEASE_NEUTRAL">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RELEASE_FITNESS">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TEMPERATURE_TYPE">
      <value value="&quot;Constant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CONSTANT_TEMPERATURE">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BreedingZonesNumber">
      <value value="&quot;GoogleMap&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FOOD_DYNAMICS?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FUMIGATION">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_EXTERMINATION">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_REPLACEMENT_WOLBACHIA">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_REPLACEMENT_STERILE">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_REPLACEMENT_OXITECH">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_REPLACEMENT_FITNESS">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="OVITRAPS?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SUGAR_BAITS?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="OXITECH_RATIO">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FITNESS_SELECTED_RATIO">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WOLBACHIA_RATIO">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STERILE_RATIO">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="HUMAN_VISIT">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STORE_BITES">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STORE_HOUSE_CONTACT">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STORE_HUMAN_CONTACT">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STORE_CONTROL_RELEASES">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="EXPORT_RATE">
      <value value="144"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="CatemacoBaseline_HOM" repetitions="8" runMetricsEveryStep="false">
    <setup>setup
XML-setup-name (word "GeneratedData/CatemacoBaseline_HOM/CatemacoBaseline_HOM ") 
XML-init-write
XML-write-header "Novel Control Measures." "HMSC" "Replicating RIDL/Wolbachia papers in smaller scale."
XML-write-parameters
XML-init-write-ticks-body</setup>
    <go>go
XML-write-tick-outputs EXPORT_RATE</go>
    <final>ask humans[die-human]
XML-finish-write-ticks-body
XML-init-write-tail-body
XML-write-tail-outputs
XML-finish-write-tail-body
XML-finish-write</final>
    <timeLimit steps="100000"/>
    <enumeratedValueSet variable="RELEASE_WOLBACHIA">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RELEASE_STERILE">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RELEASE_FOGGING">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RELEASE_OXITECH">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RELEASE_FITNESS">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RELEASE_NEUTRAL">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TEMPERATURE_TYPE">
      <value value="&quot;Constant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CONSTANT_TEMPERATURE">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BreedingZonesNumber">
      <value value="&quot;GoogleMap&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FOOD_DYNAMICS?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FUMIGATION">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_EXTERMINATION">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_REPLACEMENT_WOLBACHIA">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_REPLACEMENT_STERILE">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_REPLACEMENT_OXITECH">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_REPLACEMENT_FITNESS">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="OVITRAPS?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SUGAR_BAITS?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="OXITECH_RATIO">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FITNESS_SELECTED_RATIO">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WOLBACHIA_RATIO">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STERILE_RATIO">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="HUMAN_VISIT">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STORE_BITES">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STORE_HOUSE_CONTACT">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STORE_HUMAN_CONTACT">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STORE_CONTROL_RELEASES">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="EXPORT_RATE">
      <value value="144"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="CatemacoWolbachia_HOM" repetitions="4" runMetricsEveryStep="false">
    <setup>setup
XML-setup-name (word "GeneratedData/CatemacoWolbachia_HOM/CatemacoWolbachia_HOM ") 
XML-init-write
XML-write-header "Novel Control Measures." "HMSC" "Replicating RIDL/Wolbachia papers in smaller scale."
XML-write-parameters
XML-init-write-ticks-body</setup>
    <go>go
XML-write-tick-outputs EXPORT_RATE</go>
    <final>ask humans[die-human]
XML-finish-write-ticks-body
XML-init-write-tail-body
XML-write-tail-outputs
XML-finish-write-tail-body
XML-finish-write</final>
    <timeLimit steps="100000"/>
    <enumeratedValueSet variable="RELEASE_WOLBACHIA">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RELEASE_FOGGING">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RELEASE_STERILE">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RELEASE_OXITECH">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RELEASE_FITNESS">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TEMPERATURE_TYPE">
      <value value="&quot;Constant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CONSTANT_TEMPERATURE">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BreedingZonesNumber">
      <value value="&quot;GoogleMap&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FOOD_DYNAMICS?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FUMIGATION">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_EXTERMINATION">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_REPLACEMENT_WOLBACHIA">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_REPLACEMENT_STERILE">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_REPLACEMENT_OXITECH">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_REPLACEMENT_FITNESS">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="OVITRAPS?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SUGAR_BAITS?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="OXITECH_RATIO">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FITNESS_SELECTED_RATIO">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WOLBACHIA_RATIO">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STERILE_RATIO">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="HUMAN_VISIT">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STORE_BITES">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STORE_HOUSE_CONTACT">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STORE_HUMAN_CONTACT">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STORE_CONTROL_RELEASES">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="EXPORT_RATE">
      <value value="144"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="CatemacoOxitec_HOM" repetitions="8" runMetricsEveryStep="false">
    <setup>setup
XML-setup-name (word "GeneratedData/CatemacoOxitec_HOM/CatemacoOxitec_HOM ") 
XML-init-write
XML-write-header "Novel Control Measures." "HMSC" "Replicating RIDL/Wolbachia papers in smaller scale."
XML-write-parameters
XML-init-write-ticks-body</setup>
    <go>go
XML-write-tick-outputs EXPORT_RATE</go>
    <final>ask humans[die-human]
XML-finish-write-ticks-body
XML-init-write-tail-body
XML-write-tail-outputs
XML-finish-write-tail-body
XML-finish-write</final>
    <timeLimit steps="100000"/>
    <enumeratedValueSet variable="RELEASE_WOLBACHIA">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RELEASE_STERILE">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RELEASE_FOGGING">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RELEASE_OXITECH">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RELEASE_FITNESS">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TEMPERATURE_TYPE">
      <value value="&quot;Constant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CONSTANT_TEMPERATURE">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BreedingZonesNumber">
      <value value="&quot;GoogleMap&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FOOD_DYNAMICS?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FUMIGATION">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_EXTERMINATION">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_REPLACEMENT_WOLBACHIA">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_REPLACEMENT_STERILE">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_REPLACEMENT_OXITECH">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_REPLACEMENT_FITNESS">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="OVITRAPS?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SUGAR_BAITS?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="OXITECH_RATIO">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FITNESS_SELECTED_RATIO">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WOLBACHIA_RATIO">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STERILE_RATIO">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="HUMAN_VISIT">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STORE_BITES">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STORE_HOUSE_CONTACT">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STORE_HUMAN_CONTACT">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STORE_CONTROL_RELEASES">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="EXPORT_RATE">
      <value value="144"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="CatemacoFogging_HOM" repetitions="8" runMetricsEveryStep="false">
    <setup>setup
XML-setup-name (word "GeneratedData/CatemacoFogging_HOM/CatemacoFogging_HOM ") 
XML-init-write
XML-write-header "Novel Control Measures." "HMSC" "Replicating RIDL/Wolbachia papers in smaller scale."
XML-write-parameters
XML-init-write-ticks-body</setup>
    <go>go
XML-write-tick-outputs EXPORT_RATE</go>
    <final>ask humans[die-human]
XML-finish-write-ticks-body
XML-init-write-tail-body
XML-write-tail-outputs
XML-finish-write-tail-body
XML-finish-write</final>
    <timeLimit steps="100000"/>
    <enumeratedValueSet variable="RELEASE_FOGGING">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RELEASE_WOLBACHIA">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RELEASE_STERILE">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RELEASE_OXITECH">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RELEASE_NEUTRAL">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RELEASE_FITNESS">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TEMPERATURE_TYPE">
      <value value="&quot;Constant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CONSTANT_TEMPERATURE">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BreedingZonesNumber">
      <value value="&quot;GoogleMap&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FOOD_DYNAMICS?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FUMIGATION">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_EXTERMINATION">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_REPLACEMENT_WOLBACHIA">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_REPLACEMENT_STERILE">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_REPLACEMENT_OXITECH">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_REPLACEMENT_FITNESS">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="OVITRAPS?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SUGAR_BAITS?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="OXITECH_RATIO">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FITNESS_SELECTED_RATIO">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WOLBACHIA_RATIO">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STERILE_RATIO">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="HUMAN_VISIT">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STORE_BITES">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STORE_HOUSE_CONTACT">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STORE_HUMAN_CONTACT">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STORE_CONTROL_RELEASES">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="EXPORT_RATE">
      <value value="144"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="HumanVisitingNG_000000" repetitions="8" runMetricsEveryStep="false">
    <setup>setup
XML-setup-name (word "GeneratedData/000000VisitNG/000000VisitNG ") 
XML-init-write
XML-write-header "Human Movement." "HMSC" ""
XML-write-parameters
XML-init-write-ticks-body</setup>
    <go>go
XML-write-tick-outputs EXPORT_RATE</go>
    <final>ask humans[die-human]
XML-finish-write-ticks-body
XML-init-write-tail-body
XML-write-tail-outputs
XML-finish-write-tail-body
XML-finish-write</final>
    <timeLimit steps="125000"/>
    <enumeratedValueSet variable="HUMAN_VISITING_PROBABILITY">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="GRAVITY_VISIT?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RELEASE_WOLBACHIA">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RELEASE_STERILE">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RELEASE_FOGGING">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RELEASE_OXITECH">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RELEASE_FITNESS">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RELEASE_NEUTRAL">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TEMPERATURE_TYPE">
      <value value="&quot;Constant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CONSTANT_TEMPERATURE">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BreedingZonesNumber">
      <value value="&quot;GoogleMap&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FOOD_DYNAMICS?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FUMIGATION">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_EXTERMINATION">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_REPLACEMENT_WOLBACHIA">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_REPLACEMENT_STERILE">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_REPLACEMENT_OXITECH">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BREEDING_REPLACEMENT_FITNESS">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="OVITRAPS?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SUGAR_BAITS?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="OXITECH_RATIO">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FITNESS_SELECTED_RATIO">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WOLBACHIA_RATIO">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STERILE_RATIO">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="HUMAN_VISIT">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STORE_BITES">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STORE_HOUSE_CONTACT">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STORE_HUMAN_CONTACT">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STORE_CONTROL_RELEASES">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="EXPORT_RATE">
      <value value="144"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@

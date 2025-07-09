#!/bin/bash
# Project Zomboid Server Sandbox Variables
#
# This script defines default environment variables for Project Zomboid
# server sandbox configuration that correspond to the sandbox settings in the game.
# These variables control world generation, gameplay difficulty, zombie behavior,
# survival mechanics, vehicle settings, and other sandbox-specific parameters.
#
# These environment variables can be overridden at runtime to customize
# sandbox configuration when running in Docker or other containerized environments.
# Each variable uses the bash parameter expansion syntax ${VAR:-default} to
# provide fallback values if not explicitly set.
#
# Usage:
#   Source this file before generating sandbox configuration:
#   source ./server-sandbox-vars.sh
#
# Docker Usage:
#   Override any variable using Docker's -e flag:
#   docker run -e ZOMBIES="5" -e XP_MULTIPLIER="2.0" -e PVP="false" <image>
#
# Configuration Categories:
#   - World settings (version, zombie distribution, day length)
#   - Utilities and infrastructure (water/electricity shutoff)
#   - Loot and item spawning (food, weapons, medical supplies)
#   - Environmental factors (temperature, rain, erosion)
#   - Character progression (XP multipliers, free points)
#   - Survival mechanics (nutrition, injury severity, corpse removal)
#   - Vehicle system (spawn rates, fuel, damage, traffic)
#   - Map configuration (mini-map, world map visibility)
#   - Zombie behavior (speed, strength, cognition, population)
#   - Advanced zombie settings (respawn, rally mechanics)

# Enable automatic export of all variables
set -a

VERSION="${VERSION:-5}"

# Changing this sets the "Population Multiplier" advanced option. Default=Normal
# 1 = Insane
# 2 = Very High
# 3 = High
# 4 = Normal
# 5 = Low
ZOMBIES="${ZOMBIES:-4}"

# Default=Urban Focused
# 1 = Urban Focused
DISTRIBUTION="${DISTRIBUTION:-1}"

# Default=1 Hour
# 1 = 15 Minutes
# 2 = 30 Minutes
# 3 = 1 Hour
# 4 = 2 Hours
# 5 = 3 Hours
# 6 = 4 Hours
# 7 = 5 Hours
# 8 = 6 Hours
# 9 = 7 Hours
# 10 = 8 Hours
# 11 = 9 Hours
# 12 = 10 Hours
# 13 = 11 Hours
# 14 = 12 Hours
# 15 = 13 Hours
# 16 = 14 Hours
# 17 = 15 Hours
# 18 = 16 Hours
# 19 = 17 Hours
# 20 = 18 Hours
# 21 = 19 Hours
# 22 = 20 Hours
# 23 = 21 Hours
# 24 = 22 Hours
# 25 = 23 Hours
DAY_LENGTH="${DAY_LENGTH:-3}"

START_YEAR="${START_YEAR:-1}"

# Default=July
# 1 = January
# 2 = February
# 3 = March
# 4 = April
# 5 = May
# 6 = June
# 7 = July
# 8 = August
# 9 = September
# 10 = October
# 11 = November
START_MONTH="${START_MONTH:-7}"

START_DAY="${START_DAY:-9}"

# Default=9 AM
# 1 = 7 AM
# 2 = 9 AM
# 3 = 12 PM
# 4 = 2 PM
# 5 = 5 PM
# 6 = 9 PM
# 7 = 12 AM
# 8 = 2 AM
START_TIME="${START_TIME:-2}"

# Default=0-30 Days
# 1 = Instant
# 2 = 0-30 Days
# 3 = 0-2 Months
# 4 = 0-6 Months
# 5 = 0-1 Year
# 6 = 0-5 Years
# 7 = 2-6 Months
WATER_SHUT="${WATER_SHUT:-2}"

# Default=0-30 Days
# 1 = Instant
# 2 = 0-30 Days
# 3 = 0-2 Months
# 4 = 0-6 Months
# 5 = 0-1 Year
# 6 = 0-5 Years
# 7 = 2-6 Months
ELEC_SHUT="${ELEC_SHUT:-2}"

# Minimum=-1 Maximum=2147483647 Default=14
WATER_SHUT_MODIFIER="${WATER_SHUT_MODIFIER:-14}"

# Minimum=-1 Maximum=2147483647 Default=14
ELEC_SHUT_MODIFIER="${ELEC_SHUT_MODIFIER:-14}"

# Default=Rare
# 1 = None (not recommended)
# 2 = Insanely Rare
# 3 = Extremely Rare
# 4 = Rare
# 5 = Normal
# 6 = Common
FOOD_LOOT="${FOOD_LOOT:-4}"

# Default=Rare
# 1 = None (not recommended)
# 2 = Insanely Rare
# 3 = Extremely Rare
# 4 = Rare
# 5 = Normal
# 6 = Common
CANNED_FOOD_LOOT="${CANNED_FOOD_LOOT:-4}"

# Default=Rare
# 1 = None (not recommended)
# 2 = Insanely Rare
# 3 = Extremely Rare
# 4 = Rare
# 5 = Normal
# 6 = Common
LITERATURE_LOOT="${LITERATURE_LOOT:-4}"

# Seeds, Nails, Saws, Fishing Rods, various tools, etc... Default=Rare
# 1 = None (not recommended)
# 2 = Insanely Rare
# 3 = Extremely Rare
# 4 = Rare
# 5 = Normal
# 6 = Common
SURVIVAL_GEARS_LOOT="${SURVIVAL_GEARS_LOOT:-4}"

# Default=Rare
# 1 = None (not recommended)
# 2 = Insanely Rare
# 3 = Extremely Rare
# 4 = Rare
# 5 = Normal
# 6 = Common
MEDICAL_LOOT="${MEDICAL_LOOT:-4}"

# Default=Rare
# 1 = None (not recommended)
# 2 = Insanely Rare
# 3 = Extremely Rare
# 4 = Rare
# 5 = Normal
# 6 = Common
WEAPON_LOOT="${WEAPON_LOOT:-4}"

# Default=Rare
# 1 = None (not recommended)
# 2 = Insanely Rare
# 3 = Extremely Rare
# 4 = Rare
# 5 = Normal
# 6 = Common
RANGED_WEAPON_LOOT="${RANGED_WEAPON_LOOT:-4}"

# Default=Rare
# 1 = None (not recommended)
# 2 = Insanely Rare
# 3 = Extremely Rare
# 4 = Rare
# 5 = Normal
# 6 = Common
AMMO_LOOT="${AMMO_LOOT:-4}"

# Default=Rare
# 1 = None (not recommended)
# 2 = Insanely Rare
# 3 = Extremely Rare
# 4 = Rare
# 5 = Normal
# 6 = Common
MECHANICS_LOOT="${MECHANICS_LOOT:-4}"

# Everything else. Also affects foraging for all items in Town/Road zones. Default=Rare
# 1 = None (not recommended)
# 2 = Insanely Rare
# 3 = Extremely Rare
# 4 = Rare
# 5 = Normal
# 6 = Common
OTHER_LOOT="${OTHER_LOOT:-4}"

# Controls the global temperature. Default=Normal
# 1 = Very Cold
# 2 = Cold
# 3 = Normal
# 4 = Hot
TEMPERATURE="${TEMPERATURE:-3}"

# Controls how often it rains. Default=Normal
# 1 = Very Dry
# 2 = Dry
# 3 = Normal
# 4 = Rainy
RAIN="${RAIN:-3}"

# Number of days until 100% growth. Default=Normal (100 Days)
# 1 = Very Fast (20 Days)
# 2 = Fast (50 Days)
# 3 = Normal (100 Days)
# 4 = Slow (200 Days)
EROSION_SPEED="${EROSION_SPEED:-3}"

# Number of days until 100% growth. -1 means no growth. Zero means use the Erosion Speed option. Maximum 36,500 (100 years). Minimum=-1 Maximum=36500 Default=0
EROSION_DAYS="${EROSION_DAYS:-0}"

# Modifies the base XP gain from actions by this number. Minimum=0.00 Maximum=1000.00 Default=1.00
XP_MULTIPLIER="${XP_MULTIPLIER:-1.0}"

# Use this to multiply or reduce engine general loudness. Minimum=0.00 Maximum=100.00 Default=1.00
ZOMBIE_ATTRACTION_MULTIPLIER="${ZOMBIE_ATTRACTION_MULTIPLIER:-1.0}"

# Governs whether cars are locked, need keys to start etc.
VEHICLE_EASY_USE="${VEHICLE_EASY_USE:-false}"

# Controls the speed of plant growth. Default=Normal
# 1 = Very Fast
# 2 = Fast
# 3 = Normal
# 4 = Slow
FARMING="${FARMING:-3}"

# Controls the time it takes for food to break down in a composter. Default=2 Weeks
# 1 = 1 Week
# 2 = 2 Weeks
# 3 = 3 Weeks
# 4 = 4 Weeks
# 5 = 6 Weeks
# 6 = 8 Weeks
# 7 = 10 Weeks
COMPOST_TIME="${COMPOST_TIME:-2}"

# How fast character's hunger, thirst and fatigue will decrease. Default=Normal
# 1 = Very Fast
# 2 = Fast
# 3 = Normal
# 4 = Slow
STATS_DECREASE="${STATS_DECREASE:-3}"

# Controls the abundance of fish and general forage. Default=Normal
# 1 = Very Poor
# 2 = Poor
# 3 = Normal
# 4 = Abundant
NATURE_ABUNDANCE="${NATURE_ABUNDANCE:-3}"

# Default=Sometimes
# 1 = Never
# 2 = Extremely Rare
# 3 = Rare
# 4 = Sometimes
# 5 = Often
ALARM="${ALARM:-4}"

# How frequently homes and buildings will be discovered locked Default=Very Often
# 1 = Never
# 2 = Extremely Rare
# 3 = Rare
# 4 = Sometimes
# 5 = Often
LOCKED_HOUSES="${LOCKED_HOUSES:-6}"

# Spawn with chips, water bottle, school bag, baseball bat and a hammer.
STARTER_KIT="${STARTER_KIT:-false}"

# Nutritional value of food affects the player's condition.
NUTRITION="${NUTRITION:-true}"

# Define how fast the food will spoil inside or outside fridge. Default=Normal
# 1 = Very Fast
# 2 = Fast
# 3 = Normal
# 4 = Slow
FOOD_ROT_SPEED="${FOOD_ROT_SPEED:-3}"

# Define how much a fridge will be effective. Default=Normal
# 1 = Very Low
# 2 = Low
# 3 = Normal
# 4 = High
FRIDGE_FACTOR="${FRIDGE_FACTOR:-3}"

# Items will respawn in already-looted containers in towns and trailer parks. Items will not respawn in player-made containers. Default=None
# 1 = None
# 2 = Every Day
# 3 = Every Week
# 4 = Every Month
LOOT_RESPAWN="${LOOT_RESPAWN:-1}"

# When > 0, loot will not respawn in zones that have been visited within this number of in-game hours. Minimum=0 Maximum=2147483647 Default=0
SEEN_HOURS_PREVENT_LOOT_RESPAWN="${SEEN_HOURS_PREVENT_LOOT_RESPAWN:-0}"

# A comma-separated list of item types that will be removed after HoursForWorldItemRemoval hours.
WORLD_ITEM_REMOVAL_LIST="${WORLD_ITEM_REMOVAL_LIST:-"Base.Hat,Base.Glasses,Base.Maggots"}"

# Number of hours since an item was dropped on the ground before it is removed.  Items are removed the next time that part of the map is loaded.  Zero means items are not removed. Minimum=0.00 Maximum=2147483647.00 Default=24.00
HOURS_FOR_WORLD_ITEM_REMOVAL="${HOURS_FOR_WORLD_ITEM_REMOVAL:-24.0}"

# If true, any items *not* in WorldItemRemovalList will be removed.
ITEM_REMOVAL_LIST_BLACKLIST_TOGGLE="${ITEM_REMOVAL_LIST_BLACKLIST_TOGGLE:-false}"

# This will affect starting world erosion and food spoilage. Default=0
# 1 = 0
# 2 = 1
# 3 = 2
# 4 = 3
# 5 = 4
# 6 = 5
# 7 = 6
# 8 = 7
# 9 = 8
# 10 = 9
# 11 = 10
# 12 = 11
TIME_SINCE_APO="${TIME_SINCE_APO:-1}"

# Will influence how much water the plant will lose per day and their ability to avoid disease. Default=Normal
# 1 = Very High
# 2 = High
# 3 = Normal
# 4 = Low
PLANT_RESILIENCE="${PLANT_RESILIENCE:-3}"

# Controls the yield of plants when harvested. Default=Normal
# 1 = Very Poor
# 2 = Poor
# 3 = Normal
# 4 = Abundant
PLANT_ABUNDANCE="${PLANT_ABUNDANCE:-3}"

# Recovery from being tired from performing actions Default=Normal
# 1 = Very Fast
# 2 = Fast
# 3 = Normal
# 4 = Slow
END_REGEN="${END_REGEN:-3}"

# How regularly helicopters pass over the event zone. Default=Once
# 1 = Never
# 2 = Once
# 3 = Sometimes
HELICOPTER="${HELICOPTER:-2}"

# How often zombie attracting metagame events like distant gunshots will occur. Default=Sometimes
# 1 = Never
# 2 = Sometimes
META_EVENT="${META_EVENT:-2}"

# Governs night-time metagame events during the player's sleep. Default=Never
# 1 = Never
# 2 = Sometimes
SLEEPING_EVENT="${SLEEPING_EVENT:-1}"

# Increase/decrease the chance of electrical generators spawning on the map. Default=Sometimes
# 1 = Extremely Rare
# 2 = Rare
# 3 = Sometimes
# 4 = Often
GENERATOR_SPAWNING="${GENERATOR_SPAWNING:-3}"

# How much fuel is consumed per in-game hour. Minimum=0.00 Maximum=100.00 Default=1.00
GENERATOR_FUEL_CONSUMPTION="${GENERATOR_FUEL_CONSUMPTION:-1.0}"

# Increase/decrease probability of discovering randomized safe houses on the map: either burnt out, containing loot stashes, dead survivor bodies etc. Default=Rare
# 1 = Never
# 2 = Extremely Rare
# 3 = Rare
# 4 = Sometimes
# 5 = Often
SURVIVOR_HOUSE_CHANCE="${SURVIVOR_HOUSE_CHANCE:-3}"

# Default=Rare
# 1 = Never
# 2 = Extremely Rare
# 3 = Rare
# 4 = Sometimes
# 5 = Often
VEHICLE_STORY_CHANCE="${VEHICLE_STORY_CHANCE:-3}"

# Default=Rare
# 1 = Never
# 2 = Extremely Rare
# 3 = Rare
# 4 = Sometimes
# 5 = Often
ZONE_STORY_CHANCE="${ZONE_STORY_CHANCE:-3}"

# Impacts on how often a looted map will have annotations marked on it by a deceased survivor. Default=Sometimes
# 1 = Never
# 2 = Extremely Rare
# 3 = Rare
# 4 = Sometimes
# 5 = Often
ANNOTATED_MAP_CHANCE="${ANNOTATED_MAP_CHANCE:-4}"

# Adds free points during character creation. Minimum=-100 Maximum=100 Default=0
CHARACTER_FREE_POINTS="${CHARACTER_FREE_POINTS:-0}"

# Gives player-built constructions extra hit points so they are more resistant to zombie damage. Default=Normal
# 1 = Very Low
# 2 = Low
# 3 = Normal
# 4 = High
CONSTRUCTION_BONUS_POINTS="${CONSTRUCTION_BONUS_POINTS:-3}"

# Governs the ambient lighting at night. Default=Normal
# 1 = Pitch Black
# 2 = Dark
# 3 = Normal
NIGHT_DARKNESS="${NIGHT_DARKNESS:-3}"

# Increase and decrease the impact injuries have on your body, and their healing time. Default=Normal
# 1 = Low
# 2 = Normal
INJURY_SEVERITY="${INJURY_SEVERITY:-2}"

# Enable or disable broken limbs when survivors receive injuries from impacts, zombie damage and falls.
BONE_FRACTURE="${BONE_FRACTURE:-true}"

# How long before zombie bodies disappear. Minimum=-1.00 Maximum=2147483647.00 Default=216.00
HOURS_FOR_CORPSE_REMOVAL="${HOURS_FOR_CORPSE_REMOVAL:-216.0}"

# Governs impact that nearby decaying bodies has on the player's health and emotions. Default=Normal
# 1 = None
# 2 = Low
# 3 = Normal
DECAYING_CORPSE_HEALTH_IMPACT="${DECAYING_CORPSE_HEALTH_IMPACT:-3}"

# How much blood is sprayed on floor and walls. Default=Normal
# 1 = None
# 2 = Low
# 3 = Normal
# 4 = High
BLOOD_LEVEL="${BLOOD_LEVEL:-3}"

# Governs how quickly clothing degrades, becomes dirty, and bloodied. Default=Normal
# 1 = Disabled
# 2 = Slow
# 3 = Normal
CLOTHING_DEGRADATION="${CLOTHING_DEGRADATION:-3}"

FIRE_SPREAD="${FIRE_SPREAD:-true}"

# Number of in-game days before rotten food is removed from the map. -1 means rotten food is never removed. Minimum=-1 Maximum=2147483647 Default=-1
DAYS_FOR_ROTTEN_FOOD_REMOVAL="${DAYS_FOR_ROTTEN_FOOD_REMOVAL:--1}"

# If enabled, generators will work on exterior tiles, allowing for example to power gas pump.
ALLOW_EXTERIOR_GENERATOR="${ALLOW_EXTERIOR_GENERATOR:-true}"

# Controls the maximum intensity of fog. Default=Normal
# 1 = Normal
# 2 = Moderate
MAX_FOG_INTENSITY="${MAX_FOG_INTENSITY:-1}"

# Controls the maximum intensity of rain. Default=Normal
# 1 = Normal
# 2 = Moderate
MAX_RAIN_FX_INTENSITY="${MAX_RAIN_FX_INTENSITY:-1}"

# If disabled snow will not accumulate on ground but will still be visible on vegetation and rooftops.
ENABLE_SNOW_ON_GROUND="${ENABLE_SNOW_ON_GROUND:-true}"

# if disabled, tainted water will not have a warning marking it as such
ENABLE_TAINTED_WATER_TEXT="${ENABLE_TAINTED_WATER_TEXT:-true}"

# When enabled certain melee weapons will be able to strike multiple zombies in one hit.
MULTI_HIT_ZOMBIES="${MULTI_HIT_ZOMBIES:-false}"

# Chance of being bitten when a zombie attacks from behind. Default=High
# 1 = Low
# 2 = Medium
REAR_VULNERABILITY="${REAR_VULNERABILITY:-3}"

# Disable to walk unimpeded while melee attacking.
ATTACK_BLOCK_MOVEMENTS="${ATTACK_BLOCK_MOVEMENTS:-true}"

ALL_CLOTHES_UNLOCKED="${ALL_CLOTHES_UNLOCKED:-false}"

# Governs how frequently cars are discovered on the map Default=Low
# 1 = None
# 2 = Very Low
# 3 = Low
# 4 = Normal
CAR_SPAWN_RATE="${CAR_SPAWN_RATE:-3}"

# Governs the chances of finding vehicles with gas in the tank. Default=Low
# 1 = Low
# 2 = Normal
CHANCE_HAS_GAS="${CHANCE_HAS_GAS:-1}"

# Governs how full gas tanks will be in discovered cars. Default=Low
# 1 = Very Low
# 2 = Low
# 3 = Normal
# 4 = High
# 5 = Very High
INITIAL_GAS="${INITIAL_GAS:-2}"

# Governs how full gas tanks in fuel station will be, initially. Default=Normal
# 1 = Empty
# 2 = Super Low
# 3 = Very Low
# 4 = Low
# 5 = Normal
# 6 = High
# 7 = Very High
# 8 = Full
FUEL_STATION_GAS="${FUEL_STATION_GAS:-5}"

# How gas-hungry vehicles on the map are. Minimum=0.00 Maximum=100.00 Default=1.00
CAR_GAS_CONSUMPTION="${CAR_GAS_CONSUMPTION:-1.0}"

# Default=Rare
# 1 = Never
# 2 = Extremely Rare
# 3 = Rare
# 4 = Sometimes
# 5 = Often
LOCKED_CAR="${LOCKED_CAR:-3}"

# General condition of vehicles discovered on the map Default=Low
# 1 = Very Low
# 2 = Low
# 3 = Normal
# 4 = High
CAR_GENERAL_CONDITION="${CAR_GENERAL_CONDITION:-2}"

# Governs the amount of damage dealt to vehicles that crash. Default=Normal
# 1 = Very Low
# 2 = Low
# 3 = Normal
# 4 = High
CAR_DAMAGE_ON_IMPACT="${CAR_DAMAGE_ON_IMPACT:-3}"

# Damage received by the player from the car in a collision. Default=None
# 1 = None
# 2 = Low
# 3 = Normal
# 4 = High
DAMAGE_TO_PLAYER_FROM_HIT_BY_A_CAR="${DAMAGE_TO_PLAYER_FROM_HIT_BY_A_CAR:-1}"

# Enable or disable traffic jams that spawn on the main roads of the map.
TRAFFIC_JAM="${TRAFFIC_JAM:-true}"

# How frequently cars will be discovered with an alarm. Default=Extremely Rare
# 1 = Never
# 2 = Extremely Rare
# 3 = Rare
# 4 = Sometimes
# 5 = Often
CAR_ALARM="${CAR_ALARM:-2}"

# Enable or disable player getting damage from being in a car accident.
PLAYER_DAMAGE_FROM_CRASH="${PLAYER_DAMAGE_FROM_CRASH:-true}"

# How many in-game hours before a wailing siren shuts off. Minimum=0.00 Maximum=168.00 Default=0.00
SIREN_SHUTOFF_HOURS="${SIREN_SHUTOFF_HOURS:-0.0}"

#  Governs whether player can discover a car that has been maintained and cared for after the infection struck. Default=Low
# 1 = None
# 2 = Low
# 3 = Normal
RECENTLY_SURVIVOR_VEHICLES="${RECENTLY_SURVIVOR_VEHICLES:-2}"

# Enables vehicles to spawn.
ENABLE_VEHICLES="${ENABLE_VEHICLES:-true}"

# Governs if poisoning food is enabled. Default=True
# 1 = True
# 2 = False
ENABLE_POISONING="${ENABLE_POISONING:-1}"

# Default=In and around bodies
# 1 = In and around bodies
# 2 = In bodies only
MAGGOT_SPAWN="${MAGGOT_SPAWN:-1}"

# --------------------------------------------------------------
# Nested categories for map settings
ALLOW_MINI_MAP="${ALLOW_MINI_MAP:-false}"
ALLOW_WORLD_MAP="${ALLOW_WORLD_MAP:-true}"
MAP_ALL_KNOWN="${MAP_ALL_KNOWN:-false}"

# --------------------------------------------------------------
# Nested categories for zombie lore settings
# Controls the zombie movement rate. Default=Fast Shamblers
# 1 = Sprinters
# 2 = Fast Shamblers
# 3 = Shamblers
SPEED="${SPEED:-2}"

# Controls the damage zombies inflict per attack. Default=Normal
# 1 = Superhuman
# 2 = Normal
# 3 = Weak
STRENGTH="${STRENGTH:-2}"

# Controls the difficulty to kill zombies. Default=Normal
# 1 = Tough
# 2 = Normal
# 3 = Fragile
TOUGHNESS="${TOUGHNESS:-2}"

# Controls how the zombie virus spreads. Default=Blood + Saliva
# 1 = Blood + Saliva
# 2 = Saliva Only
# 3 = Everyone's Infected
TRANSMISSION="${TRANSMISSION:-1}"

# Controls how quickly the infection takes effect. Default=2-3 Days
# 1 = Instant
# 2 = 0-30 Seconds
# 3 = 0-1 Minutes
# 4 = 0-12 Hours
# 5 = 2-3 Days
# 6 = 1-2 Weeks
MORTALITY="${MORTALITY:-5}"

# Controls how quickly corpses rise as zombies. Default=0-1 Minutes
# 1 = Instant
# 2 = 0-30 Seconds
# 3 = 0-1 Minutes
# 4 = 0-12 Hours
# 5 = 2-3 Days
REANIMATE="${REANIMATE:-3}"

# Controls zombie intelligence. Default=Basic Navigation
# 1 = Navigate + Use Doors
# 2 = Navigate
# 3 = Basic Navigation
COGNITION="${COGNITION:-3}"

# Controls which zombies can crawl under vehicles. Default=Often
# 1 = Crawlers Only
# 2 = Extremely Rare
# 3 = Rare
# 4 = Sometimes
# 5 = Often
# 6 = Very Often
CRAWL_UNDER_VEHICLE="${CRAWL_UNDER_VEHICLE:-5}"

# Controls how long zombies remember players after seeing or hearing. Default=Normal
# 1 = Long
# 2 = Normal
# 3 = Short
# 4 = None
MEMORY="${MEMORY:-2}"

# Controls zombie vision radius. Default=Normal
# 1 = Eagle
# 2 = Normal
# 3 = Poor
SIGHT="${SIGHT:-2}"

# Controls zombie hearing radius. Default=Normal
# 1 = Pinpoint
# 2 = Normal
# 3 = Poor
HEARING="${HEARING:-2}"

# Zombies that have not seen/heard player can attack doors and constructions while roaming.
THUMP_NO_CHASING="${THUMP_NO_CHASING:-false}"

# Governs whether or not zombies can destroy player constructions and defences.
THUMP_ON_CONSTRUCTION="${THUMP_ON_CONSTRUCTION:-true}"

# Governs whether zombies are more active during the day, or whether they act more nocturnally.  Active zombies will use the speed set in the "Speed" setting. Inactive zombies will be slower, and tend not to give chase. Default=Both
# 1 = Both
# 2 = Night
ACTIVE_ONLY="${ACTIVE_ONLY:-1}"

# Allows zombies to trigger house alarms when breaking through windows and doors.
TRIGGER_HOUSE_ALARM="${TRIGGER_HOUSE_ALARM:-false}"

# When enabled if multiple zombies are attacking they can drag you down to feed. Dependent on zombie strength.
ZOMBIES_DRAG_DOWN="${ZOMBIES_DRAG_DOWN:-true}"

# When enabled zombies will have a chance to lunge after climbing over a fence if you're too close.
ZOMBIES_FENCE_LUNGE="${ZOMBIES_FENCE_LUNGE:-true}"

# Default=Some zombies in the world will pretend to be dead
# 1 = Some zombies in the world will pretend to be dead
# 2 = Some zombies in the world, as well as some you 'kill', can pretend to be dead
DISABLE_FAKE_DEAD="${DISABLE_FAKE_DEAD:-1}"

# --------------------------------------------------------------
# Nested categories for zombie settings
# Set by the "Zombie Count" population option. 4.0 = Insane, Very High = 3.0, 2.0 = High, 1.0 = Normal, 0.35 = Low, 0.0 = None. Minimum=0.00 Maximum=4.00 Default=1.00
POPULATION_MULTIPLIER="${POPULATION_MULTIPLIER:-1.0}"

# Adjusts the desired population at the start of the game. Minimum=0.00 Maximum=4.00 Default=1.00
POPULATION_START_MULTIPLIER="${POPULATION_START_MULTIPLIER:-1.0}"

# Adjusts the desired population on the peak day. Minimum=0.00 Maximum=4.00 Default=1.50
POPULATION_PEAK_MULTIPLIER="${POPULATION_PEAK_MULTIPLIER:-1.5}"

# The day when the population reaches it's peak. Minimum=1 Maximum=365 Default=28
POPULATION_PEAK_DAY="${POPULATION_PEAK_DAY:-28}"

# The number of hours that must pass before zombies may respawn in a cell. If zero, spawning is disabled. Minimum=0.00 Maximum=8760.00 Default=72.00
RESPAWN_HOURS="${RESPAWN_HOURS:-72.0}"

# The number of hours that a chunk must be unseen before zombies may respawn in it. Minimum=0.00 Maximum=8760.00 Default=16.00
RESPAWN_UNSEEN_HOURS="${RESPAWN_UNSEEN_HOURS:-16.0}"

# The fraction of a cell's desired population that may respawn every RespawnHours. Minimum=0.00 Maximum=1.00 Default=0.10
RESPAWN_MULTIPLIER="${RESPAWN_MULTIPLIER:-0.1}"

# The number of hours that must pass before zombies migrate to empty parts of the same cell. If zero, migration is disabled. Minimum=0.00 Maximum=8760.00 Default=12.00
REDISTRIBUTE_HOURS="${REDISTRIBUTE_HOURS:-12.0}"

# The distance a zombie will try to walk towards the last sound it heard. Minimum=10 Maximum=1000 Default=100
FOLLOW_SOUND_DISTANCE="${FOLLOW_SOUND_DISTANCE:-100}"

# The size of groups real zombies form when idle. Zero means zombies don't form groups. Groups don't form inside buildings or forest zones. Minimum=0 Maximum=1000 Default=20
RALLY_GROUP_SIZE="${RALLY_GROUP_SIZE:-20}"

# The distance real zombies travel to form groups when idle. Minimum=5 Maximum=50 Default=20
RALLY_TRAVEL_DISTANCE="${RALLY_TRAVEL_DISTANCE:-20}"

# The distance between zombie groups. Minimum=5 Maximum=25 Default=15
RALLY_GROUP_SEPARATION="${RALLY_GROUP_SEPARATION:-15}"

# How close members of a group stay to the group's leader. Minimum=1 Maximum=10 Default=3
RALLY_GROUP_RADIUS="${RALLY_GROUP_RADIUS:-3}"

# Disable automatic export
set +a

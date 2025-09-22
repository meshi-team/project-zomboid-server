# Server Sandbox Variables

## Description

This document lists all the environment variables you can customize for Project Zomboid server sandbox configuration. These variables control world generation, gameplay difficulty, zombie behavior, survival mechanics, vehicle settings, and other sandbox-specific parameters that define how the game world behaves. This allows you to configure your server without modifying any files, simply override them when starting your container.

**All variables listed below can be customized using Docker's `-e` flag.**

## Table of Contents

- [Description](#description)
- [Table of Contents](#table-of-contents)
- [How to Override Variables](#how-to-override-variables)
- [Available Configuration Variables](#available-configuration-variables)
- [Most Common Variables to Change](#most-common-variables-to-change)
- [Quick Reference](#quick-reference)
  - [Numeric Options](#numeric-options)
  - [Boolean Values](#boolean-values)
  - [Multiplier Values](#multiplier-values)
  - [Time Values](#time-values)

## How to Override Variables

Use Docker Compose and add your variables under the `environment:` key:

```yaml
version: "3.8"
services:
  zomboid-server:
    image: <your-image>
    environment:
      - SERVER_NAME=My Server
      - PORT=16262
      - SERVER_MEMORY=4096m
      - ADMIN_USERNAME=admin
      - ADMIN_PASSWORD=your_password
    ports:
      - "16262:16262"
```

## Available Configuration Variables

The following table shows all variables you can override, their purpose, and default values:

> **💡 Tip**: For more complete descriptions of available values and detailed explanations, refer to the original `server-sandbox-vars.sh` file which contains extensive comments for each setting.

| Variable Name                        | Description                                                                                             | Default Value                          |
| ------------------------------------ | ------------------------------------------------------------------------------------------------------- | -------------------------------------- |
| `VERSION`                            | Sandbox configuration version                                                                           | `5`                                    |
| `ZOMBIES`                            | Population Multiplier (1=Insane, 2=Very High, 3=High, 4=Normal, 5=Low)                                  | `3`                                    |
| `DISTRIBUTION`                       | Zombie distribution pattern (1=Urban Focused)                                                           | `1`                                    |
| `DAY_LENGTH`                         | Length of in-game day (1=15min, 2=30min, 3=1hr, etc. up to 25=23hr)                                     | `3`                                    |
| `START_YEAR`                         | Starting year of the apocalypse                                                                         | `1`                                    |
| `START_MONTH`                        | Starting month (1=January, 2=February, etc.)                                                            | `7`                                    |
| `START_DAY`                          | Starting day of the month                                                                               | `9`                                    |
| `START_TIME`                         | Starting time of day (1=7AM, 2=9AM, 3=12PM, etc.)                                                       | `2`                                    |
| `WATER_SHUT`                         | When water shuts off (1=Instant, 2=0-30 Days, 3=0-2 Months, etc.)                                       | `2`                                    |
| `ELEC_SHUT`                          | When electricity shuts off (1=Instant, 2=0-30 Days, 3=0-2 Months, etc.)                                 | `2`                                    |
| `WATER_SHUT_MODIFIER`                | Water shutoff modifier in days                                                                          | `14`                                   |
| `ELEC_SHUT_MODIFIER`                 | Electricity shutoff modifier in days                                                                    | `14`                                   |
| `FOOD_LOOT`                          | Food loot abundance (1=None, 2=Insanely Rare, 3=Extremely Rare, 4=Rare, 5=Normal, 6=Common)             | `4`                                    |
| `CANNED_FOOD_LOOT`                   | Canned food loot abundance                                                                              | `4`                                    |
| `LITERATURE_LOOT`                    | Literature loot abundance                                                                               | `4`                                    |
| `SURVIVAL_GEARS_LOOT`                | Survival gear loot abundance (seeds, tools, etc.)                                                       | `4`                                    |
| `MEDICAL_LOOT`                       | Medical supplies loot abundance                                                                         | `4`                                    |
| `WEAPON_LOOT`                        | Weapon loot abundance                                                                                   | `4`                                    |
| `RANGED_WEAPON_LOOT`                 | Ranged weapon loot abundance                                                                            | `4`                                    |
| `AMMO_LOOT`                          | Ammunition loot abundance                                                                               | `4`                                    |
| `MECHANICS_LOOT`                     | Mechanics-related loot abundance                                                                        | `4`                                    |
| `OTHER_LOOT`                         | All other loot abundance                                                                                | `4`                                    |
| `TEMPERATURE`                        | Global temperature setting (1=Very Cold, 2=Cold, 3=Normal, 4=Hot)                                       | `3`                                    |
| `RAIN`                               | Rain frequency (1=Very Dry, 2=Dry, 3=Normal, 4=Rainy)                                                   | `3`                                    |
| `EROSION_SPEED`                      | Speed of world erosion (1=Very Fast, 2=Fast, 3=Normal, 4=Slow)                                          | `3`                                    |
| `EROSION_DAYS`                       | Number of days until 100% erosion growth (0=use erosion speed, -1=no growth)                            | `0`                                    |
| `XP_MULTIPLIER`                      | Base XP gain multiplier                                                                                 | `1.0`                                  |
| `XP_MULTIPLIER_AFFECTS_PASSIVE`      | Whether XP multiplier affects passive skills                                                            | `false`                                |
| `ZOMBIE_ATTRACTION_MULTIPLIER`       | Engine noise attraction multiplier                                                                      | `1.0`                                  |
| `VEHICLE_EASY_USE`                   | Whether cars are unlocked and don't need keys                                                           | `false`                                |
| `FARMING`                            | Plant growth speed (1=Very Fast, 2=Fast, 3=Normal, 4=Slow)                                              | `3`                                    |
| `COMPOST_TIME`                       | Time for food to break down in composter (1=1 Week, 2=2 Weeks, etc.)                                    | `2`                                    |
| `STATS_DECREASE`                     | Speed of hunger/thirst/fatigue decrease (1=Very Fast, 2=Fast, 3=Normal, 4=Slow)                         | `3`                                    |
| `NATURE_ABUNDANCE`                   | Abundance of fish and forage (1=Very Poor, 2=Poor, 3=Normal, 4=Abundant)                                | `3`                                    |
| `ALARM`                              | Frequency of house alarms (1=Never, 2=Extremely Rare, 3=Rare, 4=Sometimes, 5=Often)                     | `4`                                    |
| `LOCKED_HOUSES`                      | Frequency of locked buildings (1=Never to 6=Very Often)                                                 | `6`                                    |
| `STARTER_KIT`                        | Whether players spawn with starter items                                                                | `false`                                |
| `NUTRITION`                          | Whether nutritional value affects player condition                                                      | `true`                                 |
| `FOOD_ROT_SPEED`                     | Speed of food spoilage (1=Very Fast, 2=Fast, 3=Normal, 4=Slow)                                          | `3`                                    |
| `FRIDGE_FACTOR`                      | Fridge effectiveness (1=Very Low, 2=Low, 3=Normal, 4=High)                                              | `3`                                    |
| `LOOT_RESPAWN`                       | Container loot respawn rate (1=None, 2=Every Day, 3=Every Week, 4=Every Month)                          | `1`                                    |
| `SEEN_HOURS_PREVENT_LOOT_RESPAWN`    | Hours after visiting zone before loot can respawn                                                       | `0`                                    |
| `WORLD_ITEM_REMOVAL_LIST`            | List of items to remove after specified hours                                                           | `"Base.Hat,Base.Glasses,Base.Maggots"` |
| `HOURS_FOR_WORLD_ITEM_REMOVAL`       | Hours before dropped items are removed                                                                  | `24.0`                                 |
| `ITEM_REMOVAL_LIST_BLACKLIST_TOGGLE` | Whether to remove items NOT in removal list                                                             | `false`                                |
| `TIME_SINCE_APO`                     | Starting world erosion and spoilage (0-11 representing 0-11)                                            | `1`                                    |
| `PLANT_RESILIENCE`                   | Plant disease resistance (1=Very High, 2=High, 3=Normal, 4=Low)                                         | `3`                                    |
| `PLANT_ABUNDANCE`                    | Plant harvest yield (1=Very Poor, 2=Poor, 3=Normal, 4=Abundant)                                         | `3`                                    |
| `END_REGEN`                          | Recovery speed from tiredness (1=Very Fast, 2=Fast, 3=Normal, 4=Slow)                                   | `3`                                    |
| `HELICOPTER`                         | Helicopter event frequency (1=Never, 2=Once, 3=Sometimes)                                               | `2`                                    |
| `META_EVENT`                         | Distant gunshot events frequency (1=Never, 2=Sometimes)                                                 | `2`                                    |
| `SLEEPING_EVENT`                     | Night-time events during sleep (1=Never, 2=Sometimes)                                                   | `1`                                    |
| `GENERATOR_SPAWNING`                 | Generator spawn chance (1=Extremely Rare, 2=Rare, 3=Sometimes, 4=Often)                                 | `3`                                    |
| `GENERATOR_FUEL_CONSUMPTION`         | Fuel consumption per in-game hour                                                                       | `1.0`                                  |
| `SURVIVOR_HOUSE_CHANCE`              | Randomized safe house discovery chance                                                                  | `3`                                    |
| `VEHICLE_STORY_CHANCE`               | Vehicle story event chance                                                                              | `3`                                    |
| `ZONE_STORY_CHANCE`                  | Zone story event chance                                                                                 | `3`                                    |
| `ANNOTATED_MAP_CHANCE`               | Chance for looted maps to have annotations                                                              | `4`                                    |
| `CHARACTER_FREE_POINTS`              | Free points during character creation                                                                   | `0`                                    |
| `CONSTRUCTION_BONUS_POINTS`          | Extra hit points for player constructions                                                               | `3`                                    |
| `NIGHT_DARKNESS`                     | Ambient lighting at night (1=Pitch Black, 2=Dark, 3=Normal)                                             | `3`                                    |
| `NIGHT_LENGTH`                       | Length of night time                                                                                    | `3`                                    |
| `INJURY_SEVERITY`                    | Impact and healing time of injuries (1=Low, 2=Normal)                                                   | `2`                                    |
| `BONE_FRACTURE`                      | Whether broken limbs are enabled                                                                        | `true`                                 |
| `HOURS_FOR_CORPSE_REMOVAL`           | Hours before zombie bodies disappear                                                                    | `216.0`                                |
| `DECAYING_CORPSE_HEALTH_IMPACT`      | Health impact from nearby decaying bodies                                                               | `3`                                    |
| `BLOOD_LEVEL`                        | Amount of blood spray (1=None, 2=Low, 3=Normal, 4=High)                                                 | `3`                                    |
| `CLOTHING_DEGRADATION`               | Speed of clothing degradation (1=Disabled, 2=Slow, 3=Normal)                                            | `3`                                    |
| `FIRE_SPREAD`                        | Whether fire can spread                                                                                 | `true`                                 |
| `DAYS_FOR_ROTTEN_FOOD_REMOVAL`       | Days before rotten food is removed (-1=never)                                                           | `-1`                                   |
| `ALLOW_EXTERIOR_GENERATOR`           | Whether generators work on exterior tiles                                                               | `true`                                 |
| `MAX_FOG_INTENSITY`                  | Maximum fog intensity (1=Normal, 2=Moderate)                                                            | `1`                                    |
| `MAX_RAIN_FX_INTENSITY`              | Maximum rain effect intensity (1=Normal, 2=Moderate)                                                    | `1`                                    |
| `ENABLE_SNOW_ON_GROUND`              | Whether snow accumulates on ground                                                                      | `true`                                 |
| `ENABLE_TAINTED_WATER_TEXT`          | Whether tainted water shows warning text                                                                | `true`                                 |
| `MULTI_HIT_ZOMBIES`                  | Whether melee weapons can hit multiple zombies                                                          | `false`                                |
| `REAR_VULNERABILITY`                 | Chance of being bitten from behind (1=Low, 2=Medium, 3=High)                                            | `3`                                    |
| `ATTACK_BLOCK_MOVEMENTS`             | Whether attacking blocks movement                                                                       | `true`                                 |
| `ALL_CLOTHES_UNLOCKED`               | Whether all clothing is unlocked                                                                        | `false`                                |
| `CAR_SPAWN_RATE`                     | Vehicle spawn frequency (1=None, 2=Very Low, 3=Low, 4=Normal)                                           | `3`                                    |
| `CHANCE_HAS_GAS`                     | Chance vehicles spawn with gas (1=Low, 2=Normal)                                                        | `1`                                    |
| `INITIAL_GAS`                        | How full gas tanks are in discovered cars                                                               | `2`                                    |
| `FUEL_STATION_GAS`                   | How full fuel station tanks are initially                                                               | `5`                                    |
| `CAR_GAS_CONSUMPTION`                | Vehicle fuel consumption multiplier                                                                     | `1.0`                                  |
| `LOCKED_CAR`                         | Frequency of locked vehicles                                                                            | `3`                                    |
| `CAR_GENERAL_CONDITION`              | General condition of discovered vehicles                                                                | `2`                                    |
| `CAR_DAMAGE_ON_IMPACT`               | Damage dealt to vehicles in crashes                                                                     | `3`                                    |
| `DAMAGE_TO_PLAYER_FROM_HIT_BY_A_CAR` | Player damage from car collisions                                                                       | `1`                                    |
| `TRAFFIC_JAM`                        | Whether traffic jams spawn on roads                                                                     | `true`                                 |
| `CAR_ALARM`                          | Frequency of cars with alarms                                                                           | `2`                                    |
| `PLAYER_DAMAGE_FROM_CRASH`           | Whether players take damage in crashes                                                                  | `true`                                 |
| `SIREN_SHUTOFF_HOURS`                | Hours before sirens shut off                                                                            | `0.0`                                  |
| `RECENTLY_SURVIVOR_VEHICLES`         | Chance of finding maintained vehicles                                                                   | `2`                                    |
| `ENABLE_VEHICLES`                    | Whether vehicles are enabled                                                                            | `true`                                 |
| `ENABLE_POISONING`                   | Whether food poisoning is enabled (1=True, 2=False)                                                     | `1`                                    |
| `MAGGOT_SPAWN`                       | Where maggots spawn (1=In and around bodies, 2=In bodies only)                                          | `1`                                    |
| `LIGHT_BULB_LIFESPAN`                | How long lightbulbs last (0=never break)                                                                | `1.0`                                  |
| `ALLOW_MINI_MAP`                     | Whether mini-map is allowed                                                                             | `false`                                |
| `ALLOW_WORLD_MAP`                    | Whether world map is allowed                                                                            | `true`                                 |
| `MAP_ALL_KNOWN`                      | Whether all map areas are revealed                                                                      | `false`                                |
| `SPEED`                              | Zombie movement speed (1=Sprinters, 2=Fast Shamblers, 3=Shamblers)                                      | `2`                                    |
| `STRENGTH`                           | Zombie attack damage (1=Superhuman, 2=Normal, 3=Weak)                                                   | `2`                                    |
| `TOUGHNESS`                          | Zombie durability (1=Tough, 2=Normal, 3=Fragile)                                                        | `2`                                    |
| `TRANSMISSION`                       | Virus transmission method (1=Blood+Saliva, 2=Saliva Only, 3=Everyone's Infected)                        | `1`                                    |
| `MORTALITY`                          | Infection onset speed (1=Instant, 2=0-30 Seconds, 3=0-1 Minutes, 4=0-12 Hours, 5=2-3 Days, 6=1-2 Weeks) | `5`                                    |
| `REANIMATE`                          | Corpse reanimation speed (1=Instant, 2=0-30 Seconds, 3=0-1 Minutes, 4=0-12 Hours, 5=2-3 Days)           | `3`                                    |
| `COGNITION`                          | Zombie intelligence (1=Navigate+Use Doors, 2=Navigate, 3=Basic Navigation)                              | `3`                                    |
| `CRAWL_UNDER_VEHICLE`                | Zombie crawling ability (1=Crawlers Only, 2=Extremely Rare, 3=Rare, 4=Sometimes, 5=Often, 6=Very Often) | `5`                                    |
| `MEMORY`                             | How long zombies remember players (1=Long, 2=Normal, 3=Short, 4=None)                                   | `2`                                    |
| `SIGHT`                              | Zombie vision range (1=Eagle, 2=Normal, 3=Poor)                                                         | `2`                                    |
| `HEARING`                            | Zombie hearing range (1=Pinpoint, 2=Normal, 3=Poor)                                                     | `2`                                    |
| `THUMP_NO_CHASING`                   | Whether zombies attack doors while roaming                                                              | `false`                                |
| `THUMP_ON_CONSTRUCTION`              | Whether zombies can destroy player constructions                                                        | `true`                                 |
| `ACTIVE_ONLY`                        | When zombies are most active (1=Both, 2=Night)                                                          | `1`                                    |
| `TRIGGER_HOUSE_ALARM`                | Whether zombies can trigger house alarms                                                                | `false`                                |
| `ZOMBIES_DRAG_DOWN`                  | Whether multiple zombies can drag player down                                                           | `true`                                 |
| `ZOMBIES_FENCE_LUNGE`                | Whether zombies lunge after climbing fences                                                             | `true`                                 |
| `DISABLE_FAKE_DEAD`                  | Fake dead zombie behavior (1=Some pretend dead, 2=Some killed+world pretend dead)                       | `1`                                    |
| `POPULATION_MULTIPLIER`              | Overall zombie population multiplier                                                                    | `1.0`                                  |
| `POPULATION_START_MULTIPLIER`        | Starting population multiplier                                                                          | `1.0`                                  |
| `POPULATION_PEAK_MULTIPLIER`         | Peak population multiplier                                                                              | `1.5`                                  |
| `POPULATION_PEAK_DAY`                | Day when population reaches peak                                                                        | `28`                                   |
| `RESPAWN_HOURS`                      | Hours before zombies may respawn in a cell                                                              | `72.0`                                 |
| `RESPAWN_UNSEEN_HOURS`               | Hours chunk must be unseen before zombie respawn                                                        | `16.0`                                 |
| `RESPAWN_MULTIPLIER`                 | Fraction of desired population that respawns                                                            | `0.1`                                  |
| `REDISTRIBUTE_HOURS`                 | Hours before zombies migrate within cell                                                                | `12.0`                                 |
| `FOLLOW_SOUND_DISTANCE`              | Distance zombies will walk toward sounds                                                                | `100`                                  |
| `RALLY_GROUP_SIZE`                   | Size of zombie groups when idle                                                                         | `20`                                   |
| `RALLY_TRAVEL_DISTANCE`              | Distance zombies travel to form groups                                                                  | `20`                                   |
| `RALLY_GROUP_SEPARATION`             | Distance between zombie groups                                                                          | `15`                                   |
| `RALLY_GROUP_RADIUS`                 | How close group members stay to leader                                                                  | `3`                                    |

## Most Common Variables to Change

Here are the variables you'll most likely want to customize:

- **`ZOMBIES`**: Population multiplier (3=High is default, 4=Normal, 5=Low for easier gameplay)
- **`DAY_LENGTH`**: How long each in-game day lasts
- **`XP_MULTIPLIER`**: Speed up or slow down skill progression
- **`FOOD_LOOT`**, **`WEAPON_LOOT`**: Adjust loot abundance for different difficulty
- **`SPEED`**, **`STRENGTH`**, **`TOUGHNESS`**: Core zombie difficulty settings
- **`CAR_SPAWN_RATE`**: Vehicle availability
- **`STARTER_KIT`**: Give new players basic equipment

## Quick Reference

### Numeric Options

Most settings use numbered options (1-6 typically) representing different intensities:

- **1** = Usually the most extreme (None/Instant/Very Fast/etc.)
- **Middle numbers** = Balanced options
- **Highest number** = Most abundant/slowest/etc.

### Boolean Values

Use `true`/`false` for enable/disable settings

### Multiplier Values

Decimal values like `1.0` = normal, `2.0` = double, `0.5` = half

### Time Values

- Hours: Decimal values (e.g. `72.0`)
- Days: Integer values (e.g. `28`)
- Some settings use special time ranges (see individual descriptions)

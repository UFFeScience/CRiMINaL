# CRiMINaL
>Crime patteRn MachINe Learning: a framework to uncover crimes patterns using logic-based relational machine learning techniques.

## Overview
This repository presents the CRiMINaL a framework to uncover crimes patterns using logic-based relational machine learning techniques. CRiMINaL addresses the city public security problem by collecting crime data from existing crowd-sourcing systems and automatically induce patterns with relational machine learning. Experimental results conducted with real data evidentiate CRiMINaL as a suitable and promising tool to assist police departments on crime prevention.

## Repository Structure
* ```CRiMINaL/```
    * ```code/```
    *  ```data/```
        * ```raw_data/```
        * ```model_data/```
    * README.md

## Quick Start Guide


### Prerequisits
* [R Programming Language](https://www.r-project.org/)

* [Java Programming Language](https://docs.oracle.com/javase/)

* [Aleph ILP system](https://www.cs.ox.ac.uk/activities/machlearn/Aleph/aleph.html)

* [YAP Prolog](https://www.dcc.fc.up.pt/~vsc/Yap/)

### Pipeline Execution
The following pipeline is a real case-of-study addressed in the city of Niterói, RJ, Brazil.

All data retrieved and processed during the execution of the pipeline can be found in ```/data/raw_data/```.

* Data Retrieval

```A1_ext.R``` retrieves the crowd-source information from [Onde Fui Roubado](http://www.ondefuiroubado.com.br/) website.
```
input: none
output: ondefuiroubado_occurrences n-m. TimeStamp k.csv
```

```A2_ext``` retrieves relevant public locations (e.g. banks, stores, attractions, hospitals etc) from [Open Street Maps](https://www.openstreetmap.org/).
```
input: none
output: geo_places.csv
```

* Data Cleaning and Discretizations
	
```B_cln.R``` filters the Niterói occurrences from the other.
```
input: ondefuiroubado_occurrences n-m. TimeStamp k.csv
output: Niteroi_occurrences.csv
```
    
```C_cln.R``` convert the georeferences (latitude and longitude) to its official neighborhood.
```
input: Niteroi_occurrences.csv
output: Niteroi_occurrences_suburb.csv
```
    
```D1_cln.R``` and ```D2_cln.R``` merge the ocurrences with the nearby relevant public locations.
```
D1_cln:
input: Niteroi_occurrences.csv ; geo_places.csv
output: nearby_location.csv

D2_cln:
input: nearby_location.csv
output: nearby_locations_plus_neighbourhoods.csv
```

```E_cln.R``` convert the continuous date and time into a discrete date and time.
```
input: nearby_location.csv
output: time_discretize_nit.csv
```

```F_nrm.R``` build clauses from data.
```
input: time_discretize_suburb_updated.csv
output: siac.f ; siac.b ; siac.n
```

* Learning the Model

```
yap -f G_lrn.pl > model.txt
```
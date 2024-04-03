![waffle_banner](https://github.com/asjadnaqvi/stata-waffle/assets/38498046/9aaba239-7774-4005-99d2-9f87b65235bc)

![StataMin](https://img.shields.io/badge/stata-2015-blue) ![issues](https://img.shields.io/github/issues/asjadnaqvi/stata-waffle) ![license](https://img.shields.io/github/license/asjadnaqvi/stata-waffle) ![Stars](https://img.shields.io/github/stars/asjadnaqvi/stata-waffle) ![version](https://img.shields.io/github/v/release/asjadnaqvi/stata-waffle) ![release](https://img.shields.io/github/release-date/asjadnaqvi/stata-waffle)

---

[Installation](#Installation) | [Syntax](#Syntax) | [Examples](#Examples) | [Feedback](#Feedback) | [Change log](#Change-log)

---

# waffle v1.1
(04 Apr 2024)

This package provides the ability to draw waffles Stata. It is based on the [Waffle plots](https://medium.com/the-stata-guide/stata-graphs-waffle-plots-613808b51f73) guide on Medium.

The package is still beta and is being constantly improved. It might still be missing checks and features. 


## Installation

The package can be installed via SSC or GitHub. The GitHub version, *might* be more recent due to bug fixes, feature updates etc, and *may* contain syntax improvements and changes in *default* values. See version numbers below. Eventually the GitHub version is published on SSC.

The SSC version (**v1.0**):
```
ssc install waffle, replace
```

Or it can be installed from GitHub (**v1.1**):

```
net install waffle, from("https://raw.githubusercontent.com/asjadnaqvi/stata-waffle/main/installation/") replace
```


The `palettes` package is required to run this command:

```
ssc install palettes, replace
ssc install colrspace, replace
```

Even if you have the package installed, make sure that it is updated `ado update, update`.

If you want to make a clean figure, then it is advisable to load a clean scheme. These are several available and I personally use the following:

```
ssc install schemepack, replace
set scheme white_tableau  
```

You can also push the scheme directly into the graph using the `scheme(schemename)` option. See the help file for details or the example below.

I also prefer narrow fonts in figures with long labels. You can change this as follows:

```
graph set window fontface "Arial Narrow"
```


## Syntax

The syntax for the latest version is as follows:

```stata
waffle numvar(s) [if] [in], 
                [ by(variable) over(variable) normvar(variable) percent showpct format(fmt) palette(name)
                  rowdots(num) coldots(num) aspect(num) msymbol(list) msize(list) mlwidth(list)
                  ndsymbol(str) ndsize(str) ndcolor(str) cols(num) margin(str) legcolumns(num) legposition(pos) legsize(str)
                  note(str) subtitle(str) *                                  
                ]
```

See the help file `help waffle` for details.

The basic use for wide form is:

```
waffle variables
```

and for long form is:

```
waffle variable, by()
```

where `variable(s)` are a set of numeric variables.

## Examples

Set up the data in wide form:

```stata
clear
sysuse pop2000, clear

// generate a categorical variable

gen agecat = .
replace agecat = 1 if agegrp <= 3
replace agecat = 2 if inrange(agegrp, 4, 13)
replace agecat = 3 if agegrp >=14 

tab agegrp agecat 
lab de agecat 1 "<15" 2 "15-64" 3 "> 65+"
lab val agecat agecat
```

Let's test the basic command:


```
waffle white black asian indian
```

<img src="/figures/waffle1.png" width="100%">

Add additional catgories:

```
waffle white black asian indian, over(agecat) note("")
```

<img src="/figures/waffle2.png" width="100%">

```
waffle white black asian indian, over(agecat) note("") showpct
```

<img src="/figures/waffle2_1.png" width="100%">


Above the higher category determines the relatively heights. But we can also adjust it by a normalizaing variable `normvar()` which in this case is the total population variable:

```
waffle white black asian indian, over(agecat) normvar(total) note("")
```

<img src="/figures/waffle3.png" width="100%">

```
waffle white black asian indian, over(agecat) normvar(total) note("") showpct
```

<img src="/figures/waffle3_1.png" width="100%">


We can also normalize each block local percentages of each category:

```
waffle white black asian indian, over(agecat) percent note("")
```

<img src="/figures/waffle4.png" width="100%">

And change the color palettes:

```
waffle white black asian indian, over(agecat) normvar(total) palette(okabe) note("")
```

<img src="/figures/waffle5.png" width="100%">

```
waffle white black asian indian, over(agecat) normvar(total) palette(okabe) ///
note("Graphs by race") xsize(2) ysize(1)
```

<img src="/figures/waffle6.png" width="100%">

### Marker symbols

We can also fully customize the marker symbols and marker sizes:

```
waffle white black asian indian, over(agecat) normvar(total) ///
palette(okabe) msym(triangle circle square) msize(1.5 1.6) ///
note("") xsize(2) ysize(1)
```

<img src="/figures/waffle7.png" width="100%">

This also works well if there is a single color, e.g. for black and white graphs:


```
waffle white black asian indian, over(agecat) normvar(total) ///
palette(black) msym(Oh triangle +) msize(1.8 1.5 2.4) ///
note("") xsize(3) ysize(1)
```

<img src="/figures/waffle8.png" width="100%">


```
waffle white black asian indian, over(agecat) normvar(total) ///
palette(black) msym(Oh triangle +) msize(1.8 1.5 2.4) ///
note("") xsize(3) ysize(1)
```

<img src="/figures/waffle8_1.png" width="100%">


```
waffle white black asian indian, over(agecat) normvar(total) ///
palette(black) msym(Oh triangle +) msize(1.8 1.5 2.4) mlwid(0.5 0.2 0.5) ///
note("") xsize(3) ysize(1)	///
legsize(3) subtitle(, size(4) pos(6) nobox) ndsym(circle) ndcolor(red) ndsize(0.1)
```

<img src="/figures/waffle8_2.png" width="100%">


### Customize dots rows and columns


```
waffle white black asian indian, over(agecat) normvar(total) palette(okabe) rowdots(10) note("") 
```

<img src="/figures/waffle9.png" width="100%">


```
waffle white black asian indian, over(agecat) normvar(total) palette(okabe) rowdots(10) msize(2.2) note("")
```

<img src="/figures/waffle10.png" width="100%">

```
waffle white black asian indian, over(agecat) normvar(total) palette(okabe) rowdots(5) msize(3) note("") 
```

<img src="/figures/waffle11.png" width="100%">


### Placements

```
waffle white black asian indian, over(agecat) normvar(total) palette(okabe) rowdots(5) msize(3) ///
note("") margin(large) 
```

<img src="/figures/waffle12.png" width="100%">

```
waffle white black asian indian, over(agecat) normvar(total) palette(okabe) rowdots(10) msize(1.1) ///
note("") cols(2) xsize(1) ysize(1)
```

<img src="/figures/waffle13.png" width="100%">

```
waffle white black asian indian, over(agecat) normvar(total) palette(okabe) rowdots(10) msize(1.1) ///
note("") cols(2) xsize(1) ysize(1)
```

<img src="/figures/waffle14.png" width="100%">


### Long form


Convert the data to long form:

```stata
sysuse pop2000, clear

keep white black asian indian island agegrp total
gen id = _n

ren white y_white
ren black y_black
ren asian y_asian
ren indian y_indian
ren island y_island

reshape long y_ , i(id agegrp total) j(byvar) string

sort byvar agegrp 



gen agecat = .
replace agecat = 1 if agegrp <= 3
replace agecat = 2 if inrange(agegrp, 4, 13)
replace agecat = 3 if agegrp >=14 

tab agegrp agecat 
lab de agecat 1 "<15" 2 "15-64" 3 "> 65+"
lab val agecat agecat


gen groups = .
replace groups = 1 if byvar=="indian"
replace groups = 2 if byvar=="asian"
replace groups = 3 if byvar=="black"
replace groups = 4 if byvar=="white"
replace groups = 5 if byvar=="island"


lab de groups 1 "Indian" 2 "Asian" 3 "Blacks" 4 "White" 5 "Island", replace
lab val groups groups

drop if groups==5
```

and run the command with long options:

```
waffle y_ , by(groups) over(agecat) normvar(total)  note("") showpct
```

<img src="/figures/waffle15.png" width="100%">

## Feedback

Please open an [issue](https://github.com/asjadnaqvi/stata-waffle/issues) to report errors, feature enhancements, and/or other requests. 


## Change log

**v1.1 (04 Apr 2024)**
- Rerelease with reworked code. This version is still beta.
- Allows long and wide data forms.
- More flexibility with colors, markers, sizes, placements.


**v1.0 (01 Mar 2022)**
- First release






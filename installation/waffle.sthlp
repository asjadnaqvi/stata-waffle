{smcl}
{* 05Apr2024}{...}
{hi:help waffle}{...}
{right:{browse "https://github.com/asjadnaqvi/stata-waffle":waffle v1.1 (GitHub)}}

{hline}

{title:streamplot}: A Stata package for waffle plots. 

{p 4 4 2}
The command is based on the following guide on Medium: {browse "https://medium.com/the-stata-guide/stata-graphs-waffle-charts-32afc7d6f6dd":Waffle plots}.


{marker syntax}{title:Syntax}
{p 8 15 2}

XXXXXX

{p 4 4 2}
The options are described as follows:



{title:Dependencies}

The {browse "http://repec.sowi.unibe.ch/stata/palettes/index.html":palette} package (Jann 2018, 2022) is required for {cmd:waffle}:

{stata ssc install palettes, replace}
{stata ssc install colrspace, replace}

Even if you have these installed, it is highly recommended to check for updates: {stata ado update, update}

{title:Examples}

See {browse "https://github.com/asjadnaqvi/stata-streamplot":GitHub}.

{hline}


{title:Package details}

Version      : {bf:waffle} v1.1
This release : XX Apr 2024
First release: XXX
Repository   : {browse "https://github.com/asjadnaqvi/stata-waffle":GitHub}
Keywords     : Stata, graph, waffle
License      : {browse "https://opensource.org/licenses/MIT":MIT}

Authors      : {browse "https://github.com/asjadnaqvi":Asjad Naqvi} & {browse "jaredcolston.com":Jared Colston}
E-mail       : asjadnaqvi@gmail.com, colston@wisc.edu
Twitter      : {browse "https://twitter.com/AsjadNaqvi":@AsjadNaqvi}


{title:References}

{p 4 8 2}Jann, B. (2018). {browse "https://www.stata-journal.com/article.html?article=gr0075":Color palettes for Stata graphics}. The Stata Journal 18(4): 765-785.

{p 4 8 2}Jann, B. (2022). {browse "https://ideas.repec.org/p/bss/wpaper/43.html":Color palettes for Stata graphics: An update}. University of Bern Social Sciences Working Papers No. 43. 


{title:Other visualization packages}

{psee}
    {helpb arcplot}, {helpb alluvial}, {helpb bimap}, {helpb bumparea}, {helpb bumpline}, {helpb circlebar}, {helpb circlepack}, {helpb clipgeo}, {helpb delaunay}, {helpb joyplot}, 
	{helpb marimekko}, {helpb sankey}, {helpb schemepack}, {helpb spider}, {helpb streamplot}, {helpb sunburst}, {helpb treecluster}, {helpb treemap}

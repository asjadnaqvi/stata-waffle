{smcl}
{* 04Apr2024}{...}
{hi:help waffle}{...}
{right:{browse "https://github.com/asjadnaqvi/stata-waffle":waffle v1.1 (GitHub)}}

{hline}

{title:waffle}: A Stata package for waffle plots. 

{p 4 4 2}
The command is based on the {browse "https://medium.com/the-stata-guide/stata-graphs-waffle-charts-32afc7d6f6dd":Waffle plots} guide on Medium.


{marker syntax}{title:Syntax}
{p 8 15 2}

{cmd:waffle} {it:numvar(s)} {ifin}, 
                {cmd:[} {cmd:by}({it:variable}) {cmd:over}({it:variable}) {cmd:normvar}({it:variable}) {cmd:percent} {cmd:showpct} {cmd:format}({it:fmt}) {cmd:palette}({it:name})
                  {cmdab:rowd:ots}({it:num}) {cmdab:cold:ots}({it:num}) {cmd:aspect}({it:num}) {cmdab:msym:bol}({it:list}) {cmdab:ms:ize}({it:list}) {cmdab:mlwid:th}({it:list})
                  {cmdab:ndsym:bol}({it:str}) {cmdab:nds:ize}({it:str}) {cmdab:ndc:olor}({it:str}) {cmd:cols}({it:num}) {cmd:margin}({it:str}) {cmdab:legcol:umns}({it:num}) {cmdab:legpos:ition}({it:pos}) {cmdab:legs:ize}({it:str})
                  {cmd:note}({it:str}) {cmd:subtitle}({it:str}) *                                  
                {cmd:]}

{p 4 4 2}
The options are described as follows:

{it:Option 1: Wide form}
{p2coldent : {opt waffle numvars}}Use this option if the data is in wide form and each category is stored in a separate variable. Here one can specify
a list of variables. Drawing is currently in alphabetical order.{p_end}

{it:Option 2: Long form}
{p2coldent : {opt waffle numvar, by(var)}}Use this option if the data is in long form and a single {it:numvar} can be split using the {opt by()} variable.{p_end}


{p2coldent : {opt over(var)}}Further splits the waffle into {opt over()} groups where each is assigned a different color.{p_end}

{p2coldent : {opt normvar(var)}}Normalize the heights based on the {opt normvar()} variable. Otherwise the category with the highest value will
be shown as fully covering all the dots in the waffle. The gaps to the full height as shown as no data (nd) symbols. See options below.{p_end}

{p2coldent : {opt percent}}This will normalize each category to 100% split into own {opt over()} categories.{p_end}

{p2coldent : {opt showpct}}Show percentage share instead of actual totals in the waffle plot.{p_end}

{p2coldent : {opt format(fmt)}}Format the values displayed. Defaults are {opt format(%15.0fc)} and {opt format(%6.2f)} if the {opt showpct} option is specified.{p_end}

{p2coldent : {opt palette(name)}}Color name is any named scheme defined in the {stata help colorpalette:colorpalette} package. Default is {stata colorpalette tableau:{it:tableau}}.
The {opt over()} option shows colors.{p_end}

{p2coldent : {opt rowd:ots(num)}, {opt cold:ots(num)}}These options can be used to control the number of dots in the waffle. Defaults are {opt rowdots(20)} and {opt coldots(20)}.
Changing these will automatically trigger a change in the aspect ratio to ensure that dot spacing is even. If not, then overwrite the {opt aspect()} option.{p_end}

{p2coldent : {opt aspect(num)}}Aspect ratio of the waffle plots. Default is {opt coldots()}/{opt rowdots()}.{p_end}

{p2coldent : {opt msym:bol(list)}}Provide a list of acceptable marker symbols for each {opt over()} category. If the length of symbols is less than the {opt over()} layers,
then the last specified symbol is used for the remaining layers. Default is {opt msymb(square)}, which is an obvious choice for a waffle plot.{p_end}

{p2coldent : {opt ms:ize(list)}}Provide a list of marker sizes for each {opt over()} category. Default is {opt msize(0.85)}.{p_end}

{p2coldent : {opt mlwid:th(list)}}Provide a list of marker line widths for each {opt over()} category. Useful if hollow symbols are used, which look very
slim compared to filled symbols. Default is {opt mlwid(0.05)}.{p_end}

{p2coldent : {opt ndsym:bol(str)}}Symbol of filler no data category. Default is {opt ndsymb(square)}.{p_end}

{p2coldent : {opt nds:ize(str)}}Size of the no data category. Default is {opt ndsize(0.5)}.{p_end}

{p2coldent : {opt ndc:olor(str)}}Color of the no data category. Default is {opt ndc(gs14)} if a the {normvar()} option is used, otherwise, it is turned off.{p_end}

{p2coldent : {opt cols(num)}}Number of waffle columns. Default is {opt cols(4)}.{p_end}

{p2coldent : {opt margin(str)}}Margin of the waffle columns. Here one needs to specify valid margin options.{p_end}

{p2coldent : {opt legcol:umns(num)}}Number of legend columns. Default is {opt legcol(4)}.{p_end}

{p2coldent : {opt legpos:ition(str)}}The position of the legend. Default is {opt legpos(6)}.{p_end}

{p2coldent : {opt legs:ize(str)}}The size of the legend labels. Default is {opt legs(2.2)}.{p_end}

{p2coldent : {opt note(str)}}Can be used for displaying more information about the {opt by()} variables. To turn it off use {opt note("")}.{p_end}

{p2coldent : {opt subtitle(str)}}Can be used customizing the labels of the waffle. Default is {opt subtitle( , pos(6) size(2.5) nobox)}.{p_end}

{p2coldent : {opt *}}All other twoway options not elsewhere specified.{p_end}

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
This release : 04 Apr 2024
First release: 01 Mar 2022
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

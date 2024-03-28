*! waffle v1.1 (Apr 2024)
*! Asjad Naqvi and Jared Colston

*v1.1 (XX Apr 2024): Re-release
*v1.0 (XX XXX 2022): First release by Jared Colston


/* ToDos
	* Sometimes the wrong graphs are drawn. might be due to an unstable sort.
	* nolegend not working properly.
*/



capture program drop waffle 

program waffle, sortpreserve
version 15

syntax varlist(numeric min=1) [if] [in], ///
	[	///
		by(passthru) over(varname) normvar(varname numeric) percent palette(string)  ///
		ROWDots(real 20) COLDots(real 20) MSYMbol(string) MLWIDth(string) MSize(string)	 ///
		NDSYMbol(string)  NDSize(string) NDColor(string)	///   // No Data = ND
		cols(real 4) LEGPOSition(real 6) LEGCOLumns(real 4) LEGSize(real 2.2) NOLEGend margin(string) ///
		aspect(numlist max=1 >0) xsize(passthru) ysize(passthru) 	///
		title(passthru) subtitle(passthru) note(passthru) scheme(passthru) name(passthru) legend(passthru) saving(passthru) name(passthru)		/// 						// keep default options here
	]

	
	// check dependencies
	cap findfile colorpalette.ado
	if _rc != 0 {
		display as error "The palettes package is missing. Install the {stata ssc install palettes, replace:palettes} and {stata ssc install colrspace, replace:colrspace} packages."
		exit
	}	
	
	marksample touse, strok
	
preserve																			
quietly {
	
	keep if `touse'
	tokenize `varlist'		
	
	
	// preamble
	
	if "`over'" == ""	{
		gen _over = 1 
		local over _over
		local ovswitch  = 1
	}
	
	keep `varlist' `normvar' `over'
	
	foreach x of local varlist {
		local `x'_lab : var label `x'
	}
	
	
	
	collapse (sum) `varlist' `normvar', by(`over')


	
	
	
	// flatten to long
	foreach x of local varlist  {
		ren `x' y_`x'
	}	
	

	gen _i = _n
	

	reshape long y_, i(_i `over') j(_cats) string
	
	foreach x of  local varlist {
		*label variable  `x' "``x'_lab'"
		replace _cats = "``x'_lab'" if _cats=="`x'"
	}		
	
	
	
	
	sort _cats `over'
	ren y_ _val
		
	egen _grp = group(_cats)
	
	
	local max = 0
	
	if "`normvar'" == "" {
		levelsof _grp, local(lvls)
		
		foreach x of local lvls {
			summ _val if _grp==`x', meanonly
			if r(sum) > `max' local max = r(sum)
		}
	}
	else {
		summ `normvar' if _grp==1, meanonly
		local max = r(sum)		
	
		drop `normvar'
	}
	
		
	gen double _share = .


	if "`percent'" == "" {
		replace _share = _val / `max' // if _grp==`x'  & `over'==`y'
	}
	else {
		levelsof _grp, local(lvls)
		foreach x of local lvls {
			summ _val if _grp==`x', meanonly
			replace _share = _val / r(sum) if _grp==`x' 
		}
		
	}
	
	

	egen _tag = tag(_grp)
		
	local obsv = `rowdots' * `coldots'  // calculate the total number of rows per group

	
	expand `obsv' if _tag==1, gen(_control)	
	
	
	sort _grp _cats 
	
	
	bysort _grp:	egen _y = seq(), b(`rowdots')  
	bysort _grp:	egen _x = seq(), t(`rowdots') 	

	by _grp: gen _id = _n				

	drop if _id > `obsv'
	drop _tag
	
	gen _dot = 0 
	
	
	
	levelsof _grp, local(lvls)
	levelsof `over', local(ovrs)
	
	local items = r(r)
	
	
	foreach x of local lvls {
		
		local start = 1
		local counter = 1
		
		foreach y of local ovrs {
			summ _share if _grp==`x' & `over'==`y' , meanonly
			local share = r(mean)
			
			
			summ _id  if _grp==`x', meanonly
			local gap = int(`share' * `r(max)')
			
			local end = `start' + `gap'
			
			qui replace _dot = `counter' if _grp==`x' & inrange(_id, `start', `end') 
			
			local start = `end' + 1
			local ++counter
		}
		
		
	}		
	
	
	
	
	egen _tag2 = tag(_grp `over')
	gen _label = ""
	
	levelsof _grp, local(lvls)
	foreach x of local lvls {
	
		summ _val if _grp==`x' & _tag2==1, meanonly
		
		replace _label = _cats + " (" + string(r(sum), "%15.0fc") + ")"	if _grp==`x'
	}

	
	
	
	if "`msize'"   == "" 	local msize    0.8	
	if "`msymbol'" == "" 	local msymbol square	
	if "`mlwidth'" == "" 	local mlwidth    0.05	
	
	if "`ndsymbol'"	== "" 	local ndsymbol square		
	if "`ndsize'"   == "" 	local ndsize 	0.5
	
	if "`ndcolor'" 	== "" 	{
		if "`normvar'" == "" {
			local ndcolor none
		}
		else {
			local ndcolor gs14
		}
	}
	
	
	if "`palette'" == "" {
		local palette tableau
	}
	else {
		tokenize "`palette'", p(",")
		local palette  `1'
		local poptions `3'
	}
	
	
	// dots
	
	local mlen : word count `msymbol' 
	local slen : word count `msize'
	local wlen : word count `mlwidth'
	

	levelsof _dot if _dot > 0, local(lvls)
	foreach x of local lvls {
		
		local b = min(`x', `mlen')
		local a : word `b' of `msymbol'
		
		local c = min(`x', `slen')
		local f : word `c' of `msize'
		
		local k = min(`x', `wlen')
		local p : word `k' of `mlwidth'		
		
		colorpalette `palette', nograph	n(`items') `poptions'
		local dots `dots' (scatter _y _x if _dot==`x',  msymbol(`a') msize(`f') mcolor("`r(p`x')'") mlwidth(`p') ) ///
	
		
		// legend
			local varn : label `over' `x'
			local entries `" `entries' `x'  "`varn'"  "'
			local mylegend legend(order("`entries'") pos(`legposition') size(`legsize') col(`legcolumns')) 
		 
		
	}
	
	
	
	
	if "`nolegend'" != ""  {
		local legswitch legend(off)
		local mylegend legend(off)		
	}	
	
	if "`ovswitch'" == "1"  {
		local legswitch legend(off)
		local mylegend legend(off)
	}
	
	*if "`note'" == "" local note note(" ")
	
	if "`aspect'" == "" local aspect = `coldots' / `rowdots' // a good approximation
	
	if "`subtitle'" == "" local subtitle subtitle( , pos(6) size(2.5) nobox)
	
	*if "`margin'" == "" local margin medium
	
	
	// draw the graph
	
	twoway ///
		`dots' ///
		(scatter _y _x if _dot==0, msize(`ndsize') msymbol(`ndsymbol') mcolor(`ndcolor')) ///
			, ///
			ytitle("") yscale(noline) ylabel(, nogrid) ///
			xtitle("") xscale(noline) xlabel(, nogrid) ///
			by(, noiyaxes noixaxes noiytick noixtick noiylabel noixlabel) ///
			by(_label, `title' `note' rows(`rows') cols(`cols') imargin(`margin') `legswitch' ) ///
			`subtitle' ///
			`mylegend'	///
				aspect(`aspect') `xsize' `ysize'	///
				`saving' `name' `scheme'
						
	
	
	*/
	}
restore
end





**** END OF PROGRAM *****


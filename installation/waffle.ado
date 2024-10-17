*! waffle v1.22 (18 Oct 2024)
*! Asjad Naqvi and Jared Colston

* v1.23 (18 Oct 2024): Added `noval' to remove the totals. Added `wrap()` for label wrapping.
* v1.22 (27 Aug 2024): fixed label issues for graphs with just one item. Fixed a bug where wrong totals were calculated under certain conditions.
* v1.21 (27 Jun 2024): by _cats bug. Post graph now shows dotval as an output. return locals fixed.
* v1.2  (26 May 2024): Fix long graph normalization bug. better treatment of null shares. r(dot) added.
* v1.11 (05 May 2024): Bug fixes to how data was collapsed under different conditions. normvar now needs to be already the sum value.
* v1.1  (04 Apr 2024): Re-release. Allows wide and long form data.
* v1.0  (01 Mar 2022): First release by Jared Colston

* Code is based on the Waffle guide on Medium: https://medium.com/the-stata-guide/stata-graphs-waffle-charts-32afc7d6f6dd



capture program drop waffle 

program waffle, rclass sortpreserve 
version 15

syntax varlist(numeric min=1) [if] [in], ///
	[	///
		by(varname) over(varname) normvar(varname numeric) percent showpct format(string) palette(string)  ///
		ROWDots(real 20) COLDots(real 20) MSYMbol(string) MLWIDth(string) MSize(string)	 ///
		NDSYMbol(string)  NDSize(string) NDColor(string)	///   // No Data = ND
		COLs(real 4) LEGPOSition(string) LEGCOLumns(real 4) LEGSize(string) NOLEGend margin(string) ///
		aspect(numlist max=1 >0) note(passthru) title(passthru) subtitle(passthru)   * 	  ///
		NOVALues wrap(numlist >=0 max=1)  ]   // v1.23 options

	
	// check dependencies
	cap findfile colorpalette.ado
	if _rc != 0 {
		display as error "The palettes package is missing. Install the {stata ssc install palettes, replace:palettes} and {stata ssc install colrspace, replace:colrspace} packages."
		exit
	}	
	
	
	if "`wrap'" != "" {
		cap findfile labsplit.ado
		if _rc != 0 {
			display as error "The {bf:graphfunctions} package is missing. Install the {stata ssc install graphfunctions, replace:graphfunctions}."
			exit
		}			
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
	

	keep `varlist' `normvar' `over' `by'

	local length : word count `varlist'
	
	if `length' > 1 {
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
			replace _cats = "``x'_lab'" if _cats=="`x'"
		}		
		
	}
	if `length' == 1 {	
		
		local byoff = 0
		
		if "`by'" == ""	{
			gen _by = 1 
			local by _by
			local byoff = 1
		}		
		
		cap ren `by' _cats
		
		
		fillin _cats `over'
		recode `varlist' (.=0)
		drop _fillin
		
		if "`normvar'"=="" {
			collapse (sum) `varlist', by(_cats `over')
		}
		else {
			collapse (sum) `varlist' (mean) `normvar', by(_cats `over')
		}

		cap ren `varlist' y_
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
		levelsof _grp, local(lvls)
		
		foreach x of local lvls {
			summ `normvar' if _grp==`x', meanonly
			if r(sum) > `max' local max = r(max)
		}
		
	}


	cap drop `normvar'
	
	gen double _share = .

	if "`percent'" == "" {
		replace _share = _val / `max' 
	}
	else {
		levelsof _grp, local(lvls)
		foreach x of local lvls {
			summ _val if _grp==`x', meanonly
						
			replace _share = _val / r(sum) if _grp==`x' 
		}
	}
	
	

	egen _tag = tag(_grp)
	
	bysort _cats: egen double _share_tot = sum(_share)
	
	
	local obsv = `rowdots' * `coldots'  // calculate the total number of rows per group
	
	
	
	return local maxdots `obsv'
	
	if "`percent'" != "" {
		local dotval = 100 / `obsv'
		return local dot `dotval'
	}
	else {
		local dotval = `max' / `obsv'
		return local dot `dotval'
	}
	
	
	expand `obsv' if _tag==1, gen(_control)	
		
	sort _grp  _cats _control `over'
	
	
	bysort _grp:	egen _y = seq(), b(`rowdots')  
	bysort _grp:	egen _x = seq(), t(`rowdots') 	

	by _grp: gen _id = _n				

	drop if _id > `obsv'
	drop _tag
	
	gen _dot = 0 
	
	egen _tag2 = tag(_grp `over')
	egen _tag3 = group(`over')
	



	
	levelsof _grp , local(lvls)
	levelsof _tag3, local(ovrs)
	
	local items = r(r)
	

	foreach x of local lvls {
		
		local start = 1
		local counter = 1
		
		foreach y of local ovrs {
					
			summ _share if _grp==`x' & _tag3==`y' & _tag2==1, meanonly
			local share = r(mean)
			
			if `r(N)' > 0 & `share' > 0 {
				summ _id  if _grp==`x', meanonly

				local gap = int(`share' * `r(max)')			
				local end = `start' + `gap'
				
				qui replace _dot = `counter' if _grp==`x' & inrange(_id, `start', `end') 
				local start = `end' + 1
				
			}
			local ++counter
		}
	}	
	

	if "`byoff'" != "1" {
		
		cap confirm numeric var _cats
		if !_rc {
			decode _cats, gen(_temp)
		}
		else {
			gen _temp = _cats
		}
	}
	else {
		gen _temp = string(_cats)
	}
	
	
	
	
	if "`format'"  == "" {
		if "`showpct'"  == "" {
			local format %15.0fc
		}
		else {
			local format %6.2f
		}
	}		
	
	
	gen _label = ""

	
	if "`novalues'" == "" {
		if "`showpct'" == "" {
			levelsof _grp, local(lvls)
		
			foreach x of local lvls {
				summ _val if _grp==`x' & _control==0, meanonly
				replace _label = _temp + " (" + string(r(sum), "`format'") + ")"	if _grp==`x' 
			}
		}
		else {
			replace _label = _temp + " (" + string(_share_tot * 100, "`format'") + "%)"	 
		}
	}
	else {
		replace _label = _temp
	}
	
	if "`wrap'" != "" {
		ren _label _label_temp
		labsplit _label_temp, wrap(`wrap') gen(_label)
		drop _label_temp
	}		
		
	
	capture drop _i 
	capture drop _control 
	capture drop _temp
	
	if "`msize'"   		== "" 	local msize		0.90	
	if "`msymbol'" 		== "" 	local msymbol	square	
	if "`mlwidth'" 		== "" 	local mlwidth	0.05	
	if "`ndsymbol'"		== "" 	local ndsymbol	square		
	if "`ndsize'"   	== "" 	local ndsize	0.5
	if "`legposition'"  == "" 	local legposition	6	
	if "`ndcolor'" 		== "" 	local ndcolor gs12

	
	if "`palette'" == "" {
		local palette tableau
	}
	else {
		tokenize "`palette'", p(",")
		local palette  `1'
		local poptions `3'
	}
	
	
	if "`legsize'"   == "" 	local legsize 2.2	
	
	// dots

	levelsof `over', local(ovlvls)
	
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
		
		capture confirm numeric variable `over'
		if !_rc {	
			local varn : label `over' `x'
			local entries `" `entries' `x'  "`varn'"  "'
		}
		else {
			local varn : word `x' of `ovlvls'
			local entries `" `entries' `x'  "`varn'"  "'
		}
			
			local mylegend legend(order("`entries'") position(`legposition') size(`legsize') col(`legcolumns')) 
		 
		
	}
	
	
	if "`ovswitch'" != "1" local myleg2 legend(position(`legposition'))
	

	if "`nolegend'" != ""  {
		local legswitch legend(off)
		local mylegend legend(off)		
		local myleg2 
	}	
	
	if "`ovswitch'" == "1"  {
		local legswitch legend(off)
		local mylegend legend(off)
	}
	
	
	if "`aspect'" == "" local aspect = `coldots' / `rowdots' // a good approximation
	if "`subtitle'" == "" local subtitle subtitle( , pos(6) size(2.5) nobox)
	
	
	// draw the graph
	
	twoway ///
		`dots' ///
		(scatter _y _x if _dot==0, msize(`ndsize') msymbol(`ndsymbol') mcolor(`ndcolor')) ///
			, ///
			ytitle("") yscale(off noline range(1 `coldots')) ylabel(, nogrid) ///
			xtitle("") xscale(off noline range(1 `rowdots')) xlabel(, nogrid) ///
			by(, noiyaxes noixaxes noiytick noixtick noiylabel noixlabel `myleg2'	 ) ///
			by(_label, `title' `note' rows(`rows') cols(`cols') imargin(`margin') `legswitch' ) ///
			`subtitle' ///
			`mylegend'	///
				aspect(`aspect') `options'	
						
	
	noi display in yellow "Each dot has a value of `dotval'. See {stata return list} for stored values."
	
	

	
	
	*/
	}
restore
end




*************************
**** END OF PROGRAM *****
*************************

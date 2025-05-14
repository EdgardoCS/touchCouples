*-------------------------------------------------------------------------------
* Wave 				: W2       
* Subwave			: W2B
* welle				: 5                                          
* Author            : Yvonne Friedrich
* Contributor		: Edgardo Silva
* Analysis  		: FReDA Touch article (2)
*-------------------------------------------------------------------------------
* Content 			: Prepare data: Merge data from all waves
*-------------------------------------------------------------------------------
* Set paths, read data

clear all

global path_data `""C:\Users\silva\Documents\FReDA\Data\FReDA v4-1-0\Data\Stata""'
global path_data_all `""C:\Users\silva\Documents\FReDA\OutputEN""'

*-------------------------------------------------------------------------------
* Prepare for merging
// Beforehand, install renvarlab
// Von der Webseite http://fmwww.bc.edu/repec/bocode/r/ die Dateien renvarlab.ado und renvarlab.hlp herunterladen und in den Ordner 
// "C:\ado\plus\r\" (ggf. vorher anlegen) auf der Festplatte speichern. Und danach Stata (neu) starten. 
*------------------------------------------------------------------------------

cd $path_data
use FREDAanchor5.dta, clear
label language en
sort id
renvarlab, postfix(_w2b)
rename id_w2b id
drop welle
cd $path_data_all
save W2B.dta, replace

cd $path_data
use FREDAanchor4.dta, clear
label language en
sort id
renvarlab, postfix(_w2a)
rename id_w2a id
drop welle
cd $path_data_all
save W2A.dta, replace

cd $path_data
use FREDAanchor1.dta, clear
label language en
sort id
renvarlab, postfix(_w1r)
rename id_w1r id
drop welle
cd $path_data_all
save W1R.dta, replace

cd $path_data
use FREDAanchor2.dta, clear
label language en
sort id
renvarlab, postfix(_w1a)
rename id_w1a id
drop welle
cd $path_data_all
save W1A.dta, replace

cd $path_data
use FREDAanchor3.dta, clear
label language en
sort id
renvarlab, postfix(_w1b)
rename id_w1b id
drop welle
cd $path_data_all
save W1B.dta, replace


cd $path_data
use FREDApartner5.dta, clear
label language en
sort id
renvarlab, postfix(_w2b)
rename id_w2b id
drop welle
sort expartner_w2b
by expartner_w2b: keep if expartner_w2b == 0
cd $path_data_all
save W2B_P.dta, replace

cd $path_data
use FREDApartner4.dta, clear
label language en
sort id
renvarlab, postfix(_w2a)
rename id_w2a id
drop welle
sort expartner_w2a
by expartner_w2a: keep if expartner_w2a == 0
cd $path_data_all
save W2A_P.dta, replace

cd $path_data
use FREDApartner2.dta, clear
label language en
sort id
renvarlab, postfix(_w1r)
rename id_w1r id
drop welle
cd $path_data_all
save W1A_P.dta, replace


**** Merge

cd $path_data_all
use W2B.dta, clear

merge 1:1 id using W1R.dta //, keepusing (***) // to keep only specific variables
recode _merge (3=1)(1=0)(else=.), gen(participant_w1r)
label variable participant_w1r "participant in W1R"
drop _merge

merge 1:1 id using W1A.dta //, keepusing (***)
recode _merge (3=1)(1=0)(else=.), gen(participant_w1a)
label variable participant_w1a "participant in W1A"
drop _merge

merge 1:1 id using W1B.dta //, keepusing (***)
recode _merge (3=1)(1=0)(else=.), gen(participant_w1b)
label variable participant_w1b "participant in W1B"
drop _merge

merge 1:1 id using W2A.dta //, keepusing (pa17i1_w2a pa17i2_w2a pa17i4_w2a pa17i5_w2a pa17i6_w2a pa17i8_w2a)
recode _merge (3=1)(1=0)(else=.), gen(participant_w2a)
label variable participant_w2a "participant in W2A"
drop _merge


// Partner data
merge 1:1 id using W2B_P.dta //, keepusing (***)
recode _merge (3=1)(1=0)(else=.), gen(participant_w2b_p)
label variable participant_w2b_p "participant in W1A"
drop _merge


merge 1:1 id using W1A_P.dta //, keepusing (***)
recode _merge (3=1)(1=0)(else=.), gen(participant_w1a_p)
label variable participant_w1a_p "participant in W1A"
drop _merge

merge 1:1 id using W2A_P.dta //, keepusing (pa17i1_w2a pa17i2_w2a pa17i4_w2a pa17i5_w2a pa17i6_w2a pa17i8_w2a)
recode _merge (3=1)(1=0)(else=.), gen(participant_w2a_p)
label variable participant_w2a_p "participant in W2A"
drop _merge


label define lbl_yesno 1 "yes" 0 "no", replace
label values participant_w1r lbl_yesno
label values participant_w1a lbl_yesno
label values participant_w1b lbl_yesno
label values participant_w2a lbl_yesno

**** Delete cases if not suitable

drop if missing(inty_w2b) // delete if not participated at W2B (year of interview is missing)

**** Save

cd $path_data_all
save W2B_com.dta, replace


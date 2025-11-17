*-------------------------------------------------------------------------------
* Wave 				: W2       
* Subwave			: W2B
* welle				: 5                                          
* Author            : Yvonne Friedrich
* Contributor		: Edgardo Silva
* Analysis  		: FReDA Touch article (2)

*-------------------------------------------------------------------------------
* Content 			: Prepare data: Generate new variables, see descriptives
*                     run script "FReDA_Touch_mergeData.do" first
*					  This will set results for only anchor + current partner
*-------------------------------------------------------------------------------
* Set path, upload data

clear all
global path_data_all `""C:\Users\Edo\Documents\GitHub\touchCouples\Stata\data""'

cd $path_data_all
use W2B_com.dta, clear 


**** Analyse data for relationship status

tab pstat_w2b,  m // 22,494 cases: 17,066 (75.87%) in relationship; 5,412 (24.06%) Singles; n = 16 Missings
*-------------------------------------------------------------------------------
**** Delete cases that do not have any data on touch frequency / are singles
* display missings
tab omo15i1_w2b, m // no response: 313/ wrong: 19/ not applicable: 5,409
tab omo16i1_w2b, m // no response: 334/ wrong: 18/ not applicable: 5,410
tab omo17i1_w2b, m // no response: 372/ wrong: 18/ not applicable: 5,410
tab pomo15i1_w2b, m // no response: 21/ wrong: 3/ not applicable: 40 
tab pomo16i1_w2b, m // no response: 19/ wrong: 3/ not applicable: 40
tab pomo17i1_w2b, m // no response: 15/ wrong: 3/ not applicable: 40

* delete cases
drop if omo15i1_w2b < 1 | omo16i1_w2b < 1 | omo17i1_w2b < 1
drop if omo15i1_w2b == . | omo16i1_w2b == . | omo17i1_w2b == .
drop if pomo15i1_w2b < 1 | pomo16i1_w2b < 1 | pomo17i1_w2b < 1
drop if pomo15i1_w2b == . | pomo16i1_w2b == . | pomo17i1_w2b == .

* -> 7116 participants left

*-------------------------------------------------------------------------------
**** Explore touch data

* Response rates to touch questions (Anchors) 
 // kiss frequency
tab omo15i1_w2b, m 
 // kiss wish
tab omo15i2_w2b, m  
 // hold frequency
tab omo16i1_w2b, m  
 // hold wish
tab omo16i2_w2b, m  
 // hug frequency
tab omo17i1_w2b, m  
 // hug wish
tab omo17i2_w2b, m

* Response rates to touch questions (Partners) 
 // kiss frequency
tab pomo15i1_w2b, m 
 // kiss wish
tab pomo15i2_w2b, m  
 // hold frequency
tab pomo16i1_w2b, m  
 // hold wish
tab pomo16i2_w2b, m  
 // hug frequency
tab pomo17i1_w2b, m  
 // hug wish
tab pomo17i2_w2b, m


*-------------------------------------------------------------------------------
* Generate new variables and show descriptives
*-------------------------------------------------------------------------------


*-------------------------------------------------------------------------------
* A. Sociodemographics 
*-------------------------------------------------------------------------------

**** 1. Age ********************************************************************

// Please check n=588 -> 51y., n = 27 -> 52y., n = 17 -> 53y., n=2 -> 17y., n=1 missing 
* 		-> if age was invalid, age from registry was taken / n = 1
* Anchor data *
gen age = age_w2b
replace age = age_reg_w2b if age < 0 // if typos occured or the year was unvalid, age from the register is taken
mvdecode age, mv(-10/-1) // define remaining missing values 
label variable age "Corrected Age (ANCHOR)"

* Partner data *
gen page = page_w2b
label variable page "Corrected Age (PARTNER)"

sum age

* generate age groups
// Please note: 17y. are not in classes

recode age (18 19 = 1 "18-19") (20/24=2 "20-24") (25/29=3 "25-29") (30/34=4 "30-34") (35/39=5 "35-39") (40/44=6 "40-44") (45/51=7 "45-51") (else=.), gen(age_class)
label variable age_class "Age (classes)"

tab age_class, m // n = 16 missings

drop if age < 18 | age > 51


**** 2. Sex ********************************************************************
*        -> information from register if data was missing (n=1) -> male
* Anchor data *
gen sex = sex_w2b 
replace sex = sex_reg_w2b if sex_w2b < 0 // if subject did not respond, sex from register was taken
label variable sex "Sex (ANCHOR)"
label define sexl 1 "Male" 2 "Female" 3 "Diverse" -2 "No answer", replace
label value sex sexl

* Partner data *
gen psex = psex_w2b
replace psex = psexgen_w2b if psex_w2b == -2 // if subject did not respond, sex from register was taken
label variable psex "Sex (PARTNER)"
label define sexl 1 "Male" 2 "Female" 3 "Diverse" -2 "No answer", replace
label value psex sexl

tab psex, m

**** 3. Education **************************************************************
* Anchor data *
* a. Highest school dregree 
tab school_w2b, m // n = 26 missings

* b. Vocational training/study 
tab voctrain_w2b, m // n = 135 missings

* c. Years of education
tab educy_w2b, m // n = 156 missings

* d. ISCED-11, International Standard Classification of Education
tab isced11_w2b, m // n = 520 missings
gen isced11 = isced11_w2b
mvdecode isced11, mv(-10/-1)

* Partner data *
tab pschool_w2b, m // n = 26 missings

* b. Vocational training/study 
tab pvoctrain_w2b, m // n = 135 missings

* c. Years of education
tab peducy_w2b, m // n = 156 missings

* d. ISCED-11, International Standard Classification of Education
tab pisced11_w2b, m // n = 520 missings
gen pisced11 = pisced11_w2b
mvdecode pisced11, mv(-10/-1)


**** 4. Work & employment ******************************************************
* Anchor data *
* 	a. Work situation (detail)
gen work = lfstat_w2b if lfstat_w2b > 0
label variable work "Labour force status (ANCHOR)"
label define workl 1 "Education/vocational training" 2 "Parental leave" 3 "Homemaker" 4 "Unemployed" 5 "Military service/civic service" 6 "Retired/unfit for work" 7 "Working, full-time employed" 8 "Working, part-time employed" 9 "Working, marginal employed " 10 "Working, self-employed" 11 "Other", replace
label values work workl
tab work, m // n = 9 missings

recode work (1 5 7 10 = 1 "Full time activity") (8 9 = 2 "Part-time activity") (2 3 4 6 = 3 "Home") (else=.), gen(workst)
label variable workst "Work status (ANCHOR)"
tab workst, m // n = 79 missings

* 	b. Working hours
gen workh = job56_w2b if job56_w2b > 0 & job56_w2b <= 168
label variable workh "Working hours per week"
tab workh, m // n = 773 missings

* Partner data *
* 	a. Work situation (detail)
gen pwork = plfstat_w2b if plfstat_w2b > 0
label variable pwork "Labour force status (PARTNER)"
label define pworkl 1 "Education/vocational training" 2 "Parental leave" 3 "Homemaker" 4 "Unemployed" 5 "Military service/civic service" 6 "Retired/unfit for work" 7 "Working, full-time employed" 8 "Working, part-time employed" 9 "Working, marginal employed " 10 "Working, self-employed" 11 "Other", replace
label values pwork pworkl
tab pwork, m // n = 9 missings

recode pwork (1 5 7 10 = 1 "Full time activity") (8 9 = 2 "Part-time activity") (2 3 4 6 = 3 "Home") (else=.), gen(pworkst)
label variable pworkst "Work status (PARTNER)"
tab pworkst, m // n = 79 missings


**** 5. Migration background ***************************************************
//(no update info collected in Wave 2)

gen migback = migback_w1b
mvdecode migback, mv(-10/-1) // define remaining missing values 
recode migback (3 = 0) // define "no migration background" as a reference
label variable migback "Migration background"
label define migbackl 1 "1st gen." 2 "2nd gen." 0 "None", replace
label values migback migbackl
tab migback, m // missings:  1,562 

**** 6. Residential area *******************************************************
* Anchor data *
* 	a. Eastern Germany 
gen east = east_w2b if east_w2b > -1
label variable east "Residency (ANCHOR)"
label define eastl 1 "East Germany" 0 "West Germany"
label value east eastl

tab east, m // n = 16 missings

* 	b. Urbanisation
gen degurba = degurba_w2b if degurba_w2b > 0
label variable degurba "Urbanisation (ANCHOR)"
label define degurbal 1 "City" 2 "Town or suburb" 3 "Rural area"
label value degurba degurbal

tab degurba, m // n = 17 missing

* Partner data *
* 	a. Eastern Germany 
gen peast = peast_w2b if peast_w2b > -1
label variable peast "Residency (PARTNER)"
label define peastl 1 "East Germany" 0 "West Germany"
label value peast peastl

tab peast, m // n = 16 missings

* 	b. Urbanisation
gen pdegurba = pdegurba_w2b if pdegurba_w2b > 0
label variable pdegurba "Urbanisation (PARTNER)"
label define pdegurbal 1 "City" 2 "Town or suburb" 3 "Rural area"
label value pdegurba pdegurbal

tab pdegurba, m // n = 17 missing


*-------------------------------------------------------------------------------
* B. Relationship variables
*-------------------------------------------------------------------------------
* Anchor data *
**** 1. Relationship duration **************************************************
tab reldur_w2b, m // n = 152 missings

gen reldur = reldur_w2b if reldur_w2b > -1
replace reldur = reldur/12 // transform to years
label variable reldur "Relationship duration [years]" 

// hist reldur
sum reldur

recode reldur (0/2.99 = 1 "1") (3/5.99 = 2 "2") (6/10.99 = 3 "3") (11/20.99 = 4 "4") (21/50 = 5 "5") (else =.), gen(reldur_class)
label variable reldur_class "Relationship duration [years]"
tab reldur_class, m

**** 2. Same sex relationship **************************************************		
* a. generate partner sex 
tab psex_w2b, m 
gen sexp = psex_w2b if psex_w2b > 0

* label variable
label variable sexp "Sex, partner"
label define sexpl 		 1 "Male"  2 "Female"  3 "Diverse" , replace
label value sexp sexpl

tab sexp, m // n = 60 missings

* b. generate same sex variable
tab samesex_w2b, m // n = 60 missings

gen samesex = samesex_w2b
replace samesex = 1 if sex==sexp & inlist(sex, 1, 2) & inlist(sexp, 1, 2) & samesex < 0
replace samesex = 0 if sex!=sexp & inlist(sex, 1, 2, 3) & inlist(sexp, 1, 2, 3) & samesex < 0
replace samesex = 0 if sex==sexp & sex==3 & samesex < 0

* label variable
label variable samesex "Relationship type"
label define samesex_de  0 "Different sex"  1 "Same sex" , replace
label value samesex samesex_de
mvdecode samesex, mv(-10/-1) // define missing values

tab samesex, m // n = 60 missings

* see "sex. orientation" (omo18_w2b) vs. actual relationship
tab omo18_w2b samesex, m

**** 3. Age difference between partners ****************************************

* a. generate partner's age 
tab page_w2b, m // n = 6 missings

gen agep = page_w2b

replace agep = floor(((inty_w2b * 12 + intm_w2b) - (sdp1y_w1a * 12 + sdp1m_w1a))/12) if sdp1y_w1a <= inty_w2b & sdp1y_w1a > 1950 & sdp1m_w1a < 13 & sdp1y_w1a > 0 & agep < 0 // calculate age based on W1A info
replace agep = floor(((inty_w2b * 12 + intm_w2b) - (bpa18y_w2a * 12 + bpa18m_w2a))/12) if bpa18y_w2a <= inty_w2b & bpa18y_w2a > 1950 & bpa18m_w2a < 13 & bpa18m_w2a > 0 & agep < 0 // update age if new data at W2A
label variable agep "Age of partner"

* b. generate age difference
gen agediff = .
replace agediff = agep - age  if age > 0 & agep > 0 // plus -> Partner older
label variable agediff "Age difference"

* c. define age diff classes
recode agediff (-1 0 1 = 1 "Same age") (2/5=2 "2-5y. older partner") (6/10=3 "6-10y. older partner") (11/50=4 "> 10y. older partner") (-5/-2=5 "2-5y. younger partner") (-10/-6=6 "6-10y. younger partner") (-50/-11=7 "> 10y. younger partner") (else=.), gen(agediff_class)
label variable agediff_class "Age difference (classes)"

tab agediff_class sex, m // n = 3 missings


**** 4. Cohabitation ***********************************************************

gen cohab = .
replace cohab = sd7e1_w1a if sd7e1_w1a > 0 // cohabitation indicated at W1A if meaningful data (>0)
replace cohab = bpa4_w2a if bpa4_w2a > 0 // update at W2A, old partner if meaningful data (>0)
replace cohab = bpa20_w2a if bpa20_w2a > 0 // update at W2A, new partner if meaningful data (>0)
replace cohab = bpa4_w2b if bpa4_w2b > 0 // update at W2B if meaningful data (>0)
label variable cohab "Living situation"
recode cohab (2 = 0)
label define cohabl 1 "Cohabiting" 0 "Separate households", replace 
label value cohab cohabl

tab cohab, m // n = 0 missings

**** 5. Number of kids *********************************************************
* Anchor data *
tab nkids_w2b, m // n = 7 missings
gen nkids = nkids_w2b
mvdecode nkids, mv(-10/-1) // define missing values
tab nkids, m

tab nkidsliv_w2b, m // n = 6 missings
gen nkidsliv = nkidsliv_w2b
mvdecode nkidsliv, mv(-10/-1) // define missing values
tab nkidsliv, m

* nkids classes 

recode nkids_w2b (0 = 0 "0") (1=1 "1") (2=2 "2") (3/50=3 "3 or more") (else=.), gen(nkids_class_w2b)
label variable nkids_class_w2b "Number of children (classes)"

tab nkids_class_w2b, m

* nkidsliv classes (kids living in the same household)

recode nkidsliv_w2b (0 = 0 "0") (1=1 "1") (2=2 "2") (3/50=3 "3+") (else=.), gen(nkidsliv_class)
label variable nkidsliv_class "Number of all children living with subject (classes)"

tab nkidsliv_class, m

* generate age classes

recode ykage_w2b (0 1 = 1 "1") (2/5=2 "2") (6/13=3 "3") (14/17=4 "4") (18/50=5 "5") (else=.), gen(ykage_class_w2b)
label variable ykage_class_w2b "Age of youngest child (classes)"

tab ykage_class_w2b, m

**** 8. Relationship quality index *********************************************
// a lot of missing due to Aktualisierung Partner bpa1_w2b -> "trifft nicht zu" & relint = 0 ??

* a. recode reverse items
recode pa17i4_w2a (5=1) (4=2) (3=3) (2=4) (1=5), gen(pa17i4_w2a_r)
label variable pa17i4_w2a_r "[recoded] Häufigkeit in Partnerschaft: Ärgerlich oder wütend"
recode pa17i6_w2a (5=1) (4=2) (3=3) (2=4) (1=5), gen(pa17i6_w2a_r)
label variable pa17i6_w2a_r "[recoded] Häufigkeit in Partnerschaft: Unterschiedliche Meinung, Streit"

* b. calculate sum score
egen relint = rowtotal(pa17i1_w2a pa17i2_w2a pa17i4_w2a_r pa17i5_w2a pa17i6_w2a_r pa17i8_w2a) if pa17i1_w2a > 0 & pa17i2_w2a > 0 & pa17i4_w2a_r > 0 & pa17i5_w2a > 0 & pa17i6_w2a_r > 0 & pa17i8_w2a > 0 & (bpa1_w2b == 1 | bpa1_w2b == 4) // only if responses are complete & partner is the same for W2B
recode relint 0 = .
label variable relint "Relationship interaction index (W2A)"

tab relint, m // n = 267 missings

**** 9a. Conflict management ****************************************************
// -> pos. = constructive // see above -> problem with missings

* a. recode reverse items
recode pa22ri12_w2a pa22ri9_w2a pa22ri1_w2a pa22ri11_w2a (5=1) (4=2) (3=3) (2=4) (1=5), gen(pa22ri12_w2a_r pa22ri9_w2a_r pa22ri1_w2a_r pa22ri11_w2a_r)

* calculate sum score
egen confm = rowtotal(pa22ri12_w2a_r pa22ri10_w2a pa22ri8_w2a pa22ri9_w2a_r pa22ri1_w2a_r pa22ri11_w2a_r) if pa22ri12_w2a_r > 0 & pa22ri10_w2a > 0 & pa22ri8_w2a > 0 & pa22ri9_w2a_r > 0 & pa22ri1_w2a_r > 0 & pa22ri11_w2a_r > 0 & (bpa1_w2b == 1 | bpa1_w2b == 4) // only if responses are complete & partner is the same for W2B
recode confm 0 = .
label variable confm "Conflict management index (W2A)"

tab confm, m // n = 274 missings

* Partner data *
* a. recode reverse items
recode ppa17i4_w2a (5=1) (4=2) (3=3) (2=4) (1=5), gen(ppa17i4_w2a_r)
label variable ppa17i4_w2a_r "[recoded] Frequency in partnership: Annoyed or angry"
recode ppa17i6_w2a (5=1) (4=2) (3=3) (2=4) (1=5), gen(ppa17i6_w2a_r)
label variable ppa17i6_w2a_r "[recoded] Frequency in partnership: Differences of opinion, arguments"

* b. calculate sum score
egen prelint = rowtotal(ppa17i1_w2a ppa17i2_w2a ppa17i4_w2a_r ppa17i5_w2a ppa17i6_w2a_r ppa17i8_w2a) if ppa17i1_w2a > 0 & ppa17i2_w2a > 0 & ppa17i4_w2a_r > 0 & ppa17i5_w2a > 0 & ppa17i6_w2a_r > 0 & ppa17i8_w2a > 0 & (pbpa1_w2b == 1 | pbpa1_w2b == 4) // only if responses are complete & partner is the same for W2B
recode prelint 0 = .
label variable prelint "Relationship interaction index (W2A)"

tab prelint, m // n = 267 missings

**** 9a. Conflict management ****************************************************
// -> pos. = constructive // see above -> problem with missings

* a. recode reverse items
recode ppa22ri12_w2a ppa22ri9_w2a ppa22ri1_w2a ppa22ri11_w2a (5=1) (4=2) (3=3) (2=4) (1=5), gen(ppa22ri12_w2a_r ppa22ri9_w2a_r ppa22ri1_w2a_r ppa22ri11_w2a_r)

* calculate sum score
egen pconfm = rowtotal(ppa22ri12_w2a_r ppa22ri10_w2a ppa22ri8_w2a ppa22ri9_w2a_r ppa22ri1_w2a_r ppa22ri11_w2a_r) if ppa22ri12_w2a_r > 0 & ppa22ri10_w2a > 0 & ppa22ri8_w2a > 0 & ppa22ri9_w2a_r > 0 & ppa22ri1_w2a_r > 0 & ppa22ri11_w2a_r > 0 & (pbpa1_w2b == 1 | pbpa1_w2b == 4) // only if responses are complete & partner is the same for W2B
recode pconfm 0 = .
label variable pconfm "Conflict management index (W2A)"

tab pconfm, m // n = 274 missings

**** 10. Thought about possible separation *************************************

*-------------------------------------------------------------------------------
* C. Psych variables 
*-------------------------------------------------------------------------------


**** 1.a. Touch frequency index ************************************************
*       -> mean of the three touch items from W2B

egen omotf = rowmean(omo15i1_w2b omo16i1_w2b omo17i1_w2b) if omo15i1_w2b > 0 & omo16i1_w2b > 0 & omo17i1_w2b > 0  // include complete cases only
label variable omotf "Touch frequency index" 
// hist omotf
sum omotf if omotf > 0 // n = 0 missings

* b. Rename single variables
clonevar tf_kiss = omo15i1_w2b
clonevar tf_hold = omo16i1_w2b
clonevar tf_hug = omo17i1_w2b

label variable tf_kiss "Touch frequency: Kissing"
label variable tf_hold "Touch frequency: Holding"
label variable tf_hug "Touch frequency: Hugging"

mvdecode tf_kiss tf_hold tf_hug, mv(-10/-1) // define missing values
label define tfl 1 "0x" 2 "1-5x" 3 "6-10x" 4 "11-20x" 5 "21-50x" 6 "> 50x"
label values tf_kiss tf_hold tf_hug tfl

tab tf_kiss tf_hold, m

clonevar ptf_kiss = pomo15i1_w2b
clonevar ptf_hold = pomo16i1_w2b
clonevar ptf_hug = pomo17i1_w2b

label variable ptf_kiss "Partner Touch frequency: Kissing"
label variable ptf_hold "Partner Touch frequency: Holding"
label variable ptf_hug "Partner Touch frequency: Hugging"

mvdecode ptf_kiss ptf_hold ptf_hug, mv(-10/-1) // define missing values
label define ptfl 1 "0x" 2 "1-5x" 3 "6-10x" 4 "11-20x" 5 "21-50x" 6 "> 50x"
label values ptf_kiss ptf_hold ptf_hug ptfl

tab tf_kiss ptf_kiss

* kiss index
tab tf_kiss
* hold index
tab tf_hold
* hug index
tab tf_hug

* Partner kiss index
tab ptf_kiss
* Partner hold index
tab ptf_hold
* Partner hug index
tab ptf_hug


**** 2. Depressiveness index ***************************************************
*       -> mean of the three depression items from W2B

egen depr = rowtotal(per21i2_w2b per21i4_w2b per21i5_w2b) if per21i2_w2b > 0 & per21i4_w2b > 0 & per21i5_w2b > 0 // exclude missings
label variable depr "Depression total score W2B (3 items)"
tab depr, m // n = 11 missings
sum depr if depr > 0
**** 2. Partner ***************************************************


egen pdepr = rowtotal(pper21i2_w2b pper21i4_w2b pper21i5_w2b) if pper21i2_w2b > 0 & pper21i4_w2b > 0 & pper21i5_w2b > 0 // exclude missings
label variable pdepr "Depression total score W2B (3 items)"
tab pdepr, m // n = 11 missings
sum pdepr if pdepr > 0

**** 3. Self esteem ************************************************************
*       -> mean of 3 items from W2B

* a. recode Item 1 "Manchmal denke ich, dass ich wertlos bin."
recode per1i2_w2b (5=1) (4=2) (3=3) (2=4) (1=5), gen(per1i2_w2b_r)
label variable per1i2_w2b_r "[recoded] Persönliche Wahrnehmung: Wertlos"

* b. calculate sum score
egen self = rowtotal(per1i2_w2b_r per1i7 per1i13) if per1i2_w2b_r > 0 & per1i7 > 0 & per1i13 > 0
// exclude missings
label variable self "Self esteem W2B (3 items)"

tab self, m // n = 43 missings 
sum self if self > 0
**** 3. Partner ************************************************************

* a. recode Item 1 "Manchmal denke ich, dass ich wertlos bin."
recode pper1i2_w2b (5=1) (4=2) (3=3) (2=4) (1=5), gen(pper1i2_w2b_r)
label variable pper1i2_w2b_r "[recoded] Persönliche Wahrnehmung: Wertlos"

* b. calculate sum score
egen pself = rowtotal(pper1i2_w2b_r pper1i7 pper1i13) if pper1i2_w2b_r > 0 & pper1i7 > 0 & pper1i13 > 0
// exclude missings
label variable pself "Self esteem W2B (3 items)"

tab pself, m // n = 43 missings 
sum pself if pself > 0

**** 4. Loneliness *************************************************************

rename (per1i6_w2b) (loneliness)
mvdecode loneliness, mv(-10/-1)
tab loneliness, m // n = 12 missings
// hist loneliness

rename (pper1i6_w2b) (ploneliness)
mvdecode ploneliness, mv(-10/-1)
tab ploneliness, m // n = 12 missings

**** 5.a/b/c Rename relationship satisfaction, life satisfaction, health index, marital status

rename (sat3_w2b sat6_w2b hlt32_w2b) (relsat lifsat bad_health)
recode bad_health (5=1) (4=2) (3=3) (2=4) (1=5), gen(health)
label variable health "General health"
label variable lifsat "Life satisfaction"
label variable relsat "Relationship satisfaction"

mvdecode relsat, mv(-10/-1) 	// define missing values
mvdecode lifsat, mv(-10/-1) 	// define missing values
mvdecode health, mv(-10/-1) 	// define missing values

rename (bpa7_w2b) (married)
mvdecode married, mv(-10/-1)
label variable married "Marital status"
label define marriedl 1 "Married" 2 "Not married"
label values married marriedl

// tab married, m  // n = 7 missings
// tab lifsat, m  	// n = 7 missings
// tab relsat, m 	// n = 8 missings
// tab health, m 	// n = 3 missings

sum relsat if relsat > -1
sum lifsat if lifsat > -1



rename (psat3_w2b psat6_w2b phlt32_w2b) (prelsat plifsat pbad_health)
recode pbad_health (5=1) (4=2) (3=3) (2=4) (1=5), gen(phealth)
label variable phealth "General health"
label variable plifsat "Life satisfaction"
label variable prelsat "Relationship satisfaction"

mvdecode prelsat, mv(-10/-1) 	// define missing values
mvdecode plifsat, mv(-10/-1) 	// define missing values
mvdecode phealth, mv(-10/-1) 	// define missing values

tab plifsat, m  	// n = 7 missings
tab prelsat, m 	// n = 8 missings
tab phealth, m 	// n = 3 missings

sum prelsat if prelsat > -1
sum plifsat if plifsat > -1


**** 6. consvervative consvitudes *************************************************
*       -> sum score of 7 items from W2B

* a. recode item 4, 5
recode val1i14_w2b (5=1) (4=2) (3=3) (2=4) (1=5), gen(val1i14_w2b_r)
label variable val1i14_w2b_r "[recoded] Werte: Mutter-Kind-Beziehung bei berufstätiger Mutter"

recode val1i17_w2b (5=1) (4=2) (3=3) (2=4) (1=5), gen(val1i17_w2b_r)
label variable val1i17_w2b_r "[recoded] Werte: Vater-Kind-Beziehung bei berufstätigem Vater"

* b. define values
label define consvl -1 "Weiß nicht" -2 "Keine Antwort" -3 "Trifft nicht zu (Filter)" -4 "Filterfehler/falsche Eingabe" -5 "Inkonsistenter Wert" -6 "Unlesbare Antwort" -7 "Unvollständige Daten"	-8 "Trifft nicht zu (Antwortoption)" -9 "Unzulässige (Mehrfach-)Antwort" -10 "Designbedingter Missing" 1 "Stimme überhaupt nicht zu" 2 "Stimme eher nicht zu" 3 "Weder noch" 4 "Stimme eher zu" 5 "Stimme voll zu"
label values val1i14_w2b_r consvl
label values val1i17_w2b_r consvl

* c. calculate sum score, if no value is missing
egen consv = rowtotal(val1i5_w2b val1i15_w2b val1i16_w2b val1i14_w2b_r val1i17_w2b_r val2i5_w2b val2i2_w2b) if val1i5_w2b > 0 & val1i15_w2b > 0 & val1i16_w2b > 0 & val1i14_w2b_r > 0 & val1i17_w2b_r > 0 & val2i5_w2b > 0 & val2i2_w2b  > 0 // exclude missings
label variable consv "Conservative attitudes about family life W2B (7 items)"

// hist consv
sum consv if consv > -1
tab consv, m // n = 75 missings


**** 6. consvervative consvitudes PARTNER *************************************************
*       -> sum score of 7 items from W2B

* a. recode item 4, 5
recode pval1i14_w2b (5=1) (4=2) (3=3) (2=4) (1=5), gen(pval1i14_w2b_r)
label variable pval1i14_w2b_r "[recoded] Werte: Mutter-Kind-Beziehung bei berufstätiger Mutter"

recode pval1i17_w2b (5=1) (4=2) (3=3) (2=4) (1=5), gen(pval1i17_w2b_r)
label variable pval1i17_w2b_r "[recoded] Werte: Vater-Kind-Beziehung bei berufstätigem Vater"

* b. define values
label define pconsvl -1 "Weiß nicht" -2 "Keine Antwort" -3 "Trifft nicht zu (Filter)" -4 "Filterfehler/falsche Eingabe" -5 "Inkonsistenter Wert" -6 "Unlesbare Antwort" -7 "Unvollständige Daten"	-8 "Trifft nicht zu (Antwortoption)" -9 "Unzulässige (Mehrfach-)Antwort" -10 "Designbedingter Missing" 1 "Stimme überhaupt nicht zu" 2 "Stimme eher nicht zu" 3 "Weder noch" 4 "Stimme eher zu" 5 "Stimme voll zu"
label values pval1i14_w2b_r pconsvl
label values pval1i17_w2b_r pconsvl

* c. calculate sum score, if no value is missing
egen pconsv = rowtotal(pval1i5_w2b pval1i15_w2b pval1i16_w2b pval1i14_w2b_r pval1i17_w2b_r pval2i5_w2b pval2i2_w2b) if pval1i5_w2b > 0 & pval1i15_w2b > 0 & pval1i16_w2b > 0 & pval1i14_w2b_r > 0 & pval1i17_w2b_r > 0 & pval2i5_w2b > 0 & pval2i2_w2b  > 0 // exclude missings
label variable pconsv "Conservative attitudes about family life W2B (7 items)"

// hist consv
//sum consv if consv > -1
//tab consv, m // n = 75 missings

**** 7. BIG-5 ******************************************************************
* a. recode item 22, 27, 24, 28, 29, 32
recode per3i22_w2b per3i24_w2b per3i27_w2b per3i28_w2b per3i29_w2b per3i32_w2b (5=1) (4=2) (3=3) (2=4) (1=5), gen(per3i22_w2b_r per3i24_w2b_r per3i27_w2b_r per3i28_w2b_r per3i29_w2b_r per3i32_w2b_r) 

* b. calculate sum scores

* Extraversion(1)
egen extr = rowtotal(per3i22_w2b_r per3i26_w2b per3i30_w2b) if per3i22_w2b_r > 0 & per3i26_w2b > 0 & per3i30_w2b > 0
label variable extr "Extraversion"

* Agreeableness
egen agree = rowtotal(per3i23_w2b per3i7_w2b per3i27_w2b_r) if per3i23_w2b > 0 & per3i7_w2b > 0 & per3i27_w2b_r > 0
label variable agree "Agreeableness"

* conscientiousness
egen consc = rowtotal(per3i24_w2b_r per3i28_w2b_r per3i31_w2b) if per3i24_w2b_r > 0 & per3i28_w2b_r > 0 & per3i31_w2b > 0
label variable consc "conscientiousness"

* Openess
egen open = rowtotal(per3i25_w2b per3i29_w2b_r per3i33_w2b) if per3i25_w2b > 0 & per3i29_w2b_r > 0 & per3i33_w2b > 0
label variable open "Openess"

* Neuroticism(2)
egen neur = rowtotal(per3i14_w2b per3i4_w2b per3i32_w2b_r) if per3i14_w2b > 0 & per3i4_w2b > 0 & per3i32_w2b_r > 0
label variable neur "Neuroticism"

sum(extr)
sum(agree)
sum(consc)
sum(open)
sum(neur)

**** 7. BIG-5 (PARTNER) ******************************************************************
* a. recode item 22, 27, 24, 28, 29, 32
recode pper3i22_w2b pper3i24_w2b pper3i27_w2b pper3i28_w2b pper3i29_w2b pper3i32_w2b (5=1) (4=2) (3=3) (2=4) (1=5), gen(pper3i22_w2b_r pper3i24_w2b_r pper3i27_w2b_r pper3i28_w2b_r pper3i29_w2b_r pper3i32_w2b_r) 

* b. calculate sum scores

* Extraversion(1)
egen pextr = rowtotal(pper3i22_w2b_r pper3i26_w2b pper3i30_w2b) if pper3i22_w2b_r > 0 & pper3i26_w2b > 0 & pper3i30_w2b > 0
label variable pextr "Extraversion"

* Agreeableness
egen pagree = rowtotal(pper3i23_w2b pper3i7_w2b pper3i27_w2b_r) if pper3i23_w2b > 0 & pper3i7_w2b > 0 & pper3i27_w2b_r > 0
label variable pagree "Agreeableness"

* conscientiousness
egen pconsc = rowtotal(pper3i24_w2b_r pper3i28_w2b_r pper3i31_w2b) if pper3i24_w2b_r > 0 & pper3i28_w2b_r > 0 & pper3i31_w2b > 0
label variable pconsc "conscientiousness"

* Openess
egen popen = rowtotal(pper3i25_w2b pper3i29_w2b_r pper3i33_w2b) if pper3i25_w2b > 0 & pper3i29_w2b_r > 0 & pper3i33_w2b > 0
label variable popen "Openess"

* Neuroticism(2)
egen pneur = rowtotal(pper3i14_w2b pper3i4_w2b pper3i32_w2b_r) if pper3i14_w2b > 0 & pper3i4_w2b > 0 & pper3i32_w2b_r > 0
label variable pneur "Neuroticism"

sum(pextr)
sum(pagree)
sum(pconsc)
sum(popen)
sum(pneur)

// hist extr
// hist agree
// hist consc
// hist open
// hist neur

// tab extr, m // n = 26 missings
// tab agree, m // n = 25 missings
// tab consc, m // n = 29 missings
// tab open, m // n = 57 missings
// tab neur, m // n = 24 missings

**** 8. Religion ******************************************************************
gen god = sd36_w2b if sd36_w2b > -1 // "Importance of God", missings = 13
label variable god "Importance of God"

**** 8. Partner ******************************************************************
gen pgod = psd36_w2b if psd36_w2b > -1 // "Importance of God", missings = 13
label variable pgod "Importance of God"



**** Age of kid *****

*-------------------------------------------------------------------------------
**** Save separately (only cases with answers to the touch frequency questions)
*-------------------------------------------------------------------------------
* log close

// delete all waves but W2B
drop *_w1r
drop *_w1a
drop *_w1b
drop *_w2a

outsheet age page workst pworkst sex psex samesex reldur reldur_class cohab nkidsliv_class relsat prelsat relin prelint tf_kiss tf_hold tf_hug ptf_kiss ptf_hold ptf_hug omo15i1_w2b omo16i1_w2b omo17i1_w2b omo15i2_w2b omo16i2_w2b omo17i2_w2b pomo15i1_w2b pomo16i1_w2b pomo17i1_w2b pomo15i2_w2b pomo16i2_w2b pomo17i2_w2b agediff_class confm pconfm loneliness ploneliness lifsat plifsat extr agree consc open neur depr pdepr self pself health phealth consv god pgod pextr pagree pconsc popen pneur east peast degurba pdegurba married pconsv ykage_class_w2b pisced11 isced11 using outputdata.csv, comma

cd $path_data_all
save W2B_com_t.dta, replace
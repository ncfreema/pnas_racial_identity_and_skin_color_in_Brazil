// Generate Weight Variable

gen weight1500=. 
replace weight1500=wt*1500/1562 if pais==1 
replace weight1500=wt*1500/1504 if pais==2 
replace weight1500=wt*1500/1550 if pais==3 
replace weight1500=wt*1500/1596 if pais==4 
replace weight1500=wt*1500/1540 if pais==5 
replace weight1500=wt*1500/1500 if pais==6 
replace weight1500=wt*1500/1536 if pais==7 
replace weight1500=wt*1500/1506 if pais==8 
replace weight1500=wt*1500/3000 if pais==9 
replace weight1500=wt*1500/3018 if pais==10 
replace weight1500=wt*1500/1500 if pais==11 
replace weight1500=wt*1500/1502 if pais==12 
replace weight1500=wt*1500/1965 if pais==13 
replace weight1500=wt*1500/1500 if pais==14 
replace weight1500=wt*1500/2482 if pais==15 
replace weight1500=wt*1500/1500 if pais==16 
replace weight1500=wt*1410/1500 if pais==17 
replace weight1500=wt*1500/1500 if pais==21 
replace weight1500=wt*1500/1752 if pais==22 
replace weight1500=wt*1500/1504 if pais==23 
replace weight1500=wt*1500/1540 if pais==24 
replace weight1500=wt*1500/1503 if pais==25 
replace weight1500=wt*1500/1504 if pais==26 
replace weight1500=wt*1500/1514 if pais==27 
replace weight1500=wt*1500/1500 if pais==40 
replace weight1500=wt*1500/1500 if pais==41 

// Code to Weight Data

svyset upm [pw=weight1500], strata(strata)

// Generate New Variables

*Dependent Variable

*Race 
gen Race = .
replace Race=1 if etid==1 
replace Race=2 if etid==5 
replace Race=3 if etid==4
label define Racel 1 "White" 2 "Brown" 3 "Black" 
label values Race Racel 

*Indepednent Variable

*Respodent Skin Color (3-point measure) 
gen Respondentskincolor3pt = .
replace Respondentskincolor3pt=1 if colorr==1 | colorr==2 | colorr==3
replace Respondentskincolor3pt=2 if colorr==4 | colorr==5 | colorr==6
replace Respondentskincolor3pt=3 if colorr==7 | colorr==8 | colorr==9 | colorr==10 | colorr==11
label define Respondentskincolor3ptl 1 "Light" 2 "Medium" 3 "Dark" 
label values Respondentskincolor3pt Respondentskincolor3ptl 

*Controls

*Year

*Note: "Year" variable needs to be constructed such that respondents from the 2010 survey wave our assigned a 1, respondents from the 2012 survey wave our assigned a 2, respondents from the 2014 survey wave our assigned a 3, respondents from the 2017 survey wave our assigned a 4, respondents from the 2019 survey wave our assigned a 5, and respondents from the 2010 survey wave our assigned a 7.   

*Interviewer Skin Color (3-point measure) 
gen Interviewerskincolor3pt = .
replace Interviewerskincolor3pt=1 if colori==1 | colori==2 | colori==3
replace Interviewerskincolor3pt=2 if colori==4 | colori==5 | colori==6
replace Interviewerskincolor3pt=3 if colori==7 | colori==8 | colori==9 | colori==10 | colori==11
label define Interviewerskincolor3ptl 1 "Light" 2 "Medium" 3 "Dark" 
label values Interviewerskincolor3pt Interviewerskincolor3ptl 

*Female 
gen Female = .
replace Female=1 if sexo==2 
replace Female=0 if sexo==1 
label define Femalel 1 "Female" 0 "Male" 
label values Female Femalel 

*Age
rename q2 Age

*Education 
gen Education = .
replace Education=1 if ed <= 8 
replace Education=2 if ed==9 | ed==10 | ed==11
replace Education=3 if ed >= 12
label define Educationl 1 "0-8" 2 "9-11" 3 "12-18"
label values Education Educationl 

*Urban 
gen Urban = .
replace Urban=1 if ur==1 
replace Urban=0 if ur==2 
label define Urbanl 1 "Urban" 0 "Rural" 
label values Urban Urbanl 

*Region
gen Region = .
replace Region=1 if estratopri==1
replace Reigon=2 if estratopri==2 
replace Region=3 if estratopri==3
replace Region=4 if estratopri==4
replace Region=5 if estratopri==5
label define Regionl 1 "North" 2 "Northeast" 3 "Central-West" 4 "Southeast" 5 "South"   
label values Region Regionl

*Wealth
pca r1 r3 r4 r6 r7 r12 r15 r16
rotate
predict pc1, score
rename pc1 Wealth

// Descriptive Analyses

svy: tab Race  

svy: tab Respondentskincolor3pt 

svy: tab Interviewerskincolor3pt  

svy: tab Year 

svy: mean Wealth
estat sd

svy: tab Female

svy: mean Age 
estat sd

svy: tab Urban 

svy: tab Region 

svy: tab Education

svy: tab Respondentskincolor11pt

svy: tab Interviewerskincolor11pt


// Regression Analyses

*Multinomial regression predicting brown and black versus white racial identity
mlogit Race i.Interviewerskincolor3pt Wealth Age i.Education Female Urban ib4.Region i.Respondentskincolor3pt c.Year [pw=weight1500], base(1)

*Multinomial regression predicting brown and black versus white racial identity (with respondent skin color x year interaction)
mlogit Race i.Interviewerskincolor3pt Wealth Age i.Education Female Urban ib4.Region i.Respondentskincolor3pt##c.Year [pw=weight1500], base(1)

*Multinomial regression predicting brown and black versus white racial identity (with respondent skin color x education x year interaction)
mlogit Race i.Interviewerskincolor3pt Wealth Age Female Urban ib4.Region i.Respondentskincolor3pt##i.Education##c.Year [pw=weight1500], base(1)

*Multinomial regression predicting brown and black versus white racial identity (with 11-point skin color measures)
mlogit Race c.Interviewerskincolor11pt Wealth Age i.Education Female Urban ib4.Region c.Respondentskincolor11pt c.Year [pw=weight1500], base(1)

*Multinomial regression predicting brown and black versus white racial identity (with respondent skin color x year interaction and 11 point skin color measures)
mlogit Race c.Interviewerskincolor11pt Wealth Age i.Education Female Urban ib4.Region c.Respondentskincolor11pt##c.Year [pw=weight1500], base(1)


// Predicted Probability Analyses 

*Predicted probabilities of self-identity as white, brown, or black for light skin persons, medium skin persons, and dark skin persons
margins Respondentskincolor3pt, at(Year=()) atmeans


*Predicted probabilities of self-identity as white, brown, or black, by education level, for light skin persons, medium skin persons, and dark skin persons
margins Respondentskincolor3pt, at(Education=() Year=()) atmeans




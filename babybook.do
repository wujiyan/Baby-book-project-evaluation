cd "D:\documents\project evaluation" 
use Raw_BabyBook_Data, clear


use FamilyID_Only.dta
rename Col1 AWFamID
merge 1:m  AWFamID using "D:\documents\project evaluation\Raw_BabyBook_Data.dta"

keep if _merge==3
drop _merge

save BabyBooks, replace



*create weekly earnings
gen Earnings=AWBQ13*AWBQ14
label var Earnings "Weekly Earnings Hrs x Wage"

* Creating time variable *
gen DOBMonths=(awdate-cDOB)/30.4    /* baby age in month */
replace DOBMonths=0 if WaveSort==1  /*It is prenatal period when WaveSort==1, so we assign 0 to birth date*/
gen DOBMonthsR=round(DOBMonths)     /* gen rounded baby age */
replace DOBMonthsR=0 if WaveSort==1 /* Fill in missing cDOB values from other values (within family ID) */
label var DOBMonths "Baby's age in Months"
label var DOBMonthsR "Baby's age in Months rounded"
tab DOBMonths
tab DOBMonthsR

** IDENTIFY ISSUES GENERATING THIS VALUE
count if DOBMonths==.
*list AWFamID WaveSort DOBMonths if DOBMonths==.

** dropping several entries without any data
drop if DOBMonths==.


//attrition rate
tab WaveSort 
gen still_in7 = .
replace still_in7 = 0 if WaveSort == 1
replace still_in7 = 1 if WaveSort == 7

table AWFamID, c(sum still_in7) row col
gen still_in =.
replace still_in = 1 if WaveSort == 1
replace still_in = 0 if AWFamID == 1207 & WaveSort == 1 | AWFamID == 1218 & WaveSort == 1 | AWFamID == 1224 & WaveSort == 1 | AWFamID == 1231 & WaveSort == 1 | AWFamID == 1302 & WaveSort == 1 | AWFamID == 1311 & WaveSort == 1 | AWFamID == 1328 & WaveSort == 1 | AWFamID == 1343 & WaveSort == 1 | AWFamID == 1350 & WaveSort == 1 | AWFamID == 1369 & WaveSort == 1 | AWFamID == 1406 & WaveSort == 1 | AWFamID == 1428 & WaveSort == 1 | AWFamID == 1464 & WaveSort == 1 | AWFamID == 1496 & WaveSort == 1 | AWFamID == 1519 & WaveSort == 1 | AWFamID == 1596 & WaveSort == 1 | AWFamID == 1608 & WaveSort == 1 | AWFamID == 1633 & WaveSort == 1 | AWFamID == 1647 & WaveSort == 1 | AWFamID == 1648 & WaveSort == 1 | AWFamID == 1674 & WaveSort == 1 | AWFamID == 1676 & WaveSort == 1

drop if still_in ==.





local variable_a "AWBQ04 AWBQ05 AWBQ06 AWBQ09 AWBQ09a AWBQ09b AWBQ09d AWBQ09e AWBQ09f AWBQ09g AWBQ09h AWBQ09i AWBQ09k AWBQ09l AWBQ09m AWBQ09n AWBQ10 AWBQ13 AWBQ14 AWBQ17 AWBQ18 AWBQ19 AWBQ02 AWBQ03 A1MomAge AWBQ20"

//ssc install mdesc, replace

mdesc `variable_a'


* simple sum
sum `variable_a'
sum `variable_a' if still_in==0
sum `variable_a' if still_in==1




foreach var of local variable_a {

ttest `var', by(still_in) 
}

* generate a random variable and a real randomly assignment treatment




//knowledge about safety
egen knowledge=rowmean(AWO1B02C AWO1B05C AWO1B12C AWO1B15C AWO1B16C AWO1B19C AWO1B20C AWO1B21C AWO1B26C AWO1B29C)
label var knowledge "percent of correct answers among the questions about safety which are answered, prenatal"

table DOBMonthsR StudyGrp, c(mean knowledge) row col

egen AWO1BPCS1=rowtotal(AWO1B02C AWO1B05C AWO1B12C AWO1B15C AWO1B16C AWO1B19C AWO1B20C AWO1B21C AWO1B26C AWO1B29C),m
replace AWO1BPCS1=AWO1BPCS1/10
label var AWO1BPCS1 "percent of correct answers among all of the questions about safety, prenatal" 



***********************************************************************************************
*               CREATING THE VARIABLE FOR INJURIES BASED ON SEVERITY LEVEL                   *
***********************************************************************************************


//injury types
table AWIC09a StudyGrp if AWIC09a==2
table AWIC09a StudyGrp if AWIC09a==3
table AWIC09a StudyGrp if AWIC09a==4
table AWIC09a StudyGrp if AWIC09a==5
table AWIC09a StudyGrp if AWIC09a==6
table AWIC09a StudyGrp if AWIC09a==7
table AWIC09a StudyGrp if AWIC09a==8
table AWIC09a StudyGrp if AWIC09a==9
table OtherInj_EmergencyVisit StudyGrp if OtherInj_EmergencyVisit==1
table AWIC09a StudyGrp if AWIC09a==11
table AWIC09a StudyGrp if AWIC09a==12


table AWIC14a StudyGrp if AWIC14a==2
table AWIC14a StudyGrp if AWIC14a==3
table AWIC14a StudyGrp if AWIC14a==4
table AWIC14a StudyGrp if AWIC14a==5
table AWIC14a StudyGrp if AWIC14a==6
table AWIC14a StudyGrp if AWIC14a==7
table AWIC14a StudyGrp if AWIC14a==8
table AWIC14a StudyGrp if AWIC14a==9
table OtherInj_HospitalStay StudyGrp if OtherInj_HospitalStay==1
table AWIC14a StudyGrp if AWIC14a==11
table AWIC14a StudyGrp if AWIC14a==12



table AWIC17ab StudyGrp if AWIC17ab==1
table AWIC17ac StudyGrp if AWIC17ac==1
table AWIC17ad StudyGrp if AWIC17ad==1
table AWIC17ae StudyGrp if AWIC17ae==1
table AWIC17af StudyGrp if AWIC17af==1
table AWIC17ag StudyGrp if AWIC17ag==1
table AWIC17ah StudyGrp if AWIC17ah==1
table AWIC17ai StudyGrp if AWIC17ai==1
table AWIC17aj StudyGrp if AWIC17aj==1
table AWIC17ak StudyGrp if AWIC17ak==1
table AWIC17al StudyGrp if AWIC17al==1
table AWIC17b StudyGrp if AWIC17b==1

table StudyGrp Other_Injury
table StudyGrp Other_Injury if AWIC17ac==1
table StudyGrp Other_Injury if AWIC17ad==1
table StudyGrp Other_Injury if AWIC17ae==1
table StudyGrp Other_Injury if AWIC17af==1
table StudyGrp Other_Injury if AWIC17ag==1
table StudyGrp Other_Injury if AWIC17ah==1
table StudyGrp Other_Injury if AWIC17ai==1
table StudyGrp Other_Injury if AWIC17aj==1
table StudyGrp Other_Injury if AWIC17ak==1
table StudyGrp Other_Injury if AWIC17al==1
table StudyGrp Other_Injury if AWIC17b==1




*  Generating variables for Emergency Visits *
*  Use file InterviewQuestionnaire_Codebook and file codebkFinalFile. The first file identifies AWIC09a as dummy variable for Emergency Room visits (first ER visit). There are 10 types of injuries and an additional "other" category for injuries that can not be classified in either type.
*  10 injury types include fall, burn, cut, struck, chocking, car accident, drowning, borken bone or sprain, spanking, and shaking. 
*  Below is provided the generation of the variable for emergency visits with fall injury type, including first, second, third, and fourth ER visits. In the questionnaire "InterviewQuestionnaire_Codebook" you can see that fall is 2 in the list of injuries when the participants are asked for the reason of ER visit. 
*  Since AWIC09a refers to first ER visit, questions were asked to participants for the second, third, and fourth ER visit and each of them have the following variable names respectively: AWIC10a, AWIC11a, AWIC12a.

gen Fall_EmergencyVisit = 0
replace Fall_EmergencyVisit = 1 if AWIC09a==2 | AWIC10a==2 | AWIC11a==2 | AWIC12a==2 
gen Burn_EmergencyVisit = 0
replace Burn_EmergencyVisit = 1 if AWIC09a==3 | AWIC10a==3 | AWIC11a==3 | AWIC12a==3
gen Cut_EmergencyVisit = 0
replace Cut_EmergencyVisit = 1 if AWIC09a==4 | AWIC10a==4 | AWIC11a==4 | AWIC12a==4 
gen Struck_EmergencyVisit = 0
replace Struck_EmergencyVisit = 1 if AWIC09a==5 | AWIC10a==5 | AWIC11a==5 | AWIC12a==5
gen Chock_EmergencyVisit = 0
replace Chock_EmergencyVisit = 1 if AWIC09a==6 | AWIC10a==6 | AWIC11a==6 | AWIC12a==6 
gen Car_EmergencyVisit = 0
replace Car_EmergencyVisit = 1 if AWIC09a==7 | AWIC10a==7 | AWIC11a==7 | AWIC12a==7
gen Drowning_EmergencyVisit = 0
replace Drowning_EmergencyVisit = 1 if AWIC09a==8 | AWIC10a==8 | AWIC11a==8 | AWIC12a==8
gen Sprain_EmergencyVisit = 0
replace Sprain_EmergencyVisit = 1 if AWIC09a==9 | AWIC10a==9 | AWIC11a==9 | AWIC12a==9
gen Spank_EmergencyVisit = 0
replace Spank_EmergencyVisit = 1 if AWIC09a==11 | AWIC10a==11 | AWIC11a==11 | AWIC12a==11
gen Shake_EmergencyVisit = 0
replace Shake_EmergencyVisit = 1 if AWIC09a==12 | AWIC10a==12 | AWIC11a==12 | AWIC12a==12


* Generating Other Injuries variable for Emergency Visits *
* Use again the file InterviewQuestionnaire_Codebook. Other Injuries are labelled as AWIC09aS, 10th in order,  in the list of reasons for the first ER visit. Since other injuries can not be classified in a specific type, they should be analyzed one by one to determine injury related visits.
* Identifying injury related Other Injuries for ER *

list AWIC09a AWIC09aS if AWIC09a==10   /* This command allows you to obtain a list of Other Injuries for the first ER visit with descriptions. Going over each description, we identify injurt related visits. */
									  /* Repeat the same command for second, third, and fourth ER visits. */
* Below we generate the variable for Other Injuries for ER and we use the specific injuries identified with "list" command.
gen OtherInj_EmergencyVisit = 0
replace OtherInj_EmergencyVisit = 1 if AWIC09aS== "thought he swallowed chemicals" | AWIC09aS== "eye injury - unknown cause" | AWIC09aS== "smashed finger" | AWIC09aS== "dropped something on foot" | AWIC09aS== "swollen eye" | AWIC09aS== "drank whole bottle of Benadryl" | AWIC09aS== "swallowed pill" | AWIC09aS== "swallowed mom's medication" | AWIC09aS== "bitten by family dog" | AWIC09aS== "vaginal bleeding" | AWIC09aS== "vomiting-GERD" 

* Total Emergency Visit Injuries *
egen EmergencyVisits = rowtotal(Fall_EmergencyVisit Burn_EmergencyVisit Cut_EmergencyVisit Struck_EmergencyVisit Chock_EmergencyVisit Car_EmergencyVisit Drowning_EmergencyVisit Sprain_EmergencyVisit Spank_EmergencyVisit Shake_EmergencyVisit OtherInj_EmergencyVisit)
label var EmergencyVisits "total number of injuries calling for emergency visit"

* Generating variables for Hospital Stays *
* Same file as for ER is used. Variable defined for Hospital Stays is AWIC14a, which refers to first hospital stay. We also have AWIC15a and AWIC16a for the second and third hospital stays respectively. *

gen Fall_HospitalStay = 0
replace Fall_HospitalStay = 1 if AWIC14a==2 | AWIC15a==2 | AWIC16a==2  
gen Burn_HospitalStay = 0
replace Burn_HospitalStay = 1 if AWIC14a==3 | AWIC15a==3 | AWIC16a==3 
gen Cut_HospitalStay = 0
replace Cut_HospitalStay = 1 if AWIC14a==4 | AWIC15a==4 | AWIC16a==4  
gen Struck_HospitalStay = 0
replace Struck_HospitalStay = 1 if AWIC14a==5 | AWIC15a==5 | AWIC16a==5
gen Chock_HospitalStay = 0
replace Chock_HospitalStay = 1 if AWIC14a==6 | AWIC15a==6 | AWIC16a==6  
gen Car_HospitalStay = 0
replace Car_HospitalStay = 1 if AWIC14a==7 | AWIC15a==7 | AWIC16a==7 
gen Drowning_HospitalStay = 0
replace Drowning_HospitalStay = 1 if AWIC14a==8 | AWIC15a==8 | AWIC16a==8 
gen Sprain_HospitalStay = 0
replace Sprain_HospitalStay = 1 if AWIC14a==9 | AWIC15a==9 | AWIC16a==9 
gen Spank_HospitalStay = 0
replace Spank_HospitalStay = 1 if AWIC14a==11 | AWIC15a==11 | AWIC16a==11 
gen Shake_HospitalStay = 0
replace Shake_HospitalStay = 1 if AWIC14a==12 | AWIC15a==12 | AWIC16a==12 

* Generating Other Injuries variable for Hospital Stays *
* Use again the file InterviewQuestionnaire_Codebook. Other Injuries are labelled as AWIC14aS, 10th in order,  in the list of reasons for the first HS. Since other injuries can not be classified in a specific type, they should be analyzed one by one to determine injury related stays.
* Identifying injury related Other Injuries for HS *

list AWIC14a AWIC14aS if AWIC14a==10    /* This command allows you to obtain a list of Other Injuries for the first HS with descriptions. Going over each description, we identify injurt related stays. */
									    /* Repeat the same command for second and this hospital stay. */
* Below we generate the variable for Other Injuries for HS and we use the specific injuries identified with "list" command.*
gen OtherInj_HospitalStay = 0
replace OtherInj_HospitalStay = 1 if AWIC14aS== " swallowed mom's medication "
egen HospitalStays = rowtotal(Fall_HospitalStay Burn_HospitalStay Cut_HospitalStay Struck_HospitalStay Chock_HospitalStay Car_HospitalStay Drowning_HospitalStay Sprain_HospitalStay Spank_HospitalStay Shake_HospitalStay OtherInj_HospitalStay)
label var HospitalStays "total number of injuries calling for hospital stays"

* Generating variables for Doctors Visits * 
* Use files InterviewQuestionnaire_Codebook and codebkFinalFile. The following variables in the first file refer to the first, second, third, fourth, fifth, sixth and seventh doctor's visit respectively: AWIC04a, AWIC05a, AWIC06a, AWIC07a, AWIC50a, AWIC51a, AWIC52a. These variables take the value 3 if the reason for the visit was an injury; therefore we define the command conditional on the variables being equal to 3.
* In the second file, we see that AWIC04b3 (as a sample) refers to a dummy variable which takes the value 1 if the cost incurred is caused by an injury.
gen DoctorsVisits1 = 0
replace DoctorsVisits1 = 1 if AWIC04a==3 | AWIC04b3==1
gen DoctorsVisits2 = 0
replace DoctorsVisits2 = 1 if AWIC05a==3 | AWIC05b3==1
gen DoctorsVisits3 = 0
replace DoctorsVisits3 = 1 if AWIC06a==3 | AWIC06b3==1
gen DoctorsVisits4 = 0
replace DoctorsVisits4 = 1 if AWIC07a==3 | AWIC07b3==1
gen DoctorsVisits5 = 0
replace DoctorsVisits5 = 1 if AWIC50a==3 | AWIC50b3==1
gen DoctorsVisits6 = 0
replace DoctorsVisits6 = 1 if AWIC51a==3 | AWIC51b3==1
gen DoctorsVisits7 = 0
replace DoctorsVisits7 = 1 if AWIC52a==3 | AWIC52b3==1

* Generating Other Doctor's Visits *
* Similar to ER and HS, we need to identify injury related visits from the list of all doctors visits *

list AWIC04a AWIC04aS if AWIC04a==6   /* This command allows us to generate a list of all other doctors visits. The variable is AWIC04aS and it is sixth in sequence as labelled in the file InterviewQuestionnaire_Codebook. */
                                      /* Repeat the same for the rest of the doctor's visits */
* Generate Other Doctor's Visits using the list command above and identifying specific descriptions for injuries *
gen Other_DoctorsVisits = 0
replace Other_DoctorsVisits = 1 if AWIC04aS== " broke out " | AWIC06aS== " swallow study " | AWIC06aS== " eating too much " 
egen DoctorsVisits = rowtotal(DoctorsVisits1 DoctorsVisits2 DoctorsVisits3 DoctorsVisits4 DoctorsVisits5 DoctorsVisits6 DoctorsVisits7 Other_DoctorsVisits)
label var DoctorsVisits "total number of injuries that remained at the doctors visits level"


* Generate OTHER INJURIES *
* Use files InterviewQuestionnaire_Codebook and codebkFinalFile. These injuries refer to injuries other than doctor's visits, ER, and HS. The variable is AWIC17a, and the following letters indicate the specific injury type (i.e. AWIC17ab is for fall.)
egen Other_Injury = rowtotal(AWIC17ab AWIC17ac AWIC17ad AWIC17ae AWIC17af AWIC17ag AWIC17ah AWIC17ai AWIC17ak AWIC17al AWIC17aj AWIC17b) 
label var Other_Injury "total number of injuries per type other than emergency visit and hospital stay"

egen totalinjury = rowtotal(EmergencyVisits HospitalStays DoctorsVisits Other_Injury) 
label var totalinjury "total number of injuries"

local injury_list "EmergencyVisits HospitalStays DoctorsVisits Other_Injury totalinjury "

foreach var of local injury_list {

*table NewWave StudyGrp, c(sum `var') row col
*table DOBMonths StudyGrp, c(sum `var') row col
table DOBMonthsR StudyGrp, c(sum `var') row col

}

*******************

foreach var of local injury_list {

*table NewWave StudyGrp, c(sum `var') row col
*table DOBMonths StudyGrp, c(sum `var') row col
table AWFamID StudyGrp, c(sum `var') row col

}

****************

list AWMonth AWDay if HospitalStays == 1
list AWMonth AWDay if DoctorsVisits == 1 









***********************************************
***********************************************

save babybooks0, replace


//ttest group 2and3

local variable_s "AWBQ04 AWBQ05 AWBQ06 AWBQ09 AWBQ09a AWBQ09b AWBQ09d AWBQ09e AWBQ09f AWBQ09g AWBQ09h AWBQ09i AWBQ09k AWBQ09l AWBQ09m AWBQ09n AWBQ08 AWBQ08BW AWBQ10 AWBQ13 AWBQ14 AWBQ17 AWBQ18 AWBQ19 AWBQ02 AWBQ03 A1MomAge AWBQ20 AWBQ50 totalinjury"

//ssc install mdesc, replace

mdesc `variable_s'

//gen stugrp23 = StudyGrp
drop if stugrp23 == 1

* simple sum
sum `variable_s'
sum `variable_s' if stugrp23==3
sum `variable_s' if stugrp23==2



* sum by Receiving or not remittances
foreach var of local variable_s {
tab stugrp23, s(`var')
}




foreach var of local variable_s {

sum `var', d
}

* t test by whether receiving remittance

foreach var of local variable_s {

ttest `var', by(stugrp23)
}

* generate a random variable and a real randomly assignment treatment





//ttest group 1 and 3

use babybooks0.dta

local variable_s "AWBQ04 AWBQ05 AWBQ06 AWBQ09 AWBQ09a AWBQ09b AWBQ09d AWBQ09e AWBQ09f AWBQ09g AWBQ09h AWBQ09i AWBQ09k AWBQ09l AWBQ09m AWBQ09n AWBQ08 AWBQ08BW AWBQ10 AWBQ13 AWBQ14 AWBQ17 AWBQ18 AWBQ19 AWBQ02 AWBQ03 A1MomAge AWBQ20 AWBQ50"

ssc install mdesc, replace

mdesc `variable_s'


gen stugrp13 = StudyGrp
drop if stugrp13 == 2

* simple sum
sum `variable_s'
sum `variable_s' if stugrp13==1
sum `variable_s' if stugrp13==3



* sum by Receiving or not remittances
foreach var of local variable_s {
tab stugrp13, s(`var')
}




foreach var of local variable_s {

sum `var', d
}

* t test by whether receiving remittance

foreach var of local variable_s {

ttest `var', by(stugrp13)
}

* generate a random variable and a real randomly assignment treatment




//ttest group 1 and 2

use babybooks0.dta

local variable_s "AWBQ04 AWBQ05 AWBQ06 AWBQ09 AWBQ09a AWBQ09b AWBQ09d AWBQ09e AWBQ09f AWBQ09g AWBQ09h AWBQ09i AWBQ09k AWBQ09l AWBQ09m AWBQ09n AWBQ08 AWBQ08BW AWBQ10 AWBQ13 AWBQ14 AWBQ17 AWBQ18 AWBQ19 AWBQ02 AWBQ03 A1MomAge AWBQ20 AWBQ50"

ssc install mdesc, replace

mdesc `variable_s'


* simple sum
sum `variable_s'
sum `variable_s' if StudyGrp==1
sum `variable_s' if StudyGrp==2



* sum by Receiving or not remittances
foreach var of local variable_s {
tab StudyGrp, s(`var')
}




foreach var of local variable_s {

sum `var', d
}

* t test by whether receiving remittance

foreach var of local variable_s {

ttest `var', by(StudyGrp)
}

* generate a random variable and a real randomly assignment treatment









************************************************
************************************************


//do the randomizaion in the excel, merge the commercial group and no book group,and randomly select half of the control group
use babybooks0.dta

drop if AWFamID == 1074 | AWFamID == 1081 | AWFamID == 1150 | AWFamID == 1225 | AWFamID == 1231 | AWFamID == 1296 | AWFamID == 1302 | AWFamID == 1308 | AWFamID == 1318 | AWFamID == 1332 | AWFamID == 1348 | AWFamID == 1357 | AWFamID == 1378 | AWFamID == 1384 | AWFamID == 1357 | AWFamID == 1378 | AWFamID == 1384 | AWFamID == 1390 | AWFamID == 1408 | AWFamID == 1446 | AWFamID == 1456 | AWFamID == 1465 | AWFamID == 1467 | AWFamID == 1471 | AWFamID == 1497 | AWFamID == 1506 | AWFamID == 1515 | AWFamID == 1520 | AWFamID == 1531 | AWFamID == 1540 | AWFamID == 1541 | AWFamID == 1559 | AWFamID == 1579 | AWFamID == 1585 | AWFamID == 1617 | AWFamID == 1621 | AWFamID == 1067 | AWFamID == 1142 | AWFamID == 1262 | AWFamID == 1313 | AWFamID == 1343 | AWFamID == 1350 | AWFamID == 1359 | AWFamID == 1367 | AWFamID == 1379 | AWFamID == 1380 | AWFamID == 1381 | AWFamID == 1385 | AWFamID == 1387 | AWFamID == 1406 | AWFamID == 1425 | AWFamID == 1426 | AWFamID == 1433 | AWFamID == 1434 | AWFamID == 1435 | AWFamID == 1444 | AWFamID == 1505 | AWFamID == 1509 | AWFamID == 1526 | AWFamID == 1532 | AWFamID == 1546 | AWFamID == 1555 | AWFamID == 1569


replace StudyGrp = 2 if StudyGrp == 2 | StudyGrp ==3





*******************************************************
*******************************************************


gen StuDOB = StudyGrp*DOBMonthsR
replace StudyGrp = 0 if StudyGrp == 2


gen employment = 0
replace employment = 1 if AWBQ09 == 1 | AWBQ09 == 2 | AWBQ09 == 9
replace employment = 0 if AWBQ09 == 3 | AWBQ09 == 4 | AWBQ09 == 7 | AWBQ09 == 8

gen findepend = 0
replace findepend = 1 if AWBQ19 == 1 | AWBQ19 == 2
replace findepend = 0 if AWBQ19 == 3 | AWBQ19 == 4

gen publicass = AWBQ18

gen time = DOBMonthsR


collapse (mean)DOBMonthsR (max)StudyGrp (sum)Other_Injury employment publicass findepend, by(AWFamID time)

gen time_tx = time*StudyGrp

save babybookss, replace

********************************************
********************************************

capture log close

clear

cd "D:\documents\project evaluation"

log using "Knowledge_Log", replace
set more off

use sasmerge20110805, clear

** GENERATE TIME RELATEIVE TO BABY'S DATE OF BIRTH
gen DOBMonths=(awdate-cDOB)/30.4    /* baby age in month */
replace DOBMonths=0 if WaveSort==1  /*It is prenatal period when WaveSort==1, so we assign 0 to birth date*/
gen DOBMonthsR=round(DOBMonths)     /* gen rounded baby age */
replace DOBMonthsR=0 if WaveSort==1 /* Fill in missing cDOB values from other values (within family ID) */
order WaveSort

** Generate new variables of knowledge about safety. We will use them later as outcomes
egen AWO1BPCS1=rowtotal(AWO1B02C AWO1B05C AWO1B12C AWO1B15C AWO1B16C AWO1B19C AWO1B20C AWO1B21C AWO1B26C AWO1B29C),m
replace AWO1BPCS1=AWO1BPCS1/10
label var AWO1BPCS1 "percent of correct answers among all of the questions about safety, prenatal" 

egen AWO1BPCS2=rowmean(AWO1B02C AWO1B05C AWO1B12C AWO1B15C AWO1B16C AWO1B19C AWO1B20C AWO1B21C AWO1B26C AWO1B29C)
label var AWO1BPCS2 "percent of correct answers among the questions about safety which are answered, prenatal"

egen AWO2BPCS1=rowtotal(AWO2B03C AWO2B04C AWO2B06C AWO2B07C AWO2B09C AWO2B10C AWO2B16C AWO2B21C AWO2B22C AWO2B26C AWO2B28C),m
replace AWO2BPCS1=AWO2BPCS1/11
label var AWO2BPCS1 "percent of correct answers among all of the questions about safety, 2 month old"

egen AWO2BPCS2=rowmean(AWO2B03C AWO2B04C AWO2B06C AWO2B07C AWO2B09C AWO2B10C AWO2B16C AWO2B21C AWO2B22C AWO2B26C AWO2B28C)
label var AWO2BPCS2 "percent of correct answers among the questions about safety which are answered, 2 month old"

egen AWO3BPCS1=rowtotal(AWO3B02C AWO3B03C AWO3B06C AWO3B09C AWO3B10C AWO3B12C AWO3B14C AWO3B16C AWO3B17C AWO3B18C),m
replace AWO3BPCS1=AWO3BPCS1/10
label var AWO3BPCS1 "percent of correct answers among all of the questions about safety, 4 month old"

egen AWO3BPCS2=rowmean(AWO3B02C AWO3B03C AWO3B06C AWO3B09C AWO3B10C AWO3B12C AWO3B14C AWO3B16C AWO3B17C AWO3B18C)
label var AWO3BPCS2 "percent of correct answers among the questions about safety which are answered, 4 month old"

egen AWO4BPCS1=rowtotal(AWO4B01C AWO4B02C AWO4B03C AWO4B04C AWO4B09C AWO4B10C AWO4B12C AWO4B15C AWO4B16C AWO4B18C),m
replace AWO4BPCS1=AWO4BPCS1/10
label var AWO4BPCS1 "percent of correct answers among all of the questions about safety, 6 month old"

egen AWO4BPCS2=rowmean(AWO4B01C AWO4B02C AWO4B03C AWO4B04C AWO4B09C AWO4B10C AWO4B12C AWO4B15C AWO4B16C AWO4B18C)
label var AWO4BPCS2 "percent of correct answers among the questions about safety which are answered, 6 month old"

egen AWO5BPCS1=rowtotal(AWO5B01C AWO5B02C AWO5B18C AWO5B08C AWO5B10C AWO5B11C AWO5B14C AWO5B16C),m
replace AWO5BPCS1=AWO5BPCS1/8
label var AWO5BPCS1 "percent of correct answers among all of the questions about safety, 9 month old"

egen AWO5BPCS2=rowmean(AWO5B01C AWO5B02C AWO5B18C AWO5B08C AWO5B10C AWO5B11C AWO5B14C AWO5B16C)
label var AWO5BPCS2 "percent of correct answers among the questions about safety which are answered, 9 month old"

egen AWO6BPCS1=rowtotal(AWO6B06C AWO6B08C AWO6B12C AWO6B13C),m
replace AWO6BPCS1=AWO6BPCS1/4
label var AWO6BPCS1 "percent of correct answers among all of the questions about safety, 12 month old"

egen AWO6BPCS2=rowmean(AWO6B06C AWO6B08C AWO6B12C AWO6B13C)
label var AWO6BPCS2 "percent of correct answers among the questions about safety which are answered, 12 month old"

egen AWO7BPCS1=rowtotal(AWO7B01C AWO7B10C AWO7B13C),m
replace AWO7BPCS1=AWO7BPCS1/3
label var AWO7BPCS1 "percent of correct answers among all of the questions about safety, 18 month old"

egen AWO7BPCS2=rowmean(AWO7B01C AWO7B10C AWO7B13C)
label var AWO7BPCS2 "percent of correct answers among the questions about safety which are answered, 18 month old"

forvalues i=1(1)7{

replace AWO`i'BPCS1=AWO`i'BPCS1*100   /*transfer the newly generated variables above into the format of percentage point*/
*label var AWO`i'BPCS1 "O`i'B % correct, based on safety, total"
replace AWO`i'BPCS2=AWO`i'BPCS2*100
*label var AWO`i'BPCS2 "O`i'B % correct, based on safety, answered"

}

*DOBMonthsR==0
*DOBMonthsR==2
*DOBMonthsR==4
*DOBMonthsR==6
*DOBMonthsR==9
*DOBMonthsR==12
*DOBMonthsR==18

** Generate Pannel (Safety) Knoledge Variables
gen PannelSafetyKnoledgeAll = .
replace PannelSafetyKnoledgeAll = AWO1BPCS1 if WaveSort >= 1 & WaveSort < 2
replace PannelSafetyKnoledgeAll = AWO2BPCS1 if WaveSort >= 2 & WaveSort < 3
replace PannelSafetyKnoledgeAll = AWO3BPCS1 if WaveSort >= 3 & WaveSort < 4
replace PannelSafetyKnoledgeAll = AWO4BPCS1 if WaveSort >= 4 & WaveSort < 5
replace PannelSafetyKnoledgeAll = AWO5BPCS1 if WaveSort >= 5 & WaveSort < 6
replace PannelSafetyKnoledgeAll = AWO6BPCS1 if WaveSort >= 6 & WaveSort < 7
replace PannelSafetyKnoledgeAll = AWO7BPCS1 if WaveSort >= 7 & WaveSort < 8

gen PannelSafetyKnoledgeAnswered = .
replace PannelSafetyKnoledgeAnswered = AWO1BPCS2 if WaveSort >= 1 & WaveSort < 2
replace PannelSafetyKnoledgeAnswered = AWO2BPCS2 if WaveSort >= 2 & WaveSort < 3
replace PannelSafetyKnoledgeAnswered = AWO3BPCS2 if WaveSort >= 3 & WaveSort < 4
replace PannelSafetyKnoledgeAnswered = AWO4BPCS2 if WaveSort >= 4 & WaveSort < 5
replace PannelSafetyKnoledgeAnswered = AWO5BPCS2 if WaveSort >= 5 & WaveSort < 6
replace PannelSafetyKnoledgeAnswered = AWO6BPCS2 if WaveSort >= 6 & WaveSort < 7
replace PannelSafetyKnoledgeAnswered = AWO7BPCS2 if WaveSort >= 7 & WaveSort < 8
                                                                           
** Generate new variables of knowledge about parenting. We will also use them as outcomes
egen AWO1BPCP1=rowtotal(AWO1B03C),m
replace AWO1BPCP1=AWO1BPCP1/1
label var AWO1BPCP1 "percent of correct answers among all of the questions about parenting, prenatal" 

egen AWO1BPCP2=rowmean(AWO1B03C)
label var AWO1BPCP2 "percent of correct answers among the questions about parenting which are answered, prenatal"


egen AWO2BPCP1=rowtotal(AWO2B08C AWO2B12C),m
replace AWO2BPCP1=AWO2BPCP1/2
label var AWO2BPCP1 "percent of correct answers among all of the questions about parenting, 2 month old"

egen AWO2BPCP2=rowmean(AWO2B08C AWO2B12C)
label var AWO2BPCP2 "percent of correct answers among the questions about parenting which are answered, 2 month old"

* we do not have parenting outcomes at 4 and 6 month old

egen AWO5BPCP1=rowtotal(AWO5B04C AWO5B06C),m
replace AWO5BPCP1=AWO5BPCP1/2
label var AWO5BPCP1 "percent of correct answers among all of the questions about parenting, 9 month old"

egen AWO5BPCP2=rowmean(AWO5B04C AWO5B06C)
label var AWO5BPCP2 "percent of correct answers among the questions about parenting which are answered, 9 month old"

egen AWO6BPCP1=rowtotal(AWO6B01C AWO6B04C AWO6B10C AWO6B11C AWO6B17C),m
replace AWO6BPCP1=AWO6BPCP1/5
label var AWO6BPCP1 "percent of correct answers among all of the questions about parenting, 12 month old"

egen AWO6BPCP2=rowmean(AWO6B01C AWO6B04C AWO6B10C AWO6B11C AWO6B17C)
label var AWO6BPCP2 "percent of correct answers among the questions about parenting which are answered, 12 month old"

egen AWO7BPCP1=rowtotal(AWO7B03C AWO7B04C AWO7B05C AWO7B07C),m
replace AWO7BPCP1=AWO7BPCP1/4
label var AWO7BPCP1 "percent of correct answers among all of the questions about parenting, 18 month old"

egen AWO7BPCP2=rowmean(AWO7B03C AWO7B04C AWO7B05C AWO7B07C)
label var AWO7BPCP2 "percent of correct answers among the questions about parenting which are answered, 18 month old"

local num "1 2 5 6 7"

foreach i of local num{

replace AWO`i'BPCP1=AWO`i'BPCP1*100   /*transfer the newly generated variables above into the format of percentage point*/
*label var AWO`i'BPCS1 "O`i'B % correct, based on safety, total"
replace AWO`i'BPCP2=AWO`i'BPCP2*100
*label var AWO`i'BPCS2 "O`i'B % correct, based on safety, answered"

}

** Generate Pannel (Parenting) Knoledge Variables
gen PannelParentingKnoledgeAll = .
replace PannelParentingKnoledgeAll = AWO1BPCP1 if WaveSort >= 1 & WaveSort < 2
replace PannelParentingKnoledgeAll = AWO2BPCP1 if WaveSort >= 2 & WaveSort < 3
*replace PannelParentingKnoledgeAll = AWO3BPCP1 if WaveSort >= 3 & WaveSort < 4
*replace PannelParentingKnoledgeAll = AWO4BPCP1 if WaveSort >= 4 & WaveSort < 5
replace PannelParentingKnoledgeAll = AWO5BPCP1 if WaveSort >= 5 & WaveSort < 6
replace PannelParentingKnoledgeAll = AWO6BPCP1 if WaveSort >= 6 & WaveSort < 7
replace PannelParentingKnoledgeAll = AWO7BPCP1 if WaveSort >= 7 & WaveSort < 8
                                                                         
gen PannelParentingKnoledgeAnswered = .
replace PannelParentingKnoledgeAnswered = AWO1BPCP2 if WaveSort >= 1 & WaveSort < 2
replace PannelParentingKnoledgeAnswered = AWO2BPCP2 if WaveSort >= 2 & WaveSort < 3
*replace PannelParentingKnoledgeAnswered = AWO3BPCP2 if WaveSort >= 3 & WaveSort < 4
*replace PannelParentingKnoledgeAnswered = AWO4BPCP2 if WaveSort >= 4 & WaveSort < 5
replace PannelParentingKnoledgeAnswered = AWO5BPCP2 if WaveSort >= 5 & WaveSort < 6
replace PannelParentingKnoledgeAnswered = AWO6BPCP2 if WaveSort >= 6 & WaveSort < 7
replace PannelParentingKnoledgeAnswered = AWO7BPCP2 if WaveSort >= 7 & WaveSort < 8
                                                                              
keep AWFamID WaveSort DOBMonths DOBMonthsR PannelSafetyKnoledgeAll PannelSafetyKnoledgeAnswered PannelParentingKnoledgeAll PannelParentingKnoledgeAnswered AWO1BPCS1 AWO2BPCS1 AWO3BPCS1 AWO4BPCS1 AWO5BPCS1 AWO6BPCS1 AWO7BPCS1 AWO1BPCS2 AWO2BPCS2 AWO3BPCS2 AWO4BPCS2 AWO5BPCS2 AWO6BPCS2 AWO7BPCS2 AWO1BPCP1 AWO2BPCP1 AWO5BPCP1 AWO6BPCP1 AWO7BPCP1 AWO1BPCP2 AWO2BPCP2 AWO5BPCP2 AWO6BPCP2 AWO7BPCP2
keep AWFamID WaveSort DOBMonths DOBMonthsR PannelSafetyKnoledgeAll PannelSafetyKnoledgeAnswered PannelParentingKnoledgeAll PannelParentingKnoledgeAnswered

collapse (mean)PannelSafetyKnoledgeAll PannelParentingKnoledgeAll, by(AWFamID DOBMonthsR)

*add here a collapse command similar to the one we had in the do file, getting rid of repeated times x id so you will collapse by famid and dobmonthsr

save Pannel_Knoledge_Data_V1, replace

log close



use Pannel_Knoledge_Data_V1.dta
sort AWFamID DOBMonthsR
merge m:m  AWFamID using "D:\documents\project evaluation\babybookss.dta"

save knowledge, replace







*************************************************************************
*************************************************************************



save babybook1, replace


//ITT with merged group
xtreg Other_Injury time StudyGrp time_tx
xtreg Other_Injury time employment publicass findepend StudyGrp time_tx



*creating time on semesters
gen semester=0
replace semester=1 if DOBMonthsR>0 & DOBMonthsR<=6
replace semester=2 if DOBMonthsR>6 & DOBMonthsR<=12
replace semester=3 if DOBMonthsR>12 & DOBMonthsR<=19

order AWFamID semester
xtset AWFamID semester

tabulate StudyGrp, gen(grp)

collapse (mean)DOBMonthsR (mean)PannelSafetyKnoledgeAll (sum)Other_Injury (mean)employment (mean)publicass (mean)findepend grp1 grp2 grp3 (mean)StudyGrp, by(AWFamID semester)



//ITT with original group
xtset AWFamID semester
xtreg Other_Injury semester grp1 grp2,re robust

*safety knowledge ==> measuring how safety knowledge changes by group
xtreg PannelSafetyKnoledgeAll semester grp1 grp2,re robust

xtpoisson Other_Injury semester grp1 grp2,re 

//TOT
xtreg Other_Injury semester PannelSafetyKnoledgeAll,re robust
xtpoisson Other_Injury semester PannelSafetyKnoledgeAll,re 
xtpoisson Other_Injury semester PannelSafetyKnoledgeAll grp1 safetyknowgr1,re 

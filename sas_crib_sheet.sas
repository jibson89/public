/*Create library*/
libname mylib 'C:files\project';


/* Import */
data mylib.weightgain;
  input id$4 source$8 type$8 weighg 8 bday MMDDYY10.;
  infile "C:\Documents\weightgain.csv" DSD MISSOVER FIRSTOBS=2;
  input id$ source$ type$ weighg bday date11.;
  format bday date9.;
run;

/* infile "C:\Documents\weightgain.txt" DLM="|" DSD MISSOVER FIRSTOBS=2;  */

/*Data exploration- get columns, column types*/
proc contents data=test; run;

/*Select columns*/
data test2 (keep=id);
  set test (keep = id salary);
run;

/*Rename*/
data test2;
  set test (rename=(type=newtype));
run;


/*Filter*/
data test2;
  set test (where=(spend > 10000  ));
  if weightg <10;
run;

/*if then*/
data sales2;
  set sales;
  length fired$3 performance$6;
  fired='';
  if sales<50 then fired = 'Yep';

  performance ='';
  if sales <100 then performance= 'low';
  else if sales<150 then performance= 'medium';
  else performance ='high';

run;

/*Sort*/
proc sort data=test out=test2;
  by DESC name;
run;

/*Merge*/
data new;
  merge old1 old2;
  by name;
run;

/*Proc freq gives frequency, get a separate table for each table*/
proc freq data =test;
  table type price;
run;


/*Count by variable (needs to be sorted by gender before)*/
data test2;
  set test;
  count = count+1;
  by gender;
  if first.gender then count=1;
run;

/*Trim compress
compress by default removes all spaces
first argument after column is characters to remove, second says remove spaces */
newcol= compress(phonen, '(-)','s')

/* Put and input
input converts char to num
put num to character
*/
numsale=input(sale, comma9.); /*comma9 is to say currnt string format has commas in*/
charsale=put(sale,7.); /*comnvert numeric to character, then informat to read number*/

/*Concatenate strings- catx also removes trailing spaces*/
/*separator, then things to join*/
result= catx(',',firstname,lastname)

/*Scan- get first word of a string (or nth)*/
first=scan(string,1)

/*Coalesce- return first non missing value*/
numavailable=coalesce(home_phone,cell_phone);

/*Verify-check a variable to see if valid*/
/*in this case if error then output to error dataset
the true is the faild to verify, just to be confusing */
data errors valid;
   set test_old;
   if verify(stage,'abcd') then output errors;
    else output valid;
run;

/*Substr substring*/
newstring= substr(source,position,n)
newstring= substr(oldstring,3,5)
/*Can also do left side strign function and rpelace part of string */
substr(oldstring,6,2)='16';

/*Scatter plot*/
proc gplot data=houseprices;
TITLE = 'Price and tax by home type';
format price dollar9.;
  sumbol1 value=dot cv=blue;
  symbol2 value=square cv=red;
  /*plot p[rice and tax, group by type]*/
  plot price*tax = type;
Run;

/*Bar chart */
proc gchart data=houseprices;
  title "Price and tax by type of home";
  format tprtice dollar9.;
  vbar price tax/ group=type;
  pattern color='yellow'
run;

/*ttest- see if two groups are different- numerical */
proc ttest data=qualityiflife;
  TITLE "impact of wealth on Quality life";
  CLASS  wealth  /*independent variable*/
  var quality_life
run;

/*Chi-square- categorical difference, e.g. does  yes/no answering differ by group? */
/*example table of gender, political party, number of people*/
proc freq data=political_affiliation;
  TABLES gender*party /chisq;
  weight counts;
run;

/*Correlatio matrix*/
proc corr data=dataset;
var x y z; run;

/*linear regression*/
proc reg data=dataset;
  MODEL y=z;
run;

/*Multiple regression */
proc reg data=dataset;
  MODEL y= x z;
run;

/*Macros*/
%let newv= tax;

proc means data=homes;
  var &newv.;
run;

%macro newstats(nvar);
  proc means data=homes;
    var &nvar. ;
  run;
%mend;

/*make macro variable with symput durign data steps*/
call symput(macro_variable, text)

/*use proc sql to create macro variables*/
proc sql noprint;
select max(year) ,min(year)
      into:year_max, year_min
from dates;
quit;
/*create a delimited list of macro variables */
proc sql noprint;
select column 1 into:macro_variable
separated by ','
from TABLE;
quit;

/*Conditional flow with macro variables */
%macro check(macvar);
   %if macvar= 4 %THEN %DO;
   %END;
   %ELSE %DO;
   %END;
 %mend check;

/*Do loop*/
%macro looper(first=1,last=5);
%local month
  %do month=&first. to %last.;
  %end;
%mend;


/*Export to CSV*/
proc export data=libname.data (where=(sex='F'))
   outfile='c:\myfiles\Femalelist.csv'
   dbms=csv
   replace;
run;

/*Proc summary */
* This section produces summary statistics for each species across all samples;
proc sort; by species_code; run;

proc summary;
by species_code;
var length;
output out=summary1 mean=mean_len n=n var=var_len std=std_len stderr=se_len min=min_len max=max_len
                range=range_len cv=cv_len sum=sum_len median=med_len;
run;


/*PROC UNIVARIATE*/
/*proc means is a crap version of univariate*/
proc univariate data = sashelp.shoes;
var sales;
class region;
run;

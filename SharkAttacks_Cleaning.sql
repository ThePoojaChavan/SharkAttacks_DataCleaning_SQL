/****** Script for SelectTopNRows command from SSMS  ******/

-- A very messy dataset with whole lot of cleaning and wrangling to be done

SELECT * 
FROM dbo.attacks

  SELECT * 
  FROM dbo.attacks
  where [Date] is null
  or
  [Case Number] is null

 --Deleting all rows that contain nulls in any of the columns (exception is 'Species' column which we will deal at a later stage)
  delete from dbo.attacks
  where [Date] is null
  or
  [Case Number] is null
  or
 [Type] is null
  or
  [Activity] is null
  or 
  [Age] is null
  or
  [Time] is null
  or
  [Location] is null
  or
  [Name] is null
  or
  [Area] is null
  or
  [Injury] is null

 commit;

 --We have 79 rows with Type as 'Invalid'
 select  * from dbo.attacks
 where Type='Invalid'

 --6 types of Shark Attacks, two are similar i.e. Boat and Boating likely refer to same type. We will update Boat with Boating
select  distinct [Type] from dbo.attacks

update dbo.attacks
set [Type]='Boating'
where [Type]='Boat'

commit;
 
 -- There are 391 rows of different activities listed, many are similar or fall in same bucket , example 18 rows contain data starting from 'Fishing'
 select  distinct [Activity] from dbo.attacks

  select  distinct [Activity] from dbo.attacks
  where [Activity]  like 'Fishing%'

SELECT distinct [Fatal (Y/N)]
FROM dbo.attacks

select * from 
dbo.attacks

--Quite a few rows (127) contain gender in the 'Name' column
select distinct([Name]) from 
dbo.attacks

select [Name] from 
dbo.attacks
where [Name] in ('male','female','boy','girl')

--Comparing the gender vales in Name column with Gender column to see if they are same. Except one row which has 'male' in Name column and female in Sex colum, all other 
--values are consistent in both columns
select [name],[Sex]
from dbo.attacks
where [Name] in ('male','female','boy','girl')
order by [sex]

--We will therefore replace gender values in Name column by Unknown
update dbo.attacks
set [Name]='Unknown'
 where [Name] in ('male','female','boy','girl')

 commit;

--removing spaces from column 'Name'
select trim([Name]) from 
dbo.attacks

update dbo.attacks
set [Name]=trim([Name])

commit;

--Quite a few values (675) of Species' column contain null/ blanks, replacing them with 'Unknown'
select  [Species] 
from dbo.attacks
where [Species]  =' '
or [Species]  is null

update dbo.attacks
set [Species]  ='Unknown'
where  [Species]  =' '
or [Species]  is null

select  [Species] 
from dbo.attacks

-- Injury column has FATAL as a value, updating to Fatal
select distinct [Injury] 
from dbo.attacks

update dbo.attacks
set [Injury]='Fatal'
where [Injury]='FATAL'

commit;

select * from dbo.attacks;

--extract Year from Date column

select year([Date]) from dbo.attacks
order by year([Date])

select * from dbo.attacks

--Wrangling Country column, changing values from Upper to Proper Case
select concat(upper(SUBSTRING([Country],1,1))   , lower(SUBSTRING([Country],2,len([Country])))) as "Country Proper Case" from dbo.attacks

update dbo.attacks
set Country=(concat(upper(SUBSTRING([Country],1,1))   , lower(SUBSTRING([Country],2,len([Country])))))

commit

--Renaming column Sex to Gender
sp_rename 'dbo.attacks.Sex','Gender','COLUMN'

--Renaming column Fatal (Y/N) to Fatal
sp_rename 'dbo.attacks.Fatal (Y/N)','Fatal','COLUMN'

--Wrangling the Time column
select trim([time])
from dbo.attacks;

select Time, SUBSTRING([Time],1,2),
case 
	 when SUBSTRING([Time],1,2)<'04' then 'Pre-dawn' 
	 when SUBSTRING([Time],1,2)>='04' and SUBSTRING([Time],1,2) <'07'   then 'Early Morning' 
	 when (SUBSTRING([Time],1,2)>='07' or SUBSTRING([Time],1,1)>='7' ) and SUBSTRING([Time],1,2) <'10'   then 'Morning' 
	 when SUBSTRING([Time],1,2)>='10' and SUBSTRING([Time],1,2) <'12'   then 'Early Noon' 
	 when SUBSTRING([Time],1,2)>='12' and SUBSTRING([Time],1,2) <'13'   then 'Noon' 
	 when SUBSTRING([Time],1,2)>='13' and SUBSTRING([Time],1,2) <'15'   then 'Afternoon' 
	 when SUBSTRING([Time],1,2)>='15' and SUBSTRING([Time],1,2) <'16'   then 'Early Evening' 
	 when SUBSTRING([Time],1,2)>='16' and SUBSTRING([Time],1,2) <'18'   then 'Evening'
	 when SUBSTRING([Time],1,2)>='18' and SUBSTRING([Time],1,2) <'20'   then 'Late Evening'
	 when SUBSTRING([Time],1,2)>='20' and SUBSTRING([Time],1,2) <'22'   then 'Night'
	 --when SUBSTRING([Time],1,2)>'22' then 'Late Night'
else [Time] 
end as Attack_Time
from dbo.attacks
order by Attack_Time

update dbo.attacks
set [Time]= (case 
	 when SUBSTRING([Time],1,2)<'04' then 'Pre-dawn' 
	 when SUBSTRING([Time],1,2)>='04' and SUBSTRING([Time],1,2) <'07'   then 'Early Morning' 
	 when (SUBSTRING([Time],1,2)>='07' or SUBSTRING([Time],1,1)>='7' ) and SUBSTRING([Time],1,2) <'10'   then 'Morning' 
	 when SUBSTRING([Time],1,2)>='10' and SUBSTRING([Time],1,2) <'12'   then 'Early Noon' 
	 when SUBSTRING([Time],1,2)>='12' and SUBSTRING([Time],1,2) <'13'   then 'Noon' 
	 when SUBSTRING([Time],1,2)>='13' and SUBSTRING([Time],1,2) <'15'   then 'Afternoon' 
	 when SUBSTRING([Time],1,2)>='15' and SUBSTRING([Time],1,2) <'16'   then 'Early Evening' 
	 when SUBSTRING([Time],1,2)>='16' and SUBSTRING([Time],1,2) <'18'   then 'Evening'
	 when SUBSTRING([Time],1,2)>='18' and SUBSTRING([Time],1,2) <'20'   then 'Late Evening'
	 when SUBSTRING([Time],1,2)>='20' and SUBSTRING([Time],1,2) <'22'   then 'Night'
else [Time] 
end )

commit;

select * from dbo.attacks;

--Still, few values in Time column need to be formatted for accurate EDA like P.M., Prior to.., Sunset, etc. 
select [Time] from dbo.attacks
order by [Time]

--renaming Time colum  to Attack Time
sp_rename 'dbo.attacks.Time','Attack Time','COLUMN'

select *  from dbo.attacks

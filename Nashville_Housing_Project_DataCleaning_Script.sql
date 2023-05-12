select * from ..Nashvill	e_Housing

--Populate Property Adress data

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress --,ISNULL(a.PropertyAddress,b.PropertyAddress)
from ..Nashville_Housing a 
join ..Nashville_Housing b ON a.ParcelID=b.ParcelID and a.UniqueID != b. UniqueID
--where a.PropertyAddress is NULL


update a set a.PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
from ..Nashville_Housing a 
join ..Nashville_Housing b ON a.ParcelID=b.ParcelID and a.UniqueID != b. UniqueID
where a.PropertyAddress is NULL

-- Breaking out Adress into Individual columns (Address, city, state)

select PropertyAddress,SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,


SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as City
from ..Nashville_Housing 

Alter table ..Nashville_Housing Add PropertySplitAdress nVARCHAR(MAX)
Alter table ..Nashville_Housing Add PropertySplitCity nVARCHAR(MAX)

update ..Nashville_Housing set PropertySplitAdress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) ,
PropertySplitCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) 
from ..Nashville_Housing 

select PropertyAddress,SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as City, PropertySplitAdress,PropertySplitCity
from ..Nashville_Housing 


select OwnerAddress,PARSENAME(REPLACE (OwnerAddress,',','.'),3),
PARSENAME(REPLACE (OwnerAddress,',','.'),2),
PARSENAME(REPLACE (OwnerAddress,',','.'),1)
from ..Nashville_Housing 

Alter table ..Nashville_Housing Add OwnerSplitAdress nVARCHAR(MAX)
Alter table ..Nashville_Housing Add OwnerSplitCity nVARCHAR(MAX)
Alter table ..Nashville_Housing Add OwnerSplitState nVARCHAR(MAX)

update ..Nashville_Housing set OwnerSplitAdress=PARSENAME(REPLACE (OwnerAddress,',','.'),3) ,
OwnerSplitCity=PARSENAME(REPLACE (OwnerAddress,',','.'),2) ,
OwnerSplitState = PARSENAME(REPLACE (OwnerAddress,',','.'),1)
from ..Nashville_Housing 

-- Change Y and N and Yes and No

select DISTINCT SoldAsVacant, count(*)
from ..Nashville_Housing
group by SoldAsVacant

select  SoldAsVacant, 
case when SoldAsVacant = 'Y' then 'Yes' else case when SoldAsVacant ='N' then 'No' else SoldAsVacant end  end
from ..Nashville_Housing
order by SoldAsVacant

update ..Nashville_Housing set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes' else case when SoldAsVacant ='N' then 'No' else SoldAsVacant end end 

-- Remove duplicates
with rn as (
select *,ROW_NUMBER() over (Partition by ParcelID,PropertyAddress,SaleDate,SalePrice,LegalReference order by UniqueID) as rw_num 
from ..Nashville_Housing )
select * from rn
where rw_num>1
order by 2

with rn as (
select *,ROW_NUMBER() over (Partition by ParcelID,PropertyAddress,SaleDate,SalePrice,LegalReference order by UniqueID) as rw_num 
from ..Nashville_Housing )
delete from rn
where rw_num>1

-- Delete unused Columns

select * from ..Nashville_Housing

ALTER TABLE ..Nashville_Housing DROP COLUMN [TaxDistrict]








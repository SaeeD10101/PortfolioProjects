select *
from NashVillehousing
-----------------------------

--Standrdize Date Format  
Select SalesDateConverted , Convert (date , SaleDate)
from NashVillehousing
 


Alter Table NashvilleHousing 
add SalesDateConverted Date;

update NashVillehousing
Set SalesDateConverted = convert (date , SaleDate)


--------------------------------------
-- Populate  Properity Address Date 

select *
from NashVillehousing
--where PropertyAddress is null
order by ParcelID


select a.ParcelID , a.PropertyAddress , b.ParcelID , b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress) 
from NashVillehousing a
join NashVillehousing  b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashVillehousing a
join NashVillehousing  b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


---------------------------------------------------------------------
--Braking out Address into Individual Colums (Address , City , State )


select PropertyAddress
from NashVillehousing

-------- 
select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address ,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1 , len(PropertyAddress)) as Address 

from NashVillehousing

alter table NashVillehousing
add ProperitySplitAddress nvarchar(255)

update NashVillehousing
Set ProperitySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

alter table NashVillehousing
add ProperitySplitCity nvarchar(255)

update NashVillehousing
Set ProperitySplitCity =SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1 , len(PropertyAddress))

select ProperitySplitAddress , ProperitySplitCity
from NashVillehousing


----------------------------------------------------------
 
select OwnerAddress
from NashVillehousing 
------------------
-- Spliting The Owner`s Addresses
select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from NashVillehousing

-------- Updating The tabele wiht the new coulmns 


alter table NashVillehousing
add OwnerSplitAddress nvarchar(255);

update NashVillehousing
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)


alter table NashVillehousing
add  OwnerSplitCity nvarchar(255);

update NashVillehousing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)



alter table NashVillehousing
add OwnerSplitState nvarchar(255);

update NashVillehousing
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

 --Finished 
---------------------------------------

 -- Change the Y and N to Yes and No in " Sold as Vcent  " filed 

select Distinct (SoldAsVacant) , count (SoldAsVacant)
from NashVillehousing 
 group by SoldAsVacant 
 order by 2 

 -----------------
 select SoldAsVacant ,
 Case When SoldAsVacant = 'Y' Then 'Yes' 
 When SoldAsVacant = 'N' Then 'No'
 Else SoldAsVacant
    end
 from NashVillehousing


 update NashVillehousing

 Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes' 
 When SoldAsVacant = 'N' Then 'No'
 Else SoldAsVacant
    end
 


 ----------------------------------------------------------------------------


 -- Remove Duplicates 

With RowNumCTE AS(
select * ,
row_number() over (
partition by ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			order by 
			UniqueID
			) row_num 
  
  from NashVillehousing

)





select *
 from RowNumCTE
 Where row_num > 1
 




 ----------------------------------------------
 -- Delete Unused Columns 


 select *
 from NashVillehousing


 alter table NashVillehousing
 drop column OwnerAddress, TaxDistrict , PropertyAddress

 
 alter table NashVillehousing
 drop column SaleDate



 -------------------------------------------------------------




  












 
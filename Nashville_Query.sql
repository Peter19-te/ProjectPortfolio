--SQL Data cleaning
select *
from PeterPortfolio..Nashville


--Standardize SaleDate 
select SaleDate2, CONVERT(date, SaleDate)
from PeterPortfolio.dbo.Nashville

Update Nashville
SET SaleDate = CONVERT(date,SaleDate)

ALTER TABLE Nashville
Add SaleDate2 date;

Update Nashville
SET SaleDate2 = CONVERT(date,SaleDate)

--Populate property address data
select PropertyAddress
from PeterPortfolio..Nashville

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PeterPortfolio.dbo.Nashville a
JOIN PeterPortfolio.dbo.Nashville b
   on a.ParcelID = b.ParcelID
   and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
SET PropertyAddress  = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PeterPortfolio.dbo.Nashville a
JOIN PeterPortfolio.dbo.Nashville b
   on a.ParcelID = b.ParcelID
   and a.[UniqueID ] <> b.[UniqueID ]
--where a.PropertyAddress is null

--Breaking Address into seperate columns
select * --PropertyAddress
from PeterPortfolio..Nashville

select SUBSTRING(PropertyAddress, 1, Charindex(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, Charindex(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
from PeterPortfolio..Nashville

ALTER TABLE Nashville
Add HomeAddress nvarchar(255);

Update Nashville
SET HomeAddress = SUBSTRING(PropertyAddress, 1, Charindex(',', PropertyAddress) -1)

ALTER TABLE Nashville
Add CityAddress nvarchar(255);

Update Nashville
SET CityAddress = SUBSTRING(PropertyAddress, Charindex(',', PropertyAddress) +1, LEN(PropertyAddress))

--Seperating OwnerAddress column
select
PARSENAME(REPLACE (OwnerAddress,',','.'),  3),
PARSENAME(REPLACE (OwnerAddress,',','.'),  2),
PARSENAME(REPLACE (OwnerAddress,',','.'),  1)
from PeterPortfolio.dbo.Nashville

ALTER TABLE Nashville
Add OwnerhomeAddress nvarchar(255);

Update Nashville 
SET OwnerhomeAddress = PARSENAME(REPLACE (OwnerAddress,',','.'),  3)

ALTER TABLE Nashville
Add OwnerCityAddress nvarchar(255);

Update Nashville
SET OwnerCityAddress = PARSENAME(REPLACE (OwnerAddress,',','.'),  2)

ALTER TABLE Nashville
Add OwnerStateAddress nvarchar(255);

Update Nashville
SET OwnerStateAddress = PARSENAME(REPLACE (OwnerAddress,',','.'),  1)


--Changing Y and N to Yes and No in SoldAsVacant column
Select distinct(SoldAsVacant), COUNT(SoldAsVacant)
from PeterPortfolio.dbo.Nashville
Group by SoldAsVacant
Order by 2

select SoldAsVacant
, CASE When SoldAsVacant = 'Y' then 'Yes'
	   When SoldAsVacant = 'N' then 'No'
	   Else SoldAsVacant
	   End
from PeterPortfolio.dbo.Nashville

Update Nashville
SET SoldAsVacant =  CASE When SoldAsVacant = 'Y' then 'Yes'
	   When SoldAsVacant = 'N' then 'No'
	   Else SoldAsVacant
	   End

--Deleting Unused Columns
ALTER TABLE Nashville
DROP COLUMN PropertyAddress, SaleDate, OwnerAddress
 

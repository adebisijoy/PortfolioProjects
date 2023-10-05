SELECT *
FROM [Portfolio Project].dbo.NashvilleHousing;

SELECT SaleDate
FROM [Portfolio Project].dbo.NashvilleHousing;

SELECT SaleDateConverted, CONVERT(DATE, SaleDate)
FROM [Portfolio Project].dbo.NashvilleHousing;

ALTER TABLE NashvilleHousing
ADD SaleDateConverted DATE;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(DATE, SaleDate);


SELECT PropertyAddress
FROM [Portfolio Project].dbo.NashvilleHousing
WHERE PropertyAddress IS NULL;

SELECT *
FROM [Portfolio Project].dbo.NashvilleHousing
-- WHERE PropertyAddress IS NULL
ORDER BY ParcelID;

SELECT Nash.ParcelID, Nash.PropertyAddress, NH.ParcelID, NH.PropertyAddress, ISNULL(Nash.PropertyAddress, NH.PropertyAddress)
FROM [Portfolio Project].dbo.NashvilleHousing Nash
JOIN [Portfolio Project].dbo.NashvilleHousing NH
	ON Nash.ParcelID = NH.ParcelID
	AND Nash.[UniqueID ] <> NH.[UniqueID ]
WHERE Nash.PropertyAddress IS NULL;

UPDATE Nash
SET PropertyAddress = ISNULL(Nash.PropertyAddress, NH.PropertyAddress)
FROM [Portfolio Project].dbo.NashvilleHousing Nash
JOIN [Portfolio Project].dbo.NashvilleHousing NH
	ON Nash.ParcelID = NH.ParcelID
	AND Nash.[UniqueID ] <> NH.[UniqueID ]
WHERE Nash.PropertyAddress IS NULL;

SELECT PropertyAddress, 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS Address
FROM [Portfolio Project].dbo.NashvilleHousing;

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1);

ALTER TABLE NashvilleHousing
ADD PropertySplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress));

SELECT *
FROM [Portfolio Project].dbo.NashvilleHousing;

SELECT PARSENAME(OwnerAddress, 1)
FROM [Portfolio Project].dbo.NashvilleHousing;

SELECT PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
FROM [Portfolio Project].dbo.NashvilleHousing;

SELECT PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM [Portfolio Project].dbo.NashvilleHousing;

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) 

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);

SELECT DISTINCT SoldAsVacant, COUNT(SoldAsVacant)
FROM [Portfolio Project].dbo.NashvilleHousing
GROUP BY SoldAsVacant;

SELECT SoldAsVacant,
  CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
       WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM [Portfolio Project].dbo.NashvilleHousing;

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
					    WHEN SoldAsVacant = 'N' THEN 'No'
						ELSE SoldAsVacant
						END

WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID, 
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
				   UniqueID
				   ) AS row_num
FROM [Portfolio Project].dbo.NashvilleHousing
)
SELECT * 
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress;

WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID, 
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
				   UniqueID
				   ) AS row_num
FROM [Portfolio Project].dbo.NashvilleHousing
)
DELETE FROM RowNumCTE
WHERE row_num > 1

SELECT *
FROM [Portfolio Project].dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN PropertyAddress;

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, SaleDate;
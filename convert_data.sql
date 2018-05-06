---------Zmien wartosci kolumny adres z tabeli data, tak aby pozosta³a tylko nazwa ulicy-------------
UPDATE data SET adres = REPLACE(adres, '0', '' );
UPDATE data SET adres = REPLACE(adres, '1', '' );
UPDATE data SET adres = REPLACE(adres, '2', '' );
UPDATE data SET adres = REPLACE(adres, '3', '' );
UPDATE data SET adres = REPLACE(adres, '4', '' );
UPDATE data SET adres = REPLACE(adres, '5', '' );
UPDATE data SET adres = REPLACE(adres, '6', '' );
UPDATE data SET adres = REPLACE(adres, '7', '' );
UPDATE data SET adres = REPLACE(adres, '9', '' );
UPDATE data SET adres = REPLACE(adres, 'Street', 'St' );
UPDATE data SET adres = REPLACE(adres, '/', '' );
UPDATE data SET adres = REPLACE(adres, '#', '' );
UPDATE data SET adres = REPLACE(adres, '.', '' );
UPDATE data SET adres = REPLACE(adres, '-', '' );
UPDATE data SET adres = REPLACE(adres, '"', '' );

CREATE FUNCTION CamelCase
(@Str varchar(8000))
RETURNS varchar(8000) AS
BEGIN
  DECLARE @Result varchar(2000)
  SET @Str = LOWER(@Str) + ' '
  SET @Result = ''
  WHILE 1=1
  BEGIN
    IF PATINDEX('% %',@Str) = 0 BREAK
    SET @Result = @Result + UPPER(Left(@Str,1))+
    SubString  (@Str,2,CharIndex(' ',@Str)-1)
    SET @Str = SubString(@Str,
      CharIndex(' ',@Str)+1,Len(@Str))
  END
  SET @Result = Left(@Result,Len(@Result))
  RETURN @Result
END 

UPDATE data SET adres = dbo.CamelCase(adres) FROM data;

UPDATE data SET adres = SUBSTRING(adres, 1, CHARINDEX(' Apt', adres)) FROM data
where adres like '%Apt%';

UPDATE data SET adres = SUBSTRING(adres, 1, CHARINDEX(' Unit', adres)) FROM data
where adres like '%Unit%';

UPDATE data SET adres = SUBSTRING(adres, 1, CHARINDEX(' St', adres)) FROM data
where adres like '%St%';

UPDATE data SET adres = SUBSTRING(adres, 1, CHARINDEX(' Ave', adres)) FROM data
where adres like '%Ave%';

UPDATE data SET adres = SUBSTRING(adres, 1, CHARINDEX(' Av ', adres)) FROM data
where adres like '%Av%';

UPDATE data SET adres = RTRIM(LTRIM(adres)) FROM data;

-------Podziel kolumny data_zlozenia i data_rozpatrzenia z tabeli data na oddzielne kolumny dzien, miesiac, rok---------
ALTER TABLE data
ADD dzien_zl INT, miesiac_zl INT, rok_zl INT

ALTER TABLE data
ADD dzien_roz INT, miesiac_roz INT, rok_roz INT

UPDATE data
SET dzien_zl = DAY(data_zlozenia),
miesiac_zl = MONTH(data_zlozenia),
rok_zl = YEAR(data_zlozenia),
dzien_roz = DAY(data_rozpatrzenia),
miesiac_roz = MONTH(data_rozpatrzenia),
rok_roz = YEAR(data_rozpatrzenia)
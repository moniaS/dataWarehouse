----------Dodaj wszystkie kolumny do tabeli faktu------------
ALTER TABLE Fakt_rozpatrzenia_wniosku_o_licencje
ADD adres varchar(120),
  status varchar(10),
  rodzaj varchar(25),
  liczba_pokoi int,
  liczba_gosci int,
  dzien_roz int,
  miesiac_roz int,
  rok_roz int,
  dzien_zl int,
  miesiac_zl int,
  rok_zl int,
  nazwa char(60),
  numer char(50),
  email char(150)

---------Skopiuj dane z tabeli data do tabeli Fakt_rozpatrzenia_wniosku_o_licencje----------
INSERT INTO Fakt_rozpatrzenia_wniosku_o_licencje (adres, status, rodzaj, liczba_pokoi, liczba_gosci, dzien_roz, miesiac_roz, rok_roz, dzien_zl, miesiac_zl, rok_zl, nazwa, numer, email)
SELECT adres, status, rodzaj, liczba_pokoi, liczba_gosci, dzien_roz, miesiac_roz, rok_roz, dzien_zl, miesiac_zl, rok_zl, nazwa, numer, email FROM data

---------Wstaw dane do tabeli Wnioskodawca---------------------
INSERT INTO Wnioskodawca
    (nazwa, numer, email)
    SELECT DISTINCT nazwa, numer, email
        FROM Fakt_rozpatrzenia_wniosku_o_licencje

---------Wstaw dane do tabeli Wniosek o licencje---------------------
INSERT INTO Wniosek_o_licencje
    (rodzaj, status)
    SELECT DISTINCT rodzaj, status
        FROM Fakt_rozpatrzenia_wniosku_o_licencje

---------Wstaw dane do tabeli Nieruchomosc---------------------
INSERT INTO Nieruchomosc
    (adres, liczba_pokoi, liczba_gosci)
    SELECT DISTINCT adres, liczba_pokoi, liczba_gosci
        FROM Fakt_rozpatrzenia_wniosku_o_licencje

---------Wstaw dane do tabeli Czas---------------------
INSERT INTO Czas
    (dzien, miesiac, rok)
    SELECT dzien_zl, miesiac_zl, rok_zl FROM Fakt_rozpatrzenia_wniosku_o_licencje
		UNION
	SELECT dzien_roz, miesiac_roz, rok_roz FROM Fakt_rozpatrzenia_wniosku_o_licencje

--------Uzupe³nij klucz obcy wnioskodawca_id w tabeli faktu----------
DECLARE @WnioskodawcaKursor CURSOR;
DECLARE @FaktId INT;
DECLARE @Nazwa VARCHAR(150);
DECLARE @Email VARCHAR(150);
DECLARE @Numer VARCHAR(150);
DECLARE @WnioskodawcaId INT;
BEGIN
    SET @WnioskodawcaKursor = CURSOR FOR
    SELECT fakt_rozpatrzenia_id, nazwa, email, numer FROM Fakt_rozpatrzenia_wniosku_o_licencje;

    OPEN @WnioskodawcaKursor 
    FETCH NEXT FROM @WnioskodawcaKursor 
    INTO @FaktId, @Nazwa, @Email, @Numer

    WHILE @@FETCH_STATUS = 0
    BEGIN
     SELECT @WnioskodawcaId = wnioskodawca_id
	 FROM Wnioskodawca 
	 WHERE nazwa LIKE @Nazwa 
	 AND numer LIKE @Numer
	 AND email LIKE @Email
	 PRINT(@WnioskodawcaId)

	 UPDATE Fakt_rozpatrzenia_wniosku_o_licencje 
	 SET wnioskodawca_id = @WnioskodawcaId
	 WHERE fakt_rozpatrzenia_id = @FaktId
      
	 FETCH NEXT FROM @WnioskodawcaKursor 
     INTO @FaktId, @Nazwa, @Email, @Numer
    END; 

    CLOSE @WnioskodawcaKursor ;
    DEALLOCATE @WnioskodawcaKursor;
END;

--------Uzupe³nij klucz obcy nieruchomosc_id w tabeli faktu----------
DECLARE @NieruchomoscKursor CURSOR;
DECLARE @FaktId INT;
DECLARE @Adres VARCHAR(150);
DECLARE @LiczbaPokoi INT;
DECLARE @LiczbaGosci INT;
DECLARE @NieruchomoscId INT;
BEGIN
    SET @NieruchomoscKursor = CURSOR FOR
    SELECT fakt_rozpatrzenia_id, adres, liczba_pokoi, liczba_gosci FROM Fakt_rozpatrzenia_wniosku_o_licencje;

    OPEN @NieruchomoscKursor 
    FETCH NEXT FROM @NieruchomoscKursor 
    INTO @FaktId, @Adres, @LiczbaPokoi, @LiczbaGosci

    WHILE @@FETCH_STATUS = 0
    BEGIN
     SELECT @NieruchomoscId = nieruchomosc_id
	 FROM Nieruchomosc 
	 WHERE adres LIKE @Adres 
	 AND liczba_pokoi = @LiczbaPokoi
	 AND liczba_gosci = @LiczbaGosci

	 UPDATE Fakt_rozpatrzenia_wniosku_o_licencje 
	 SET nieruchomosc_id = @NieruchomoscId
	 WHERE fakt_rozpatrzenia_id = @FaktId
      
	 FETCH NEXT FROM @NieruchomoscKursor 
     INTO @FaktId, @Adres, @LiczbaPokoi, @LiczbaGosci
    END; 

    CLOSE @NieruchomoscKursor ;
    DEALLOCATE @NieruchomoscKursor;
END;

--------Uzupe³nij klucz obcy wniosek_o_licencje_id w tabeli faktu----------
DECLARE @WniosekKursor CURSOR;
DECLARE @FaktId INT;
DECLARE @Rodzaj VARCHAR(30);
DECLARE @Status VARCHAR(30);
DECLARE @WniosekId INT;
BEGIN
    SET @WniosekKursor = CURSOR FOR
    SELECT fakt_rozpatrzenia_id, rodzaj, status FROM Fakt_rozpatrzenia_wniosku_o_licencje;

    OPEN @WniosekKursor 
    FETCH NEXT FROM @WniosekKursor 
    INTO @FaktId, @Rodzaj, @Status

    WHILE @@FETCH_STATUS = 0
    BEGIN
     SELECT @WniosekId = wniosek_id
	 FROM Wniosek_o_licencje 
	 WHERE rodzaj = @Rodzaj 
	 AND status = @Status

	 UPDATE Fakt_rozpatrzenia_wniosku_o_licencje 
	 SET wniosek_o_licencje_id = @WniosekId
	 WHERE fakt_rozpatrzenia_id = @FaktId
      
	 FETCH NEXT FROM @WniosekKursor 
     INTO @FaktId, @Rodzaj, @Status
    END; 

    CLOSE @WniosekKursor;
    DEALLOCATE @WniosekKursor;
END;

--------Uzupe³nij klucze obce data_zlozenia_wniosku_id i data_rozpatrzenia_wniosku_id w tabeli faktu----------
DECLARE @DataKursor CURSOR;
DECLARE @FaktId INT;
DECLARE @Dzien INT;
DECLARE @Miesiac INT;
DECLARE @Rok INT;
DECLARE @DataId INT;
BEGIN
    SET @DataKursor = CURSOR FOR
    SELECT fakt_rozpatrzenia_id, dzien_zl, miesiac_zl, rok_zl FROM Fakt_rozpatrzenia_wniosku_o_licencje;

    OPEN @DataKursor 
    FETCH NEXT FROM @DataKursor 
    INTO @FaktId, @Dzien, @Miesiac, @Rok

    WHILE @@FETCH_STATUS = 0
    BEGIN
     SELECT @DataId = czas_id
	 FROM Czas 
	 WHERE dzien = @Dzien 
	 AND miesiac = @Miesiac
	 AND rok = @Rok

	 UPDATE Fakt_rozpatrzenia_wniosku_o_licencje 
	 SET data_zlozenia_wniosku_id = @DataId
	 WHERE fakt_rozpatrzenia_id = @FaktId
      
	 FETCH NEXT FROM @DataKursor 
     INTO @FaktId, @Dzien, @Miesiac, @Rok
    END; 

    CLOSE @DataKursor;
    DEALLOCATE @DataKursor;
END;

BEGIN
    SET @DataKursor = CURSOR FOR
    SELECT fakt_rozpatrzenia_id, dzien_roz, miesiac_roz, rok_roz FROM Fakt_rozpatrzenia_wniosku_o_licencje;

    OPEN @DataKursor 
    FETCH NEXT FROM @DataKursor 
    INTO @FaktId, @Dzien, @Miesiac, @Rok

    WHILE @@FETCH_STATUS = 0
    BEGIN
     SELECT @DataId = czas_id
	 FROM Czas 
	 WHERE dzien = @Dzien 
	 AND miesiac = @Miesiac
	 AND rok = @Rok

	 UPDATE Fakt_rozpatrzenia_wniosku_o_licencje 
	 SET data_rozpatrzenia_wniosku_id = @DataId
	 WHERE fakt_rozpatrzenia_id = @FaktId
      
	 FETCH NEXT FROM @DataKursor 
     INTO @FaktId, @Dzien, @Miesiac, @Rok
    END; 

    CLOSE @DataKursor;
    DEALLOCATE @DataKursor;
END;

---------------Usuniecie niepotrzebnych kolumn z tabeli faktu-----------------
ALTER TABLE Fakt_rozpatrzenia_wniosku_o_licencje
 DROP COLUMN adres, status, rodzaj, liczba_pokoi, liczba_gosci, dzien_roz, miesiac_roz, rok_roz, dzien_zl, miesiac_zl, rok_zl, nazwa, numer, email

---------------Uzupelnij miare w tabeli faktu-------------------
DECLARE @FaktKursor CURSOR;
DECLARE @FaktId INT;
DECLARE @NieruchomoscId INT;
DECLARE @CzasZlozeniaId INT;
DECLARE @CzasRozpatrzeniaId INT;
DECLARE @WniosekId INT;
DECLARE @WnioskodawcaId INT;
DECLARE @LiczbaWnioskow INT;

BEGIN
    SET @FaktKursor = CURSOR FOR
    SELECT fakt_rozpatrzenia_id FROM Fakt_rozpatrzenia_wniosku_o_licencje;

    OPEN @FaktKursor 
    FETCH NEXT FROM @FaktKursor 
    INTO @FaktId

    WHILE @@FETCH_STATUS = 0
    BEGIN
		SELECT @WniosekId = wniosek_o_licencje_id, @NieruchomoscId = nieruchomosc_id, @WnioskodawcaId = wnioskodawca_id,
		@CzasZlozeniaId = data_zlozenia_wniosku_id, @CzasRozpatrzeniaId = data_rozpatrzenia_wniosku_id FROM Fakt_rozpatrzenia_wniosku_o_licencje
		WHERE fakt_rozpatrzenia_id = @FaktId
		
		SELECT @LiczbaWnioskow = COUNT(fakt_rozpatrzenia_id) FROM Fakt_rozpatrzenia_wniosku_o_licencje
		WHERE wniosek_o_licencje_id = @WniosekId AND wnioskodawca_id = @WnioskodawcaId
		AND nieruchomosc_id = @NieruchomoscId AND data_zlozenia_wniosku_id = @CzasZlozeniaId
		AND data_rozpatrzenia_wniosku_id = @CzasRozpatrzeniaId

		DELETE FROM Fakt_rozpatrzenia_wniosku_o_licencje
		WHERE wniosek_o_licencje_id = @WniosekId AND wnioskodawca_id = @WnioskodawcaId
		AND nieruchomosc_id = @NieruchomoscId AND data_zlozenia_wniosku_id = @CzasZlozeniaId
		AND data_rozpatrzenia_wniosku_id = @CzasRozpatrzeniaId AND fakt_rozpatrzenia_id <> @FaktId

		UPDATE Fakt_rozpatrzenia_wniosku_o_licencje
		SET ilosc_wnioskow_o_licencje = @LiczbaWnioskow
		WHERE fakt_rozpatrzenia_id = @FaktId
		
		FETCH NEXT FROM @FaktKursor 
		INTO @FaktId
    END; 

    CLOSE @FaktKursor;
    DEALLOCATE @FaktKursor;
END;

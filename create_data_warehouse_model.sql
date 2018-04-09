CREATE TABLE Wnioskodawca
( wnioskodawca_id int NOT NULL,
  nazwa char(50) NOT NULL,
  numer char(50),
  email char(50),
  CONSTRAINT klucz_wnioskodawca PRIMARY KEY (wnioskodawca_id)
);

CREATE TABLE Czas
( czas_id int NOT NULL,
  dzien int,
  miesiac int,
  rok int,
  sezon char(50),
  CONSTRAINT klucz_czas PRIMARY KEY (czas_id)
);

CREATE TABLE Nieruchomosc
( nieruchomosc_id int NOT NULL,
  adres varchar(50),
  liczba_pokoi int,
  liczba_gosci int,
  CONSTRAINT klucz_nieruchomosc PRIMARY KEY (nieruchomosc_id)	
)

CREATE TABLE Licencja
( licencja_id int NOT NULL,
  status varchar(15),
  rodzaj varchar(15),
  data_zlozenia_wniosku date,
  data_przyznania_licencji date,
  nieruchomosc_id int,
  CONSTRAINT klucz_licencja PRIMARY KEY (licencja_id),
  FOREIGN KEY (nieruchomosc_id) REFERENCES Nieruchomosc(nieruchomosc_id)
);

CREATE TABLE Fakt_rozpatrzenia_licencji 
(
  wnioskodawca_id int NOT NULL REFERENCES Wnioskodawca(wnioskodawca_id),
  czas_id int NOT NULL REFERENCES Czas(czas_id),
  licencja_id int NOT NULL REFERENCES Licencja(licencja_id),
  ilosc_licencji int,
  CONSTRAINT klucz_fakt_rozpatrzenia_licencji PRIMARY KEY(wnioskodawca_id, licencja_id, czas_id)
)


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
  CONSTRAINT klucz_czas PRIMARY KEY (czas_id)
);

CREATE TABLE Nieruchomosc
( nieruchomosc_id int NOT NULL,
  adres varchar(50),
  liczba_pokoi int,
  liczba_gosci int,
  CONSTRAINT klucz_nieruchomosc PRIMARY KEY (nieruchomosc_id)	
)

CREATE TABLE Wniosek_o_licencje
( wniosek_id int NOT NULL,
  status varchar(15),
  rodzaj varchar(15),
  CONSTRAINT klucz_wniosek PRIMARY KEY (wniosek_id),
);

CREATE TABLE Fakt_rozpatrzenia_wniosku_o_licencje 
(
  fakt_rozpatrzenia_id int NOT NULL
  wnioskodawca_id int REFERENCES Wnioskodawca(wnioskodawca_id),
  wniosek_o_licencje_id int REFERENCES Wniosek_o_licencje(wniosek_id),
  data_zlozenia_wniosku date REFERENCES Czas(czas_id),
  data_rozpatrzenia_wniosku date REFERENCES Czas(czas_id),
  ilosc_wnioskow_o_licencje int,
  CONSTRAINT klucz_fakt_rozpatrzenia_licencji PRIMARY KEY(fakt_rozpatrzenia_id)
)
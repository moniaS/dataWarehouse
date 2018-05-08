CREATE TABLE Wnioskodawca
( wnioskodawca_id INT IDENTITY(1, 1),
  nazwa CHAR(60),
  numer CHAR(50),
  email CHAR(150),
  CONSTRAINT klucz_wnioskodawca PRIMARY KEY (wnioskodawca_id)
);

CREATE TABLE Czas
( czas_id INT IDENTITY(1, 1),
  dzien INT,
  miesiac INT,
  rok INT,
  CONSTRAINT klucz_czas PRIMARY KEY (czas_id)
);

CREATE TABLE Nieruchomosc
( nieruchomosc_id INT IDENTITY(1, 1),
  adres VARCHAR(120),
  liczba_pokoi INT,
  liczba_gosci INT,
  CONSTRAINT klucz_nieruchomosc PRIMARY KEY (nieruchomosc_id)	
)

CREATE TABLE Wniosek_o_licencje
( wniosek_id INT IDENTITY(1, 1),
  status VARCHAR(10),
  rodzaj VARCHAR(25),
  CONSTRAINT klucz_wniosek PRIMARY KEY (wniosek_id),
);

CREATE TABLE Fakt_rozpatrzenia_wniosku_o_licencje 
(
  fakt_rozpatrzenia_id INT IDENTITY(1,1),
  nieruchomosc_id INT REFERENCES Nieruchomosc(nieruchomosc_id),
  wnioskodawca_id INT REFERENCES Wnioskodawca(wnioskodawca_id),
  wniosek_o_licencje_id INT REFERENCES Wniosek_o_licencje(wniosek_id),
  data_zlozenia_wniosku_id INT REFERENCES Czas(czas_id),
  data_rozpatrzenia_wniosku_id INT REFERENCES Czas(czas_id),
  ilosc_wnioskow_o_licencje INT,
  CONSTRAINT klucz_fakt_rozpatrzenia_licencji PRIMARY KEY(fakt_rozpatrzenia_id)
)


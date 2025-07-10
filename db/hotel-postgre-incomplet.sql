-- Script à compléter
-- Plusieurs tables sont à ajouter, vous pouvez vous servir du modèle logique de données pour les retrouver

-- Attention : 
-- Pour les noms de table ou de colonne vous ne pourrez pas utiliser les mots-clefs utilisé par le langage SQL
-- Voici un liste des mots clefs interdits : https://www.postgresql.org/docs/current/sql-keywords-appendix.html
-- si toutefois vous souhaitez utiliser un mot clef considéré interdit vous pouvez utiliser des guillemets.

-- Ne pas oublier les contraintes d'intégrités suivantes :
-- * contraintes de clefs étrangères 
-- * contraintes de clefs primaires
-- * contraintes de domaine  (ou type)


CREATE TABLE station (
	id SERIAL PRIMARY KEY,
	"name" VARCHAR(50) NOT NULL,
	altitude INT
);

CREATE TABLE hotel (
	id 			SERIAL primary KEY,
	station_id 		INT NOT NULL,
	"name" 		VARCHAR(50) NOT NULL,
	category 	INT NOT NULL,
	address		VARCHAR(50) NOT NULL,
	city 		VARCHAR(50) NOT NULL, 
	FOREIGN KEY (station_id) REFERENCES station(id)
);

-- Tables à insérer ici

-- Table room, création de la clé étrangère qui pointe vers la clé primaire de hotel
CREATE TABLE room (
    id SERIAL PRIMARY KEY,
    hotel_id INT NOT NULL,
    number VARCHAR(10) NOT NULL,
    capacity INT NOT NULL,
    type VARCHAR(50),
	FOREIGN KEY (hotel_id) REFERENCES hotel(id)
   
);

-- Table booking


-- Explication des types
-- Colonne	Type utilisé	Raison
-- id	SERIAL	Clé primaire auto-incrémentée
-- first_name, etc	VARCHAR(n)	Chaîne de caractères
-- booking_date	DATE	Type date
-- price, deposit	REAL	Valeur décimale

-- création de la clé étrangère qui pointe vers la clé primaire de client et room
CREATE TABLE booking (
    id SERIAL PRIMARY KEY,
    room_id INT NOT NULL,
    client_id INT NOT NULL,
    booking_date DATE NOT NULL,
    stay_start_date DATE NOT NULL,
    stay_end_date DATE NOT NULL,
    price REAL,
    deposit REAL,
	FOREIGN KEY (client_id) REFERENCES client(id),
	FOREIGN KEY (room_id) REFERENCES room(id)
    
);
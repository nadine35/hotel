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
CREATE TABLE
    station (
        id SERIAL PRIMARY KEY,
        "name" VARCHAR(50) NOT NULL,
        altitude INT
    );

CREATE TABLE
    hotel (
        id SERIAL primary KEY,
        station_id INT NOT NULL,
        "name" VARCHAR(50) NOT NULL,
        category INT NOT NULL,
        address VARCHAR(50) NOT NULL,
        city VARCHAR(50) NOT NULL,
        FOREIGN KEY (station_id) REFERENCES station (id)
    );

-- Tables à insérer ici
-- Table room, création de la clé étrangère qui pointe vers la clé primaire de hotel
CREATE TABLE
    room (
        id SERIAL PRIMARY KEY,
        hotel_id INT NOT NULL,
        number VARCHAR(10) NOT NULL,
        capacity INT NOT NULL,
        type VARCHAR(50),
        FOREIGN KEY (hotel_id) REFERENCES hotel (id)
    );

-- Table booking
-- price, deposit	REAL	Valeur décimale
-- création de la clé étrangère qui pointe vers la clé primaire de client et room
CREATE TABLE
    booking (
        id SERIAL PRIMARY KEY,
        room_id INT NOT NULL,
        client_id INT NOT NULL,
        booking_date DATE NOT NULL,
        stay_start_date DATE NOT NULL,
        stay_end_date DATE NOT NULL,
        price REAL,
        deposit REAL,
        FOREIGN KEY (client_id) REFERENCES client (id),
        FOREIGN KEY (room_id) REFERENCES room (id)
    );

-- Ce que la vue ne fait pas :
-- Elle ne crée pas une nouvelle table dans le stockage physique.
-- Elle ne duplique pas les données.
-- Elle ne modifie pas les tables d’origine.
-- Explication :
-- Sécurité	L'utilisateur ne voit qu'une partie des données (masquage)
-- Simplicité	L'utilisateur ne voit qu’une vue claire au lieu de faire des JOIN
-- Maintenance	Si la structure interne change, on peut modifier la vue, sans casser les requêtes de l’utilisateur
-- Si elle existe déjà, elle sera remplacée automatiquement.
-- On part de la table booking alias b et on sélectionne les colonnes de cette table
-- b.client_id correspond à c.id dans la table client
-- On ajoute les informations du client :
-- Son id (alias : client_id)
-- Son first_name (prénom)
-- Son last_name (nom)
-- On utilise JOIN pour lier les deux tables ensemble
-- Création d'une vue nommée vue_reservations_clients.
-- Vue 1 :
CREATE
OR REPLACE VIEW vue_reservations_clients AS
SELECT
    b.id AS booking_id,
    b.booking_date,
    b.stay_start_date,
    b.stay_end_date,
    b.price,
    b.deposit,
    c.id AS client_id,
    c.first_name,
    c.last_name
FROM
    booking b
    JOIN client c ON b.client_id = c.id;

-- Création d'une vue nommée vue_chambres_hotels_stations.
-- Vue 2 :
-- Afficher la liste des chambres, avec :
-- le nom de l’hôtel auquel chaque chambre appartient,
-- et le nom de la station de cet hôtel.
-- jointure entre les tables room, hôtel et station
create
or replace VIEW vue_chambres_hotels_stations AS
select
    r.id as room_id,
    r.number AS room_number,
    r.type AS room_type,
    r.capacity,
    h.name as hotel_name,
    s.name as station_name
from
    room r
    jOIN hotel h ON r.hotel_id = h.id
    JOIN station s ON h.station_id = s.id;

----------------------------------------------------------------------------------
-- RÔlES
-- création du rôle application_client :
CREATE ROLE application_client LOGIN PASSWORD 'azerty';

--vérifier que le rôle a bien été créé :
SELECT
    rolname
FROM
    pg_roles
WHERE
    rolname = 'application_client';

-- accorder l'accès à la base au super admin
GRANT CONNECT ON DATABASE hotel TO application_client;

SELECT
    *
FROM
    vue_chambres_hotels_stations;

-- 6. Créez un nouveau rôle « application_client » pouvant se connecter à votre base de
-- données.
-- Donner des droits d'accès tels que :
-- lecture, insertion de nouvelles lignes,
-- modification, suppression et vider la table (irréversible)
GRANT
SELECT
,
    INSERT,
UPDATE,
delete,
truncate ON hotel TO application_admin;

-- 4. Accordez les privilèges « SELECT », « INSERT », « UPDATE » et « DELETE » à
-- l’utilisateur « application_admin » sur toutes les tables sauf « station ».
-- Donner les droits sur toutes les tables du schéma :
GRANT
SELECT
,
    INSERT,
UPDATE,
DELETE ON ALL TABLES IN SCHEMA public TO application_admin;

-- Retirer les droits sur la table station :
REVOKE
SELECT
,
    INSERT,
UPDATE,
DELETE ON station
FROM
    application_admin;

-- 5. Essayez d’effectuer des requêtes :
--INSERT, UPDATE, DELETE ne sont pas possibles 
-- sans mécanismes avancés (trigger ou règle).
-- On ne peut pas exécuter cette permission car il y a des jointures
INSERT INTO
    vue_chambres_hotels_stations (
        room_id,
        hotel_name,
        station_name,
        capacity,
        room_number,
        room_type
    )
VALUES
    (
        123,
        'Hotel Paradis',
        'Station Centrale',
        4,
        '101',
        'Double'
    );

-- on ne peux pas faire d’UPDATE simple sur cette vue car elle ne repose pas sur une seule table simple
-- elle a des jointures.
UPDATE vue_chambres_hotels_stations
SET
    capacity = 10
WHERE
    room_id = 123;
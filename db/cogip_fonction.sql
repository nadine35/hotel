

-- Cette fonction compte combien il y a d’articles dans la table item,
--  affiche ce nombre avec l’heure actuelle, puis retourne ce nombre.


create or replace
function get_items_count() returns integer language plpgsql as $$ declare items_count integer;

time_now time = now();

begin
select
	count(id)
into
	items_count
from
	item;

raise notice '% articles à %',
items_count,
time_now;

return items_count;
end;

$$








select *
from "order" o ;
COMMENT ON TABLE "order" IS 'Commentaires concernant la commande.';



-- On crée une fonction qui retourne un nombre entier
CREATE OR REPLACE FUNCTION public.count_items_to_order()
RETURNS integer
LANGUAGE plpgsql
AS $$
DECLARE
    items_to_order INTEGER;
BEGIN
    -- On compte les articles où le stock est en-dessous du stock d'alerte
    SELECT COUNT(id)

    -- on met le compte dans la variable
    INTO items_to_order  
    FROM item

    --Dans la table item où le stock est inférieur au stock d'alerte
    WHERE stock < stock_alert;

    -- On affiche le résultat avec un message (NOTICE)
    RAISE NOTICE '% article(s) à commander (alerte de stock)', items_to_order;

    -- On retourne le résultat
    RETURN items_to_order;
END;
$$;


;

-- Retourne le résultat de la fonction
-- Combien d’articles ont un stock trop bas, et retourne ce nombre.
 SELECT count_items_to_order();


----------------------------------------------------------------------------------------------------

  create or replace
function public.best_supplier()
	returns int4
	language plpgsql
as $$
declare
best_supplier_id INTEGER;
best_supplier_name TEXT;
nb_commande INTEGER;
begin
-- selectionne le id le nom et compte le nbre de lignes dans la table order
    SELECT s.id, s.name, COUNT(*) as nb_commande
INTO best_supplier_id, best_supplier_name, nb_commande
    from
    "order"o
    join supplier s on
    s.id = o.supplier_id
    group by
    s.id,
    s.name
    order by
    nb_commande desc
    limit 1;

 -- Retourne l'identifiant du meilleur fournisseur quant au nombre de commandes
    RETURN best_supplier_id;
	END;
$$;



;
-- DROP FUNCTION public.satisfaction_string();


create or replace
function public.satisfaction_string(satisfaction_index integer)
	returns text
	language plpgsql
as $$
	begin
--	selon l'entier appelé on renvoie une chaine de caractères	
		IF satisfaction_index is null THEN
			RETURN 'sans commentaire';
		ELSIF satisfaction_index IN (1, 2) THEN
        	RETURN 'Mauvais';
    	ELSIF satisfaction_index IN (3, 4) THEN
        	RETURN 'Passable';
    	ELSIF satisfaction_index IN (5, 6) THEN
        	RETURN 'Moyen';
    	ELSIF satisfaction_index IN (7, 8) THEN
        	RETURN 'Bon';
    	ELSIF satisfaction_index IN (9, 10) THEN
        	RETURN 'Excellent';
    	END IF;
END;
$$ 
		;
-- sélectionne le id du fournisseur ayant le plus de commandes
SELECT best_supplier();



-- DROP FUNCTION public.add_days();

-- « add_days » devra prendre en paramètre une date et un nombre
-- de jours et retourner une nouvelle date incrémentée du nombre de jours.
create or replace
function public.ADD_DAYS(date DATE, days_to_add integer)
	returns date
	language plpgsql
as $$
	begin
return date + days_to_add;
--	
		
    	
END;
$$ 
		;;
-- sélectionne la fonction et renvoie les param tels que la date + les jours sous forme d'entier en plus

SELECT add_days('2023-10-10', 5);


-- L’objectif et de créer une fonction retournant le résultat d’une requête 
-- comptant le nombre d’articles proposés par un fournisseur.
CREATE OR REPLACE FUNCTION public.count_items_by_supplier(s_id integer)
RETURNS integer
LANGUAGE plpgsql
AS $function$
DECLARE
    item_count INT;
BEGIN
    SELECT COUNT(*) INTO item_count
    FROM sale_offer so
    WHERE so.supplier_id = s_id;

    RETURN item_count;
END;
$function$;

-- Appel de la fonction
SELECT count_items_by_supplier(540);
















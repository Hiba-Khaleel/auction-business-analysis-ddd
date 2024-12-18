--1--Utöver säljare och köpare i auktionerna,
--behöver också datatjänst för admininstratörer eller motsvarande hanteras.
create view admin_hanterar_användare as
SELECT
    ao.titel AS auktion_tiel,
    b.bud,
    u.fornamn || ' ' || u.efternamn AS budgivare_namn,
    u.email AS budgivare_epost
FROM
    bud b
JOIN
    anvandare u ON b.budgivare_id = u.id
JOIN
    auktions_objekt ao ON b.auktionsobjekt_id = ao.id
WHERE
    ao.id = 9
 ;
------------------------

--2--Tjänsten måste ge tillräcklig information om varje
-- auktionstyp och auktionsobjekt så att köpare tydligt kan förstå vad de budar på.
create view  detaljerad_auktion as
select titel,
beskrivning,
kvalitetsklass,
typ,
starttid,
sluttid,
utgangspris,
utropspris,
reservationspris,
b.bud,
b.tidpunkt
from auktions_objekt
join bud b on auktions_objekt.id = b.auktionsobjekt_id;

------------------------

--3--Varje auktionsobjekt måste kunna ha flera bilder eller filer.
-- (Bilder och filer kan med fördel sparas som länkar i typen text).
create view auktions_bilder as
select
titel,
b.url as bild ,
b.beskrivning
from auktions_objekt
join bilder b on auktions_objekt.id = b.auktionsobjekt_id;

------------------------

--4-Användare måste kunna registrera sig och logga in.
-- registrera
insert into anvandare(fornamn, efternamn, email, losenord, is_admin)
values ('Hiba','khaleel','hiba@gmail.com','12345',false);

--logga in
select * from anvandare
where email='hiba@gmail.com'
and losenord='12345';

------------------------

--5-Användare måste kunna se listor (mer kortfattad info) såväl som enskilda auktioner (med detaljerad info)
--kortfattad info
create view kortfattad_info as
SELECT
    id,
    titel,
    utropspris,
    starttid,
    sluttid
FROM
    auktions_objekt
WHERE
    sluttid> CURRENT_TIMESTAMP AND starttid < CURRENT_TIMESTAMP
ORDER BY
    sluttid;

--med detaljerad info
    SELECT
    ao.id,
    ao.titel,
    ao.beskrivning,
    ao.kvalitetsklass,
    ao.typ,
    b.url AS bild_url,
    b.beskrivning AS bild_beskrivning,
    ao.starttid,
    ao.sluttid,
    ao.utgangspris,
    ao.utropspris,
    ao.reservationspris

FROM
    public.auktions_objekt ao
LEFT JOIN
    public.bilder b ON ao.id = b.auktionsobjekt_id
    where ao.id = 3;
;
------------------------

--6---Listor måste kunna ordnas baserat på tid (nya auktioner / auktioner som snart går ut)
-- nya auktioner
create view nya_auktioner as
SELECT
    id,
    titel,
    utropspris,
    starttid,
    sluttid
FROM
    public.auktions_objekt
WHERE
    sluttid > CURRENT_TIMESTAMP AND starttid < CURRENT_TIMESTAMP
ORDER BY
    starttid DESC;


-- auktioner som snart går ut
create view  auktioner_snart_går_ut as
SELECT
    id,
    titel,
    utropspris,
    starttid,
    sluttid
FROM
    public.auktions_objekt
WHERE
    sluttid > CURRENT_TIMESTAMP AND starttid < CURRENT_TIMESTAMP
ORDER BY
    starttid ;
------------------------

--7--Listor måste kunna filtreras (pågående, avslutade)
--pågående:
create view pågående_auktion as
select  auktions_objekt.titel, sluttid from auktions_objekt
where  sluttid> CURRENT_TIMESTAMP AND starttid < CURRENT_TIMESTAMP;

--avslutade:
create view avslutade_auktion as

select  auktions_objekt.titel, sluttid from auktions_objekt
where  sluttid< CURRENT_TIMESTAMP ;

------------------------

--8--Användare måste kunna se budhistorik per auktion, såväl som aktuellt bud
-- Aktuellt bud

select ao.titel,a.fornamn || ' ' || a.efternamn AS budgivare_namn,bud,tidpunkt from bud
join auktions_objekt ao on ao.id = bud.auktionsobjekt_id
join public.anvandare a on a.id = bud.budgivare_id
where starttid <current_timestamp And sluttid > current_timestamp;

--budhistorik
select ao.titel,a.fornamn || ' ' || a.efternamn AS budgivare_namn,bud,tidpunkt from bud
join public.auktions_objekt ao on ao.id = bud.auktionsobjekt_id
join public.anvandare a on a.id = bud.budgivare_id

where sluttid < current_timestamp;
------------------------

--9--Användare måste kunna se egna bud och egna auktioner
--egna auktioner
select bud,fornamn||' '||efternamn as bud_givare,ao.titel from bud
join public.anvandare a on a.id = bud.budgivare_id
join public.auktions_objekt ao on ao.id = bud.auktionsobjekt_id
where ao.saljare_id=3;
--
--egna auktioner
select fornamn||' '||efternamn as bud_givare, b.bud, ao.titel from anvandare
join public.bud b on anvandare.id = b.budgivare_id
join auktions_objekt ao on b.auktionsobjekt_id = ao.id
where anvandare.id=5;

-------------------------------
--10--Användare måste kunna se vem som vunnit en auktion
select bud,a.fornamn || ' ' || a.efternamn AS winner_name from bud
join public.anvandare a on a.id = bud.budgivare_id
join public.auktions_objekt ao on a.id = ao.saljare_id
where sluttid< CURRENT_TIMESTAMP
ORDER BY bud desc
limit 1;
select * from bud;

SELECT
    ao.id AS auction_id,
    ao.titel AS auction_title,
    ao.sluttid AS auction_end_time,
    a.fornamn AS winner_first_name,
    a.efternamn AS winner_last_name,
    b.bud AS winning_bid
FROM
    auktions_objekt ao
JOIN
    bud b ON ao.id = b.auktionsobjekt_id
JOIN
    anvandare a ON b.budgivare_id = a.id
WHERE
    ao.sluttid < CURRENT_TIMESTAMP
    AND b.bud = (
        SELECT MAX(b1.bud)
        FROM bud b1
        WHERE b1.auktionsobjekt_id = ao.id
    )
ORDER BY
    ao.sluttid DESC;

--11 Administratörer måste kunna se användare som listor och detaljerat
--som listor
SELECT
    id,
    fornamn,
    efternamn,
    email,
    is_admin
FROM
    anvandare
ORDER BY
    id;

-- Detaljerat
create view detaljerat_användare_info as
SELECT
    a.id,
    a.fornamn,
    a.efternamn,
    a.email,
    a.is_admin,
    ao.id AS auktion_id,
    ao.titel AS auktion_titel,
    ao.beskrivning AS auktion_beskrivning,
    ao.starttid AS auktion_starttid,
    ao.sluttid AS auktion_sluttid,
    b.id AS bud_id,
    b.bud AS bud_belopp,
    b.tidpunkt AS bud_tidpunkt,
    ao_bud.titel AS bud_auktion_titel
FROM
    public.anvandare a
LEFT JOIN
    public.auktions_objekt ao ON a.id = ao.saljare_id
LEFT JOIN
    public.bud b ON a.id = b.budgivare_id
LEFT JOIN
    public.auktions_objekt ao_bud ON b.auktionsobjekt_id = ao_bud.id
WHERE
    a.id = 6
ORDER BY
    a.id, ao.id, b.id;

-------------------------------------------------------------------------------

--12-En lista över pågående auktioner, sorterat på kortast tid kvar.

select
    (sluttid::date-starttid::date)
from
    auktions_objekt
where sluttid != CURRENT_TIMESTAMP
limit 1;
select
    id,
    titel,
    utropspris,
    starttid,
    sluttid,
    (sluttid - CURRENT_TIMESTAMP) as tid_kvar
from
    public.auktions_objekt
where
    starttid < CURRENT_TIMESTAMP
    and sluttid > CURRENT_TIMESTAMP
ORDER BY
    tid_kvar desc;

--13 En lista med de pågående auktioner som är nyligen listade.
--Listorna innehåller följande för varje auktionsobjekt:
-- en kortfattad beskrivning, en bild, kvalitetsklass, bud, och
-- hur lång tid det är kvar.
SELECT
    b2.auktionsobjekt_id as id,
    titel,
    kvalitetsklass,
    b.beskrivning,
    b.url,
    (sluttid::date-starttid::date) as dagar_kvar
from auktions_objekt
join bilder b on auktions_objekt.id = b.auktionsobjekt_id
join public.bud b2 on auktions_objekt.id = b2.auktionsobjekt_id
order by dagar_kvar ;


------------------------

--14 Går jag in på ett avslutat auktionsobjektets sida möts jag av information som anger vem som vann budgivningen och med vilket belopp.

SELECT
    a.fornamn || ' ' || a.efternamn AS vinnande_bud,
    b.bud AS vinst_bud,
    ao.utropspris AS utropspris
FROM
    public.anvandare a
JOIN
    public.bud b ON a.id = b.budgivare_id
JOIN
    public.auktions_objekt ao ON ao.id = b.auktionsobjekt_id
WHERE
    ao.sluttid < CURRENT_TIMESTAMP
    AND b.bud = (
        SELECT MAX(bud)
        FROM public.bud
        WHERE auktionsobjekt_id = ao.id
    )
ORDER BY
    b.bud DESC
LIMIT 1;


------------------------

--15 -- I sökfältet kan jag också söka på auktionsobjekt genom att skriva hela eller delar av titeln. (Query med sökning på en del av titeln)
SELECT titel
FROM auktions_objekt
WHERE titel LIKE '%Tomater%';

------------------------


--16 --Söker jag på typ får jag fram alla auktioner som matchar den kategorin.
select * from auktions_objekt where auktions_objekt.typ LIKE 'grönt';
------------------------

--17 Jag öppnar applikationen och trycker på "registrera konto".
-- Jag fyller i mitt företags organisationsnummer,
-- som kommer att fungera som användarnamn, och sedan ett lösenord.

insert into foretag( anvandare_id, orgnr, foretagsnamn, address_id)
values (3,556671-8891,'SagarLabs AB',5);

select *from foretag;
------------------------

--19En flik för användare där jag får fram en lista med organisationsnummer, företagsnamn, adress och epost.
SELECT fornamn,efternamn,anvandare.email,f.foretagsnamn,f.orgnr, a.gate from anvandare
join foretag f on anvandare.id = f.anvandare_id
join public.adresser a on a.id = f.address_id;

------------------------



--20-- Samt en flik för slutförda köp som visar en lista på de objekt som sålts, vem som sålde, och vem som köpte.

select
    ao.titel AS objekt_titel,
    a_kopare.fornamn AS kopare,
    a_saljare.fornamn AS saljare
from
    kop
join
    auktions_objekt ao ON kop.auktionsobjekt_id = ao.id
join
    anvandare a_kopare ON kop.kopare_id = a_kopare.id
join
    anvandare a_saljare ON ao.saljare_id = a_saljare.id;

------------------------

--22-- Går jag in på ett köp får jag också fram orderdetaljer för köpet.

select
    k.id AS kop_id,
    a.fornamn AS kopare_fornamn,
    a.efternamn AS kopare_efternamn,
    ao.titel AS objekt_titel,
    ao.utropspris,
    ao.sluttid
from
     kop k
join
    anvandare a ON k.kopare_id = a.id
join
    auktions_objekt ao ON k.auktionsobjekt_id = ao.id;






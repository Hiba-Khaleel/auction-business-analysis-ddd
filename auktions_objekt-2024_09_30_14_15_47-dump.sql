--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4
-- Dumped by pg_dump version 16.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: postgres; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C';


ALTER DATABASE postgres OWNER TO postgres;

\connect postgres

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: farskhetsgrad_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.farskhetsgrad_enum AS ENUM (
    'nyskördat',
    'lång hållbarhet',
    'kort hållbarhet'
);


ALTER TYPE public.farskhetsgrad_enum OWNER TO postgres;

--
-- Name: kvalitetsklass_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.kvalitetsklass_enum AS ENUM (
    'klass 1',
    'klass 2',
    'klass 3'
);


ALTER TYPE public.kvalitetsklass_enum OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: anvandare; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.anvandare (
    id integer NOT NULL,
    fornamn character varying(255),
    efternamn character varying(255),
    email character varying(255),
    losenord character varying(255),
    is_admin boolean
);


ALTER TABLE public.anvandare OWNER TO postgres;

--
-- Name: auktions_objekt; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auktions_objekt (
    id integer NOT NULL,
    titel character varying(255),
    beskrivning text,
    typ character varying(50),
    saljare_id integer,
    kvalitetsklass public.kvalitetsklass_enum,
    farskhetsgrad public.farskhetsgrad_enum,
    starttid timestamp without time zone,
    sluttid timestamp without time zone,
    vikt integer,
    utgangspris integer,
    utropspris integer,
    reservationspris integer
);


ALTER TABLE public.auktions_objekt OWNER TO postgres;

--
-- Name: bud; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bud (
    id integer NOT NULL,
    budgivare_id integer,
    bud integer,
    auktionsobjekt_id integer,
    tidpunkt timestamp without time zone
);


ALTER TABLE public.bud OWNER TO postgres;

--
-- Name: admin_hanterar_anvandare; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.admin_hanterar_anvandare AS
 SELECT ao.titel AS auktion_tiel,
    b.bud,
    (((u.fornamn)::text || ' '::text) || (u.efternamn)::text) AS budgivare_namn,
    u.email AS budgivare_epost
   FROM ((public.bud b
     JOIN public.anvandare u ON ((b.budgivare_id = u.id)))
     JOIN public.auktions_objekt ao ON ((b.auktionsobjekt_id = ao.id)))
  WHERE (ao.id = 9);


ALTER VIEW public.admin_hanterar_anvandare OWNER TO postgres;

--
-- Name: adresser; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.adresser (
    id integer NOT NULL,
    gate character varying(50),
    postnr character varying(50),
    ort character varying(50),
    land character varying(50)
);


ALTER TABLE public.adresser OWNER TO postgres;

--
-- Name: adresser_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.adresser_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.adresser_id_seq OWNER TO postgres;

--
-- Name: adresser_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.adresser_id_seq OWNED BY public.adresser.id;


--
-- Name: anvandare_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.anvandare_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.anvandare_id_seq OWNER TO postgres;

--
-- Name: anvandare_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.anvandare_id_seq OWNED BY public.anvandare.id;


--
-- Name: auktions_objekt_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auktions_objekt_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auktions_objekt_id_seq OWNER TO postgres;

--
-- Name: auktions_objekt_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auktions_objekt_id_seq OWNED BY public.auktions_objekt.id;


--
-- Name: avslutade_auktion; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.avslutade_auktion AS
 SELECT titel,
    sluttid
   FROM public.auktions_objekt
  WHERE (sluttid < CURRENT_TIMESTAMP);


ALTER VIEW public.avslutade_auktion OWNER TO postgres;

--
-- Name: bilder; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bilder (
    id integer NOT NULL,
    url character varying(255),
    auktionsobjekt_id integer,
    beskrivning text
);


ALTER TABLE public.bilder OWNER TO postgres;

--
-- Name: bilder_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bilder_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bilder_id_seq OWNER TO postgres;

--
-- Name: bilder_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bilder_id_seq OWNED BY public.bilder.id;


--
-- Name: bud_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bud_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bud_id_seq OWNER TO postgres;

--
-- Name: bud_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bud_id_seq OWNED BY public.bud.id;


--
-- Name: detaljerat_användare_info; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public."detaljerat_användare_info" AS
 SELECT a.id,
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
   FROM (((public.anvandare a
     LEFT JOIN public.auktions_objekt ao ON ((a.id = ao.saljare_id)))
     LEFT JOIN public.bud b ON ((a.id = b.budgivare_id)))
     LEFT JOIN public.auktions_objekt ao_bud ON ((b.auktionsobjekt_id = ao_bud.id)))
  WHERE (a.id = 6)
  ORDER BY a.id, ao.id, b.id;


ALTER VIEW public."detaljerat_användare_info" OWNER TO postgres;

--
-- Name: foretag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.foretag (
    id integer NOT NULL,
    anvandare_id integer,
    orgnr character varying(50),
    foretagsnamn character varying(255),
    address_id integer
);


ALTER TABLE public.foretag OWNER TO postgres;

--
-- Name: foretag_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.foretag_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.foretag_id_seq OWNER TO postgres;

--
-- Name: foretag_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.foretag_id_seq OWNED BY public.foretag.id;


--
-- Name: kop; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kop (
    id integer NOT NULL,
    betalmetod character varying(50),
    kopare_id integer,
    auktionsobjekt_id integer,
    vinnande_bud_id integer
);


ALTER TABLE public.kop OWNER TO postgres;

--
-- Name: kop_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.kop_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.kop_id_seq OWNER TO postgres;

--
-- Name: kop_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.kop_id_seq OWNED BY public.kop.id;


--
-- Name: kortfattad_info; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.kortfattad_info AS
 SELECT id,
    titel,
    utropspris,
    starttid,
    sluttid
   FROM public.auktions_objekt
  WHERE ((sluttid > CURRENT_TIMESTAMP) AND (starttid < CURRENT_TIMESTAMP))
  ORDER BY sluttid;


ALTER VIEW public.kortfattad_info OWNER TO postgres;

--
-- Name: nya_auktioner; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.nya_auktioner AS
 SELECT id,
    titel,
    utropspris,
    starttid,
    sluttid
   FROM public.auktions_objekt
  WHERE ((sluttid > CURRENT_TIMESTAMP) AND (starttid < CURRENT_TIMESTAMP))
  ORDER BY starttid DESC;


ALTER VIEW public.nya_auktioner OWNER TO postgres;

--
-- Name: pågående_auktion; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public."pågående_auktion" AS
 SELECT titel,
    sluttid
   FROM public.auktions_objekt
  WHERE ((sluttid > CURRENT_TIMESTAMP) AND (starttid < CURRENT_TIMESTAMP));


ALTER VIEW public."pågående_auktion" OWNER TO postgres;

--
-- Name: testtable; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.testtable (
    id integer NOT NULL,
    testcolumn text
);


ALTER TABLE public.testtable OWNER TO postgres;

--
-- Name: testtable_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.testtable_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.testtable_id_seq OWNER TO postgres;

--
-- Name: testtable_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.testtable_id_seq OWNED BY public.testtable.id;


--
-- Name: adresser id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adresser ALTER COLUMN id SET DEFAULT nextval('public.adresser_id_seq'::regclass);


--
-- Name: anvandare id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.anvandare ALTER COLUMN id SET DEFAULT nextval('public.anvandare_id_seq'::regclass);


--
-- Name: auktions_objekt id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auktions_objekt ALTER COLUMN id SET DEFAULT nextval('public.auktions_objekt_id_seq'::regclass);


--
-- Name: bilder id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bilder ALTER COLUMN id SET DEFAULT nextval('public.bilder_id_seq'::regclass);


--
-- Name: bud id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bud ALTER COLUMN id SET DEFAULT nextval('public.bud_id_seq'::regclass);


--
-- Name: foretag id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foretag ALTER COLUMN id SET DEFAULT nextval('public.foretag_id_seq'::regclass);


--
-- Name: kop id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kop ALTER COLUMN id SET DEFAULT nextval('public.kop_id_seq'::regclass);


--
-- Name: testtable id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.testtable ALTER COLUMN id SET DEFAULT nextval('public.testtable_id_seq'::regclass);


--
-- Data for Name: adresser; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.adresser (id, gate, postnr, ort, land) FROM stdin;
1	Storgatan 1	111 22	Stockholm	Sverige
2	Kungsbackavägen 10	426 55	Kungsbacka	Sverige
3	Lundavägen 5	223 61	Lund	Sverige
4	Östra Förstadsgatan 12	211 22	Malmö	Sverige
5	Skånegatan 8	302 45	Helsingborg	Sverige
6	Norrlandsgatan 3	903 12	Umeå	Sverige
7	Västra Storgatan 4	811 32	Gävle	Sverige
8	Västerlånggatan 20	111 29	Stockholm	Sverige
9	Norra Promenaden 6	907 20	Umeå	Sverige
10	Bergsgatan 11	252 32	Helsingborg	Sverige
11	Ringvägen 4	116 61	Stockholm	Sverige
12	Malmövägen 6	215 40	Malmö	Sverige
13	Södra Källgatan 15	203 22	Lund	Sverige
14	Rådmansgatan 1	118 24	Stockholm	Sverige
15	Kyrkogatan 9	941 30	Piteå	Sverige
16	Vikgatan 2	790 40	Borlänge	Sverige
17	Strandvägen 8	114 56	Stockholm	Sverige
18	Hälsingegatan 10	826 62	Hälsingland	Sverige
19	Torggatan 3	631 80	Eskilstuna	Sverige
20	Järnvägsgatan 5	831 32	Östersund	Sverige
21	Björkgatan 7	124 67	Vällingby	Sverige
\.


--
-- Data for Name: anvandare; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.anvandare (id, fornamn, efternamn, email, losenord, is_admin) FROM stdin;
1	Anna	Svensson	anna.svensson@example.com	losenord123	f
2	Erik	Karlsson	erik.karlsson@example.com	losenord456	f
3	Maria	Johansson	maria.johansson@example.com	losenord789	t
4	Lars	Andersson	lars.andersson@example.com	losenord321	f
5	Eva	Nilsson	eva.nilsson@example.com	losenord654	f
6	Johan	Larsson	johan.larsson@example.com	losenord987	f
7	Karin	Persson	karin.persson@example.com	losenord741	f
8	Olof	Eriksson	olof.eriksson@example.com	losenord852	t
9	Sara	Berg	sara.berg@example.com	losenord963	f
10	Nils	Lindgren	nils.lindgren@example.com	losenord159	t
11	Hiba	khaleel	hiba@gmail.com	12345	f
\.


--
-- Data for Name: auktions_objekt; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auktions_objekt (id, titel, beskrivning, typ, saljare_id, kvalitetsklass, farskhetsgrad, starttid, sluttid, vikt, utgangspris, utropspris, reservationspris) FROM stdin;
2	Tomater	Röda, saftiga tomater.	grönt	2	klass 2	nyskördat	2024-09-26 09:00:00	2024-10-01 20:00:00	8	80	100	130
3	Potatis	Potatis av hög kvalitet.	grönt	3	klass 3	lång hållbarhet	2024-09-27 10:00:00	2024-10-02 17:00:00	15	60	80	100
6	Päron	Saftiga päron med söt smak.	frukt	6	klass 3	nyskördat	2024-09-30 13:00:00	2024-10-05 15:00:00	7	85	105	135
8	Gurka	Friska, krispiga gurkor.	grönt	8	klass 2	nyskördat	2024-10-02 15:00:00	2024-10-07 17:00:00	8	65	85	115
9	Paprika	Röd paprika, rik på C-vitamin.	grönt	9	klass 3	lång hållbarhet	2024-10-03 16:00:00	2024-10-08 12:00:00	6	75	95	125
10	Blåbär	Vilda blåbär plockade i skogen.	frukt	10	klass 1	kort hållbarhet	2024-10-04 17:00:00	2024-10-09 13:00:00	4	150	180	210
12	Plommon	Mogna plommon, perfekt till sylt.	frukt	2	klass 3	nyskördat	2024-10-06 19:00:00	2024-10-11 15:00:00	6	95	115	145
13	Spenat	Färsk spenat för sallad och matlagning.	grönt	3	klass 1	nyskördat	2024-10-07 08:00:00	2024-10-12 16:00:00	3	50	70	90
15	Vindruvor	Söta, kärnfria vindruvor.	frukt	5	klass 3	kort hållbarhet	2024-10-09 10:00:00	2024-10-14 19:00:00	4	100	120	150
16	Mango	Saftig mango, direkt från tropikerna.	frukt	6	klass 1	nyskördat	2024-10-10 11:00:00	2024-10-15 20:00:00	5	140	160	190
17	Melon	Söt och saftig melon.	frukt	7	klass 2	nyskördat	2024-10-11 12:00:00	2024-10-16 21:00:00	8	130	150	180
18	Citroner	Friska citroner, perfekt till drycker.	frukt	8	klass 3	lång hållbarhet	2024-10-12 13:00:00	2024-10-17 22:00:00	6	90	110	140
19	Sallad	Färsk, krispig sallad.	grönt	9	klass 1	nyskördat	2024-10-13 14:00:00	2024-10-18 23:00:00	3	40	60	80
20	Pumpa	Perfekt för halloween eller matlagning.	grönt	10	klass 2	lång hållbarhet	2024-10-14 15:00:00	2024-10-19 17:00:00	12	60	80	100
21	Ananas	Söt och saftig ananas.	frukt	1	klass 3	nyskördat	2024-10-15 16:00:00	2024-10-20 18:00:00	5	120	140	170
22	Rödbetor	Färska rödbetor, direkt från åkern.	grönt	2	klass 1	nyskördat	2024-10-16 17:00:00	2024-10-21 19:00:00	10	80	100	130
23	Lök	Ekologisk gul lök.	grönt	3	klass 2	lång hållbarhet	2024-10-17 18:00:00	2024-10-22 20:00:00	9	50	70	90
24	Apelsiner	Saftiga apelsiner, rika på vitamin C.	frukt	4	klass 3	kort hållbarhet	2024-10-18 19:00:00	2024-10-23 21:00:00	8	130	150	180
25	Bananer	Mogna bananer, perfekt för smoothies.	frukt	5	klass 1	nyskördat	2024-10-19 20:00:00	2024-10-24 22:00:00	7	110	130	160
26	Persilja	Färsk persilja för matlagning.	grönt	6	klass 2	nyskördat	2024-10-20 21:00:00	2024-10-25 23:00:00	2	20	40	60
27	Avokado	Mogen avokado, perfekt för guacamole.	frukt	7	klass 3	nyskördat	2024-10-21 08:00:00	2024-10-26 18:00:00	5	80	100	130
28	Brysselkål	Ekologisk brysselkål.	grönt	8	klass 1	nyskördat	2024-10-22 09:00:00	2024-10-27 19:00:00	4	60	80	100
29	Kiwi	Söt och saftig kiwi.	frukt	9	klass 2	kort hållbarhet	2024-10-23 10:00:00	2024-10-28 20:00:00	5	90	110	140
30	Rädisor	Färska rädisor, perfekt för sallader.	grönt	10	klass 3	nyskördat	2024-10-24 11:00:00	2024-10-29 21:00:00	3	30	50	70
32	Blomkål	Ekologisk blomkål.	grönt	2	klass 2	nyskördat	2024-10-26 13:00:00	2024-10-31 23:00:00	8	50	70	90
33	Granatäpple	Saftigt granatäpple, rik på antioxidanter.	frukt	3	klass 3	lång hållbarhet	2024-10-27 14:00:00	2024-11-01 16:00:00	4	100	120	150
34	Vitlök	Färsk vitlök, perfekt för matlagning.	grönt	4	klass 1	nyskördat	2024-10-28 15:00:00	2024-11-02 17:00:00	3	40	60	80
35	Päron	Mogna päron, söt och saftig.	frukt	5	klass 2	kort hållbarhet	2024-10-29 16:00:00	2024-11-03 18:00:00	7	110	130	160
36	Körsbär	Färska körsbär, perfekt för desserter.	frukt	6	klass 3	kort hållbarhet	2024-10-30 17:00:00	2024-11-04 19:00:00	5	130	150	180
37	Gröna Äpplen	Krispiga gröna äpplen.	frukt	7	klass 1	nyskördat	2024-10-31 18:00:00	2024-11-05 20:00:00	8	100	120	150
39	Lime	Friska lime, perfekt för drycker.	frukt	9	klass 3	lång hållbarhet	2024-11-02 20:00:00	2024-11-07 22:00:00	5	90	110	140
38	Röda Vindruvor	Söta röda vindruvor, kärnfria.	frukt	8	klass 2	kort hållbarhet	2024-11-01 19:00:00	2024-11-17 10:05:46	6	110	130	160
7	Zucchini	Gröna zucchinis, perfekt för sallad.	grönt	7	klass 1	nyskördat	2024-10-01 14:00:00	2024-10-25 10:04:54	9	70	90	120
4	Jordgubbar	Färska jordgubbar plockade imorse.	frukt	4	klass 1	kort hållbarhet	2024-09-28 11:00:00	2024-10-08 16:00:00	5	120	150	180
31	Hallon	Färska hallon, perfekt för desserter.	frukt	1	klass 1	kort hållbarhet	2024-10-25 12:00:00	2024-11-01 22:00:00	2	150	170	200
11	Persikor	Söta persikor med mjukt kött.	frukt	1	klass 2	nyskördat	2024-10-05 18:00:00	2024-10-11 14:00:00	7	110	130	160
5	Äpplen	Krispiga röda äpplen.	frukt	5	klass 2	nyskördat	2024-09-29 12:00:00	2024-10-08 19:00:00	10	90	110	140
14	Broccoli	Ekologisk broccoli.	grönt	4	klass 2	nyskördat	2024-10-08 09:00:00	2024-10-17 18:00:00	5	60	80	100
1	Morötter	Ekologiska morötter direkt från bondgården.	grönt	1	klass 1	nyskördat	2024-09-25 08:00:00	2024-09-26 18:00:00	10	100	120	150
\.


--
-- Data for Name: bilder; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bilder (id, url, auktionsobjekt_id, beskrivning) FROM stdin;
1	morotter.jpg	1	Bild av ekologiska morötter plockade direkt från bondgården.
2	tomater.jpg	2	Röda och saftiga tomater som visar kvalitén.
3	potatis.jpg	3	Högkvalitativa potatisar i fina förpackningar.
4	jordgubbar.jpg	4	Färska jordgubbar, perfekt för sommarens desserter.
5	äpplen.jpg	5	Krispiga röda äpplen, idealiska för snacks.
6	päron.jpg	6	Saftiga päron med en söt och god smak.
7	zucchini.jpg	7	Gröna zucchinis, perfekta för alla typer av maträtter.
8	gurka.jpg	8	Friska gurkor, perfekta för sallader och smörgåsar.
9	paprika.jpg	9	Röd paprika med hög C-vitamin nivå, utmärkt för matlagning.
10	blåbär.jpg	10	Vilda blåbär, perfekta för sylt eller att äta direkt.
11	persikor.jpg	11	Söta persikor med mjukt kött.
12	plommon.jpg	12	Mogna plommon, perfekt till sylt.
13	spenat.jpg	13	Färsk spenat för sallad och matlagning.
14	broccoli.jpg	14	Ekologisk broccoli.
15	vindruvor.jpg	15	Söta, kärnfria vindruvor.
16	mango.jpg	16	Saftig mango, direkt från tropikerna.
17	melon.jpg	17	Söt och saftig melon.
18	citroner.jpg	18	Friska citroner, perfekt till drycker.
19	sallad.jpg	19	Färsk, krispig sallad.
20	pumpa.jpg	20	Perfekt för halloween eller matlagning.
21	ananas.jpg	21	Söt och saftig ananas.
22	rödbetor.jpg	22	Färska rödbetor, direkt från åkern.
23	lök.jpg	23	Ekologisk gul lök.
24	apelsiner.jpg	24	Saftiga apelsiner, rika på vitamin C.
25	bananer.jpg	25	Mogna bananer, perfekt för smoothies.
26	persilja.jpg	26	Färsk persilja för matlagning.
27	avokado.jpg	27	Mogen avokado, perfekt för guacamole.
28	brysselkål.jpg	28	Ekologisk brysselkål.
29	kiwi.jpg	29	Söt och saftig kiwi.
30	rädisor.jpg	30	Färska rädisor, perfekt för sallader.
31	hallon.jpg	31	Färska hallon, perfekt för desserter.
32	blomkål.jpg	32	Ekologisk blomkål.
33	granatäpple.jpg	33	Saftigt granatäpple, rik på antioxidanter.
34	vitlök.jpg	34	Färsk vitlök, perfekt för matlagning.
35	päron2.jpg	35	Mogna päron, söt och saftig.
36	körsbär.jpg	36	Färska körsbär, perfekt för desserter.
37	gröna_äpplen.jpg	37	Krispiga gröna äpplen.
38	röda_vindruvor.jpg	38	Söta röda vindruvor, kärnfria.
39	lime.jpg	39	Friska lime, perfekt för drycker.
\.


--
-- Data for Name: bud; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bud (id, budgivare_id, bud, auktionsobjekt_id, tidpunkt) FROM stdin;
1	1	100	1	2024-09-24 10:00:00
2	1	150	2	2024-09-24 11:00:00
3	2	120	3	2024-09-24 12:00:00
4	3	130	4	2024-09-24 13:00:00
5	4	140	5	2024-09-24 14:00:00
6	5	160	6	2024-09-24 15:00:00
7	6	110	7	2024-09-24 16:00:00
8	7	170	8	2024-09-24 17:00:00
9	8	180	9	2024-09-24 18:00:00
10	9	190	10	2024-09-24 19:00:00
11	1	200	1	2024-09-24 20:00:00
12	2	210	3	2024-09-24 21:00:00
13	3	220	4	2024-09-24 22:00:00
14	4	230	5	2024-09-24 23:00:00
15	5	240	6	2024-09-25 00:00:00
\.


--
-- Data for Name: foretag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.foretag (id, anvandare_id, orgnr, foretagsnamn, address_id) FROM stdin;
1	1	556677-8899	Företag AB	1
2	2	556677-9900	Svenska Hem AB	2
3	3	556677-0011	Nordisk Design AB	3
4	4	556677-1122	Kreativ Media AB	4
5	9	556677-2233	Tech Solutions AB	5
6	6	556677-3344	Gröna Energier AB	8
7	7	556677-4455	Mat & Dryck AB	7
8	8	556677-5566	Bygg & Renovering AB	8
9	9	556677-6677	Hälsa & Träning AB	9
10	2	556677-7788	Resor & Upplevelser AB	10
11	1	556677-8898	IT Support AB	11
12	2	556677-9987	Event & Catering AB	12
13	5	556677-0076	Konsulttjänster AB	13
14	4	556677-1165	Rör & VVS AB	10
15	5	556677-2254	Fastigheter AB	15
16	7	556677-3343	Utbildning AB	16
17	7	556677-4432	Kundservice AB	17
18	8	556677-5521	Webbdesign AB	18
19	9	556677-6610	Reklam & Marknadsföring AB	19
20	10	556677-7709	Skönhet & Spa AB	1
21	3	547780	SagarLabs AB	5
\.


--
-- Data for Name: kop; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kop (id, betalmetod, kopare_id, auktionsobjekt_id, vinnande_bud_id) FROM stdin;
11	Klarna	1	1	1
12	Swish	1	2	2
13	Kort	2	3	3
14	Klarna	3	4	4
15	Swish	4	5	5
16	Kort	5	6	6
17	Klarna	5	7	7
18	Klarna	6	8	8
19	Swish	7	9	9
20	Kort	8	10	10
\.


--
-- Data for Name: testtable; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.testtable (id, testcolumn) FROM stdin;
\.


--
-- Name: adresser_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.adresser_id_seq', 21, true);


--
-- Name: anvandare_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.anvandare_id_seq', 11, true);


--
-- Name: auktions_objekt_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auktions_objekt_id_seq', 39, true);


--
-- Name: bilder_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bilder_id_seq', 39, true);


--
-- Name: bud_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bud_id_seq', 15, true);


--
-- Name: foretag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.foretag_id_seq', 21, true);


--
-- Name: kop_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.kop_id_seq', 20, true);


--
-- Name: testtable_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.testtable_id_seq', 1, false);


--
-- Name: adresser adresser_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adresser
    ADD CONSTRAINT adresser_pkey PRIMARY KEY (id);


--
-- Name: anvandare anvandare_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.anvandare
    ADD CONSTRAINT anvandare_pkey PRIMARY KEY (id);


--
-- Name: auktions_objekt auktions_objekt_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auktions_objekt
    ADD CONSTRAINT auktions_objekt_pkey PRIMARY KEY (id);


--
-- Name: bilder bilder_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bilder
    ADD CONSTRAINT bilder_pkey PRIMARY KEY (id);


--
-- Name: bud bud_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bud
    ADD CONSTRAINT bud_pkey PRIMARY KEY (id);


--
-- Name: foretag foretag_orgnr_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foretag
    ADD CONSTRAINT foretag_orgnr_key UNIQUE (orgnr);


--
-- Name: foretag foretag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foretag
    ADD CONSTRAINT foretag_pkey PRIMARY KEY (id);


--
-- Name: kop kop_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kop
    ADD CONSTRAINT kop_pkey PRIMARY KEY (id);


--
-- Name: testtable testtable_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.testtable
    ADD CONSTRAINT testtable_pkey PRIMARY KEY (id);


--
-- Name: auktions_objekt auktions_objekt_saljare_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auktions_objekt
    ADD CONSTRAINT auktions_objekt_saljare_id_fkey FOREIGN KEY (saljare_id) REFERENCES public.anvandare(id);


--
-- Name: bilder bilder_auktionsobjekt_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bilder
    ADD CONSTRAINT bilder_auktionsobjekt_id_fkey FOREIGN KEY (auktionsobjekt_id) REFERENCES public.auktions_objekt(id);


--
-- Name: bud bud_auktionsobjekt_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bud
    ADD CONSTRAINT bud_auktionsobjekt_id_fkey FOREIGN KEY (auktionsobjekt_id) REFERENCES public.auktions_objekt(id);


--
-- Name: bud bud_budgivare_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bud
    ADD CONSTRAINT bud_budgivare_id_fkey FOREIGN KEY (budgivare_id) REFERENCES public.anvandare(id);


--
-- Name: foretag foretag_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foretag
    ADD CONSTRAINT foretag_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.adresser(id);


--
-- Name: foretag foretag_anvandare_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foretag
    ADD CONSTRAINT foretag_anvandare_id_fkey FOREIGN KEY (anvandare_id) REFERENCES public.anvandare(id);


--
-- Name: kop kop_auktionsobjekt_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kop
    ADD CONSTRAINT kop_auktionsobjekt_id_fkey FOREIGN KEY (auktionsobjekt_id) REFERENCES public.auktions_objekt(id);


--
-- Name: kop kop_kopare_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kop
    ADD CONSTRAINT kop_kopare_id_fkey FOREIGN KEY (kopare_id) REFERENCES public.anvandare(id);


--
-- Name: kop kop_vinnande_bud_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kop
    ADD CONSTRAINT kop_vinnande_bud_id_fkey FOREIGN KEY (vinnande_bud_id) REFERENCES public.bud(id);


--
-- PostgreSQL database dump complete
--


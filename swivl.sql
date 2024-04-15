--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2
-- Dumped by pg_dump version 16.2

-- Started on 2024-04-15 09:14:34

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 218 (class 1259 OID 16479)
-- Name: DiaryEntry; Type: TABLE; Schema: public; Owner: avnadmin
--

CREATE TABLE public."DiaryEntry" (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    description text NOT NULL,
    date date DEFAULT CURRENT_DATE,
    location character varying(255) NOT NULL,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "userId" integer
);


ALTER TABLE public."DiaryEntry" OWNER TO avnadmin;

--
-- TOC entry 217 (class 1259 OID 16478)
-- Name: DiaryEntry_id_seq; Type: SEQUENCE; Schema: public; Owner: avnadmin
--

CREATE SEQUENCE public."DiaryEntry_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."DiaryEntry_id_seq" OWNER TO avnadmin;

--
-- TOC entry 4383 (class 0 OID 0)
-- Dependencies: 217
-- Name: DiaryEntry_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: avnadmin
--

ALTER SEQUENCE public."DiaryEntry_id_seq" OWNED BY public."DiaryEntry".id;


--
-- TOC entry 216 (class 1259 OID 16464)
-- Name: User; Type: TABLE; Schema: public; Owner: avnadmin
--

CREATE TABLE public."User" (
    id integer NOT NULL,
    username character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public."User" OWNER TO avnadmin;

--
-- TOC entry 215 (class 1259 OID 16463)
-- Name: User_id_seq; Type: SEQUENCE; Schema: public; Owner: avnadmin
--

CREATE SEQUENCE public."User_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."User_id_seq" OWNER TO avnadmin;

--
-- TOC entry 4384 (class 0 OID 0)
-- Dependencies: 215
-- Name: User_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: avnadmin
--

ALTER SEQUENCE public."User_id_seq" OWNED BY public."User".id;


--
-- TOC entry 4218 (class 2604 OID 16482)
-- Name: DiaryEntry id; Type: DEFAULT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public."DiaryEntry" ALTER COLUMN id SET DEFAULT nextval('public."DiaryEntry_id_seq"'::regclass);


--
-- TOC entry 4215 (class 2604 OID 16467)
-- Name: User id; Type: DEFAULT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public."User" ALTER COLUMN id SET DEFAULT nextval('public."User_id_seq"'::regclass);


--
-- TOC entry 4377 (class 0 OID 16479)
-- Dependencies: 218
-- Data for Name: DiaryEntry; Type: TABLE DATA; Schema: public; Owner: avnadmin
--

INSERT INTO public."DiaryEntry" (id, title, description, date, location, "createdAt", "updatedAt", "userId") VALUES (1, 'Trip to Goa', 'Visited Goa with friends. Had a great time.', '2021-06-01', 'Goa', '2024-04-14 16:53:11.174', '2024-04-14 16:53:11.174', 1);
INSERT INTO public."DiaryEntry" (id, title, description, date, location, "createdAt", "updatedAt", "userId") VALUES (2, 'Trekking in Himalayas', 'Trekking in Himalayas was an amazing experience.', '2021-07-01', 'Himalayas', '2024-04-14 16:53:42.298', '2024-04-14 16:53:42.298', 1);
INSERT INTO public."DiaryEntry" (id, title, description, date, location, "createdAt", "updatedAt", "userId") VALUES (3, 'Family Trip to Ooty', 'Family trip to Ooty was a memorable experience.', '2021-08-01', 'Ooty', '2024-04-14 16:56:01.23', '2024-04-14 16:56:01.23', 2);
INSERT INTO public."DiaryEntry" (id, title, description, date, location, "createdAt", "updatedAt", "userId") VALUES (4, 'Road Trip to Pondicherry', 'Road trip to Pondicherry was a fun experience.', '2021-09-01', 'Pondicherry', '2024-04-14 16:56:17.67', '2024-04-14 16:56:17.67', 2);


--
-- TOC entry 4375 (class 0 OID 16464)
-- Dependencies: 216
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: avnadmin
--

INSERT INTO public."User" (id, username, email, password, "createdAt", "updatedAt") VALUES (1, 'testuser', 'testuser@example.com', '$2a$10$3g0h5F68oCMPG8FHzbVNF.EDeKE4TKuZSdno2aXX..iMIfFmKOUGm', '2024-04-14 16:27:59.311', '2024-04-14 16:27:59.311');
INSERT INTO public."User" (id, username, email, password, "createdAt", "updatedAt") VALUES (2, 'srikanth', 'srikanth@example.com', '$2a$10$BRekAfLdicmjd4aHcjGamOb2/HyiApehnro/RTNRTPfK/gUp./r/u', '2024-04-14 16:30:41.016', '2024-04-14 16:30:41.016');


--
-- TOC entry 4385 (class 0 OID 0)
-- Dependencies: 217
-- Name: DiaryEntry_id_seq; Type: SEQUENCE SET; Schema: public; Owner: avnadmin
--

SELECT pg_catalog.setval('public."DiaryEntry_id_seq"', 5, true);


--
-- TOC entry 4386 (class 0 OID 0)
-- Dependencies: 215
-- Name: User_id_seq; Type: SEQUENCE SET; Schema: public; Owner: avnadmin
--

SELECT pg_catalog.setval('public."User_id_seq"', 2, true);


--
-- TOC entry 4229 (class 2606 OID 16489)
-- Name: DiaryEntry DiaryEntry_pkey; Type: CONSTRAINT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public."DiaryEntry"
    ADD CONSTRAINT "DiaryEntry_pkey" PRIMARY KEY (id);


--
-- TOC entry 4223 (class 2606 OID 16477)
-- Name: User User_email_key; Type: CONSTRAINT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_email_key" UNIQUE (email);


--
-- TOC entry 4225 (class 2606 OID 16473)
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);


--
-- TOC entry 4227 (class 2606 OID 16475)
-- Name: User User_username_key; Type: CONSTRAINT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_username_key" UNIQUE (username);


--
-- TOC entry 4230 (class 2606 OID 16490)
-- Name: DiaryEntry DiaryEntry_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public."DiaryEntry"
    ADD CONSTRAINT "DiaryEntry_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON DELETE CASCADE;


-- Completed on 2024-04-15 09:14:39

--
-- PostgreSQL database dump complete
--


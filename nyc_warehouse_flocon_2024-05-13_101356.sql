--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2 (Debian 16.2-1.pgdg120+2)
-- Dumped by pg_dump version 16.1

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
-- Name: dblink; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS dblink WITH SCHEMA public;


--
-- Name: EXTENSION dblink; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION dblink IS 'connect to other PostgreSQL databases from within a database';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: dim_location; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dim_location (
    location_id integer NOT NULL,
    location_name text,
    borough text,
    latitude double precision,
    longitude double precision
);


ALTER TABLE public.dim_location OWNER TO postgres;

--
-- Name: dim_location_location_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dim_location_location_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dim_location_location_id_seq OWNER TO postgres;

--
-- Name: dim_location_location_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dim_location_location_id_seq OWNED BY public.dim_location.location_id;


--
-- Name: dim_payment_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dim_payment_type (
    payment_type_id integer NOT NULL,
    payment_type text
);


ALTER TABLE public.dim_payment_type OWNER TO postgres;

--
-- Name: dim_payment_type_payment_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dim_payment_type_payment_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dim_payment_type_payment_type_id_seq OWNER TO postgres;

--
-- Name: dim_payment_type_payment_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dim_payment_type_payment_type_id_seq OWNED BY public.dim_payment_type.payment_type_id;


--
-- Name: dim_time; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dim_time (
    time_id integer NOT NULL,
    datetime timestamp without time zone,
    hour integer,
    day integer,
    month integer,
    year integer
);


ALTER TABLE public.dim_time OWNER TO postgres;

--
-- Name: dim_time_time_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dim_time_time_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dim_time_time_id_seq OWNER TO postgres;

--
-- Name: dim_time_time_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dim_time_time_id_seq OWNED BY public.dim_time.time_id;


--
-- Name: fact_trip; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fact_trip (
    trip_id integer NOT NULL,
    pickup_datetime timestamp without time zone,
    dropoff_datetime timestamp without time zone,
    passenger_count integer,
    trip_distance double precision,
    fare_amount double precision,
    total_amount double precision,
    payment_type_id integer,
    pickup_location_id integer,
    dropoff_location_id integer,
    time_id integer
);


ALTER TABLE public.fact_trip OWNER TO postgres;

--
-- Name: fact_trip_trip_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fact_trip_trip_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fact_trip_trip_id_seq OWNER TO postgres;

--
-- Name: fact_trip_trip_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.fact_trip_trip_id_seq OWNED BY public.fact_trip.trip_id;


--
-- Name: dim_location location_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dim_location ALTER COLUMN location_id SET DEFAULT nextval('public.dim_location_location_id_seq'::regclass);


--
-- Name: dim_payment_type payment_type_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dim_payment_type ALTER COLUMN payment_type_id SET DEFAULT nextval('public.dim_payment_type_payment_type_id_seq'::regclass);


--
-- Name: dim_time time_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dim_time ALTER COLUMN time_id SET DEFAULT nextval('public.dim_time_time_id_seq'::regclass);


--
-- Name: fact_trip trip_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fact_trip ALTER COLUMN trip_id SET DEFAULT nextval('public.fact_trip_trip_id_seq'::regclass);


--
-- Name: dim_location dim_location_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dim_location
    ADD CONSTRAINT dim_location_pkey PRIMARY KEY (location_id);


--
-- Name: dim_payment_type dim_payment_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dim_payment_type
    ADD CONSTRAINT dim_payment_type_pkey PRIMARY KEY (payment_type_id);


--
-- Name: dim_time dim_time_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dim_time
    ADD CONSTRAINT dim_time_pkey PRIMARY KEY (time_id);


--
-- Name: fact_trip fact_trip_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fact_trip
    ADD CONSTRAINT fact_trip_pkey PRIMARY KEY (trip_id);


--
-- Name: fact_trip fact_trip_dropoff_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fact_trip
    ADD CONSTRAINT fact_trip_dropoff_location_id_fkey FOREIGN KEY (dropoff_location_id) REFERENCES public.dim_location(location_id);


--
-- Name: fact_trip fact_trip_payment_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fact_trip
    ADD CONSTRAINT fact_trip_payment_type_id_fkey FOREIGN KEY (payment_type_id) REFERENCES public.dim_payment_type(payment_type_id);


--
-- Name: fact_trip fact_trip_pickup_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fact_trip
    ADD CONSTRAINT fact_trip_pickup_location_id_fkey FOREIGN KEY (pickup_location_id) REFERENCES public.dim_location(location_id);


--
-- Name: fact_trip fact_trip_time_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fact_trip
    ADD CONSTRAINT fact_trip_time_id_fkey FOREIGN KEY (time_id) REFERENCES public.dim_time(time_id);


--
-- PostgreSQL database dump complete
--


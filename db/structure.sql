SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: cloud_entities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cloud_entities (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    transfer_id uuid NOT NULL,
    parent_id uuid,
    status integer NOT NULL,
    file_path character varying NOT NULL,
    cloud_file_id character varying,
    cloud_file_url character varying,
    mime_type character varying,
    data jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: torrent_entities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.torrent_entities (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    transfer_id uuid NOT NULL,
    torrent_post_id uuid,
    torrent_file_id uuid,
    magnet_link character varying,
    trigger integer NOT NULL,
    transmission_id integer,
    status integer NOT NULL,
    name character varying,
    data jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: torrent_files; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.torrent_files (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    value character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: torrent_posts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.torrent_posts (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    provider integer NOT NULL,
    outer_id character varying NOT NULL,
    magnet_link character varying NOT NULL,
    title character varying NOT NULL,
    body character varying NOT NULL,
    image_url character varying,
    torrent_size bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: transfers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.transfers (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    status integer NOT NULL,
    data jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: user_auths; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_auths (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    provider integer NOT NULL,
    data jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    email character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: cloud_entities cloud_entities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cloud_entities
    ADD CONSTRAINT cloud_entities_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: torrent_entities torrent_entities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.torrent_entities
    ADD CONSTRAINT torrent_entities_pkey PRIMARY KEY (id);


--
-- Name: torrent_files torrent_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.torrent_files
    ADD CONSTRAINT torrent_files_pkey PRIMARY KEY (id);


--
-- Name: torrent_posts torrent_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.torrent_posts
    ADD CONSTRAINT torrent_posts_pkey PRIMARY KEY (id);


--
-- Name: transfers transfers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transfers
    ADD CONSTRAINT transfers_pkey PRIMARY KEY (id);


--
-- Name: user_auths user_auths_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_auths
    ADD CONSTRAINT user_auths_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_cloud_entities_on_parent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_cloud_entities_on_parent_id ON public.cloud_entities USING btree (parent_id);


--
-- Name: index_cloud_entities_on_transfer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_cloud_entities_on_transfer_id ON public.cloud_entities USING btree (transfer_id);


--
-- Name: index_torrent_entities_on_torrent_file_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_torrent_entities_on_torrent_file_id ON public.torrent_entities USING btree (torrent_file_id);


--
-- Name: index_torrent_entities_on_torrent_post_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_torrent_entities_on_torrent_post_id ON public.torrent_entities USING btree (torrent_post_id);


--
-- Name: index_torrent_entities_on_transfer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_torrent_entities_on_transfer_id ON public.torrent_entities USING btree (transfer_id);


--
-- Name: index_torrent_posts_on_outer_id_and_provider; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_torrent_posts_on_outer_id_and_provider ON public.torrent_posts USING btree (outer_id, provider);


--
-- Name: index_transfers_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transfers_on_user_id ON public.transfers USING btree (user_id);


--
-- Name: index_user_auths_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_auths_on_user_id ON public.user_auths USING btree (user_id);


--
-- Name: transfers fk_rails_344b52b7fd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transfers
    ADD CONSTRAINT fk_rails_344b52b7fd FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: torrent_entities fk_rails_34e7d93807; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.torrent_entities
    ADD CONSTRAINT fk_rails_34e7d93807 FOREIGN KEY (transfer_id) REFERENCES public.transfers(id);


--
-- Name: cloud_entities fk_rails_3904d1a86c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cloud_entities
    ADD CONSTRAINT fk_rails_3904d1a86c FOREIGN KEY (transfer_id) REFERENCES public.transfers(id);


--
-- Name: torrent_entities fk_rails_52133845c9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.torrent_entities
    ADD CONSTRAINT fk_rails_52133845c9 FOREIGN KEY (torrent_file_id) REFERENCES public.torrent_files(id);


--
-- Name: torrent_entities fk_rails_6bb2f562f5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.torrent_entities
    ADD CONSTRAINT fk_rails_6bb2f562f5 FOREIGN KEY (torrent_post_id) REFERENCES public.torrent_posts(id);


--
-- Name: user_auths fk_rails_6eeab874aa; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_auths
    ADD CONSTRAINT fk_rails_6eeab874aa FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20190605213344'),
('20190605213350'),
('20190605213352'),
('20190605213353'),
('20190614085747'),
('20190623143710'),
('20190623143715'),
('20190623143720');



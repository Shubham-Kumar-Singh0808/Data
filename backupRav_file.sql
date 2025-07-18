--
-- PostgreSQL database dump
--

-- Dumped from database version 14.17
-- Dumped by pg_dump version 14.17

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
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: getnextid(character varying); Type: FUNCTION; Schema: public; Owner: dspace
--

CREATE FUNCTION public.getnextid(character varying) RETURNS integer
    LANGUAGE sql
    AS $_$SELECT CAST (nextval($1 || '_seq') AS INTEGER) AS RESULT;$_$;


ALTER FUNCTION public.getnextid(character varying) OWNER TO dspace;

--
-- Name: alert_id_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.alert_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.alert_id_seq OWNER TO dspace;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: bitstream; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.bitstream (
    bitstream_id integer,
    bitstream_format_id integer,
    checksum character varying(64),
    checksum_algorithm character varying(32),
    internal_id character varying(256),
    deleted boolean,
    store_number integer,
    sequence_id integer,
    size_bytes bigint,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE public.bitstream OWNER TO dspace;

--
-- Name: bitstreamformatregistry; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.bitstreamformatregistry (
    bitstream_format_id integer NOT NULL,
    mimetype character varying(256),
    short_description character varying(128),
    description text,
    support_level integer,
    internal boolean
);


ALTER TABLE public.bitstreamformatregistry OWNER TO dspace;

--
-- Name: bitstreamformatregistry_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.bitstreamformatregistry_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bitstreamformatregistry_seq OWNER TO dspace;

--
-- Name: bundle; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.bundle (
    bundle_id integer,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    primary_bitstream_id uuid
);


ALTER TABLE public.bundle OWNER TO dspace;

--
-- Name: bundle2bitstream; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.bundle2bitstream (
    bitstream_order_legacy integer,
    bundle_id uuid NOT NULL,
    bitstream_id uuid NOT NULL,
    bitstream_order integer NOT NULL
);


ALTER TABLE public.bundle2bitstream OWNER TO dspace;

--
-- Name: checksum_history; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.checksum_history (
    check_id bigint NOT NULL,
    process_start_date timestamp without time zone,
    process_end_date timestamp without time zone,
    checksum_expected character varying,
    checksum_calculated character varying,
    result character varying,
    bitstream_id uuid
);


ALTER TABLE public.checksum_history OWNER TO dspace;

--
-- Name: checksum_history_check_id_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.checksum_history_check_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.checksum_history_check_id_seq OWNER TO dspace;

--
-- Name: checksum_history_check_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dspace
--

ALTER SEQUENCE public.checksum_history_check_id_seq OWNED BY public.checksum_history.check_id;


--
-- Name: checksum_results; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.checksum_results (
    result_code character varying NOT NULL,
    result_description character varying
);


ALTER TABLE public.checksum_results OWNER TO dspace;

--
-- Name: collection; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.collection (
    collection_id integer,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    submitter uuid,
    template_item_id uuid,
    logo_bitstream_id uuid,
    admin uuid
);


ALTER TABLE public.collection OWNER TO dspace;

--
-- Name: collection2item; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.collection2item (
    collection_id uuid NOT NULL,
    item_id uuid NOT NULL
);


ALTER TABLE public.collection2item OWNER TO dspace;

--
-- Name: community; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.community (
    community_id integer,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    admin uuid,
    logo_bitstream_id uuid
);


ALTER TABLE public.community OWNER TO dspace;

--
-- Name: community2collection; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.community2collection (
    collection_id uuid NOT NULL,
    community_id uuid NOT NULL
);


ALTER TABLE public.community2collection OWNER TO dspace;

--
-- Name: community2community; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.community2community (
    parent_comm_id uuid NOT NULL,
    child_comm_id uuid NOT NULL
);


ALTER TABLE public.community2community OWNER TO dspace;

--
-- Name: cwf_claimtask_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.cwf_claimtask_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cwf_claimtask_seq OWNER TO dspace;

--
-- Name: cwf_claimtask; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.cwf_claimtask (
    claimtask_id integer DEFAULT nextval('public.cwf_claimtask_seq'::regclass) NOT NULL,
    workflowitem_id integer,
    workflow_id text,
    step_id text,
    action_id text,
    owner_id uuid
);


ALTER TABLE public.cwf_claimtask OWNER TO dspace;

--
-- Name: cwf_collectionrole_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.cwf_collectionrole_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cwf_collectionrole_seq OWNER TO dspace;

--
-- Name: cwf_collectionrole; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.cwf_collectionrole (
    collectionrole_id integer DEFAULT nextval('public.cwf_collectionrole_seq'::regclass) NOT NULL,
    role_id text,
    collection_id uuid,
    group_id uuid
);


ALTER TABLE public.cwf_collectionrole OWNER TO dspace;

--
-- Name: cwf_in_progress_user_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.cwf_in_progress_user_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cwf_in_progress_user_seq OWNER TO dspace;

--
-- Name: cwf_in_progress_user; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.cwf_in_progress_user (
    in_progress_user_id integer DEFAULT nextval('public.cwf_in_progress_user_seq'::regclass) NOT NULL,
    workflowitem_id integer,
    finished boolean,
    user_id uuid
);


ALTER TABLE public.cwf_in_progress_user OWNER TO dspace;

--
-- Name: cwf_pooltask_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.cwf_pooltask_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cwf_pooltask_seq OWNER TO dspace;

--
-- Name: cwf_pooltask; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.cwf_pooltask (
    pooltask_id integer DEFAULT nextval('public.cwf_pooltask_seq'::regclass) NOT NULL,
    workflowitem_id integer,
    workflow_id text,
    step_id text,
    action_id text,
    group_id uuid,
    eperson_id uuid
);


ALTER TABLE public.cwf_pooltask OWNER TO dspace;

--
-- Name: cwf_workflowitem_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.cwf_workflowitem_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cwf_workflowitem_seq OWNER TO dspace;

--
-- Name: cwf_workflowitem; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.cwf_workflowitem (
    workflowitem_id integer DEFAULT nextval('public.cwf_workflowitem_seq'::regclass) NOT NULL,
    multiple_titles boolean,
    published_before boolean,
    multiple_files boolean,
    item_id uuid,
    collection_id uuid
);


ALTER TABLE public.cwf_workflowitem OWNER TO dspace;

--
-- Name: cwf_workflowitemrole_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.cwf_workflowitemrole_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cwf_workflowitemrole_seq OWNER TO dspace;

--
-- Name: cwf_workflowitemrole; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.cwf_workflowitemrole (
    workflowitemrole_id integer DEFAULT nextval('public.cwf_workflowitemrole_seq'::regclass) NOT NULL,
    role_id text,
    workflowitem_id integer,
    group_id uuid,
    eperson_id uuid
);


ALTER TABLE public.cwf_workflowitemrole OWNER TO dspace;

--
-- Name: doi; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.doi (
    doi_id integer NOT NULL,
    doi character varying(256),
    resource_type_id integer,
    resource_id integer,
    status integer,
    dspace_object uuid
);


ALTER TABLE public.doi OWNER TO dspace;

--
-- Name: doi_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.doi_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.doi_seq OWNER TO dspace;

--
-- Name: dspaceobject; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.dspaceobject (
    uuid uuid NOT NULL
);


ALTER TABLE public.dspaceobject OWNER TO dspace;

--
-- Name: entity_type; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.entity_type (
    id integer NOT NULL,
    label character varying(32) NOT NULL
);


ALTER TABLE public.entity_type OWNER TO dspace;

--
-- Name: entity_type_id_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.entity_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.entity_type_id_seq OWNER TO dspace;

--
-- Name: eperson; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.eperson (
    eperson_id integer,
    email character varying(64),
    password character varying(128),
    can_log_in boolean,
    require_certificate boolean,
    self_registered boolean,
    last_active timestamp without time zone,
    sub_frequency integer,
    netid character varying(64),
    salt character varying(32),
    digest_algorithm character varying(16),
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    session_salt character varying(32)
);


ALTER TABLE public.eperson OWNER TO dspace;

--
-- Name: epersongroup; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.epersongroup (
    eperson_group_id integer,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    permanent boolean DEFAULT false,
    name character varying(250)
);


ALTER TABLE public.epersongroup OWNER TO dspace;

--
-- Name: epersongroup2eperson; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.epersongroup2eperson (
    eperson_group_id uuid NOT NULL,
    eperson_id uuid NOT NULL
);


ALTER TABLE public.epersongroup2eperson OWNER TO dspace;

--
-- Name: fileextension; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.fileextension (
    file_extension_id integer NOT NULL,
    bitstream_format_id integer,
    extension character varying(16)
);


ALTER TABLE public.fileextension OWNER TO dspace;

--
-- Name: fileextension_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.fileextension_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fileextension_seq OWNER TO dspace;

--
-- Name: group2group; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.group2group (
    parent_id uuid NOT NULL,
    child_id uuid NOT NULL
);


ALTER TABLE public.group2group OWNER TO dspace;

--
-- Name: group2groupcache; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.group2groupcache (
    parent_id uuid NOT NULL,
    child_id uuid NOT NULL
);


ALTER TABLE public.group2groupcache OWNER TO dspace;

--
-- Name: handle; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.handle (
    handle_id integer NOT NULL,
    handle character varying(256),
    resource_type_id integer,
    resource_legacy_id integer,
    resource_id uuid
);


ALTER TABLE public.handle OWNER TO dspace;

--
-- Name: handle_id_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.handle_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.handle_id_seq OWNER TO dspace;

--
-- Name: handle_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.handle_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.handle_seq OWNER TO dspace;

--
-- Name: harvested_collection; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.harvested_collection (
    harvest_type integer,
    oai_source character varying,
    oai_set_id character varying,
    harvest_message character varying,
    metadata_config_id character varying,
    harvest_status integer,
    harvest_start_time timestamp with time zone,
    last_harvested timestamp with time zone,
    id integer NOT NULL,
    collection_id uuid
);


ALTER TABLE public.harvested_collection OWNER TO dspace;

--
-- Name: harvested_collection_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.harvested_collection_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.harvested_collection_seq OWNER TO dspace;

--
-- Name: harvested_item; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.harvested_item (
    last_harvested timestamp with time zone,
    oai_id character varying,
    id integer NOT NULL,
    item_id uuid
);


ALTER TABLE public.harvested_item OWNER TO dspace;

--
-- Name: harvested_item_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.harvested_item_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.harvested_item_seq OWNER TO dspace;

--
-- Name: item; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.item (
    item_id integer,
    in_archive boolean,
    withdrawn boolean,
    last_modified timestamp with time zone,
    discoverable boolean,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    submitter_id uuid,
    owning_collection uuid
);


ALTER TABLE public.item OWNER TO dspace;

--
-- Name: item2bundle; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.item2bundle (
    bundle_id uuid NOT NULL,
    item_id uuid NOT NULL
);


ALTER TABLE public.item2bundle OWNER TO dspace;

--
-- Name: ldn_message; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.ldn_message (
    id character varying(255) NOT NULL,
    object uuid,
    message text,
    type character varying(255),
    origin integer,
    target integer,
    inreplyto character varying(255),
    context uuid,
    activity_stream_type character varying(255),
    coar_notify_type character varying(255),
    queue_status integer,
    queue_attempts integer DEFAULT 0,
    queue_last_start_time timestamp without time zone,
    queue_timeout timestamp without time zone,
    source_ip character varying(45)
);


ALTER TABLE public.ldn_message OWNER TO dspace;

--
-- Name: metadatafieldregistry_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.metadatafieldregistry_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.metadatafieldregistry_seq OWNER TO dspace;

--
-- Name: metadatafieldregistry; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.metadatafieldregistry (
    metadata_field_id integer DEFAULT nextval('public.metadatafieldregistry_seq'::regclass) NOT NULL,
    metadata_schema_id integer NOT NULL,
    element character varying(64),
    qualifier character varying(64),
    scope_note text
);


ALTER TABLE public.metadatafieldregistry OWNER TO dspace;

--
-- Name: metadataschemaregistry_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.metadataschemaregistry_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.metadataschemaregistry_seq OWNER TO dspace;

--
-- Name: metadataschemaregistry; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.metadataschemaregistry (
    metadata_schema_id integer DEFAULT nextval('public.metadataschemaregistry_seq'::regclass) NOT NULL,
    namespace character varying(256),
    short_id character varying(32)
);


ALTER TABLE public.metadataschemaregistry OWNER TO dspace;

--
-- Name: metadatavalue_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.metadatavalue_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.metadatavalue_seq OWNER TO dspace;

--
-- Name: metadatavalue; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.metadatavalue (
    metadata_value_id integer DEFAULT nextval('public.metadatavalue_seq'::regclass) NOT NULL,
    metadata_field_id integer,
    text_value text,
    text_lang character varying(24),
    place integer,
    authority character varying(100),
    confidence integer DEFAULT '-1'::integer,
    dspace_object_id uuid
);


ALTER TABLE public.metadatavalue OWNER TO dspace;

--
-- Name: most_recent_checksum; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.most_recent_checksum (
    to_be_processed boolean NOT NULL,
    expected_checksum character varying NOT NULL,
    current_checksum character varying NOT NULL,
    last_process_start_date timestamp without time zone NOT NULL,
    last_process_end_date timestamp without time zone NOT NULL,
    checksum_algorithm character varying NOT NULL,
    matched_prev_checksum boolean NOT NULL,
    result character varying,
    bitstream_id uuid
);


ALTER TABLE public.most_recent_checksum OWNER TO dspace;

--
-- Name: notifypatterns_to_trigger; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.notifypatterns_to_trigger (
    id integer NOT NULL,
    item_id uuid,
    service_id integer,
    pattern character varying(255)
);


ALTER TABLE public.notifypatterns_to_trigger OWNER TO dspace;

--
-- Name: notifypatterns_to_trigger_id_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.notifypatterns_to_trigger_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notifypatterns_to_trigger_id_seq OWNER TO dspace;

--
-- Name: notifyservice; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.notifyservice (
    id integer NOT NULL,
    name character varying(255),
    description text,
    url character varying(255),
    ldn_url character varying(255),
    enabled boolean NOT NULL,
    score numeric(6,5),
    lower_ip character varying(45),
    upper_ip character varying(45)
);


ALTER TABLE public.notifyservice OWNER TO dspace;

--
-- Name: notifyservice_id_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.notifyservice_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notifyservice_id_seq OWNER TO dspace;

--
-- Name: notifyservice_inbound_pattern; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.notifyservice_inbound_pattern (
    id integer NOT NULL,
    service_id integer,
    pattern character varying(255),
    constraint_name character varying(255),
    automatic boolean
);


ALTER TABLE public.notifyservice_inbound_pattern OWNER TO dspace;

--
-- Name: notifyservice_inbound_pattern_id_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.notifyservice_inbound_pattern_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notifyservice_inbound_pattern_id_seq OWNER TO dspace;

--
-- Name: openurltracker; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.openurltracker (
    tracker_id integer NOT NULL,
    tracker_url character varying(1000),
    uploaddate date
);


ALTER TABLE public.openurltracker OWNER TO dspace;

--
-- Name: openurltracker_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.openurltracker_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.openurltracker_seq OWNER TO dspace;

--
-- Name: orcid_history; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.orcid_history (
    id integer NOT NULL,
    owner_id uuid NOT NULL,
    entity_id uuid,
    put_code character varying(255),
    timestamp_last_attempt timestamp without time zone,
    response_message text,
    status integer,
    metadata text,
    operation character varying(255),
    record_type character varying(255),
    description text
);


ALTER TABLE public.orcid_history OWNER TO dspace;

--
-- Name: orcid_history_id_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.orcid_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orcid_history_id_seq OWNER TO dspace;

--
-- Name: orcid_queue; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.orcid_queue (
    id integer NOT NULL,
    owner_id uuid NOT NULL,
    entity_id uuid,
    attempts integer,
    put_code character varying(255),
    record_type character varying(255),
    description text,
    operation character varying(255),
    metadata text
);


ALTER TABLE public.orcid_queue OWNER TO dspace;

--
-- Name: orcid_queue_id_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.orcid_queue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orcid_queue_id_seq OWNER TO dspace;

--
-- Name: orcid_token; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.orcid_token (
    id integer NOT NULL,
    eperson_id uuid NOT NULL,
    profile_item_id uuid,
    access_token character varying(100) NOT NULL
);


ALTER TABLE public.orcid_token OWNER TO dspace;

--
-- Name: orcid_token_id_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.orcid_token_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orcid_token_id_seq OWNER TO dspace;

--
-- Name: process; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.process (
    process_id integer NOT NULL,
    user_id uuid,
    start_time timestamp without time zone,
    finished_time timestamp without time zone,
    creation_time timestamp without time zone NOT NULL,
    script character varying(256) NOT NULL,
    status character varying(32),
    parameters text
);


ALTER TABLE public.process OWNER TO dspace;

--
-- Name: process2bitstream; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.process2bitstream (
    process_id integer NOT NULL,
    bitstream_id uuid NOT NULL
);


ALTER TABLE public.process2bitstream OWNER TO dspace;

--
-- Name: process2group; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.process2group (
    process_id integer NOT NULL,
    group_id uuid NOT NULL
);


ALTER TABLE public.process2group OWNER TO dspace;

--
-- Name: process_id_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.process_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.process_id_seq OWNER TO dspace;

--
-- Name: qaevent_processed; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.qaevent_processed (
    qaevent_id character varying(255) NOT NULL,
    qaevent_timestamp timestamp without time zone,
    eperson_uuid uuid,
    item_uuid uuid
);


ALTER TABLE public.qaevent_processed OWNER TO dspace;

--
-- Name: registrationdata; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.registrationdata (
    registrationdata_id integer NOT NULL,
    email character varying(64),
    token character varying(48),
    expires timestamp without time zone
);


ALTER TABLE public.registrationdata OWNER TO dspace;

--
-- Name: registrationdata_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.registrationdata_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.registrationdata_seq OWNER TO dspace;

--
-- Name: relationship; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.relationship (
    id integer NOT NULL,
    left_id uuid NOT NULL,
    type_id integer NOT NULL,
    right_id uuid NOT NULL,
    left_place integer,
    right_place integer,
    leftward_value character varying,
    rightward_value character varying,
    latest_version_status integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.relationship OWNER TO dspace;

--
-- Name: relationship_id_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.relationship_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.relationship_id_seq OWNER TO dspace;

--
-- Name: relationship_type; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.relationship_type (
    id integer NOT NULL,
    left_type integer NOT NULL,
    right_type integer NOT NULL,
    leftward_type character varying(32) NOT NULL,
    rightward_type character varying(32) NOT NULL,
    left_min_cardinality integer,
    left_max_cardinality integer,
    right_min_cardinality integer,
    right_max_cardinality integer,
    copy_to_left boolean DEFAULT false NOT NULL,
    copy_to_right boolean DEFAULT false NOT NULL,
    tilted integer
);


ALTER TABLE public.relationship_type OWNER TO dspace;

--
-- Name: relationship_type_id_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.relationship_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.relationship_type_id_seq OWNER TO dspace;

--
-- Name: requestitem; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.requestitem (
    requestitem_id integer NOT NULL,
    token character varying(48),
    allfiles boolean,
    request_email character varying(64),
    request_name character varying(64),
    request_date timestamp without time zone,
    accept_request boolean,
    decision_date timestamp without time zone,
    expires timestamp without time zone,
    request_message text,
    item_id uuid,
    bitstream_id uuid
);


ALTER TABLE public.requestitem OWNER TO dspace;

--
-- Name: requestitem_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.requestitem_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.requestitem_seq OWNER TO dspace;

--
-- Name: resourcepolicy; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.resourcepolicy (
    policy_id integer NOT NULL,
    resource_type_id integer,
    resource_id integer,
    action_id integer,
    start_date date,
    end_date date,
    rpname character varying(30),
    rptype character varying(30),
    rpdescription text,
    eperson_id uuid,
    epersongroup_id uuid,
    dspace_object uuid,
    CONSTRAINT resourcepolicy_eperson_and_epersongroup_not_nullobject_chk CHECK (((eperson_id IS NOT NULL) OR (epersongroup_id IS NOT NULL)))
);


ALTER TABLE public.resourcepolicy OWNER TO dspace;

--
-- Name: resourcepolicy_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.resourcepolicy_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.resourcepolicy_seq OWNER TO dspace;

--
-- Name: schema_version; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.schema_version (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


ALTER TABLE public.schema_version OWNER TO dspace;

--
-- Name: site; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.site (
    uuid uuid NOT NULL
);


ALTER TABLE public.site OWNER TO dspace;

--
-- Name: subscription; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.subscription (
    subscription_id integer NOT NULL,
    eperson_id uuid,
    dspace_object_id uuid,
    type character varying(255)
);


ALTER TABLE public.subscription OWNER TO dspace;

--
-- Name: subscription_parameter; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.subscription_parameter (
    subscription_parameter_id integer NOT NULL,
    name character varying(255),
    value character varying(255),
    subscription_id integer NOT NULL
);


ALTER TABLE public.subscription_parameter OWNER TO dspace;

--
-- Name: subscription_parameter_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.subscription_parameter_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.subscription_parameter_seq OWNER TO dspace;

--
-- Name: subscription_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.subscription_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.subscription_seq OWNER TO dspace;

--
-- Name: supervision_orders; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.supervision_orders (
    id integer NOT NULL,
    item_id uuid,
    eperson_group_id uuid
);


ALTER TABLE public.supervision_orders OWNER TO dspace;

--
-- Name: supervision_orders_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.supervision_orders_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.supervision_orders_seq OWNER TO dspace;

--
-- Name: systemwidealert; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.systemwidealert (
    alert_id integer NOT NULL,
    message character varying(512),
    allow_sessions character varying(64),
    countdown_to timestamp without time zone,
    active boolean
);


ALTER TABLE public.systemwidealert OWNER TO dspace;

--
-- Name: versionhistory; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.versionhistory (
    versionhistory_id integer NOT NULL
);


ALTER TABLE public.versionhistory OWNER TO dspace;

--
-- Name: versionhistory_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.versionhistory_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.versionhistory_seq OWNER TO dspace;

--
-- Name: versionitem; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.versionitem (
    versionitem_id integer NOT NULL,
    version_number integer,
    version_date timestamp without time zone,
    version_summary character varying(255),
    versionhistory_id integer,
    eperson_id uuid,
    item_id uuid
);


ALTER TABLE public.versionitem OWNER TO dspace;

--
-- Name: versionitem_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.versionitem_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.versionitem_seq OWNER TO dspace;

--
-- Name: webapp; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.webapp (
    webapp_id integer NOT NULL,
    appname character varying(32),
    url character varying,
    started timestamp without time zone,
    isui integer
);


ALTER TABLE public.webapp OWNER TO dspace;

--
-- Name: webapp_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.webapp_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.webapp_seq OWNER TO dspace;

--
-- Name: workspaceitem; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.workspaceitem (
    workspace_item_id integer NOT NULL,
    multiple_titles boolean,
    published_before boolean,
    multiple_files boolean,
    stage_reached integer,
    page_reached integer,
    item_id uuid,
    collection_id uuid
);


ALTER TABLE public.workspaceitem OWNER TO dspace;

--
-- Name: workspaceitem_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.workspaceitem_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.workspaceitem_seq OWNER TO dspace;

--
-- Name: checksum_history check_id; Type: DEFAULT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.checksum_history ALTER COLUMN check_id SET DEFAULT nextval('public.checksum_history_check_id_seq'::regclass);


--
-- Data for Name: bitstream; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.bitstream (bitstream_id, bitstream_format_id, checksum, checksum_algorithm, internal_id, deleted, store_number, sequence_id, size_bytes, uuid) FROM stdin;
\N	1	82b11c4adf116bdb41ab4c304288945e	MD5	46352702083696185274926651874147410322	f	0	-1	3002708	bffa777f-3b9a-4f40-9955-048a85e55453
\N	4	af29f11ee8a4956de40c0e6de6e33dd3	MD5	27568862487994747008713171467090092359	t	0	1	936943	ec4574c6-8742-403a-af0e-545906824d71
\N	1	51498efda63b10466506e1cd7a6edf66	MD5	152115116671310325049917254960643310437	f	0	-1	45196833	df761c44-c4b7-4b63-b36d-0b81d3a1698e
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	10266562725710762398535720472166519603	t	0	2	1748	dc7ffc6c-aee0-480c-8430-b6d4d744979e
\N	4	af29f11ee8a4956de40c0e6de6e33dd3	MD5	136432693668217890966273724695648980742	t	0	1	936943	3bfd0215-c135-49f4-b58e-1d45b7dd4117
\N	1	13a4a0ec86aecc7577a913b5a12bd73a	MD5	13643762993260468952829897657120781976	t	0	-1	759504	ad64501f-aa9f-4b5c-8235-d5b8990db32f
\N	1	8c7d6c88684c4f2299f0888ee3879195	MD5	49774070439808809067012169096950427579	t	0	-1	1066502	b51d23a6-444f-44f6-8e9d-a67b9f63bcf9
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	156552663827823925989930584868745948390	t	0	1	1748	e5320dc2-3ed9-4a69-b9b9-90853d1cb56d
\N	1	13a4a0ec86aecc7577a913b5a12bd73a	MD5	65047522744558104983642497549214869585	t	0	-1	759504	236c8cf5-28ce-4a40-b7e2-118dfa9e844c
\N	4	a23c198f97ef004c8428e06ddbe446cb	MD5	73856916849495250019166533271802149893	t	0	1	936943	45791949-4999-465b-8be2-d8f4bcb953b9
\N	4	7ea2e5214ae49f1d31e53e7c7c43d500	MD5	36905296116034567805833893989646265205	t	0	2	740317	5356f5bb-4103-4d1b-b58c-12ed7dd52220
\N	4	47310362ce5cda167ddff3e6796bf2af	MD5	32060304170752980241094389598576404722	t	0	1	652808	bd66ea1d-86e4-4b09-b6bc-3ad96445903f
\N	2	bb9bdc0b3349e4284e09149f943790b4	MD5	109303146558714731240939812366124865122	t	0	2	1748	f7c4a72e-a00f-4229-934f-849567e8a211
\N	9	4fbb92e37d61a34e0dc290bef66a5970	MD5	110245452085242583796566548726562325743	f	0	-1	966	ff5c7076-c0a2-497d-be0e-d8fffb6ce41f
\N	4	af29f11ee8a4956de40c0e6de6e33dd3	MD5	55975888314369233261638948465827907212	t	0	1	936943	5f126a7b-6100-4610-a303-bd9db95911a5
\N	1	cfaf1b5709d1f79f8f655aa12df2269e	MD5	163333485598986053223318088172050356952	f	0	-1	282	1feb0aae-67a2-49cd-a766-dd0b9d06c592
\N	4	5443787056385bc0b9f21dae083845cb	MD5	110418007661547339436873054717748742050	t	0	1	563016	be1e7391-d4d3-4c0d-9b1f-b3c1509ace38
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	123145499664509355351518404066119570832	t	0	2	1748	cbdcdf0a-50cf-4873-be4d-a74d33ca58d1
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	17557138448336706970376767710961447621	t	0	2	1748	53c5cbb4-0dc4-41f7-a2ed-5dc538dd1acb
\N	4	af29f11ee8a4956de40c0e6de6e33dd3	MD5	46402492758748518677395905802455323552	t	0	1	936943	5e546662-ba03-4732-80d2-f83efc97efce
\N	4	af29f11ee8a4956de40c0e6de6e33dd3	MD5	102849421791296863174171496243344625481	t	0	1	936943	12baa5fd-5c81-4bea-b285-dc17c32ae888
\N	4	af29f11ee8a4956de40c0e6de6e33dd3	MD5	148343367458301767505387687746072048485	t	0	1	936943	9b16ac04-1200-4a4f-9e97-c2c37bfc750b
\N	4	fb420bc8201abee887defe88344869a8	MD5	18947996513476868652289397143458565771	t	0	1	1197798	811f0c7a-b5eb-4747-99b5-44fc6ea29bdf
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	60242057043360696554363869383521814634	t	0	2	1748	dd1fb0ac-d7f8-4c65-bc28-90d84935f82a
\N	4	af29f11ee8a4956de40c0e6de6e33dd3	MD5	161002786818984276262461497794759576163	t	0	1	936943	80184882-0695-46a3-94de-add544369356
\N	4	af29f11ee8a4956de40c0e6de6e33dd3	MD5	33030355638895653896627747528115513617	t	0	1	936943	87430ec5-5f4f-4a4a-ab24-76e5c15cc6df
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	153155580440968364101727012897065066654	t	0	2	1748	be4aad3e-0a3f-43d3-b909-8c2236e02536
\N	4	af29f11ee8a4956de40c0e6de6e33dd3	MD5	67666943835913989738603135040631765100	t	0	1	936943	7e857c23-806b-4830-baf3-b1e1986b1965
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	17168962784307252560415089592531252052	t	0	2	1748	0bb58d6f-48de-4c84-9e42-fcdd6a779c8c
\N	4	e6e3c7f2b460e532a06c1a496e1a8121	MD5	75767397877947329353162038725182710967	t	0	1	886616	2191ea91-4091-45d2-a4a1-725d635802fe
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	13893511519827331694998044743787816923	t	0	2	1748	4b029b79-7589-44c6-9f24-4394bae3b1b8
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	132599732273122164469457225262444979378	t	0	2	1748	aaeeb341-c623-4c0d-b9b9-7f9568feacbe
\N	4	7ebf329c51688e22cfc1ad583f2467c8	MD5	10698060321415658621303981231452606868	t	0	1	586711	55b28903-d1cd-4e29-9b0a-379dc666cc7a
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	135513068817924858932497594265690553522	t	0	2	1748	0a00872c-1d53-41ee-afd2-d062b0bb676f
\N	4	af29f11ee8a4956de40c0e6de6e33dd3	MD5	53147828131211975057782645644626184041	t	0	1	936943	48cdb008-bfdf-4998-9f43-94e699fbc0a9
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	114931475392220906649870069871325167782	t	0	2	1748	b77b327b-f817-4d32-9a4b-9eb462659bf1
\N	4	c6b03124b8ed977a80debe0f7f95d46f	MD5	36893235006752235699462839019813559681	t	0	1	886616	6ea746de-6c4b-4288-9bee-a93cc0a8037c
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	55284731630996154181365816979660923500	t	0	2	1748	1ce61bae-e6a7-4831-a1f9-b07404c5b7fc
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	52045432480318043596400824566522686758	t	0	2	1748	dc72b579-bf8e-4e1d-ba58-e52031095104
\N	4	af29f11ee8a4956de40c0e6de6e33dd3	MD5	136343194217557601789527540292931760700	t	0	1	936943	cf5e4e38-a1ce-4078-b89c-4937acb2055c
\N	4	e6e3c7f2b460e532a06c1a496e1a8121	MD5	161538651672810769074981958342441825175	t	0	1	886616	ac7c5540-a1a8-4f96-90e7-f2bff716c4e4
\N	4	af29f11ee8a4956de40c0e6de6e33dd3	MD5	163868375660438949816013668084929860054	t	0	1	936943	b7a6c81e-8e5b-4cf7-a4bb-bb709c14afdd
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	146361700947336739296449240046562575178	t	0	2	1748	5a932d7f-a4dd-4855-aef4-e6bd910fcf66
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	99071886268518751091837172935449032016	t	0	2	1748	4bc4ff48-23d8-40f3-985d-8ae62a01f105
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	122994706174288695302252187841442827841	t	0	2	1748	abceae7c-29c7-4a12-8841-5989af4d95a3
\N	4	af29f11ee8a4956de40c0e6de6e33dd3	MD5	3926637364943438528164011333464640164	t	0	1	936943	4acd467e-b518-4d9b-b8fb-7a86e9806097
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	169481659780736626262698133675164012678	t	0	2	1748	c9a9d872-4f09-4e14-bef4-2b55164f1c3b
\N	4	af29f11ee8a4956de40c0e6de6e33dd3	MD5	123995799843831350475914167489261600124	t	0	1	936943	245156b5-eef4-40d4-9f44-1c1ff30b1816
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	76596185284286373911579469114925393269	t	0	2	1748	79658689-4d32-4268-81ed-625c0bf821a9
\N	1	677effe3c2bff249f28822a2a3a01ab8	MD5	75386476671615339015074121746877861179	f	0	-1	10015879	f557699e-1b6f-4152-8393-17b03dc6a5da
\N	4	aeb18195e29746978a92ffe7cfb2c503	MD5	92387000638331346508840648359941177087	t	0	1	709668	2591ffac-01e2-4c96-acf0-cab1938845b0
\N	4	63c92e91817aa44892a2d303ab1e9d94	MD5	105355390021466841884800043061107884657	t	0	1	886966	87875547-a4d0-43e5-a51c-f8694fc1e0fe
\N	4	63c92e91817aa44892a2d303ab1e9d94	MD5	97665901001349907965786195755470984591	t	0	1	886966	a7f86a11-fcfb-4df5-87f0-49e3103c5148
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	145801762086799721343589309116444802664	t	0	2	1748	c3b58c0a-fb64-494d-8a5a-ce505d02334a
\N	4	fbd9ee19b108780bdc2dc3960e4aa599	MD5	60432312274470563367836231371288340675	t	0	1	886977	666cdae1-e874-4961-a48e-044c1c1c29b1
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	75130174994458893820151560988937988700	t	0	2	1748	c47496a8-6525-4a6a-bed9-bbffac9d426a
\N	4	e6e3c7f2b460e532a06c1a496e1a8121	MD5	78673972106246708017362217183359863517	t	0	1	886616	b4066a60-4017-4ecd-b54c-8b8699f26b19
\N	4	e6e3c7f2b460e532a06c1a496e1a8121	MD5	6663093669513869315901782828363972093	t	0	1	886616	72da50dd-b6e4-49ff-aa17-d5d5e0ecc800
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	71552975595043696113597864960730587537	t	0	2	1748	95d5c820-d64c-44c1-a876-826053be7b5e
\N	4	e6e3c7f2b460e532a06c1a496e1a8121	MD5	65558933247671965608542961095294570088	t	0	1	886616	36f003aa-4f06-4181-875e-85cf0c4fe523
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	122821417027406950895767293250532123623	t	0	2	1748	4b2155ec-e513-477b-bac8-b37142160731
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	16127883355790943850661152605454890678	t	0	2	1748	e84a7e74-e847-4548-b876-1162bef094a6
\N	4	cd38673336dea7488e28a03b184737c2	MD5	139361438852788925687826003925421957688	t	0	1	886978	1a11803d-1f11-49ad-b488-77fa97f2289b
\N	4	f05a50c4789a155fc1d42e47589037ff	MD5	167034388097606573429916479425151863470	t	0	3	919596	cb6963ad-0e29-4a38-957f-509828bec799
\N	4	af29f11ee8a4956de40c0e6de6e33dd3	MD5	22474840675595550372867993380294565467	t	0	1	936943	76127d2c-e183-47c4-a072-a84d0f5642b9
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	131811201303396070838175908167889085176	t	0	2	1748	7a2b4032-6338-4f6d-abad-726db6b2488e
\N	4	a2ed64d9d118bbfb009ac48cab3b630e	MD5	157443278607379464742815562822676252835	t	0	1	30537	1f956b79-4c6a-4b92-a23e-a9bd1045456f
\N	4	e6e3c7f2b460e532a06c1a496e1a8121	MD5	70539788264838068064416249947809884016	t	0	1	886616	ac7c3fab-92e1-4559-b929-df4d8351cb5e
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	113857233123023724997954289073714849707	t	0	2	1748	bde6882b-dcee-421a-89f9-37db10c46792
\N	4	cf7de7febec72c9a1a72a3cd03afdce1	MD5	99801253631774089781595682280392618253	t	0	1	256841	dd614107-0246-44a0-a3b7-dbd0f51be521
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	53624002603237962198719812756458561115	t	0	2	1748	e045690f-1c4a-4391-badb-7474a9b3cefa
\N	4	c6b03124b8ed977a80debe0f7f95d46f	MD5	139877886397737414815839532395132314281	t	0	1	886616	c107b290-0eb6-405a-a064-f5f5724b8626
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	16651106882027037000538979353464860620	t	0	2	1748	d6bb0483-f84d-45e0-93d9-704676a85522
\N	4	c6b03124b8ed977a80debe0f7f95d46f	MD5	36088633914124183254870183670631527071	t	0	1	886616	d42d7bf8-74fa-4a24-bee7-51db8c5f09a4
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	131651559896957630500338700109105887153	t	0	2	1748	428d54c9-c728-4678-9f62-043a7d175237
\N	4	e6e3c7f2b460e532a06c1a496e1a8121	MD5	51129029810202363723922917933750646271	t	0	1	886616	be028d3e-d6c3-4ed1-b3c6-43a3a1585c68
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	166869256783710596441592436824534776225	t	0	2	1748	ec800be0-f237-4a79-bc7c-b7629548061c
\N	4	6b144c4aa698b5486f6bc40605c9e389	MD5	89890837080291623255281164875755519184	t	0	1	886977	73ae3365-d84f-4579-a563-763e8076b4de
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	66004843171887300919311862956881168875	t	0	2	1748	8de27065-13ba-45e1-b85c-80d68bf2a1f6
\N	4	e6e3c7f2b460e532a06c1a496e1a8121	MD5	106854812034456603260599911631468605473	t	0	1	886616	279ff75d-77af-44c0-ad5d-d76df4c78ed2
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	7386497256663663890463922012580949826	t	0	2	1748	f883f0c4-3c25-415a-abed-f5ab0b95a291
\N	4	63c92e91817aa44892a2d303ab1e9d94	MD5	100759818892313115829862560693481637072	t	0	1	886966	1e635111-9d8f-4e4a-876f-31b937a0fa5d
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	140009364154978018542280550217754303273	t	0	2	1748	c664e707-9730-4f7b-ae79-ad35c83f5baa
\N	4	c6b03124b8ed977a80debe0f7f95d46f	MD5	14053076885406305995210103358663034171	t	0	1	886616	d7e89e60-4c09-4a36-91fa-f87a6ac88f10
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	11141761751067693417691908518864972630	t	0	2	1748	97dbfc61-89cf-4fb3-8825-d30bf55642ee
\N	4	63c92e91817aa44892a2d303ab1e9d94	MD5	164025194150708688778526232316368928510	t	0	1	886966	e1326ff4-fc49-48d8-9353-2cdee18d2c72
\N	4	63c92e91817aa44892a2d303ab1e9d94	MD5	64864358759343994414502539852945970742	t	0	1	886966	d9de3187-2c1a-462c-8c57-361c44172721
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	133439920936042861548243045891623342950	t	0	2	1748	f175016d-594a-4070-8cb3-4ed00c7a25b0
\N	4	63c92e91817aa44892a2d303ab1e9d94	MD5	62986304024243494319332715457022775037	t	0	1	886966	c226ac74-c714-4d4f-a65d-764b5d59ff43
\N	4	e6e3c7f2b460e532a06c1a496e1a8121	MD5	49675393193516462092516916964585098234	t	0	1	886616	2e850448-44b2-4aaf-bdb1-04a985298ac3
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	54035215439963430019526832291851776154	t	0	2	1748	57baadf2-71e4-4d2a-9f0a-644901bacff5
\N	4	63c92e91817aa44892a2d303ab1e9d94	MD5	141007049956479459482411054735142380163	t	0	1	886966	91ee1c48-06fd-4af4-a9e9-ed7caed2b547
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	102898563444635862855323602398169918635	t	0	2	1748	3332bd87-0e63-457b-9be5-594da51b0566
\N	4	c6b03124b8ed977a80debe0f7f95d46f	MD5	83981943224299978145144180228399337743	t	0	1	886616	8bf4e517-56af-4a48-a65f-574bc1498aed
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	105715856975090083939525303438122165038	t	0	2	1748	494fbda6-b49f-451e-a13e-e0ca8cbd7ceb
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	131985464999732194722855125141967530266	t	0	2	1748	bc4b83a2-fb82-4f7b-8ffe-af436db04ec8
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	32874007800149696631051055783263736341	t	0	2	1748	b657dfc2-1e64-4565-a23e-ac69945c5e51
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	51515930533852348371604920451112880747	t	0	2	1748	d6f002d5-b5e4-4857-9b3a-23adc038ddd1
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	8407583527949789386859856093845470099	t	0	2	1748	f2bde1b1-ca22-443d-a958-c8575d953772
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	108506307926666092598507416045127639884	t	0	2	1748	3c49f4fd-154f-49a3-bdfa-27bae9c848a2
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	47603266313627143191869229442802677669	t	0	1	136497	6bf62d50-0441-4a85-bd58-635cb5e1a5f1
\N	19	6ddea52d202140ed7ba035b8f3d4da9c	MD5	87007000704727892922949410688715356733	t	0	3	314448	661a0996-f05f-4951-8194-5046d5934ab8
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	9280579056279024915303322500546992300	t	0	2	16633	e2c37321-66aa-4573-a9de-70d29b6f099b
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	103642697743110230087393987797895704122	t	0	1	136497	b2af4673-5761-419b-92f2-069499eba9e6
\N	1	131bb18f3116e7e4c7300a3047c62365	MD5	56761887472224167972356359599124635329	f	0	-1	3001776	38d06d74-3c74-4e76-be58-e3df8704e345
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	50673158546456177957977718345370905939	t	0	1	136497	1ac3ee27-d910-4321-aa8a-11eaaf335de7
\N	1	d41d8cd98f00b204e9800998ecf8427e	MD5	30713206941042650257417466107505880026	f	0	-1	0	6ec99fa2-276f-4119-91e9-6e46116e43fc
\N	1	db85f678ea59db1259a61b4ed896116f	MD5	83547373565150048166714646342746961632	f	0	-1	64270	a28e25ae-96cb-499b-aa50-cf8f6b868150
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	17073968875282947703569917191962774327	t	0	2	16633	da04ea46-4f37-4585-9cb3-e4c968c51bad
\N	1	d41d8cd98f00b204e9800998ecf8427e	MD5	35025417281987312353027927570153466963	f	0	-1	0	2b8dc1ca-f8da-45c9-9b7f-6149d3d5d191
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	141054996707002414805588627945193422293	t	0	2	16633	ac8cee04-6adc-4b1a-9602-c27099e14eee
\N	1	d703e50144b62b46b50ede5bf4d0551c	MD5	124687917198198138344276493437943601601	f	0	-1	64259	f4ef99d8-0800-4b93-bf95-129faf3015e4
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	27108824464336717145167072181793269970	t	0	1	136497	8b9f2da6-aaf3-4f80-bd18-cb472bc5980e
\N	1	131bb18f3116e7e4c7300a3047c62365	MD5	85545288920539132224567292763562806662	f	0	-1	3001776	062c9c70-eec2-4188-b48b-b23ea4a1bd45
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	57639897216058732510457437711544690744	t	0	2	16633	ca8dad51-dfe2-45c9-add4-aad6ee9a4559
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	128687431574354078423635352573094211977	t	0	1	136497	53bd6771-9970-4a43-a34e-206da41b777b
\N	4	f05a50c4789a155fc1d42e47589037ff	MD5	32044208540187477556639226001877195866	t	0	5	919596	993120ec-3a2c-452a-9cbc-1d71ac62a857
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	59916990904337751264694900934581559655	t	0	2	16633	5e5cfff7-d46a-474e-bb0d-c247cf5fdd72
\N	4	f05a50c4789a155fc1d42e47589037ff	MD5	116575678156262062418795914974782400443	t	0	4	919596	47403eda-009f-45a0-8471-cea960116cf9
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	119007567483860437175764729171429790250	t	0	1	136497	c99f65b0-24b1-491c-a4ee-2ac02a6c31b6
\N	4	f05a50c4789a155fc1d42e47589037ff	MD5	39171615092070007460894860888937350145	t	0	3	919596	d2f556a8-4051-41e3-8d5b-17d3a503ffdd
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	72398490531651153869263765206467871439	t	0	1	136497	824ea511-1866-4981-9c67-a225abd67b9d
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	1087129850461008982741196677504663849	t	0	1	2618792	0ab5de0b-e06a-4dfc-8eda-d28f8fb5de39
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	145725635980217419490770257364434515366	t	0	2	20661	2f9154bc-65cd-44b6-9299-8802ac82c5e7
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	166601957866158579642300222626737219130	t	0	1	2618792	039c3fa2-7b1d-4495-8749-2e1371342e40
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	159678975119526267373636696949873372732	t	0	2	20661	f97551d3-3859-44a0-9e65-2c394b9b54b6
\N	4	6b144c4aa698b5486f6bc40605c9e389	MD5	59602462686036234034389673956855748033	t	0	1	886977	fdf22476-a896-41cd-b9df-f1ffdc5f3905
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	28184779093314059918705488534844317935	t	0	2	16633	a26c5f13-f433-4143-9e00-873b20f8695d
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	113408718918700077265710503461178035011	t	0	2	1748	cc5897b0-73f1-43bb-aab2-2e3ed2c30b21
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	107572882010018203566907085324159664606	t	0	1	2618792	ca1f7ea6-16c6-40ef-9ae6-8226e0824dd7
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	36654359103639568308538862066491842523	t	0	2	20661	ba63462e-820a-4a38-b80b-6be4f97d2e12
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	98210719729851074164671649874740623743	t	0	1	2618792	862d725f-7c16-4657-910e-86ae34abc90e
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	119650091245492804000897206307823737519	t	0	2	20661	32a1f201-6cc0-4485-b9a7-4e74450c7d1b
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	59190311397387774690493832319757316142	t	0	1	2618792	986f2d6e-adb6-43d1-bb0c-87a4ab4ce613
\N	1	82b11c4adf116bdb41ab4c304288945e	MD5	66273057316998626623363450623221758409	f	0	-1	3002708	c6d7ea8a-3653-4ba5-b843-f448d72a4f46
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	9770453840852499705243211292279577249	t	0	2	20661	9cd9241a-0c2e-41f6-a117-042e792784b1
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	81058625035867633033513633719164809482	t	0	1	136497	66ce3e95-b6e8-4747-8bd7-e8ccd4fee601
\N	1	9cbd8fd3b0a1dd79259d7824f5904f4f	MD5	155666874963631097828490072097667680786	f	0	-1	13373	b827b971-58f2-455a-9575-63b771b6a920
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	126105998320315606936860232436726059675	t	0	2	16633	66db2f4b-52fb-4300-9634-364fe3c4eee9
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	88523490368265045738701011709822446735	t	0	2	16633	cf8847bc-21fa-4988-80aa-05da0eb96de5
\N	1	82b11c4adf116bdb41ab4c304288945e	MD5	98868085499720635147361645478742408112	f	0	-1	3002708	33326ace-bf60-40d9-9342-812a491bf96a
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	114375743810498828134341307971605900776	t	0	2	16633	63c8f333-b7de-4248-929c-d66f1bed4205
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	101937434973008658446234517845793103527	t	0	2	16633	c7dd26b7-55d4-4bef-b0b9-1823885787ff
\N	1	82b11c4adf116bdb41ab4c304288945e	MD5	77215942911879005764271593433245854305	f	0	-1	3002708	11e326a6-41d1-48aa-ab44-88e79be87367
\N	1	82b11c4adf116bdb41ab4c304288945e	MD5	145674519397981917848097973377972852103	f	0	-1	3002708	aafd1652-1e33-47c8-83d3-164099e91f1d
\N	1	82b11c4adf116bdb41ab4c304288945e	MD5	146149043981373768647784073785351049538	f	0	-1	3002708	1ce72c8b-7d2b-452b-b1df-4f8c2c742b9f
\N	1	b91139651373f9eb67fb40269fcd9571	MD5	184631623458558317363710801134409691	f	0	-1	351	d8a32f78-2b75-4020-9b65-7d829f342242
\N	1	82b9b916e5a8ab76d2b68b4db8e3fe23	MD5	39015368380088042538915293682916737930	f	0	-1	51095	35e5fe5a-dc1d-4c95-8e0d-7d0fd1a4be21
\N	1	82b11c4adf116bdb41ab4c304288945e	MD5	123649450905353312376053880333044765642	f	0	-1	3002708	46ec0a27-1027-403d-81ab-6e16088394c2
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	96686001770305702891517892458763983024	t	0	2	16633	ddcdaf51-783b-4c28-bafd-93e0824e83c2
\N	4	63c92e91817aa44892a2d303ab1e9d94	MD5	43596274402580352083011630796941995659	t	0	1	886966	135bf286-ca4f-4440-aab0-783449b4316a
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	114889330081551942352386487992182086333	t	0	2	1748	89d9c763-30c3-4557-93fe-3776fdc49689
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	48937659274303971778766420693527470586	t	0	1	136497	4d85a1b1-0100-4c01-b1db-3fdf2ab2f6a8
\N	1	d41d8cd98f00b204e9800998ecf8427e	MD5	54740520737888590570748045676003173090	f	0	-1	0	22915ed5-e8f4-4442-bfd4-cc6e488c47df
\N	1	97cb588140b1fb06fc51ff2f5706ea47	MD5	159596648296299722514192303601250721104	f	0	-1	64260	173374f7-02e5-4817-8ab7-8cbd382985b0
\N	4	af29f11ee8a4956de40c0e6de6e33dd3	MD5	155379681198342492686791595750783739429	t	0	1	936943	e0b6a6c5-4a04-4e79-a32f-e07f60edfa10
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	73615031966702848766443159676189972012	t	0	2	1748	e7e64031-a35c-474b-b81e-c80dee141c79
\N	1	131bb18f3116e7e4c7300a3047c62365	MD5	125876446960733835073310152292242694808	f	0	-1	3001776	3c6e31ad-5217-40cc-8112-4324477ea8d8
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	55895534799695895781871597084879856638	t	0	2	16633	9ec79635-ebcc-4015-b48e-715b2bb17f2e
\N	1	131bb18f3116e7e4c7300a3047c62365	MD5	71319368365843857113267356482732954709	f	0	-1	3001776	7a292192-5bec-4358-bfdc-ae27578b4cb9
\N	4	f3893f072768e254eb5d9c040de8fa1d	MD5	101153453378810620059947654487750743307	t	0	4	1101304	2da875ab-3c70-4207-bb7e-d2439ea6c511
\N	1	d41d8cd98f00b204e9800998ecf8427e	MD5	30560455893726764080582562668387941266	f	0	-1	0	1e99bd7c-6734-4755-bafb-cf883f044ea8
\N	1	638698a23cb96fc59f561982aee1a31e	MD5	79429296964723529790869481671204310561	f	0	-1	48030	7c0b6660-9bd8-4542-bc74-8781cbc72f9e
\N	1	19803eb2c32761733f512cd98da70344	MD5	107064704450443539334142583689330248680	f	0	-1	3002489	7088082e-d908-4d91-9d78-697ce5af8e2c
\N	1	677effe3c2bff249f28822a2a3a01ab8	MD5	149594273088122263902034830729275810581	f	0	-1	10015879	4bfbf1d6-a42a-4b93-b3e3-34fe8a309351
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	116385967754147376001708800835407162731	t	0	1	136497	8ec8d495-0014-4740-a088-fa895e8af8ca
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	76900630016166674128533298939486999925	t	0	2	16633	39211907-e7a7-433e-b3e7-63ea6072974c
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	42706843689337518505406714144343722437	t	0	1	136497	0d354644-0ec3-4fb9-8adb-ec825370fd8d
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	129987446721400585194308091901537089455	t	0	2	16633	f95297fc-4084-4b60-827e-b8a476037ef9
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	134006167941060617575655489099177743856	t	0	1	2618792	d4ea992f-7a65-49af-b90b-4cbe54e62784
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	99399441566789198202590904914756366765	t	0	2	20661	ba7ba332-4a7f-4409-be28-bf9504db6f44
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	51507042938229808086417116228288322807	t	0	1	2618792	19cb1f36-ed20-48ef-8297-0174867edb91
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	61516557250215343996761842199759183028	t	0	1	136497	6c34aedd-20d7-46e4-8614-0a7f2185a567
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	33779121954910641715179925218073744634	t	0	2	20661	f6c466e3-f8b8-4f28-8d7d-d1de8df0a5d7
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	76475540179992955055432463603331832657	t	0	1	2618792	e74a37f3-b989-4499-af6f-2162ee3dbea7
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	11943901373763620891742487654304616000	t	0	2	20661	21e75cac-2d4d-40b0-9888-f61cd53a4b6d
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	73811158863376681204328633573026055041	t	0	1	2618792	f374620d-ef40-4ed6-9fcf-3f519848371c
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	160688537230193248249652163994770906994	t	0	2	20661	e9c9f7ac-6a60-4082-bc97-39fdc9e79c89
\N	1	82b11c4adf116bdb41ab4c304288945e	MD5	156552989559375432980515702741337284332	f	0	-1	3002708	910811f3-954b-4e26-8eb4-8e8cb14100e0
\N	17	ba6ea14c63dd028b698e405d5f763cee	MD5	69326250481759973301905804618695195719	t	0	3	1077935	eb452230-1790-4fa4-a35c-1821014c403d
\N	1	3e88dd01e0da5d26ec0192f5e2bd6556	MD5	55228802673933792206070380829944267771	f	0	-1	13369	efa477b7-ad16-4bc6-bc0f-04aafe43736a
\N	17	ba6ea14c63dd028b698e405d5f763cee	MD5	16692883512852813319828727498449081874	t	0	1	1077935	3b4370e6-90dd-4ee1-a289-eeaa0a77c7da
\N	2	bb9bdc0b3349e4284e09149f943790b4	MD5	163165061598919565348028255519667630721	t	0	2	1748	8b701473-2893-4d03-8155-b1fcb8989141
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	145505699571185633715460586911754028984	t	0	2	16633	1adbfd1d-8d65-4c80-916c-1a62bddde614
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	78513724329451791675498006275602503133	t	0	1	136497	4696cb67-0e5f-44b3-a2e9-f96ec8d9daff
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	165228572240281885629673265128200899107	t	0	2	16633	90a742a2-cb2d-49da-878d-f885b4cf7289
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	51822388139825627051623791242354683765	t	0	1	136497	902e9e9a-ca08-4b2c-9a19-cb2f86d30d03
\N	1	10b33482557c6b1d6db490809a0ae544	MD5	77004027540790615412200910894518321283	f	0	-1	331	06492d28-6f48-462e-a981-39c9e5cfbe40
\N	1	00a1d76a4c9c884d16a8d60c182ec7ec	MD5	65200980211987071760621305450711309266	f	0	-1	47714	3c58bf17-ace4-4ed0-8697-fb3097ac3360
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	7140689067307519511032790226898742498	t	0	1	136497	6a383623-266d-4413-ae5f-e6aa9ca5294c
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	85788897408253415192337592494968109919	t	0	2	16633	1ca7dc9e-2099-49d8-93eb-7698063ad1e0
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	4727165244723184119674580949292997459	t	0	1	136497	edc8cb15-8d03-4cc2-9f85-1974a4d8e654
\N	1	ae04d3887ff4a4db8117c1e130ab15c2	MD5	121463732206438078743609731030235722507	f	0	-1	13431	e9377708-7c1d-4b2a-ba7f-b07e4f2762ec
\N	1	51498efda63b10466506e1cd7a6edf66	MD5	139342445094657702643635228500810703749	t	0	-1	45196833	b68fb29e-60fd-4e0a-aa59-f44bf47f0c14
\N	1	b558fd725aced71b6fa030f66c8c0a4d	MD5	35376770756869064280234432167574935344	f	0	-1	148286804	ee696fdb-4d5c-4ec1-af77-f18d651db39d
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	132781068603449602985318044071215884581	t	0	1	136497	c2b25088-12bf-4de3-9202-9c34e22c2883
\N	1	82b11c4adf116bdb41ab4c304288945e	MD5	126577808689522272752754767437765639326	f	0	-1	3002708	439c7f26-2571-48a3-98c3-c22c7ad5aa5e
\N	17	2373b12bc6b2bc4f08f43e64f86d9dd0	MD5	103033079013047505055417330268382645282	t	0	1	28633	5f954a91-01b2-4994-9aea-5247f41bba19
\N	84	d25ff8540b369d8f3cb2f562b446c254	MD5	67184775313126717947976945859687508327	t	0	1	6706	83bb9fcc-27f4-498d-9554-aa80daadd80c
\N	2	bb9bdc0b3349e4284e09149f943790b4	MD5	24805417622158645981254349222445693398	t	0	2	1748	f1a2433b-b17f-42d6-a354-ff877a3d5a2b
\N	4	47310362ce5cda167ddff3e6796bf2af	MD5	161047813911916098675152014966206015112	t	0	1	652808	4d8e733b-3140-4c5e-b5f9-a16a758afafd
\N	1	131bb18f3116e7e4c7300a3047c62365	MD5	90135272506228009204869758162307198045	f	0	-1	3001776	29326696-59de-446c-b833-d36936828fae
\N	2	bb9bdc0b3349e4284e09149f943790b4	MD5	46720814184244566564653427595986298159	t	0	2	1748	b10693f9-9de0-401d-83a7-9f678d457e4b
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	50466917606744335831800674778473075922	t	0	1	136497	b632144c-bea6-4d11-81b1-29599b5b343c
\N	4	63c92e91817aa44892a2d303ab1e9d94	MD5	23013982756881914720190587402508368501	t	0	1	886966	44a85498-ecef-436f-b327-974987702e5f
\N	4	48a7a3be814686ee400f826059e821c1	MD5	137213850103001264895640770953091993942	t	0	1	93981	89cbc5cc-55ca-4760-b787-5eda8cb8c422
\N	2	bb9bdc0b3349e4284e09149f943790b4	MD5	69969735025023521907447766254486723295	t	0	2	1748	b946f119-cc9b-4268-9a20-914cbb1459d5
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	65963319056187127259062201475588433129	t	0	1	136497	83899895-efaf-4da7-925b-d16ad20c367b
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	162643670141362930273066713188973106846	t	0	2	16633	e862c4db-7e1d-4295-93fc-44c653221019
\N	1	7fa9a018cc5bf00a1b13ec8c90c90e71	MD5	18188084196534283798454989869827956354	f	0	-1	51095	339138ff-1b5d-4d1f-b72f-f4b81f634657
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	87183687484643636659205957627768683023	t	0	1	136497	9ba23e80-2752-4574-a0fd-d123b711a682
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	64299779112886808039889480111400500097	t	0	2	16633	4759d16b-b270-4fe5-9ff1-34f6a8191434
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	63361799229400333327002357129967133118	t	0	2	16633	6a9379f5-80c9-4c56-a33d-72a9068eec58
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	48787343973325943554711184598324701846	t	0	1	136497	ce580e90-f41b-4840-a3e4-d0648b0ab5a7
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	34757253100000404593901565112382351069	t	0	2	16633	b0006623-ba88-4650-ad4e-18e9cc34ddb5
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	66617029386587369774195202191842558397	t	0	2	16633	cbdafa5e-ce72-45e6-86fb-5a93edcedc33
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	41470716363934765020382950431261486079	t	0	1	136497	0c28b25e-492e-4776-8dab-20bc4464d954
\N	1	116800244623fe179ec9b7c5c95b8324	MD5	76534026607870314285494759425256724754	f	0	-1	13431	9272ae94-f565-4b74-86b8-55302a4bff38
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	143753438649989365661487144731355672781	t	0	2	16633	7ffc982c-9301-4082-9d1e-282652a88336
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	54759756486186871634654788595945491972	t	0	1	136497	e45c2b0a-ae64-48a9-a8d6-d2bcec6cba5b
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	13006992221949481689791855186405902315	t	0	2	16633	55ec0de8-e695-47c9-a770-124b1cfa1595
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	155808265052099462607749806683695704474	t	0	1	136497	230df675-813a-4475-8d87-66509d79d8f7
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	106059677182731824400506593435627661793	t	0	2	16633	262f89b1-29ad-4e32-b336-5a13e84f32ca
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	120907298896161881679783897333052330990	t	0	1	136497	19c06bd5-7e00-4b9d-bb63-a7d68eebb7b2
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	91508521800731229543826319245135301871	t	0	2	16633	7a064116-70e1-4699-9797-593c43d1afd2
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	1674644461735381524890201326963011432	t	0	1	136497	270ce077-ac37-448e-a941-bf8092306b31
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	72080521718719727988837834083075947789	t	0	2	16633	748d9040-0051-4fb4-8c9c-d8c2f0b621ba
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	16937649672923196611201514124804462759	t	0	1	136497	ec0516e8-ece6-486c-9c59-f099e03d2256
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	158618983668185342822307102849313300982	t	0	2	16633	e8f4c747-f710-426c-ac1b-689ea557d0f0
\N	1	97b9523ae0d2c10de5d3eee251b3fa97	MD5	43070400514780967825287431345429692845	f	0	-1	13373	c3b39c9e-0e5b-4d7f-b7fc-fcab7c249183
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	40763766023280774763495534438233664467	t	0	1	136497	5aaefc24-96b6-41da-9b95-4c2e54e4989e
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	118589556169521880178121886617900824176	t	0	1	136497	5d78d55a-6350-4714-b4ff-7648c461e08d
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	10368907900705597818390482701815112338	t	0	1	136497	87489ca1-2f0a-4303-b079-e9bcea09ef27
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	166914322714968345257105802935629972109	t	0	2	16633	d153b254-2b2c-4d2f-b7ea-7f0e52c3a7e5
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	7596920187622898878453348770975538628	t	0	1	136497	6bed6545-d8db-402f-9dd4-8d21df467b9e
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	90140240205224936919056880013686866109	t	0	2	16633	6521cffb-0c27-4491-bd6a-ea4ed616b27b
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	109010816570167250083068439441424438004	t	0	2	16633	e80fa848-8aa7-4d8f-bd3f-05c9fbc64526
\N	1	677effe3c2bff249f28822a2a3a01ab8	MD5	73564495577093601586151244120718251494	f	0	-1	10015879	316d2622-95b1-4b41-bd8c-271a59ffae66
\N	1	da03d47cf22ff60973e1062fe4fb8732	MD5	129295019585100190059550023991866746502	t	0	-1	351	6a418b3c-839b-4fc7-b4e4-a5b19a203e04
\N	1	bb2e164c30509814eec348289967c029	MD5	132316881058733184257887657499720702885	f	0	-1	351	be61103b-4de4-4a9d-aa33-a37b79417b9f
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	94605039181865696890359071442303515756	t	0	2	16633	d08831f5-28e2-4ace-b9c9-ff5f8e5ce0ae
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	29280864852459563688707641099719911827	t	0	1	2618792	ba41d4b0-e409-4f91-82b3-a793a859fd1e
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	55630860937130822169102760179044975395	t	0	1	136497	6e710488-829c-49fa-9395-ba4c9292103d
\N	2	bb9bdc0b3349e4284e09149f943790b4	MD5	150006452797861434108341563104138041075	t	0	2	1748	f544b825-5280-462b-bfef-962585f0cde9
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	144528035153281742829953621915764966147	t	0	1	136497	3f0b7a1a-56c5-4a02-9d91-6a9e4ca848a1
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	54036306575777701086817285501567337390	t	0	1	136497	28b33fc1-d78e-4e76-8be4-56cdd2604681
\N	4	317ac21b68b76edcb6233d592953b393	MD5	153173918300493104680934996310882198619	t	0	1	185873	98be67b9-2284-48c5-9b36-3e40f2640741
\N	2	bb9bdc0b3349e4284e09149f943790b4	MD5	162704455148927614432973907436907380377	t	0	2	1748	83fc647b-ca4b-49ce-8d4a-6803521c136a
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	32251733534649157513896045089916175967	t	0	2	16633	b955a8b6-0084-483d-b0da-0310e39a20d5
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	63908850822581471068833946325711385398	t	0	2	1748	e5805876-74af-418a-afba-421053c0e889
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	88921477871656094218316837056463141663	t	0	2	1748	119b7097-52b2-472b-a62e-8b209abe827f
\N	1	d41d8cd98f00b204e9800998ecf8427e	MD5	123739712219959374662235580047228445040	f	0	-1	0	4a7752ff-8932-46d1-a766-4d36a723bd81
\N	19	edefe647270991d4a79c5a1549256fca	MD5	169249655968581415841903450386372921152	t	0	1	16575	7759f18d-88bd-47af-8d60-20783fb5f0fb
\N	1	4d9787878190e1a16ec74cfdfa8daa27	MD5	109134940465641984516907496074562957043	f	0	-1	48019	74058e8c-9fe4-4ff4-8e5d-b02d09caa089
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	110785845788566591495379930487990329136	t	0	2	1748	c3c736ea-7b24-4184-93fc-f08a084ca050
\N	19	6ddea52d202140ed7ba035b8f3d4da9c	MD5	64928853458023091328184051786649275132	t	0	3	314448	d130a874-3309-4eda-a25b-736f2a96053d
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	37353834208555578584368739650978921456	t	0	1	136497	fc0cdc51-b798-4260-89c6-21bcf5e90e43
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	118649855844303802330555106695053758321	t	0	2	16633	0abb40bd-56a9-40c4-939b-a3c0629a53c2
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	10898073692764523590048785700786779817	t	0	1	136497	f3250f8e-5a48-41cf-afde-5e0fd29e38b1
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	36311636720252943063302061221976774473	t	0	2	16633	ba990800-568b-4c74-9986-243c61f79d8b
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	1386599870177781552741819621191450562	t	0	1	136497	bb63eb78-91fb-4110-9446-3fc3f2322f23
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	34366159308339986555904247272972371367	t	0	1	136497	f7898dbc-f40a-4e2b-b245-2c281f6bc1c8
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	35085177109459158734141781149764075088	t	0	2	16633	aad2253a-d28b-4740-b984-ba3b96093b83
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	33579351800348249051001683530375510615	t	0	1	136497	69ad5b1b-6a7d-4387-9956-46f985afc1bd
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	55476882474885971449993749453013602075	t	0	2	16633	d2e2dc54-1276-419e-895a-68deeae24ff2
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	139504968526575737651784460012930783203	t	0	1	136497	cb67f2cf-9167-4f7e-a903-d424080ee264
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	143254590122188484149324658663629183052	t	0	1	136497	4de34964-f939-410f-8266-177f5d95f559
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	128411518580146646657032378103788502950	t	0	2	16633	d8f60672-3b32-465c-ae3c-f617597940b8
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	16021159153043086869485175451874980814	t	0	1	136497	751813cc-de1a-4117-a6ba-f3e3c3ca1b64
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	158810458691756480320368998283009955450	t	0	2	16633	c3a6364f-7842-4d81-8ac4-9d3c4722befe
\N	1	669835a622224982c99b45500f0f1280	MD5	104820170207806896190478857852455176085	f	0	-1	13373	db2546cd-9aef-4ef8-8472-97aff1fd1817
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	12158322056832947733235119187920807404	t	0	1	136497	22d5d3f6-cf09-413a-8fcd-d656f0992007
\N	1	82b11c4adf116bdb41ab4c304288945e	MD5	102191409182832172318842934149667047167	f	0	-1	3002708	81ce143d-a2d9-418d-999b-b5804b293746
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	132942983120608849652595862793446291025	t	0	2	16633	1b8647de-8e04-468c-bd03-6f72c8cd9f14
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	53961911172923137047815799784134845919	t	0	2	16633	77adddb2-285a-4883-9257-2d795277d058
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	164572488094238927882753280295338978694	t	0	1	136497	5a068c21-5f02-4549-b1b2-aefcb7cf9eb7
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	79222989499701729264187665265290364312	t	0	2	16633	8e269ccc-c571-44c5-869d-4b83c554c526
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	29096094851671533433297110965392061301	t	0	1	136497	d886e1d0-02f2-40f6-8635-a36d290bc787
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	155939474001111845910205316471863951636	t	0	1	136497	5266a03d-f215-47e0-b511-fe38c8699df4
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	130970383454406250130040844462649753603	t	0	2	16633	e0bbc989-713a-4d79-a4a2-5896068f9bdf
\N	1	84d840fb2a16181f9096d5c9101c0395	MD5	6965632127506647795819476016046042231	f	0	-1	13431	86f31c01-ad08-48e7-bb7a-c95405c442ef
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	81346903592950885984542855635225736611	t	0	1	136497	b053e5b1-6f65-4d1c-8e42-e4ac8914d135
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	168946903440695723882182721049165095963	t	0	2	16633	220290f8-3af7-4b8a-8440-fffcd8c95718
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	124445385690259922849876440325180989360	t	0	1	136497	7c6ce2ab-85a3-4a11-8e60-8725c1d940e2
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	132552562039483385267421560130780265204	t	0	2	16633	403a7698-3805-4d67-9865-ccd57f73f17d
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	141843589518875757596514109480867267090	t	0	2	16633	0dfe516d-b1be-43dc-ae29-8dc60cf6c024
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	54651557808288602698226421003698362987	t	0	2	16633	efa5e7a6-39b8-4501-8f4d-7e1e45b38e90
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	113046784967979730860020212748000411790	t	0	1	136497	5d2693e6-6629-4c5d-8a13-b34914601ac7
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	29630616615613629481895664783740874185	t	0	2	16633	f302fa2c-bbd7-4ca5-8cca-d3e215827d23
\N	1	cb1b9559126392f5a440563635104126	MD5	145174738749924312223766093907761755810	f	0	-1	13373	d2ff8407-6bee-490f-aadb-5411c8a7b105
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	66185688846766995383760643382836754264	t	0	1	136497	fe32d393-af1b-46a4-ac17-b2feb48bdb42
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	148459425015419996256606703268105080243	t	0	2	16633	21619c05-234a-4775-97c5-9b6ed4fd0f3f
\N	1	3e847c4a72b4523a6c587e08149d854b	MD5	129839104388612479515863261426859430674	f	0	-1	3977	d9b4c68a-0e7f-494c-a380-b089f0db9796
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	128530425423151619297403318652303716810	t	0	2	20661	6c84f31d-2d1c-4b63-8002-b9b3bc305623
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	158864684836574571182975410564759628051	t	0	2	16633	78d6cda6-454c-4b43-a5ae-38b0a8b725b9
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	84207221501228053935777741468903712058	t	0	1	136497	7bc3b082-844c-49e3-bb13-e5575abb06d2
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	113391284672177227351423349673555122610	t	0	1	136497	a3b7299c-f254-4762-9e33-2f05e41660df
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	49807551289751684164706672057627844740	t	0	2	16633	f1e4c38d-d1d2-4e98-8206-87f450f9345d
\N	4	63c92e91817aa44892a2d303ab1e9d94	MD5	103850352463233699080534880776079705916	t	0	1	886966	4879f6d7-301c-4584-b7cc-d5b7836a2a92
\N	4	f3893f072768e254eb5d9c040de8fa1d	MD5	134918974496696775061609509241819956820	t	0	4	1101304	ce4542c1-44bb-4c69-b001-37fc21846545
\N	1	51498efda63b10466506e1cd7a6edf66	MD5	33189474671620684999932201575014489588	f	0	-1	45196833	7933d957-9acb-4f10-b440-50d041bea0af
\N	1	d41d8cd98f00b204e9800998ecf8427e	MD5	148585200109312064439034685189570369632	f	0	-1	0	23c3b697-a4c5-48aa-9ee0-0aca2b5a1b4b
\N	1	a0b73ec1fc332822bb478b5d333dc3c7	MD5	66089112302832666106082502264243069623	f	0	-1	47867	4d5deca8-556f-414c-a5cc-051cfb1bc48f
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	76789705919834399043854022114530633590	t	0	1	136497	31744827-8598-40e6-9dde-103b5bc80985
\N	1	51498efda63b10466506e1cd7a6edf66	MD5	42841185883815415419366538423998270409	f	0	-1	45196833	5cd90407-6e36-4f08-b959-9ca3877719f3
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	100122468913547631212006294746640017115	t	0	1	136497	7b2533fa-27a4-4a86-9754-bb85d8ac28a3
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	67554746837735192014663663257509341834	t	0	2	16633	96379ab6-5aec-4af6-b061-d426ed0c5fec
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	108612330071495897346092144804616206480	t	0	2	16633	84cd1ce2-3157-489a-acde-d42c5b984924
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	114355287668858799275440022013809170123	t	0	1	136497	ab9be5fa-c94c-4df8-a5d9-544adc1cbe12
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	82787824498721843417863910768018567787	t	0	1	136497	41017356-8657-414a-a34b-658cdaff7d32
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	7570151252727903461479210179148832687	t	0	2	16633	22f28d7e-409b-4d08-a5c4-f066bd742da7
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	9263705951834104741485839927403012815	t	0	1	136497	2ea21b92-edef-45cb-9365-4b65f0b4c972
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	100152744891443825433576967570211097713	t	0	2	16633	ddfd79fb-b06b-42cf-921c-4d8699e0dd45
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	59666465123081756516892545798299774815	t	0	2	16633	cba03df3-54cb-4f65-9fd9-589599f6d691
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	108750218281018074719268783180893483819	t	0	1	136497	645247b2-089c-4214-bd66-bfcafee9b952
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	31468235994655337857009866621493271670	t	0	2	16633	a34ad3ff-1fcc-4298-825e-80c9a1189d2a
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	21372150890612024268044726578322338831	t	0	1	136497	1d28a233-a092-403f-be74-475b05d0b538
\N	19	1db9995e72eec14d1dadae51f7c652cf	MD5	37785453990720832087950055208723040330	t	0	1	13108	47176c3f-ace6-40e4-8011-aef1ed09355a
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	3139475652520603290972433175135424447	t	0	1	136497	8e149e13-23af-49b9-8048-bbdfc3dbc125
\N	2	bb9bdc0b3349e4284e09149f943790b4	MD5	78822224215395749797415701776905267900	t	0	2	1748	282545ec-368f-45e6-aeb7-3996412ce4b8
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	92643568504984357885847138461028342200	t	0	2	16633	f3db3e45-ff66-4280-9084-75319a78a7bd
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	128303365869177921251536004188844026410	t	0	1	136497	2aa84589-6d70-4a92-a39a-94825647ce22
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	137715804862726894493224647750645620177	t	0	2	16633	0f984f42-e8e4-4ba9-80f3-a0c238e99706
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	112105322800016211632933617394845748002	t	0	1	136497	e9a89dac-3598-428c-b2f2-bed507bb9932
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	33460237776983043295201463346070831604	t	0	1	136497	972c1540-90bc-457c-b6da-08590e3b2196
\N	1	82b11c4adf116bdb41ab4c304288945e	MD5	44455072390197481489923638918968149089	f	0	-1	3002708	42b2461a-88db-4e02-a98d-8458a466b76b
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	60296027580074686962736173020217294243	t	0	2	16633	617705c9-d415-4792-9e40-46aa57b2ca8e
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	30062758283053245667175721612206939054	t	0	2	16633	746aeb4f-bf1c-48af-b643-c7802460530f
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	107956565519629041276149835814615939907	t	0	1	136497	fb722c52-4945-4a97-93aa-544a1463cc10
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	114868944134943910546118149326634825625	t	0	2	16633	55f880f3-96fb-47b2-bd67-acb0d44bee7d
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	21793006959279554604589115729804659743	t	0	1	136497	578b73cc-e493-476c-adb1-eb48220cf22e
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	92134344925114078702030164396313354341	t	0	1	136497	a79a1110-d4e5-48a1-b188-b20a56be7f43
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	125411523575276995832982650474267836252	t	0	2	16633	6c492f47-d149-4d31-a9ec-7d9b639a7b8e
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	93227554164169886475282874915319686236	t	0	2	16633	ba5f382e-f920-4654-9b15-d2856dd407c3
\N	1	677effe3c2bff249f28822a2a3a01ab8	MD5	112358689557201641951167959523516621024	f	0	-1	10015879	b2a578e0-b503-47ec-8e93-f1641eae7e24
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	35200283986252149071431376177520721152	t	0	1	136497	f66aa4f7-fd31-462c-ada8-05e04fb83d38
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	5672994799446784570133782901067623450	t	0	1	136497	e199589a-7d7a-47f4-a3f7-ac3e2ba4331d
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	106790976810807599076914316779957856666	t	0	1	136497	0cfcbaab-0582-443c-8fef-0f932ae383d9
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	160119066243877383784602774027513737353	t	0	2	16633	f63e4433-7870-4c79-b096-38fdf005aaf2
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	61076366989208296803614840570081863101	t	0	2	16633	1051d35e-9542-4efc-8129-b51986005895
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	72502719606660311851692512112498584767	t	0	1	136497	b5c4b423-4c44-4f94-b052-2847559e614f
\N	1	b558fd725aced71b6fa030f66c8c0a4d	MD5	10656709385371435786612034009286269850	f	0	-1	148286804	a7aa7e8f-2e0f-45fd-bc7b-41608f164774
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	76719255026008680067261895040306459597	t	0	1	136497	944185af-ee0d-45ad-8f94-7e5bdad716e3
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	21552970423054779715381448774115111072	t	0	2	16633	82e3fc71-c762-495b-a9fa-e8890b8f9b75
\N	1	69d8242bd2029ee29a0e74b8cbcbce2e	MD5	165714739116475222421345884437923814775	f	0	-1	3977	20fa345f-5945-4364-a7b5-98c576fbbf8f
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	128071202949759593892699430167003204263	t	0	1	2618792	94c17305-6e46-4bba-a216-828c3aef4b6b
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	120866109594390739526600478202641168327	t	0	2	20661	81aa4974-05ad-4aca-8cc1-ffeb346058c6
\N	4	e8017870361aca60b3dfc35d9fc57bb0	MD5	48913950881700479377180157621597966636	t	0	1	91478	8929239b-2c42-4621-b794-0d30bcb86804
\N	4	a23c198f97ef004c8428e06ddbe446cb	MD5	156049834852882607210003989501274077300	t	0	1	936943	5e1b3cb1-d500-4e0d-8ea6-33b7284cb4da
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	46663611837489017072944275368939720816	t	0	2	1748	1279e41e-28df-43a4-b90a-bae99d59510c
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	84728498129665316496138462459211027767	t	0	1	136497	4a9b01a9-8a85-48a7-bbc4-21d8c0ec9636
\N	1	d41d8cd98f00b204e9800998ecf8427e	MD5	134489752276808344944983699604827512951	f	0	-1	0	b4528df9-6838-43d5-a987-e728e82ea1d0
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	43131635610484042353680254959889189226	t	0	1	136497	eeffd7e4-742b-48aa-a3bf-bde382bd35a6
\N	1	ecbe72babca917661d77936b2de97633	MD5	77374742394981049913777981412163208258	f	0	-1	47868	62ac2a5a-39de-4135-a25c-8365422a6ca0
\N	1	51498efda63b10466506e1cd7a6edf66	MD5	21641084860186382778023730518980788250	f	0	-1	45196833	8a6cccc0-a9d0-444a-b5c0-da345485e010
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	100206034860458357595277773531016432696	t	0	1	136497	3faa3045-c899-4762-b3d7-9d8739fbfc75
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	47381349487981091845732985065759185660	t	0	2	16633	e9c754ec-90c2-48e9-a7eb-ac415fd0a2c7
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	133291613527837332950237090525579470113	t	0	1	136497	cbd4986a-8eee-470d-96aa-6add33867dce
\N	1	efedab8ffb24b8a4adc67b022a505d96	MD5	138087658747578502320552867651479957443	f	0	-1	50879	4fc00d69-fcd4-4ded-95b2-bc82d7da5f63
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	154354869606852405407993015716048221036	t	0	2	16633	6eb05ea0-ea66-4000-8b3c-9e47bfb27f5f
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	124060466646325734736788935559613437659	t	0	1	136497	6ac11558-f863-4d39-9c0e-0f591c27a10a
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	102256085526670687813897351396075986148	t	0	1	136497	a12cdf22-3b15-4193-bec8-f889305e6440
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	58252825426101963751267254879800911879	t	0	2	16633	48847277-3341-4566-81bc-42f98a884468
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	33917154789335022390526366584184971903	t	0	1	136497	ea81121c-6488-49b6-a2e2-ca52c57b6b17
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	43219852853580499788762427511995101197	t	0	2	16633	6dfd8bff-bba4-41e7-b852-0a8cd0d56853
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	6801817872510392867104205307759765793	t	0	1	136497	1bd47e73-3f3b-4b9c-a459-9be1a58349a7
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	55963484309994139749463325131303946072	t	0	2	16633	aec93c34-08b5-4386-9765-8c76fe5961fd
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	121655989830732241237546129335288751505	t	0	2	16633	e613b74c-a8ec-4b47-a68a-c39b6f1a980e
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	160210300569585612207355582694102962110	t	0	2	16633	dd30a8ba-3a2a-4154-ba4c-a5fceb5e56cb
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	75838264896874268603785477305284704283	t	0	1	136497	d9fb79c0-898e-4354-abd7-c5755b26bd5e
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	155900271011634794146097853132192061041	t	0	1	136497	b8a1904d-cbf1-45c7-b29b-c582db2aed47
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	35229963184315065550695254719226481906	t	0	2	16633	8bdd8b5a-484f-4fec-a451-7698f24a1483
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	66378604516735127173845253677579090642	t	0	2	16633	a4f93140-0eca-4ba3-8f1b-b03ced84925b
\N	1	6f53cfc988a923064c7d8b9a0c383d78	MD5	115073419184161802545618393953210043356	f	0	-1	351	77ecae42-7ae4-47cf-bd46-46ddbb69a862
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	130342307589394785979671274792870805599	t	0	1	136497	8c32763d-39e6-4883-9853-d54628cea3e2
\N	1	abc6ceabf45920f13832444f3466076e	MD5	2486656327377084092635578909776787063	f	0	-1	51095	260fe481-1993-4195-9b6d-83977d7ce9d2
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	34252949735035044861149586423256413881	t	0	2	16633	217da3b1-dc2a-4cc5-b65d-769695058501
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	66661114055364777044230982911113176276	t	0	1	136497	df26b968-1e76-4bfe-b406-b7b4593934b7
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	67538574940487765173647709354121248147	t	0	2	16633	66088f72-ba20-42f4-8a02-0ad84e3870de
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	150807506139711484315126896512599345124	t	0	1	136497	7439df16-626d-4f30-bd6c-03841806a3d0
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	98349387266136248471781629888834977987	t	0	2	16633	d213476c-63ea-4871-a860-d0413c0f5037
\N	1	677effe3c2bff249f28822a2a3a01ab8	MD5	63085168916724120083575990381862215342	f	0	-1	10015879	baecae16-b3b8-488d-a525-49dfbd060e76
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	36120377059830512217233604119174875485	t	0	2	16633	940def1e-38f3-45f3-8ddf-fb971fdbbeb0
\N	1	6c362b2b914f5f348d1cec75836feb07	MD5	93971796366644911302228458557631949398	f	0	-1	336	bf936c92-b0f8-4e93-9ac8-931581d3f15f
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	77851718478494092584245813849588231831	t	0	2	16633	755e21c7-1602-4c39-a5fa-5046dd7de73d
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	13148947887347344323308377137286049086	t	0	1	136497	2e5fe6fb-d466-4e39-beb8-085f3009267b
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	57892373795092292848429093129314836155	t	0	2	16633	9a6eb543-a1bc-40e5-b6a7-f703cf7464be
\N	1	b558fd725aced71b6fa030f66c8c0a4d	MD5	2849220613759625094914468705549862083	f	0	-1	148286804	fe337f7c-54ed-46c9-b5fa-84910f1e2282
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	70023570727586917613736275257011094153	t	0	2	16633	c86891a6-fc5f-4c7c-a620-b72fd2f06531
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	29048353555376241993458618306194523211	t	0	1	136497	97f2c0cb-fca6-4458-8ae0-71f4db932b64
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	37469902608148184497760671805661715782	t	0	2	16633	93001965-f3b6-44ec-b4a6-0d5d9204032f
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	158992336837797899528488309647529225712	t	0	1	136497	6371239e-2dcf-40fb-b630-2459ca5f569f
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	22582771790976545193554904732449215889	t	0	1	2618792	e3d7d763-c625-4c24-9cdf-4d89079b13ec
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	133005758735973630792662825273257455564	t	0	2	16633	4a2d9bcf-1fcf-4673-8a7d-2e88499b7008
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	130317356889139938353506223294664203457	t	0	2	16633	89288969-324a-4b85-8926-c8e8e442e6e0
\N	1	b558fd725aced71b6fa030f66c8c0a4d	MD5	47307823883980007695614965134234344409	f	0	-1	148286804	95b580c3-d3cd-4e48-9791-e2d8ce4a2330
\N	17	cb3740fbbd94844b8763b00ce6c2a83c	MD5	135814736314484230552885588851020371488	t	0	1	296066	16cc85e9-aa14-4314-9bb8-ea3b27835e3a
\N	4	63c92e91817aa44892a2d303ab1e9d94	MD5	27060247548319240570490097664032313216	t	0	1	886966	41c8a3c8-da11-4e1a-a3f2-67702395e463
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	163490009619251830758839507294567766842	t	0	2	1748	396a66a1-7c0d-4e66-bf79-cdd3f7a166af
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	18324064984070645971139459953667407822	t	0	1	2618792	37ded630-defb-4a86-b8e4-4cef64e64c7f
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	145854511452950134243839705197005597815	t	0	1	2618792	5bc0fbfc-0a4f-4207-879f-f75dd79ec933
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	92922217715787700792097900091128598520	t	0	2	20661	7d4cfe6c-37fe-4ebf-886f-98296beca018
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	153387398849066182691555427351607617059	t	0	1	2618792	2c97f2ed-5fbc-4b2f-a464-c9a310a7bb5c
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	136723779626401978721696449980268164553	t	0	2	20661	82a928e2-e66b-44bd-bae0-d9995a2c9bba
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	163298281246202246287216121097681725975	t	0	1	2618792	7266d530-89eb-42f4-b0a0-ffd80c693bd5
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	11468151450055790882466206490341724432	t	0	1	136497	bbce4a1a-766d-4c7a-91cf-52018844276e
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	28359339003449075159023586221833481811	t	0	2	20661	df1b5f2a-4337-4f48-9705-2643328c4cc1
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	106489270183755100905704053373409318781	t	0	1	2618792	bc6db9a6-06bb-432b-8cce-1f190564139a
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	73059571030835722836943813969046103522	t	0	2	20661	6987531d-294a-4ff0-91f9-649731bd8494
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	35682751632538153729766700595657800258	t	0	1	2618792	602488ce-3c6b-4fbe-b921-00f448830e32
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	65128060454834027395179518955625144017	t	0	2	20661	b91f4002-8b25-4b77-8387-417738e516c3
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	42535354194750110301655612280296956794	t	0	2	16633	4787776b-2a78-4109-8b63-f37eea5157c4
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	34324145555574171935552552329512708594	t	0	2	16633	d62a9eb4-a064-48ed-9d74-26541a46e7f8
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	11407425762157108212324703175973371660	t	0	1	136497	c0d78b5a-cab0-40b5-bbf5-b116cde4b170
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	158134996277150264281066165753530425270	t	0	2	16633	9a436b7e-1add-4301-bd3c-7d3b198d9b39
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	125666253515467729470403814519302562719	t	0	1	136497	1961d363-a764-4f34-9ece-61c0fd5e9d1b
\N	1	ab509b46c02dde4e4dec205c374442e0	MD5	102322471581039488143661671788265409538	f	0	-1	13362	53a1b46a-67e0-4105-97fc-67e4bb53f294
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	145840929045181838243944977175726287189	t	0	1	136497	dd57b1d5-b78c-4715-9b36-2bdf8a787178
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	31577548513739017666006528300729116563	t	0	2	16633	a2768559-f246-4a74-bd60-cb054d8a443c
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	94117647377771849067620847680847552723	t	0	1	136497	15a0d76b-518c-4fdc-907e-2fdc7ea2b5a6
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	163329411768843572125575996035231674913	t	0	2	16633	4b5e1986-a44e-4d68-9556-b5a17e917a97
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	163813419637064988456259350242885369422	t	0	2	16633	7f884d3a-e152-4458-aa89-e780f66f67c8
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	128379547182218602677518904434433055000	t	0	1	136497	74832c9b-bf81-40b5-b1d2-5ac6cd59f694
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	141373778627456375702725449346408702632	t	0	2	16633	4305f503-8b1f-412c-973b-f756b5b8c8ed
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	28736553157311165189435525404061874949	t	0	1	136497	8915b673-58c7-490e-9f1f-1783f3e96113
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	18869860870720731462178418411481301805	t	0	2	16633	599f87bf-f0cd-4480-9043-94b894e38515
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	158046560546459691118341027844903159500	t	0	1	136497	a9e5888f-7d35-470d-9467-2483347b0d5d
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	20822543067072771906891047412453021699	t	0	2	16633	70096eaa-ab76-45cf-89c7-b99a5812481b
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	100774421726768994067101558744327626000	t	0	1	136497	48cf9db6-bfd3-4e0d-a529-383678d7d054
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	12489517832279931063081136699035867465	t	0	1	136497	ba394fa0-e13f-4501-80ca-f6bae04f18ef
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	29649446623235449412717490710318500527	t	0	2	16633	946f5793-c741-4db2-87d3-bf77e2c3432e
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	95673427973944199166152817936615751864	t	0	1	136497	97c0e6b4-f3dd-4f0f-b25f-1ec357f841e8
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	147842492860565477480103469560000941461	t	0	2	16633	aa3ebb74-c0a8-4ba9-a676-0fb4ed213864
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	27926008626651531864977124347088432669	t	0	1	136497	a482526f-20ab-4fab-898e-203ca539a8af
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	76350427681993757803545027203487116616	t	0	1	136497	581b9dd1-32b6-474f-a777-717c3dc0e639
\N	1	dcd3387aa1be73f2bd5f082eb7940f0b	MD5	1064306878433998889878379640245773062	f	0	-1	4087	bf5ad438-914a-48b9-a745-39d5003c6d14
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	154871403224396337702499415633707834499	t	0	2	16633	3ed45c32-2637-42c5-b616-1ec2cdf7cfcb
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	148910385872016080748638110509029623131	t	0	2	20661	579ff05c-b3a3-451b-bd98-d15a5e937ecc
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	31207504578727869418687969995068953835	t	0	1	136497	24b73c6c-f534-47cb-96da-21c99bd7a0c6
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	134537607687806075034298796445116461589	t	0	2	16633	03a98ae0-f36a-4e21-86fc-ba30b958dcfd
\N	4	783c1243759698a2f971ba99e10a4c91	MD5	18033891798062886677699746749862103857	t	0	1	30568	64a70e24-4f1e-4afa-9935-9e61dc27658b
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	45847967476395187649602674481696502766	t	0	2	16633	b2fde49c-0193-4a08-87ea-9091f100077c
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	97302826892283441886955230685390523678	t	0	1	136497	5fbcc128-a675-4438-9140-b6aab16159dd
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	148570352456343078575959143046448433612	t	0	2	16633	aed73850-f650-4482-a3b7-8c462cdec415
\N	4	63c92e91817aa44892a2d303ab1e9d94	MD5	21077021704175469249805146258057521703	t	0	1	886966	324619d3-2742-420d-9bb8-26392c6656af
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	18099354880004608581378199166791709161	t	0	1	136497	7c11782b-e283-41c1-957a-4dfeaaad5546
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	59308324179517710251237232978267818946	t	0	1	2618792	e3814d8a-92e7-4f1e-98bb-a2c3c98255bc
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	35177181780497239871954180014886477926	t	0	2	20661	15bdd673-bd8e-4b84-b360-286b197f98c1
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	98568979999611032212474915507130284446	t	0	1	2618792	91803a00-67f7-45d3-b768-58bbfad4b040
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	35416632001727630584774890343463441260	t	0	2	20661	284947be-468c-4b66-a3af-f7eeb775404d
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	152718537113136307223462697795254933123	t	0	1	2618792	9071ed6b-50a2-4d60-9ffa-f956fc3edaed
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	77748760807404937807550431079828844119	t	0	2	16633	b7029c71-7698-40b0-970e-9ab6fe40716d
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	36888966889628788296931915907510966464	t	0	2	20661	66dc77ed-e46c-4199-9040-bc8cd7dfbd6c
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	590497659264368645783303824614286358	t	0	1	136497	cff717f3-cc93-493b-8b1b-b375972a80f1
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	70455760343285321548704753324869458186	t	0	2	20661	f9520aba-221e-4489-a377-7e7293efe6be
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	82163496288842272038503869173324969706	t	0	1	2618792	acddc971-d4f9-4663-a5bd-bc8a20bc37a0
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	163161112221778792565330091271128159208	t	0	2	20661	a8929ffe-0324-4679-8d37-2e84beb4cddb
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	137919199922407933215333340559030280116	t	0	1	2618792	ee7d5213-150c-45af-86e1-1dde5da6fa2f
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	52670949399272621422533956417253494954	t	0	2	20661	48f648f6-9993-414e-9833-d5f305f3fa1a
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	47987943758502317052763668515008032122	t	0	2	16633	790c2cf1-453a-4fda-9dc8-d1c4d31af8a2
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	141813719509600861388333564208785147704	t	0	1	136497	1c90b189-de22-410c-9d8d-8d1cbd1f53a2
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	1579530621709732381317389760464758506	t	0	1	136497	8201866d-18dd-4d5e-8d34-27d35c520cad
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	158150101607220722875788582880026499264	t	0	1	136497	0ad736fc-5ac6-4f94-a79c-b04b686a1fae
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	48789644992305341829869996479908655805	t	0	2	16633	9a15b0a1-ada6-4741-86ee-1015034fff05
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	163745175233801800181616911229443898249	t	0	1	136497	e70867bf-58ef-447d-8afa-b0267a4434f3
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	5620729458273935806879039338289628855	t	0	2	16633	317d9961-e788-46fa-89d2-4841e0ce4339
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	138146477132499846329980884681599685210	t	0	2	16633	a3826a71-232b-4111-b49a-79b630d20add
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	69517556058336918474050665030318768884	t	0	1	136497	30ea521a-5b8f-4bc0-89e8-7aaa63794a1d
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	35730969269603355536196298497443028527	t	0	2	16633	a98893b2-b0d5-4628-85eb-3982246bff6e
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	1595724040091441262633955452665303989	t	0	2	16633	a5bb816b-4512-42ee-8f7c-ec2ab45afb95
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	146957270165146127835332355305373380051	t	0	1	136497	3a1c1fdf-62bf-44ac-a333-5c5a852dc99f
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	159405053622297573389867388387259550299	t	0	1	136497	3dd4c076-66fb-4fb6-b0ca-349873c4279b
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	8069743443380083039073292501834043187	t	0	2	16633	94ca31af-bd87-4b0d-8a2d-fd4f6cf74de1
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	68945809819167120737160809674075329163	t	0	2	16633	8e949bbf-c38c-4923-8199-da187f587eef
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	37380211788718725813669146399631312412	t	0	1	136497	ea40b4f9-98f1-46a9-a580-782e5d21e629
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	66342228877652007991196749730545807483	t	0	2	16633	a5095e1e-0c6c-4a88-b94e-37cbef9dbbca
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	97586829506555459655882271741321618241	t	0	1	136497	88472f44-fde6-4687-ae8a-6e55c7ca063c
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	54408846943304841324072976504171827291	t	0	2	16633	79f93cd5-e77f-4e1d-afb5-bd1a737652a6
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	118541503066463240483476792568581619789	t	0	1	136497	abf9251e-0028-496d-9203-6b635eccbb7d
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	15167687393346649107458823515891128090	t	0	1	136497	627bbb3d-9477-4479-9450-5c9ae43d3270
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	135831188966701405941515085565854475389	t	0	2	16633	d1797c56-97e2-4b6c-8cb5-88f723fd426a
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	31587131592505854365420185004035550145	t	0	1	2618792	0326ba01-b36b-4335-ba22-c368c402d1ab
\N	4	f08dc2c97fea3d543830681a84c67451	MD5	127910847514818175724079112431192671898	t	0	1	310738	9de6c77a-bd54-438a-a594-542cb8bfeb14
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	36042527096145850982077760224256307127	t	0	1	136497	af07dcd2-963f-477b-83f6-7d5539e060cf
\N	2	bb9bdc0b3349e4284e09149f943790b4	MD5	22007175754653715306228513926146693239	t	0	2	1748	bfbc4aa1-5c4f-40c7-a53d-a49726a21ea0
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	117586281954298996102773631385116168039	t	0	2	16633	807be89d-3c22-46dc-8d42-edbeac43eec7
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	123432715952352447837994892877983245329	t	0	2	20661	7a353843-eccf-4ddf-83c9-21bc99ee0a77
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	37122757116103406379408029651981619653	t	0	2	16633	eb30d2f4-991e-4a9f-bdc0-8d3e322306ed
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	162519706387555872065673525208479943197	t	0	1	136497	c453bc37-9fca-4a5c-acc9-f17112581e94
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	43690647343366811076301842840790192474	t	0	2	16633	eae97bd1-3e85-4ade-8936-94a4d7b50dfd
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	132011727895345303680446606170976624841	t	0	1	136497	93ca862b-b651-442c-b6fe-fb11a0b13c7c
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	131305687257447930127918698730873646283	t	0	1	136497	9f3aafd7-04de-4286-b536-7e2906470f01
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	124605347409657757671202640574382627272	t	0	2	16633	61d5a3eb-2d3d-4695-9464-65076c32bdfd
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	94380253543965626749000470993592163097	t	0	1	136497	4e278de2-2b03-4351-b067-44d8ceab32c5
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	40749340617209680101408765777961567506	t	0	2	16633	1340521d-15eb-4d11-a849-ab9a11ea7bfe
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	76261289543118983929617265925669067167	t	0	1	136497	775ee888-0a6a-4c12-ae26-f80be4c39700
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	39155426933241413628085874600428777018	t	0	2	16633	58ed75b7-d93c-4dea-ae7b-aa676e8aba55
\N	1	f9c85cf271f97a87b40c419c68b73785	MD5	127891140738645814659610446993151069061	f	0	-1	351	bc37b708-d924-410e-8ede-cecf2588907e
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	45024762436062646557989729073469495283	t	0	1	136497	121c00b6-0488-4e1d-a6ce-90efd05ada9f
\N	1	2b7bb7ff9d0c09ff2c0a93c1955243a2	MD5	12789254202938766508754808484860619534	f	0	-1	51095	c0da6b8c-4ec6-47de-b494-46335e099b36
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	4131427042497458884460083999930818439	t	0	2	16633	ac10cbdb-0b6a-47d1-8bf6-bc01f62ed954
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	1301620768832621288263594648927334511	t	0	1	136497	33f53947-29f3-4166-9394-589883366c44
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	97726823048036697100478132180844315427	t	0	1	136497	5cf12e6e-3bda-4470-98bd-032506bc49ec
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	108720331662157357598132969376579489409	t	0	2	16633	854fafe5-67b8-4e7b-b6ba-aaf5a61404cc
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	26805728829926105484344017322339004143	t	0	1	136497	97b38cc2-d549-4a62-9dc5-ac5981dc5441
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	94996016526449138746988238543357761322	t	0	1	136497	3bf0422f-a88d-475f-8b82-e41fb2d49645
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	30737993819521167454539551542727627059	t	0	2	16633	6a64361d-703b-4b6e-9fca-728b9db967bd
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	110526901592998683164079732568931659738	t	0	2	16633	d7c189d7-914f-4894-9676-12e4ac88b083
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	60609798089121256951019516954433233587	t	0	1	136497	1ddaf4f5-030e-4493-a246-5d1f2596e780
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	18650992124401608542949631567833865279	t	0	2	16633	4c79696d-23c4-49ef-bdfb-959d590a9c6c
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	85354124107885663273526896793748853406	t	0	2	16633	c0d46ec4-2e3c-4d72-828f-0c326392d66e
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	4935587216219036908210425080977925232	t	0	1	136497	66864f6a-b31b-43c4-8abe-851ed8a1f6fb
\N	4	f08dc2c97fea3d543830681a84c67451	MD5	97148860505152647414952289757338791404	t	0	1	310738	606dae42-11ce-4648-857d-4d1ac691ad1c
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	42308430153834733005197541280795250868	t	0	2	16633	3d0b713d-3a3a-4491-b3d1-3bba4634ba3c
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	118982331042079027810547385031740839463	t	0	1	136497	ddee10e8-607d-4e76-9756-282448c0412f
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	16595095232356997745870993755880867268	t	0	2	16633	7715bf66-77ed-4896-bd10-336569150627
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	10620933670744690397269146687415196660	t	0	1	2618792	7f7c3c88-b517-405e-9238-6998163f9b8b
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	160105056335483017828483136050804371467	t	0	1	136497	1e9eb0c1-86e1-45e4-b5f3-154e64de1237
\N	2	bb9bdc0b3349e4284e09149f943790b4	MD5	42288832235741767740728549115838366199	t	0	2	1748	7712dd68-d472-421f-afa2-0a723cb7bcbd
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	138981488273536540374679042133543424191	t	0	2	16633	24c55af1-e9fc-4c2a-bba4-46f29f9ffa68
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	87667520951139552116047488179978961784	t	0	2	20661	26227059-9eb5-4db1-8d62-d6b6eb25d61f
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	58562303115367103136200016063730061985	t	0	2	16633	0c1a4dd0-f998-4dbe-900f-948ec285e720
\N	1	970aeea90cdfcf61e365b3da9b571f22	MD5	144768060488673937794723107013100847097	f	0	-1	7905	9332be79-a9bf-4463-9f63-46c590148f71
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	29760822062436979158279359649103463659	t	0	1	136497	2e5ffc83-b8a9-4fbe-94f1-60279bac8546
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	91034742695671082373190217309749803581	t	0	1	136497	c2baa239-08bf-4d90-bf5c-698ee81a5ee2
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	1559199413887180685001189850655806613	t	0	2	16633	953ef6aa-c5cd-4167-a23b-3beed5973129
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	46686035169192650731181117092445936867	t	0	1	136497	d8b6b680-1d4c-4a23-94b3-e3be30bcbd2b
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	61647584384734389127657576551798239466	t	0	2	16633	5ed8269e-2c7f-4436-84e3-e17670893fb8
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	47153136197759974963646762225487315902	t	0	2	16633	17028385-3c80-4ffd-8b59-af83266effca
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	121784129426654651812913953252312096389	t	0	2	16633	272bb69a-b2fd-4d34-9b4c-d7152b7aeff7
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	30298296983592733048779188477691461680	t	0	1	136497	798cfff1-3c9d-4144-ada2-d478d6a1d2f2
\N	4	a99fdfba66d656ea3e026c593573bd28	MD5	81735970780578463318182429585216136334	t	0	1	77460	1058f8b2-81a0-4240-9e2d-380e4709be1a
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	115705298563027146792158181653170742431	t	0	1	2618792	bbf88ff8-71f9-4b90-b37e-c889bfbf3e15
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	24470149696209000927472125015531527539	t	0	2	20661	beeec6ad-0a47-4491-a756-71bb3fe35a4d
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	81402732898558370537032705628212705419	t	0	1	136497	955e09e0-6fe8-4209-a85b-86650f8b1469
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	103121002076214520627294905496101079478	t	0	2	16633	02b692ca-36ba-4aa3-84d0-ac3b2acde399
\N	4	f08dc2c97fea3d543830681a84c67451	MD5	96006286781244287549468432594784731840	t	0	1	310738	334c5590-fac7-4be3-a885-e0b060a54451
\N	2	bb9bdc0b3349e4284e09149f943790b4	MD5	150223726602343443137977828498701133688	t	0	2	1748	9d5b6b5d-ebb8-436f-a2a5-664137b3c574
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	162404309949417768409952121527070737963	t	0	2	16633	172f5313-b4c3-4a37-8f4a-e33c18e6a619
\N	1	554c9ad85fbd7a671e698ac9703710a6	MD5	53753285512773677037865264088854840730	f	0	-1	351	73c91a17-da38-4194-a03a-43dd8902879a
\N	1	1d4f9b880ec64b61993441f36967bbc8	MD5	30803439752571937863189659197004601404	f	0	-1	51095	e4f1eaf5-471c-4a1d-9dfe-78d16daef96e
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	159593438756917676400840200680446128286	t	0	1	136497	5b11fe17-90d3-4923-8b1c-5dad34738ff1
\N	1	b558fd725aced71b6fa030f66c8c0a4d	MD5	139137141676653163950224081332622918278	f	0	-1	148286804	9fadeecc-23a6-4746-9ec6-80f88db4a86e
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	27366049228393170491210787740623773776	t	0	2	16633	5126a452-3c01-46ff-af8d-522d02028f58
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	69307502039666785431242009402659732471	t	0	1	2618792	668fce16-e7d5-44f0-bfbc-086892a8c715
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	113692204440660611563205278943525667763	t	0	1	136497	c9e28329-b399-4f91-a5be-91019d9c7156
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	98138302342425543491340083882822107995	t	0	1	136497	892c82bd-b0e5-4525-bd28-d2d0cd4bf0fe
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	32686514392974485160775735242957904102	t	0	2	16633	ef107604-ea81-4be2-822b-b1d1b55dc8a1
\N	4	f08dc2c97fea3d543830681a84c67451	MD5	115825002251042273987941034854612213747	t	0	2	310738	1bc1dabe-c142-40cc-82c8-c6cdb87c2d2b
\N	4	f08dc2c97fea3d543830681a84c67451	MD5	125874275336040198479027157538247545132	t	0	1	310738	30c7f6cd-cd70-474b-a771-ba591a8eedfc
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	28952378952812951961052717324053913340	t	0	1	136497	4aa4e915-2555-42d7-a10c-47874e03773d
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	43725174989352499108372951038603790758	t	0	2	16633	9665163c-4d2b-40f3-851d-b291b7832e70
\N	2	bb9bdc0b3349e4284e09149f943790b4	MD5	70788782339636274736436388902833374460	t	0	2	1748	3e605773-48a6-48f5-834a-de4fd0f8a665
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	50690699880016149416016543469620400137	t	0	2	20661	8151579e-799a-404c-930f-3ed7fedc5061
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	124572987835939511178532286698410590330	t	0	1	136497	4606e7db-13ca-495c-a731-c102fde7807f
\N	4	f08dc2c97fea3d543830681a84c67451	MD5	156842391553192500142016039094842204113	t	0	1	310738	51de9ec2-5e5b-40f2-88bb-e96b0eeacbd8
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	21688661321123821333895304219329236856	t	0	2	16633	9bcb5e8c-04b2-480d-851d-70becd5133e4
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	163488340719992161159508187300784609962	t	0	1	136497	2bd926fa-672b-4447-b401-1991b7a38597
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	44219256060085745918942444075186434799	t	0	2	16633	164d4687-3c9a-4230-93f6-51c42ecfe77f
\N	2	bb9bdc0b3349e4284e09149f943790b4	MD5	72778933766025363656830724497569052082	t	0	2	1748	231bd961-8e68-46be-9257-b468cc2e6056
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	51912364947618884990324570974020823203	t	0	1	136497	0f451b96-3fa6-4a83-b4dd-ece659065aaa
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	132744584473517042650939961204556366555	t	0	1	2618792	5ac8c636-16ee-4e20-970c-6295a80a8015
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	77677233078924901699196103550146322053	t	0	2	16633	925f9e60-9f66-40ba-880e-5fe6ebe910a6
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	85005001120592816292839806599131813543	t	0	1	136497	2064cc71-7de3-4278-8fd1-66bce4053585
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	20815105492028962652631497286725408191	t	0	2	16633	286a2279-6b8f-4cc9-a02f-ecf711dca598
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	134809169290136314370447099083674653369	t	0	1	136497	b3147518-aa06-4922-b4a6-bb37795ef666
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	27017860438650411699215850702208178011	t	0	2	16633	f518920d-bfff-45a6-a46f-2c78bfd468f0
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	137891840152161843540982641095577032936	t	0	1	136497	04dc80f1-2416-43ed-81f3-27b6902cf3ee
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	93668369581244135400837239331467558897	t	0	2	16633	0c46654e-ada7-4643-a347-5a2004900eef
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	52838485412649500816655650972272154547	t	0	1	136497	9932e9b9-9240-4443-bde5-c78435f012b9
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	121558131605119098700407465347836862829	t	0	2	16633	1c6d7d32-6720-4d00-8735-95cf036361e5
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	169241661392348764755337972280498074	t	0	1	136497	b6a742d9-d791-4702-8a8d-037a6a2ab8f2
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	83420834310455340223516411975846061148	t	0	2	20661	0df40261-c6ad-468d-bd10-a957c2a0c1ff
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	27843382525909116396597749407245143275	t	0	1	136497	690ac130-4f66-4560-8352-5265946a862c
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	87457807087286622796827739216009351528	t	0	2	16633	d26e1415-349b-4d02-bab9-2d8de4f45658
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	12087359413871670956155178886114938028	t	0	1	136497	70c2ff19-13e1-467d-81fc-f8f8b5796815
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	47031491884248712661091910988963701945	t	0	1	136497	832d214b-56c2-42ed-b852-d6a2f6514eac
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	26663573264884515429157162848898760965	t	0	2	16633	a5ac3c4c-9fc8-4197-a565-4c058be8a90f
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	77998358420148763613779940768226697229	t	0	2	16633	431a07af-e4d1-4346-bb93-a716aadbbfdc
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	151026033284808361102129590423641281268	t	0	2	16633	dd246496-bc36-4c0e-a793-86175c3cbfd6
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	131211680333006116899898079890016498247	t	0	1	136497	3506cf42-35b7-4334-a689-69b52e11ba24
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	46913611284938232199287808339413767911	t	0	2	16633	b9203636-80bb-48ee-9a61-e03c54c77c78
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	92989830740822897304803491788788697053	t	0	1	136497	df1d7905-edad-4905-92c8-b7765e5dc44a
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	114392350483791833606896142248457896042	t	0	2	16633	5498b778-064e-4f58-9535-581cd9d65b1a
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	3114964249558328154355166562174655481	t	0	2	16633	61befdce-d4ee-4ad1-a9bf-7c842001641b
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	10893335825813168158340803465003541799	t	0	1	136497	3415c94e-c84e-4019-894e-9059ee2caeea
\N	4	f08dc2c97fea3d543830681a84c67451	MD5	159274008205995426161004809964261424718	t	0	1	310738	005555c3-b10b-46b3-aa86-5ed4a2f08d45
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	99069346905907344889170797504309850578	t	0	2	16633	8fc4a8d7-bbdf-4208-8c8b-8b94dd287c7b
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	123538780718972605124699921744054565624	t	0	1	136497	d11e1c1a-8383-4490-8b8e-8e7ae4bdb695
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	128262097632314460600295882133636254941	t	0	2	16633	94707d18-7819-4c2e-854f-ac319bcd8f5b
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	122196307191391243199829950757543982213	t	0	1	136497	96935de8-df24-4a55-9892-3e45bb15cf0a
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	120204676240262422840593980147301125867	t	0	2	16633	c99822af-8411-4077-a8a1-4ec275961ffb
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	39341147587724111373501653411366880501	t	0	1	136497	948b694f-41e2-4b63-8f94-26c6ec1148a1
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	107973851223720530458945783502685495625	t	0	1	136497	40960c3a-f33d-4461-b67d-94bc8d6761a4
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	139822636052989369810115264490354345522	t	0	2	16633	d63365c8-9ee2-4fd7-aa46-fe94ca9371f2
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	45243620825526253125796536647399394547	t	0	1	136497	2319e588-bb37-4159-9f3a-86bd9ea03125
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	107159117172973893987404353019453768797	t	0	2	16633	0f5cc091-9c15-4e2f-92c4-8088f3e83ab1
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	87291979785846457860784832231612853106	t	0	1	136497	d3400e69-c271-4cbf-8178-f8a91bb3b715
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	166774065078089962538578495818802698799	t	0	1	2618792	03454abd-bbab-460f-a616-629e1424747d
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	71838607376992694786401106918171874292	t	0	2	16633	9e796582-8629-4e90-84f8-ced978e2670c
\N	1	df6ecdea9b12debfad9d22cd27845684	MD5	145145121348833281746135962017594883417	f	0	-1	351	68bf4655-e163-4dba-bce5-95abee17ef5f
\N	1	53578ddf6edd7cbdd013f5a3008ab836	MD5	77057030391842075455937086844035550387	f	0	-1	51095	1dfeffdc-06e2-41b1-a7f4-4e7be6425aa2
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	161695158055614626945868641496775732311	t	0	2	16633	725d945e-1b00-4a89-8eca-631800bcacf9
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	150133682087575004348740498226410133874	t	0	1	136497	f1fc8252-7480-421c-b91f-7855c2f0cdd4
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	46972539321750963508907055027451496327	t	0	2	16633	ae7896f4-2d94-43f6-a184-fba9a1070587
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	106124718483806331891079281197787535951	t	0	1	136497	9e7eb8d6-5b00-42a3-ae42-6d00f5924121
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	19945811973867742479014956633997758603	t	0	2	16633	e0edd021-dbe6-4b24-8440-ed83277c0f59
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	134589729490225676191211114492017904013	t	0	1	136497	93afd952-aa8a-45fb-9782-74f0f0f826e4
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	15868044567644181041118844711914074555	t	0	2	16633	6bef3fe6-f0ea-4882-96a0-e89209ebeec8
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	118644319265156969941666490711667316383	t	0	1	136497	b26f3744-c739-43ac-891e-ec9f30e20bef
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	75090799753788934928951290080051023868	t	0	2	16633	f1a95d81-73b6-407d-b7c2-61858eaa8604
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	78512537943488517463917818758958391525	t	0	1	136497	d3e563e1-5166-4bf7-ae05-6c9442f2770d
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	98377183221664679341907198721572207846	t	0	2	16633	b9ccf895-a5b8-42b1-97c8-ee3782d2872f
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	19992421802818439840346022132531335362	t	0	1	136497	d3e09a07-4144-4a42-9372-34797fa2d322
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	81967817155270412311862599382487397074	t	0	2	16633	2ceb9a7a-dea2-45cd-9adc-efaab51fb99f
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	58103165648862870764150179612691691561	t	0	2	20661	3bbbb0f9-ec17-4942-bd3c-a888cb7d4363
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	120296191302313191893693572990785644748	t	0	2	16633	c9bc8ce6-50fa-47ff-86b4-a370a4618e84
\N	2	bb9bdc0b3349e4284e09149f943790b4	MD5	157299235660700519455575744136319920248	t	0	2	1748	bdbd096d-b4ce-4930-8d61-fd4c0d951648
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	66566629800228007722035976941488727583	t	0	1	2618792	06b7b65c-af7a-4da7-9351-47d371792e13
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	50451315047698395854132347152015971321	t	0	2	20661	37477732-ebe9-44fc-ab84-d6112c468882
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	112618780398314851591451309351941859714	t	0	2	16633	832ab46a-853a-41e2-bf9a-70410a36159a
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	81989576337552443921869389644626158094	t	0	1	136497	6c8409dc-17fa-49a0-bc68-d2989b1064e0
\N	1	82b11c4adf116bdb41ab4c304288945e	MD5	121741605516178808600132095277289374453	f	0	-1	3002708	40391d5e-e77f-418e-af02-58bdeb8d7549
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	58078806922358090955559636536231133932	t	0	1	136497	d57e9191-6a4a-4c19-af71-305e17910222
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	39273093453661953332187756194875712802	t	0	2	16633	190ddc62-718c-4067-9985-295c454453f1
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	105904229271292489306820736874111791115	t	0	1	136497	5b6eea42-32f1-44fb-ace7-bf87e5558a27
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	154518044758065888925889259600078330953	t	0	2	16633	70f794da-073a-4e68-9855-ac3cc2c80816
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	43771583586137319992284515695970662232	t	0	2	16633	2dd3d78b-6dc0-4e59-8734-4a4506e82503
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	125960930008398368016042542376420643523	t	0	1	136497	ecb35dfd-f93d-4aa2-a6ec-e8944e5da20b
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	21486226152635497862517070421558700091	t	0	2	16633	20944134-a900-4791-8b5f-5236d78db692
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	32452863030746610301503621807097246046	t	0	1	136497	8794fa1a-3b42-4064-8d54-49671f2aa6af
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	95101701801545276574773799895587128007	t	0	2	16633	86d1211d-52eb-458e-91cc-8b2eed6fc351
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	50451203734913403330555290572148297666	t	0	1	136497	dd211663-7328-4ed6-8b2d-81e57783620c
\N	1	cefe73165135dc7dd3123f68635e26cb	MD5	112522915574460347236131840352569774324	f	0	-1	51095	f71db8ba-9806-42ab-9eef-fdeb1ac0cd1b
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	150248685235948182391641898006854767303	t	0	2	16633	b3a4add8-e41a-4069-a61c-d0d7debf9940
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	163864503049413654263099842834778204972	t	0	1	136497	102bde5e-6611-4466-8e83-6dddf117cdf1
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	64353489995129213725593103122599047385	t	0	1	2618792	a2927947-ab1f-416d-9ba8-2ddc56f759ef
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	106965710095471514822065135111136317088	t	0	2	16633	abae02dc-52da-48ab-82c4-51cd3af9131e
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	60716877974221641260511366734977439436	t	0	1	136497	28369640-9916-48fb-b53c-afd5b602def3
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	46106982363060340369338153310524229117	t	0	2	16633	65cb50ec-e02f-4fc3-b653-e3a351ab6f8b
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	51797679450455574462549499350366670396	t	0	1	136497	97ff5936-6bee-4b7d-8153-46a4b532ba4c
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	61815831236731259506619202568117785767	t	0	2	16633	84364eae-925c-47f5-81e2-71a7d9605cfa
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	64633515872188513712199852131011171979	t	0	1	136497	2e6da491-2416-4a99-a85a-cf497c1ab27a
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	9247675848615045609351820986798357888	t	0	2	16633	074ad4c5-5f51-4921-a500-900633716986
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	146336944177318277870434993039635558705	t	0	1	136497	4fdf00cc-3a18-4b77-828b-448de32661f5
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	136012686986423655705795201298087825990	t	0	1	136497	c5c167e1-81a3-40c3-9a78-5c3ac0195cac
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	51828809916311402419157158678783205528	t	0	2	20661	f19a5b53-68bf-438b-8f09-f4e4c9f4aa03
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	13106592376597450944668513752519893439	t	0	2	16633	9896432c-6e80-4610-ae46-938369c422d5
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	41458391303902577166627856935219064958	t	0	1	136497	55efd320-ba92-4ff1-b684-6c7657ef3e5b
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	167392766620210441037267056803680838604	t	0	1	136497	3afd2234-af3b-45a6-a3cd-3eeb48c6b40b
\N	1	a918b383df2d2b95e5c4498febc81348	MD5	52659825327487573354228005760785517041	f	0	-1	7905	71f93610-2069-476d-9d56-53583fa637fd
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	131859858516734355655567154132102533230	t	0	2	16633	95e127e6-70a6-454a-b09a-75ccd8f6cabe
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	151688486178329406699786335970913111162	t	0	1	136497	c5708068-8d34-4c90-acac-7b56905ae13d
\N	1	4d738a134b29aca349a10e737ac898de	MD5	115636655283376659304499688797160900839	f	0	-1	351	ad00438d-cda1-425a-998f-b1986a6a5b23
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	111578066451880901662250924507084037815	t	0	2	16633	02a8491d-0960-4850-9890-7ad3e61675bb
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	152393209233167012279466977373936054909	t	0	1	136497	3ffbd55c-a192-4418-8d01-a05a9e4fd47c
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	160606612209812787489825586460506590884	t	0	2	16633	a792f69e-0d93-4bc1-8e67-10a65564200c
\N	1	6051df7d94dfe6fe0bdbdae4ba682c6a	MD5	143124766652495232455192047975811888783	f	0	-1	7905	7259b601-89f1-4a1f-8fc4-56926dc068b8
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	61573047602106201111326538236761797147	t	0	1	2618792	dedd95f6-4bee-4b51-84f7-74e6c552a7a5
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	11322016066236962596016068720427422432	t	0	1	136497	70df4ada-b630-4acf-88c7-c06c02f7c5d4
\N	1	b558fd725aced71b6fa030f66c8c0a4d	MD5	30865778485421960410198932264963611253	f	0	-1	148286804	1e8ca0ca-52f1-47f5-9df2-d65b9670500c
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	143237545665082257708536205895816465431	t	0	2	16633	735e2e8c-b4a2-48bb-b431-708b299e3635
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	102413341535781638082703625007354795775	t	0	1	136497	80956ab9-6fcc-47c7-b4b9-e6e6e74c2af5
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	169769442057570628881078236237623072471	t	0	2	16633	30e830b5-4a6c-4b66-8d94-fa53cc39c827
\N	4	f08dc2c97fea3d543830681a84c67451	MD5	95657978793314838763464709684650269213	t	0	1	310738	47564b19-6fc8-4189-be1d-9b385bd60387
\N	2	bb9bdc0b3349e4284e09149f943790b4	MD5	168639757227303479789342411358693637635	t	0	2	1748	a7bc399a-5542-428f-8687-f9f462592d12
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	37423100663619765182536443969247185776	t	0	1	136497	d0a31804-ac18-49a4-b18b-91192ee180d8
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	9442587353040795040520342614810305561	t	0	1	136497	558bd5ac-460f-4443-9b9a-65421a026cf4
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	149949319851790086422142147171227439526	t	0	2	16633	3b5c5489-f5ef-48dd-a00a-10b34f8490c5
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	125458627867119666913602211023895528026	t	0	1	136497	a44e707d-0581-4aa5-a395-aeaedd263a36
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	145782214718690892424857630432420596944	t	0	2	16633	2754079c-f239-4bb1-9cd1-49b621ec908a
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	154506458608996174444310271848281074188	t	0	2	16633	2133a31d-afb4-41f8-b110-a16fb544096f
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	132369824377877088532920499539551349415	t	0	1	136497	2e84d08d-42c2-4c74-bb09-af495be7a69f
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	114617192632720680567144018336995183461	t	0	2	16633	8d4f00e3-5ab7-498c-a413-7de4b878cdf6
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	66948388736862647280715188984596020447	t	0	2	16633	b3e32231-4638-46e9-a47e-970ab57aa92d
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	154264818199113131915206485048840606011	t	0	1	136497	51290f10-8d57-4fd8-bd6f-63635d99e961
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	119105429843036885833966453287242511539	t	0	2	16633	c297d50a-40f5-477d-9c61-e94818ca0d17
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	58383745008899794358467514343989052326	t	0	1	136497	b536a7bb-a624-4d8d-9efb-132886fed5eb
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	146523823565534637635540152417232583291	t	0	2	16633	ad79e6a8-faf8-4d81-9fd2-b17166fd716b
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	32040566040014073505091669984937748963	t	0	1	136497	d86d3ab7-9ed9-4a49-a120-26d5a268a1a6
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	66261196204495185851414049247659475646	t	0	1	136497	05be9bc9-cef6-4cf6-a40c-13a224fb925c
\N	1	82b11c4adf116bdb41ab4c304288945e	MD5	108355590097201901727837916795795812302	f	0	-1	3002708	de3c5f7f-4550-43de-be75-113437c79993
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	114059986408266010605789654109552627382	t	0	2	16633	26081a3f-a320-41a8-860e-611bc0c9f92c
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	14801823959025407332240307955665531712	t	0	1	136497	e6a11a4c-7229-4c35-9a69-ba40cb9f6792
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	138036393252754674235744223007345196376	t	0	2	16633	1c4a4467-f236-44e2-9b7e-f3e6e21f3e47
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	154422612888542923835490442192807958417	t	0	1	136497	cd7fcc21-4cf6-4f7a-a81d-d865a540d04a
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	83512484368667547041805900862280864780	t	0	2	16633	75c637f4-7784-4779-b7fd-1d3ed1b5771f
\N	4	e8017870361aca60b3dfc35d9fc57bb0	MD5	1457989903330383463104697292791028250	t	0	1	91478	99a0c2d9-b0e3-4c8d-9aef-d1ea3468968f
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	12589087365018724685544793882782001624	t	0	1	2618792	5d9c2c7c-4a6a-44bc-a8ee-e61499ab5c21
\N	1	06c8feb56eda6dc3931efac12bd7d3b9	MD5	162554552757513890337438051919068695942	f	0	-1	7905	a657695d-ea87-4431-b5da-c5386bf488c5
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	158803005093748045707756957440734633516	t	0	2	20661	c9815ab5-4e93-47d4-aeb0-95ee1743b05e
\N	17	e47c6751955ed41ae008e7c9fb98643c	MD5	165532928645645972711210627747631291366	t	0	1	32410	d5dd99e0-fe2e-44d4-b166-d0731b4e7d5d
\N	4	521f1d71e24698cc06f0fcfa7883e56c	MD5	135467826337090434297603256103494067989	t	0	2	115327678	d9152df1-b642-4b9d-b442-d4e68ba906b4
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	109441461634994328904887175854231801369	t	0	1	2618792	cb0a053a-abd0-4df0-b5db-a2cbb8b67f4f
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	150224273161800926801266108183275927869	t	0	2	20661	07769881-d9fd-4b60-a264-e977862853f0
\N	2	bb9bdc0b3349e4284e09149f943790b4	MD5	126516105392583560599497237680634595616	t	0	3	1748	296e301d-2985-450e-b70a-f1ba7026500b
\N	17	cb3740fbbd94844b8763b00ce6c2a83c	MD5	289055672088621744689273017247049923	t	0	1	296066	0dc4795b-e6e4-49fc-80b5-092be3795016
\N	4	f08dc2c97fea3d543830681a84c67451	MD5	88201309472467041888607207136331562271	t	0	2	310738	9c0c36bc-5986-44b6-9fa3-815e1c701927
\N	2	bb9bdc0b3349e4284e09149f943790b4	MD5	133177921217923328479784706784132557283	t	0	3	1748	acdbed73-7ed9-4f94-b844-6b41edf61cf8
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	4204499527139087719522630642463231129	t	0	2	20661	789770ad-9f31-4f1b-8fcc-ca1cfd0fdc2b
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	57448438438949028716538388030143706098	t	0	2	16633	2d20f866-1481-425d-b0e3-ee9a2ef878cf
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	86802213746055114462384125766363149355	t	0	1	136497	4b2ee089-b546-43fd-9eee-621db0ef0f86
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	23713461050350068206314816518814390912	t	0	2	16633	8d4da577-bf45-4b52-bbd2-d5825795f2e0
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	98283943956310467554858762790930867109	t	0	1	136497	ae108eb8-e0ab-496a-aa97-d2c1f51a5713
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	87002208061703487036914757637248694987	t	0	1	136497	54d9d5e0-c9c8-487e-8c88-6c53d03bd3df
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	130068862995915688379029842638669090363	t	0	2	16633	36589b06-e6b5-43c5-a2e0-98500b16fcfe
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	36186672795273071859989354266245219337	t	0	1	136497	f6c28dd7-3f4f-444d-b74f-cb4ebaf04a38
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	127481751727293171447282528013329149339	t	0	2	16633	21bf492b-169c-4df7-b1c6-e72d0e775c8b
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	154590463590250662025849484556365685532	t	0	1	136497	e26e653c-d5c5-4c54-aef2-1d7b54ab41e1
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	69309432626793960071143199772849023233	t	0	2	16633	e1efdab3-4574-4849-9a19-31a650d8d25d
\N	4	c7027c65f05b69cc74b87cffb7c3dd55	MD5	47458254151779648335570895931408653311	t	0	1	5444940	7f4abd5b-41d3-46eb-bed9-d31b4486a597
\N	17	98ae60e69f271d929a616143cf975557	MD5	21654380955405087483274477040849595017	t	0	2	15479	efbbc983-fb6a-4146-9cba-a825f3becd2d
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	100626575245289635007770103853690049861	t	0	1	136497	0ece619e-fea8-4ae8-8206-b07e73036b11
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	10309266640778595048258017531797075782	t	0	2	16633	84d492d9-ada6-425c-b727-3933e658e493
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	113174899262869677722214650614180484298	t	0	1	136497	d88d94fc-573d-4bb6-b719-31eef7fa21a4
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	31246579921500505685242643482931018288	t	0	1	136497	c6205ff8-1a9b-455b-b7b3-fe40cc16f615
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	92412314312842591002588119558233729151	t	0	2	16633	1401c408-a4ae-485c-b94f-542224fc43c5
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	87546159091838191047916185268330137152	t	0	1	136497	d6e1e341-68cc-443a-a1f8-34f483ca059a
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	37769585211714432862814224144448953865	t	0	2	16633	9f9d43a6-6930-4a1e-8280-58c935d3220d
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	125880031076257259980689574926291646003	t	0	1	136497	eaf4c41a-c8e0-466c-a1bf-0a6f0fefdc58
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	59512770312332103825322044413164071872	t	0	2	16633	9b656b9a-4613-4eab-bb13-8a8832348815
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	102184656448403007413291394884694872502	t	0	2	16633	f11caffa-c6e2-4c10-a14b-d456349a9204
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	134805451687988154149671708040831290198	t	0	1	136497	9337cf8e-1249-4500-960a-2477a3f1b62b
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	44780839970388413266307560263303811215	t	0	2	16633	6e694892-cbdb-4da2-a837-2fb3b60034e2
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	87827464885315966419972509899347447637	t	0	1	136497	4f026a84-2a2d-4127-950f-454738edf405
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	53345051674906870943502496969163992738	t	0	2	16633	c89df378-d7fb-4ead-b304-36cd19e249be
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	167119057623831187691655167196954382622	t	0	2	16633	e99ace79-12f7-4ca5-b2e7-acf2a4b4f3ad
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	46824567307872412059489458581640751941	t	0	1	136497	59c54f47-70da-422a-b786-5c59b93bbafe
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	88019530316195730092254638757095368121	t	0	2	16633	fc4c0596-29c9-410f-9488-2a8dc7eacc1f
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	135219305973627846594228834745777699826	t	0	1	136497	66553ae7-14f9-444a-bb84-cb60bcea4ff9
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	105129365991306438456628841870234443008	t	0	2	16633	b3f58243-10c9-48b9-bd11-1704840ae26b
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	101758373177983432005023333206335960499	t	0	1	136497	adeb5507-ea74-409c-a25b-defd9de863cd
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	121449360799856812881465273566008026501	t	0	2	16633	788e30aa-0009-446f-94e6-4ba84886f5c2
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	20368981534708760207939926851892376948	t	0	1	136497	401fff2a-1dad-4f01-976f-421412d25e55
\N	1	b558fd725aced71b6fa030f66c8c0a4d	MD5	112709952650681626925317921447152428184	f	0	-1	148286804	050e2056-3eb0-4067-8632-b0d290b2fc7f
\N	1	51498efda63b10466506e1cd7a6edf66	MD5	23504545645019390924679766158592548058	t	0	-1	45196833	a3d94c88-cd80-4474-9c09-9b7c0f96000d
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	113492321587870055510956701393222490246	t	0	1	2618792	63f0007f-6a43-4eca-9bdb-deaa68ab9805
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	31142990898639774678019370315150406272	t	0	2	20661	062717c7-b4b0-4c4e-931c-d5aea432e364
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	108604043009954246506248934764497677345	t	0	1	2618792	ec6f5345-d5e2-4eab-8aac-0de64398f3e4
\N	1	6096ea398261c6b3e0e903ffe79170a9	MD5	101818858446563540158863955820358718319	f	0	-1	351	bb2a754c-c566-4510-9f48-5e5018fddbc5
\N	1	382c98b7da7aa6c7123efa8f90c17361	MD5	82813142276911828973059754328258190631	f	0	-1	51097	a8d1e084-4006-4c44-97c0-6c057796fb89
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	163455974058605186551787735068581250435	t	0	2	20661	b5cec853-d46c-4347-9821-7346e003a3fb
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	107894459355437316784019662389945527610	t	0	1	2618792	5037a9cd-26c0-4e38-abe1-815419894e41
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	19034374523287667233290226427936238322	t	0	2	20661	98f7e11f-4a81-4f75-b47c-1cc77b8bc319
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	106920952645905924652098983363812371240	t	0	2	16633	5dc2f6a9-5c05-4faf-950a-0cfa608ca05e
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	143805302165899372347383126306014143956	t	0	1	136497	f6d14e81-168a-4eda-b1ec-e49f04170c91
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	57542239957465771659081854673596283728	t	0	2	16633	78a622b7-75a5-4fff-9494-f34e6b6c7206
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	47191910889032463063623212714623934857	t	0	1	136497	88597d60-341d-497f-881d-5b21f975696a
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	65190730616857449527329913662952761824	t	0	1	136497	25605338-8012-4e2c-a5a6-72d3ba777629
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	11782804838265480503159307275953875003	t	0	2	16633	08f4c844-e18e-415f-ab0a-15073d4f9e1d
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	118186270709602940398093718660194603909	t	0	1	136497	1312441d-446e-4a9d-90ff-251674caae2d
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	20822795424624174801951110225788654899	t	0	2	16633	ce215474-f67f-466a-b763-528c26d1db76
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	98121564316643499327241078852142897957	t	0	1	136497	b02d9b7c-286c-4474-9825-ed73654482c0
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	127469087940384481570145149638735995356	t	0	2	16633	13efa4f6-c0e2-4d7a-b487-f3061efecf2a
\N	1	3e7bb7dd2fb4ded3901988e310d87c57	MD5	61636915470031631601407958281735938484	t	0	-1	48184	b6282c67-d08c-4b9c-8d3b-18f45e97013d
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	155693690683104991826609806063675212422	t	0	2	16633	9c1b725c-e932-4366-96ff-a723778f6765
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	106932309547033070382483746257209058297	t	0	1	136497	7ab0e0f4-a473-4c6a-9ad6-b377d48a2ae0
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	153771411578225727639194308024000071559	t	0	2	16633	2420bf11-a8c1-4013-9264-88a7aa3c95c7
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	70054239519900884757702156680353943838	t	0	1	136497	71651dfd-393d-4843-aec4-4532a85bb06b
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	120974858687685539682530412683459035129	t	0	2	16633	d20258be-2c41-4474-bf4b-23340c78dc22
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	30444967393434475669996256794130311936	t	0	1	136497	3da477e3-3bd4-411d-b20e-591b2fcf0721
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	150611354450731435866024815344144373499	t	0	2	16633	19c1a6b8-191e-4746-a5b1-d1db7eb51a1c
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	11813698339111690353027907808250901403	t	0	1	136497	39ffb9c7-1486-4610-878b-93a3c065e9a3
\N	1	32e6a68fda6983a8d4e8cc55ed02c449	MD5	115505025270232649257461976639802167657	f	0	-1	351	46769403-937c-4267-aded-006c27fc19a8
\N	1	f75e1becedcfae8be58784e4af56c1ba	MD5	56948528998543756110813501928754601969	f	0	-1	51095	0e9afc9a-ce26-459d-88f5-74c96e5a7796
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	61366193283149485697264127409012392218	t	0	2	16633	ce3049f0-4449-4663-b1b8-d7c4ee471bd9
\N	1	b558fd725aced71b6fa030f66c8c0a4d	MD5	58419046003393527815433502228320632603	t	0	-1	148286804	94a19d0f-f836-4b87-aace-08fa0adeb3b6
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	146408990282556302421377048177649972561	t	0	2	20661	829da235-86df-4b56-9c66-ce8b58180e61
\N	1	fd6597def80154fb71fa9cc7f4027e20	MD5	95477416577452692047369043509208398892	t	0	-1	351	85faaeff-8112-4887-9b42-1ad7eb2a93eb
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	75458215157237485551439856578333368980	t	0	1	2618792	77c87321-9eae-459d-a9b1-787b0ac55695
\N	1	95aef802d22a6afd90b8393c9d4fd632	MD5	55640126443436680237667044693911025075	t	0	-1	48186	0c1dd08d-1d3a-4158-abbc-935013772a8e
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	21882684613595707011693331726858106442	t	0	2	20661	a0f861f7-558e-451b-9f08-311417d631a1
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	102189984433968244752875633577810292975	t	0	1	2618792	a5523989-af5b-4ae9-bba3-8f6f91cbf5ae
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	146349067991317038994696605238092538736	t	0	2	20661	17424e41-7d15-4631-89cd-f3c955911e79
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	40195987435717281143513720021505534524	t	0	1	136497	a51fcc77-8ca5-4bc0-aa4b-86b9703464ca
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	97966011759245332689894012608571101665	t	0	2	16633	9501ff63-812c-41bb-bab6-da2d57b27f1a
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	135386940718039198911956981497455340665	t	0	1	136497	b152c321-6354-41af-bcff-84c25b5f84a5
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	61057885571961535533903895526724903725	t	0	1	2618792	b5bc28d6-33ce-4375-ae49-25ef1f8f585a
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	132665639776806736897196356652770045597	t	0	2	20661	f09412c6-7100-4645-9976-9870f9bda0af
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	84314651652618516579571741245898271926	t	0	1	2618792	8a9703f3-02b9-4e0f-a37f-53b810a7dc8e
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	25355076106571272712620822169570141179	t	0	2	16633	ffbeaa0e-17f9-4ce4-b9a9-fbd3edf235df
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	61262402057575428828607935437031438673	t	0	1	136497	f095b815-e75b-4e55-8b1f-eee1638a18aa
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	84554838015808000741547687728092563073	t	0	1	2618792	b58e5a82-5491-4651-8ab0-c9ded00592f0
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	140836495175993153809709967852140790441	t	0	2	20661	93481a0d-e8e3-41f2-8592-f2a548432e43
\N	1	686141f6be4f66a0256452522490e00d	MD5	31936568904560043049326217739294531390	f	0	-1	13431	faae6b89-5b63-44db-9b26-fd912081f9eb
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	56554967215794815473973950885360474793	t	0	1	136497	fb4bc5da-f3a0-47c3-b030-ba251691a602
\N	1	82b11c4adf116bdb41ab4c304288945e	MD5	134542931595181819281222913048003175552	t	0	-1	3002708	3d78308d-f318-4868-b9b0-c72b4c1d762c
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	40164425423349735273944798489253678293	t	0	2	16633	f8cd187a-40bd-42ee-bbc0-a3d78a057063
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	145443080950049407295705908038942519573	t	0	1	136497	f5a715b9-161a-43f3-845b-fb586c66e899
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	117300607927492077995056605263360224045	t	0	2	16633	31d47bd3-78aa-447b-b32b-2305501492c1
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	10790945208752374656616062379636401620	t	0	1	136497	5fd52188-ed21-4119-b0ba-82cd959c1115
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	169486303130432140401555869792107960805	t	0	2	16633	0b5ca965-1f39-43f0-a14e-63ab068455c1
\N	1	82b11c4adf116bdb41ab4c304288945e	MD5	45812174268709034196193438595528750191	f	0	-1	3002708	749b2588-ec6a-4b43-a04d-8413d0073ef4
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	65313914654261794501527017361480344749	t	0	1	136497	6d4bef11-2a4e-4434-a1b2-08bd50a50993
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	115008765543408595677340664080271539514	t	0	2	16633	9c04fe17-ecea-4436-b6cf-c15c7386fd7f
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	133383016173072497194536833167966582894	t	0	2	20661	84ac0db8-d480-4d08-abbe-bd667337e5d9
\N	1	1f5c1696704646b11398ab0ee26810c1	MD5	153275665301443707987254940930935548497	f	0	-1	351	a8f82864-d4ac-4f05-9c75-891704699547
\N	1	f1a6ecdb591f571795817e9914d33916	MD5	106514606344314817255418022183066449878	f	0	-1	51086	3909dd25-4d13-4777-9972-0c5f55dac187
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	22430966989778615354677298485148940419	t	0	1	2618792	4a3e2b8e-70ed-48ad-9193-b2f1174b9932
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	169177676643580327128345152752259693922	t	0	2	20661	8494484d-6cd9-41b3-bcad-eece9cf18b13
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	15603374341403016558343122686789471435	t	0	1	2618792	5628b26b-f6c5-4986-96b9-4f8102238700
\N	1	b558fd725aced71b6fa030f66c8c0a4d	MD5	93455608113210459793085066381803865472	t	0	-1	148286804	edd7938c-a7aa-4d8b-88e0-19c829cd284a
\N	1	432581017cbf1b7d787ad194d6711240	MD5	102528105158232042707464735013114775857	t	0	-1	7905	27eab72d-1ae5-42af-9659-3c5393f92e26
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	35159287529811463789725885185845773766	t	0	1	136497	4b9fed14-4557-44e9-a269-557436fd67dc
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	130455805914773033554464426288277746261	t	0	2	16633	2ccd277f-3b3e-492d-b8cc-13e00c7f4f53
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	70876312406151014917487417887259434633	t	0	1	136497	f74fe15e-9531-4615-8890-12364744b727
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	60071945829375360452162367473297266436	t	0	2	16633	fd1c4b8e-c499-4c12-8606-0be3ed8492e6
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	109686972854651720823997443917923334087	t	0	1	2618792	b3cbbb84-0fad-40b6-9e65-7be5eed8b1aa
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	75936871974306121061646956404680664103	t	0	2	20661	1864e625-ec7a-4449-a2dc-50c3b9593f81
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	136934634289721651150633021449584769325	t	0	1	136497	f707d146-3253-4deb-ae59-ec792d8aadb3
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	20897040590007571874761419178601060304	t	0	2	16633	86a5a3ad-9a3b-409c-acd7-4e7bffd60d06
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	155773528796693831023435309903151710535	t	0	2	16633	c4a3190c-4ac9-4e42-8ecc-428db8ee6f64
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	124430848513107144910825286264305226515	t	0	1	136497	136c28ea-e267-45a9-ab88-659de1fd3fad
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	111305758201324898183174140604985752518	t	0	2	16633	ccde08b4-7101-45c5-98da-05c5290aaf50
\N	1	217b72918b368ee9dfdd4a01b6a63820	MD5	49608399524897377426220025035654328083	t	0	-1	54	849b24d4-fe7c-424f-b74e-5e03cc341275
\N	1	2950d5e2d684c57cbeae99f85454e9bd	MD5	148041532496944545253012348576250073771	t	0	-1	6853	27ef9d33-1cc1-414f-8a4d-3da3e6cf1915
\N	4	a327e0b31c0807542b2638de75f5006e	MD5	132561296956043076941574119055504178607	t	0	1	96257225	ac467984-2d0c-4c2f-95e7-c14098a20c9e
\N	17	7561d19c417aa6751e7f1d44be7e55d3	MD5	129529531769658250215848074550095932408	t	0	2	11923	d1a87b50-c9ed-4ab2-85af-cfcc7c6042db
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	103949125098153601443585581358644650415	t	0	1	2618792	bfa9793e-40cc-4c04-a763-a954b639ce34
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	86964545069555159992640525701830588137	t	0	2	20661	d790964c-aea9-4e7f-991e-4916b37135c0
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	139208010038446510224004483587457646876	t	0	1	2618792	96bb0667-9322-4b3a-96aa-fc825ffc39be
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	141084577523674206779577017609930282968	t	0	2	20661	6786bee2-c0ed-4e1b-a6ec-4e2e4e904312
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	162682965854196409631183329646107144837	t	0	1	2618792	7f78e932-3381-4875-8610-8afcb146e5c5
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	123943145936783285314582520244506741180	t	0	2	20661	77cf5e35-e1e9-4120-b069-fee8d0d1b803
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	93168051624021308398974774204133764588	t	0	1	2618792	0050395f-524b-4aa3-81d8-ccf668cdb6f5
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	146914431498277873322358634915580336114	t	0	2	20661	9e6da3f7-5785-4828-8fd8-b283b7be4fd4
\N	4	f172306a0979471c64796248ba38a8d7	MD5	163264564534816070380902231626197980640	t	0	1	65408576	ade67968-9f48-48a0-9cc9-b32aff32c8fc
\N	17	bfd5dfed4d36705acbfca64f9766bd2e	MD5	114577757964771916731124102478298887414	t	0	2	15117	0152a07e-c9c8-4bb2-8fd5-73c20ba4d3f2
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	97270950042562602907573209665948566146	t	0	1	136497	797f69e5-7e59-47db-a6a1-fc247e07a798
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	164224774850657812795173409119854626517	t	0	2	16633	762584ed-da5f-4245-8656-afef7e60fedd
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	149490409832859894968695085270807527812	t	0	1	136497	6a40acc6-567c-4c69-b804-305097e67edc
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	77004695744635474874809944845543897222	t	0	2	16633	a622d0a8-c49d-4138-9577-28e8d49f5e27
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	114020667767148673048344001157965415396	t	0	1	2618792	67631fae-5814-42c7-9970-427020293dd7
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	54055096275992319419593101621172497916	t	0	2	20661	fbf41327-2c15-4ad7-8ea0-d97c79e82d30
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	99412909808364843796022453281991652699	t	0	1	136497	f8860317-72bf-4bac-ae5c-f7984c32af9d
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	120472160100652062050052801681595179669	t	0	2	16633	8fb16f11-546e-40e7-8b14-45297d266fda
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	169137203189665714629256894458797524235	t	0	1	136497	260ca43a-a55a-4e31-adf9-d61bc532e07a
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	63466884112022464754863055527675979359	t	0	1	136497	e306ee66-741f-4252-84f3-4c23ca8561de
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	138196895165220114597911643332473719213	t	0	2	16633	abf86b5c-3d67-49b9-b89e-4a6976e15b5d
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	39954736052954688937705013855909146879	t	0	1	2618792	0f20bd41-39e2-485b-9f29-827c2f048239
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	114043093062175943086142677410359812902	t	0	2	20661	59200dc7-3a0e-434d-b358-4337044d368c
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	71866102489195569798043563308966485904	t	0	1	136497	9612d2aa-0209-41c6-a8c2-c44dced19b41
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	10160068770248316681706884891601138099	t	0	2	16633	083f5923-07d9-490c-a7d5-a1553f3c1fe5
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	164470337913951700733012075623327958891	t	0	1	2618792	051c5124-c9d4-4202-b402-d9466f18b6e0
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	7138850919070302813081171549016711767	t	0	2	20661	4e3e4112-ca7b-4a72-b7e4-ddf6a19c0c95
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	101374362604727804326657372985664319316	t	0	1	136497	7cf9a466-4cd9-40b8-a8b1-242f5e1f472b
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	20637147173034612315531586238757594330	t	0	2	16633	e7a486c6-9568-42ea-8787-50cf7e8d20d7
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	20218403323685006192459083765032800735	t	0	1	2618792	269f262a-7335-4a05-b7dc-c125e309b851
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	25330345713407935062305703677042984403	t	0	2	20661	fdf5fd2f-bfa7-4529-856f-2d56174a922b
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	133210586562022923975120633182377996089	t	0	1	2618792	790e72a6-df8d-4389-9360-ea6f7f869869
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	49113679072758459835556053295720953099	t	0	2	20661	3c921302-1a45-4345-905d-124296663213
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	3724876796609592992162427164347780251	t	0	1	136497	a941fcd7-003c-470a-bc6a-aa8b4e9a5214
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	148886712338526217586364707817899674007	t	0	2	16633	cfd694f0-beb0-46c0-8f1f-766b0ab768d9
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	90333061566225171338562451535304712805	t	0	1	136497	f4b6e624-cce6-418d-8f9b-1cdc3087293c
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	16179061672256602877550763023700081895	t	0	2	16633	c1b34b63-427c-4fe6-9ee1-60d0f5cd557c
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	101204262355630813231669171193476699256	t	0	1	136497	48c30b1e-4d78-45f4-9d0a-0c94dae9b37f
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	83524960935351111601283211095551327976	t	0	2	16633	11a2c0cb-d51d-448f-b34e-eb5bd66ecb9f
\N	1	5a7546ba98fa8f7e4d65c108559013aa	MD5	7428589303110301800165822570694550422	t	0	-1	351	e7c058f5-2ce4-4b87-8fb3-d70e0b79909f
\N	1	0945a119424e0e8048ce219f872f5365	MD5	152528169953295750744559188202479797213	t	0	-1	51086	2dbf2014-aa30-491e-bc65-4f029c04c2e2
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	62185248113648487933336820609546469171	t	0	1	2618792	622a88d8-f569-42e3-9a32-93b6979b644e
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	16634552390333762953631623835836781243	t	0	2	20661	e06bccd1-3970-4bab-bd50-309ce99298bb
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	143429095528509011546770764629272984248	t	0	1	2618792	1ee11a67-c5be-49e3-9fbb-1b57300d4fba
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	1005670415462524276882149100855331225	t	0	2	20661	16105dd0-806f-4920-b1ed-a48d5c189279
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	104162762759369295819696523374815697093	t	0	1	2618792	798146ff-2d95-4ec2-a1ee-6937cb633149
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	73500492085426788649091459132213503680	t	0	2	20661	fd7f9029-730b-4b82-81b6-42f2da629f03
\N	4	f02860c9881864f0a02ad7ac833f2194	MD5	82758415244327264841047380296131249331	t	0	1	136497	f27379a9-0de7-4953-a292-d2428c8de11f
\N	17	196bb0ee94cec1de69c8cddf777fe39c	MD5	56790244753486742561688564216401132497	t	0	2	16633	6128043f-5b63-4ae5-849c-f4e0c8270799
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	145300933224694632597860355581984817272	t	0	1	2618792	02305490-a724-445b-837f-271a51d14b30
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	35190417518530517049367239475564237312	t	0	2	20661	dd781f83-90da-4bc9-b775-c9f68d6ac134
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	41986706386719917701442799691943310700	t	0	1	2618792	54d4b402-17e8-4901-b804-e46e8ee93f7d
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	7388825570814437981626878392636998959	t	0	2	20661	3246e7e8-4851-4e95-8d91-b907e18e2c2a
\N	4	f0925b06350b0eb370cc94b03b28c2f4	MD5	62173841217382948924530352925254371881	t	0	1	2618792	512af019-3dd9-47b4-b28b-5d677aa1b22b
\N	17	c60379f49cdc1ac25e5f33e46b54eb68	MD5	103550237661658049165750427022936763351	t	0	2	20661	c1f71397-0faf-4f59-8b6a-3a698770fd68
\.


--
-- Data for Name: bitstreamformatregistry; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.bitstreamformatregistry (bitstream_format_id, mimetype, short_description, description, support_level, internal) FROM stdin;
19	image/png	PNG	Portable Network Graphics	1	f
1	application/octet-stream	Unknown	Unknown data format	0	f
82	text/vtt	WebVTT	Web Video Text Tracks Format	1	f
2	text/plain; charset=utf-8	License	Item-specific license agreed to upon submission	1	t
3	text/html; charset=utf-8	CC License	Item-specific Creative Commons license agreed to upon submission	1	t
83	image/jp2	JPEG2000	JPEG 2000 Image File Format	1	f
4	application/pdf	Adobe PDF	Adobe Portable Document Format	1	f
84	image/webp	WebP	WebP is a modern image format that provides superior lossless and lossy compression for images on the web.	1	f
5	text/xml	XML	Extensible Markup Language	1	f
6	text/plain	Text	Plain Text	1	f
85	image/avif	AVIF	AV1 Image File Format (AVIF) is an open, royalty-free image file format specification for storing images or image sequences compressed with AV1 in the HEIF container format.	1	f
7	text/html	HTML	Hypertext Markup Language	1	f
86	text/javascript	JavaScript	JavaScript	1	f
8	text/css	CSS	Cascading Style Sheets	1	f
9	text/csv	CSV	Comma-Separated Values	1	f
10	application/msword	Microsoft Word	Microsoft Word	1	f
11	application/vnd.openxmlformats-officedocument.wordprocessingml.document	Microsoft Word XML	Microsoft Word XML	1	f
12	application/vnd.ms-powerpoint	Microsoft Powerpoint	Microsoft Powerpoint	1	f
13	application/vnd.openxmlformats-officedocument.presentationml.presentation	Microsoft Powerpoint XML	Microsoft Powerpoint XML	1	f
14	application/vnd.ms-excel	Microsoft Excel	Microsoft Excel	1	f
15	application/vnd.openxmlformats-officedocument.spreadsheetml.sheet	Microsoft Excel XML	Microsoft Excel XML	1	f
16	application/marc	MARC	Machine-Readable Cataloging records	1	f
17	image/jpeg	JPEG	Joint Photographic Experts Group/JPEG File Interchange Format (JFIF)	1	f
18	image/gif	GIF	Graphics Interchange Format	1	f
20	image/tiff	TIFF	Tag Image File Format	1	f
21	audio/x-aiff	AIFF	Audio Interchange File Format	1	f
22	audio/basic	audio/basic	Basic Audio	1	f
23	audio/x-wav	WAV	Broadcase Wave Format	1	f
24	video/mpeg	MPEG	Moving Picture Experts Group	1	f
25	text/richtext	RTF	Rich Text Format	1	f
26	application/vnd.visio	Microsoft Visio	Microsoft Visio	1	f
27	application/x-filemaker	FMP3	Filemaker Pro	1	f
28	image/x-ms-bmp	BMP	Microsoft Windows bitmap	1	f
29	application/x-photoshop	Photoshop	Photoshop	1	f
30	application/postscript	Postscript	Postscript Files	1	f
31	video/quicktime	Video Quicktime	Video Quicktime	1	f
32	video/mp4	Video MP4	Video MP4	1	f
33	video/ogg	Video OGG	Video OGG	1	f
34	video/webm	Video WEBM	Video WEBM	1	f
35	audio/x-mpeg	MPEG Audio	MPEG Audio	1	f
36	application/vnd.ms-project	Microsoft Project	Microsoft Project	1	f
37	application/mathematica	Mathematica	Mathematica Notebook	1	f
38	application/x-latex	LateX	LaTeX document	1	f
39	application/x-tex	TeX	Tex/LateX document	1	f
40	application/x-dvi	TeX dvi	TeX dvi format	1	f
41	application/sgml	SGML	SGML application (RFC 1874)	1	f
42	application/wordperfect5.1	WordPerfect	WordPerfect 5.1 document	1	f
43	audio/x-pn-realaudio	RealAudio	RealAudio file	1	f
44	image/x-photo-cd	Photo CD	Kodak Photo CD image	1	f
45	application/vnd.oasis.opendocument.text	OpenDocument Text	OpenDocument Text	1	f
46	application/vnd.oasis.opendocument.text-template	OpenDocument Text Template	OpenDocument Text Template	1	f
47	application/vnd.oasis.opendocument.text-web	OpenDocument HTML Template	OpenDocument HTML Template	1	f
48	application/vnd.oasis.opendocument.text-master	OpenDocument Master Document	OpenDocument Master Document	1	f
49	application/vnd.oasis.opendocument.graphics	OpenDocument Drawing	OpenDocument Drawing	1	f
50	application/vnd.oasis.opendocument.graphics-template	OpenDocument Drawing Template	OpenDocument Drawing Template	1	f
51	application/vnd.oasis.opendocument.presentation	OpenDocument Presentation	OpenDocument Presentation	1	f
52	application/vnd.oasis.opendocument.presentation-template	OpenDocument Presentation Template	OpenDocument Presentation Template	1	f
53	application/vnd.oasis.opendocument.spreadsheet	OpenDocument Spreadsheet	OpenDocument Spreadsheet	1	f
54	application/vnd.oasis.opendocument.spreadsheet-template	OpenDocument Spreadsheet Template	OpenDocument Spreadsheet Template	1	f
55	application/vnd.oasis.opendocument.chart	OpenDocument Chart	OpenDocument Chart	1	f
56	application/vnd.oasis.opendocument.formula	OpenDocument Formula	OpenDocument Formula	1	f
57	application/vnd.oasis.opendocument.database	OpenDocument Database	OpenDocument Database	1	f
58	application/vnd.oasis.opendocument.image	OpenDocument Image	OpenDocument Image	1	f
59	application/vnd.openofficeorg.extension	OpenOffice.org extension	OpenOffice.org extension (since OOo 2.1)	1	f
60	application/vnd.sun.xml.writer	Writer 6.0 documents	Writer 6.0 documents	1	f
61	application/vnd.sun.xml.writer.template	Writer 6.0 templates	Writer 6.0 templates	1	f
62	application/vnd.sun.xml.calc	Calc 6.0 spreadsheets	Calc 6.0 spreadsheets	1	f
63	application/vnd.sun.xml.calc.template	Calc 6.0 templates	Calc 6.0 templates	1	f
64	application/vnd.sun.xml.draw	Draw 6.0 documents	Draw 6.0 documents	1	f
65	application/vnd.sun.xml.draw.template	Draw 6.0 templates	Draw 6.0 templates	1	f
66	application/vnd.sun.xml.impress	Impress 6.0 presentations	Impress 6.0 presentations	1	f
67	application/vnd.sun.xml.impress.template	Impress 6.0 templates	Impress 6.0 templates	1	f
68	application/vnd.sun.xml.writer.global	Writer 6.0 global documents	Writer 6.0 global documents	1	f
69	application/vnd.sun.xml.math	Math 6.0 documents	Math 6.0 documents	1	f
70	application/vnd.stardivision.writer	StarWriter 5.x documents	StarWriter 5.x documents	1	f
71	application/vnd.stardivision.writer-global	StarWriter 5.x global documents	StarWriter 5.x global documents	1	f
72	application/vnd.stardivision.calc	StarCalc 5.x spreadsheets	StarCalc 5.x spreadsheets	1	f
73	application/vnd.stardivision.draw	StarDraw 5.x documents	StarDraw 5.x documents	1	f
74	application/vnd.stardivision.impress	StarImpress 5.x presentations	StarImpress 5.x presentations	1	f
75	application/vnd.stardivision.impress-packed	StarImpress Packed 5.x files	StarImpress Packed 5.x files	1	f
76	application/vnd.stardivision.math	StarMath 5.x documents	StarMath 5.x documents	1	f
77	application/vnd.stardivision.chart	StarChart 5.x documents	StarChart 5.x documents	1	f
78	application/vnd.stardivision.mail	StarMail 5.x mail files	StarMail 5.x mail files	1	f
79	application/rdf+xml; charset=utf-8	RDF XML	RDF serialized in XML	1	f
80	application/epub+zip	EPUB	Electronic publishing	1	f
81	audio/mpeg	mp3	MPEG audio	1	f
\.


--
-- Data for Name: bundle; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.bundle (bundle_id, uuid, primary_bitstream_id) FROM stdin;
\.


--
-- Data for Name: bundle2bitstream; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.bundle2bitstream (bitstream_order_legacy, bundle_id, bitstream_id, bitstream_order) FROM stdin;
\.


--
-- Data for Name: checksum_history; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.checksum_history (check_id, process_start_date, process_end_date, checksum_expected, checksum_calculated, result, bitstream_id) FROM stdin;
\.


--
-- Data for Name: checksum_results; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.checksum_results (result_code, result_description) FROM stdin;
INVALID_HISTORY	Install of the cheksum checking code do not consider this history as valid
BITSTREAM_NOT_FOUND	The bitstream could not be found
CHECKSUM_MATCH	Current checksum matched previous checksum
CHECKSUM_NO_MATCH	Current checksum does not match previous checksum
CHECKSUM_PREV_NOT_FOUND	Previous checksum was not found: no comparison possible
BITSTREAM_INFO_NOT_FOUND	Bitstream info not found
CHECKSUM_ALGORITHM_INVALID	Invalid checksum algorithm
BITSTREAM_NOT_PROCESSED	Bitstream marked to_be_processed=false
BITSTREAM_MARKED_DELETED	Bitstream marked deleted in bitstream table
\.


--
-- Data for Name: collection; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.collection (collection_id, uuid, submitter, template_item_id, logo_bitstream_id, admin) FROM stdin;
\.


--
-- Data for Name: collection2item; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.collection2item (collection_id, item_id) FROM stdin;
\.


--
-- Data for Name: community; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.community (community_id, uuid, admin, logo_bitstream_id) FROM stdin;
\N	95d68496-65b6-4ea5-a86a-483b608d5ecb	\N	\N
\.


--
-- Data for Name: community2collection; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.community2collection (collection_id, community_id) FROM stdin;
\.


--
-- Data for Name: community2community; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.community2community (parent_comm_id, child_comm_id) FROM stdin;
\.


--
-- Data for Name: cwf_claimtask; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.cwf_claimtask (claimtask_id, workflowitem_id, workflow_id, step_id, action_id, owner_id) FROM stdin;
\.


--
-- Data for Name: cwf_collectionrole; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.cwf_collectionrole (collectionrole_id, role_id, collection_id, group_id) FROM stdin;
\.


--
-- Data for Name: cwf_in_progress_user; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.cwf_in_progress_user (in_progress_user_id, workflowitem_id, finished, user_id) FROM stdin;
\.


--
-- Data for Name: cwf_pooltask; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.cwf_pooltask (pooltask_id, workflowitem_id, workflow_id, step_id, action_id, group_id, eperson_id) FROM stdin;
\.


--
-- Data for Name: cwf_workflowitem; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.cwf_workflowitem (workflowitem_id, multiple_titles, published_before, multiple_files, item_id, collection_id) FROM stdin;
\.


--
-- Data for Name: cwf_workflowitemrole; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.cwf_workflowitemrole (workflowitemrole_id, role_id, workflowitem_id, group_id, eperson_id) FROM stdin;
\.


--
-- Data for Name: doi; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.doi (doi_id, doi, resource_type_id, resource_id, status, dspace_object) FROM stdin;
\.


--
-- Data for Name: dspaceobject; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.dspaceobject (uuid) FROM stdin;
ea708783-6e3b-42be-b7ae-a27a039d48d5
62a74c58-773e-497a-b5d8-026f1787b9f3
23e54f59-2618-49fe-bb8c-7278e389948f
661a0996-f05f-4951-8194-5046d5934ab8
d9de3187-2c1a-462c-8c57-361c44172721
f175016d-594a-4070-8cb3-4ed00c7a25b0
b4066a60-4017-4ecd-b54c-8b8699f26b19
df761c44-c4b7-4b63-b36d-0b81d3a1698e
bffa777f-3b9a-4f40-9955-048a85e55453
e5320dc2-3ed9-4a69-b9b9-90853d1cb56d
5356f5bb-4103-4d1b-b58c-12ed7dd52220
e84a7e74-e847-4548-b876-1162bef094a6
be1e7391-d4d3-4c0d-9b1f-b3c1509ace38
cbdcdf0a-50cf-4873-be4d-a74d33ca58d1
b2a578e0-b503-47ec-8e93-f1641eae7e24
b51d23a6-444f-44f6-8e9d-a67b9f63bcf9
236c8cf5-28ce-4a40-b7e2-118dfa9e844c
ad64501f-aa9f-4b5c-8235-d5b8990db32f
7759f18d-88bd-47af-8d60-20783fb5f0fb
c3c736ea-7b24-4184-93fc-f08a084ca050
87489ca1-2f0a-4303-b079-e9bcea09ef27
ff5c7076-c0a2-497d-be0e-d8fffb6ce41f
1feb0aae-67a2-49cd-a766-dd0b9d06c592
e80fa848-8aa7-4d8f-bd3f-05c9fbc64526
2591ffac-01e2-4c96-acf0-cab1938845b0
b657dfc2-1e64-4565-a23e-ac69945c5e51
5aaefc24-96b6-41da-9b95-4c2e54e4989e
efa5e7a6-39b8-4501-8f4d-7e1e45b38e90
e1326ff4-fc49-48d8-9353-2cdee18d2c72
622fda42-aaec-495d-81ca-eff8577777b5
d6f002d5-b5e4-4857-9b3a-23adc038ddd1
749b2588-ec6a-4b43-a04d-8413d0073ef4
86f31c01-ad08-48e7-bb7a-c95405c442ef
5d2693e6-6629-4c5d-8a13-b34914601ac7
f302fa2c-bbd7-4ca5-8cca-d3e215827d23
135bf286-ca4f-4440-aab0-783449b4316a
47176c3f-ace6-40e4-8011-aef1ed09355a
89d9c763-30c3-4557-93fe-3776fdc49689
282545ec-368f-45e6-aeb7-3996412ce4b8
578b73cc-e493-476c-adb1-eb48220cf22e
42b2461a-88db-4e02-a98d-8458a466b76b
6c492f47-d149-4d31-a9ec-7d9b639a7b8e
e0b6a6c5-4a04-4e79-a32f-e07f60edfa10
e7e64031-a35c-474b-b81e-c80dee141c79
f3250f8e-5a48-41cf-afde-5e0fd29e38b1
ba990800-568b-4c74-9986-243c61f79d8b
119b7097-52b2-472b-a62e-8b209abe827f
38d06d74-3c74-4e76-be58-e3df8704e345
6ec99fa2-276f-4119-91e9-6e46116e43fc
a28e25ae-96cb-499b-aa50-cf8f6b868150
2b8dc1ca-f8da-45c9-9b7f-6149d3d5d191
f4ef99d8-0800-4b93-bf95-129faf3015e4
972c1540-90bc-457c-b6da-08590e3b2196
cb67f2cf-9167-4f7e-a903-d424080ee264
d8f60672-3b32-465c-ae3c-f617597940b8
617705c9-d415-4792-9e40-46aa57b2ca8e
4a7752ff-8932-46d1-a766-4d36a723bd81
bb63eb78-91fb-4110-9446-3fc3f2322f23
74058e8c-9fe4-4ff4-8e5d-b02d09caa089
e613b74c-a8ec-4b47-a68a-c39b6f1a980e
3d78308d-f318-4868-b9b0-c72b4c1d762c
bc6db9a6-06bb-432b-8cce-1f190564139a
80184882-0695-46a3-94de-add544369356
6987531d-294a-4ff0-91f9-649731bd8494
3faa3045-c899-4762-b3d7-9d8739fbfc75
a12cdf22-3b15-4193-bec8-f889305e6440
5e546662-ba03-4732-80d2-f83efc97efce
5bc0fbfc-0a4f-4207-879f-f75dd79ec933
7d4cfe6c-37fe-4ebf-886f-98296beca018
aec93c34-08b5-4386-9765-8c76fe5961fd
12baa5fd-5c81-4bea-b285-dc17c32ae888
d213476c-63ea-4871-a860-d0413c0f5037
602488ce-3c6b-4fbe-b921-00f448830e32
b91f4002-8b25-4b77-8387-417738e516c3
9b16ac04-1200-4a4f-9e97-c2c37bfc750b
be4aad3e-0a3f-43d3-b909-8c2236e02536
cbd4986a-8eee-470d-96aa-6add33867dce
7266d530-89eb-42f4-b0a0-ffd80c693bd5
df1b5f2a-4337-4f48-9705-2643328c4cc1
3bfd0215-c135-49f4-b58e-1d45b7dd4117
6eb05ea0-ea66-4000-8b3c-9e47bfb27f5f
dd1fb0ac-d7f8-4c65-bc28-90d84935f82a
2c97f2ed-5fbc-4b2f-a464-c9a310a7bb5c
82a928e2-e66b-44bd-bae0-d9995a2c9bba
7e857c23-806b-4830-baf3-b1e1986b1965
b152c321-6354-41af-bcff-84c25b5f84a5
0bb58d6f-48de-4c84-9e42-fcdd6a779c8c
4a9b01a9-8a85-48a7-bbc4-21d8c0ec9636
37ded630-defb-4a86-b8e4-4cef64e64c7f
f9520aba-221e-4489-a377-7e7293efe6be
b7a6c81e-8e5b-4cf7-a4bb-bb709c14afdd
d62a9eb4-a064-48ed-9d74-26541a46e7f8
abceae7c-29c7-4a12-8841-5989af4d95a3
ffbeaa0e-17f9-4ce4-b9a9-fbd3edf235df
9071ed6b-50a2-4d60-9ffa-f956fc3edaed
66dc77ed-e46c-4199-9040-bc8cd7dfbd6c
4acd467e-b518-4d9b-b8fb-7a86e9806097
c9a9d872-4f09-4e14-bef4-2b55164f1c3b
bbce4a1a-766d-4c7a-91cf-52018844276e
ee7d5213-150c-45af-86e1-1dde5da6fa2f
48f648f6-9993-414e-9833-d5f305f3fa1a
245156b5-eef4-40d4-9f44-1c1ff30b1816
4787776b-2a78-4109-8b63-f37eea5157c4
79658689-4d32-4268-81ed-625c0bf821a9
91803a00-67f7-45d3-b768-58bbfad4b040
284947be-468c-4b66-a3af-f7eeb775404d
ec4574c6-8742-403a-af0e-545906824d71
a51fcc77-8ca5-4bc0-aa4b-86b9703464ca
dc7ffc6c-aee0-480c-8430-b6d4d744979e
c0d78b5a-cab0-40b5-bbf5-b116cde4b170
e3814d8a-92e7-4f1e-98bb-a2c3c98255bc
15bdd673-bd8e-4b84-b360-286b197f98c1
cf5e4e38-a1ce-4078-b89c-4937acb2055c
9a436b7e-1add-4301-bd3c-7d3b198d9b39
4bc4ff48-23d8-40f3-985d-8ae62a01f105
9501ff63-812c-41bb-bab6-da2d57b27f1a
acddc971-d4f9-4663-a5bd-bc8a20bc37a0
a8929ffe-0324-4679-8d37-2e84beb4cddb
5f126a7b-6100-4610-a303-bd9db95911a5
53c5cbb4-0dc4-41f7-a2ed-5dc538dd1acb
15a0d76b-518c-4fdc-907e-2fdc7ea2b5a6
862d725f-7c16-4657-910e-86ae34abc90e
32a1f201-6cc0-4485-b9a7-4e74450c7d1b
87430ec5-5f4f-4a4a-ab24-76e5c15cc6df
4b5e1986-a44e-4d68-9556-b5a17e917a97
4b029b79-7589-44c6-9f24-4394bae3b1b8
ca1f7ea6-16c6-40ef-9ae6-8226e0824dd7
ba63462e-820a-4a38-b80b-6be4f97d2e12
48cdb008-bfdf-4998-9f43-94e699fbc0a9
b77b327b-f817-4d32-9a4b-9eb462659bf1
1961d363-a764-4f34-9ece-61c0fd5e9d1b
986f2d6e-adb6-43d1-bb0c-87a4ab4ce613
9cd9241a-0c2e-41f6-a117-042e792784b1
ac7c5540-a1a8-4f96-90e7-f2bff716c4e4
a2768559-f246-4a74-bd60-cb054d8a443c
5a932d7f-a4dd-4855-aef4-e6bd910fcf66
0ab5de0b-e06a-4dfc-8eda-d28f8fb5de39
2f9154bc-65cd-44b6-9299-8802ac82c5e7
55b28903-d1cd-4e29-9b0a-379dc666cc7a
0a00872c-1d53-41ee-afd2-d062b0bb676f
cff717f3-cc93-493b-8b1b-b375972a80f1
039c3fa2-7b1d-4495-8749-2e1371342e40
f97551d3-3859-44a0-9e65-2c394b9b54b6
2191ea91-4091-45d2-a4a1-725d635802fe
790c2cf1-453a-4fda-9dc8-d1c4d31af8a2
aaeeb341-c623-4c0d-b9b9-7f9568feacbe
19cb1f36-ed20-48ef-8297-0174867edb91
f6c466e3-f8b8-4f28-8d7d-d1de8df0a5d7
811f0c7a-b5eb-4747-99b5-44fc6ea29bdf
1ce61bae-e6a7-4831-a1f9-b07404c5b7fc
e70867bf-58ef-447d-8afa-b0267a4434f3
317d9961-e788-46fa-89d2-4841e0ce4339
45791949-4999-465b-8be2-d8f4bcb953b9
dd614107-0246-44a0-a3b7-dbd0f51be521
e045690f-1c4a-4391-badb-7474a9b3cefa
c107b290-0eb6-405a-a064-f5f5724b8626
d6bb0483-f84d-45e0-93d9-704676a85522
d42d7bf8-74fa-4a24-bee7-51db8c5f09a4
428d54c9-c728-4678-9f62-043a7d175237
36f003aa-4f06-4181-875e-85cf0c4fe523
4b2155ec-e513-477b-bac8-b37142160731
6ea746de-6c4b-4288-9bee-a93cc0a8037c
dc72b579-bf8e-4e1d-ba58-e52031095104
be028d3e-d6c3-4ed1-b3c6-43a3a1585c68
ec800be0-f237-4a79-bc7c-b7629548061c
72da50dd-b6e4-49ff-aa17-d5d5e0ecc800
95d5c820-d64c-44c1-a876-826053be7b5e
73ae3365-d84f-4579-a563-763e8076b4de
8de27065-13ba-45e1-b85c-80d68bf2a1f6
279ff75d-77af-44c0-ad5d-d76df4c78ed2
f883f0c4-3c25-415a-abed-f5ab0b95a291
33326ace-bf60-40d9-9342-812a491bf96a
de3c5f7f-4550-43de-be75-113437c79993
1e635111-9d8f-4e4a-876f-31b937a0fa5d
bd66ea1d-86e4-4b09-b6bc-3ad96445903f
efa477b7-ad16-4bc6-bc0f-04aafe43736a
8bf4e517-56af-4a48-a65f-574bc1498aed
f7c4a72e-a00f-4229-934f-849567e8a211
494fbda6-b49f-451e-a13e-e0ca8cbd7ceb
2da875ab-3c70-4207-bb7e-d2439ea6c511
666cdae1-e874-4961-a48e-044c1c1c29b1
316d2622-95b1-4b41-bd8c-271a59ffae66
c47496a8-6525-4a6a-bed9-bbffac9d426a
baecae16-b3b8-488d-a525-49dfbd060e76
f557699e-1b6f-4152-8393-17b03dc6a5da
4bfbf1d6-a42a-4b93-b3e3-34fe8a309351
1a11803d-1f11-49ad-b488-77fa97f2289b
4d8e733b-3140-4c5e-b5f9-a16a758afafd
910811f3-954b-4e26-8eb4-8e8cb14100e0
b10693f9-9de0-401d-83a7-9f678d457e4b
2e850448-44b2-4aaf-bdb1-04a985298ac3
2e5fe6fb-d466-4e39-beb8-085f3009267b
57baadf2-71e4-4d2a-9f0a-644901bacff5
9a6eb543-a1bc-40e5-b6a7-f703cf7464be
ce4542c1-44bb-4c69-b001-37fc21846545
d0a31804-ac18-49a4-b18b-91192ee180d8
91ee1c48-06fd-4af4-a9e9-ed7caed2b547
8d4f00e3-5ab7-498c-a413-7de4b878cdf6
3332bd87-0e63-457b-9be5-594da51b0566
a9e5888f-7d35-470d-9467-2483347b0d5d
70096eaa-ab76-45cf-89c7-b99a5812481b
c226ac74-c714-4d4f-a65d-764b5d59ff43
7088082e-d908-4d91-9d78-697ce5af8e2c
f2bde1b1-ca22-443d-a958-c8575d953772
ba394fa0-e13f-4501-80ca-f6bae04f18ef
76127d2c-e183-47c4-a072-a84d0f5642b9
b2af4673-5761-419b-92f2-069499eba9e6
7a2b4032-6338-4f6d-abad-726db6b2488e
da04ea46-4f37-4585-9cb3-e4c968c51bad
946f5793-c741-4db2-87d3-bf77e2c3432e
8201866d-18dd-4d5e-8d34-27d35c520cad
6bf62d50-0441-4a85-bd58-635cb5e1a5f1
4879f6d7-301c-4584-b7cc-d5b7836a2a92
e2c37321-66aa-4573-a9de-70d29b6f099b
9a15b0a1-ada6-4741-86ee-1015034fff05
41c8a3c8-da11-4e1a-a3f2-67702395e463
e6a11a4c-7229-4c35-9a69-ba40cb9f6792
396a66a1-7c0d-4e66-bf79-cdd3f7a166af
8b9f2da6-aaf3-4f80-bd18-cb472bc5980e
ca8dad51-dfe2-45c9-add4-aad6ee9a4559
1c4a4467-f236-44e2-9b7e-f3e6e21f3e47
fdf22476-a896-41cd-b9df-f1ffdc5f3905
7c11782b-e283-41c1-957a-4dfeaaad5546
cc5897b0-73f1-43bb-aab2-2e3ed2c30b21
75c3ab94-832e-4d84-9b5c-10b046200c09
b7029c71-7698-40b0-970e-9ab6fe40716d
0d354644-0ec3-4fb9-8adb-ec825370fd8d
48cf9db6-bfd3-4e0d-a529-383678d7d054
f95297fc-4084-4b60-827e-b8a476037ef9
94ca31af-bd87-4b0d-8a2d-fd4f6cf74de1
22915ed5-e8f4-4442-bfd4-cc6e488c47df
173374f7-02e5-4817-8ab7-8cbd382985b0
3c6e31ad-5217-40cc-8112-4324477ea8d8
7a292192-5bec-4358-bfdc-ae27578b4cb9
1ac3ee27-d910-4321-aa8a-11eaaf335de7
ac8cee04-6adc-4b1a-9602-c27099e14eee
062c9c70-eec2-4188-b48b-b23ea4a1bd45
1e99bd7c-6734-4755-bafb-cf883f044ea8
7c0b6660-9bd8-4542-bc74-8781cbc72f9e
7933d957-9acb-4f10-b440-50d041bea0af
23c3b697-a4c5-48aa-9ee0-0aca2b5a1b4b
4d5deca8-556f-414c-a5cc-051cfb1bc48f
5cd90407-6e36-4f08-b959-9ca3877719f3
f374620d-ef40-4ed6-9fcf-3f519848371c
e9c9f7ac-6a60-4082-bc97-39fdc9e79c89
4d85a1b1-0100-4c01-b1db-3fdf2ab2f6a8
9ec79635-ebcc-4015-b48e-715b2bb17f2e
d4ea992f-7a65-49af-b90b-4cbe54e62784
ba7ba332-4a7f-4409-be28-bf9504db6f44
c99f65b0-24b1-491c-a4ee-2ac02a6c31b6
a26c5f13-f433-4143-9e00-873b20f8695d
e74a37f3-b989-4499-af6f-2162ee3dbea7
21e75cac-2d4d-40b0-9888-f61cd53a4b6d
06492d28-6f48-462e-a981-39c9e5cfbe40
3c58bf17-ace4-4ed0-8697-fb3097ac3360
8ec8d495-0014-4740-a088-fa895e8af8ca
ea40b4f9-98f1-46a9-a580-782e5d21e629
d2f556a8-4051-41e3-8d5b-17d3a503ffdd
47403eda-009f-45a0-8471-cea960116cf9
993120ec-3a2c-452a-9cbc-1d71ac62a857
39211907-e7a7-433e-b3e7-63ea6072974c
a5095e1e-0c6c-4a88-b94e-37cbef9dbbca
53bd6771-9970-4a43-a34e-206da41b777b
3b4370e6-90dd-4ee1-a289-eeaa0a77c7da
5d78d55a-6350-4714-b4ff-7648c461e08d
8b701473-2893-4d03-8155-b1fcb8989141
d153b254-2b2c-4d2f-b7ea-7f0e52c3a7e5
5e5cfff7-d46a-474e-bb0d-c247cf5fdd72
89cbc5cc-55ca-4760-b787-5eda8cb8c422
05be9bc9-cef6-4cf6-a40c-13a224fb925c
b946f119-cc9b-4268-9a20-914cbb1459d5
eb452230-1790-4fa4-a35c-1821014c403d
ec0516e8-ece6-486c-9c59-f099e03d2256
e8f4c747-f710-426c-ac1b-689ea557d0f0
4696cb67-0e5f-44b3-a2e9-f96ec8d9daff
19c06bd5-7e00-4b9d-bb63-a7d68eebb7b2
7a064116-70e1-4699-9797-593c43d1afd2
90a742a2-cb2d-49da-878d-f885b4cf7289
0ad736fc-5ac6-4f94-a79c-b04b686a1fae
6bed6545-d8db-402f-9dd4-8d21df467b9e
6521cffb-0c27-4491-bd6a-ea4ed616b27b
a5bb816b-4512-42ee-8f7c-ec2ab45afb95
6c34aedd-20d7-46e4-8614-0a7f2185a567
5a068c21-5f02-4549-b1b2-aefcb7cf9eb7
8e269ccc-c571-44c5-869d-4b83c554c526
1adbfd1d-8d65-4c80-916c-1a62bddde614
d886e1d0-02f2-40f6-8635-a36d290bc787
e0bbc989-713a-4d79-a4a2-5896068f9bdf
83899895-efaf-4da7-925b-d16ad20c367b
b053e5b1-6f65-4d1c-8e42-e4ac8914d135
220290f8-3af7-4b8a-8440-fffcd8c95718
6a9379f5-80c9-4c56-a33d-72a9068eec58
be61103b-4de4-4a9d-aa33-a37b79417b9f
7c6ce2ab-85a3-4a11-8e60-8725c1d940e2
0dfe516d-b1be-43dc-ae29-8dc60cf6c024
339138ff-1b5d-4d1f-b72f-f4b81f634657
775ee888-0a6a-4c12-ae26-f80be4c39700
2aa84589-6d70-4a92-a39a-94825647ce22
0f984f42-e8e4-4ba9-80f3-a0c238e99706
58ed75b7-d93c-4dea-ae7b-aa676e8aba55
e9a89dac-3598-428c-b2f2-bed507bb9932
746aeb4f-bf1c-48af-b643-c7802460530f
3bf0422f-a88d-475f-8b82-e41fb2d49645
fb722c52-4945-4a97-93aa-544a1463cc10
55f880f3-96fb-47b2-bd67-acb0d44bee7d
6a64361d-703b-4b6e-9fca-728b9db967bd
a79a1110-d4e5-48a1-b188-b20a56be7f43
ba5f382e-f920-4654-9b15-d2856dd407c3
c6d7ea8a-3653-4ba5-b843-f448d72a4f46
8c32763d-39e6-4883-9853-d54628cea3e2
217da3b1-dc2a-4cc5-b65d-769695058501
9272ae94-f565-4b74-86b8-55302a4bff38
5cf12e6e-3bda-4470-98bd-032506bc49ec
df26b968-1e76-4bfe-b406-b7b4593934b7
66088f72-ba20-42f4-8a02-0ad84e3870de
77ecae42-7ae4-47cf-bd46-46ddbb69a862
260fe481-1993-4195-9b6d-83977d7ce9d2
854fafe5-67b8-4e7b-b6ba-aaf5a61404cc
81ce143d-a2d9-418d-999b-b5804b293746
4e278de2-2b03-4351-b067-44d8ceab32c5
1340521d-15eb-4d11-a849-ab9a11ea7bfe
121c00b6-0488-4e1d-a6ce-90efd05ada9f
ac10cbdb-0b6a-47d1-8bf6-bc01f62ed954
33f53947-29f3-4166-9394-589883366c44
c7dd26b7-55d4-4bef-b0b9-1823885787ff
66ce3e95-b6e8-4747-8bd7-e8ccd4fee601
63c8f333-b7de-4248-929c-d66f1bed4205
edc8cb15-8d03-4cc2-9f85-1974a4d8e654
172f5313-b4c3-4a37-8f4a-e33c18e6a619
73c91a17-da38-4194-a03a-43dd8902879a
e4f1eaf5-471c-4a1d-9dfe-78d16daef96e
925f9e60-9f66-40ba-880e-5fe6ebe910a6
5b11fe17-90d3-4923-8b1c-5dad34738ff1
5126a452-3c01-46ff-af8d-522d02028f58
9932e9b9-9240-4443-bde5-c78435f012b9
1c6d7d32-6720-4d00-8735-95cf036361e5
4aa4e915-2555-42d7-a10c-47874e03773d
9665163c-4d2b-40f3-851d-b291b7832e70
55efd320-ba92-4ff1-b684-6c7657ef3e5b
ddcdaf51-783b-4c28-bafd-93e0824e83c2
d8a32f78-2b75-4020-9b65-7d829f342242
35e5fe5a-dc1d-4c95-8e0d-7d0fd1a4be21
aafd1652-1e33-47c8-83d3-164099e91f1d
c2b25088-12bf-4de3-9202-9c34e22c2883
d08831f5-28e2-4ace-b9c9-ff5f8e5ce0ae
26081a3f-a320-41a8-860e-611bc0c9f92c
c664e707-9730-4f7b-ae79-ad35c83f5baa
ac7c3fab-92e1-4559-b929-df4d8351cb5e
d7e89e60-4c09-4a36-91fa-f87a6ac88f10
bde6882b-dcee-421a-89f9-37db10c46792
97dbfc61-89cf-4fb3-8825-d30bf55642ee
d130a874-3309-4eda-a25b-736f2a96053d
cd7fcc21-4cf6-4f7a-a81d-d865a540d04a
e9377708-7c1d-4b2a-ba7f-b07e4f2762ec
a7f86a11-fcfb-4df5-87f0-49e3103c5148
75c637f4-7784-4779-b7fd-1d3ed1b5771f
c3b58c0a-fb64-494d-8a5a-ce505d02334a
b632144c-bea6-4d11-81b1-29599b5b343c
e862c4db-7e1d-4295-93fc-44c653221019
87875547-a4d0-43e5-a51c-f8694fc1e0fe
bc4b83a2-fb82-4f7b-8ffe-af436db04ec8
db2546cd-9aef-4ef8-8472-97aff1fd1817
9ba23e80-2752-4574-a0fd-d123b711a682
1f956b79-4c6a-4b92-a23e-a9bd1045456f
4759d16b-b270-4fe5-9ff1-34f6a8191434
3c49f4fd-154f-49a3-bdfa-27bae9c848a2
83bb9fcc-27f4-498d-9554-aa80daadd80c
44a85498-ecef-436f-b327-974987702e5f
0c28b25e-492e-4776-8dab-20bc4464d954
7ffc982c-9301-4082-9d1e-282652a88336
5e1b3cb1-d500-4e0d-8ea6-33b7284cb4da
f1a2433b-b17f-42d6-a354-ff877a3d5a2b
1279e41e-28df-43a4-b90a-bae99d59510c
439c7f26-2571-48a3-98c3-c22c7ad5aa5e
230df675-813a-4475-8d87-66509d79d8f7
324619d3-2742-420d-9bb8-26392c6656af
262f89b1-29ad-4e32-b336-5a13e84f32ca
e5805876-74af-418a-afba-421053c0e889
d2ff8407-6bee-490f-aadb-5411c8a7b105
c6205ff8-1a9b-455b-b7b3-fe40cc16f615
f11caffa-c6e2-4c10-a14b-d456349a9204
ce580e90-f41b-4840-a3e4-d0648b0ab5a7
cbdafa5e-ce72-45e6-86fb-5a93edcedc33
29326696-59de-446c-b833-d36936828fae
b4528df9-6838-43d5-a987-e728e82ea1d0
62ac2a5a-39de-4135-a25c-8365422a6ca0
8a6cccc0-a9d0-444a-b5c0-da345485e010
53a1b46a-67e0-4105-97fc-67e4bb53f294
cb6963ad-0e29-4a38-957f-509828bec799
22d5d3f6-cf09-413a-8fcd-d656f0992007
1b8647de-8e04-468c-bd03-6f72c8cd9f14
adeb5507-ea74-409c-a25b-defd9de863cd
788e30aa-0009-446f-94e6-4ba84886f5c2
f7898dbc-f40a-4e2b-b245-2c281f6bc1c8
aad2253a-d28b-4740-b984-ba3b96093b83
69ad5b1b-6a7d-4387-9956-46f985afc1bd
d2e2dc54-1276-419e-895a-68deeae24ff2
59c54f47-70da-422a-b786-5c59b93bbafe
b827b971-58f2-455a-9575-63b771b6a920
fc0cdc51-b798-4260-89c6-21bcf5e90e43
0abb40bd-56a9-40c4-939b-a3c0629a53c2
fc4c0596-29c9-410f-9488-2a8dc7eacc1f
4de34964-f939-410f-8266-177f5d95f559
c3a6364f-7842-4d81-8ac4-9d3c4722befe
66553ae7-14f9-444a-bb84-cb60bcea4ff9
41017356-8657-414a-a34b-658cdaff7d32
22f28d7e-409b-4d08-a5c4-f066bd742da7
c3b39c9e-0e5b-4d7f-b7fc-fcab7c249183
b3f58243-10c9-48b9-bd11-1704840ae26b
8e149e13-23af-49b9-8048-bbdfc3dbc125
f3db3e45-ff66-4280-9084-75319a78a7bd
31744827-8598-40e6-9dde-103b5bc80985
96379ab6-5aec-4af6-b061-d426ed0c5fec
11e326a6-41d1-48aa-ab44-88e79be87367
401fff2a-1dad-4f01-976f-421412d25e55
645247b2-089c-4214-bd66-bfcafee9b952
a34ad3ff-1fcc-4298-825e-80c9a1189d2a
19c1a6b8-191e-4746-a5b1-d1db7eb51a1c
b26f3744-c739-43ac-891e-ec9f30e20bef
2ea21b92-edef-45cb-9365-4b65f0b4c972
ddfd79fb-b06b-42cf-921c-4d8699e0dd45
f1a95d81-73b6-407d-b7c2-61858eaa8604
1bd47e73-3f3b-4b9c-a459-9be1a58349a7
dd30a8ba-3a2a-4154-ba4c-a5fceb5e56cb
3f0b7a1a-56c5-4a02-9d91-6a9e4ca848a1
ea81121c-6488-49b6-a2e2-ca52c57b6b17
6dfd8bff-bba4-41e7-b852-0a8cd0d56853
78d6cda6-454c-4b43-a5ae-38b0a8b725b9
7b2533fa-27a4-4a86-9754-bb85d8ac28a3
b8a1904d-cbf1-45c7-b29b-c582db2aed47
8bdd8b5a-484f-4fec-a451-7698f24a1483
84cd1ce2-3157-489a-acde-d42c5b984924
71651dfd-393d-4843-aec4-4532a85bb06b
6ac11558-f863-4d39-9c0e-0f591c27a10a
48847277-3341-4566-81bc-42f98a884468
d20258be-2c41-4474-bf4b-23340c78dc22
ab9be5fa-c94c-4df8-a5d9-544adc1cbe12
eeffd7e4-742b-48aa-a3bf-bde382bd35a6
e9c754ec-90c2-48e9-a7eb-ac415fd0a2c7
bf936c92-b0f8-4e93-9ac8-931581d3f15f
4fc00d69-fcd4-4ded-95b2-bc82d7da5f63
cba03df3-54cb-4f65-9fd9-589599f6d691
7bc3b082-844c-49e3-bb13-e5575abb06d2
1051d35e-9542-4efc-8129-b51986005895
1d28a233-a092-403f-be74-475b05d0b538
755e21c7-1602-4c39-a5fa-5046dd7de73d
d9fb79c0-898e-4354-abd7-c5755b26bd5e
a4f93140-0eca-4ba3-8f1b-b03ced84925b
0cfcbaab-0582-443c-8fef-0f932ae383d9
f63e4433-7870-4c79-b096-38fdf005aaf2
7439df16-626d-4f30-bd6c-03841806a3d0
940def1e-38f3-45f3-8ddf-fb971fdbbeb0
25605338-8012-4e2c-a5a6-72d3ba777629
9c1b725c-e932-4366-96ff-a723778f6765
dd57b1d5-b78c-4715-9b36-2bdf8a787178
7f884d3a-e152-4458-aa89-e780f66f67c8
f66aa4f7-fd31-462c-ada8-05e04fb83d38
c86891a6-fc5f-4c7c-a620-b72fd2f06531
74832c9b-bf81-40b5-b1d2-5ac6cd59f694
4305f503-8b1f-412c-973b-f756b5b8c8ed
8915b673-58c7-490e-9f1f-1783f3e96113
599f87bf-f0cd-4480-9043-94b894e38515
97f2c0cb-fca6-4458-8ae0-71f4db932b64
93001965-f3b6-44ec-b4a6-0d5d9204032f
30ea521a-5b8f-4bc0-89e8-7aaa63794a1d
a98893b2-b0d5-4628-85eb-3982246bff6e
7ab0e0f4-a473-4c6a-9ad6-b377d48a2ae0
1c90b189-de22-410c-9d8d-8d1cbd1f53a2
a3826a71-232b-4111-b49a-79b630d20add
24b73c6c-f534-47cb-96da-21c99bd7a0c6
03a98ae0-f36a-4e21-86fc-ba30b958dcfd
3dd4c076-66fb-4fb6-b0ca-349873c4279b
8e949bbf-c38c-4923-8199-da187f587eef
3a1c1fdf-62bf-44ac-a333-5c5a852dc99f
cf8847bc-21fa-4988-80aa-05da0eb96de5
581b9dd1-32b6-474f-a777-717c3dc0e639
3ed45c32-2637-42c5-b616-1ec2cdf7cfcb
824ea511-1866-4981-9c67-a225abd67b9d
66db2f4b-52fb-4300-9634-364fe3c4eee9
6a383623-266d-4413-ae5f-e6aa9ca5294c
1ca7dc9e-2099-49d8-93eb-7698063ad1e0
798cfff1-3c9d-4144-ada2-d478d6a1d2f2
725d945e-1b00-4a89-8eca-631800bcacf9
902e9e9a-ca08-4b2c-9a19-cb2f86d30d03
b0006623-ba88-4650-ad4e-18e9cc34ddb5
e45c2b0a-ae64-48a9-a8d6-d2bcec6cba5b
55ec0de8-e695-47c9-a770-124b1cfa1595
93afd952-aa8a-45fb-9782-74f0f0f826e4
6bef3fe6-f0ea-4882-96a0-e89209ebeec8
270ce077-ac37-448e-a941-bf8092306b31
748d9040-0051-4fb4-8c9c-d8c2f0b621ba
5266a03d-f215-47e0-b511-fe38c8699df4
403a7698-3805-4d67-9865-ccd57f73f17d
ddee10e8-607d-4e76-9756-282448c0412f
7715bf66-77ed-4896-bd10-336569150627
751813cc-de1a-4117-a6ba-f3e3c3ca1b64
77adddb2-285a-4883-9257-2d795277d058
9f3aafd7-04de-4286-b536-7e2906470f01
61d5a3eb-2d3d-4695-9464-65076c32bdfd
bc37b708-d924-410e-8ede-cecf2588907e
c0da6b8c-4ec6-47de-b494-46335e099b36
66864f6a-b31b-43c4-8abe-851ed8a1f6fb
3d0b713d-3a3a-4491-b3d1-3bba4634ba3c
3afd2234-af3b-45a6-a3cd-3eeb48c6b40b
95e127e6-70a6-454a-b09a-75ccd8f6cabe
1e9eb0c1-86e1-45e4-b5f3-154e64de1237
24c55af1-e9fc-4c2a-bba4-46f29f9ffa68
2064cc71-7de3-4278-8fd1-66bce4053585
286a2279-6b8f-4cc9-a02f-ecf711dca598
0f451b96-3fa6-4a83-b4dd-ece659065aaa
9e7eb8d6-5b00-42a3-ae42-6d00f5924121
e0edd021-dbe6-4b24-8440-ed83277c0f59
2420bf11-a8c1-4013-9264-88a7aa3c95c7
c453bc37-9fca-4a5c-acc9-f17112581e94
0c1a4dd0-f998-4dbe-900f-948ec285e720
39ffb9c7-1486-4610-878b-93a3c065e9a3
944185af-ee0d-45ad-8f94-7e5bdad716e3
82e3fc71-c762-495b-a9fa-e8890b8f9b75
ce3049f0-4449-4663-b1b8-d7c4ee471bd9
f1fc8252-7480-421c-b91f-7855c2f0cdd4
ae7896f4-2d94-43f6-a184-fba9a1070587
3da477e3-3bd4-411d-b20e-591b2fcf0721
97c0e6b4-f3dd-4f0f-b25f-1ec357f841e8
aa3ebb74-c0a8-4ba9-a676-0fb4ed213864
2dd3d78b-6dc0-4e59-8734-4a4506e82503
abf9251e-0028-496d-9203-6b635eccbb7d
d1797c56-97e2-4b6c-8cb5-88f723fd426a
dd211663-7328-4ed6-8b2d-81e57783620c
af07dcd2-963f-477b-83f6-7d5539e060cf
807be89d-3c22-46dc-8d42-edbeac43eec7
b3a4add8-e41a-4069-a61c-d0d7debf9940
d8b6b680-1d4c-4a23-94b3-e3be30bcbd2b
5ed8269e-2c7f-4436-84e3-e17670893fb8
5b6eea42-32f1-44fb-ace7-bf87e5558a27
1ddaf4f5-030e-4493-a246-5d1f2596e780
4c79696d-23c4-49ef-bdfb-959d590a9c6c
70f794da-073a-4e68-9855-ac3cc2c80816
c2baa239-08bf-4d90-bf5c-698ee81a5ee2
953ef6aa-c5cd-4167-a23b-3beed5973129
f5a715b9-161a-43f3-845b-fb586c66e899
2bd926fa-672b-4447-b401-1991b7a38597
164d4687-3c9a-4230-93f6-51c42ecfe77f
31d47bd3-78aa-447b-b32b-2305501492c1
04dc80f1-2416-43ed-81f3-27b6902cf3ee
0c46654e-ada7-4643-a347-5a2004900eef
5fd52188-ed21-4119-b0ba-82cd959c1115
c5708068-8d34-4c90-acac-7b56905ae13d
02a8491d-0960-4850-9890-7ad3e61675bb
0b5ca965-1f39-43f0-a14e-63ab068455c1
b6a742d9-d791-4702-8a8d-037a6a2ab8f2
272bb69a-b2fd-4d34-9b4c-d7152b7aeff7
fb4bc5da-f3a0-47c3-b030-ba251691a602
40960c3a-f33d-4461-b67d-94bc8d6761a4
d63365c8-9ee2-4fd7-aa46-fe94ca9371f2
f8cd187a-40bd-42ee-bbc0-a3d78a057063
3415c94e-c84e-4019-894e-9059ee2caeea
8fc4a8d7-bbdf-4208-8c8b-8b94dd287c7b
6d4bef11-2a4e-4434-a1b2-08bd50a50993
d3e563e1-5166-4bf7-ae05-6c9442f2770d
b9ccf895-a5b8-42b1-97c8-ee3782d2872f
9c04fe17-ecea-4436-b6cf-c15c7386fd7f
a8f82864-d4ac-4f05-9c75-891704699547
d11e1c1a-8383-4490-8b8e-8e7ae4bdb695
94707d18-7819-4c2e-854f-ac319bcd8f5b
3909dd25-4d13-4777-9972-0c5f55dac187
3506cf42-35b7-4334-a689-69b52e11ba24
b9203636-80bb-48ee-9a61-e03c54c77c78
68bf4655-e163-4dba-bce5-95abee17ef5f
1dfeffdc-06e2-41b1-a7f4-4e7be6425aa2
40391d5e-e77f-418e-af02-58bdeb8d7549
97ff5936-6bee-4b7d-8153-46a4b532ba4c
84364eae-925c-47f5-81e2-71a7d9605cfa
46ec0a27-1027-403d-81ab-6e16088394c2
2e6da491-2416-4a99-a85a-cf497c1ab27a
074ad4c5-5f51-4921-a500-900633716986
b68fb29e-60fd-4e0a-aa59-f44bf47f0c14
8794fa1a-3b42-4064-8d54-49671f2aa6af
86d1211d-52eb-458e-91cc-8b2eed6fc351
ba41d4b0-e409-4f91-82b3-a793a859fd1e
c5c167e1-81a3-40c3-9a78-5c3ac0195cac
9896432c-6e80-4610-ae46-938369c422d5
6c84f31d-2d1c-4b63-8002-b9b3bc305623
28369640-9916-48fb-b53c-afd5b602def3
65cb50ec-e02f-4fc3-b653-e3a351ab6f8b
94c17305-6e46-4bba-a216-828c3aef4b6b
4fdf00cc-3a18-4b77-828b-448de32661f5
2133a31d-afb4-41f8-b110-a16fb544096f
81aa4974-05ad-4aca-8cc1-ffeb346058c6
b536a7bb-a624-4d8d-9efb-132886fed5eb
ad79e6a8-faf8-4d81-9fd2-b17166fd716b
e3d7d763-c625-4c24-9cdf-4d89079b13ec
51290f10-8d57-4fd8-bd6f-63635d99e961
c297d50a-40f5-477d-9c61-e94818ca0d17
579ff05c-b3a3-451b-bd98-d15a5e937ecc
558bd5ac-460f-4443-9b9a-65421a026cf4
3b5c5489-f5ef-48dd-a00a-10b34f8490c5
0326ba01-b36b-4335-ba22-c368c402d1ab
a44e707d-0581-4aa5-a395-aeaedd263a36
2754079c-f239-4bb1-9cd1-49b621ec908a
7a353843-eccf-4ddf-83c9-21bc99ee0a77
2e84d08d-42c2-4c74-bb09-af495be7a69f
b3e32231-4638-46e9-a47e-970ab57aa92d
bbf88ff8-71f9-4b90-b37e-c889bfbf3e15
d86d3ab7-9ed9-4a49-a120-26d5a268a1a6
e99ace79-12f7-4ca5-b2e7-acf2a4b4f3ad
beeec6ad-0a47-4491-a756-71bb3fe35a4d
eaf4c41a-c8e0-466c-a1bf-0a6f0fefdc58
9b656b9a-4613-4eab-bb13-8a8832348815
7f7c3c88-b517-405e-9238-6998163f9b8b
4f026a84-2a2d-4127-950f-454738edf405
c89df378-d7fb-4ead-b304-36cd19e249be
26227059-9eb5-4db1-8d62-d6b6eb25d61f
d6e1e341-68cc-443a-a1f8-34f483ca059a
9f9d43a6-6930-4a1e-8280-58c935d3220d
668fce16-e7d5-44f0-bfbc-086892a8c715
d88d94fc-573d-4bb6-b719-31eef7fa21a4
1401c408-a4ae-485c-b94f-542224fc43c5
8151579e-799a-404c-930f-3ed7fedc5061
9337cf8e-1249-4500-960a-2477a3f1b62b
6e694892-cbdb-4da2-a837-2fb3b60034e2
5ac8c636-16ee-4e20-970c-6295a80a8015
b02d9b7c-286c-4474-9825-ed73654482c0
13efa4f6-c0e2-4d7a-b487-f3061efecf2a
0df40261-c6ad-468d-bd10-a957c2a0c1ff
88597d60-341d-497f-881d-5b21f975696a
08f4c844-e18e-415f-ab0a-15073d4f9e1d
06b7b65c-af7a-4da7-9351-47d371792e13
1312441d-446e-4a9d-90ff-251674caae2d
ce215474-f67f-466a-b763-528c26d1db76
46769403-937c-4267-aded-006c27fc19a8
0e9afc9a-ce26-459d-88f5-74c96e5a7796
1ce72c8b-7d2b-452b-b1df-4f8c2c742b9f
37477732-ebe9-44fc-ab84-d6112c468882
28b33fc1-d78e-4e76-8be4-56cdd2604681
17028385-3c80-4ffd-8b59-af83266effca
03454abd-bbab-460f-a616-629e1424747d
fe32d393-af1b-46a4-ac17-b2feb48bdb42
21619c05-234a-4775-97c5-9b6ed4fd0f3f
3bbbb0f9-ec17-4942-bd3c-a888cb7d4363
b5c4b423-4c44-4f94-b052-2847559e614f
4a2d9bcf-1fcf-4673-8a7d-2e88499b7008
a2927947-ab1f-416d-9ba8-2ddc56f759ef
6371239e-2dcf-40fb-b630-2459ca5f569f
b2fde49c-0193-4a08-87ea-9091f100077c
f19a5b53-68bf-438b-8f09-f4e4c9f4aa03
5fbcc128-a675-4438-9140-b6aab16159dd
eb30d2f4-991e-4a9f-bdc0-8d3e322306ed
dedd95f6-4bee-4b51-84f7-74e6c552a7a5
88472f44-fde6-4687-ae8a-6e55c7ca063c
79f93cd5-e77f-4e1d-afb5-bd1a737652a6
789770ad-9f31-4f1b-8fcc-ca1cfd0fdc2b
cb0a053a-abd0-4df0-b5db-a2cbb8b67f4f
07769881-d9fd-4b60-a264-e977862853f0
5d9c2c7c-4a6a-44bc-a8ee-e61499ab5c21
c9815ab5-4e93-47d4-aeb0-95ee1743b05e
5037a9cd-26c0-4e38-abe1-815419894e41
98f7e11f-4a81-4f75-b47c-1cc77b8bc319
ec6f5345-d5e2-4eab-8aac-0de64398f3e4
97b38cc2-d549-4a62-9dc5-ac5981dc5441
d7c189d7-914f-4894-9676-12e4ac88b083
d3e09a07-4144-4a42-9372-34797fa2d322
2ceb9a7a-dea2-45cd-9adc-efaab51fb99f
6e710488-829c-49fa-9395-ba4c9292103d
b955a8b6-0084-483d-b0da-0310e39a20d5
4606e7db-13ca-495c-a731-c102fde7807f
9bcb5e8c-04b2-480d-851d-70becd5133e4
892c82bd-b0e5-4525-bd28-d2d0cd4bf0fe
ef107604-ea81-4be2-822b-b1d1b55dc8a1
a3b7299c-f254-4762-9e33-2f05e41660df
f1e4c38d-d1d2-4e98-8206-87f450f9345d
b3147518-aa06-4922-b4a6-bb37795ef666
f518920d-bfff-45a6-a46f-2c78bfd468f0
c9e28329-b399-4f91-a5be-91019d9c7156
dd246496-bc36-4c0e-a793-86175c3cbfd6
e199589a-7d7a-47f4-a3f7-ac3e2ba4331d
89288969-324a-4b85-8926-c8e8e442e6e0
96935de8-df24-4a55-9892-3e45bb15cf0a
c99822af-8411-4077-a8a1-4ec275961ffb
df1d7905-edad-4905-92c8-b7765e5dc44a
5498b778-064e-4f58-9535-581cd9d65b1a
a482526f-20ab-4fab-898e-203ca539a8af
aed73850-f650-4482-a3b7-8c462cdec415
2319e588-bb37-4159-9f3a-86bd9ea03125
0f5cc091-9c15-4e2f-92c4-8088f3e83ab1
d3400e69-c271-4cbf-8178-f8a91bb3b715
9e796582-8629-4e90-84f8-ced978e2670c
627bbb3d-9477-4479-9450-5c9ae43d3270
eae97bd1-3e85-4ade-8936-94a4d7b50dfd
d57e9191-6a4a-4c19-af71-305e17910222
190ddc62-718c-4067-9985-295c454453f1
3ffbd55c-a192-4418-8d01-a05a9e4fd47c
a792f69e-0d93-4bc1-8e67-10a65564200c
93ca862b-b651-442c-b6fe-fb11a0b13c7c
c0d46ec4-2e3c-4d72-828f-0c326392d66e
102bde5e-6611-4466-8e83-6dddf117cdf1
abae02dc-52da-48ab-82c4-51cd3af9131e
ecb35dfd-f93d-4aa2-a6ec-e8944e5da20b
20944134-a900-4791-8b5f-5236d78db692
ad00438d-cda1-425a-998f-b1986a6a5b23
f71db8ba-9806-42ab-9eef-fdeb1ac0cd1b
955e09e0-6fe8-4209-a85b-86650f8b1469
02b692ca-36ba-4aa3-84d0-ac3b2acde399
5f954a91-01b2-4994-9aea-5247f41bba19
f544b825-5280-462b-bfef-962585f0cde9
2e5ffc83-b8a9-4fbe-94f1-60279bac8546
431a07af-e4d1-4346-bb93-a716aadbbfdc
690ac130-4f66-4560-8352-5265946a862c
d26e1415-349b-4d02-bab9-2d8de4f45658
832d214b-56c2-42ed-b852-d6a2f6514eac
a5ac3c4c-9fc8-4197-a565-4c058be8a90f
70c2ff19-13e1-467d-81fc-f8f8b5796815
832ab46a-853a-41e2-bf9a-70410a36159a
948b694f-41e2-4b63-8f94-26c6ec1148a1
c9bc8ce6-50fa-47ff-86b4-a370a4618e84
6c8409dc-17fa-49a0-bc68-d2989b1064e0
61befdce-d4ee-4ad1-a9bf-7c842001641b
80956ab9-6fcc-47c7-b4b9-e6e6e74c2af5
30e830b5-4a6c-4b66-8d94-fa53cc39c827
70df4ada-b630-4acf-88c7-c06c02f7c5d4
735e2e8c-b4a2-48bb-b431-708b299e3635
e26e653c-d5c5-4c54-aef2-1d7b54ab41e1
e1efdab3-4574-4849-9a19-31a650d8d25d
f6c28dd7-3f4f-444d-b74f-cb4ebaf04a38
21bf492b-169c-4df7-b1c6-e72d0e775c8b
54d9d5e0-c9c8-487e-8c88-6c53d03bd3df
36589b06-e6b5-43c5-a2e0-98500b16fcfe
ae108eb8-e0ab-496a-aa97-d2c1f51a5713
5dc2f6a9-5c05-4faf-950a-0cfa608ca05e
f6d14e81-168a-4eda-b1ec-e49f04170c91
78a622b7-75a5-4fff-9494-f34e6b6c7206
bb2a754c-c566-4510-9f48-5e5018fddbc5
a8d1e084-4006-4c44-97c0-6c057796fb89
b5cec853-d46c-4347-9821-7346e003a3fb
63f0007f-6a43-4eca-9bdb-deaa68ab9805
062717c7-b4b0-4c4e-931c-d5aea432e364
8a9703f3-02b9-4e0f-a37f-53b810a7dc8e
829da235-86df-4b56-9c66-ce8b58180e61
77c87321-9eae-459d-a9b1-787b0ac55695
a0f861f7-558e-451b-9f08-311417d631a1
b5bc28d6-33ce-4375-ae49-25ef1f8f585a
f09412c6-7100-4645-9976-9870f9bda0af
85faaeff-8112-4887-9b42-1ad7eb2a93eb
0c1dd08d-1d3a-4158-abbc-935013772a8e
faae6b89-5b63-44db-9b26-fd912081f9eb
f095b815-e75b-4e55-8b1f-eee1638a18aa
c4a3190c-4ac9-4e42-8ecc-428db8ee6f64
136c28ea-e267-45a9-ab88-659de1fd3fad
ccde08b4-7101-45c5-98da-05c5290aaf50
4b9fed14-4557-44e9-a269-557436fd67dc
2ccd277f-3b3e-492d-b8cc-13e00c7f4f53
f707d146-3253-4deb-ae59-ec792d8aadb3
86a5a3ad-9a3b-409c-acd7-4e7bffd60d06
f74fe15e-9531-4615-8890-12364744b727
fd1c4b8e-c499-4c12-8606-0be3ed8492e6
797f69e5-7e59-47db-a6a1-fc247e07a798
762584ed-da5f-4245-8656-afef7e60fedd
4b2ee089-b546-43fd-9eee-621db0ef0f86
8d4da577-bf45-4b52-bbd2-d5825795f2e0
6a40acc6-567c-4c69-b804-305097e67edc
a622d0a8-c49d-4138-9577-28e8d49f5e27
f8860317-72bf-4bac-ae5c-f7984c32af9d
8fb16f11-546e-40e7-8b14-45297d266fda
260ca43a-a55a-4e31-adf9-d61bc532e07a
2d20f866-1481-425d-b0e3-ee9a2ef878cf
0ece619e-fea8-4ae8-8206-b07e73036b11
84d492d9-ada6-425c-b727-3933e658e493
7cf9a466-4cd9-40b8-a8b1-242f5e1f472b
e7a486c6-9568-42ea-8787-50cf7e8d20d7
f4b6e624-cce6-418d-8f9b-1cdc3087293c
c1b34b63-427c-4fe6-9ee1-60d0f5cd557c
48c30b1e-4d78-45f4-9d0a-0c94dae9b37f
11a2c0cb-d51d-448f-b34e-eb5bd66ecb9f
e306ee66-741f-4252-84f3-4c23ca8561de
abf86b5c-3d67-49b9-b89e-4a6976e15b5d
9612d2aa-0209-41c6-a8c2-c44dced19b41
083f5923-07d9-490c-a7d5-a1553f3c1fe5
a941fcd7-003c-470a-bc6a-aa8b4e9a5214
cfd694f0-beb0-46c0-8f1f-766b0ab768d9
f27379a9-0de7-4953-a292-d2428c8de11f
6128043f-5b63-4ae5-849c-f4e0c8270799
e7c058f5-2ce4-4b87-8fb3-d70e0b79909f
2dbf2014-aa30-491e-bc65-4f029c04c2e2
99a0c2d9-b0e3-4c8d-9aef-d1ea3468968f
98be67b9-2284-48c5-9b36-3e40f2640741
83fc647b-ca4b-49ce-8d4a-6803521c136a
8929239b-2c42-4621-b794-0d30bcb86804
0dc4795b-e6e4-49fc-80b5-092be3795016
9c0c36bc-5986-44b6-9fa3-815e1c701927
acdbed73-7ed9-4f94-b844-6b41edf61cf8
bf5ad438-914a-48b9-a745-39d5003c6d14
9332be79-a9bf-4463-9f63-46c590148f71
95d68496-65b6-4ea5-a86a-483b608d5ecb
64a70e24-4f1e-4afa-9935-9e61dc27658b
bfbc4aa1-5c4f-40c7-a53d-a49726a21ea0
9de6c77a-bd54-438a-a594-542cb8bfeb14
9fadeecc-23a6-4746-9ec6-80f88db4a86e
1058f8b2-81a0-4240-9e2d-380e4709be1a
9d5b6b5d-ebb8-436f-a2a5-664137b3c574
334c5590-fac7-4be3-a885-e0b060a54451
606dae42-11ce-4648-857d-4d1ac691ad1c
7712dd68-d472-421f-afa2-0a723cb7bcbd
71f93610-2069-476d-9d56-53583fa637fd
7259b601-89f1-4a1f-8fc4-56926dc068b8
1e8ca0ca-52f1-47f5-9df2-d65b9670500c
050e2056-3eb0-4067-8632-b0d290b2fc7f
30c7f6cd-cd70-474b-a771-ba591a8eedfc
3e605773-48a6-48f5-834a-de4fd0f8a665
51de9ec2-5e5b-40f2-88bb-e96b0eeacbd8
231bd961-8e68-46be-9257-b468cc2e6056
a657695d-ea87-4431-b5da-c5386bf488c5
005555c3-b10b-46b3-aa86-5ed4a2f08d45
bdbd096d-b4ce-4930-8d61-fd4c0d951648
edd7938c-a7aa-4d8b-88e0-19c829cd284a
27eab72d-1ae5-42af-9659-3c5393f92e26
94a19d0f-f836-4b87-aace-08fa0adeb3b6
7f4abd5b-41d3-46eb-bed9-d31b4486a597
efbbc983-fb6a-4146-9cba-a825f3becd2d
ade67968-9f48-48a0-9cc9-b32aff32c8fc
0152a07e-c9c8-4bb2-8fd5-73c20ba4d3f2
ac467984-2d0c-4c2f-95e7-c14098a20c9e
d1a87b50-c9ed-4ab2-85af-cfcc7c6042db
849b24d4-fe7c-424f-b74e-5e03cc341275
27ef9d33-1cc1-414f-8a4d-3da3e6cf1915
47564b19-6fc8-4189-be1d-9b385bd60387
a7bc399a-5542-428f-8687-f9f462592d12
d5dd99e0-fe2e-44d4-b166-d0731b4e7d5d
d9152df1-b642-4b9d-b442-d4e68ba906b4
296e301d-2985-450e-b70a-f1ba7026500b
a3d94c88-cd80-4474-9c09-9b7c0f96000d
b58e5a82-5491-4651-8ab0-c9ded00592f0
93481a0d-e8e3-41f2-8592-f2a548432e43
a5523989-af5b-4ae9-bba3-8f6f91cbf5ae
17424e41-7d15-4631-89cd-f3c955911e79
4a3e2b8e-70ed-48ad-9193-b2f1174b9932
8494484d-6cd9-41b3-bcad-eece9cf18b13
5628b26b-f6c5-4986-96b9-4f8102238700
1864e625-ec7a-4449-a2dc-50c3b9593f81
b3cbbb84-0fad-40b6-9e65-7be5eed8b1aa
84ac0db8-d480-4d08-abbe-bd667337e5d9
0050395f-524b-4aa3-81d8-ccf668cdb6f5
9e6da3f7-5785-4828-8fd8-b283b7be4fd4
7f78e932-3381-4875-8610-8afcb146e5c5
77cf5e35-e1e9-4120-b069-fee8d0d1b803
bfa9793e-40cc-4c04-a763-a954b639ce34
d790964c-aea9-4e7f-991e-4916b37135c0
96bb0667-9322-4b3a-96aa-fc825ffc39be
6786bee2-c0ed-4e1b-a6ec-4e2e4e904312
67631fae-5814-42c7-9970-427020293dd7
fbf41327-2c15-4ad7-8ea0-d97c79e82d30
051c5124-c9d4-4202-b402-d9466f18b6e0
4e3e4112-ca7b-4a72-b7e4-ddf6a19c0c95
269f262a-7335-4a05-b7dc-c125e309b851
fdf5fd2f-bfa7-4529-856f-2d56174a922b
790e72a6-df8d-4389-9360-ea6f7f869869
3c921302-1a45-4345-905d-124296663213
0f20bd41-39e2-485b-9f29-827c2f048239
59200dc7-3a0e-434d-b358-4337044d368c
1ee11a67-c5be-49e3-9fbb-1b57300d4fba
16105dd0-806f-4920-b1ed-a48d5c189279
54d4b402-17e8-4901-b804-e46e8ee93f7d
3246e7e8-4851-4e95-8d91-b907e18e2c2a
798146ff-2d95-4ec2-a1ee-6937cb633149
fd7f9029-730b-4b82-81b6-42f2da629f03
512af019-3dd9-47b4-b28b-5d677aa1b22b
c1f71397-0faf-4f59-8b6a-3a698770fd68
02305490-a724-445b-837f-271a51d14b30
dd781f83-90da-4bc9-b775-c9f68d6ac134
622a88d8-f569-42e3-9a32-93b6979b644e
e06bccd1-3970-4bab-bd50-309ce99298bb
6a418b3c-839b-4fc7-b4e4-a5b19a203e04
b6282c67-d08c-4b9c-8d3b-18f45e97013d
ee696fdb-4d5c-4ec1-af77-f18d651db39d
d9b4c68a-0e7f-494c-a380-b089f0db9796
a7aa7e8f-2e0f-45fd-bc7b-41608f164774
20fa345f-5945-4364-a7b5-98c576fbbf8f
fe337f7c-54ed-46c9-b5fa-84910f1e2282
95b580c3-d3cd-4e48-9791-e2d8ce4a2330
16cc85e9-aa14-4314-9bb8-ea3b27835e3a
1bc1dabe-c142-40cc-82c8-c6cdb87c2d2b
\.


--
-- Data for Name: entity_type; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.entity_type (id, label) FROM stdin;
1	none
\.


--
-- Data for Name: eperson; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.eperson (eperson_id, email, password, can_log_in, require_certificate, self_registered, last_active, sub_frequency, netid, salt, digest_algorithm, uuid, session_salt) FROM stdin;
\N	admin@dspace.com	487dc510ef8b239d0e17c96b039a29ea7e8a282efc8719e3ec955af325305cb4904c73e8ef7d99dcd50ced308a450d1d5e95508c67d980862978ce5350da0a48	t	f	f	2025-07-13 18:06:38.597	\N	\N	b6120cebb26ff4cb7b65af63230396a0	SHA-512	75c3ab94-832e-4d84-9b5c-10b046200c09	rJhUD1oAtiwLs9WyA/+fSgYaGzlFOsI7
\N	shubhamkumarsinghbxr@gmail.com	6446f93cb5cebe9ee8b514fd5d2909c5face1ec9ce0c091c35a636164e752294ddf6e1a4ce0818a67e2284a1057fe6ce22a91d8fbd635b943d2ecbf7c9e274c1	t	f	f	2025-05-24 23:42:28.443	\N	\N	60de462d9b390db12899332e541b70f3	SHA-512	622fda42-aaec-495d-81ca-eff8577777b5	
\.


--
-- Data for Name: epersongroup; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.epersongroup (eperson_group_id, uuid, permanent, name) FROM stdin;
\N	ea708783-6e3b-42be-b7ae-a27a039d48d5	t	Anonymous
\N	62a74c58-773e-497a-b5d8-026f1787b9f3	t	Administrator
\.


--
-- Data for Name: epersongroup2eperson; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.epersongroup2eperson (eperson_group_id, eperson_id) FROM stdin;
62a74c58-773e-497a-b5d8-026f1787b9f3	75c3ab94-832e-4d84-9b5c-10b046200c09
\.


--
-- Data for Name: fileextension; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.fileextension (file_extension_id, bitstream_format_id, extension) FROM stdin;
1	4	pdf
2	5	xml
3	6	txt
4	6	asc
5	7	htm
6	7	html
7	8	css
8	9	csv
9	10	doc
10	11	docx
11	12	ppt
12	13	pptx
13	14	xls
14	15	xlsx
15	17	jpeg
16	17	jpg
17	17	jfif
18	18	gif
19	19	png
20	20	tiff
21	20	tif
22	21	aiff
23	21	aif
24	21	aifc
25	22	au
26	22	snd
27	23	wav
28	24	mpeg
29	24	mpg
30	24	mpe
31	25	rtf
32	26	vsd
33	27	fm
34	28	bmp
35	29	psd
36	29	pdd
37	30	ps
38	30	eps
39	30	ai
40	31	mov
41	31	qt
42	32	mp4
43	33	ogg
44	34	webm
45	35	mpa
46	35	abs
47	35	mpega
48	36	mpp
49	36	mpx
50	36	mpd
51	37	ma
52	38	latex
53	39	tex
54	40	dvi
55	41	sgm
56	41	sgml
57	42	wpd
58	43	ra
59	43	ram
60	44	pcd
61	45	odt
62	46	ott
63	47	oth
64	48	odm
65	49	odg
66	50	otg
67	51	odp
68	52	otp
69	53	ods
70	54	ots
71	55	odc
72	56	odf
73	57	odb
74	58	odi
75	59	oxt
76	60	sxw
77	61	stw
78	62	sxc
79	63	stc
80	64	sxd
81	65	std
82	66	sxi
83	67	sti
84	68	sxg
85	69	sxm
86	70	sdw
87	71	sgl
88	72	sdc
89	73	sda
90	74	sdd
91	75	sdp
92	76	smf
93	77	sds
94	78	sdm
95	79	rdf
96	80	epub
97	81	mp3
98	82	vtt
99	83	jp2
100	84	webp
101	85	avif
102	86	js
\.


--
-- Data for Name: group2group; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.group2group (parent_id, child_id) FROM stdin;
\.


--
-- Data for Name: group2groupcache; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.group2groupcache (parent_id, child_id) FROM stdin;
\.


--
-- Data for Name: handle; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.handle (handle_id, handle, resource_type_id, resource_legacy_id, resource_id) FROM stdin;
1	123456789/0	5	\N	23e54f59-2618-49fe-bb8c-7278e389948f
174	123456789/173	3	\N	\N
226	123456789/225	4	\N	\N
130	123456789/129	3	\N	\N
129	123456789/128	4	\N	\N
81	123456789/80	2	\N	\N
4	123456789/3	4	\N	\N
3	123456789/2	4	\N	\N
80	123456789/79	3	\N	\N
79	123456789/78	4	\N	\N
317	123456789/316	3	\N	\N
5	123456789/4	3	\N	\N
133	123456789/132	3	\N	\N
229	123456789/228	3	\N	\N
8	123456789/7	2	\N	\N
228	123456789/227	4	\N	\N
140	123456789/139	3	\N	\N
139	123456789/138	4	\N	\N
231	123456789/230	3	\N	\N
230	123456789/229	4	\N	\N
143	123456789/142	3	\N	\N
14	123456789/13	4	\N	\N
13	123456789/12	4	\N	\N
418	123456789/417	2	\N	\N
15	123456789/14	3	\N	\N
366	123456789/365	2	\N	\N
364	123456789/363	2	\N	\N
16	123456789/15	2	\N	\N
365	123456789/364	2	\N	\N
340	123456789/339	3	\N	\N
6	123456789/5	4	\N	\N
19	123456789/18	4	\N	\N
18	123456789/17	4	\N	\N
20	123456789/19	4	\N	\N
21	123456789/20	4	\N	\N
183	123456789/182	2	\N	\N
190	123456789/189	2	\N	\N
22	123456789/21	4	\N	\N
181	123456789/180	2	\N	\N
178	123456789/177	2	\N	\N
23	123456789/22	4	\N	\N
182	123456789/181	2	\N	\N
179	123456789/178	2	\N	\N
24	123456789/23	4	\N	\N
180	123456789/179	2	\N	\N
187	123456789/186	2	\N	\N
25	123456789/24	4	\N	\N
186	123456789/185	2	\N	\N
26	123456789/25	4	\N	\N
27	123456789/26	4	\N	\N
255	123456789/254	2	\N	\N
28	123456789/27	4	\N	\N
239	123456789/238	2	\N	\N
232	123456789/231	4	\N	\N
29	123456789/28	4	\N	\N
84	123456789/83	2	\N	\N
32	123456789/31	3	\N	\N
10	123456789/9	2	\N	\N
171	123456789/170	3	\N	\N
168	123456789/167	2	\N	\N
163	123456789/162	2	\N	\N
164	123456789/163	2	\N	\N
167	123456789/166	2	\N	\N
166	123456789/165	2	\N	\N
156	123456789/155	2	\N	\N
155	123456789/154	2	\N	\N
157	123456789/156	2	\N	\N
150	123456789/149	2	\N	\N
154	123456789/153	2	\N	\N
153	123456789/152	2	\N	\N
159	123456789/158	2	\N	\N
152	123456789/151	2	\N	\N
158	123456789/157	2	\N	\N
160	123456789/159	2	\N	\N
151	123456789/150	2	\N	\N
162	123456789/161	2	\N	\N
161	123456789/160	2	\N	\N
169	123456789/168	2	\N	\N
165	123456789/164	2	\N	\N
149	123456789/148	3	\N	\N
73	123456789/72	4	\N	\N
75	123456789/74	3	\N	\N
74	123456789/73	4	\N	\N
46	123456789/45	2	\N	\N
36	123456789/35	2	\N	\N
77	123456789/76	2	\N	\N
38	123456789/37	2	\N	\N
31	123456789/30	3	\N	\N
30	123456789/29	4	\N	\N
17	123456789/16	4	\N	\N
42	123456789/41	2	\N	\N
35	123456789/34	2	\N	\N
62	123456789/61	2	\N	\N
67	123456789/66	2	\N	\N
61	123456789/60	2	\N	\N
59	123456789/58	2	\N	\N
58	123456789/57	2	\N	\N
68	123456789/67	2	\N	\N
50	123456789/49	2	\N	\N
54	123456789/53	2	\N	\N
57	123456789/56	2	\N	\N
47	123456789/46	2	\N	\N
52	123456789/51	2	\N	\N
63	123456789/62	2	\N	\N
65	123456789/64	2	\N	\N
64	123456789/63	2	\N	\N
71	123456789/70	2	\N	\N
40	123456789/39	2	\N	\N
37	123456789/36	2	\N	\N
56	123456789/55	2	\N	\N
69	123456789/68	2	\N	\N
72	123456789/71	2	\N	\N
53	123456789/52	2	\N	\N
66	123456789/65	2	\N	\N
33	123456789/32	2	\N	\N
39	123456789/38	2	\N	\N
60	123456789/59	2	\N	\N
70	123456789/69	2	\N	\N
55	123456789/54	2	\N	\N
11	123456789/10	3	\N	\N
49	123456789/48	2	\N	\N
34	123456789/33	2	\N	\N
45	123456789/44	2	\N	\N
48	123456789/47	2	\N	\N
44	123456789/43	2	\N	\N
43	123456789/42	2	\N	\N
9	123456789/8	2	\N	\N
51	123456789/50	2	\N	\N
12	123456789/11	2	\N	\N
76	123456789/75	2	\N	\N
78	123456789/77	2	\N	\N
41	123456789/40	2	\N	\N
7	123456789/6	3	\N	\N
2	123456789/1	4	\N	\N
127	123456789/126	3	\N	\N
126	123456789/125	4	\N	\N
128	123456789/127	3	\N	\N
98	123456789/97	2	\N	\N
105	123456789/104	2	\N	\N
94	123456789/93	2	\N	\N
86	123456789/85	2	\N	\N
104	123456789/103	2	\N	\N
87	123456789/86	2	\N	\N
90	123456789/89	2	\N	\N
92	123456789/91	2	\N	\N
96	123456789/95	2	\N	\N
93	123456789/92	2	\N	\N
88	123456789/87	2	\N	\N
95	123456789/94	2	\N	\N
91	123456789/90	2	\N	\N
102	123456789/101	2	\N	\N
101	123456789/100	2	\N	\N
89	123456789/88	2	\N	\N
100	123456789/99	2	\N	\N
103	123456789/102	2	\N	\N
99	123456789/98	2	\N	\N
97	123456789/96	2	\N	\N
83	123456789/82	3	\N	\N
120	123456789/119	2	\N	\N
116	123456789/115	2	\N	\N
117	123456789/116	2	\N	\N
110	123456789/109	2	\N	\N
114	123456789/113	2	\N	\N
121	123456789/120	2	\N	\N
113	123456789/112	2	\N	\N
118	123456789/117	2	\N	\N
111	123456789/110	2	\N	\N
122	123456789/121	2	\N	\N
119	123456789/118	2	\N	\N
123	123456789/122	2	\N	\N
112	123456789/111	2	\N	\N
107	123456789/106	2	\N	\N
124	123456789/123	2	\N	\N
115	123456789/114	2	\N	\N
106	123456789/105	2	\N	\N
125	123456789/124	2	\N	\N
108	123456789/107	2	\N	\N
109	123456789/108	2	\N	\N
85	123456789/84	3	\N	\N
82	123456789/81	4	\N	\N
131	123456789/130	3	\N	\N
173	123456789/172	4	\N	\N
227	123456789/226	3	\N	\N
132	123456789/131	4	\N	\N
233	123456789/232	3	\N	\N
135	123456789/134	3	\N	\N
134	123456789/133	4	\N	\N
196	123456789/195	2	\N	\N
195	123456789/194	2	\N	\N
142	123456789/141	4	\N	\N
192	123456789/191	2	\N	\N
193	123456789/192	2	\N	\N
170	123456789/169	4	\N	\N
191	123456789/190	2	\N	\N
184	123456789/183	2	\N	\N
172	123456789/171	3	\N	\N
148	123456789/147	4	\N	\N
194	123456789/193	2	\N	\N
189	123456789/188	2	\N	\N
197	123456789/196	2	\N	\N
185	123456789/184	2	\N	\N
188	123456789/187	2	\N	\N
177	123456789/176	3	\N	\N
176	123456789/175	4	\N	\N
199	123456789/198	3	\N	\N
198	123456789/197	4	\N	\N
202	123456789/201	3	\N	\N
201	123456789/200	4	\N	\N
393	123456789/392	2	\N	\N
395	123456789/394	2	\N	\N
390	123456789/389	2	\N	\N
389	123456789/388	2	\N	\N
394	123456789/393	2	\N	\N
391	123456789/390	2	\N	\N
392	123456789/391	2	\N	\N
396	123456789/395	2	\N	\N
387	123456789/386	4	\N	\N
328	123456789/327	2	\N	\N
333	123456789/332	2	\N	\N
318	123456789/317	2	\N	\N
329	123456789/328	2	\N	\N
320	123456789/319	2	\N	\N
322	123456789/321	2	\N	\N
327	123456789/326	2	\N	\N
336	123456789/335	2	\N	\N
319	123456789/318	2	\N	\N
334	123456789/333	2	\N	\N
324	123456789/323	2	\N	\N
331	123456789/330	2	\N	\N
335	123456789/334	2	\N	\N
325	123456789/324	2	\N	\N
323	123456789/322	2	\N	\N
326	123456789/325	2	\N	\N
337	123456789/336	2	\N	\N
321	123456789/320	2	\N	\N
330	123456789/329	2	\N	\N
332	123456789/331	2	\N	\N
221	123456789/220	2	\N	\N
213	123456789/212	2	\N	\N
224	123456789/223	2	\N	\N
225	123456789/224	2	\N	\N
218	123456789/217	2	\N	\N
222	123456789/221	2	\N	\N
211	123456789/210	2	\N	\N
207	123456789/206	2	\N	\N
223	123456789/222	2	\N	\N
208	123456789/207	2	\N	\N
220	123456789/219	2	\N	\N
217	123456789/216	2	\N	\N
206	123456789/205	2	\N	\N
210	123456789/209	2	\N	\N
212	123456789/211	2	\N	\N
215	123456789/214	2	\N	\N
219	123456789/218	2	\N	\N
214	123456789/213	2	\N	\N
209	123456789/208	2	\N	\N
216	123456789/215	2	\N	\N
205	123456789/204	3	\N	\N
204	123456789/203	4	\N	\N
260	123456789/259	2	\N	\N
251	123456789/250	2	\N	\N
242	123456789/241	2	\N	\N
264	123456789/263	2	\N	\N
246	123456789/245	2	\N	\N
245	123456789/244	2	\N	\N
253	123456789/252	2	\N	\N
261	123456789/260	2	\N	\N
241	123456789/240	2	\N	\N
372	123456789/371	2	\N	\N
368	123456789/367	2	\N	\N
369	123456789/368	2	\N	\N
373	123456789/372	2	\N	\N
359	123456789/358	2	\N	\N
347	123456789/346	2	\N	\N
343	123456789/342	2	\N	\N
345	123456789/344	2	\N	\N
349	123456789/348	2	\N	\N
358	123456789/357	2	\N	\N
341	123456789/340	2	\N	\N
351	123456789/350	2	\N	\N
353	123456789/352	2	\N	\N
344	123456789/343	2	\N	\N
316	123456789/315	4	\N	\N
339	123456789/338	3	\N	\N
383	123456789/382	3	\N	\N
379	123456789/378	2	\N	\N
382	123456789/381	2	\N	\N
378	123456789/377	2	\N	\N
363	123456789/362	2	\N	\N
371	123456789/370	2	\N	\N
376	123456789/375	2	\N	\N
367	123456789/366	2	\N	\N
370	123456789/369	2	\N	\N
380	123456789/379	2	\N	\N
377	123456789/376	2	\N	\N
375	123456789/374	2	\N	\N
381	123456789/380	2	\N	\N
374	123456789/373	2	\N	\N
362	123456789/361	3	\N	\N
361	123456789/360	4	\N	\N
384	123456789/383	4	\N	\N
342	123456789/341	2	\N	\N
352	123456789/351	2	\N	\N
360	123456789/359	2	\N	\N
350	123456789/349	2	\N	\N
357	123456789/356	2	\N	\N
346	123456789/345	2	\N	\N
301	123456789/300	2	\N	\N
311	123456789/310	2	\N	\N
306	123456789/305	2	\N	\N
300	123456789/299	2	\N	\N
315	123456789/314	2	\N	\N
296	123456789/295	2	\N	\N
304	123456789/303	2	\N	\N
236	123456789/235	2	\N	\N
314	123456789/313	2	\N	\N
240	123456789/239	2	\N	\N
298	123456789/297	2	\N	\N
290	123456789/289	2	\N	\N
277	123456789/276	2	\N	\N
248	123456789/247	2	\N	\N
262	123456789/261	2	\N	\N
238	123456789/237	2	\N	\N
303	123456789/302	2	\N	\N
274	123456789/273	2	\N	\N
237	123456789/236	2	\N	\N
313	123456789/312	2	\N	\N
279	123456789/278	2	\N	\N
297	123456789/296	2	\N	\N
308	123456789/307	2	\N	\N
283	123456789/282	2	\N	\N
275	123456789/274	2	\N	\N
266	123456789/265	2	\N	\N
293	123456789/292	2	\N	\N
250	123456789/249	2	\N	\N
299	123456789/298	2	\N	\N
271	123456789/270	2	\N	\N
258	123456789/257	2	\N	\N
273	123456789/272	2	\N	\N
276	123456789/275	2	\N	\N
284	123456789/283	2	\N	\N
289	123456789/288	2	\N	\N
257	123456789/256	2	\N	\N
265	123456789/264	2	\N	\N
280	123456789/279	2	\N	\N
287	123456789/286	2	\N	\N
278	123456789/277	2	\N	\N
291	123456789/290	2	\N	\N
294	123456789/293	2	\N	\N
249	123456789/248	2	\N	\N
305	123456789/304	2	\N	\N
307	123456789/306	2	\N	\N
263	123456789/262	2	\N	\N
270	123456789/269	2	\N	\N
267	123456789/266	2	\N	\N
292	123456789/291	2	\N	\N
295	123456789/294	2	\N	\N
252	123456789/251	2	\N	\N
269	123456789/268	2	\N	\N
285	123456789/284	2	\N	\N
309	123456789/308	2	\N	\N
310	123456789/309	2	\N	\N
243	123456789/242	2	\N	\N
259	123456789/258	2	\N	\N
282	123456789/281	2	\N	\N
288	123456789/287	2	\N	\N
256	123456789/255	2	\N	\N
281	123456789/280	2	\N	\N
244	123456789/243	2	\N	\N
235	123456789/234	2	\N	\N
272	123456789/271	2	\N	\N
302	123456789/301	2	\N	\N
286	123456789/285	2	\N	\N
254	123456789/253	2	\N	\N
247	123456789/246	2	\N	\N
268	123456789/267	2	\N	\N
312	123456789/311	2	\N	\N
234	123456789/233	3	\N	\N
356	123456789/355	2	\N	\N
355	123456789/354	2	\N	\N
354	123456789/353	2	\N	\N
348	123456789/347	2	\N	\N
446	123456789/445	2	\N	\N
426	123456789/425	2	\N	\N
438	123456789/437	2	\N	\N
420	123456789/419	2	\N	\N
423	123456789/422	2	\N	\N
427	123456789/426	2	\N	\N
425	123456789/424	2	\N	\N
405	123456789/404	2	\N	\N
433	123456789/432	2	\N	\N
385	123456789/384	3	\N	\N
338	123456789/337	4	\N	\N
432	123456789/431	2	\N	\N
421	123456789/420	2	\N	\N
435	123456789/434	2	\N	\N
406	123456789/405	2	\N	\N
408	123456789/407	2	\N	\N
424	123456789/423	2	\N	\N
417	123456789/416	2	\N	\N
422	123456789/421	2	\N	\N
445	123456789/444	2	\N	\N
437	123456789/436	2	\N	\N
429	123456789/428	2	\N	\N
402	123456789/401	2	\N	\N
419	123456789/418	2	\N	\N
398	123456789/397	2	\N	\N
428	123456789/427	2	\N	\N
430	123456789/429	2	\N	\N
409	123456789/408	2	\N	\N
411	123456789/410	2	\N	\N
410	123456789/409	2	\N	\N
431	123456789/430	2	\N	\N
407	123456789/406	2	\N	\N
434	123456789/433	2	\N	\N
403	123456789/402	2	\N	\N
399	123456789/398	2	\N	\N
400	123456789/399	2	\N	\N
436	123456789/435	2	\N	\N
397	123456789/396	2	\N	\N
444	123456789/443	2	\N	\N
404	123456789/403	2	\N	\N
401	123456789/400	2	\N	\N
388	123456789/387	3	\N	\N
447	123456789/446	4	\N	95d68496-65b6-4ea5-a86a-483b608d5ecb
\.


--
-- Data for Name: harvested_collection; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.harvested_collection (harvest_type, oai_source, oai_set_id, harvest_message, metadata_config_id, harvest_status, harvest_start_time, last_harvested, id, collection_id) FROM stdin;
\.


--
-- Data for Name: harvested_item; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.harvested_item (last_harvested, oai_id, id, item_id) FROM stdin;
\.


--
-- Data for Name: item; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.item (item_id, in_archive, withdrawn, last_modified, discoverable, uuid, submitter_id, owning_collection) FROM stdin;
\.


--
-- Data for Name: item2bundle; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.item2bundle (bundle_id, item_id) FROM stdin;
\.


--
-- Data for Name: ldn_message; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.ldn_message (id, object, message, type, origin, target, inreplyto, context, activity_stream_type, coar_notify_type, queue_status, queue_attempts, queue_last_start_time, queue_timeout, source_ip) FROM stdin;
\.


--
-- Data for Name: metadatafieldregistry; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.metadatafieldregistry (metadata_field_id, metadata_schema_id, element, qualifier, scope_note) FROM stdin;
1	2	firstname	\N	\N
2	2	lastname	\N	\N
3	2	phone	\N	\N
4	2	language	\N	\N
5	1	provenance	\N	\N
6	1	rights	license	\N
7	3	entity	type	\N
8	1	contributor	\N	A person, organization, or service responsible for the content of the resource.  Catch-all for unspecified contributors.
10	1	contributor	author	\N
13	1	contributor	other	\N
14	1	coverage	spatial	Spatial characteristics of content.
15	1	coverage	temporal	Temporal characteristics of content.
16	1	creator	\N	Do not use; only for harvested metadata.
17	1	date	\N	Use qualified form if possible.
18	1	date	accessioned	Date DSpace takes possession of item.
19	1	date	available	Date or date range item became available to the public.
20	1	date	copyright	Date of copyright.
21	1	date	created	Date of creation or manufacture of intellectual content if different from date.issued.
22	1	date	issued	Date of publication or distribution.
23	1	date	submitted	Recommend for theses/dissertations.
24	1	identifier	\N	Catch-all for unambiguous identifiers not defined by\n    qualified form; use identifier.other for a known identifier common\n    to a local collection instead of unqualified form.
25	1	identifier	citation	Human-readable, standard bibliographic citation \n    of non-DSpace format of this item
26	1	identifier	govdoc	A government document number
27	1	identifier	isbn	International Standard Book Number
28	1	identifier	issn	International Standard Serial Number
29	1	identifier	sici	Serial Item and Contribution Identifier
30	1	identifier	ismn	International Standard Music Number
31	1	identifier	other	A known identifier type common to a local collection.
32	1	identifier	doi	\N
33	1	identifier	scopus	The scopus identifier
34	1	identifier	uri	Uniform Resource Identifier
35	1	description	\N	Catch-all for any description not defined by qualifiers.
36	1	description	abstract	Abstract or summary.
37	1	description	provenance	The history of custody of the item since its creation, including any changes successive custodians made to it.
38	1	description	sponsorship	Information about sponsoring agencies, individuals, or\n    contractual arrangements for the item.
39	1	description	statementofresponsibility	To preserve statement of responsibility from MARC records.
40	1	description	tableofcontents	A table of contents for a given item.
41	1	description	uri	Uniform Resource Identifier pointing to description of\n    this item.
43	1	format	extent	Size or duration.
44	1	format	medium	Physical medium.
45	1	format	mimetype	Registered MIME type identifiers.
46	1	language	\N	Catch-all for non-ISO forms of the language of the\n    item, accommodating harvested values.
47	1	language	iso	Current ISO standard for language of intellectual content, including country codes (e.g. "en_US").
48	1	publisher	\N	Entity responsible for publication, distribution, or imprint.
50	1	relation	isformatof	References additional physical form.
51	1	relation	ispartof	References physically or logically containing item.
52	1	relation	ispartofseries	Series name and number within that series, if available.
53	1	relation	haspart	References physically or logically contained item.
54	1	relation	isversionof	References earlier version.
55	1	relation	hasversion	References later version.
56	1	relation	isbasedon	References source.
57	1	relation	isreferencedby	Pointed to by referenced resource.
58	1	relation	requires	Referenced resource is required to support function,\n    delivery, or coherence of item.
59	1	relation	replaces	References preceeding item.
60	1	relation	isreplacedby	References succeeding item.
61	1	relation	uri	References Uniform Resource Identifier for related item.
62	1	rights	\N	Terms governing use and reproduction.
63	1	rights	uri	References terms governing use and reproduction.
64	1	source	\N	Do not use; only for harvested metadata.
65	1	source	uri	Do not use; only for harvested metadata.
66	1	subject	\N	Uncontrolled index term.
67	1	subject	classification	Catch-all for value from local classification system;\n    global classification systems will receive specific qualifier
68	1	subject	ddc	Dewey Decimal Classification Number
69	1	subject	lcc	Library of Congress Classification Number
70	1	subject	lcsh	Library of Congress Subject Headings
71	1	subject	mesh	MEdical Subject Headings
72	1	subject	other	Local controlled vocabulary; global vocabularies will receive specific qualifier.
73	1	title	\N	Title statement/title proper.
74	1	title	alternative	Varying (or substitute) form of title proper appearing in item,\n    e.g. abbreviation or translation
75	1	type	\N	Nature or genre of content.
76	4	abstract	\N	A summary of the resource.
77	4	accessRights	\N	Information about who can access the resource or an indication of its security status. May include information regarding access or restrictions based on privacy, security, or other policies.
78	4	accrualMethod	\N	The method by which items are added to a collection.
79	4	accrualPeriodicity	\N	The frequency with which items are added to a collection.
80	4	accrualPolicy	\N	The policy governing the addition of items to a collection.
81	4	alternative	\N	An alternative name for the resource.
11	1	contributor	illustrator	\N
82	4	audience	\N	A class of entity for whom the resource is intended or useful.
83	4	available	\N	Date (often a range) that the resource became or will become available.
84	4	bibliographicCitation	\N	Recommended practice is to include sufficient bibliographic detail to identify the resource as unambiguously as possible.
85	4	conformsTo	\N	An established standard to which the described resource conforms.
86	4	contributor	\N	An entity responsible for making contributions to the resource. Examples of a Contributor include a person, an organization, or a service.
87	4	coverage	\N	The spatial or temporal topic of the resource, the spatial applicability of the resource, or the jurisdiction under which the resource is relevant.
88	4	created	\N	Date of creation of the resource.
89	4	creator	\N	An entity primarily responsible for making the resource.
90	4	date	\N	A point or period of time associated with an event in the lifecycle of the resource.
91	4	dateAccepted	\N	Date of acceptance of the resource.
92	4	dateCopyrighted	\N	Date of copyright.
93	4	dateSubmitted	\N	Date of submission of the resource.
94	4	description	\N	An account of the resource.
95	4	educationLevel	\N	A class of entity, defined in terms of progression through an educational or training context, for which the described resource is intended.
96	4	extent	\N	The size or duration of the resource.
97	4	format	\N	The file format, physical medium, or dimensions of the resource.
98	4	hasFormat	\N	A related resource that is substantially the same as the pre-existing described resource, but in another format.
99	4	hasPart	\N	A related resource that is included either physically or logically in the described resource.
100	4	hasVersion	\N	A related resource that is a version, edition, or adaptation of the described resource.
101	4	identifier	\N	An unambiguous reference to the resource within a given context.
102	4	instructionalMethod	\N	A process, used to engender knowledge, attitudes and skills, that the described resource is designed to support.
103	4	isFormatOf	\N	A related resource that is substantially the same as the described resource, but in another format.
104	4	isPartOf	\N	A related resource in which the described resource is physically or logically included.
105	4	isReferencedBy	\N	A related resource that references, cites, or otherwise points to the described resource.
106	4	isReplacedBy	\N	A related resource that supplants, displaces, or supersedes the described resource.
107	4	isRequiredBy	\N	A related resource that requires the described resource to support its function, delivery, or coherence.
108	4	issued	\N	Date of formal issuance (e.g., publication) of the resource.
109	4	isVersionOf	\N	A related resource of which the described resource is a version, edition, or adaptation.
110	4	language	\N	A language of the resource.
111	4	license	\N	A legal document giving official permission to do something with the resource.
112	4	mediator	\N	An entity that mediates access to the resource and for whom the resource is intended or useful.
113	4	medium	\N	The material or physical carrier of the resource.
114	4	modified	\N	Date on which the resource was changed.
115	4	provenance	\N	A statement of any changes in ownership and custody of the resource since its creation that are significant for its authenticity, integrity, and interpretation.
116	4	publisher	\N	An entity responsible for making the resource available.
117	4	references	\N	A related resource that is referenced, cited, or otherwise pointed to by the described resource.
118	4	relation	\N	A related resource.
119	4	replaces	\N	A related resource that is supplanted, displaced, or superseded by the described resource.
120	4	requires	\N	A related resource that is required by the described resource to support its function, delivery, or coherence.
121	4	rights	\N	Information about rights held in and over the resource.
122	4	rightsHolder	\N	A person or organization owning or managing rights over the resource.
123	4	source	\N	A related resource from which the described resource is derived.
124	4	spatial	\N	Spatial characteristics of the resource.
125	4	subject	\N	The topic of the resource.
126	4	tableOfContents	\N	A list of subunits of the resource.
127	4	temporal	\N	Temporal characteristics of the resource.
128	4	title	\N	A name given to the resource.
129	4	type	\N	The nature or genre of the resource.
130	4	valid	\N	Date (often a range) of validity of a resource.
131	2	orcid	\N	Metadata field used for the ORCID id
132	2	orcid	scope	Metadata field used for the granted ORCID scopes
133	1	date	updated	The last time the item was updated via the SWORD interface
134	1	description	version	The Peer Reviewed status of an item
135	1	identifier	slug	a uri supplied via the sword slug header, as a suggested uri for the item
136	1	language	rfc3066	the rfc3066 form of the language for the item
138	6	isAuthorOfPublication	\N	Contains all uuids of the "latest" AUTHORS that the current PUBLICATION links to via a relationship. In other words, this stores all relationships pointing from the current PUBLICATION to any AUTHOR where the AUTHOR is marked as "latest". Internally used by DSpace. Do not manually add, remove or edit values.
139	6	isAuthorOfPublication	latestForDiscovery	Contains all uuids of AUTHORS which link to the current PUBLICATION via a "latest" relationship. In other words, this stores all relationships pointing to the current PUBLICATION from an AUTHOR, implying that the PUBLICATION is marked as "latest". Internally used by DSpace to support versioning. Do not manually add, remove or edit values.
140	6	isPublicationOfAuthor	\N	Contains all uuids of the "latest" PUBLICATIONS that the current AUTHOR links to via a relationship. In other words, this stores all relationships pointing from the current AUTHOR to any PUBLICATION where the PUBLICATION is marked as "latest". Internally used by DSpace. Do not manually add, remove or edit values.
238	16	geoLocation	\N	Spatial region or named place where the data was gathered or about which the data is focused.
239	16	subject	fos	Fields of Science and Technology - OECD
141	6	isPublicationOfAuthor	latestForDiscovery	Contains all uuids of PUBLICATIONS which link to the current AUTHOR via a "latest" relationship. In other words, this stores all relationships pointing to the current AUTHOR from any PUBLICATION, implying that the AUTHOR is marked as "latest". Internally used by DSpace to support versioning. Do not manually add, remove or edit values.
142	6	isProjectOfPublication	\N	Contains all uuids of the "latest" PROJECTS that the current PUBLICATION links to via a relationship. In other words, this stores all relationships pointing from the current PUBLICATION to any PROJECT where the PROJECT is marked as "latest". Internally used by DSpace. Do not manually add, remove or edit values.
143	6	isProjectOfPublication	latestForDiscovery	Contains all uuids of PROJECTS which link to the current PUBLICATION via a "latest" relationship. In other words, this stores all relationships pointing to the current PUBLICATION from any PROJECT, implying that the PUBLICATION is marked as "latest". Internally used by DSpace to support versioning. Do not manually add, remove or edit values.
144	6	isPublicationOfProject	\N	Contains all uuids of the "latest" PUBLICATIONS that the current PROJECT links to via a relationship. In other words, this stores all relationships pointing from the current PROJECT to any PUBLICATION where the PUBLICATION is marked as "latest". Internally used by DSpace. Do not manually add, remove or edit values.
145	6	isPublicationOfProject	latestForDiscovery	Contains all uuids of PUBLICATIONS which link to the current PROJECT via a "latest" relationship. In other words, this stores all relationships pointing to the current PROJECT from any PUBLICATION, implying that the PROJECT is marked as "latest". Internally used by DSpace to support versioning. Do not manually add, remove or edit values.
146	6	isOrgUnitOfPublication	\N	Contains all uuids of the "latest" ORGANISATIONAL UNITS that the current PUBLICATION links to via a relationship. In other words, this stores all relationships pointing from the current PUBLICATION to any ORGANISATIONAL UNIT where the ORGANISATIONAL UNIT is marked as "latest". Internally used by DSpace. Do not manually add, remove or edit values.
147	6	isOrgUnitOfPublication	latestForDiscovery	Contains all uuids of ORGANISATIONAL UNITSS which link to the current PUBLICATION via a "latest" relationship. In other words, this stores all relationships pointing to the current PUBLICATION from any ORGANISATIONAL UNITS, implying that the PUBLICATION is marked as "latest". Internally used by DSpace to support versioning. Do not manually add, remove or edit values.
148	6	isPublicationOfOrgUnit	\N	Contains all uuids of the "latest" PUBLICATIONS that the current ORGANISATIONAL UNIT links to via a relationship. In other words, this stores all relationships pointing from the current ORGANISATIONAL UNIT to any PUBLICATION where the PUBLICATION is marked as "latest". Internally used by DSpace. Do not manually add, remove or edit values.
149	6	isPublicationOfOrgUnit	latestForDiscovery	Contains all uuids of PUBLICATIONS which link to the current ORGANISATIONAL UNIT via a "latest" relationship. In other words, this stores all relationships pointing to the current ORGANISATIONAL UNIT from any PUBLICATION, implying that the ORGANISATIONAL UNIT is marked as "latest". Internally used by DSpace to support versioning. Do not manually add, remove or edit values.
150	6	isProjectOfPerson	\N	Contains all uuids of the "latest" PROJECTS that the current PERSON links to via a relationship. In other words, this stores all relationships pointing from the current PERSON to any PROJECT where the PROJECT is marked as "latest". Internally used by DSpace. Do not manually add, remove or edit values.
151	6	isProjectOfPerson	latestForDiscovery	Contains all uuids of PROJECTS which link to the current PERSON via a "latest" relationship. In other words, this stores all relationships pointing to the current PERSON from any PROJECT, implying that the PERSON is marked as "latest". Internally used by DSpace to support versioning. Do not manually add, remove or edit values.
152	6	isPersonOfProject	\N	Contains all uuids of the "latest" PERSONS that the current PROJECT links to via a relationship. In other words, this stores all relationships pointing from the current PROJECT to any PERSON where the PERSON is marked as "latest". Internally used by DSpace. Do not manually add, remove or edit values.
153	6	isPersonOfProject	latestForDiscovery	Contains all uuids of PERSONS which link to the current PROJECT via a "latest" relationship. In other words, this stores all relationships pointing to the current PROJECT from any PERSON, implying that the PROJECT is marked as "latest". Internally used by DSpace to support versioning. Do not manually add, remove or edit values.
154	6	isOrgUnitOfPerson	\N	Contains all uuids of the "latest" ORGANISATIONAL UNITS that the current PERSON links to via a relationship. In other words, this stores all relationships pointing from the current PERSON to any ORGANISATIONAL UNIT where the ORGANISATIONAL UNIT is marked as "latest". Internally used by DSpace. Do not manually add, remove or edit values.
155	6	isOrgUnitOfPerson	latestForDiscovery	Contains all uuids of ORGANISATIONAL UNITS which link to the current PERSON via a "latest" relationship. In other words, this stores all relationships pointing to the current PERSON from any ORGANISATIONAL UNIT, implying that the PERSON is marked as "latest". Internally used by DSpace to support versioning. Do not manually add, remove or edit values.
156	6	isPersonOfOrgUnit	\N	Contains all uuids of the "latest" PERSONS that the current ORGANISATIONAL UNIT links to via a relationship. In other words, this stores all relationships pointing from the current ORGANISATIONAL UNIT to any PERSON where the PERSON is marked as "latest". Internally used by DSpace. Do not manually add, remove or edit values.
157	6	isPersonOfOrgUnit	latestForDiscovery	Contains all uuids of PERSONS which link to the current ORGANISATIONAL UNIT via a "latest" relationship. In other words, this stores all relationships pointing to the current ORGANISATIONAL UNIT from any PERSON, implying that the ORGANISATIONAL UNIT is marked as "latest". Internally used by DSpace to support versioning. Do not manually add, remove or edit values.
158	6	isOrgUnitOfProject	\N	Contains all uuids of the "latest" ORGANISATIONAL UNITS that the current PROJECT links to via a relationship. In other words, this stores all relationships pointing from the current PROJECT to any ORGANISATIONAL UNIT where the ORGANISATIONAL UNIT is marked as "latest". Internally used by DSpace. Do not manually add, remove or edit values.
159	6	isOrgUnitOfProject	latestForDiscovery	Contains all uuids of ORGANISATIONAL UNITS which link to the current PROJECT via a "latest" relationship. In other words, this stores all relationships pointing to the current PROJECT from any ORGANISATIONAL UNIT, implying that the PROJECT is marked as "latest". Internally used by DSpace to support versioning. Do not manually add, remove or edit values.
237	15	citation	conferenceDate	The date when the conference took place. This property is considered to be part of the bibliographic citation. Recommended best practice for encoding the date value is defined in a profile of ISO 8601 [W3CDTF] and follows the YYYY-MM-DD format.
160	6	isProjectOfOrgUnit	\N	Contains all uuids of the "latest" PROJECTS that the current ORGANISATIONAL UNIT links to via a relationship. In other words, this stores all relationships pointing from the current ORGANISATIONAL UNIT to any PROJECT where the PROJECT is marked as "latest". Internally used by DSpace. Do not manually add, remove or edit values.
161	6	isProjectOfOrgUnit	latestForDiscovery	Contains all uuids of PROEJCTS which link to the current ORGANISATIONAL UNIT via a "latest" relationship. In other words, this stores all relationships pointing to the current ORGANISATIONAL UNIT from any PROEJCT, implying that the ORGANISATIONAL UNIT is marked as "latest". Internally used by DSpace to support versioning. Do not manually add, remove or edit values.
162	6	isVolumeOfJournal	\N	Contains all uuids of the "latest" VOLUMES that the current JOURNAL links to via a relationship. In other words, this stores all relationships pointing from the current JOURNAL to any VOLUME where the VOLUME is marked as "latest". Internally used by DSpace. Do not manually add, remove or edit values.
163	6	isVolumeOfJournal	latestForDiscovery	Contains all uuids of VOLUMES which link to the current JOURNAL via a "latest" relationship. In other words, this stores all relationships pointing to the current JOURNAL from any VOLUME, implying that the JOURNAL is marked as "latest". Internally used by DSpace to support versioning. Do not manually add, remove or edit values.
164	6	isJournalOfVolume	\N	Contains all uuids of the "latest" JOURNALS that the current VOLUME links to via a relationship. In other words, this stores all relationships pointing from the current VOLUME to any JOURNAL where the JOURNAL is marked as "latest". Internally used by DSpace. Do not manually add, remove or edit values.
165	6	isJournalOfVolume	latestForDiscovery	Contains all uuids of JOURNALS which link to the current VOLUME via a "latest" relationship. In other words, this stores all relationships pointing to the current VOLUME from any JOURNAL, implying that the VOLUME is marked as "latest". Internally used by DSpace to support versioning. Do not manually add, remove or edit values.
166	6	isIssueOfJournalVolume	\N	Contains all uuids of the "latest" ISSUES that the current VOLUME links to via a relationship. In other words, this stores all relationships pointing from the current VOLUME to any ISSUE where the ISSUE is marked as "latest". Internally used by DSpace. Do not manually add, remove or edit values.
167	6	isIssueOfJournalVolume	latestForDiscovery	Contains all uuids of ISSUES which link to the current VOLUME via a "latest" relationship. In other words, this stores all relationships pointing to the current VOLUME from any ISSUE, implying that the VOLUME is marked as "latest". Internally used by DSpace to support versioning. Do not manually add, remove or edit values.
168	6	isJournalVolumeOfIssue	\N	Contains all uuids of the "latest" VOLUMES that the current ISSUE links to via a relationship. In other words, this stores all relationships pointing from the current ISSUE to any VOLUME where the VOLUME is marked as "latest". Internally used by DSpace. Do not manually add, remove or edit values.
169	6	isJournalVolumeOfIssue	latestForDiscovery	Contains all uuids of VOLUMES which link to the current ISSUE via a "latest" relationship. In other words, this stores all relationships pointing to the current ISSUE from any VOLUME, implying that the ISSUE is marked as "latest". Internally used by DSpace to support versioning. Do not manually add, remove or edit values.
170	6	isJournalOfPublication	\N	Contains all uuids of the "latest" JOURNALS that the current PUBLICATION links to via a relationship. In other words, this stores all relationships pointing from the current PUBLICATION to any JOURNAL where the JOURNAL is marked as "latest". Internally used by DSpace. Do not manually add, remove or edit values.
171	6	isJournalOfPublication	latestForDiscovery	Contains all uuids of JOURNALS which link to the current PUBLICATION via a "latest" relationship. In other words, this stores all relationships pointing to the current PUBLICATION from any JOURNAL, implying that the PUBLICATION is marked as "latest". Internally used by DSpace to support versioning. Do not manually add, remove or edit values.
172	6	isJournalIssueOfPublication	\N	Contains all uuids of the "latest" ISSUES that the current PUBLICATION links to via a relationship. In other words, this stores all relationships pointing from the current PUBLICATION to any ISSUE where the ISSUE is marked as "latest". Internally used by DSpace. Do not manually add, remove or edit values.
173	6	isJournalIssueOfPublication	latestForDiscovery	Contains all uuids of ISSUES which link to the current PUBLICATION via a "latest" relationship. In other words, this stores all relationships pointing to the current PUBLICATION from any ISSUE, implying that the PUBLICATION is marked as "latest". Internally used by DSpace to support versioning. Do not manually add, remove or edit values.
174	6	isPublicationOfJournalIssue	\N	Contains all uuids of the "latest" PUBLICATIONS that the current ISSUE links to via a relationship. In other words, this stores all relationships pointing from the current ISSUE to any PUBLICATION where the PUBLICATION is marked as "latest". Internally used by DSpace. Do not manually add, remove or edit values.
175	6	isPublicationOfJournalIssue	latestForDiscovery	Contains all uuids of PUBLICATIONS which link to the current ISSUE via a "latest" relationship. In other words, this stores all relationships pointing to the current ISSUE from any PUBLICATION, implying that the ISSUE is marked as "latest". Internally used by DSpace to support versioning. Do not manually add, remove or edit values.
176	6	isContributorOfPublication	\N	Contains all uuids of the "latest" CONTRIBUTORS that the current PUBLICATION links to via a relationship. In other words, this stores all relationships pointing from the current PUBLICATION to any CONTRIBUTOR where the CONTRIBUTOR is marked as "latest". Internally used by DSpace. Do not manually add, remove or edit values.
177	6	isContributorOfPublication	latestForDiscovery	Contains all uuids of CONTRIBUTORS which link to the current PUBLICATION via a "latest" relationship. In other words, this stores all relationships pointing to the current PUBLICATION from any CONTRIBUTOR, implying that the PUBLICATION is marked as "latest". Internally used by DSpace to support versioning. Do not manually add, remove or edit values.
178	6	isPublicationOfContributor	\N	Contains all uuids of the "latest" PUBLICATIONS that the current CONTRIBUTOR links to via a relationship. In other words, this stores all relationships pointing from the current CONTRIBUTOR to any PUBLICATION where the PUBLICATION is marked as "latest". Internally used by DSpace. Do not manually add, remove or edit values.
179	6	isPublicationOfContributor	latestForDiscovery	Contains all uuids of PUBLICATIONS which link to the current CONTRIBUTOR via a "latest" relationship. In other words, this stores all relationships pointing to the current CONTRIBUTOR from any PUBLICATION, implying that the CONTRIBUTOR is marked as "latest". Internally used by DSpace to support versioning. Do not manually add, remove or edit values.
240	3	process	filetype	\N
180	6	isFundingAgencyOfProject	\N	Contains all uuids of the "latest" FUNDING AGENCIES that the current PROJECT links to via a relationship. In other words, this stores all relationships pointing from the current PROJECT to any FUNDING AGENCY where the FUNDING AGENCY is marked as "latest". Internally used by DSpace. Do not manually add, remove or edit values.
181	6	isFundingAgencyOfProject	latestForDiscovery	Contains all uuids of FUNDING AGENCIES which link to the current PROJECT via a "latest" relationship. In other words, this stores all relationships pointing to the current PROJECT from any FUNDING AGENCY, implying that the PROJECT is marked as "latest". Internally used by DSpace to support versioning. Do not manually add, remove or edit values.
182	6	isProjectOfFundingAgency	\N	Contains all uuids of the "latest" PROJECTS that the current FUNDING AGENCY links to via a relationship. In other words, this stores all relationships pointing from the current FUNDING AGENCY to any PROJECT where the PROJECT is marked as "latest". Internally used by DSpace. Do not manually add, remove or edit values.
183	6	isProjectOfFundingAgency	latestForDiscovery	Contains all uuids of PROJECTS which link to the current FUNDING AGENCY via a "latest" relationship. In other words, this stores all relationships pointing to the current FUNDING AGENCY from any PROJECT, implying that the FUNDING AGENCY is marked as "latest". Internally used by DSpace to support versioning. Do not manually add, remove or edit values.
209	9	legalName	\N	The official name of the organization, e.g. the registered company name.
210	9	foundingDate	\N	The date that this organization was founded.
211	9	address	addressLocality	Physical address locality (ex. Mountain View) of the organization.
212	9	address	addressCountry	Physical address country (ex. USA) of the organization. You can also provide the two-letter ISO\n            3166-1 alpha-2 country code.
213	9	identifier	\N	Generic Identifier
214	9	identifier	isni	International Standard Name Identifier
215	9	identifier	rin	Ringgold identifier
216	9	identifier	ror	Research Organization Registry
217	9	identifier	crossrefid	Crossref identifier
218	11	editor	\N	Specifies the Person who edited the CreativeWork.
219	11	publisher	\N	The publisher of the creative work.
220	12	issn	\N	The International Standard Serial Number (ISSN) that identifies this serial publication. You can\n            repeat this property to identify different formats of, or the linking ISSN (ISSN-L) for, this serial\n            publication.
221	13	issueNumber	\N	Identifies the issue of publication; for example, "iii" or "2".
222	11	keywords	\N	Keywords or tags used to describe this content. Multiple entries in a keywords list are typically\n            delimited by commas.
223	11	datePublished	\N	Date of first broadcast/publication.
224	14	volumeNumber	\N	Identifies the volume of publication or multi-part work; for example, "iii" or "2".
225	15	fundingStream	\N	Name of the funding stream
226	15	awardNumber	\N	Project grantId or awardNumber
227	15	awardURI	\N	URI of the project landing page provided by the funder for more information about the award (grant).
228	15	awardTitle	\N	Title of the project, award or grant.
229	15	version	\N	Use either a version number or the label of the vocabulary term as value.
230	15	citation	title	The title name of the container (e.g. journal, book, conference) this work is published in. This property is considered to be part of the bibliographic citation.
231	15	citation	volume	The volume, typically a number, of the container (e.g. journal). This property is considered to be part of the bibliographic citation.
232	15	citation	issue	The issue of the container (e.g. journal). This property is considered to be part of the bibliographic citation.
233	15	citation	startPage	The start page is part of the pagination information of the work published in a container (e.g. journal issue). This property is considered to be part of the bibliographic citation.
234	15	citation	endPage	The end page is part of the pagination information of the work published in a container (e.g. journal issue). This property is considered to be part of the bibliographic citation.
235	15	citation	edition	The edition the work was published in (e.g. book edition). This property is considered to be part of the bibliographic citation.
236	15	citation	conferencePlace	The place where the conference took place. This property is considered to be part of the bibliographic citation.
241	3	agreements	end-user	Stores whether the End User Agreement has been accepted by an EPerson. Valid values; true, false
242	3	agreements	cookies	Stores the cookie preferences of an EPerson, as selected in last session. Value will be an array of cookieName/boolean pairs, specifying which cookies are allowed or not allowed.
243	3	iiif	enabled	Stores a boolean text value (true or false) to indicate if the iiif feature is enabled or not for the dspace object. If absent the value is derived from the parent dspace object
244	3	object	owner	Used to support researcher profiles
245	3	orcid	scope	Stores the scopes/authorizations granted by the user during authentication on ORCID
246	3	orcid	sync-mode	Stores the synchronization with ORCID mode chosen by the user
247	3	orcid	sync-publications	Stores the publication synchronization with ORCID preference chosen by the user
248	3	orcid	sync-fundings	Stores the funding synchronization with ORCID preference chosen by the user
249	3	orcid	sync-profile	Stores the profile synchronization with ORCID preference chosen by the user
250	3	orcid	authenticated	Stores the timestamp related to the user authentication on ORCID
251	17	label	\N	Metadata field used to set the IIIF label associated with the resource otherwise the system will derive one according to the configuration and metadata
252	17	description	\N	Metadata field used to set the IIIF description associated with the resource
253	17	toc	\N	Metadata field used to set the position of the iiif resource in the structure. Levels are separated by triple pipe ||| can be applied to Bundles and Bitstreams
254	17	canvas	naming	Metadata field used to set the base label used to name all the canvas in the Item. The canvas label will be generated using the value of this metadata as prefix and the canvas position
255	17	viewing	hint	Metadata field used to set the viewing hint overriding the configuration value if any
256	17	image	width	Metadata field used to store the width of an image in px
257	17	image	height	Metadata field used to store the height of an image in px
258	17	search	enabled	Metadata field used to enable the IIIF Search service at the item level
263	11	contributor	tester	An agent which provided illustrations for the resource
264	11	contributor	course.type	An agent which provided illustrations for the resource
265	11	contributor	model	An agent which provided illustrations for the resource
266	1	contributor	advisor	Use primarily for thesis advisor.
267	1	contributor	editor	\N
268	9	parentOrganization	\N	The larger organization that this organization is a subOrganization of, if any.
269	9	alternateName	\N	An alias for the organization.
270	9	url	\N	Url of the organization.
271	16	relation	isReviewedBy	Reviewd by
272	16	relation	isReferencedBy	Referenced by
273	16	relation	isSupplementedBy	Supplemented by
281	1	tittle	\N	\N
282	1	author	\N	\N
283	1	year	\N	\N
284	1	copyright	\N	\N
285	1	contenttype	\N	\N
286	1	doctype	\N	\N
287	1	keyword	\N	\N
288	1	pages	\N	\N
291	2	cart	\N	\N
292	1	sectionName	\N	\N
293	1	fileType	\N	\N
294	1	month	\N	\N
295	1	year1	\N	\N
296	1	year2	\N	\N
297	1	yearRange	\N	\N
298	1	boxNo	\N	\N
299	1	fileNo	\N	\N
300	1	fileName	\N	\N
301	1	sectionname	\N	\N
302	1	filenumber	\N	\N
303	1	yearrange	\N	\N
304	1	boxnumber	\N	\N
305	1	filename	\N	\N
\.


--
-- Data for Name: metadataschemaregistry; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.metadataschemaregistry (metadata_schema_id, namespace, short_id) FROM stdin;
1	http://dublincore.org/documents/dcmi-terms/	dc
2	http://dspace.org/eperson	eperson
3	http://dspace.org/dspace	dspace
4	http://purl.org/dc/terms/	dcterms
5	http://dspace.org/namespace/local/	local
6	http://dspace.org/relation	relation
9	https://schema.org/Organization	organization
10	https://schema.org/Periodical	periodical
11	https://schema.org/CreativeWork	creativework
12	https://schema.org/CreativeWorkSeries	creativeworkseries
13	https://schema.org/PublicationIssue	publicationissue
14	https://schema.org/PublicationVolume	publicationvolume
15	http://namespace.openaire.eu/schema/oaire/	oaire
16	http://datacite.org/schema/kernel-4	datacite
17	http://dspace.org/iiif	iiif
\.


--
-- Data for Name: metadatavalue; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.metadatavalue (metadata_value_id, metadata_field_id, text_value, text_lang, place, authority, confidence, dspace_object_id) FROM stdin;
4220	73	Panda.zip	\N	0	\N	-1	aafd1652-1e33-47c8-83d3-164099e91f1d
214	73	New_Techniques_in_Farming_Vol-13_Issue-10_October_1969.pdf	\N	0	\N	-1	5e546662-ba03-4732-80d2-f83efc97efce
215	64	New_Techniques_in_Farming_Vol-13_Issue-10_October_1969.pdf	\N	0	\N	-1	5e546662-ba03-4732-80d2-f83efc97efce
2272	73	hr.zip	\N	0	\N	-1	b2a578e0-b503-47ec-8e93-f1641eae7e24
2273	240	inputfile	\N	0	\N	-1	b2a578e0-b503-47ec-8e93-f1641eae7e24
4221	240	inputfile	\N	0	\N	-1	aafd1652-1e33-47c8-83d3-164099e91f1d
1314	73	burger.png	\N	0	\N	-1	661a0996-f05f-4951-8194-5046d5934ab8
1770	73	Panda.zip	\N	0	\N	-1	bffa777f-3b9a-4f40-9955-048a85e55453
6720	73	Panda.zip	\N	0	\N	-1	749b2588-ec6a-4b43-a04d-8413d0073ef4
6721	240	inputfile	\N	0	\N	-1	749b2588-ec6a-4b43-a04d-8413d0073ef4
97	240	exportCSV	\N	0	\N	-1	ff5c7076-c0a2-497d-be0e-d8fffb6ce41f
1771	240	inputfile	\N	0	\N	-1	bffa777f-3b9a-4f40-9955-048a85e55453
7947	34	http://localhost:4000/handle/123456789/446	\N	0	\N	-1	95d68496-65b6-4ea5-a86a-483b608d5ecb
2861	73	Panda.zip	\N	0	\N	-1	c6d7ea8a-3653-4ba5-b843-f448d72a4f46
2862	240	inputfile	\N	0	\N	-1	c6d7ea8a-3653-4ba5-b843-f448d72a4f46
7948	35		\N	0	\N	-1	95d68496-65b6-4ea5-a86a-483b608d5ecb
7949	73	EasySmartDocs	\N	0	\N	-1	95d68496-65b6-4ea5-a86a-483b608d5ecb
48	73	license.txt	\N	0	\N	-1	e5320dc2-3ed9-4a69-b9b9-90853d1cb56d
49	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	e5320dc2-3ed9-4a69-b9b9-90853d1cb56d
50	77	2024-07-13T04:41:26Z	\N	0	\N	-1	e5320dc2-3ed9-4a69-b9b9-90853d1cb56d
52	73	Burdwan_Farmers_Convention_Vol-1_January_1957 (4).pdf	\N	0	\N	-1	5356f5bb-4103-4d1b-b58c-12ed7dd52220
53	64	Burdwan_Farmers_Convention_Vol-1_January_1957 (4).pdf	\N	0	\N	-1	5356f5bb-4103-4d1b-b58c-12ed7dd52220
2226	73	dev.zip	\N	0	\N	-1	df761c44-c4b7-4b63-b36d-0b81d3a1698e
2227	240	inputfile	\N	0	\N	-1	df761c44-c4b7-4b63-b36d-0b81d3a1698e
7617	73	Credence1.pdf	\N	0	\N	-1	269f262a-7335-4a05-b7dc-c125e309b851
269	73	New_Techniques_in_Farming_Vol-13_Issue-10_October_1969.pdf	\N	0	\N	-1	cf5e4e38-a1ce-4078-b89c-4937acb2055c
270	64	New_Techniques_in_Farming_Vol-13_Issue-10_October_1969.pdf	\N	0	\N	-1	cf5e4e38-a1ce-4078-b89c-4937acb2055c
649	73	Burdwan_Farmers_Convention_Vol-1_January_1957 (5).pdf	\N	0	\N	-1	4879f6d7-301c-4584-b7cc-d5b7836a2a92
69	73	license.txt	\N	0	\N	-1	cbdcdf0a-50cf-4873-be4d-a74d33ca58d1
70	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	cbdcdf0a-50cf-4873-be4d-a74d33ca58d1
71	77	2024-07-13T04:53:33Z	\N	0	\N	-1	cbdcdf0a-50cf-4873-be4d-a74d33ca58d1
1906	73	ann14.pdf	\N	0	\N	-1	5d78d55a-6350-4714-b4ff-7648c461e08d
1907	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	d153b254-2b2c-4d2f-b7ea-7f0e52c3a7e5
7618	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	fdf5fd2f-bfa7-4529-856f-2d56174a922b
650	64	Burdwan_Farmers_Convention_Vol-1_January_1957 (5).pdf	\N	0	\N	-1	4879f6d7-301c-4584-b7cc-d5b7836a2a92
62	73	Minister_of_State_for_Food_and_Agriculture_Governm_Vol-13_Issue-5-6_May-June_1969 (8).pdf	\N	0	\N	-1	be1e7391-d4d3-4c0d-9b1f-b3c1509ace38
63	64	Minister_of_State_for_Food_and_Agriculture_Governm_Vol-13_Issue-5-6_May-June_1969 (8).pdf	\N	0	\N	-1	be1e7391-d4d3-4c0d-9b1f-b3c1509ace38
7779	73	rav.zip	\N	0	\N	-1	ee696fdb-4d5c-4ec1-af77-f18d651db39d
7780	240	inputfile	\N	0	\N	-1	ee696fdb-4d5c-4ec1-af77-f18d651db39d
272	73	license.txt	\N	0	\N	-1	4bc4ff48-23d8-40f3-985d-8ae62a01f105
273	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	4bc4ff48-23d8-40f3-985d-8ae62a01f105
274	77	2024-07-30T22:05:52Z	\N	0	\N	-1	4bc4ff48-23d8-40f3-985d-8ae62a01f105
4236	73	ann.pdf	\N	0	\N	-1	c2b25088-12bf-4de3-9202-9c34e22c2883
4237	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	d08831f5-28e2-4ace-b9c9-ff5f8e5ce0ae
4626	73	Panda.zip	\N	0	\N	-1	40391d5e-e77f-418e-af02-58bdeb8d7549
4627	240	inputfile	\N	0	\N	-1	40391d5e-e77f-418e-af02-58bdeb8d7549
80	73	login.png	\N	0	\N	-1	7759f18d-88bd-47af-8d60-20783fb5f0fb
81	64	login.png	\N	0	\N	-1	7759f18d-88bd-47af-8d60-20783fb5f0fb
283	73	New_Techniques_in_Farming_Vol-13_Issue-10_October_1969.pdf	\N	0	\N	-1	87430ec5-5f4f-4a4a-ab24-76e5c15cc6df
284	64	New_Techniques_in_Farming_Vol-13_Issue-10_October_1969.pdf	\N	0	\N	-1	87430ec5-5f4f-4a4a-ab24-76e5c15cc6df
7782	73	34-import.log	\N	0	\N	-1	d9b4c68a-0e7f-494c-a380-b089f0db9796
5032	73	Panda.zip	\N	0	\N	-1	1ce72c8b-7d2b-452b-b1df-4f8c2c742b9f
88	73	license.txt	\N	0	\N	-1	c3c736ea-7b24-4184-93fc-f08a084ca050
89	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	c3c736ea-7b24-4184-93fc-f08a084ca050
90	77	2024-07-17T19:15:11Z	\N	0	\N	-1	c3c736ea-7b24-4184-93fc-f08a084ca050
5033	240	inputfile	\N	0	\N	-1	1ce72c8b-7d2b-452b-b1df-4f8c2c742b9f
7783	240	script_output	\N	0	\N	-1	d9b4c68a-0e7f-494c-a380-b089f0db9796
286	73	license.txt	\N	0	\N	-1	4b029b79-7589-44c6-9f24-4394bae3b1b8
287	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	4b029b79-7589-44c6-9f24-4394bae3b1b8
288	77	2024-07-30T22:24:43Z	\N	0	\N	-1	4b029b79-7589-44c6-9f24-4394bae3b1b8
96	73	fafcd21c-9b96-4236-af07-4e55b08e699e.csv	\N	0	\N	-1	ff5c7076-c0a2-497d-be0e-d8fffb6ce41f
98	73	metadata-export1.log	\N	0	\N	-1	1feb0aae-67a2-49cd-a766-dd0b9d06c592
99	240	script_output	\N	0	\N	-1	1feb0aae-67a2-49cd-a766-dd0b9d06c592
290	73	New_Techniques_in_Farming_Vol-13_Issue-10_October_1969.pdf	\N	0	\N	-1	48cdb008-bfdf-4998-9f43-94e699fbc0a9
3309	73	Panda.zip	\N	0	\N	-1	33326ace-bf60-40d9-9342-812a491bf96a
2247	73	12-import.log	\N	0	\N	-1	efa477b7-ad16-4bc6-bc0f-04aafe43736a
234	73	New_Techniques_in_Farming_Vol-13_Issue-10_October_1969.pdf	\N	0	\N	-1	7e857c23-806b-4830-baf3-b1e1986b1965
235	64	New_Techniques_in_Farming_Vol-13_Issue-10_October_1969.pdf	\N	0	\N	-1	7e857c23-806b-4830-baf3-b1e1986b1965
237	73	license.txt	\N	0	\N	-1	0bb58d6f-48de-4c84-9e42-fcdd6a779c8c
238	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	0bb58d6f-48de-4c84-9e42-fcdd6a779c8c
239	77	2024-07-30T21:30:45Z	\N	0	\N	-1	0bb58d6f-48de-4c84-9e42-fcdd6a779c8c
652	73	New_Techniques_in_Farming_Vol-13_Issue-10_October_1969 (1).pdf	\N	0	\N	-1	5e1b3cb1-d500-4e0d-8ea6-33b7284cb4da
653	64	New_Techniques_in_Farming_Vol-13_Issue-10_October_1969 (1).pdf	\N	0	\N	-1	5e1b3cb1-d500-4e0d-8ea6-33b7284cb4da
241	73	New_Techniques_in_Farming_Vol-13_Issue-10_October_1969.pdf	\N	0	\N	-1	b7a6c81e-8e5b-4cf7-a4bb-bb709c14afdd
242	64	New_Techniques_in_Farming_Vol-13_Issue-10_October_1969.pdf	\N	0	\N	-1	b7a6c81e-8e5b-4cf7-a4bb-bb709c14afdd
3310	240	inputfile	\N	0	\N	-1	33326ace-bf60-40d9-9342-812a491bf96a
2248	240	script_output	\N	0	\N	-1	efa477b7-ad16-4bc6-bc0f-04aafe43736a
244	73	license.txt	\N	0	\N	-1	abceae7c-29c7-4a12-8841-5989af4d95a3
245	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	abceae7c-29c7-4a12-8841-5989af4d95a3
246	77	2024-07-30T21:37:14Z	\N	0	\N	-1	abceae7c-29c7-4a12-8841-5989af4d95a3
262	73	New_Techniques_in_Farming_Vol-13_Issue-10_October_1969.pdf	\N	0	\N	-1	ec4574c6-8742-403a-af0e-545906824d71
263	64	New_Techniques_in_Farming_Vol-13_Issue-10_October_1969.pdf	\N	0	\N	-1	ec4574c6-8742-403a-af0e-545906824d71
655	73	license.txt	\N	0	\N	-1	1279e41e-28df-43a4-b90a-bae99d59510c
265	73	license.txt	\N	0	\N	-1	dc7ffc6c-aee0-480c-8430-b6d4d744979e
266	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	dc7ffc6c-aee0-480c-8430-b6d4d744979e
267	77	2024-07-30T22:00:20Z	\N	0	\N	-1	dc7ffc6c-aee0-480c-8430-b6d4d744979e
656	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	1279e41e-28df-43a4-b90a-bae99d59510c
335	73	Burdwan_Farmers_Convention_Vol-1_January_1957 (6).pdf	\N	0	\N	-1	c107b290-0eb6-405a-a064-f5f5724b8626
276	73	New_Techniques_in_Farming_Vol-13_Issue-10_October_1969.pdf	\N	0	\N	-1	5f126a7b-6100-4610-a303-bd9db95911a5
277	64	New_Techniques_in_Farming_Vol-13_Issue-10_October_1969.pdf	\N	0	\N	-1	5f126a7b-6100-4610-a303-bd9db95911a5
657	77	2024-08-16T08:43:54Z	\N	0	\N	-1	1279e41e-28df-43a4-b90a-bae99d59510c
336	64	Burdwan_Farmers_Convention_Vol-1_January_1957 (6).pdf	\N	0	\N	-1	c107b290-0eb6-405a-a064-f5f5724b8626
279	73	license.txt	\N	0	\N	-1	53c5cbb4-0dc4-41f7-a2ed-5dc538dd1acb
280	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	53c5cbb4-0dc4-41f7-a2ed-5dc538dd1acb
281	77	2024-07-30T22:20:28Z	\N	0	\N	-1	53c5cbb4-0dc4-41f7-a2ed-5dc538dd1acb
659	73	Burdwan_Farmers_Convention_Vol-1_January_1957 (5).pdf	\N	0	\N	-1	41c8a3c8-da11-4e1a-a3f2-67702395e463
660	64	Burdwan_Farmers_Convention_Vol-1_January_1957 (5).pdf	\N	0	\N	-1	41c8a3c8-da11-4e1a-a3f2-67702395e463
297	73	Burdwan_Farmers_Convention_Vol-1_January_1957 (7).pdf	\N	0	\N	-1	ac7c5540-a1a8-4f96-90e7-f2bff716c4e4
298	64	Burdwan_Farmers_Convention_Vol-1_January_1957 (7).pdf	\N	0	\N	-1	ac7c5540-a1a8-4f96-90e7-f2bff716c4e4
300	73	license.txt	\N	0	\N	-1	5a932d7f-a4dd-4855-aef4-e6bd910fcf66
301	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	5a932d7f-a4dd-4855-aef4-e6bd910fcf66
302	77	2024-08-02T19:05:54Z	\N	0	\N	-1	5a932d7f-a4dd-4855-aef4-e6bd910fcf66
5464	73	Panda.zip	\N	0	\N	-1	de3c5f7f-4550-43de-be75-113437c79993
318	73	Minister_of_State_for_Food_and_Agriculture_Governm_Vol-13_Issue-5-6_May-June_1969.pdf	\N	0	\N	-1	811f0c7a-b5eb-4747-99b5-44fc6ea29bdf
319	64	Minister_of_State_for_Food_and_Agriculture_Governm_Vol-13_Issue-5-6_May-June_1969.pdf	\N	0	\N	-1	811f0c7a-b5eb-4747-99b5-44fc6ea29bdf
5465	240	inputfile	\N	0	\N	-1	de3c5f7f-4550-43de-be75-113437c79993
662	73	license.txt	\N	0	\N	-1	396a66a1-7c0d-4e66-bf79-cdd3f7a166af
321	73	license.txt	\N	0	\N	-1	1ce61bae-e6a7-4831-a1f9-b07404c5b7fc
322	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	1ce61bae-e6a7-4831-a1f9-b07404c5b7fc
323	77	2024-08-02T19:35:59Z	\N	0	\N	-1	1ce61bae-e6a7-4831-a1f9-b07404c5b7fc
328	73	UCG-NET-240510201498-1714203996.pdf	\N	0	\N	-1	dd614107-0246-44a0-a3b7-dbd0f51be521
329	64	UCG-NET-240510201498-1714203996.pdf	\N	0	\N	-1	dd614107-0246-44a0-a3b7-dbd0f51be521
331	73	license.txt	\N	0	\N	-1	e045690f-1c4a-4391-badb-7474a9b3cefa
332	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	e045690f-1c4a-4391-badb-7474a9b3cefa
333	77	2024-08-02T19:43:15Z	\N	0	\N	-1	e045690f-1c4a-4391-badb-7474a9b3cefa
338	73	license.txt	\N	0	\N	-1	d6bb0483-f84d-45e0-93d9-704676a85522
339	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	d6bb0483-f84d-45e0-93d9-704676a85522
340	77	2024-08-02T19:45:41Z	\N	0	\N	-1	d6bb0483-f84d-45e0-93d9-704676a85522
367	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	ec800be0-f237-4a79-bc7c-b7629548061c
349	73	Burdwan_Farmers_Convention_Vol-1_January_1957 (7).pdf	\N	0	\N	-1	36f003aa-4f06-4181-875e-85cf0c4fe523
350	64	Burdwan_Farmers_Convention_Vol-1_January_1957 (7).pdf	\N	0	\N	-1	36f003aa-4f06-4181-875e-85cf0c4fe523
368	77	2024-08-02T20:01:01Z	\N	0	\N	-1	ec800be0-f237-4a79-bc7c-b7629548061c
352	73	license.txt	\N	0	\N	-1	4b2155ec-e513-477b-bac8-b37142160731
353	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	4b2155ec-e513-477b-bac8-b37142160731
354	77	2024-08-02T19:51:14Z	\N	0	\N	-1	4b2155ec-e513-477b-bac8-b37142160731
363	73	Burdwan_Farmers_Convention_Vol-1_January_1957 (7).pdf	\N	0	\N	-1	be028d3e-d6c3-4ed1-b3c6-43a3a1585c68
364	64	Burdwan_Farmers_Convention_Vol-1_January_1957 (7).pdf	\N	0	\N	-1	be028d3e-d6c3-4ed1-b3c6-43a3a1585c68
366	73	license.txt	\N	0	\N	-1	ec800be0-f237-4a79-bc7c-b7629548061c
370	73	Burdwan_Farmers_Convention_Vol-1_January_1957 (7).pdf	\N	0	\N	-1	72da50dd-b6e4-49ff-aa17-d5d5e0ecc800
371	64	Burdwan_Farmers_Convention_Vol-1_January_1957 (7).pdf	\N	0	\N	-1	72da50dd-b6e4-49ff-aa17-d5d5e0ecc800
373	73	license.txt	\N	0	\N	-1	95d5c820-d64c-44c1-a876-826053be7b5e
374	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	95d5c820-d64c-44c1-a876-826053be7b5e
375	77	2024-08-02T20:07:34Z	\N	0	\N	-1	95d5c820-d64c-44c1-a876-826053be7b5e
377	73	Burdwan_Farmers_Convention_Vol-1_January_1957 (1).pdf	\N	0	\N	-1	73ae3365-d84f-4579-a563-763e8076b4de
378	64	Burdwan_Farmers_Convention_Vol-1_January_1957 (1).pdf	\N	0	\N	-1	73ae3365-d84f-4579-a563-763e8076b4de
663	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	396a66a1-7c0d-4e66-bf79-cdd3f7a166af
664	77	2024-08-17T17:57:18Z	\N	0	\N	-1	396a66a1-7c0d-4e66-bf79-cdd3f7a166af
727	73	ANNUAL.zip	\N	0	\N	-1	38d06d74-3c74-4e76-be58-e3df8704e345
7784	73	rav.zip	\N	0	\N	-1	a7aa7e8f-2e0f-45fd-bc7b-41608f164774
211	73	New_Techniques_in_Farming_Vol-13_Issue-10_October_1969.pdf	\N	0	\N	-1	80184882-0695-46a3-94de-add544369356
7785	240	inputfile	\N	0	\N	-1	a7aa7e8f-2e0f-45fd-bc7b-41608f164774
212	64	New_Techniques_in_Farming_Vol-13_Issue-10_October_1969.pdf	\N	0	\N	-1	80184882-0695-46a3-94de-add544369356
1298	73	Request For Proposal_Online Digital Library_V 1.0.pdf	\N	0	\N	-1	bd66ea1d-86e4-4b09-b6bc-3ad96445903f
1228	73	ShubhamKumarSinghResume.pdf	\N	0	\N	-1	cb6963ad-0e29-4a38-957f-509828bec799
217	73	New_Techniques_in_Farming_Vol-13_Issue-10_October_1969.pdf	\N	0	\N	-1	12baa5fd-5c81-4bea-b285-dc17c32ae888
218	64	New_Techniques_in_Farming_Vol-13_Issue-10_October_1969.pdf	\N	0	\N	-1	12baa5fd-5c81-4bea-b285-dc17c32ae888
1299	64	Request For Proposal_Online Digital Library_V 1.0.pdf	\N	0	\N	-1	bd66ea1d-86e4-4b09-b6bc-3ad96445903f
220	73	New_Techniques_in_Farming_Vol-13_Issue-10_October_1969.pdf	\N	0	\N	-1	9b16ac04-1200-4a4f-9e97-c2c37bfc750b
7787	73	35-import.log	\N	0	\N	-1	20fa345f-5945-4364-a7b5-98c576fbbf8f
728	240	inputfile	\N	0	\N	-1	38d06d74-3c74-4e76-be58-e3df8704e345
221	64	New_Techniques_in_Farming_Vol-13_Issue-10_October_1969.pdf	\N	0	\N	-1	9b16ac04-1200-4a4f-9e97-c2c37bfc750b
7788	240	script_output	\N	0	\N	-1	20fa345f-5945-4364-a7b5-98c576fbbf8f
223	73	license.txt	\N	0	\N	-1	be4aad3e-0a3f-43d3-b909-8c2236e02536
224	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	be4aad3e-0a3f-43d3-b909-8c2236e02536
225	77	2024-07-30T21:17:13Z	\N	0	\N	-1	be4aad3e-0a3f-43d3-b909-8c2236e02536
227	73	New_Techniques_in_Farming_Vol-13_Issue-10_October_1969.pdf	\N	0	\N	-1	3bfd0215-c135-49f4-b58e-1d45b7dd4117
228	64	New_Techniques_in_Farming_Vol-13_Issue-10_October_1969.pdf	\N	0	\N	-1	3bfd0215-c135-49f4-b58e-1d45b7dd4117
6300	73	dev.zip	\N	0	\N	-1	b68fb29e-60fd-4e0a-aa59-f44bf47f0c14
6301	240	inputfile	\N	0	\N	-1	b68fb29e-60fd-4e0a-aa59-f44bf47f0c14
230	73	license.txt	\N	0	\N	-1	dd1fb0ac-d7f8-4c65-bc28-90d84935f82a
231	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	dd1fb0ac-d7f8-4c65-bc28-90d84935f82a
232	77	2024-07-30T21:26:51Z	\N	0	\N	-1	dd1fb0ac-d7f8-4c65-bc28-90d84935f82a
248	73	New_Techniques_in_Farming_Vol-13_Issue-10_October_1969.pdf	\N	0	\N	-1	4acd467e-b518-4d9b-b8fb-7a86e9806097
249	64	New_Techniques_in_Farming_Vol-13_Issue-10_October_1969.pdf	\N	0	\N	-1	4acd467e-b518-4d9b-b8fb-7a86e9806097
1306	73	license.txt	\N	0	\N	-1	f7c4a72e-a00f-4229-934f-849567e8a211
251	73	license.txt	\N	0	\N	-1	c9a9d872-4f09-4e14-bef4-2b55164f1c3b
252	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	c9a9d872-4f09-4e14-bef4-2b55164f1c3b
253	77	2024-07-30T21:47:22Z	\N	0	\N	-1	c9a9d872-4f09-4e14-bef4-2b55164f1c3b
291	64	New_Techniques_in_Farming_Vol-13_Issue-10_October_1969.pdf	\N	0	\N	-1	48cdb008-bfdf-4998-9f43-94e699fbc0a9
255	73	New_Techniques_in_Farming_Vol-13_Issue-10_October_1969.pdf	\N	0	\N	-1	245156b5-eef4-40d4-9f44-1c1ff30b1816
256	64	New_Techniques_in_Farming_Vol-13_Issue-10_October_1969.pdf	\N	0	\N	-1	245156b5-eef4-40d4-9f44-1c1ff30b1816
258	73	license.txt	\N	0	\N	-1	79658689-4d32-4268-81ed-625c0bf821a9
259	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	79658689-4d32-4268-81ed-625c0bf821a9
260	77	2024-07-30T21:57:35Z	\N	0	\N	-1	79658689-4d32-4268-81ed-625c0bf821a9
293	73	license.txt	\N	0	\N	-1	b77b327b-f817-4d32-9a4b-9eb462659bf1
294	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	b77b327b-f817-4d32-9a4b-9eb462659bf1
295	77	2024-07-30T22:31:51Z	\N	0	\N	-1	b77b327b-f817-4d32-9a4b-9eb462659bf1
304	73	Work_Resolutely_Vol-7_Issue-6_June_1963 (1).pdf	\N	0	\N	-1	55b28903-d1cd-4e29-9b0a-379dc666cc7a
305	64	Work_Resolutely_Vol-7_Issue-6_June_1963 (1).pdf	\N	0	\N	-1	55b28903-d1cd-4e29-9b0a-379dc666cc7a
307	73	license.txt	\N	0	\N	-1	0a00872c-1d53-41ee-afd2-d062b0bb676f
308	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	0a00872c-1d53-41ee-afd2-d062b0bb676f
309	77	2024-08-02T19:08:21Z	\N	0	\N	-1	0a00872c-1d53-41ee-afd2-d062b0bb676f
735	73	mapfile	\N	0	\N	-1	6ec99fa2-276f-4119-91e9-6e46116e43fc
311	73	Burdwan_Farmers_Convention_Vol-1_January_1957 (7).pdf	\N	0	\N	-1	2191ea91-4091-45d2-a4a1-725d635802fe
312	64	Burdwan_Farmers_Convention_Vol-1_January_1957 (7).pdf	\N	0	\N	-1	2191ea91-4091-45d2-a4a1-725d635802fe
736	240	importSAFMapfile	\N	0	\N	-1	6ec99fa2-276f-4119-91e9-6e46116e43fc
314	73	license.txt	\N	0	\N	-1	aaeeb341-c623-4c0d-b9b9-7f9568feacbe
315	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	aaeeb341-c623-4c0d-b9b9-7f9568feacbe
316	77	2024-08-02T19:23:54Z	\N	0	\N	-1	aaeeb341-c623-4c0d-b9b9-7f9568feacbe
737	73	3-import.log	\N	0	\N	-1	a28e25ae-96cb-499b-aa50-cf8f6b868150
325	73	New_Techniques_in_Farming_Vol-13_Issue-10_October_1969 (1).pdf	\N	0	\N	-1	45791949-4999-465b-8be2-d8f4bcb953b9
326	64	New_Techniques_in_Farming_Vol-13_Issue-10_October_1969 (1).pdf	\N	0	\N	-1	45791949-4999-465b-8be2-d8f4bcb953b9
738	240	script_output	\N	0	\N	-1	a28e25ae-96cb-499b-aa50-cf8f6b868150
342	73	Burdwan_Farmers_Convention_Vol-1_January_1957 (6).pdf	\N	0	\N	-1	d42d7bf8-74fa-4a24-bee7-51db8c5f09a4
343	64	Burdwan_Farmers_Convention_Vol-1_January_1957 (6).pdf	\N	0	\N	-1	d42d7bf8-74fa-4a24-bee7-51db8c5f09a4
741	73	mapfile	\N	0	\N	-1	2b8dc1ca-f8da-45c9-9b7f-6149d3d5d191
345	73	license.txt	\N	0	\N	-1	428d54c9-c728-4678-9f62-043a7d175237
346	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	428d54c9-c728-4678-9f62-043a7d175237
347	77	2024-08-02T19:46:38Z	\N	0	\N	-1	428d54c9-c728-4678-9f62-043a7d175237
742	240	importSAFMapfile	\N	0	\N	-1	2b8dc1ca-f8da-45c9-9b7f-6149d3d5d191
356	73	Burdwan_Farmers_Convention_Vol-1_January_1957 (6).pdf	\N	0	\N	-1	6ea746de-6c4b-4288-9bee-a93cc0a8037c
357	64	Burdwan_Farmers_Convention_Vol-1_January_1957 (6).pdf	\N	0	\N	-1	6ea746de-6c4b-4288-9bee-a93cc0a8037c
743	73	4-import.log	\N	0	\N	-1	f4ef99d8-0800-4b93-bf95-129faf3015e4
359	73	license.txt	\N	0	\N	-1	dc72b579-bf8e-4e1d-ba58-e52031095104
360	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	dc72b579-bf8e-4e1d-ba58-e52031095104
361	77	2024-08-02T19:57:28Z	\N	0	\N	-1	dc72b579-bf8e-4e1d-ba58-e52031095104
744	240	script_output	\N	0	\N	-1	f4ef99d8-0800-4b93-bf95-129faf3015e4
380	73	license.txt	\N	0	\N	-1	8de27065-13ba-45e1-b85c-80d68bf2a1f6
381	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	8de27065-13ba-45e1-b85c-80d68bf2a1f6
382	77	2024-08-02T20:10:03Z	\N	0	\N	-1	8de27065-13ba-45e1-b85c-80d68bf2a1f6
1307	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	f7c4a72e-a00f-4229-934f-849567e8a211
384	73	Burdwan_Farmers_Convention_Vol-1_January_1957 (7).pdf	\N	0	\N	-1	279ff75d-77af-44c0-ad5d-d76df4c78ed2
385	64	Burdwan_Farmers_Convention_Vol-1_January_1957 (7).pdf	\N	0	\N	-1	279ff75d-77af-44c0-ad5d-d76df4c78ed2
729	73	mapfile	\N	0	\N	-1	22915ed5-e8f4-4442-bfd4-cc6e488c47df
387	73	license.txt	\N	0	\N	-1	f883f0c4-3c25-415a-abed-f5ab0b95a291
388	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	f883f0c4-3c25-415a-abed-f5ab0b95a291
389	77	2024-08-02T20:14:17Z	\N	0	\N	-1	f883f0c4-3c25-415a-abed-f5ab0b95a291
730	240	importSAFMapfile	\N	0	\N	-1	22915ed5-e8f4-4442-bfd4-cc6e488c47df
391	73	Burdwan_Farmers_Convention_Vol-1_January_1957 (5).pdf	\N	0	\N	-1	1e635111-9d8f-4e4a-876f-31b937a0fa5d
392	64	Burdwan_Farmers_Convention_Vol-1_January_1957 (5).pdf	\N	0	\N	-1	1e635111-9d8f-4e4a-876f-31b937a0fa5d
394	73	license.txt	\N	0	\N	-1	c664e707-9730-4f7b-ae79-ad35c83f5baa
395	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	c664e707-9730-4f7b-ae79-ad35c83f5baa
396	77	2024-08-02T20:17:30Z	\N	0	\N	-1	c664e707-9730-4f7b-ae79-ad35c83f5baa
426	73	Burdwan_Farmers_Convention_Vol-1_January_1957 (2).pdf	\N	0	\N	-1	666cdae1-e874-4961-a48e-044c1c1c29b1
398	73	Burdwan_Farmers_Convention_Vol-1_January_1957 (6).pdf	\N	0	\N	-1	d7e89e60-4c09-4a36-91fa-f87a6ac88f10
399	64	Burdwan_Farmers_Convention_Vol-1_January_1957 (6).pdf	\N	0	\N	-1	d7e89e60-4c09-4a36-91fa-f87a6ac88f10
731	73	2-import.log	\N	0	\N	-1	173374f7-02e5-4817-8ab7-8cbd382985b0
427	64	Burdwan_Farmers_Convention_Vol-1_January_1957 (2).pdf	\N	0	\N	-1	666cdae1-e874-4961-a48e-044c1c1c29b1
401	73	license.txt	\N	0	\N	-1	97dbfc61-89cf-4fb3-8825-d30bf55642ee
402	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	97dbfc61-89cf-4fb3-8825-d30bf55642ee
403	77	2024-08-02T20:18:29Z	\N	0	\N	-1	97dbfc61-89cf-4fb3-8825-d30bf55642ee
732	240	script_output	\N	0	\N	-1	173374f7-02e5-4817-8ab7-8cbd382985b0
405	73	Burdwan_Farmers_Convention_Vol-1_January_1957 (6).pdf	\N	0	\N	-1	8bf4e517-56af-4a48-a65f-574bc1498aed
406	64	Burdwan_Farmers_Convention_Vol-1_January_1957 (6).pdf	\N	0	\N	-1	8bf4e517-56af-4a48-a65f-574bc1498aed
733	73	ANNUAL.zip	\N	0	\N	-1	3c6e31ad-5217-40cc-8112-4324477ea8d8
408	73	license.txt	\N	0	\N	-1	494fbda6-b49f-451e-a13e-e0ca8cbd7ceb
409	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	494fbda6-b49f-451e-a13e-e0ca8cbd7ceb
410	77	2024-08-02T20:35:00Z	\N	0	\N	-1	494fbda6-b49f-451e-a13e-e0ca8cbd7ceb
734	240	inputfile	\N	0	\N	-1	3c6e31ad-5217-40cc-8112-4324477ea8d8
412	73	Burdwan_Farmers_Convention_Vol-1_January_1957 (5).pdf	\N	0	\N	-1	d9de3187-2c1a-462c-8c57-361c44172721
413	64	Burdwan_Farmers_Convention_Vol-1_January_1957 (5).pdf	\N	0	\N	-1	d9de3187-2c1a-462c-8c57-361c44172721
739	73	ANNUAL.zip	\N	0	\N	-1	7a292192-5bec-4358-bfdc-ae27578b4cb9
415	73	license.txt	\N	0	\N	-1	f175016d-594a-4070-8cb3-4ed00c7a25b0
416	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	f175016d-594a-4070-8cb3-4ed00c7a25b0
417	77	2024-08-02T20:54:05Z	\N	0	\N	-1	f175016d-594a-4070-8cb3-4ed00c7a25b0
740	240	inputfile	\N	0	\N	-1	7a292192-5bec-4358-bfdc-ae27578b4cb9
1308	77	2025-04-21T15:04:10Z	\N	0	\N	-1	f7c4a72e-a00f-4229-934f-849567e8a211
419	73	Burdwan_Farmers_Convention_Vol-1_January_1957 (7).pdf	\N	0	\N	-1	ac7c3fab-92e1-4559-b929-df4d8351cb5e
420	64	Burdwan_Farmers_Convention_Vol-1_January_1957 (7).pdf	\N	0	\N	-1	ac7c3fab-92e1-4559-b929-df4d8351cb5e
422	73	license.txt	\N	0	\N	-1	bde6882b-dcee-421a-89f9-37db10c46792
423	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	bde6882b-dcee-421a-89f9-37db10c46792
424	77	2024-08-04T14:47:53Z	\N	0	\N	-1	bde6882b-dcee-421a-89f9-37db10c46792
429	73	license.txt	\N	0	\N	-1	c47496a8-6525-4a6a-bed9-bbffac9d426a
430	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	c47496a8-6525-4a6a-bed9-bbffac9d426a
431	77	2024-08-04T14:48:55Z	\N	0	\N	-1	c47496a8-6525-4a6a-bed9-bbffac9d426a
2334	73	hr.zip	\N	0	\N	-1	f557699e-1b6f-4152-8393-17b03dc6a5da
2335	240	inputfile	\N	0	\N	-1	f557699e-1b6f-4152-8393-17b03dc6a5da
433	73	Burdwan_Farmers_Convention_Vol-1_January_1957 (7).pdf	\N	0	\N	-1	b4066a60-4017-4ecd-b54c-8b8699f26b19
434	64	Burdwan_Farmers_Convention_Vol-1_January_1957 (7).pdf	\N	0	\N	-1	b4066a60-4017-4ecd-b54c-8b8699f26b19
436	73	license.txt	\N	0	\N	-1	e84a7e74-e847-4548-b876-1162bef094a6
437	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	e84a7e74-e847-4548-b876-1162bef094a6
438	77	2024-08-05T11:24:48Z	\N	0	\N	-1	e84a7e74-e847-4548-b876-1162bef094a6
2357	73	hr.zip	\N	0	\N	-1	4bfbf1d6-a42a-4b93-b3e3-34fe8a309351
2358	240	inputfile	\N	0	\N	-1	4bfbf1d6-a42a-4b93-b3e3-34fe8a309351
2380	73	Panda.zip	\N	0	\N	-1	910811f3-954b-4e26-8eb4-8e8cb14100e0
2381	240	inputfile	\N	0	\N	-1	910811f3-954b-4e26-8eb4-8e8cb14100e0
5885	73	Panda.zip	\N	0	\N	-1	46ec0a27-1027-403d-81ab-6e16088394c2
5886	240	inputfile	\N	0	\N	-1	46ec0a27-1027-403d-81ab-6e16088394c2
6702	291	955e09e0-6fe8-4209-a85b-86650f8b1469_2025-05-19	\N	6	\N	-1	75c3ab94-832e-4d84-9b5c-10b046200c09
7789	73	rav.zip	\N	0	\N	-1	fe337f7c-54ed-46c9-b5fa-84910f1e2282
7790	240	inputfile	\N	0	\N	-1	fe337f7c-54ed-46c9-b5fa-84910f1e2282
7795	73	rav.zip	\N	0	\N	-1	95b580c3-d3cd-4e48-9791-e2d8ce4a2330
3814	73	Panda.zip	\N	0	\N	-1	11e326a6-41d1-48aa-ab44-88e79be87367
3815	240	inputfile	\N	0	\N	-1	11e326a6-41d1-48aa-ab44-88e79be87367
7796	240	inputfile	\N	0	\N	-1	95b580c3-d3cd-4e48-9791-e2d8ce4a2330
4642	73	ann.pdf	\N	0	\N	-1	97ff5936-6bee-4b7d-8153-46a4b532ba4c
4643	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	84364eae-925c-47f5-81e2-71a7d9605cfa
451	73	Burdwan_Farmers_Convention_Vol-1_January_1957.pdf	\N	0	\N	-1	1a11803d-1f11-49ad-b488-77fa97f2289b
452	64	Burdwan_Farmers_Convention_Vol-1_January_1957.pdf	\N	0	\N	-1	1a11803d-1f11-49ad-b488-77fa97f2289b
1315	73	DMS_Brochure_Optimark_2025.pdf	\N	0	\N	-1	2da875ab-3c70-4207-bb7e-d2439ea6c511
1362	1	Admin	\N	0	\N	-1	75c3ab94-832e-4d84-9b5c-10b046200c09
1786	73	ann.pdf	\N	0	\N	-1	b2af4673-5761-419b-92f2-069499eba9e6
1787	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	da04ea46-4f37-4585-9cb3-e4c968c51bad
2355	73	16-import.log	\N	0	\N	-1	b827b971-58f2-455a-9575-63b771b6a920
2356	240	script_output	\N	0	\N	-1	b827b971-58f2-455a-9575-63b771b6a920
5480	73	ann.pdf	\N	0	\N	-1	d0a31804-ac18-49a4-b18b-91192ee180d8
3351	73	license.txt	\N	0	\N	-1	f1a2433b-b17f-42d6-a354-ff877a3d5a2b
5481	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	8d4f00e3-5ab7-498c-a413-7de4b878cdf6
3352	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	f1a2433b-b17f-42d6-a354-ff877a3d5a2b
464	73	Burdwan_Farmers_Convention_Vol-1_January_1957 (7).pdf	\N	0	\N	-1	2e850448-44b2-4aaf-bdb1-04a985298ac3
465	64	Burdwan_Farmers_Convention_Vol-1_January_1957 (7).pdf	\N	0	\N	-1	2e850448-44b2-4aaf-bdb1-04a985298ac3
676	73	Burdwan_Farmers_Convention_Vol-1_January_1957 (5).pdf	\N	0	\N	-1	324619d3-2742-420d-9bb8-26392c6656af
467	73	license.txt	\N	0	\N	-1	57baadf2-71e4-4d2a-9f0a-644901bacff5
468	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	57baadf2-71e4-4d2a-9f0a-644901bacff5
469	77	2024-08-13T19:50:54Z	\N	0	\N	-1	57baadf2-71e4-4d2a-9f0a-644901bacff5
3353	77	2025-05-09T06:14:25Z	\N	0	\N	-1	f1a2433b-b17f-42d6-a354-ff877a3d5a2b
677	64	Burdwan_Farmers_Convention_Vol-1_January_1957 (5).pdf	\N	0	\N	-1	324619d3-2742-420d-9bb8-26392c6656af
3331	73	22-import.log	\N	0	\N	-1	e9377708-7c1d-4b2a-ba7f-b07e4f2762ec
3332	240	script_output	\N	0	\N	-1	e9377708-7c1d-4b2a-ba7f-b07e4f2762ec
3343	73	work-bg.webp	\N	0	\N	-1	83bb9fcc-27f4-498d-9554-aa80daadd80c
3344	64	work-bg.webp	\N	0	\N	-1	83bb9fcc-27f4-498d-9554-aa80daadd80c
6709	291	690ac130-4f66-4560-8352-5265946a862c_2025-05-22_1,2,3,4-9	\N	4	\N	-1	75c3ab94-832e-4d84-9b5c-10b046200c09
4256	73	ann9.pdf	\N	0	\N	-1	9e7eb8d6-5b00-42a3-ae42-6d00f5924121
4257	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	e0edd021-dbe6-4b24-8440-ed83277c0f59
7793	73	36-import.log	\N	0	\N	-1	bf5ad438-914a-48b9-a745-39d5003c6d14
482	73	Burdwan_Farmers_Convention_Vol-1_January_1957 (5).pdf	\N	0	\N	-1	91ee1c48-06fd-4af4-a9e9-ed7caed2b547
483	64	Burdwan_Farmers_Convention_Vol-1_January_1957 (5).pdf	\N	0	\N	-1	91ee1c48-06fd-4af4-a9e9-ed7caed2b547
485	73	license.txt	\N	0	\N	-1	3332bd87-0e63-457b-9be5-594da51b0566
486	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	3332bd87-0e63-457b-9be5-594da51b0566
487	77	2024-08-13T19:59:50Z	\N	0	\N	-1	3332bd87-0e63-457b-9be5-594da51b0566
7794	240	script_output	\N	0	\N	-1	bf5ad438-914a-48b9-a745-39d5003c6d14
679	73	license.txt	\N	0	\N	-1	e5805876-74af-418a-afba-421053c0e889
511	77	2024-08-13T20:14:51Z	\N	0	\N	-1	bc4b83a2-fb82-4f7b-8ffe-af436db04ec8
1806	73	ann9.pdf	\N	0	\N	-1	6bf62d50-0441-4a85-bd58-635cb5e1a5f1
1807	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	e2c37321-66aa-4573-a9de-70d29b6f099b
3367	73	Panda.zip	\N	0	\N	-1	439c7f26-2571-48a3-98c3-c22c7ad5aa5e
3368	240	inputfile	\N	0	\N	-1	439c7f26-2571-48a3-98c3-c22c7ad5aa5e
6703	291	93ca862b-b651-442c-b6fe-fb11a0b13c7c_2025-05-19	\N	5	\N	-1	75c3ab94-832e-4d84-9b5c-10b046200c09
519	73	Minister_of_State_for_Food_and_Agriculture_Governm_Vol-13_Issue-5-6_May-June_1969 (1).pdf	\N	0	\N	-1	2591ffac-01e2-4c96-acf0-cab1938845b0
499	73	Burdwan_Farmers_Convention_Vol-1_January_1957 (5).pdf	\N	0	\N	-1	a7f86a11-fcfb-4df5-87f0-49e3103c5148
500	64	Burdwan_Farmers_Convention_Vol-1_January_1957 (5).pdf	\N	0	\N	-1	a7f86a11-fcfb-4df5-87f0-49e3103c5148
680	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	e5805876-74af-418a-afba-421053c0e889
520	64	Minister_of_State_for_Food_and_Agriculture_Governm_Vol-13_Issue-5-6_May-June_1969 (1).pdf	\N	0	\N	-1	2591ffac-01e2-4c96-acf0-cab1938845b0
502	73	license.txt	\N	0	\N	-1	c3b58c0a-fb64-494d-8a5a-ce505d02334a
503	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	c3b58c0a-fb64-494d-8a5a-ce505d02334a
504	77	2024-08-13T20:09:54Z	\N	0	\N	-1	c3b58c0a-fb64-494d-8a5a-ce505d02334a
681	77	2024-08-17T18:04:08Z	\N	0	\N	-1	e5805876-74af-418a-afba-421053c0e889
506	73	Burdwan_Farmers_Convention_Vol-1_January_1957 (5).pdf	\N	0	\N	-1	87875547-a4d0-43e5-a51c-f8694fc1e0fe
507	64	Burdwan_Farmers_Convention_Vol-1_January_1957 (5).pdf	\N	0	\N	-1	87875547-a4d0-43e5-a51c-f8694fc1e0fe
509	73	license.txt	\N	0	\N	-1	bc4b83a2-fb82-4f7b-8ffe-af436db04ec8
510	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	bc4b83a2-fb82-4f7b-8ffe-af436db04ec8
5901	73	ann.pdf	\N	0	\N	-1	6e710488-829c-49fa-9395-ba4c9292103d
5902	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	b955a8b6-0084-483d-b0da-0310e39a20d5
522	73	license.txt	\N	0	\N	-1	b657dfc2-1e64-4565-a23e-ac69945c5e51
523	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	b657dfc2-1e64-4565-a23e-ac69945c5e51
524	77	2024-08-13T20:25:05Z	\N	0	\N	-1	b657dfc2-1e64-4565-a23e-ac69945c5e51
6704	241	true	\N	0	\N	-1	622fda42-aaec-495d-81ca-eff8577777b5
6705	1	Shubham	\N	0	\N	-1	622fda42-aaec-495d-81ca-eff8577777b5
6706	4	en	\N	0	\N	-1	622fda42-aaec-495d-81ca-eff8577777b5
6315	73	Credence.pdf	\N	0	\N	-1	ba41d4b0-e409-4f91-82b3-a793a859fd1e
6316	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	6c84f31d-2d1c-4b63-8002-b9b3bc305623
6707	2	Singh	\N	0	\N	-1	622fda42-aaec-495d-81ca-eff8577777b5
6708	3	8252128044	\N	0	\N	-1	622fda42-aaec-495d-81ca-eff8577777b5
1827	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	ca8dad51-dfe2-45c9-add4-aad6ee9a4559
2249	73	hr.zip	\N	0	\N	-1	316d2622-95b1-4b41-bd8c-271a59ffae66
1364	73	Panda.zip	\N	0	\N	-1	7088082e-d908-4d91-9d78-697ce5af8e2c
2250	240	inputfile	\N	0	\N	-1	316d2622-95b1-4b41-bd8c-271a59ffae66
536	73	Burdwan_Farmers_Convention_Vol-1_January_1957 (5).pdf	\N	0	\N	-1	c226ac74-c714-4d4f-a65d-764b5d59ff43
537	64	Burdwan_Farmers_Convention_Vol-1_January_1957 (5).pdf	\N	0	\N	-1	c226ac74-c714-4d4f-a65d-764b5d59ff43
1365	240	inputfile	\N	0	\N	-1	7088082e-d908-4d91-9d78-697ce5af8e2c
539	73	license.txt	\N	0	\N	-1	f2bde1b1-ca22-443d-a958-c8575d953772
540	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	f2bde1b1-ca22-443d-a958-c8575d953772
541	77	2024-08-13T20:29:38Z	\N	0	\N	-1	f2bde1b1-ca22-443d-a958-c8575d953772
2883	73	20-import.log	\N	0	\N	-1	9272ae94-f565-4b74-86b8-55302a4bff38
543	73	New_Techniques_in_Farming_Vol-13_Issue-10_October_1969.pdf	\N	0	\N	-1	76127d2c-e183-47c4-a072-a84d0f5642b9
544	64	New_Techniques_in_Farming_Vol-13_Issue-10_October_1969.pdf	\N	0	\N	-1	76127d2c-e183-47c4-a072-a84d0f5642b9
2884	240	script_output	\N	0	\N	-1	9272ae94-f565-4b74-86b8-55302a4bff38
546	73	license.txt	\N	0	\N	-1	7a2b4032-6338-4f6d-abad-726db6b2488e
547	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	7a2b4032-6338-4f6d-abad-726db6b2488e
548	77	2024-08-13T20:40:20Z	\N	0	\N	-1	7a2b4032-6338-4f6d-abad-726db6b2488e
6742	73	31-import.log	\N	0	\N	-1	faae6b89-5b63-44db-9b26-fd912081f9eb
6743	240	script_output	\N	0	\N	-1	faae6b89-5b63-44db-9b26-fd912081f9eb
5500	73	ann9.pdf	\N	0	\N	-1	e6a11a4c-7229-4c35-9a69-ba40cb9f6792
5501	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	1c4a4467-f236-44e2-9b7e-f3e6e21f3e47
560	73	Burdwan_Farmers_Convention_Vol-1_January_1957 (5).pdf	\N	0	\N	-1	e1326ff4-fc49-48d8-9353-2cdee18d2c72
561	64	Burdwan_Farmers_Convention_Vol-1_January_1957 (5).pdf	\N	0	\N	-1	e1326ff4-fc49-48d8-9353-2cdee18d2c72
563	73	license.txt	\N	0	\N	-1	d6f002d5-b5e4-4857-9b3a-23adc038ddd1
564	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	d6f002d5-b5e4-4857-9b3a-23adc038ddd1
565	77	2024-08-13T20:44:52Z	\N	0	\N	-1	d6f002d5-b5e4-4857-9b3a-23adc038ddd1
1826	73	ann10.pdf	\N	0	\N	-1	8b9f2da6-aaf3-4f80-bd18-cb472bc5980e
2378	73	17-import.log	\N	0	\N	-1	c3b39c9e-0e5b-4d7f-b7fc-fcab7c249183
2379	240	script_output	\N	0	\N	-1	c3b39c9e-0e5b-4d7f-b7fc-fcab7c249183
3830	73	ann.pdf	\N	0	\N	-1	b26f3744-c739-43ac-891e-ec9f30e20bef
579	73	pftrust_card_2024.pdf	\N	0	\N	-1	1f956b79-4c6a-4b92-a23e-a9bd1045456f
580	64	pftrust_card_2024.pdf	\N	0	\N	-1	1f956b79-4c6a-4b92-a23e-a9bd1045456f
3831	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	f1a95d81-73b6-407d-b7c2-61858eaa8604
5921	73	ann9.pdf	\N	0	\N	-1	a3b7299c-f254-4762-9e33-2f05e41660df
582	73	license.txt	\N	0	\N	-1	3c49f4fd-154f-49a3-bdfa-27bae9c848a2
583	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	3c49f4fd-154f-49a3-bdfa-27bae9c848a2
584	77	2024-08-13T20:47:12Z	\N	0	\N	-1	3c49f4fd-154f-49a3-bdfa-27bae9c848a2
5922	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	f1e4c38d-d1d2-4e98-8206-87f450f9345d
7636	73	Credence19.pdf	\N	0	\N	-1	790e72a6-df8d-4389-9360-ea6f7f869869
7637	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	3c921302-1a45-4345-905d-124296663213
6710	291	690ac130-4f66-4560-8352-5265946a862c_2025-05-22_1	\N	3	\N	-1	75c3ab94-832e-4d84-9b5c-10b046200c09
596	73	Burdwan_Farmers_Convention_Vol-1_January_1957 (5).pdf	\N	0	\N	-1	135bf286-ca4f-4440-aab0-783449b4316a
597	64	Burdwan_Farmers_Convention_Vol-1_January_1957 (5).pdf	\N	0	\N	-1	135bf286-ca4f-4440-aab0-783449b4316a
599	73	license.txt	\N	0	\N	-1	89d9c763-30c3-4557-93fe-3776fdc49689
600	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	89d9c763-30c3-4557-93fe-3776fdc49689
601	77	2024-08-14T19:24:07Z	\N	0	\N	-1	89d9c763-30c3-4557-93fe-3776fdc49689
5520	73	ann10.pdf	\N	0	\N	-1	05be9bc9-cef6-4cf6-a40c-13a224fb925c
5521	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	26081a3f-a320-41a8-860e-611bc0c9f92c
613	73	New_Techniques_in_Farming_Vol-13_Issue-10_October_1969.pdf	\N	0	\N	-1	e0b6a6c5-4a04-4e79-a32f-e07f60edfa10
614	64	New_Techniques_in_Farming_Vol-13_Issue-10_October_1969.pdf	\N	0	\N	-1	e0b6a6c5-4a04-4e79-a32f-e07f60edfa10
616	73	license.txt	\N	0	\N	-1	e7e64031-a35c-474b-b81e-c80dee141c79
617	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	e7e64031-a35c-474b-b81e-c80dee141c79
618	77	2024-08-14T20:07:41Z	\N	0	\N	-1	e7e64031-a35c-474b-b81e-c80dee141c79
3850	73	ann9.pdf	\N	0	\N	-1	3f0b7a1a-56c5-4a02-9d91-6a9e4ca848a1
3851	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	78d6cda6-454c-4b43-a5ae-38b0a8b725b9
629	73	Burdwan_Farmers_Convention_Vol-1_January_1957 (5).pdf	\N	0	\N	-1	44a85498-ecef-436f-b327-974987702e5f
630	64	Burdwan_Farmers_Convention_Vol-1_January_1957 (5).pdf	\N	0	\N	-1	44a85498-ecef-436f-b327-974987702e5f
693	73	Burdwan_Farmers_Convention_Vol-1_January_1957 (1).pdf	\N	0	\N	-1	fdf22476-a896-41cd-b9df-f1ffdc5f3905
694	64	Burdwan_Farmers_Convention_Vol-1_January_1957 (1).pdf	\N	0	\N	-1	fdf22476-a896-41cd-b9df-f1ffdc5f3905
2402	73	18-import.log	\N	0	\N	-1	86f31c01-ad08-48e7-bb7a-c95405c442ef
2293	73	14-import.log	\N	0	\N	-1	d2ff8407-6bee-490f-aadb-5411c8a7b105
640	73	license.txt	\N	0	\N	-1	119b7097-52b2-472b-a62e-8b209abe827f
641	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	119b7097-52b2-472b-a62e-8b209abe827f
642	77	2024-08-16T07:44:15Z	\N	0	\N	-1	119b7097-52b2-472b-a62e-8b209abe827f
1380	73	ann.pdf	\N	0	\N	-1	b632144c-bea6-4d11-81b1-29599b5b343c
1381	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	e862c4db-7e1d-4295-93fc-44c653221019
2270	73	13-import.log	\N	0	\N	-1	db2546cd-9aef-4ef8-8472-97aff1fd1817
2271	240	script_output	\N	0	\N	-1	db2546cd-9aef-4ef8-8472-97aff1fd1817
2403	240	script_output	\N	0	\N	-1	86f31c01-ad08-48e7-bb7a-c95405c442ef
2910	73	ann.pdf	\N	0	\N	-1	7b2533fa-27a4-4a86-9754-bb85d8ac28a3
2911	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	84cd1ce2-3157-489a-acde-d42c5b984924
696	73	license.txt	\N	0	\N	-1	cc5897b0-73f1-43bb-aab2-2e3ed2c30b21
697	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	cc5897b0-73f1-43bb-aab2-2e3ed2c30b21
698	77	2024-08-17T18:09:43Z	\N	0	\N	-1	cc5897b0-73f1-43bb-aab2-2e3ed2c30b21
3383	73	ann.pdf	\N	0	\N	-1	87489ca1-2f0a-4303-b079-e9bcea09ef27
3384	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	e80fa848-8aa7-4d8f-bd3f-05c9fbc64526
5941	73	ann10.pdf	\N	0	\N	-1	e199589a-7d7a-47f4-a3f7-ac3e2ba4331d
5942	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	89288969-324a-4b85-8926-c8e8e442e6e0
2294	240	script_output	\N	0	\N	-1	d2ff8407-6bee-490f-aadb-5411c8a7b105
5540	73	ann11.pdf	\N	0	\N	-1	cd7fcc21-4cf6-4f7a-a81d-d865a540d04a
5541	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	75c637f4-7784-4779-b7fd-1d3ed1b5771f
710	4	en	\N	0	\N	-1	75c3ab94-832e-4d84-9b5c-10b046200c09
4276	73	ann10.pdf	\N	0	\N	-1	c453bc37-9fca-4a5c-acc9-f17112581e94
4277	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	0c1a4dd0-f998-4dbe-900f-948ec285e720
6769	73	ann.pdf	\N	0	\N	-1	b152c321-6354-41af-bcff-84c25b5f84a5
6770	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	ffbeaa0e-17f9-4ce4-b9a9-fbd3edf235df
1325	73	Request For Proposal_Online Digital Library_V 1.0.pdf	\N	0	\N	-1	4d8e733b-3140-4c5e-b5f9-a16a758afafd
1326	64	Request For Proposal_Online Digital Library_V 1.0.pdf	\N	0	\N	-1	4d8e733b-3140-4c5e-b5f9-a16a758afafd
3870	73	ann10.pdf	\N	0	\N	-1	7bc3b082-844c-49e3-bb13-e5575abb06d2
3871	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	1051d35e-9542-4efc-8129-b51986005895
6753	73	Panda.zip	\N	0	\N	-1	3d78308d-f318-4868-b9b0-c72b4c1d762c
3403	73	ann9.pdf	\N	0	\N	-1	5aaefc24-96b6-41da-9b95-4c2e54e4989e
1420	73	ann10.pdf	\N	0	\N	-1	0c28b25e-492e-4776-8dab-20bc4464d954
3404	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	efa5e7a6-39b8-4501-8f4d-7e1e45b38e90
6754	240	inputfile	\N	0	\N	-1	3d78308d-f318-4868-b9b0-c72b4c1d762c
1333	73	license.txt	\N	0	\N	-1	b10693f9-9de0-401d-83a7-9f678d457e4b
1334	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	b10693f9-9de0-401d-83a7-9f678d457e4b
1335	77	2025-04-22T12:47:21Z	\N	0	\N	-1	b10693f9-9de0-401d-83a7-9f678d457e4b
2894	73	Panda.zip	\N	0	\N	-1	81ce143d-a2d9-418d-999b-b5804b293746
2895	240	inputfile	\N	0	\N	-1	81ce143d-a2d9-418d-999b-b5804b293746
2405	73	Techbets.png	\N	0	\N	-1	47176c3f-ace6-40e4-8011-aef1ed09355a
2406	64	Techbets.png	\N	0	\N	-1	47176c3f-ace6-40e4-8011-aef1ed09355a
1400	73	ann9.pdf	\N	0	\N	-1	9ba23e80-2752-4574-a0fd-d123b711a682
1401	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	4759d16b-b270-4fe5-9ff1-34f6a8191434
2413	73	license.txt	\N	0	\N	-1	282545ec-368f-45e6-aeb7-3996412ce4b8
2414	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	282545ec-368f-45e6-aeb7-3996412ce4b8
2415	77	2025-05-06T14:10:23Z	\N	0	\N	-1	282545ec-368f-45e6-aeb7-3996412ce4b8
5961	73	ann11.pdf	\N	0	\N	-1	a482526f-20ab-4fab-898e-203ca539a8af
5962	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	aed73850-f650-4482-a3b7-8c462cdec415
5560	73	ann12.pdf	\N	0	\N	-1	c6205ff8-1a9b-455b-b7b3-fe40cc16f615
5561	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	f11caffa-c6e2-4c10-a14b-d456349a9204
3890	73	ann11.pdf	\N	0	\N	-1	0cfcbaab-0582-443c-8fef-0f932ae383d9
3423	73	ann10.pdf	\N	0	\N	-1	5d2693e6-6629-4c5d-8a13-b34914601ac7
3424	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	f302fa2c-bbd7-4ca5-8cca-d3e215827d23
3891	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	f63e4433-7870-4c79-b096-38fdf005aaf2
1421	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	7ffc982c-9301-4082-9d1e-282652a88336
7655	73	Credence2.pdf	\N	0	\N	-1	0f20bd41-39e2-485b-9f29-827c2f048239
7656	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	59200dc7-3a0e-434d-b358-4337044d368c
7812	73	37-import.log	\N	0	\N	-1	9332be79-a9bf-4463-9f63-46c590148f71
7813	240	script_output	\N	0	\N	-1	9332be79-a9bf-4463-9f63-46c590148f71
6334	73	Credence9.pdf	\N	0	\N	-1	94c17305-6e46-4bba-a216-828c3aef4b6b
6335	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	81aa4974-05ad-4aca-8cc1-ffeb346058c6
4296	73	ann11.pdf	\N	0	\N	-1	944185af-ee0d-45ad-8f94-7e5bdad716e3
4297	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	82e3fc71-c762-495b-a9fa-e8890b8f9b75
815	73	ANNUAL.zip	\N	0	\N	-1	062c9c70-eec2-4188-b48b-b23ea4a1bd45
816	240	inputfile	\N	0	\N	-1	062c9c70-eec2-4188-b48b-b23ea4a1bd45
817	73	mapfile	\N	0	\N	-1	1e99bd7c-6734-4755-bafb-cf883f044ea8
818	240	importSAFMapfile	\N	0	\N	-1	1e99bd7c-6734-4755-bafb-cf883f044ea8
819	73	5-import.log	\N	0	\N	-1	7c0b6660-9bd8-4542-bc74-8781cbc72f9e
820	240	script_output	\N	0	\N	-1	7c0b6660-9bd8-4542-bc74-8781cbc72f9e
821	73	ANNUAL.zip	\N	0	\N	-1	29326696-59de-446c-b833-d36936828fae
822	240	inputfile	\N	0	\N	-1	29326696-59de-446c-b833-d36936828fae
823	73	mapfile	\N	0	\N	-1	4a7752ff-8932-46d1-a766-4d36a723bd81
824	240	importSAFMapfile	\N	0	\N	-1	4a7752ff-8932-46d1-a766-4d36a723bd81
825	73	6-import.log	\N	0	\N	-1	74058e8c-9fe4-4ff4-8e5d-b02d09caa089
826	240	script_output	\N	0	\N	-1	74058e8c-9fe4-4ff4-8e5d-b02d09caa089
827	73	dev.zip	\N	0	\N	-1	7933d957-9acb-4f10-b440-50d041bea0af
828	240	inputfile	\N	0	\N	-1	7933d957-9acb-4f10-b440-50d041bea0af
829	73	mapfile	\N	0	\N	-1	b4528df9-6838-43d5-a987-e728e82ea1d0
830	240	importSAFMapfile	\N	0	\N	-1	b4528df9-6838-43d5-a987-e728e82ea1d0
831	73	7-import.log	\N	0	\N	-1	62ac2a5a-39de-4135-a25c-8365422a6ca0
832	240	script_output	\N	0	\N	-1	62ac2a5a-39de-4135-a25c-8365422a6ca0
833	73	dev.zip	\N	0	\N	-1	8a6cccc0-a9d0-444a-b5c0-da345485e010
834	240	inputfile	\N	0	\N	-1	8a6cccc0-a9d0-444a-b5c0-da345485e010
835	73	mapfile	\N	0	\N	-1	23c3b697-a4c5-48aa-9ee0-0aca2b5a1b4b
836	240	importSAFMapfile	\N	0	\N	-1	23c3b697-a4c5-48aa-9ee0-0aca2b5a1b4b
837	73	8-import.log	\N	0	\N	-1	4d5deca8-556f-414c-a5cc-051cfb1bc48f
838	240	script_output	\N	0	\N	-1	4d5deca8-556f-414c-a5cc-051cfb1bc48f
839	73	dev.zip	\N	0	\N	-1	5cd90407-6e36-4f08-b959-9ca3877719f3
840	240	inputfile	\N	0	\N	-1	5cd90407-6e36-4f08-b959-9ca3877719f3
1341	73	burger.png	\N	0	\N	-1	d130a874-3309-4eda-a25b-736f2a96053d
2303	73	hr.zip	\N	0	\N	-1	baecae16-b3b8-488d-a525-49dfbd060e76
2304	240	inputfile	\N	0	\N	-1	baecae16-b3b8-488d-a525-49dfbd060e76
5981	73	ann12.pdf	\N	0	\N	-1	627bbb3d-9477-4479-9450-5c9ae43d3270
5982	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	eae97bd1-3e85-4ade-8936-94a4d7b50dfd
2930	73	ann9.pdf	\N	0	\N	-1	ab9be5fa-c94c-4df8-a5d9-544adc1cbe12
2931	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	cba03df3-54cb-4f65-9fd9-589599f6d691
5580	73	ann13.pdf	\N	0	\N	-1	adeb5507-ea74-409c-a25b-defd9de863cd
1440	73	ann11.pdf	\N	0	\N	-1	230df675-813a-4475-8d87-66509d79d8f7
1441	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	262f89b1-29ad-4e32-b336-5a13e84f32ca
5581	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	788e30aa-0009-446f-94e6-4ba84886f5c2
854	73	Credence.pdf	\N	0	\N	-1	bc6db9a6-06bb-432b-8cce-1f190564139a
855	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	6987531d-294a-4ff0-91f9-649731bd8494
3910	73	ann12.pdf	\N	0	\N	-1	f66aa4f7-fd31-462c-ada8-05e04fb83d38
3443	73	ann11.pdf	\N	0	\N	-1	578b73cc-e493-476c-adb1-eb48220cf22e
3444	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	6c492f47-d149-4d31-a9ec-7d9b639a7b8e
3911	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	c86891a6-fc5f-4c7c-a620-b72fd2f06531
2445	73	ann.pdf	\N	0	\N	-1	f3250f8e-5a48-41cf-afde-5e0fd29e38b1
2446	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	ba990800-568b-4c74-9986-243c61f79d8b
873	73	Credence9.pdf	\N	0	\N	-1	5bc0fbfc-0a4f-4207-879f-f75dd79ec933
874	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	7d4cfe6c-37fe-4ebf-886f-98296beca018
1460	73	ann12.pdf	\N	0	\N	-1	ce580e90-f41b-4840-a3e4-d0648b0ab5a7
1461	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	cbdafa5e-ce72-45e6-86fb-5a93edcedc33
2950	73	ann10.pdf	\N	0	\N	-1	1d28a233-a092-403f-be74-475b05d0b538
2951	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	755e21c7-1602-4c39-a5fa-5046dd7de73d
6789	73	ann9.pdf	\N	0	\N	-1	a51fcc77-8ca5-4bc0-aa4b-86b9703464ca
6790	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	9501ff63-812c-41bb-bab6-da2d57b27f1a
6001	73	ann13.pdf	\N	0	\N	-1	93ca862b-b651-442c-b6fe-fb11a0b13c7c
4662	73	ann9.pdf	\N	0	\N	-1	2e6da491-2416-4a99-a85a-cf497c1ab27a
7814	73	rav.zip	\N	0	\N	-1	9fadeecc-23a6-4746-9ec6-80f88db4a86e
7815	240	inputfile	\N	0	\N	-1	9fadeecc-23a6-4746-9ec6-80f88db4a86e
6002	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	c0d46ec4-2e3c-4d72-828f-0c326392d66e
5600	73	ann14.pdf	\N	0	\N	-1	59c54f47-70da-422a-b786-5c59b93bbafe
5601	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	fc4c0596-29c9-410f-9488-2a8dc7eacc1f
3463	73	ann12.pdf	\N	0	\N	-1	972c1540-90bc-457c-b6da-08590e3b2196
3464	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	617705c9-d415-4792-9e40-46aa57b2ca8e
3930	73	ann13.pdf	\N	0	\N	-1	97f2c0cb-fca6-4458-8ae0-71f4db932b64
3931	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	93001965-f3b6-44ec-b4a6-0d5d9204032f
892	73	Credence10.pdf	\N	0	\N	-1	602488ce-3c6b-4fbe-b921-00f448830e32
893	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	b91f4002-8b25-4b77-8387-417738e516c3
2970	73	ann11.pdf	\N	0	\N	-1	d9fb79c0-898e-4354-abd7-c5755b26bd5e
2971	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	a4f93140-0eca-4ba3-8f1b-b03ced84925b
1480	73	ann13.pdf	\N	0	\N	-1	22d5d3f6-cf09-413a-8fcd-d656f0992007
1481	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	1b8647de-8e04-468c-bd03-6f72c8cd9f14
2324	73	15-import.log	\N	0	\N	-1	53a1b46a-67e0-4105-97fc-67e4bb53f294
2325	240	script_output	\N	0	\N	-1	53a1b46a-67e0-4105-97fc-67e4bb53f294
3483	73	ann13.pdf	\N	0	\N	-1	3faa3045-c899-4762-b3d7-9d8739fbfc75
3484	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	d213476c-63ea-4871-a860-d0413c0f5037
6809	73	ann10.pdf	\N	0	\N	-1	f095b815-e75b-4e55-8b1f-eee1638a18aa
911	73	Credence11.pdf	\N	0	\N	-1	7266d530-89eb-42f4-b0a0-ffd80c693bd5
912	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	df1b5f2a-4337-4f48-9705-2643328c4cc1
3950	73	ann14.pdf	\N	0	\N	-1	24b73c6c-f534-47cb-96da-21c99bd7a0c6
3951	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	03a98ae0-f36a-4e21-86fc-ba30b958dcfd
5620	73	ann15.pdf	\N	0	\N	-1	66553ae7-14f9-444a-bb84-cb60bcea4ff9
5621	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	b3f58243-10c9-48b9-bd11-1704840ae26b
6021	73	ann14.pdf	\N	0	\N	-1	955e09e0-6fe8-4209-a85b-86650f8b1469
6022	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	02b692ca-36ba-4aa3-84d0-ac3b2acde399
1500	73	ann14.pdf	\N	0	\N	-1	f7898dbc-f40a-4e2b-b245-2c281f6bc1c8
1501	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	aad2253a-d28b-4740-b984-ba3b96093b83
6810	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	c4a3190c-4ac9-4e42-8ecc-428db8ee6f64
2990	73	ann12.pdf	\N	0	\N	-1	7439df16-626d-4f30-bd6c-03841806a3d0
2991	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	940def1e-38f3-45f3-8ddf-fb971fdbbeb0
6353	73	Credence10.pdf	\N	0	\N	-1	e3d7d763-c625-4c24-9cdf-4d89079b13ec
6354	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	579ff05c-b3a3-451b-bd98-d15a5e937ecc
4316	73	ann12.pdf	\N	0	\N	-1	f1fc8252-7480-421c-b91f-7855c2f0cdd4
4317	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	ae7896f4-2d94-43f6-a184-fba9a1070587
4663	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	074ad4c5-5f51-4921-a500-900633716986
1346	73	DMS_Brochure_Optimark_2025 (2).pdf	\N	0	\N	-1	ce4542c1-44bb-4c69-b001-37fc21846545
2429	73	Panda.zip	\N	0	\N	-1	42b2461a-88db-4e02-a98d-8458a466b76b
2430	240	inputfile	\N	0	\N	-1	42b2461a-88db-4e02-a98d-8458a466b76b
3503	73	ann14.pdf	\N	0	\N	-1	2e5fe6fb-d466-4e39-beb8-085f3009267b
3504	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	9a6eb543-a1bc-40e5-b6a7-f703cf7464be
930	73	Credence12.pdf	\N	0	\N	-1	2c97f2ed-5fbc-4b2f-a464-c9a310a7bb5c
931	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	82a928e2-e66b-44bd-bae0-d9995a2c9bba
3970	73	ann15.pdf	\N	0	\N	-1	581b9dd1-32b6-474f-a777-717c3dc0e639
3971	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	3ed45c32-2637-42c5-b616-1ec2cdf7cfcb
5640	73	ann16.pdf	\N	0	\N	-1	401fff2a-1dad-4f01-976f-421412d25e55
5641	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	19c1a6b8-191e-4746-a5b1-d1db7eb51a1c
6041	73	ann15.pdf	\N	0	\N	-1	2e5ffc83-b8a9-4fbe-94f1-60279bac8546
1520	73	ann15.pdf	\N	0	\N	-1	69ad5b1b-6a7d-4387-9956-46f985afc1bd
1521	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	d2e2dc54-1276-419e-895a-68deeae24ff2
3010	73	ann13.pdf	\N	0	\N	-1	dd57b1d5-b78c-4715-9b36-2bdf8a787178
3011	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	7f884d3a-e152-4458-aa89-e780f66f67c8
6042	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	431a07af-e4d1-4346-bb93-a716aadbbfdc
6829	73	ann11.pdf	\N	0	\N	-1	136c28ea-e267-45a9-ab88-659de1fd3fad
6830	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	ccde08b4-7101-45c5-98da-05c5290aaf50
949	73	Credence13.pdf	\N	0	\N	-1	37ded630-defb-4a86-b8e4-4cef64e64c7f
950	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	f9520aba-221e-4489-a377-7e7293efe6be
3523	73	ann15.pdf	\N	0	\N	-1	a9e5888f-7d35-470d-9467-2483347b0d5d
3524	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	70096eaa-ab76-45cf-89c7-b99a5812481b
1243	73	ShubhamKumarSinghResume.pdf	\N	0	\N	-1	d2f556a8-4051-41e3-8d5b-17d3a503ffdd
3990	73	ann16.pdf	\N	0	\N	-1	798cfff1-3c9d-4144-ada2-d478d6a1d2f2
1540	73	ann16.pdf	\N	0	\N	-1	fc0cdc51-b798-4260-89c6-21bcf5e90e43
1244	73	ShubhamKumarSinghResume.pdf	\N	0	\N	-1	47403eda-009f-45a0-8471-cea960116cf9
1245	73	ShubhamKumarSinghResume.pdf	\N	0	\N	-1	993120ec-3a2c-452a-9cbc-1d71ac62a857
1541	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	0abb40bd-56a9-40c4-939b-a3c0629a53c2
3991	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	725d945e-1b00-4a89-8eca-631800bcacf9
3030	73	ann14.pdf	\N	0	\N	-1	74832c9b-bf81-40b5-b1d2-5ac6cd59f694
3031	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	4305f503-8b1f-412c-973b-f756b5b8c8ed
5660	73	ann17.pdf	\N	0	\N	-1	71651dfd-393d-4843-aec4-4532a85bb06b
5661	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	d20258be-2c41-4474-bf4b-23340c78dc22
7831	73	38-import.log	\N	0	\N	-1	71f93610-2069-476d-9d56-53583fa637fd
7832	240	script_output	\N	0	\N	-1	71f93610-2069-476d-9d56-53583fa637fd
5048	73	ann.pdf	\N	0	\N	-1	28b33fc1-d78e-4e76-8be4-56cdd2604681
6372	73	Credence11.pdf	\N	0	\N	-1	0326ba01-b36b-4335-ba22-c368c402d1ab
6373	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	7a353843-eccf-4ddf-83c9-21bc99ee0a77
6061	73	ann16.pdf	\N	0	\N	-1	690ac130-4f66-4560-8352-5265946a862c
1581	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	22f28d7e-409b-4d08-a5c4-f066bd742da7
968	73	Credence14.pdf	\N	0	\N	-1	9071ed6b-50a2-4d60-9ffa-f956fc3edaed
969	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	66dc77ed-e46c-4199-9040-bc8cd7dfbd6c
6062	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	d26e1415-349b-4d02-bab9-2d8de4f45658
6849	73	ann12.pdf	\N	0	\N	-1	4b9fed14-4557-44e9-a269-557436fd67dc
6850	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	2ccd277f-3b3e-492d-b8cc-13e00c7f4f53
2465	73	ann9.pdf	\N	0	\N	-1	cb67f2cf-9167-4f7e-a903-d424080ee264
2466	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	d8f60672-3b32-465c-ae3c-f617597940b8
3543	73	ann16.pdf	\N	0	\N	-1	ba394fa0-e13f-4501-80ca-f6bae04f18ef
3544	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	946f5793-c741-4db2-87d3-bf77e2c3432e
987	73	Credence15.pdf	\N	0	\N	-1	ee7d5213-150c-45af-86e1-1dde5da6fa2f
988	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	48f648f6-9993-414e-9833-d5f305f3fa1a
1560	73	ann17.pdf	\N	0	\N	-1	4de34964-f939-410f-8266-177f5d95f559
1561	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	c3a6364f-7842-4d81-8ac4-9d3c4722befe
4010	73	ann17.pdf	\N	0	\N	-1	93afd952-aa8a-45fb-9782-74f0f0f826e4
3050	73	ann15.pdf	\N	0	\N	-1	8915b673-58c7-490e-9f1f-1783f3e96113
3051	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	599f87bf-f0cd-4480-9043-94b894e38515
4011	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	6bef3fe6-f0ea-4882-96a0-e89209ebeec8
5680	73	ann18.pdf	\N	0	\N	-1	25605338-8012-4e2c-a5a6-72d3ba777629
2485	73	ann10.pdf	\N	0	\N	-1	bb63eb78-91fb-4110-9446-3fc3f2322f23
2486	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	e613b74c-a8ec-4b47-a68a-c39b6f1a980e
5681	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	9c1b725c-e932-4366-96ff-a723778f6765
6081	73	ann17.pdf	\N	0	\N	-1	832d214b-56c2-42ed-b852-d6a2f6514eac
1006	73	Credence16.pdf	\N	0	\N	-1	91803a00-67f7-45d3-b768-58bbfad4b040
1007	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	284947be-468c-4b66-a3af-f7eeb775404d
6082	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	a5ac3c4c-9fc8-4197-a565-4c058be8a90f
1580	73	ann18.pdf	\N	0	\N	-1	41017356-8657-414a-a34b-658cdaff7d32
3563	73	ann17.pdf	\N	0	\N	-1	48cf9db6-bfd3-4e0d-a529-383678d7d054
3564	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	94ca31af-bd87-4b0d-8a2d-fd4f6cf74de1
1846	73	ann11.pdf	\N	0	\N	-1	0d354644-0ec3-4fb9-8adb-ec825370fd8d
1847	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	f95297fc-4084-4b60-827e-b8a476037ef9
6869	73	ann13.pdf	\N	0	\N	-1	f707d146-3253-4deb-ae59-ec792d8aadb3
6870	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	86a5a3ad-9a3b-409c-acd7-4e7bffd60d06
4336	73	ann13.pdf	\N	0	\N	-1	97c0e6b4-f3dd-4f0f-b25f-1ec357f841e8
4337	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	aa3ebb74-c0a8-4ba9-a676-0fb4ed213864
7674	73	Credence3.pdf	\N	0	\N	-1	1ee11a67-c5be-49e3-9fbb-1b57300d4fba
7675	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	16105dd0-806f-4920-b1ed-a48d5c189279
5049	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	17028385-3c80-4ffd-8b59-af83266effca
7833	73	rav.zip	\N	0	\N	-1	050e2056-3eb0-4067-8632-b0d290b2fc7f
7834	240	inputfile	\N	0	\N	-1	050e2056-3eb0-4067-8632-b0d290b2fc7f
4030	73	ann18.pdf	\N	0	\N	-1	ddee10e8-607d-4e76-9756-282448c0412f
3070	73	ann16.pdf	\N	0	\N	-1	30ea521a-5b8f-4bc0-89e8-7aaa63794a1d
3071	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	a98893b2-b0d5-4628-85eb-3982246bff6e
4031	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	7715bf66-77ed-4896-bd10-336569150627
2505	73	ann11.pdf	\N	0	\N	-1	a12cdf22-3b15-4193-bec8-f889305e6440
2506	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	aec93c34-08b5-4386-9765-8c76fe5961fd
5700	73	ann1.pdf	\N	0	\N	-1	7ab0e0f4-a473-4c6a-9ad6-b377d48a2ae0
1025	73	Credence17.pdf	\N	0	\N	-1	e3814d8a-92e7-4f1e-98bb-a2c3c98255bc
1026	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	15bdd673-bd8e-4b84-b360-286b197f98c1
5701	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	2420bf11-a8c1-4013-9264-88a7aa3c95c7
1600	73	ann1.pdf	\N	0	\N	-1	8e149e13-23af-49b9-8048-bbdfc3dbc125
1601	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	f3db3e45-ff66-4280-9084-75319a78a7bd
3583	73	ann18.pdf	\N	0	\N	-1	ea40b4f9-98f1-46a9-a580-782e5d21e629
3584	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	a5095e1e-0c6c-4a88-b94e-37cbef9dbbca
6101	73	ann18.pdf	\N	0	\N	-1	70c2ff19-13e1-467d-81fc-f8f8b5796815
6102	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	832ab46a-853a-41e2-bf9a-70410a36159a
3090	73	ann17.pdf	\N	0	\N	-1	1c90b189-de22-410c-9d8d-8d1cbd1f53a2
3091	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	a3826a71-232b-4111-b49a-79b630d20add
1044	73	Credence18.pdf	\N	0	\N	-1	acddc971-d4f9-4663-a5bd-bc8a20bc37a0
1045	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	a8929ffe-0324-4679-8d37-2e84beb4cddb
2525	73	ann12.pdf	\N	0	\N	-1	cbd4986a-8eee-470d-96aa-6add33867dce
2526	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	6eb05ea0-ea66-4000-8b3c-9e47bfb27f5f
4050	73	ann1.pdf	\N	0	\N	-1	66864f6a-b31b-43c4-8abe-851ed8a1f6fb
4051	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	3d0b713d-3a3a-4491-b3d1-3bba4634ba3c
6889	73	ann14.pdf	\N	0	\N	-1	f74fe15e-9531-4615-8890-12364744b727
1263	73	Abhishek kumar singh_page-0001.jpg	\N	0	\N	-1	3b4370e6-90dd-4ee1-a289-eeaa0a77c7da
1264	64	Abhishek kumar singh_page-0001.jpg	\N	0	\N	-1	3b4370e6-90dd-4ee1-a289-eeaa0a77c7da
6890	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	fd1c4b8e-c499-4c12-8606-0be3ed8492e6
1620	73	ann19.pdf	\N	0	\N	-1	31744827-8598-40e6-9dde-103b5bc80985
1621	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	96379ab6-5aec-4af6-b061-d426ed0c5fec
1270	73	license.txt	\N	0	\N	-1	8b701473-2893-4d03-8155-b1fcb8989141
1271	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	8b701473-2893-4d03-8155-b1fcb8989141
1272	77	2025-04-17T19:18:52Z	\N	0	\N	-1	8b701473-2893-4d03-8155-b1fcb8989141
7850	73	39-import.log	\N	0	\N	-1	7259b601-89f1-4a1f-8fc4-56926dc068b8
7851	240	script_output	\N	0	\N	-1	7259b601-89f1-4a1f-8fc4-56926dc068b8
5720	73	ann19.pdf	\N	0	\N	-1	39ffb9c7-1486-4610-878b-93a3c065e9a3
5721	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	ce3049f0-4449-4663-b1b8-d7c4ee471bd9
7852	73	rav.zip	\N	0	\N	-1	1e8ca0ca-52f1-47f5-9df2-d65b9670500c
2006	73	ann1.pdf	\N	0	\N	-1	d886e1d0-02f2-40f6-8635-a36d290bc787
2007	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	e0bbc989-713a-4d79-a4a2-5896068f9bdf
7853	240	inputfile	\N	0	\N	-1	1e8ca0ca-52f1-47f5-9df2-d65b9670500c
4356	73	ann14.pdf	\N	0	\N	-1	abf9251e-0028-496d-9203-6b635eccbb7d
4357	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	d1797c56-97e2-4b6c-8cb5-88f723fd426a
6391	73	Credence12.pdf	\N	0	\N	-1	bbf88ff8-71f9-4b90-b37e-c889bfbf3e15
6392	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	beeec6ad-0a47-4491-a756-71bb3fe35a4d
1660	73	ann3.pdf	\N	0	\N	-1	2ea21b92-edef-45cb-9365-4b65f0b4c972
3603	73	ann1.pdf	\N	0	\N	-1	0ad736fc-5ac6-4f94-a79c-b04b686a1fae
3604	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	a5bb816b-4512-42ee-8f7c-ec2ab45afb95
1063	73	Credence1.pdf	\N	0	\N	-1	862d725f-7c16-4657-910e-86ae34abc90e
1064	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	32a1f201-6cc0-4485-b9a7-4e74450c7d1b
6121	73	ann1.pdf	\N	0	\N	-1	948b694f-41e2-4b63-8f94-26c6ec1148a1
3110	73	ann18.pdf	\N	0	\N	-1	3dd4c076-66fb-4fb6-b0ca-349873c4279b
3111	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	8e949bbf-c38c-4923-8199-da187f587eef
6122	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	c9bc8ce6-50fa-47ff-86b4-a370a4618e84
2545	73	ann13.pdf	\N	0	\N	-1	4a9b01a9-8a85-48a7-bbc4-21d8c0ec9636
2546	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	d62a9eb4-a064-48ed-9d74-26541a46e7f8
4070	73	ann19.pdf	\N	0	\N	-1	3afd2234-af3b-45a6-a3cd-3eeb48c6b40b
1640	73	ann2.pdf	\N	0	\N	-1	645247b2-089c-4214-bd66-bfcafee9b952
1641	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	a34ad3ff-1fcc-4298-825e-80c9a1189d2a
4071	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	95e127e6-70a6-454a-b09a-75ccd8f6cabe
1082	73	Credence19.pdf	\N	0	\N	-1	ca1f7ea6-16c6-40ef-9ae6-8226e0824dd7
1083	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	ba63462e-820a-4a38-b80b-6be4f97d2e12
6909	73	ann15.pdf	\N	0	\N	-1	797f69e5-7e59-47db-a6a1-fc247e07a798
6910	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	762584ed-da5f-4245-8656-afef7e60fedd
3623	73	ann19.pdf	\N	0	\N	-1	775ee888-0a6a-4c12-ae26-f80be4c39700
3624	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	58ed75b7-d93c-4dea-ae7b-aa676e8aba55
3130	73	ann1.pdf	\N	0	\N	-1	3a1c1fdf-62bf-44ac-a333-5c5a852dc99f
3131	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	cf8847bc-21fa-4988-80aa-05da0eb96de5
5740	73	ann2.pdf	\N	0	\N	-1	3da477e3-3bd4-411d-b20e-591b2fcf0721
5741	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	2dd3d78b-6dc0-4e59-8734-4a4506e82503
1284	77	2025-04-17T19:22:57Z	\N	0	\N	-1	b946f119-cc9b-4268-9a20-914cbb1459d5
2565	73	ann14.pdf	\N	0	\N	-1	bbce4a1a-766d-4c7a-91cf-52018844276e
1661	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	ddfd79fb-b06b-42cf-921c-4d8699e0dd45
2566	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	4787776b-2a78-4109-8b63-f37eea5157c4
1101	73	Credence2.pdf	\N	0	\N	-1	986f2d6e-adb6-43d1-bb0c-87a4ab4ce613
1274	73	Invoice_2040208141.pdf	\N	0	\N	-1	89cbc5cc-55ca-4760-b787-5eda8cb8c422
1275	64	Invoice_2040208141.pdf	\N	0	\N	-1	89cbc5cc-55ca-4760-b787-5eda8cb8c422
6141	73	ann19.pdf	\N	0	\N	-1	6c8409dc-17fa-49a0-bc68-d2989b1064e0
4090	73	ann2.pdf	\N	0	\N	-1	1e9eb0c1-86e1-45e4-b5f3-154e64de1237
4091	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	24c55af1-e9fc-4c2a-bba4-46f29f9ffa68
6142	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	61befdce-d4ee-4ad1-a9bf-7c842001641b
1282	73	license.txt	\N	0	\N	-1	b946f119-cc9b-4268-9a20-914cbb1459d5
1283	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	b946f119-cc9b-4268-9a20-914cbb1459d5
4682	73	ann10.pdf	\N	0	\N	-1	8794fa1a-3b42-4064-8d54-49671f2aa6af
4683	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	86d1211d-52eb-458e-91cc-8b2eed6fc351
1102	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	9cd9241a-0c2e-41f6-a117-042e792784b1
6929	73	ann16.pdf	\N	0	\N	-1	4b2ee089-b546-43fd-9eee-621db0ef0f86
6930	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	8d4da577-bf45-4b52-bbd2-d5825795f2e0
3643	73	ann2.pdf	\N	0	\N	-1	3bf0422f-a88d-475f-8b82-e41fb2d49645
3644	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	6a64361d-703b-4b6e-9fca-728b9db967bd
3150	73	ann19.pdf	\N	0	\N	-1	824ea511-1866-4981-9c67-a225abd67b9d
3151	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	66db2f4b-52fb-4300-9634-364fe3c4eee9
1680	73	ann4.pdf	\N	0	\N	-1	1bd47e73-3f3b-4b9c-a459-9be1a58349a7
1681	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	dd30a8ba-3a2a-4154-ba4c-a5fceb5e56cb
1120	73	Credence3.pdf	\N	0	\N	-1	0ab5de0b-e06a-4dfc-8eda-d28f8fb5de39
1121	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	2f9154bc-65cd-44b6-9299-8802ac82c5e7
2585	73	ann15.pdf	\N	0	\N	-1	c0d78b5a-cab0-40b5-bbf5-b116cde4b170
2586	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	9a436b7e-1add-4301-bd3c-7d3b198d9b39
5760	73	ann3.pdf	\N	0	\N	-1	dd211663-7328-4ed6-8b2d-81e57783620c
5761	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	b3a4add8-e41a-4069-a61c-d0d7debf9940
4110	73	ann3.pdf	\N	0	\N	-1	2064cc71-7de3-4278-8fd1-66bce4053585
4111	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	286a2279-6b8f-4cc9-a02f-ecf711dca598
6161	73	ann2.pdf	\N	0	\N	-1	80956ab9-6fcc-47c7-b4b9-e6e6e74c2af5
6162	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	30e830b5-4a6c-4b66-8d94-fa53cc39c827
1139	73	Credence4.pdf	\N	0	\N	-1	039c3fa2-7b1d-4495-8749-2e1371342e40
1140	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	f97551d3-3859-44a0-9e65-2c394b9b54b6
3663	73	ann3.pdf	\N	0	\N	-1	5cf12e6e-3bda-4470-98bd-032506bc49ec
1700	73	ann5.pdf	\N	0	\N	-1	ea81121c-6488-49b6-a2e2-ca52c57b6b17
1701	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	6dfd8bff-bba4-41e7-b852-0a8cd0d56853
3664	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	854fafe5-67b8-4e7b-b6ba-aaf5a61404cc
1290	73	Abhishek kumar singh_page-0001.jpg	\N	0	\N	-1	eb452230-1790-4fa4-a35c-1821014c403d
3170	73	ann2.pdf	\N	0	\N	-1	6a383623-266d-4413-ae5f-e6aa9ca5294c
2605	73	ann16.pdf	\N	0	\N	-1	15a0d76b-518c-4fdc-907e-2fdc7ea2b5a6
2606	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	4b5e1986-a44e-4d68-9556-b5a17e917a97
3171	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	1ca7dc9e-2099-49d8-93eb-7698063ad1e0
6949	73	ann17.pdf	\N	0	\N	-1	6a40acc6-567c-4c69-b804-305097e67edc
6950	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	a622d0a8-c49d-4138-9577-28e8d49f5e27
5780	73	ann4.pdf	\N	0	\N	-1	5b6eea42-32f1-44fb-ace7-bf87e5558a27
5781	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	70f794da-073a-4e68-9855-ac3cc2c80816
6410	73	Credence13.pdf	\N	0	\N	-1	7f7c3c88-b517-405e-9238-6998163f9b8b
7869	73	40-import.log	\N	0	\N	-1	a657695d-ea87-4431-b5da-c5386bf488c5
6411	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	26227059-9eb5-4db1-8d62-d6b6eb25d61f
7870	240	script_output	\N	0	\N	-1	a657695d-ea87-4431-b5da-c5386bf488c5
4376	73	ann15.pdf	\N	0	\N	-1	af07dcd2-963f-477b-83f6-7d5539e060cf
4377	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	807be89d-3c22-46dc-8d42-edbeac43eec7
4130	73	ann4.pdf	\N	0	\N	-1	0f451b96-3fa6-4a83-b4dd-ece659065aaa
4131	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	925f9e60-9f66-40ba-880e-5fe6ebe910a6
6181	73	ann3.pdf	\N	0	\N	-1	70df4ada-b630-4acf-88c7-c06c02f7c5d4
6182	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	735e2e8c-b4a2-48bb-b431-708b299e3635
1158	73	Credence5.pdf	\N	0	\N	-1	19cb1f36-ed20-48ef-8297-0174867edb91
1159	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	f6c466e3-f8b8-4f28-8d7d-d1de8df0a5d7
1720	73	ann6.pdf	\N	0	\N	-1	b8a1904d-cbf1-45c7-b29b-c582db2aed47
1721	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	8bdd8b5a-484f-4fec-a451-7698f24a1483
3683	73	ann4.pdf	\N	0	\N	-1	4e278de2-2b03-4351-b067-44d8ceab32c5
2625	73	ann17.pdf	\N	0	\N	-1	1961d363-a764-4f34-9ece-61c0fd5e9d1b
2626	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	a2768559-f246-4a74-bd60-cb054d8a443c
3190	73	ann3.pdf	\N	0	\N	-1	902e9e9a-ca08-4b2c-9a19-cb2f86d30d03
3191	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	b0006623-ba88-4650-ad4e-18e9cc34ddb5
3684	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	1340521d-15eb-4d11-a849-ab9a11ea7bfe
5800	73	ann5.pdf	\N	0	\N	-1	f5a715b9-161a-43f3-845b-fb586c66e899
5801	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	31d47bd3-78aa-447b-b32b-2305501492c1
1177	73	Credence6.pdf	\N	0	\N	-1	f374620d-ef40-4ed6-9fcf-3f519848371c
1178	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	e9c9f7ac-6a60-4082-bc97-39fdc9e79c89
4150	73	ann5.pdf	\N	0	\N	-1	5b11fe17-90d3-4923-8b1c-5dad34738ff1
4151	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	5126a452-3c01-46ff-af8d-522d02028f58
6969	73	ann18.pdf	\N	0	\N	-1	f8860317-72bf-4bac-ae5c-f7984c32af9d
1740	73	ann7.pdf	\N	0	\N	-1	6ac11558-f863-4d39-9c0e-0f591c27a10a
1741	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	48847277-3341-4566-81bc-42f98a884468
6970	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	8fb16f11-546e-40e7-8b14-45297d266fda
2645	73	ann18.pdf	\N	0	\N	-1	cff717f3-cc93-493b-8b1b-b375972a80f1
2646	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	790c2cf1-453a-4fda-9dc8-d1c4d31af8a2
3210	73	ann4.pdf	\N	0	\N	-1	e45c2b0a-ae64-48a9-a8d6-d2bcec6cba5b
3211	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	55ec0de8-e695-47c9-a770-124b1cfa1595
3703	73	ann5.pdf	\N	0	\N	-1	121c00b6-0488-4e1d-a6ce-90efd05ada9f
3704	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	ac10cbdb-0b6a-47d1-8bf6-bc01f62ed954
6201	73	ann4.pdf	\N	0	\N	-1	e26e653c-d5c5-4c54-aef2-1d7b54ab41e1
6202	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	e1efdab3-4574-4849-9a19-31a650d8d25d
7871	73	rav.zip	\N	0	\N	-1	edd7938c-a7aa-4d8b-88e0-19c829cd284a
7872	240	inputfile	\N	0	\N	-1	edd7938c-a7aa-4d8b-88e0-19c829cd284a
1196	73	Credence7.pdf	\N	0	\N	-1	d4ea992f-7a65-49af-b90b-4cbe54e62784
1197	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	ba7ba332-4a7f-4409-be28-bf9504db6f44
5820	73	ann6.pdf	\N	0	\N	-1	5fd52188-ed21-4119-b0ba-82cd959c1115
5821	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	0b5ca965-1f39-43f0-a14e-63ab068455c1
4170	73	ann6.pdf	\N	0	\N	-1	9932e9b9-9240-4443-bde5-c78435f012b9
1760	73	ann8.pdf	\N	0	\N	-1	eeffd7e4-742b-48aa-a3bf-bde382bd35a6
1761	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	e9c754ec-90c2-48e9-a7eb-ac415fd0a2c7
4171	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	1c6d7d32-6720-4d00-8735-95cf036361e5
6989	73	ann1.pdf	\N	0	\N	-1	260ca43a-a55a-4e31-adf9-d61bc532e07a
6990	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	2d20f866-1481-425d-b0e3-ee9a2ef878cf
1766	73	mapfile	\N	0	\N	-1	bf936c92-b0f8-4e93-9ac8-931581d3f15f
1767	240	importSAFMapfile	\N	0	\N	-1	bf936c92-b0f8-4e93-9ac8-931581d3f15f
1768	73	10-import.log	\N	0	\N	-1	4fc00d69-fcd4-4ded-95b2-bc82d7da5f63
1769	240	script_output	\N	0	\N	-1	4fc00d69-fcd4-4ded-95b2-bc82d7da5f63
1215	73	Credence8.pdf	\N	0	\N	-1	e74a37f3-b989-4499-af6f-2162ee3dbea7
1216	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	21e75cac-2d4d-40b0-9888-f61cd53a4b6d
2665	73	ann1.pdf	\N	0	\N	-1	e70867bf-58ef-447d-8afa-b0267a4434f3
2666	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	317d9961-e788-46fa-89d2-4841e0ce4339
3230	73	ann5.pdf	\N	0	\N	-1	270ce077-ac37-448e-a941-bf8092306b31
1866	73	ann12.pdf	\N	0	\N	-1	4d85a1b1-0100-4c01-b1db-3fdf2ab2f6a8
1221	73	mapfile	\N	0	\N	-1	06492d28-6f48-462e-a981-39c9e5cfbe40
1222	240	importSAFMapfile	\N	0	\N	-1	06492d28-6f48-462e-a981-39c9e5cfbe40
1223	73	9-import.log	\N	0	\N	-1	3c58bf17-ace4-4ed0-8697-fb3097ac3360
1224	240	script_output	\N	0	\N	-1	3c58bf17-ace4-4ed0-8697-fb3097ac3360
1867	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	9ec79635-ebcc-4015-b48e-715b2bb17f2e
3231	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	748d9040-0051-4fb4-8c9c-d8c2f0b621ba
3723	73	ann6.pdf	\N	0	\N	-1	33f53947-29f3-4166-9394-589883366c44
3724	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	c7dd26b7-55d4-4bef-b0b9-1823885787ff
6221	73	ann5.pdf	\N	0	\N	-1	f6c28dd7-3f4f-444d-b74f-cb4ebaf04a38
6222	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	21bf492b-169c-4df7-b1c6-e72d0e775c8b
6429	73	Credence14.pdf	\N	0	\N	-1	668fce16-e7d5-44f0-bfbc-086892a8c715
4190	73	ann7.pdf	\N	0	\N	-1	4aa4e915-2555-42d7-a10c-47874e03773d
2685	73	ann19.pdf	\N	0	\N	-1	8201866d-18dd-4d5e-8d34-27d35c520cad
1886	73	ann13.pdf	\N	0	\N	-1	8ec8d495-0014-4740-a088-fa895e8af8ca
1887	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	39211907-e7a7-433e-b3e7-63ea6072974c
2686	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	9a15b0a1-ada6-4741-86ee-1015034fff05
4191	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	9665163c-4d2b-40f3-851d-b291b7832e70
5840	73	ann7.pdf	\N	0	\N	-1	fb4bc5da-f3a0-47c3-b030-ba251691a602
5841	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	f8cd187a-40bd-42ee-bbc0-a3d78a057063
4396	73	ann16.pdf	\N	0	\N	-1	d8b6b680-1d4c-4a23-94b3-e3be30bcbd2b
4397	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	5ed8269e-2c7f-4436-84e3-e17670893fb8
6430	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	8151579e-799a-404c-930f-3ed7fedc5061
7888	73	41-import.log	\N	0	\N	-1	27eab72d-1ae5-42af-9659-3c5393f92e26
7889	240	script_output	\N	0	\N	-1	27eab72d-1ae5-42af-9659-3c5393f92e26
3250	73	ann6.pdf	\N	0	\N	-1	5266a03d-f215-47e0-b511-fe38c8699df4
3251	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	403a7698-3805-4d67-9865-ccd57f73f17d
3743	73	ann7.pdf	\N	0	\N	-1	66ce3e95-b6e8-4747-8bd7-e8ccd4fee601
3744	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	63c8f333-b7de-4248-929c-d66f1bed4205
7009	73	ann19.pdf	\N	0	\N	-1	0ece619e-fea8-4ae8-8206-b07e73036b11
7010	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	84d492d9-ada6-425c-b727-3933e658e493
6241	73	ann6.pdf	\N	0	\N	-1	54d9d5e0-c9c8-487e-8c88-6c53d03bd3df
6242	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	36589b06-e6b5-43c5-a2e0-98500b16fcfe
1926	73	ann15.pdf	\N	0	\N	-1	ec0516e8-ece6-486c-9c59-f099e03d2256
1927	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	e8f4c747-f710-426c-ac1b-689ea557d0f0
2705	73	ann2.pdf	\N	0	\N	-1	7c11782b-e283-41c1-957a-4dfeaaad5546
2706	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	b7029c71-7698-40b0-970e-9ab6fe40716d
3270	73	ann7.pdf	\N	0	\N	-1	751813cc-de1a-4117-a6ba-f3e3c3ca1b64
3271	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	77adddb2-285a-4883-9257-2d795277d058
4210	73	ann8.pdf	\N	0	\N	-1	55efd320-ba92-4ff1-b684-6c7657ef3e5b
4211	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	ddcdaf51-783b-4c28-bafd-93e0824e83c2
3763	73	ann8.pdf	\N	0	\N	-1	edc8cb15-8d03-4cc2-9f85-1974a4d8e654
3764	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	172f5313-b4c3-4a37-8f4a-e33c18e6a619
5860	73	ann8.pdf	\N	0	\N	-1	6d4bef11-2a4e-4434-a1b2-08bd50a50993
5861	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	9c04fe17-ecea-4436-b6cf-c15c7386fd7f
4216	73	mapfile	\N	0	\N	-1	d8a32f78-2b75-4020-9b65-7d829f342242
3769	73	mapfile	\N	0	\N	-1	73c91a17-da38-4194-a03a-43dd8902879a
3770	240	importSAFMapfile	\N	0	\N	-1	73c91a17-da38-4194-a03a-43dd8902879a
3771	73	23-import.log	\N	0	\N	-1	e4f1eaf5-471c-4a1d-9dfe-78d16daef96e
1946	73	ann16.pdf	\N	0	\N	-1	19c06bd5-7e00-4b9d-bb63-a7d68eebb7b2
1947	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	7a064116-70e1-4699-9797-593c43d1afd2
3772	240	script_output	\N	0	\N	-1	e4f1eaf5-471c-4a1d-9dfe-78d16daef96e
4217	240	importSAFMapfile	\N	0	\N	-1	d8a32f78-2b75-4020-9b65-7d829f342242
2725	73	ann3.pdf	\N	0	\N	-1	1ac3ee27-d910-4321-aa8a-11eaaf335de7
2726	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	ac8cee04-6adc-4b1a-9602-c27099e14eee
4218	73	24-import.log	\N	0	\N	-1	35e5fe5a-dc1d-4c95-8e0d-7d0fd1a4be21
4219	240	script_output	\N	0	\N	-1	35e5fe5a-dc1d-4c95-8e0d-7d0fd1a4be21
3290	73	ann8.pdf	\N	0	\N	-1	9f3aafd7-04de-4286-b536-7e2906470f01
3291	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	61d5a3eb-2d3d-4695-9464-65076c32bdfd
5866	73	mapfile	\N	0	\N	-1	a8f82864-d4ac-4f05-9c75-891704699547
5867	240	importSAFMapfile	\N	0	\N	-1	a8f82864-d4ac-4f05-9c75-891704699547
5868	73	28-import.log	\N	0	\N	-1	3909dd25-4d13-4777-9972-0c5f55dac187
5869	240	script_output	\N	0	\N	-1	3909dd25-4d13-4777-9972-0c5f55dac187
7029	73	ann2.pdf	\N	0	\N	-1	7cf9a466-4cd9-40b8-a8b1-242f5e1f472b
7030	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	e7a486c6-9568-42ea-8787-50cf7e8d20d7
4416	73	ann17.pdf	\N	0	\N	-1	1ddaf4f5-030e-4493-a246-5d1f2596e780
4417	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	4c79696d-23c4-49ef-bdfb-959d590a9c6c
7890	73	rav.zip	\N	0	\N	-1	94a19d0f-f836-4b87-aace-08fa0adeb3b6
7891	240	inputfile	\N	0	\N	-1	94a19d0f-f836-4b87-aace-08fa0adeb3b6
6261	73	ann7.pdf	\N	0	\N	-1	ae108eb8-e0ab-496a-aa97-d2c1f51a5713
3296	73	mapfile	\N	0	\N	-1	bc37b708-d924-410e-8ede-cecf2588907e
3297	240	importSAFMapfile	\N	0	\N	-1	bc37b708-d924-410e-8ede-cecf2588907e
3298	73	21-import.log	\N	0	\N	-1	c0da6b8c-4ec6-47de-b494-46335e099b36
3299	240	script_output	\N	0	\N	-1	c0da6b8c-4ec6-47de-b494-46335e099b36
6262	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	5dc2f6a9-5c05-4faf-950a-0cfa608ca05e
1966	73	ann17.pdf	\N	0	\N	-1	6bed6545-d8db-402f-9dd4-8d21df467b9e
1967	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	6521cffb-0c27-4491-bd6a-ea4ed616b27b
2745	73	ann4.pdf	\N	0	\N	-1	c99f65b0-24b1-491c-a4ee-2ac02a6c31b6
2746	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	a26c5f13-f433-4143-9e00-873b20f8695d
4436	73	ann18.pdf	\N	0	\N	-1	c2baa239-08bf-4d90-bf5c-698ee81a5ee2
4437	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	953ef6aa-c5cd-4167-a23b-3beed5973129
7049	73	ann3.pdf	\N	0	\N	-1	f4b6e624-cce6-418d-8f9b-1cdc3087293c
7050	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	c1b34b63-427c-4fe6-9ee1-60d0f5cd557c
6281	73	ann8.pdf	\N	0	\N	-1	f6d14e81-168a-4eda-b1ec-e49f04170c91
6282	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	78a622b7-75a5-4fff-9494-f34e6b6c7206
1986	73	ann18.pdf	\N	0	\N	-1	5a068c21-5f02-4549-b1b2-aefcb7cf9eb7
1987	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	8e269ccc-c571-44c5-869d-4b83c554c526
2765	73	ann5.pdf	\N	0	\N	-1	53bd6771-9970-4a43-a34e-206da41b777b
2766	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	5e5cfff7-d46a-474e-bb0d-c247cf5fdd72
6287	73	mapfile	\N	0	\N	-1	bb2a754c-c566-4510-9f48-5e5018fddbc5
6288	240	importSAFMapfile	\N	0	\N	-1	bb2a754c-c566-4510-9f48-5e5018fddbc5
6289	73	29-import.log	\N	0	\N	-1	a8d1e084-4006-4c44-97c0-6c057796fb89
6290	240	script_output	\N	0	\N	-1	a8d1e084-4006-4c44-97c0-6c057796fb89
4456	73	ann1.pdf	\N	0	\N	-1	2bd926fa-672b-4447-b401-1991b7a38597
4457	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	164d4687-3c9a-4230-93f6-51c42ecfe77f
6448	73	Credence15.pdf	\N	0	\N	-1	5ac8c636-16ee-4e20-970c-6295a80a8015
4702	73	ann11.pdf	\N	0	\N	-1	c5c167e1-81a3-40c3-9a78-5c3ac0195cac
4703	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	9896432c-6e80-4610-ae46-938369c422d5
6449	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	0df40261-c6ad-468d-bd10-a957c2a0c1ff
7901	73	RAMDAS M. AVHAD.pdf	\N	0	\N	-1	7f4abd5b-41d3-46eb-bed9-d31b4486a597
7902	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	efbbc983-fb6a-4146-9cba-a825f3becd2d
7069	73	ann4.pdf	\N	0	\N	-1	48c30b1e-4d78-45f4-9d0a-0c94dae9b37f
6467	73	Credence16.pdf	\N	0	\N	-1	06b7b65c-af7a-4da7-9351-47d371792e13
6468	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	37477732-ebe9-44fc-ab84-d6112c468882
7070	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	11a2c0cb-d51d-448f-b34e-eb5bd66ecb9f
2785	73	ann6.pdf	\N	0	\N	-1	4696cb67-0e5f-44b3-a2e9-f96ec8d9daff
2786	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	90a742a2-cb2d-49da-878d-f885b4cf7289
2026	73	ann19.pdf	\N	0	\N	-1	b053e5b1-6f65-4d1c-8e42-e4ac8914d135
2027	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	220290f8-3af7-4b8a-8440-fffcd8c95718
4476	73	ann19.pdf	\N	0	\N	-1	04dc80f1-2416-43ed-81f3-27b6902cf3ee
4477	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	0c46654e-ada7-4643-a347-5a2004900eef
6486	73	Credence17.pdf	\N	0	\N	-1	03454abd-bbab-460f-a616-629e1424747d
6487	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	3bbbb0f9-ec17-4942-bd3c-a888cb7d4363
2046	73	ann2.pdf	\N	0	\N	-1	7c6ce2ab-85a3-4a11-8e60-8725c1d940e2
2047	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	0dfe516d-b1be-43dc-ae29-8dc60cf6c024
2805	73	ann7.pdf	\N	0	\N	-1	6c34aedd-20d7-46e4-8614-0a7f2185a567
2806	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	1adbfd1d-8d65-4c80-916c-1a62bddde614
7089	73	ann5.pdf	\N	0	\N	-1	e306ee66-741f-4252-84f3-4c23ca8561de
7090	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	abf86b5c-3d67-49b9-b89e-4a6976e15b5d
4496	73	ann2.pdf	\N	0	\N	-1	c5708068-8d34-4c90-acac-7b56905ae13d
4497	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	02a8491d-0960-4850-9890-7ad3e61675bb
4722	73	ann12.pdf	\N	0	\N	-1	28369640-9916-48fb-b53c-afd5b602def3
4723	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	65cb50ec-e02f-4fc3-b653-e3a351ab6f8b
7916	73	15_N.P PARAMESWARAN NAMBOOTHIRI ERNAKULAM.pdf	\N	0	\N	-1	ade67968-9f48-48a0-9cc9-b32aff32c8fc
5068	73	ann9.pdf	\N	0	\N	-1	fe32d393-af1b-46a4-ac17-b2feb48bdb42
2066	73	ann3.pdf	\N	0	\N	-1	2aa84589-6d70-4a92-a39a-94825647ce22
2067	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	0f984f42-e8e4-4ba9-80f3-a0c238e99706
6505	73	Credence18.pdf	\N	0	\N	-1	a2927947-ab1f-416d-9ba8-2ddc56f759ef
2825	73	ann8.pdf	\N	0	\N	-1	83899895-efaf-4da7-925b-d16ad20c367b
2826	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	6a9379f5-80c9-4c56-a33d-72a9068eec58
6506	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	f19a5b53-68bf-438b-8f09-f4e4c9f4aa03
2831	73	mapfile	\N	0	\N	-1	be61103b-4de4-4a9d-aa33-a37b79417b9f
2832	240	importSAFMapfile	\N	0	\N	-1	be61103b-4de4-4a9d-aa33-a37b79417b9f
2833	73	19-import.log	\N	0	\N	-1	339138ff-1b5d-4d1f-b72f-f4b81f634657
2834	240	script_output	\N	0	\N	-1	339138ff-1b5d-4d1f-b72f-f4b81f634657
7109	73	ann6.pdf	\N	0	\N	-1	9612d2aa-0209-41c6-a8c2-c44dced19b41
7110	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	083f5923-07d9-490c-a7d5-a1553f3c1fe5
4516	73	ann3.pdf	\N	0	\N	-1	b6a742d9-d791-4702-8a8d-037a6a2ab8f2
4517	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	272bb69a-b2fd-4d34-9b4c-d7152b7aeff7
2086	73	ann4.pdf	\N	0	\N	-1	e9a89dac-3598-428c-b2f2-bed507bb9932
2087	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	746aeb4f-bf1c-48af-b643-c7802460530f
7917	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	0152a07e-c9c8-4bb2-8fd5-73c20ba4d3f2
6524	73	Credence1.pdf	\N	0	\N	-1	dedd95f6-4bee-4b51-84f7-74e6c552a7a5
6525	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	789770ad-9f31-4f1b-8fcc-ca1cfd0fdc2b
4536	73	ann4.pdf	\N	0	\N	-1	40960c3a-f33d-4461-b67d-94bc8d6761a4
4537	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	d63365c8-9ee2-4fd7-aa46-fe94ca9371f2
7129	73	ann7.pdf	\N	0	\N	-1	a941fcd7-003c-470a-bc6a-aa8b4e9a5214
7130	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	cfd694f0-beb0-46c0-8f1f-766b0ab768d9
4742	73	ann13.pdf	\N	0	\N	-1	4fdf00cc-3a18-4b77-828b-448de32661f5
4743	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	2133a31d-afb4-41f8-b110-a16fb544096f
5069	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	21619c05-234a-4775-97c5-9b6ed4fd0f3f
2106	73	ann5.pdf	\N	0	\N	-1	fb722c52-4945-4a97-93aa-544a1463cc10
2107	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	55f880f3-96fb-47b2-bd67-acb0d44bee7d
6543	73	Credence19.pdf	\N	0	\N	-1	cb0a053a-abd0-4df0-b5db-a2cbb8b67f4f
6544	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	07769881-d9fd-4b60-a264-e977862853f0
4556	73	ann5.pdf	\N	0	\N	-1	3415c94e-c84e-4019-894e-9059ee2caeea
4557	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	8fc4a8d7-bbdf-4208-8c8b-8b94dd287c7b
2126	73	ann6.pdf	\N	0	\N	-1	a79a1110-d4e5-48a1-b188-b20a56be7f43
2127	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	ba5f382e-f920-4654-9b15-d2856dd407c3
7149	73	ann8.pdf	\N	0	\N	-1	f27379a9-0de7-4953-a292-d2428c8de11f
7150	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	6128043f-5b63-4ae5-849c-f4e0c8270799
7155	73	mapfile	\N	0	\N	-1	e7c058f5-2ce4-4b87-8fb3-d70e0b79909f
7156	240	importSAFMapfile	\N	0	\N	-1	e7c058f5-2ce4-4b87-8fb3-d70e0b79909f
7157	73	32-import.log	\N	0	\N	-1	2dbf2014-aa30-491e-bc65-4f029c04c2e2
7158	240	script_output	\N	0	\N	-1	2dbf2014-aa30-491e-bc65-4f029c04c2e2
6562	73	Credence2.pdf	\N	0	\N	-1	5d9c2c7c-4a6a-44bc-a8ee-e61499ab5c21
6563	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	c9815ab5-4e93-47d4-aeb0-95ee1743b05e
4576	73	ann6.pdf	\N	0	\N	-1	d3e563e1-5166-4bf7-ae05-6c9442f2770d
2146	73	ann7.pdf	\N	0	\N	-1	8c32763d-39e6-4883-9853-d54628cea3e2
2147	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	217da3b1-dc2a-4cc5-b65d-769695058501
4577	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	b9ccf895-a5b8-42b1-97c8-ee3782d2872f
7693	73	Credence4.pdf	\N	0	\N	-1	54d4b402-17e8-4901-b804-e46e8ee93f7d
7694	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	3246e7e8-4851-4e95-8d91-b907e18e2c2a
7931	73	16_VD S.P SARDESHMUKH PUNE.pdf	\N	0	\N	-1	ac467984-2d0c-4c2f-95e7-c14098a20c9e
7932	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	d1a87b50-c9ed-4ab2-85af-cfcc7c6042db
7937	73	mapfile	\N	0	\N	-1	849b24d4-fe7c-424f-b74e-5e03cc341275
7160	73	Shubham_Resume.pdf	\N	0	\N	-1	99a0c2d9-b0e3-4c8d-9aef-d1ea3468968f
7161	64	Shubham_Resume.pdf	\N	0	\N	-1	99a0c2d9-b0e3-4c8d-9aef-d1ea3468968f
7198	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	16cc85e9-aa14-4314-9bb8-ea3b27835e3a
7199	64	Thumbnail_TIT_01.jpg	\N	0	\N	-1	16cc85e9-aa14-4314-9bb8-ea3b27835e3a
6581	73	Credence3.pdf	\N	0	\N	-1	5037a9cd-26c0-4e38-abe1-815419894e41
6582	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	98f7e11f-4a81-4f75-b47c-1cc77b8bc319
7200	73	Shahubham's_Resume.pdf	\N	0	\N	-1	1bc1dabe-c142-40cc-82c8-c6cdb87c2d2b
7201	64	Shahubham's_Resume.pdf	\N	0	\N	-1	1bc1dabe-c142-40cc-82c8-c6cdb87c2d2b
7234	73	ann16.pdf	\N	0	\N	-1	64a70e24-4f1e-4afa-9935-9e61dc27658b
7235	64	ann16.pdf	\N	0	\N	-1	64a70e24-4f1e-4afa-9935-9e61dc27658b
4596	73	ann7.pdf	\N	0	\N	-1	d11e1c1a-8383-4490-8b8e-8e7ae4bdb695
4597	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	94707d18-7819-4c2e-854f-ac319bcd8f5b
2166	73	ann8.pdf	\N	0	\N	-1	df26b968-1e76-4bfe-b406-b7b4593934b7
2167	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	66088f72-ba20-42f4-8a02-0ad84e3870de
2172	73	mapfile	\N	0	\N	-1	77ecae42-7ae4-47cf-bd46-46ddbb69a862
2173	240	importSAFMapfile	\N	0	\N	-1	77ecae42-7ae4-47cf-bd46-46ddbb69a862
2174	73	11-import.log	\N	0	\N	-1	260fe481-1993-4195-9b6d-83977d7ce9d2
2175	240	script_output	\N	0	\N	-1	260fe481-1993-4195-9b6d-83977d7ce9d2
7242	73	license.txt	\N	0	\N	-1	bfbc4aa1-5c4f-40c7-a53d-a49726a21ea0
7243	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	bfbc4aa1-5c4f-40c7-a53d-a49726a21ea0
7244	77	2025-06-08T20:48:11Z	\N	0	\N	-1	bfbc4aa1-5c4f-40c7-a53d-a49726a21ea0
6600	73	Credence4.pdf	\N	0	\N	-1	ec6f5345-d5e2-4eab-8aac-0de64398f3e4
6601	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	b5cec853-d46c-4347-9821-7346e003a3fb
7938	240	importSAFMapfile	\N	0	\N	-1	849b24d4-fe7c-424f-b74e-5e03cc341275
7298	73	Shahubham's_Resume.pdf	\N	0	\N	-1	9de6c77a-bd54-438a-a594-542cb8bfeb14
7299	64	Shahubham's_Resume.pdf	\N	0	\N	-1	9de6c77a-bd54-438a-a594-542cb8bfeb14
4616	73	ann8.pdf	\N	0	\N	-1	3506cf42-35b7-4334-a689-69b52e11ba24
4617	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	b9203636-80bb-48ee-9a61-e03c54c77c78
4622	73	mapfile	\N	0	\N	-1	68bf4655-e163-4dba-bce5-95abee17ef5f
4623	240	importSAFMapfile	\N	0	\N	-1	68bf4655-e163-4dba-bce5-95abee17ef5f
4624	73	25-import.log	\N	0	\N	-1	1dfeffdc-06e2-41b1-a7f4-4e7be6425aa2
4625	240	script_output	\N	0	\N	-1	1dfeffdc-06e2-41b1-a7f4-4e7be6425aa2
4762	73	ann14.pdf	\N	0	\N	-1	b536a7bb-a624-4d8d-9efb-132886fed5eb
4763	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	ad79e6a8-faf8-4d81-9fd2-b17166fd716b
7712	73	Credence5.pdf	\N	0	\N	-1	798146ff-2d95-4ec2-a1ee-6937cb633149
7713	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	fd7f9029-730b-4b82-81b6-42f2da629f03
7939	73	42-import.log	\N	0	\N	-1	27ef9d33-1cc1-414f-8a4d-3da3e6cf1915
7940	240	script_output	\N	0	\N	-1	27ef9d33-1cc1-414f-8a4d-3da3e6cf1915
7168	73	Shahubham_Resume.pdf	\N	0	\N	-1	98be67b9-2284-48c5-9b36-3e40f2640741
7169	64	Shahubham_Resume.pdf	\N	0	\N	-1	98be67b9-2284-48c5-9b36-3e40f2640741
4782	73	ann15.pdf	\N	0	\N	-1	51290f10-8d57-4fd8-bd6f-63635d99e961
4783	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	c297d50a-40f5-477d-9c61-e94818ca0d17
6619	73	Credence5.pdf	\N	0	\N	-1	63f0007f-6a43-4eca-9bdb-deaa68ab9805
6620	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	062717c7-b4b0-4c4e-931c-d5aea432e364
7177	73	license.txt	\N	0	\N	-1	83fc647b-ca4b-49ce-8d4a-6803521c136a
7178	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	83fc647b-ca4b-49ce-8d4a-6803521c136a
7179	77	2025-05-25T07:36:33Z	\N	0	\N	-1	83fc647b-ca4b-49ce-8d4a-6803521c136a
7215	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	0dc4795b-e6e4-49fc-80b5-092be3795016
7216	64	Thumbnail_TIT_01.jpg	\N	0	\N	-1	0dc4795b-e6e4-49fc-80b5-092be3795016
4802	73	ann16.pdf	\N	0	\N	-1	558bd5ac-460f-4443-9b9a-65421a026cf4
4803	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	3b5c5489-f5ef-48dd-a00a-10b34f8490c5
7217	73	Shahubham's_Resume.pdf	\N	0	\N	-1	9c0c36bc-5986-44b6-9fa3-815e1c701927
7218	64	Shahubham's_Resume.pdf	\N	0	\N	-1	9c0c36bc-5986-44b6-9fa3-815e1c701927
6638	73	Credence6.pdf	\N	0	\N	-1	8a9703f3-02b9-4e0f-a37f-53b810a7dc8e
6639	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	829da235-86df-4b56-9c66-ce8b58180e61
7285	73	Shahubham's_Resume.pdf	\N	0	\N	-1	334c5590-fac7-4be3-a885-e0b060a54451
7225	73	license.txt	\N	0	\N	-1	acdbed73-7ed9-4f94-b844-6b41edf61cf8
7226	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	acdbed73-7ed9-4f94-b844-6b41edf61cf8
7227	77	2025-06-05T19:55:30Z	\N	0	\N	-1	acdbed73-7ed9-4f94-b844-6b41edf61cf8
7941	291	684e8a56-ba71-4b54-98eb-e227d331b2d2_9612d2aa-0209-41c6-a8c2-c44dced19b41_2025-06-20_1,5,7	\N	1	\N	-1	75c3ab94-832e-4d84-9b5c-10b046200c09
7251	73	ticket.pdf	\N	0	\N	-1	1058f8b2-81a0-4240-9e2d-380e4709be1a
7252	64	ticket.pdf	\N	0	\N	-1	1058f8b2-81a0-4240-9e2d-380e4709be1a
5088	73	ann10.pdf	\N	0	\N	-1	b5c4b423-4c44-4f94-b052-2847559e614f
5089	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	4a2d9bcf-1fcf-4673-8a7d-2e88499b7008
7946	2	EasySmartDocs	\N	0	\N	-1	75c3ab94-832e-4d84-9b5c-10b046200c09
7259	73	license.txt	\N	0	\N	-1	9d5b6b5d-ebb8-436f-a2a5-664137b3c574
7260	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	9d5b6b5d-ebb8-436f-a2a5-664137b3c574
7261	77	2025-06-08T20:51:28Z	\N	0	\N	-1	9d5b6b5d-ebb8-436f-a2a5-664137b3c574
7286	64	Shahubham's_Resume.pdf	\N	0	\N	-1	334c5590-fac7-4be3-a885-e0b060a54451
7306	73	Shahubham's_Resume.pdf	\N	0	\N	-1	606dae42-11ce-4648-857d-4d1ac691ad1c
7307	64	Shahubham's_Resume.pdf	\N	0	\N	-1	606dae42-11ce-4648-857d-4d1ac691ad1c
7314	73	license.txt	\N	0	\N	-1	7712dd68-d472-421f-afa2-0a723cb7bcbd
7315	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	7712dd68-d472-421f-afa2-0a723cb7bcbd
7316	77	2025-06-08T20:57:54Z	\N	0	\N	-1	7712dd68-d472-421f-afa2-0a723cb7bcbd
4822	73	ann17.pdf	\N	0	\N	-1	a44e707d-0581-4aa5-a395-aeaedd263a36
4823	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	2754079c-f239-4bb1-9cd1-49b621ec908a
7186	73	Shubham_Resume.pdf	\N	0	\N	-1	8929239b-2c42-4621-b794-0d30bcb86804
7187	64	Shubham_Resume.pdf	\N	0	\N	-1	8929239b-2c42-4621-b794-0d30bcb86804
6657	73	Credence7.pdf	\N	0	\N	-1	77c87321-9eae-459d-a9b1-787b0ac55695
6658	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	a0f861f7-558e-451b-9f08-311417d631a1
7268	73	Shahubham's_Resume.pdf	\N	0	\N	-1	30c7f6cd-cd70-474b-a771-ba591a8eedfc
7269	64	Shahubham's_Resume.pdf	\N	0	\N	-1	30c7f6cd-cd70-474b-a771-ba591a8eedfc
7276	73	license.txt	\N	0	\N	-1	3e605773-48a6-48f5-834a-de4fd0f8a665
7277	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	3e605773-48a6-48f5-834a-de4fd0f8a665
7278	77	2025-06-08T20:52:38Z	\N	0	\N	-1	3e605773-48a6-48f5-834a-de4fd0f8a665
4842	73	ann18.pdf	\N	0	\N	-1	2e84d08d-42c2-4c74-bb09-af495be7a69f
4843	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	b3e32231-4638-46e9-a47e-970ab57aa92d
7323	73	Shahubham's_Resume.pdf	\N	0	\N	-1	51de9ec2-5e5b-40f2-88bb-e96b0eeacbd8
7324	64	Shahubham's_Resume.pdf	\N	0	\N	-1	51de9ec2-5e5b-40f2-88bb-e96b0eeacbd8
6676	73	Credence8.pdf	\N	0	\N	-1	b5bc28d6-33ce-4375-ae49-25ef1f8f585a
6677	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	f09412c6-7100-4645-9976-9870f9bda0af
6682	73	mapfile	\N	0	\N	-1	85faaeff-8112-4887-9b42-1ad7eb2a93eb
6683	240	importSAFMapfile	\N	0	\N	-1	85faaeff-8112-4887-9b42-1ad7eb2a93eb
6684	73	30-import.log	\N	0	\N	-1	0c1dd08d-1d3a-4158-abbc-935013772a8e
6685	240	script_output	\N	0	\N	-1	0c1dd08d-1d3a-4158-abbc-935013772a8e
7331	73	license.txt	\N	0	\N	-1	231bd961-8e68-46be-9257-b468cc2e6056
7332	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	231bd961-8e68-46be-9257-b468cc2e6056
7333	77	2025-06-08T21:01:43Z	\N	0	\N	-1	231bd961-8e68-46be-9257-b468cc2e6056
4862	73	ann1.pdf	\N	0	\N	-1	d86d3ab7-9ed9-4a49-a120-26d5a268a1a6
4863	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	e99ace79-12f7-4ca5-b2e7-acf2a4b4f3ad
5108	73	ann11.pdf	\N	0	\N	-1	6371239e-2dcf-40fb-b630-2459ca5f569f
5109	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	b2fde49c-0193-4a08-87ea-9091f100077c
7731	73	Credence6.pdf	\N	0	\N	-1	512af019-3dd9-47b4-b28b-5d677aa1b22b
7732	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	c1f71397-0faf-4f59-8b6a-3a698770fd68
7942	291	85a2ae5d-cbe1-490f-99c6-a258a0dbd9a0_ade67968-9f48-48a0-9cc9-b32aff32c8fc_2025-06-20_3,6,8	\N	0	\N	-1	75c3ab94-832e-4d84-9b5c-10b046200c09
7340	73	Shahubham's_Resume.pdf	\N	0	\N	-1	005555c3-b10b-46b3-aa86-5ed4a2f08d45
7341	64	Shahubham's_Resume.pdf	\N	0	\N	-1	005555c3-b10b-46b3-aa86-5ed4a2f08d45
7348	73	license.txt	\N	0	\N	-1	bdbd096d-b4ce-4930-8d61-fd4c0d951648
7349	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	bdbd096d-b4ce-4930-8d61-fd4c0d951648
7350	77	2025-06-08T21:07:12Z	\N	0	\N	-1	bdbd096d-b4ce-4930-8d61-fd4c0d951648
4882	73	ann19.pdf	\N	0	\N	-1	eaf4c41a-c8e0-466c-a1bf-0a6f0fefdc58
4883	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	9b656b9a-4613-4eab-bb13-8a8832348815
7750	73	Credence7.pdf	\N	0	\N	-1	02305490-a724-445b-837f-271a51d14b30
7751	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	dd781f83-90da-4bc9-b775-c9f68d6ac134
4902	73	ann2.pdf	\N	0	\N	-1	4f026a84-2a2d-4127-950f-454738edf405
4903	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	c89df378-d7fb-4ead-b304-36cd19e249be
7769	73	Credence8.pdf	\N	0	\N	-1	622a88d8-f569-42e3-9a32-93b6979b644e
7770	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	e06bccd1-3970-4bab-bd50-309ce99298bb
7775	73	mapfile	\N	0	\N	-1	6a418b3c-839b-4fc7-b4e4-a5b19a203e04
7776	240	importSAFMapfile	\N	0	\N	-1	6a418b3c-839b-4fc7-b4e4-a5b19a203e04
7777	73	33-import.log	\N	0	\N	-1	b6282c67-d08c-4b9c-8d3b-18f45e97013d
7778	240	script_output	\N	0	\N	-1	b6282c67-d08c-4b9c-8d3b-18f45e97013d
5128	73	ann12.pdf	\N	0	\N	-1	5fbcc128-a675-4438-9140-b6aab16159dd
5129	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	eb30d2f4-991e-4a9f-bdc0-8d3e322306ed
7357	73	Shahubham's_Resume.pdf	\N	0	\N	-1	47564b19-6fc8-4189-be1d-9b385bd60387
7358	64	Shahubham's_Resume.pdf	\N	0	\N	-1	47564b19-6fc8-4189-be1d-9b385bd60387
4922	73	ann3.pdf	\N	0	\N	-1	d6e1e341-68cc-443a-a1f8-34f483ca059a
4923	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	9f9d43a6-6930-4a1e-8280-58c935d3220d
7365	73	license.txt	\N	0	\N	-1	a7bc399a-5542-428f-8687-f9f462592d12
7366	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	a7bc399a-5542-428f-8687-f9f462592d12
7367	77	2025-06-09T11:17:41Z	\N	0	\N	-1	a7bc399a-5542-428f-8687-f9f462592d12
4942	73	ann4.pdf	\N	0	\N	-1	d88d94fc-573d-4bb6-b719-31eef7fa21a4
4943	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	1401c408-a4ae-485c-b94f-542224fc43c5
5148	73	ann13.pdf	\N	0	\N	-1	88472f44-fde6-4687-ae8a-6e55c7ca063c
5149	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	79f93cd5-e77f-4e1d-afb5-bd1a737652a6
7374	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	d5dd99e0-fe2e-44d4-b166-d0731b4e7d5d
7375	64	Thumbnail_TIT_01.jpg	\N	0	\N	-1	d5dd99e0-fe2e-44d4-b166-d0731b4e7d5d
4962	73	ann5.pdf	\N	0	\N	-1	9337cf8e-1249-4500-960a-2477a3f1b62b
4963	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	6e694892-cbdb-4da2-a837-2fb3b60034e2
7376	73	Z-28015-5-2007-NI.pdf	\N	0	\N	-1	d9152df1-b642-4b9d-b442-d4e68ba906b4
7377	64	Z-28015-5-2007-NI.pdf	\N	0	\N	-1	d9152df1-b642-4b9d-b442-d4e68ba906b4
7384	73	license.txt	\N	0	\N	-1	296e301d-2985-450e-b70a-f1ba7026500b
7385	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	296e301d-2985-450e-b70a-f1ba7026500b
7386	77	2025-06-09T11:40:15Z	\N	0	\N	-1	296e301d-2985-450e-b70a-f1ba7026500b
4982	73	ann6.pdf	\N	0	\N	-1	b02d9b7c-286c-4474-9825-ed73654482c0
4983	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	13efa4f6-c0e2-4d7a-b487-f3061efecf2a
5002	73	ann7.pdf	\N	0	\N	-1	88597d60-341d-497f-881d-5b21f975696a
5003	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	08f4c844-e18e-415f-ab0a-15073d4f9e1d
7392	291	d9152df1-b642-4b9d-b442-d4e68ba906b4_2025-06-11_1,2,3	\N	2	\N	-1	75c3ab94-832e-4d84-9b5c-10b046200c09
5022	73	ann8.pdf	\N	0	\N	-1	1312441d-446e-4a9d-90ff-251674caae2d
5023	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	ce215474-f67f-466a-b763-528c26d1db76
5028	73	mapfile	\N	0	\N	-1	46769403-937c-4267-aded-006c27fc19a8
5029	240	importSAFMapfile	\N	0	\N	-1	46769403-937c-4267-aded-006c27fc19a8
5030	73	26-import.log	\N	0	\N	-1	0e9afc9a-ce26-459d-88f5-74c96e5a7796
5031	240	script_output	\N	0	\N	-1	0e9afc9a-ce26-459d-88f5-74c96e5a7796
5168	73	ann14.pdf	\N	0	\N	-1	97b38cc2-d549-4a62-9dc5-ac5981dc5441
5169	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	d7c189d7-914f-4894-9676-12e4ac88b083
5188	73	ann15.pdf	\N	0	\N	-1	d3e09a07-4144-4a42-9372-34797fa2d322
5189	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	2ceb9a7a-dea2-45cd-9adc-efaab51fb99f
7393	73	dev.zip	\N	0	\N	-1	a3d94c88-cd80-4474-9c09-9b7c0f96000d
7394	240	inputfile	\N	0	\N	-1	a3d94c88-cd80-4474-9c09-9b7c0f96000d
5208	73	ann16.pdf	\N	0	\N	-1	4606e7db-13ca-495c-a731-c102fde7807f
5209	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	9bcb5e8c-04b2-480d-851d-70becd5133e4
5228	73	ann17.pdf	\N	0	\N	-1	892c82bd-b0e5-4525-bd28-d2d0cd4bf0fe
5229	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	ef107604-ea81-4be2-822b-b1d1b55dc8a1
5248	73	ann18.pdf	\N	0	\N	-1	b3147518-aa06-4922-b4a6-bb37795ef666
5249	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	f518920d-bfff-45a6-a46f-2c78bfd468f0
7408	73	Credence.pdf	\N	0	\N	-1	b58e5a82-5491-4651-8ab0-c9ded00592f0
7409	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	93481a0d-e8e3-41f2-8592-f2a548432e43
5268	73	ann1.pdf	\N	0	\N	-1	c9e28329-b399-4f91-a5be-91019d9c7156
5269	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	dd246496-bc36-4c0e-a793-86175c3cbfd6
7427	73	Credence9.pdf	\N	0	\N	-1	a5523989-af5b-4ae9-bba3-8f6f91cbf5ae
7428	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	17424e41-7d15-4631-89cd-f3c955911e79
5288	73	ann19.pdf	\N	0	\N	-1	96935de8-df24-4a55-9892-3e45bb15cf0a
5289	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	c99822af-8411-4077-a8a1-4ec275961ffb
7446	73	Credence10.pdf	\N	0	\N	-1	4a3e2b8e-70ed-48ad-9193-b2f1174b9932
7447	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	8494484d-6cd9-41b3-bcad-eece9cf18b13
5308	73	ann2.pdf	\N	0	\N	-1	df1d7905-edad-4905-92c8-b7765e5dc44a
5309	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	5498b778-064e-4f58-9535-581cd9d65b1a
7465	73	Credence11.pdf	\N	0	\N	-1	5628b26b-f6c5-4986-96b9-4f8102238700
7466	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	1864e625-ec7a-4449-a2dc-50c3b9593f81
5328	73	ann3.pdf	\N	0	\N	-1	2319e588-bb37-4159-9f3a-86bd9ea03125
5329	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	0f5cc091-9c15-4e2f-92c4-8088f3e83ab1
7484	73	Credence12.pdf	\N	0	\N	-1	b3cbbb84-0fad-40b6-9e65-7be5eed8b1aa
7485	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	84ac0db8-d480-4d08-abbe-bd667337e5d9
5348	73	ann4.pdf	\N	0	\N	-1	d3400e69-c271-4cbf-8178-f8a91bb3b715
5349	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	9e796582-8629-4e90-84f8-ced978e2670c
7503	73	Credence13.pdf	\N	0	\N	-1	0050395f-524b-4aa3-81d8-ccf668cdb6f5
7504	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	9e6da3f7-5785-4828-8fd8-b283b7be4fd4
5368	73	ann5.pdf	\N	0	\N	-1	d57e9191-6a4a-4c19-af71-305e17910222
5369	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	190ddc62-718c-4067-9985-295c454453f1
7522	73	Credence14.pdf	\N	0	\N	-1	7f78e932-3381-4875-8610-8afcb146e5c5
7523	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	77cf5e35-e1e9-4120-b069-fee8d0d1b803
5388	73	ann6.pdf	\N	0	\N	-1	3ffbd55c-a192-4418-8d01-a05a9e4fd47c
5389	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	a792f69e-0d93-4bc1-8e67-10a65564200c
7541	73	Credence15.pdf	\N	0	\N	-1	bfa9793e-40cc-4c04-a763-a954b639ce34
7542	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	d790964c-aea9-4e7f-991e-4916b37135c0
5408	73	ann7.pdf	\N	0	\N	-1	102bde5e-6611-4466-8e83-6dddf117cdf1
5409	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	abae02dc-52da-48ab-82c4-51cd3af9131e
7560	73	Credence16.pdf	\N	0	\N	-1	96bb0667-9322-4b3a-96aa-fc825ffc39be
7561	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	6786bee2-c0ed-4e1b-a6ec-4e2e4e904312
5428	73	ann8.pdf	\N	0	\N	-1	ecb35dfd-f93d-4aa2-a6ec-e8944e5da20b
5429	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	20944134-a900-4791-8b5f-5236d78db692
5434	73	mapfile	\N	0	\N	-1	ad00438d-cda1-425a-998f-b1986a6a5b23
5435	240	importSAFMapfile	\N	0	\N	-1	ad00438d-cda1-425a-998f-b1986a6a5b23
5436	73	27-import.log	\N	0	\N	-1	f71db8ba-9806-42ab-9eef-fdeb1ac0cd1b
5437	240	script_output	\N	0	\N	-1	f71db8ba-9806-42ab-9eef-fdeb1ac0cd1b
5439	73	bh-series-number-plate.jpg	\N	0	\N	-1	5f954a91-01b2-4994-9aea-5247f41bba19
5440	64	bh-series-number-plate.jpg	\N	0	\N	-1	5f954a91-01b2-4994-9aea-5247f41bba19
7579	73	Credence17.pdf	\N	0	\N	-1	67631fae-5814-42c7-9970-427020293dd7
7580	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	fbf41327-2c15-4ad7-8ea0-d97c79e82d30
5447	73	license.txt	\N	0	\N	-1	f544b825-5280-462b-bfef-962585f0cde9
5448	64	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	f544b825-5280-462b-bfef-962585f0cde9
5449	77	2025-05-10T10:53:28Z	\N	0	\N	-1	f544b825-5280-462b-bfef-962585f0cde9
7598	73	Credence18.pdf	\N	0	\N	-1	051c5124-c9d4-4202-b402-d9466f18b6e0
7599	73	Thumbnail_TIT_01.jpg	\N	0	\N	-1	4e3e4112-ca7b-4a72-b7e4-ddf6a19c0c95
\.


--
-- Data for Name: most_recent_checksum; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.most_recent_checksum (to_be_processed, expected_checksum, current_checksum, last_process_start_date, last_process_end_date, checksum_algorithm, matched_prev_checksum, result, bitstream_id) FROM stdin;
\.


--
-- Data for Name: notifypatterns_to_trigger; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.notifypatterns_to_trigger (id, item_id, service_id, pattern) FROM stdin;
\.


--
-- Data for Name: notifyservice; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.notifyservice (id, name, description, url, ldn_url, enabled, score, lower_ip, upper_ip) FROM stdin;
\.


--
-- Data for Name: notifyservice_inbound_pattern; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.notifyservice_inbound_pattern (id, service_id, pattern, constraint_name, automatic) FROM stdin;
\.


--
-- Data for Name: openurltracker; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.openurltracker (tracker_id, tracker_url, uploaddate) FROM stdin;
\.


--
-- Data for Name: orcid_history; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.orcid_history (id, owner_id, entity_id, put_code, timestamp_last_attempt, response_message, status, metadata, operation, record_type, description) FROM stdin;
\.


--
-- Data for Name: orcid_queue; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.orcid_queue (id, owner_id, entity_id, attempts, put_code, record_type, description, operation, metadata) FROM stdin;
\.


--
-- Data for Name: orcid_token; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.orcid_token (id, eperson_id, profile_item_id, access_token) FROM stdin;
\.


--
-- Data for Name: process; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.process (process_id, user_id, start_time, finished_time, creation_time, script, status, parameters) FROM stdin;
23	75c3ab94-832e-4d84-9b5c-10b046200c09	2025-05-09 13:26:08.394	2025-05-09 13:26:15.635	2025-05-09 13:26:08.305	import	COMPLETED	--add|||--zip Panda.zip|||--collection f05b7263-764d-44a4-bbef-e0014e915cd6
1	\N	2024-07-18 01:51:25.441	2024-07-18 01:51:25.636	2024-07-18 01:51:25.362	metadata-export	COMPLETED	-i fafcd21c-9b96-4236-af07-4e55b08e699e|||-a
2	75c3ab94-832e-4d84-9b5c-10b046200c09	2025-03-16 19:43:26.734	2025-03-16 19:43:35.484	2025-03-16 19:43:26.136	import	COMPLETED	--add|||--zip ANNUAL.zip|||--collection 0131c95e-f0f8-4d03-b253-258e1d24c51f|||-v true
24	75c3ab94-832e-4d84-9b5c-10b046200c09	2025-05-10 16:02:42.9	2025-05-10 16:02:51.581	2025-05-10 16:02:42.811	import	COMPLETED	--add|||--zip Panda.zip|||--collection b863f812-7550-4e9a-8689-46a1d87d107d
3	75c3ab94-832e-4d84-9b5c-10b046200c09	2025-03-16 19:50:12.32	2025-03-16 19:50:15.698	2025-03-16 19:50:12.214	import	COMPLETED	--add|||--zip ANNUAL.zip|||--collection fafcd21c-9b96-4236-af07-4e55b08e699e|||-v true
25	75c3ab94-832e-4d84-9b5c-10b046200c09	2025-05-10 16:12:09.094	2025-05-10 16:12:16.81	2025-05-10 16:12:08.995	import	COMPLETED	--add|||--zip Panda.zip|||--collection b863f812-7550-4e9a-8689-46a1d87d107d
4	75c3ab94-832e-4d84-9b5c-10b046200c09	2025-03-16 19:54:42.006	2025-03-16 19:54:45.85	2025-03-16 19:54:41.921	import	COMPLETED	--add|||--zip ANNUAL.zip|||--collection 435ad20a-a79c-461a-9a00-99274a84b006|||-v true
26	75c3ab94-832e-4d84-9b5c-10b046200c09	2025-05-10 16:13:45.598	2025-05-10 16:13:53.569	2025-05-10 16:13:45.529	import	COMPLETED	--add|||--zip Panda.zip|||--collection b863f812-7550-4e9a-8689-46a1d87d107d
5	75c3ab94-832e-4d84-9b5c-10b046200c09	2025-03-31 01:10:51.069	2025-03-31 01:10:57.026	2025-03-31 01:10:50.824	import	COMPLETED	--add|||--zip ANNUAL.zip|||--collection fafcd21c-9b96-4236-af07-4e55b08e699e|||-v true
6	75c3ab94-832e-4d84-9b5c-10b046200c09	2025-03-31 01:14:47.887	2025-03-31 01:14:50.556	2025-03-31 01:14:47.806	import	COMPLETED	--add|||--zip ANNUAL.zip|||--collection 435ad20a-a79c-461a-9a00-99274a84b006|||-v true
27	75c3ab94-832e-4d84-9b5c-10b046200c09	2025-05-10 16:20:32.619	2025-05-10 16:20:39.938	2025-05-10 16:20:32.531	import	COMPLETED	--add|||--zip Panda.zip|||--collection b863f812-7550-4e9a-8689-46a1d87d107d
7	75c3ab94-832e-4d84-9b5c-10b046200c09	2025-03-31 01:25:38.983	2025-03-31 01:25:46.305	2025-03-31 01:25:37.957	import	COMPLETED	--add|||--zip dev.zip|||--collection 0131c95e-f0f8-4d03-b253-258e1d24c51f|||-v true
28	75c3ab94-832e-4d84-9b5c-10b046200c09	2025-05-10 16:26:32.303	2025-05-10 16:26:39.493	2025-05-10 16:26:32.205	import	COMPLETED	--add|||--zip Panda.zip|||--collection 45a3bdc6-981c-4844-9f42-911098a58546
8	75c3ab94-832e-4d84-9b5c-10b046200c09	2025-03-31 01:31:16.301	2025-03-31 01:31:20.625	2025-03-31 01:31:15.529	import	COMPLETED	--add|||--zip dev.zip|||--collection 435ad20a-a79c-461a-9a00-99274a84b006|||-v true
29	75c3ab94-832e-4d84-9b5c-10b046200c09	2025-05-11 23:39:47.697	2025-05-11 23:39:58.925	2025-05-11 23:39:47.506	import	COMPLETED	--add|||--zip Panda.zip|||--collection eebb9376-e36f-44e1-8db5-c225c17371bb
9	75c3ab94-832e-4d84-9b5c-10b046200c09	2025-03-31 01:38:21.872	2025-03-31 01:38:31.863	2025-03-31 01:38:21.231	import	COMPLETED	--add|||--zip dev.zip|||--collection 435ad20a-a79c-461a-9a00-99274a84b006
10	75c3ab94-832e-4d84-9b5c-10b046200c09	2025-04-25 01:25:07.403	2025-04-25 01:25:22.177	2025-04-25 01:25:07.014	import	COMPLETED	--add|||--zip Panda.zip|||--collection 665518a4-c5df-4107-84fc-208eaf056dd6
11	75c3ab94-832e-4d84-9b5c-10b046200c09	2025-04-25 01:44:35.584	2025-04-25 01:44:43.285	2025-04-25 01:44:35.48	import	COMPLETED	--add|||--zip Panda.zip|||--collection 5d00d6e0-8abc-400f-bf70-c225c6b0b95f
31	75c3ab94-832e-4d84-9b5c-10b046200c09	2025-05-24 23:45:54.044	2025-05-24 23:46:00.316	2025-05-24 23:45:53.734	import	FAILED	--add|||--zip Panda.zip|||--collection 0bc1fe8f-8569-4e6e-89b0-9772929606bc
12	75c3ab94-832e-4d84-9b5c-10b046200c09	2025-05-06 16:09:38.348	2025-05-06 16:09:45.276	2025-05-06 16:09:37.631	import	FAILED	--add|||--zip dev.zip|||--collection 03e29b50-2b7d-4dff-abe9-a0c5aec2bf11
13	75c3ab94-832e-4d84-9b5c-10b046200c09	2025-05-06 16:11:26.611	2025-05-06 16:11:29.189	2025-05-06 16:11:26.393	import	FAILED	--add|||--zip hr.zip|||--collection 03e29b50-2b7d-4dff-abe9-a0c5aec2bf11
14	75c3ab94-832e-4d84-9b5c-10b046200c09	2025-05-06 16:15:13.12	2025-05-06 16:15:15.353	2025-05-06 16:15:12.954	import	FAILED	--add|||--zip hr.zip|||--collection 03e29b50-2b7d-4dff-abe9-a0c5aec2bf11
15	75c3ab94-832e-4d84-9b5c-10b046200c09	2025-05-06 19:28:24.747	2025-05-06 19:28:30.505	2025-05-06 19:28:24.289	import	FAILED	--add|||--zip hr.zip|||--collection 25071bb2-6648-47f8-a8dd-935d9e159d53
34	75c3ab94-832e-4d84-9b5c-10b046200c09	2025-06-13 02:34:22.632	2025-06-13 02:34:29.03	2025-06-13 02:34:20.892	import	FAILED	--add|||--zip rav.zip|||--collection 0bc1fe8f-8569-4e6e-89b0-9772929606bc
16	75c3ab94-832e-4d84-9b5c-10b046200c09	2025-05-06 19:32:13.411	2025-05-06 19:32:16.255	2025-05-06 19:32:13.227	import	FAILED	--add|||--zip hr.zip|||--collection fc7e5bbf-2ed6-49e3-a07c-f424855c1c50
35	75c3ab94-832e-4d84-9b5c-10b046200c09	2025-06-13 02:43:19.78	2025-06-13 02:43:25.578	2025-06-13 02:43:17.699	import	FAILED	--add|||--zip rav.zip|||--collection 0bc1fe8f-8569-4e6e-89b0-9772929606bc
17	75c3ab94-832e-4d84-9b5c-10b046200c09	2025-05-06 19:35:12.55	2025-05-06 19:35:14.99	2025-05-06 19:35:12.39	import	FAILED	--add|||--zip hr.zip|||--collection fc7e5bbf-2ed6-49e3-a07c-f424855c1c50
18	75c3ab94-832e-4d84-9b5c-10b046200c09	2025-05-06 19:37:28.193	2025-05-06 19:37:30.593	2025-05-06 19:37:28.106	import	FAILED	--add|||--zip Panda.zip|||--collection fc7e5bbf-2ed6-49e3-a07c-f424855c1c50
36	75c3ab94-832e-4d84-9b5c-10b046200c09	2025-06-13 02:46:56.598	2025-06-13 02:47:02.637	2025-06-13 02:46:54.857	import	FAILED	--add|||--zip rav.zip|||--collection 0bc1fe8f-8569-4e6e-89b0-9772929606bc
19	75c3ab94-832e-4d84-9b5c-10b046200c09	2025-05-06 19:44:33.904	2025-05-06 19:44:43.284	2025-05-06 19:44:33.8	import	COMPLETED	--add|||--zip Panda.zip|||--collection 51c8b287-1073-440c-8925-3ba25cc2ac76
37	75c3ab94-832e-4d84-9b5c-10b046200c09	2025-06-13 02:48:11.815	2025-06-13 02:48:18.589	2025-06-13 02:48:09.979	import	FAILED	--add|||--zip rav.zip|||--collection 0bc1fe8f-8569-4e6e-89b0-9772929606bc
20	75c3ab94-832e-4d84-9b5c-10b046200c09	2025-05-09 11:28:15.984	2025-05-09 11:28:20.759	2025-05-09 11:28:15.785	import	FAILED	--add|||--zip Panda.zip|||--collection 132a29ec-2856-4d0a-ae2d-891caa4b796e
38	75c3ab94-832e-4d84-9b5c-10b046200c09	2025-06-13 02:57:25.643	2025-06-13 02:57:34.382	2025-06-13 02:57:23.767	import	FAILED	--add|||--zip rav.zip|||--collection 0bc1fe8f-8569-4e6e-89b0-9772929606bc
21	75c3ab94-832e-4d84-9b5c-10b046200c09	2025-05-09 11:33:26.681	2025-05-09 11:33:34.632	2025-05-09 11:33:26.572	import	COMPLETED	--add|||--zip Panda.zip|||--collection e04ece8b-a894-452a-9e07-9f5fa3ca35ec
22	75c3ab94-832e-4d84-9b5c-10b046200c09	2025-05-09 11:37:10.348	2025-05-09 11:37:12.462	2025-05-09 11:37:10.245	import	FAILED	--add|||--zip Panda.zip|||--collection 90c82965-888a-40bb-8de8-3aceb6d20548
39	75c3ab94-832e-4d84-9b5c-10b046200c09	2025-06-13 03:19:44.697	2025-06-13 03:19:49.537	2025-06-13 03:19:43.008	import	FAILED	--add|||--zip rav.zip|||--collection 0bc1fe8f-8569-4e6e-89b0-9772929606bc
40	75c3ab94-832e-4d84-9b5c-10b046200c09	2025-06-13 03:36:47.352	2025-06-13 03:36:53.725	2025-06-13 03:36:45.92	import	FAILED	--add|||--zip rav.zip|||--collection 0bc1fe8f-8569-4e6e-89b0-9772929606bc
\.


--
-- Data for Name: process2bitstream; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.process2bitstream (process_id, bitstream_id) FROM stdin;
1	ff5c7076-c0a2-497d-be0e-d8fffb6ce41f
1	1feb0aae-67a2-49cd-a766-dd0b9d06c592
29	46ec0a27-1027-403d-81ab-6e16088394c2
2	38d06d74-3c74-4e76-be58-e3df8704e345
2	22915ed5-e8f4-4442-bfd4-cc6e488c47df
2	173374f7-02e5-4817-8ab7-8cbd382985b0
29	bb2a754c-c566-4510-9f48-5e5018fddbc5
29	a8d1e084-4006-4c44-97c0-6c057796fb89
3	6ec99fa2-276f-4119-91e9-6e46116e43fc
3	3c6e31ad-5217-40cc-8112-4324477ea8d8
3	a28e25ae-96cb-499b-aa50-cf8f6b868150
4	2b8dc1ca-f8da-45c9-9b7f-6149d3d5d191
4	7a292192-5bec-4358-bfdc-ae27578b4cb9
4	f4ef99d8-0800-4b93-bf95-129faf3015e4
5	062c9c70-eec2-4188-b48b-b23ea4a1bd45
5	1e99bd7c-6734-4755-bafb-cf883f044ea8
5	7c0b6660-9bd8-4542-bc74-8781cbc72f9e
31	749b2588-ec6a-4b43-a04d-8413d0073ef4
31	faae6b89-5b63-44db-9b26-fd912081f9eb
6	4a7752ff-8932-46d1-a766-4d36a723bd81
6	29326696-59de-446c-b833-d36936828fae
6	74058e8c-9fe4-4ff4-8e5d-b02d09caa089
7	7933d957-9acb-4f10-b440-50d041bea0af
7	b4528df9-6838-43d5-a987-e728e82ea1d0
7	62ac2a5a-39de-4135-a25c-8365422a6ca0
8	23c3b697-a4c5-48aa-9ee0-0aca2b5a1b4b
8	8a6cccc0-a9d0-444a-b5c0-da345485e010
8	4d5deca8-556f-414c-a5cc-051cfb1bc48f
9	5cd90407-6e36-4f08-b959-9ca3877719f3
9	06492d28-6f48-462e-a981-39c9e5cfbe40
9	3c58bf17-ace4-4ed0-8697-fb3097ac3360
10	7088082e-d908-4d91-9d78-697ce5af8e2c
10	bf936c92-b0f8-4e93-9ac8-931581d3f15f
10	4fc00d69-fcd4-4ded-95b2-bc82d7da5f63
34	ee696fdb-4d5c-4ec1-af77-f18d651db39d
34	d9b4c68a-0e7f-494c-a380-b089f0db9796
11	bffa777f-3b9a-4f40-9955-048a85e55453
11	77ecae42-7ae4-47cf-bd46-46ddbb69a862
11	260fe481-1993-4195-9b6d-83977d7ce9d2
35	a7aa7e8f-2e0f-45fd-bc7b-41608f164774
12	df761c44-c4b7-4b63-b36d-0b81d3a1698e
12	efa477b7-ad16-4bc6-bc0f-04aafe43736a
35	20fa345f-5945-4364-a7b5-98c576fbbf8f
13	316d2622-95b1-4b41-bd8c-271a59ffae66
13	db2546cd-9aef-4ef8-8472-97aff1fd1817
14	b2a578e0-b503-47ec-8e93-f1641eae7e24
14	d2ff8407-6bee-490f-aadb-5411c8a7b105
36	fe337f7c-54ed-46c9-b5fa-84910f1e2282
15	baecae16-b3b8-488d-a525-49dfbd060e76
15	53a1b46a-67e0-4105-97fc-67e4bb53f294
36	bf5ad438-914a-48b9-a745-39d5003c6d14
16	f557699e-1b6f-4152-8393-17b03dc6a5da
16	b827b971-58f2-455a-9575-63b771b6a920
17	4bfbf1d6-a42a-4b93-b3e3-34fe8a309351
17	c3b39c9e-0e5b-4d7f-b7fc-fcab7c249183
37	95b580c3-d3cd-4e48-9791-e2d8ce4a2330
18	910811f3-954b-4e26-8eb4-8e8cb14100e0
18	86f31c01-ad08-48e7-bb7a-c95405c442ef
37	9332be79-a9bf-4463-9f63-46c590148f71
38	9fadeecc-23a6-4746-9ec6-80f88db4a86e
19	42b2461a-88db-4e02-a98d-8458a466b76b
19	be61103b-4de4-4a9d-aa33-a37b79417b9f
19	339138ff-1b5d-4d1f-b72f-f4b81f634657
38	71f93610-2069-476d-9d56-53583fa637fd
20	c6d7ea8a-3653-4ba5-b843-f448d72a4f46
20	9272ae94-f565-4b74-86b8-55302a4bff38
39	050e2056-3eb0-4067-8632-b0d290b2fc7f
39	7259b601-89f1-4a1f-8fc4-56926dc068b8
21	81ce143d-a2d9-418d-999b-b5804b293746
21	bc37b708-d924-410e-8ede-cecf2588907e
21	c0da6b8c-4ec6-47de-b494-46335e099b36
22	33326ace-bf60-40d9-9342-812a491bf96a
22	e9377708-7c1d-4b2a-ba7f-b07e4f2762ec
40	1e8ca0ca-52f1-47f5-9df2-d65b9670500c
40	a657695d-ea87-4431-b5da-c5386bf488c5
23	439c7f26-2571-48a3-98c3-c22c7ad5aa5e
23	73c91a17-da38-4194-a03a-43dd8902879a
23	e4f1eaf5-471c-4a1d-9dfe-78d16daef96e
24	11e326a6-41d1-48aa-ab44-88e79be87367
24	d8a32f78-2b75-4020-9b65-7d829f342242
24	35e5fe5a-dc1d-4c95-8e0d-7d0fd1a4be21
25	aafd1652-1e33-47c8-83d3-164099e91f1d
25	68bf4655-e163-4dba-bce5-95abee17ef5f
25	1dfeffdc-06e2-41b1-a7f4-4e7be6425aa2
26	40391d5e-e77f-418e-af02-58bdeb8d7549
26	46769403-937c-4267-aded-006c27fc19a8
26	0e9afc9a-ce26-459d-88f5-74c96e5a7796
27	1ce72c8b-7d2b-452b-b1df-4f8c2c742b9f
27	ad00438d-cda1-425a-998f-b1986a6a5b23
27	f71db8ba-9806-42ab-9eef-fdeb1ac0cd1b
28	de3c5f7f-4550-43de-be75-113437c79993
28	a8f82864-d4ac-4f05-9c75-891704699547
28	3909dd25-4d13-4777-9972-0c5f55dac187
\.


--
-- Data for Name: process2group; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.process2group (process_id, group_id) FROM stdin;
\.


--
-- Data for Name: qaevent_processed; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.qaevent_processed (qaevent_id, qaevent_timestamp, eperson_uuid, item_uuid) FROM stdin;
\.


--
-- Data for Name: registrationdata; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.registrationdata (registrationdata_id, email, token, expires) FROM stdin;
1	abhisheksingh258833@gmail.com	9af0f54aa2ea2cc0062b8e4374576755	\N
2	laddu8651bxr@gmail.com	6a6d24ac088f19ea7e3dc40c4fadb6f4	\N
3	user@institution.edu	a566b4cae88c169d64d201bca1331d8b	\N
5	singhshubhamkumar242@gmail.com	efc515e15e371558f56eac8ceaf322a1	\N
6	rajabau@gmail.com	43845ec260f1c7e425295136b6f788e9	\N
11	dspacedemo+admin@gmail.com	5446c3a3b3d9bf3c403ae7eec73714e7	\N
15	techie3707@gmail.com	a1470132770a95d14eb285217774d5ce	\N
20	anknitsinha648@gmail.com	6e6dc259c6cbc99ef2c230cbc359c975	\N
21	ankitsinha648@gmail.com	c4b403b4a83e0f3cb2968eed3fca01b2	\N
22	shubhamkumarsinghbxr@gmail.com	8da99e79961ac48bc8d0f7a7650c7c2e	\N
\.


--
-- Data for Name: relationship; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.relationship (id, left_id, type_id, right_id, left_place, right_place, leftward_value, rightward_value, latest_version_status) FROM stdin;
\.


--
-- Data for Name: relationship_type; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.relationship_type (id, left_type, right_type, leftward_type, rightward_type, left_min_cardinality, left_max_cardinality, right_min_cardinality, right_max_cardinality, copy_to_left, copy_to_right, tilted) FROM stdin;
\.


--
-- Data for Name: requestitem; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.requestitem (requestitem_id, token, allfiles, request_email, request_name, request_date, accept_request, decision_date, expires, request_message, item_id, bitstream_id) FROM stdin;
\.


--
-- Data for Name: resourcepolicy; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.resourcepolicy (policy_id, resource_type_id, resource_id, action_id, start_date, end_date, rpname, rptype, rpdescription, eperson_id, epersongroup_id, dspace_object) FROM stdin;
1	5	\N	0	\N	\N	\N	\N	\N	\N	ea708783-6e3b-42be-b7ae-a27a039d48d5	23e54f59-2618-49fe-bb8c-7278e389948f
10739	4	\N	0	\N	\N	\N	\N	\N	\N	ea708783-6e3b-42be-b7ae-a27a039d48d5	95d68496-65b6-4ea5-a86a-483b608d5ecb
3604	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	316d2622-95b1-4b41-bd8c-271a59ffae66
3605	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	316d2622-95b1-4b41-bd8c-271a59ffae66
3055	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	bffa777f-3b9a-4f40-9955-048a85e55453
3606	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	316d2622-95b1-4b41-bd8c-271a59ffae66
3692	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	f557699e-1b6f-4152-8393-17b03dc6a5da
3693	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	f557699e-1b6f-4152-8393-17b03dc6a5da
3056	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	bffa777f-3b9a-4f40-9955-048a85e55453
3057	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	bffa777f-3b9a-4f40-9955-048a85e55453
2566	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	7088082e-d908-4d91-9d78-697ce5af8e2c
2567	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	7088082e-d908-4d91-9d78-697ce5af8e2c
1743	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	38d06d74-3c74-4e76-be58-e3df8704e345
2568	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	7088082e-d908-4d91-9d78-697ce5af8e2c
1744	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	38d06d74-3c74-4e76-be58-e3df8704e345
1745	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	38d06d74-3c74-4e76-be58-e3df8704e345
3694	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	f557699e-1b6f-4152-8393-17b03dc6a5da
3744	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	910811f3-954b-4e26-8eb4-8e8cb14100e0
3745	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	910811f3-954b-4e26-8eb4-8e8cb14100e0
3746	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	910811f3-954b-4e26-8eb4-8e8cb14100e0
3718	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	4bfbf1d6-a42a-4b93-b3e3-34fe8a309351
3719	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	4bfbf1d6-a42a-4b93-b3e3-34fe8a309351
3720	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	4bfbf1d6-a42a-4b93-b3e3-34fe8a309351
5906	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	aafd1652-1e33-47c8-83d3-164099e91f1d
5907	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	aafd1652-1e33-47c8-83d3-164099e91f1d
1755	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	6ec99fa2-276f-4119-91e9-6e46116e43fc
1756	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	6ec99fa2-276f-4119-91e9-6e46116e43fc
1757	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	6ec99fa2-276f-4119-91e9-6e46116e43fc
5908	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	aafd1652-1e33-47c8-83d3-164099e91f1d
7919	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	46ec0a27-1027-403d-81ab-6e16088394c2
3578	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	df761c44-c4b7-4b63-b36d-0b81d3a1698e
1758	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	a28e25ae-96cb-499b-aa50-cf8f6b868150
1759	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	a28e25ae-96cb-499b-aa50-cf8f6b868150
1760	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	a28e25ae-96cb-499b-aa50-cf8f6b868150
3579	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	df761c44-c4b7-4b63-b36d-0b81d3a1698e
3580	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	df761c44-c4b7-4b63-b36d-0b81d3a1698e
7920	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	46ec0a27-1027-403d-81ab-6e16088394c2
1764	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	2b8dc1ca-f8da-45c9-9b7f-6149d3d5d191
1765	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	2b8dc1ca-f8da-45c9-9b7f-6149d3d5d191
1766	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	2b8dc1ca-f8da-45c9-9b7f-6149d3d5d191
6396	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	40391d5e-e77f-418e-af02-58bdeb8d7549
6397	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	40391d5e-e77f-418e-af02-58bdeb8d7549
6398	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	40391d5e-e77f-418e-af02-58bdeb8d7549
1767	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	f4ef99d8-0800-4b93-bf95-129faf3015e4
1768	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	f4ef99d8-0800-4b93-bf95-129faf3015e4
1769	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	f4ef99d8-0800-4b93-bf95-129faf3015e4
1836	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	5cd90407-6e36-4f08-b959-9ca3877719f3
1837	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	5cd90407-6e36-4f08-b959-9ca3877719f3
7921	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	46ec0a27-1027-403d-81ab-6e16088394c2
1838	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	5cd90407-6e36-4f08-b959-9ca3877719f3
10540	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	050e2056-3eb0-4067-8632-b0d290b2fc7f
4312	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	c6d7ea8a-3653-4ba5-b843-f448d72a4f46
4313	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	c6d7ea8a-3653-4ba5-b843-f448d72a4f46
4314	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	c6d7ea8a-3653-4ba5-b843-f448d72a4f46
10541	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	050e2056-3eb0-4067-8632-b0d290b2fc7f
10542	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	050e2056-3eb0-4067-8632-b0d290b2fc7f
3538	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	77ecae42-7ae4-47cf-bd46-46ddbb69a862
3539	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	77ecae42-7ae4-47cf-bd46-46ddbb69a862
3540	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	77ecae42-7ae4-47cf-bd46-46ddbb69a862
3541	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	260fe481-1993-4195-9b6d-83977d7ce9d2
1746	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	22915ed5-e8f4-4442-bfd4-cc6e488c47df
1747	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	22915ed5-e8f4-4442-bfd4-cc6e488c47df
1748	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	22915ed5-e8f4-4442-bfd4-cc6e488c47df
1800	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	062c9c70-eec2-4188-b48b-b23ea4a1bd45
1801	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	062c9c70-eec2-4188-b48b-b23ea4a1bd45
1802	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	062c9c70-eec2-4188-b48b-b23ea4a1bd45
1749	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	173374f7-02e5-4817-8ab7-8cbd382985b0
1750	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	173374f7-02e5-4817-8ab7-8cbd382985b0
7423	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	de3c5f7f-4550-43de-be75-113437c79993
7424	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	de3c5f7f-4550-43de-be75-113437c79993
1751	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	173374f7-02e5-4817-8ab7-8cbd382985b0
7425	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	de3c5f7f-4550-43de-be75-113437c79993
4838	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	33326ace-bf60-40d9-9342-812a491bf96a
1752	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	3c6e31ad-5217-40cc-8112-4324477ea8d8
1753	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	3c6e31ad-5217-40cc-8112-4324477ea8d8
1754	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	3c6e31ad-5217-40cc-8112-4324477ea8d8
4839	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	33326ace-bf60-40d9-9342-812a491bf96a
4840	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	33326ace-bf60-40d9-9342-812a491bf96a
1761	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	7a292192-5bec-4358-bfdc-ae27578b4cb9
1762	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	7a292192-5bec-4358-bfdc-ae27578b4cb9
1763	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	7a292192-5bec-4358-bfdc-ae27578b4cb9
3601	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	efa477b7-ad16-4bc6-bc0f-04aafe43736a
3602	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	efa477b7-ad16-4bc6-bc0f-04aafe43736a
3603	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	efa477b7-ad16-4bc6-bc0f-04aafe43736a
5417	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	11e326a6-41d1-48aa-ab44-88e79be87367
5418	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	11e326a6-41d1-48aa-ab44-88e79be87367
5419	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	11e326a6-41d1-48aa-ab44-88e79be87367
3627	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	db2546cd-9aef-4ef8-8472-97aff1fd1817
3628	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	db2546cd-9aef-4ef8-8472-97aff1fd1817
3629	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	db2546cd-9aef-4ef8-8472-97aff1fd1817
3715	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	b827b971-58f2-455a-9575-63b771b6a920
3716	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	b827b971-58f2-455a-9575-63b771b6a920
3717	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	b827b971-58f2-455a-9575-63b771b6a920
3767	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	86f31c01-ad08-48e7-bb7a-c95405c442ef
3685	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	53a1b46a-67e0-4105-97fc-67e4bb53f294
3686	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	53a1b46a-67e0-4105-97fc-67e4bb53f294
3687	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	53a1b46a-67e0-4105-97fc-67e4bb53f294
3768	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	86f31c01-ad08-48e7-bb7a-c95405c442ef
3769	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	86f31c01-ad08-48e7-bb7a-c95405c442ef
10445	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	ee696fdb-4d5c-4ec1-af77-f18d651db39d
10446	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	ee696fdb-4d5c-4ec1-af77-f18d651db39d
10447	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	ee696fdb-4d5c-4ec1-af77-f18d651db39d
8946	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	faae6b89-5b63-44db-9b26-fd912081f9eb
8947	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	faae6b89-5b63-44db-9b26-fd912081f9eb
8948	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	faae6b89-5b63-44db-9b26-fd912081f9eb
3542	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	260fe481-1993-4195-9b6d-83977d7ce9d2
3653	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	d2ff8407-6bee-490f-aadb-5411c8a7b105
3654	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	d2ff8407-6bee-490f-aadb-5411c8a7b105
3655	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	d2ff8407-6bee-490f-aadb-5411c8a7b105
1803	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	1e99bd7c-6734-4755-bafb-cf883f044ea8
1804	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	1e99bd7c-6734-4755-bafb-cf883f044ea8
1805	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	1e99bd7c-6734-4755-bafb-cf883f044ea8
3630	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	b2a578e0-b503-47ec-8e93-f1641eae7e24
3631	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	b2a578e0-b503-47ec-8e93-f1641eae7e24
3632	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	b2a578e0-b503-47ec-8e93-f1641eae7e24
1806	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	7c0b6660-9bd8-4542-bc74-8781cbc72f9e
1807	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	7c0b6660-9bd8-4542-bc74-8781cbc72f9e
1808	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	7c0b6660-9bd8-4542-bc74-8781cbc72f9e
3662	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	baecae16-b3b8-488d-a525-49dfbd060e76
3663	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	baecae16-b3b8-488d-a525-49dfbd060e76
3664	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	baecae16-b3b8-488d-a525-49dfbd060e76
3809	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	42b2461a-88db-4e02-a98d-8458a466b76b
3810	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	42b2461a-88db-4e02-a98d-8458a466b76b
4335	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	9272ae94-f565-4b74-86b8-55302a4bff38
4336	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	9272ae94-f565-4b74-86b8-55302a4bff38
4337	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	9272ae94-f565-4b74-86b8-55302a4bff38
4909	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	439c7f26-2571-48a3-98c3-c22c7ad5aa5e
4910	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	439c7f26-2571-48a3-98c3-c22c7ad5aa5e
3811	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	42b2461a-88db-4e02-a98d-8458a466b76b
4911	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	439c7f26-2571-48a3-98c3-c22c7ad5aa5e
8923	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	749b2588-ec6a-4b43-a04d-8413d0073ef4
8924	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	749b2588-ec6a-4b43-a04d-8413d0073ef4
8925	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	749b2588-ec6a-4b43-a04d-8413d0073ef4
10563	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	7259b601-89f1-4a1f-8fc4-56926dc068b8
10564	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	7259b601-89f1-4a1f-8fc4-56926dc068b8
10565	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	7259b601-89f1-4a1f-8fc4-56926dc068b8
10566	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	1e8ca0ca-52f1-47f5-9df2-d65b9670500c
10567	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	1e8ca0ca-52f1-47f5-9df2-d65b9670500c
10568	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	1e8ca0ca-52f1-47f5-9df2-d65b9670500c
3741	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	c3b39c9e-0e5b-4d7f-b7fc-fcab7c249183
3742	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	c3b39c9e-0e5b-4d7f-b7fc-fcab7c249183
3743	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	c3b39c9e-0e5b-4d7f-b7fc-fcab7c249183
5392	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	73c91a17-da38-4194-a03a-43dd8902879a
4861	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	e9377708-7c1d-4b2a-ba7f-b07e4f2762ec
4862	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	e9377708-7c1d-4b2a-ba7f-b07e4f2762ec
4292	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	be61103b-4de4-4a9d-aa33-a37b79417b9f
4293	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	be61103b-4de4-4a9d-aa33-a37b79417b9f
4294	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	be61103b-4de4-4a9d-aa33-a37b79417b9f
4863	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	e9377708-7c1d-4b2a-ba7f-b07e4f2762ec
5393	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	73c91a17-da38-4194-a03a-43dd8902879a
5394	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	73c91a17-da38-4194-a03a-43dd8902879a
4295	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	339138ff-1b5d-4d1f-b72f-f4b81f634657
4296	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	339138ff-1b5d-4d1f-b72f-f4b81f634657
4297	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	339138ff-1b5d-4d1f-b72f-f4b81f634657
5395	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	e4f1eaf5-471c-4a1d-9dfe-78d16daef96e
5396	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	e4f1eaf5-471c-4a1d-9dfe-78d16daef96e
5397	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	e4f1eaf5-471c-4a1d-9dfe-78d16daef96e
1809	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	29326696-59de-446c-b833-d36936828fae
1810	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	29326696-59de-446c-b833-d36936828fae
1811	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	29326696-59de-446c-b833-d36936828fae
6890	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	1ce72c8b-7d2b-452b-b1df-4f8c2c742b9f
6891	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	1ce72c8b-7d2b-452b-b1df-4f8c2c742b9f
6892	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	1ce72c8b-7d2b-452b-b1df-4f8c2c742b9f
10453	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	d9b4c68a-0e7f-494c-a380-b089f0db9796
10454	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	d9b4c68a-0e7f-494c-a380-b089f0db9796
10455	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	d9b4c68a-0e7f-494c-a380-b089f0db9796
10589	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	a657695d-ea87-4431-b5da-c5386bf488c5
10590	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	a657695d-ea87-4431-b5da-c5386bf488c5
10591	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	a657695d-ea87-4431-b5da-c5386bf488c5
5900	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	d8a32f78-2b75-4020-9b65-7d829f342242
5901	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	d8a32f78-2b75-4020-9b65-7d829f342242
5902	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	d8a32f78-2b75-4020-9b65-7d829f342242
5903	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	35e5fe5a-dc1d-4c95-8e0d-7d0fd1a4be21
5904	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	35e5fe5a-dc1d-4c95-8e0d-7d0fd1a4be21
5905	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	35e5fe5a-dc1d-4c95-8e0d-7d0fd1a4be21
1812	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	4a7752ff-8932-46d1-a766-4d36a723bd81
1813	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	4a7752ff-8932-46d1-a766-4d36a723bd81
1814	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	4a7752ff-8932-46d1-a766-4d36a723bd81
1815	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	74058e8c-9fe4-4ff4-8e5d-b02d09caa089
1816	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	74058e8c-9fe4-4ff4-8e5d-b02d09caa089
1817	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	74058e8c-9fe4-4ff4-8e5d-b02d09caa089
4343	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	81ce143d-a2d9-418d-999b-b5804b293746
4344	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	81ce143d-a2d9-418d-999b-b5804b293746
4345	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	81ce143d-a2d9-418d-999b-b5804b293746
4826	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	bc37b708-d924-410e-8ede-cecf2588907e
4827	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	bc37b708-d924-410e-8ede-cecf2588907e
4828	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	bc37b708-d924-410e-8ede-cecf2588907e
4829	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	c0da6b8c-4ec6-47de-b494-46335e099b36
4830	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	c0da6b8c-4ec6-47de-b494-46335e099b36
4831	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	c0da6b8c-4ec6-47de-b494-46335e099b36
1818	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	7933d957-9acb-4f10-b440-50d041bea0af
1819	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	7933d957-9acb-4f10-b440-50d041bea0af
1820	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	7933d957-9acb-4f10-b440-50d041bea0af
1830	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	23c3b697-a4c5-48aa-9ee0-0aca2b5a1b4b
1831	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	23c3b697-a4c5-48aa-9ee0-0aca2b5a1b4b
1832	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	23c3b697-a4c5-48aa-9ee0-0aca2b5a1b4b
1833	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	4d5deca8-556f-414c-a5cc-051cfb1bc48f
1834	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	4d5deca8-556f-414c-a5cc-051cfb1bc48f
1835	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	4d5deca8-556f-414c-a5cc-051cfb1bc48f
3543	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	260fe481-1993-4195-9b6d-83977d7ce9d2
1821	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	b4528df9-6838-43d5-a987-e728e82ea1d0
1822	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	b4528df9-6838-43d5-a987-e728e82ea1d0
1823	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	b4528df9-6838-43d5-a987-e728e82ea1d0
1824	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	62ac2a5a-39de-4135-a25c-8365422a6ca0
1825	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	62ac2a5a-39de-4135-a25c-8365422a6ca0
1826	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	62ac2a5a-39de-4135-a25c-8365422a6ca0
1827	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	8a6cccc0-a9d0-444a-b5c0-da345485e010
1828	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	8a6cccc0-a9d0-444a-b5c0-da345485e010
1829	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	8a6cccc0-a9d0-444a-b5c0-da345485e010
10466	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	a7aa7e8f-2e0f-45fd-bc7b-41608f164774
10467	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	a7aa7e8f-2e0f-45fd-bc7b-41608f164774
10468	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	a7aa7e8f-2e0f-45fd-bc7b-41608f164774
10474	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	20fa345f-5945-4364-a7b5-98c576fbbf8f
10475	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	20fa345f-5945-4364-a7b5-98c576fbbf8f
10476	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	20fa345f-5945-4364-a7b5-98c576fbbf8f
10477	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	fe337f7c-54ed-46c9-b5fa-84910f1e2282
10478	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	fe337f7c-54ed-46c9-b5fa-84910f1e2282
10479	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	fe337f7c-54ed-46c9-b5fa-84910f1e2282
10488	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	95b580c3-d3cd-4e48-9791-e2d8ce4a2330
10489	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	95b580c3-d3cd-4e48-9791-e2d8ce4a2330
10490	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	95b580c3-d3cd-4e48-9791-e2d8ce4a2330
10485	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	bf5ad438-914a-48b9-a745-39d5003c6d14
10486	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	bf5ad438-914a-48b9-a745-39d5003c6d14
10487	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	bf5ad438-914a-48b9-a745-39d5003c6d14
10511	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	9332be79-a9bf-4463-9f63-46c590148f71
10512	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	9332be79-a9bf-4463-9f63-46c590148f71
10513	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	9332be79-a9bf-4463-9f63-46c590148f71
10514	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	9fadeecc-23a6-4746-9ec6-80f88db4a86e
10515	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	9fadeecc-23a6-4746-9ec6-80f88db4a86e
10516	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	9fadeecc-23a6-4746-9ec6-80f88db4a86e
2319	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	06492d28-6f48-462e-a981-39c9e5cfbe40
2320	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	06492d28-6f48-462e-a981-39c9e5cfbe40
2321	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	06492d28-6f48-462e-a981-39c9e5cfbe40
2322	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	3c58bf17-ace4-4ed0-8697-fb3097ac3360
2323	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	3c58bf17-ace4-4ed0-8697-fb3097ac3360
2324	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	3c58bf17-ace4-4ed0-8697-fb3097ac3360
3049	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	bf936c92-b0f8-4e93-9ac8-931581d3f15f
3050	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	bf936c92-b0f8-4e93-9ac8-931581d3f15f
3051	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	bf936c92-b0f8-4e93-9ac8-931581d3f15f
3052	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	4fc00d69-fcd4-4ded-95b2-bc82d7da5f63
3053	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	4fc00d69-fcd4-4ded-95b2-bc82d7da5f63
3054	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	4fc00d69-fcd4-4ded-95b2-bc82d7da5f63
7906	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	a8f82864-d4ac-4f05-9c75-891704699547
7907	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	a8f82864-d4ac-4f05-9c75-891704699547
7908	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	a8f82864-d4ac-4f05-9c75-891704699547
8402	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	bb2a754c-c566-4510-9f48-5e5018fddbc5
8403	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	bb2a754c-c566-4510-9f48-5e5018fddbc5
7909	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	3909dd25-4d13-4777-9972-0c5f55dac187
7910	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	3909dd25-4d13-4777-9972-0c5f55dac187
7911	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	3909dd25-4d13-4777-9972-0c5f55dac187
8404	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	bb2a754c-c566-4510-9f48-5e5018fddbc5
8405	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	a8d1e084-4006-4c44-97c0-6c057796fb89
8406	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	a8d1e084-4006-4c44-97c0-6c057796fb89
8407	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	a8d1e084-4006-4c44-97c0-6c057796fb89
10537	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	71f93610-2069-476d-9d56-53583fa637fd
10538	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	71f93610-2069-476d-9d56-53583fa637fd
10539	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	71f93610-2069-476d-9d56-53583fa637fd
6389	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	68bf4655-e163-4dba-bce5-95abee17ef5f
6390	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	68bf4655-e163-4dba-bce5-95abee17ef5f
6391	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	68bf4655-e163-4dba-bce5-95abee17ef5f
6392	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	1dfeffdc-06e2-41b1-a7f4-4e7be6425aa2
6393	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	1dfeffdc-06e2-41b1-a7f4-4e7be6425aa2
6394	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	1dfeffdc-06e2-41b1-a7f4-4e7be6425aa2
6879	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	46769403-937c-4267-aded-006c27fc19a8
6880	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	46769403-937c-4267-aded-006c27fc19a8
6881	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	46769403-937c-4267-aded-006c27fc19a8
6882	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	0e9afc9a-ce26-459d-88f5-74c96e5a7796
6883	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	0e9afc9a-ce26-459d-88f5-74c96e5a7796
6884	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	0e9afc9a-ce26-459d-88f5-74c96e5a7796
7373	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	ad00438d-cda1-425a-998f-b1986a6a5b23
7374	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	ad00438d-cda1-425a-998f-b1986a6a5b23
7375	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	ad00438d-cda1-425a-998f-b1986a6a5b23
7376	0	\N	0	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	f71db8ba-9806-42ab-9eef-fdeb1ac0cd1b
7377	0	\N	1	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	f71db8ba-9806-42ab-9eef-fdeb1ac0cd1b
7378	0	\N	2	\N	\N	\N	\N	\N	75c3ab94-832e-4d84-9b5c-10b046200c09	\N	f71db8ba-9806-42ab-9eef-fdeb1ac0cd1b
\.


--
-- Data for Name: schema_version; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.schema_version (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
1	1	<< Flyway Baseline >>	BASELINE	<< Flyway Baseline >>	\N	null	2024-01-13 15:42:49.920847	0	t
2	1.1	Initial DSpace 1.1 database schema	SQL	V1.1__Initial_DSpace_1.1_database_schema.sql	1147897299	dspace	2024-01-13 15:42:50.072452	146	t
3	1.2	Upgrade to DSpace 1.2 schema	SQL	V1.2__Upgrade_to_DSpace_1.2_schema.sql	903973515	dspace	2024-01-13 15:42:50.232485	23	t
4	1.3	Upgrade to DSpace 1.3 schema	SQL	V1.3__Upgrade_to_DSpace_1.3_schema.sql	-783235991	dspace	2024-01-13 15:42:50.2586	21	t
5	1.3.9	Drop constraint for DSpace 1 4 schema	JDBC	org.dspace.storage.rdbms.migration.V1_3_9__Drop_constraint_for_DSpace_1_4_schema	-1	dspace	2024-01-13 15:42:50.284118	5	t
6	1.4	Upgrade to DSpace 1.4 schema	SQL	V1.4__Upgrade_to_DSpace_1.4_schema.sql	-831219528	dspace	2024-01-13 15:42:50.299253	58	t
7	1.5	Upgrade to DSpace 1.5 schema	SQL	V1.5__Upgrade_to_DSpace_1.5_schema.sql	-1234304544	dspace	2024-01-13 15:42:50.384812	78	t
8	1.5.9	Drop constraint for DSpace 1 6 schema	JDBC	org.dspace.storage.rdbms.migration.V1_5_9__Drop_constraint_for_DSpace_1_6_schema	-1	dspace	2024-01-13 15:42:50.469779	2	t
9	1.6	Upgrade to DSpace 1.6 schema	SQL	V1.6__Upgrade_to_DSpace_1.6_schema.sql	-495469766	dspace	2024-01-13 15:42:50.47568	23	t
10	1.7	Upgrade to DSpace 1.7 schema	SQL	V1.7__Upgrade_to_DSpace_1.7_schema.sql	-589640641	dspace	2024-01-13 15:42:50.504012	1	t
11	1.8	Upgrade to DSpace 1.8 schema	SQL	V1.8__Upgrade_to_DSpace_1.8_schema.sql	-171791117	dspace	2024-01-13 15:42:50.51003	4	t
12	3.0	Upgrade to DSpace 3.x schema	SQL	V3.0__Upgrade_to_DSpace_3.x_schema.sql	-1098885663	dspace	2024-01-13 15:42:50.518112	13	t
13	4.0	Upgrade to DSpace 4.x schema	SQL	V4.0__Upgrade_to_DSpace_4.x_schema.sql	1191833374	dspace	2024-01-13 15:42:50.536661	22	t
14	4.9.2015.10.26	DS-2818 registry update	SQL	V4.9_2015.10.26__DS-2818_registry_update.sql	1675451156	dspace	2024-01-13 15:42:50.563917	5	t
15	5.0.2014.08.08	DS-1945 Helpdesk Request a Copy	SQL	V5.0_2014.08.08__DS-1945_Helpdesk_Request_a_Copy.sql	-1208221648	dspace	2024-01-13 15:42:50.5739	3	t
16	5.0.2014.09.25	DS 1582 Metadata For All Objects drop constraint	JDBC	org.dspace.storage.rdbms.migration.V5_0_2014_09_25__DS_1582_Metadata_For_All_Objects_drop_constraint	-1	dspace	2024-01-13 15:42:50.58065	2	t
17	5.0.2014.09.26	DS-1582 Metadata For All Objects	SQL	V5.0_2014.09.26__DS-1582_Metadata_For_All_Objects.sql	1509433410	dspace	2024-01-13 15:42:50.589359	17	t
18	5.0.2014.11.04	Enable XMLWorkflow Migration	JDBC	org.dspace.storage.rdbms.xmlworkflow.V5_0_2014_11_04__Enable_XMLWorkflow_Migration	-1	dspace	2024-01-13 15:42:50.610176	90	t
19	5.6.2016.08.23	DS-3097	SQL	V5.6_2016.08.23__DS-3097.sql	410632858	dspace	2024-01-13 15:42:50.705954	2	t
20	5.7.2017.04.11	DS-3563 Index metadatavalue resource type id column	SQL	V5.7_2017.04.11__DS-3563_Index_metadatavalue_resource_type_id_column.sql	912059617	dspace	2024-01-13 15:42:50.711932	3	t
21	5.7.2017.05.05	DS 3431 Add Policies for BasicWorkflow	JDBC	org.dspace.storage.rdbms.migration.V5_7_2017_05_05__DS_3431_Add_Policies_for_BasicWorkflow	-1	dspace	2024-01-13 15:42:50.717889	2	t
22	6.0.2015.03.06	DS 2701 Dso Uuid Migration	JDBC	org.dspace.storage.rdbms.migration.V6_0_2015_03_06__DS_2701_Dso_Uuid_Migration	-1	dspace	2024-01-13 15:42:50.723559	13	t
23	6.0.2015.03.07	DS-2701 Hibernate migration	SQL	V6.0_2015.03.07__DS-2701_Hibernate_migration.sql	-542830952	dspace	2024-01-13 15:42:50.750192	254	t
24	6.0.2015.08.31	DS 2701 Hibernate Workflow Migration	JDBC	org.dspace.storage.rdbms.migration.V6_0_2015_08_31__DS_2701_Hibernate_Workflow_Migration	-1	dspace	2024-01-13 15:42:51.018051	12	t
25	6.0.2015.09.01	DS 2701 Enable XMLWorkflow Migration	JDBC	org.dspace.storage.rdbms.xmlworkflow.V6_0_2015_09_01__DS_2701_Enable_XMLWorkflow_Migration	-1	dspace	2024-01-13 15:42:51.034584	1	t
26	6.0.2016.01.03	DS-3024	SQL	V6.0_2016.01.03__DS-3024.sql	95468273	dspace	2024-01-13 15:42:51.038502	1	t
27	6.0.2016.01.26	DS 2188 Remove DBMS Browse Tables	JDBC	org.dspace.storage.rdbms.migration.V6_0_2016_01_26__DS_2188_Remove_DBMS_Browse_Tables	-1	dspace	2024-01-13 15:42:51.041733	18	t
28	6.0.2016.02.25	DS-3004-slow-searching-as-admin	SQL	V6.0_2016.02.25__DS-3004-slow-searching-as-admin.sql	-1623115511	dspace	2024-01-13 15:42:51.065579	4	t
29	6.0.2016.04.01	DS-1955 Increase embargo reason	SQL	V6.0_2016.04.01__DS-1955_Increase_embargo_reason.sql	283892016	dspace	2024-01-13 15:42:51.074569	2	t
30	6.0.2016.04.04	DS-3086-OAI-Performance-fix	SQL	V6.0_2016.04.04__DS-3086-OAI-Performance-fix.sql	445863295	dspace	2024-01-13 15:42:51.08056	9	t
31	6.0.2016.04.14	DS-3125-fix-bundle-bitstream-delete-rights	SQL	V6.0_2016.04.14__DS-3125-fix-bundle-bitstream-delete-rights.sql	-699277527	dspace	2024-01-13 15:42:51.094762	1	t
32	6.0.2016.05.10	DS-3168-fix-requestitem item id column	SQL	V6.0_2016.05.10__DS-3168-fix-requestitem_item_id_column.sql	-1122969100	dspace	2024-01-13 15:42:51.100576	8	t
33	6.0.2016.07.21	DS-2775	SQL	V6.0_2016.07.21__DS-2775.sql	-126635374	dspace	2024-01-13 15:42:51.113616	4	t
34	6.0.2016.07.26	DS-3277 fix handle assignment	SQL	V6.0_2016.07.26__DS-3277_fix_handle_assignment.sql	-284088754	dspace	2024-01-13 15:42:51.123895	4	t
35	6.0.2016.08.23	DS-3097	SQL	V6.0_2016.08.23__DS-3097.sql	-1986377895	dspace	2024-01-13 15:42:51.132216	2	t
36	6.1.2017.01.03	DS 3431 Add Policies for BasicWorkflow	JDBC	org.dspace.storage.rdbms.migration.V6_1_2017_01_03__DS_3431_Add_Policies_for_BasicWorkflow	-1	dspace	2024-01-13 15:42:51.136333	1	t
37	7.0.2017.10.12	DS-3542-stateless-sessions	SQL	V7.0_2017.10.12__DS-3542-stateless-sessions.sql	1096514101	dspace	2024-01-13 15:42:51.140541	2	t
38	7.0.2018.04.03	Upgrade Workflow Policy	JDBC	org.dspace.storage.rdbms.migration.V7_0_2018_04_03__Upgrade_Workflow_Policy	-1	dspace	2024-01-13 15:42:51.152553	7	t
39	7.0.2018.04.16	dspace-entities	SQL	V7.0_2018.04.16__dspace-entities.sql	48698215	dspace	2024-01-13 15:42:51.164077	24	t
40	7.0.2018.06.07	DS-3851-permission	SQL	V7.0_2018.06.07__DS-3851-permission.sql	-483449368	dspace	2024-01-13 15:42:51.192603	1	t
41	7.0.2019.05.02	DS-4239-workflow-xml-migration	SQL	V7.0_2019.05.02__DS-4239-workflow-xml-migration.sql	552982806	dspace	2024-01-13 15:42:51.19716	1	t
42	7.0.2019.06.14	scripts-and-process	SQL	V7.0_2019_06_14__scripts-and-process.sql	461424151	dspace	2024-01-13 15:42:51.200689	11	t
43	7.0.2019.07.31	Retrieval of name variant	SQL	V7.0_2019.07.31__Retrieval_of_name_variant.sql	1983541373	dspace	2024-01-13 15:42:51.215405	3	t
44	7.0.2019.11.13	relationship type copy left right	SQL	V7.0_2019.11.13__relationship_type_copy_left_right.sql	-1354960066	dspace	2024-01-13 15:42:51.220518	2	t
45	7.0.2020.01.08	DS-626-statistics-tracker	SQL	V7.0_2020.01.08__DS-626-statistics-tracker.sql	-333238642	dspace	2024-01-13 15:42:51.225287	4	t
46	7.0.2020.10.31	CollectionCommunity Metadata Handle	JDBC	org.dspace.storage.rdbms.migration.V7_0_2020_10_31__CollectionCommunity_Metadata_Handle	-1	dspace	2024-01-13 15:42:51.23261	7	t
47	7.0.2021.01.22	Remove basic workflow	SQL	V7.0_2021.01.22__Remove_basic_workflow.sql	2057390209	dspace	2024-01-13 15:42:51.243027	3	t
48	7.0.2021.02.08	tilted rels	SQL	V7.0_2021.02.08__tilted_rels.sql	-766574489	dspace	2024-01-13 15:42:51.250087	1	t
49	7.0.2021.03.18	Move entity type to dspace schema	SQL	V7.0_2021.03.18__Move_entity_type_to_dspace_schema.sql	-1728009386	dspace	2024-01-13 15:42:51.253994	2	t
50	7.0.2021.09.24	Move entity type from item template to collection	SQL	V7.0_2021.09.24__Move_entity_type_from_item_template_to_collection.sql	1218117924	dspace	2024-01-13 15:42:51.259364	1	t
51	7.0.2021.10.04	alter collection table drop workflow stem columns	SQL	V7.0_2021.10.04__alter_collection_table_drop_workflow_stem_columns.sql	-1110355606	dspace	2024-01-13 15:42:51.263313	2	t
52	7.1.2021.10.18	Fix MDV place after migrating from DSpace 5	SQL	V7.1_2021.10.18__Fix_MDV_place_after_migrating_from_DSpace_5.sql	1472833040	dspace	2024-01-13 15:42:51.269049	1	t
53	7.3.2022.04.29	orcid queue and history	SQL	V7.3_2022.04.29__orcid_queue_and_history.sql	1236173569	dspace	2024-01-13 15:42:51.273896	11	t
54	7.3.2022.05.16	Orcid token table	SQL	V7.3_2022.05.16__Orcid_token_table.sql	-1774799511	dspace	2024-01-13 15:42:51.288685	4	t
55	7.3.2022.06.16	process to group	SQL	V7.3_2022.06.16__process_to_group.sql	1355367717	dspace	2024-01-13 15:42:51.295245	3	t
56	7.3.2022.06.20	add last version status column to relationship table	SQL	V7.3_2022.06.20__add_last_version_status_column_to_relationship_table.sql	1737818971	dspace	2024-01-13 15:42:51.300053	0	t
57	7.5.2022.12.01	add table subscriptionparamter change columns subscription table	SQL	V7.5_2022.12.01__add_table_subscriptionparamter_change_columns_subscription_table.sql	-721211506	dspace	2024-01-13 15:42:51.303501	7	t
58	7.5.2022.12.06	index action resource policy	SQL	V7.5_2022.12.06__index_action_resource_policy.sql	-1946362859	dspace	2024-01-13 15:42:51.313864	2	t
59	7.5.2022.12.09	Supervision Orders table	SQL	V7.5_2022.12.09__Supervision_Orders_table.sql	-189440977	dspace	2024-01-13 15:42:51.318275	8	t
60	7.5.2022.12.15	system wide alerts	SQL	V7.5_2022.12.15__system_wide_alerts.sql	-544844344	dspace	2024-01-13 15:42:51.33062	5	t
61	7.6.2023.03.17	Remove unused sequence	SQL	V7.6_2023.03.17__Remove_unused_sequence.sql	-1998166894	dspace	2025-03-07 18:11:11.115389	19	t
62	7.6.2023.03.24	Update PNG in bitstream format registry	SQL	V7.6_2023.03.24__Update_PNG_in_bitstream_format_registry.sql	-2089109672	dspace	2025-03-07 18:11:11.171769	16	t
63	7.6.2023.03.29	orcid queue and history descriptions to text type	SQL	V7.6_2023.03.29__orcid_queue_and_history_descriptions_to_text_type.sql	-1132643521	dspace	2025-03-07 18:11:11.198904	10	t
64	7.6.2023.04.19	process parameters to text type	SQL	V7.6_2023.04.19__process_parameters_to_text_type.sql	199599750	dspace	2025-03-07 18:11:11.217914	3	t
65	7.6.2023.09.28	enforce group or eperson for resourcepolicy	SQL	V7.6_2023.09.28__enforce_group_or_eperson_for_resourcepolicy.sql	-1476787363	dspace	2025-03-07 18:11:11.227108	21	t
66	7.6.2023.10.12	Fix-deleted-primary-bitstreams	SQL	V7.6_2023.10.12__Fix-deleted-primary-bitstreams.sql	1024959027	dspace	2025-03-07 18:11:11.253142	27	t
67	7.6.2024.03.07	set eperson process nullable	SQL	V7.6_2024.03.07__set_eperson_process_nullable.sql	-1718815514	dspace	2025-03-07 18:11:11.287111	2	t
68	7.6.2024.05.07	process eperson constraint	SQL	V7.6_2024.05.07__process_eperson_constraint.sql	160958489	dspace	2025-03-07 18:11:11.296258	27	t
69	7.6.2024.12.17	workspaceitem add item id unique constraint	SQL	V7.6_2024.12.17__workspaceitem_add_item_id_unique_constraint.sql	1404983590	dspace	2025-03-07 18:11:11.330546	17	t
70	8.0.2023.08.07	qaevent processed	SQL	V8.0_2023.08.07__qaevent_processed.sql	1930444577	dspace	2025-03-07 18:11:11.354783	16	t
71	8.0.2024.02.14	ldn tables	SQL	V8.0_2024.02.14__ldn_tables.sql	-48491652	dspace	2025-03-07 18:11:11.378241	28	t
\.


--
-- Data for Name: site; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.site (uuid) FROM stdin;
23e54f59-2618-49fe-bb8c-7278e389948f
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.subscription (subscription_id, eperson_id, dspace_object_id, type) FROM stdin;
\.


--
-- Data for Name: subscription_parameter; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.subscription_parameter (subscription_parameter_id, name, value, subscription_id) FROM stdin;
\.


--
-- Data for Name: supervision_orders; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.supervision_orders (id, item_id, eperson_group_id) FROM stdin;
\.


--
-- Data for Name: systemwidealert; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.systemwidealert (alert_id, message, allow_sessions, countdown_to, active) FROM stdin;
\.


--
-- Data for Name: versionhistory; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.versionhistory (versionhistory_id) FROM stdin;
\.


--
-- Data for Name: versionitem; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.versionitem (versionitem_id, version_number, version_date, version_summary, versionhistory_id, eperson_id, item_id) FROM stdin;
\.


--
-- Data for Name: webapp; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.webapp (webapp_id, appname, url, started, isui) FROM stdin;
\.


--
-- Data for Name: workspaceitem; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.workspaceitem (workspace_item_id, multiple_titles, published_before, multiple_files, stage_reached, page_reached, item_id, collection_id) FROM stdin;
\.


--
-- Name: alert_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.alert_id_seq', 1, false);


--
-- Name: bitstreamformatregistry_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.bitstreamformatregistry_seq', 86, true);


--
-- Name: checksum_history_check_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.checksum_history_check_id_seq', 1, false);


--
-- Name: cwf_claimtask_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.cwf_claimtask_seq', 1, false);


--
-- Name: cwf_collectionrole_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.cwf_collectionrole_seq', 1, false);


--
-- Name: cwf_in_progress_user_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.cwf_in_progress_user_seq', 1, false);


--
-- Name: cwf_pooltask_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.cwf_pooltask_seq', 1, false);


--
-- Name: cwf_workflowitem_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.cwf_workflowitem_seq', 22, true);


--
-- Name: cwf_workflowitemrole_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.cwf_workflowitemrole_seq', 1, false);


--
-- Name: doi_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.doi_seq', 1, false);


--
-- Name: entity_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.entity_type_id_seq', 1, true);


--
-- Name: fileextension_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.fileextension_seq', 102, true);


--
-- Name: handle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.handle_id_seq', 447, true);


--
-- Name: handle_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.handle_seq', 446, true);


--
-- Name: harvested_collection_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.harvested_collection_seq', 1, false);


--
-- Name: harvested_item_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.harvested_item_seq', 1, false);


--
-- Name: metadatafieldregistry_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.metadatafieldregistry_seq', 305, true);


--
-- Name: metadataschemaregistry_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.metadataschemaregistry_seq', 23, true);


--
-- Name: metadatavalue_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.metadatavalue_seq', 7949, true);


--
-- Name: notifypatterns_to_trigger_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.notifypatterns_to_trigger_id_seq', 1, false);


--
-- Name: notifyservice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.notifyservice_id_seq', 1, false);


--
-- Name: notifyservice_inbound_pattern_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.notifyservice_inbound_pattern_id_seq', 1, false);


--
-- Name: openurltracker_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.openurltracker_seq', 1, false);


--
-- Name: orcid_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.orcid_history_id_seq', 1, false);


--
-- Name: orcid_queue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.orcid_queue_id_seq', 1, false);


--
-- Name: orcid_token_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.orcid_token_id_seq', 1, false);


--
-- Name: process_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.process_id_seq', 42, true);


--
-- Name: registrationdata_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.registrationdata_seq', 22, true);


--
-- Name: relationship_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.relationship_id_seq', 1, false);


--
-- Name: relationship_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.relationship_type_id_seq', 1, false);


--
-- Name: requestitem_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.requestitem_seq', 1, false);


--
-- Name: resourcepolicy_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.resourcepolicy_seq', 10739, true);


--
-- Name: subscription_parameter_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.subscription_parameter_seq', 1, false);


--
-- Name: subscription_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.subscription_seq', 1, false);


--
-- Name: supervision_orders_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.supervision_orders_seq', 1, false);


--
-- Name: versionhistory_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.versionhistory_seq', 1, false);


--
-- Name: versionitem_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.versionitem_seq', 1, false);


--
-- Name: webapp_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.webapp_seq', 1, false);


--
-- Name: workspaceitem_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.workspaceitem_seq', 511, true);


--
-- Name: bitstream bitstream_id_unique; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bitstream
    ADD CONSTRAINT bitstream_id_unique UNIQUE (uuid);


--
-- Name: bitstream bitstream_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bitstream
    ADD CONSTRAINT bitstream_pkey PRIMARY KEY (uuid);


--
-- Name: bitstream bitstream_uuid_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bitstream
    ADD CONSTRAINT bitstream_uuid_key UNIQUE (uuid);


--
-- Name: bitstreamformatregistry bitstreamformatregistry_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bitstreamformatregistry
    ADD CONSTRAINT bitstreamformatregistry_pkey PRIMARY KEY (bitstream_format_id);


--
-- Name: bitstreamformatregistry bitstreamformatregistry_short_description_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bitstreamformatregistry
    ADD CONSTRAINT bitstreamformatregistry_short_description_key UNIQUE (short_description);


--
-- Name: bundle2bitstream bundle2bitstream_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bundle2bitstream
    ADD CONSTRAINT bundle2bitstream_pkey PRIMARY KEY (bitstream_id, bundle_id, bitstream_order);


--
-- Name: bundle bundle_id_unique; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bundle
    ADD CONSTRAINT bundle_id_unique UNIQUE (uuid);


--
-- Name: bundle bundle_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bundle
    ADD CONSTRAINT bundle_pkey PRIMARY KEY (uuid);


--
-- Name: bundle bundle_uuid_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bundle
    ADD CONSTRAINT bundle_uuid_key UNIQUE (uuid);


--
-- Name: checksum_history checksum_history_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.checksum_history
    ADD CONSTRAINT checksum_history_pkey PRIMARY KEY (check_id);


--
-- Name: checksum_results checksum_results_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.checksum_results
    ADD CONSTRAINT checksum_results_pkey PRIMARY KEY (result_code);


--
-- Name: collection2item collection2item_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.collection2item
    ADD CONSTRAINT collection2item_pkey PRIMARY KEY (collection_id, item_id);


--
-- Name: collection collection_id_unique; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_id_unique UNIQUE (uuid);


--
-- Name: collection collection_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_pkey PRIMARY KEY (uuid);


--
-- Name: collection collection_uuid_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_uuid_key UNIQUE (uuid);


--
-- Name: community2collection community2collection_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community2collection
    ADD CONSTRAINT community2collection_pkey PRIMARY KEY (collection_id, community_id);


--
-- Name: community2community community2community_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community2community
    ADD CONSTRAINT community2community_pkey PRIMARY KEY (parent_comm_id, child_comm_id);


--
-- Name: community community_id_unique; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community
    ADD CONSTRAINT community_id_unique UNIQUE (uuid);


--
-- Name: community community_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community
    ADD CONSTRAINT community_pkey PRIMARY KEY (uuid);


--
-- Name: community community_uuid_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community
    ADD CONSTRAINT community_uuid_key UNIQUE (uuid);


--
-- Name: cwf_claimtask cwf_claimtask_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.cwf_claimtask
    ADD CONSTRAINT cwf_claimtask_pkey PRIMARY KEY (claimtask_id);


--
-- Name: cwf_collectionrole cwf_collectionrole_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.cwf_collectionrole
    ADD CONSTRAINT cwf_collectionrole_pkey PRIMARY KEY (collectionrole_id);


--
-- Name: cwf_in_progress_user cwf_in_progress_user_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.cwf_in_progress_user
    ADD CONSTRAINT cwf_in_progress_user_pkey PRIMARY KEY (in_progress_user_id);


--
-- Name: cwf_pooltask cwf_pooltask_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.cwf_pooltask
    ADD CONSTRAINT cwf_pooltask_pkey PRIMARY KEY (pooltask_id);


--
-- Name: cwf_workflowitem cwf_workflowitem_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.cwf_workflowitem
    ADD CONSTRAINT cwf_workflowitem_pkey PRIMARY KEY (workflowitem_id);


--
-- Name: cwf_workflowitemrole cwf_workflowitemrole_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.cwf_workflowitemrole
    ADD CONSTRAINT cwf_workflowitemrole_pkey PRIMARY KEY (workflowitemrole_id);


--
-- Name: doi doi_doi_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.doi
    ADD CONSTRAINT doi_doi_key UNIQUE (doi);


--
-- Name: doi doi_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.doi
    ADD CONSTRAINT doi_pkey PRIMARY KEY (doi_id);


--
-- Name: dspaceobject dspaceobject_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.dspaceobject
    ADD CONSTRAINT dspaceobject_pkey PRIMARY KEY (uuid);


--
-- Name: entity_type entity_type_label_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.entity_type
    ADD CONSTRAINT entity_type_label_key UNIQUE (label);


--
-- Name: entity_type entity_type_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.entity_type
    ADD CONSTRAINT entity_type_pkey PRIMARY KEY (id);


--
-- Name: eperson eperson_email_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.eperson
    ADD CONSTRAINT eperson_email_key UNIQUE (email);


--
-- Name: eperson eperson_id_unique; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.eperson
    ADD CONSTRAINT eperson_id_unique UNIQUE (uuid);


--
-- Name: eperson eperson_netid_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.eperson
    ADD CONSTRAINT eperson_netid_key UNIQUE (netid);


--
-- Name: eperson eperson_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.eperson
    ADD CONSTRAINT eperson_pkey PRIMARY KEY (uuid);


--
-- Name: eperson eperson_uuid_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.eperson
    ADD CONSTRAINT eperson_uuid_key UNIQUE (uuid);


--
-- Name: epersongroup2eperson epersongroup2eperson_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.epersongroup2eperson
    ADD CONSTRAINT epersongroup2eperson_pkey PRIMARY KEY (eperson_group_id, eperson_id);


--
-- Name: epersongroup epersongroup_id_unique; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.epersongroup
    ADD CONSTRAINT epersongroup_id_unique UNIQUE (uuid);


--
-- Name: epersongroup epersongroup_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.epersongroup
    ADD CONSTRAINT epersongroup_pkey PRIMARY KEY (uuid);


--
-- Name: epersongroup epersongroup_uuid_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.epersongroup
    ADD CONSTRAINT epersongroup_uuid_key UNIQUE (uuid);


--
-- Name: fileextension fileextension_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.fileextension
    ADD CONSTRAINT fileextension_pkey PRIMARY KEY (file_extension_id);


--
-- Name: group2group group2group_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.group2group
    ADD CONSTRAINT group2group_pkey PRIMARY KEY (parent_id, child_id);


--
-- Name: group2groupcache group2groupcache_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.group2groupcache
    ADD CONSTRAINT group2groupcache_pkey PRIMARY KEY (parent_id, child_id);


--
-- Name: handle handle_handle_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.handle
    ADD CONSTRAINT handle_handle_key UNIQUE (handle);


--
-- Name: handle handle_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.handle
    ADD CONSTRAINT handle_pkey PRIMARY KEY (handle_id);


--
-- Name: harvested_collection harvested_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.harvested_collection
    ADD CONSTRAINT harvested_collection_pkey PRIMARY KEY (id);


--
-- Name: harvested_item harvested_item_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.harvested_item
    ADD CONSTRAINT harvested_item_pkey PRIMARY KEY (id);


--
-- Name: item2bundle item2bundle_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.item2bundle
    ADD CONSTRAINT item2bundle_pkey PRIMARY KEY (bundle_id, item_id);


--
-- Name: item item_id_unique; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_id_unique UNIQUE (uuid);


--
-- Name: item item_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_pkey PRIMARY KEY (uuid);


--
-- Name: item item_uuid_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_uuid_key UNIQUE (uuid);


--
-- Name: ldn_message ldn_message_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.ldn_message
    ADD CONSTRAINT ldn_message_pkey PRIMARY KEY (id);


--
-- Name: notifyservice ldn_url_unique; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.notifyservice
    ADD CONSTRAINT ldn_url_unique UNIQUE (ldn_url);


--
-- Name: metadatafieldregistry metadatafieldregistry_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.metadatafieldregistry
    ADD CONSTRAINT metadatafieldregistry_pkey PRIMARY KEY (metadata_field_id);


--
-- Name: metadataschemaregistry metadataschemaregistry_namespace_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.metadataschemaregistry
    ADD CONSTRAINT metadataschemaregistry_namespace_key UNIQUE (namespace);


--
-- Name: metadataschemaregistry metadataschemaregistry_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.metadataschemaregistry
    ADD CONSTRAINT metadataschemaregistry_pkey PRIMARY KEY (metadata_schema_id);


--
-- Name: metadatavalue metadatavalue_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.metadatavalue
    ADD CONSTRAINT metadatavalue_pkey PRIMARY KEY (metadata_value_id);


--
-- Name: notifypatterns_to_trigger notifypatterns_to_trigger_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.notifypatterns_to_trigger
    ADD CONSTRAINT notifypatterns_to_trigger_pkey PRIMARY KEY (id);


--
-- Name: notifyservice_inbound_pattern notifyservice_inbound_pattern_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.notifyservice_inbound_pattern
    ADD CONSTRAINT notifyservice_inbound_pattern_pkey PRIMARY KEY (id);


--
-- Name: notifyservice notifyservice_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.notifyservice
    ADD CONSTRAINT notifyservice_pkey PRIMARY KEY (id);


--
-- Name: openurltracker openurltracker_pk; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.openurltracker
    ADD CONSTRAINT openurltracker_pk PRIMARY KEY (tracker_id);


--
-- Name: orcid_history orcid_history_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.orcid_history
    ADD CONSTRAINT orcid_history_pkey PRIMARY KEY (id);


--
-- Name: orcid_queue orcid_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.orcid_queue
    ADD CONSTRAINT orcid_queue_pkey PRIMARY KEY (id);


--
-- Name: orcid_token orcid_token_eperson_id_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.orcid_token
    ADD CONSTRAINT orcid_token_eperson_id_key UNIQUE (eperson_id);


--
-- Name: orcid_token orcid_token_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.orcid_token
    ADD CONSTRAINT orcid_token_pkey PRIMARY KEY (id);


--
-- Name: process2bitstream pk_process2bitstream; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.process2bitstream
    ADD CONSTRAINT pk_process2bitstream PRIMARY KEY (process_id, bitstream_id);


--
-- Name: process2group pk_process2group; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.process2group
    ADD CONSTRAINT pk_process2group PRIMARY KEY (process_id, group_id);


--
-- Name: process process_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.process
    ADD CONSTRAINT process_pkey PRIMARY KEY (process_id);


--
-- Name: qaevent_processed qaevent_pk; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.qaevent_processed
    ADD CONSTRAINT qaevent_pk PRIMARY KEY (qaevent_id);


--
-- Name: registrationdata registrationdata_email_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.registrationdata
    ADD CONSTRAINT registrationdata_email_key UNIQUE (email);


--
-- Name: registrationdata registrationdata_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.registrationdata
    ADD CONSTRAINT registrationdata_pkey PRIMARY KEY (registrationdata_id);


--
-- Name: relationship relationship_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.relationship
    ADD CONSTRAINT relationship_pkey PRIMARY KEY (id);


--
-- Name: relationship_type relationship_type_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.relationship_type
    ADD CONSTRAINT relationship_type_pkey PRIMARY KEY (id);


--
-- Name: requestitem requestitem_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.requestitem
    ADD CONSTRAINT requestitem_pkey PRIMARY KEY (requestitem_id);


--
-- Name: requestitem requestitem_token_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.requestitem
    ADD CONSTRAINT requestitem_token_key UNIQUE (token);


--
-- Name: resourcepolicy resourcepolicy_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.resourcepolicy
    ADD CONSTRAINT resourcepolicy_pkey PRIMARY KEY (policy_id);


--
-- Name: schema_version schema_version_pk; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.schema_version
    ADD CONSTRAINT schema_version_pk PRIMARY KEY (installed_rank);


--
-- Name: site site_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.site
    ADD CONSTRAINT site_pkey PRIMARY KEY (uuid);


--
-- Name: subscription_parameter subscription_parameter_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.subscription_parameter
    ADD CONSTRAINT subscription_parameter_pkey PRIMARY KEY (subscription_parameter_id);


--
-- Name: subscription subscription_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.subscription
    ADD CONSTRAINT subscription_pkey PRIMARY KEY (subscription_id);


--
-- Name: supervision_orders supervision_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.supervision_orders
    ADD CONSTRAINT supervision_orders_pkey PRIMARY KEY (id);


--
-- Name: systemwidealert systemwidealert_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.systemwidealert
    ADD CONSTRAINT systemwidealert_pkey PRIMARY KEY (alert_id);


--
-- Name: relationship u_constraint; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.relationship
    ADD CONSTRAINT u_constraint UNIQUE (left_id, type_id, right_id);


--
-- Name: relationship_type u_relationship_type_constraint; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.relationship_type
    ADD CONSTRAINT u_relationship_type_constraint UNIQUE (left_type, right_type, leftward_type, rightward_type);


--
-- Name: workspaceitem unique_item_id; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.workspaceitem
    ADD CONSTRAINT unique_item_id UNIQUE (item_id);


--
-- Name: versionhistory versionhistory_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.versionhistory
    ADD CONSTRAINT versionhistory_pkey PRIMARY KEY (versionhistory_id);


--
-- Name: versionitem versionitem_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.versionitem
    ADD CONSTRAINT versionitem_pkey PRIMARY KEY (versionitem_id);


--
-- Name: webapp webapp_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.webapp
    ADD CONSTRAINT webapp_pkey PRIMARY KEY (webapp_id);


--
-- Name: workspaceitem workspaceitem_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.workspaceitem
    ADD CONSTRAINT workspaceitem_pkey PRIMARY KEY (workspace_item_id);


--
-- Name: bit_bitstream_fk_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX bit_bitstream_fk_idx ON public.bitstream USING btree (bitstream_format_id);


--
-- Name: bitstream_id_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX bitstream_id_idx ON public.bitstream USING btree (bitstream_id);


--
-- Name: bundle2bitstream_bitstream; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX bundle2bitstream_bitstream ON public.bundle2bitstream USING btree (bitstream_id);


--
-- Name: bundle2bitstream_bundle; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX bundle2bitstream_bundle ON public.bundle2bitstream USING btree (bundle_id);


--
-- Name: bundle_id_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX bundle_id_idx ON public.bundle USING btree (bundle_id);


--
-- Name: bundle_primary; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX bundle_primary ON public.bundle USING btree (primary_bitstream_id);


--
-- Name: ch_result_fk_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX ch_result_fk_idx ON public.checksum_history USING btree (result);


--
-- Name: checksum_history_bitstream; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX checksum_history_bitstream ON public.checksum_history USING btree (bitstream_id);


--
-- Name: collecion2item_collection; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX collecion2item_collection ON public.collection2item USING btree (collection_id);


--
-- Name: collecion2item_item; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX collecion2item_item ON public.collection2item USING btree (item_id);


--
-- Name: collection_bitstream; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX collection_bitstream ON public.collection USING btree (logo_bitstream_id);


--
-- Name: collection_id_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX collection_id_idx ON public.collection USING btree (collection_id);


--
-- Name: collection_submitter; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX collection_submitter ON public.collection USING btree (submitter);


--
-- Name: collection_template; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX collection_template ON public.collection USING btree (template_item_id);


--
-- Name: community2collection_collection; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX community2collection_collection ON public.community2collection USING btree (collection_id);


--
-- Name: community2collection_community; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX community2collection_community ON public.community2collection USING btree (community_id);


--
-- Name: community2community_child; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX community2community_child ON public.community2community USING btree (child_comm_id);


--
-- Name: community2community_parent; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX community2community_parent ON public.community2community USING btree (parent_comm_id);


--
-- Name: community_admin; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX community_admin ON public.community USING btree (admin);


--
-- Name: community_bitstream; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX community_bitstream ON public.community USING btree (logo_bitstream_id);


--
-- Name: community_id_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX community_id_idx ON public.community USING btree (community_id);


--
-- Name: cwf_claimtask_workflow_fk_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX cwf_claimtask_workflow_fk_idx ON public.cwf_claimtask USING btree (workflowitem_id);


--
-- Name: cwf_claimtask_workflow_step_action_fk_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX cwf_claimtask_workflow_step_action_fk_idx ON public.cwf_claimtask USING btree (workflowitem_id, step_id, action_id);


--
-- Name: cwf_claimtask_workflow_step_fk_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX cwf_claimtask_workflow_step_fk_idx ON public.cwf_claimtask USING btree (workflowitem_id, step_id);


--
-- Name: cwf_in_progress_user_workflow_fk_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX cwf_in_progress_user_workflow_fk_idx ON public.cwf_in_progress_user USING btree (workflowitem_id);


--
-- Name: cwf_pooltask_workflow_fk_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX cwf_pooltask_workflow_fk_idx ON public.cwf_pooltask USING btree (workflowitem_id);


--
-- Name: cwf_workflowitemrole_item_fk_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX cwf_workflowitemrole_item_fk_idx ON public.cwf_workflowitemrole USING btree (workflowitem_id);


--
-- Name: cwf_workflowitemrole_item_role_fk_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX cwf_workflowitemrole_item_role_fk_idx ON public.cwf_workflowitemrole USING btree (workflowitem_id, role_id);


--
-- Name: doi_doi_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX doi_doi_idx ON public.doi USING btree (doi);


--
-- Name: doi_object; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX doi_object ON public.doi USING btree (dspace_object);


--
-- Name: doi_resource_id_and_type_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX doi_resource_id_and_type_idx ON public.doi USING btree (resource_id, resource_type_id);


--
-- Name: entity_type_label_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX entity_type_label_idx ON public.entity_type USING btree (label);


--
-- Name: eperson_email_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX eperson_email_idx ON public.eperson USING btree (email);


--
-- Name: eperson_group_id_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX eperson_group_id_idx ON public.epersongroup USING btree (eperson_group_id);


--
-- Name: eperson_id_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX eperson_id_idx ON public.eperson USING btree (eperson_id);


--
-- Name: epersongroup2eperson_group; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX epersongroup2eperson_group ON public.epersongroup2eperson USING btree (eperson_group_id);


--
-- Name: epersongroup2eperson_person; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX epersongroup2eperson_person ON public.epersongroup2eperson USING btree (eperson_id);


--
-- Name: epersongroup_unique_idx_name; Type: INDEX; Schema: public; Owner: dspace
--

CREATE UNIQUE INDEX epersongroup_unique_idx_name ON public.epersongroup USING btree (name);


--
-- Name: fe_bitstream_fk_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX fe_bitstream_fk_idx ON public.fileextension USING btree (bitstream_format_id);


--
-- Name: group2group_child; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX group2group_child ON public.group2group USING btree (child_id);


--
-- Name: group2group_parent; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX group2group_parent ON public.group2group USING btree (parent_id);


--
-- Name: group2groupcache_child; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX group2groupcache_child ON public.group2groupcache USING btree (child_id);


--
-- Name: group2groupcache_parent; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX group2groupcache_parent ON public.group2groupcache USING btree (parent_id);


--
-- Name: handle_handle_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX handle_handle_idx ON public.handle USING btree (handle);


--
-- Name: handle_object; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX handle_object ON public.handle USING btree (resource_id);


--
-- Name: handle_resource_id_and_type_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX handle_resource_id_and_type_idx ON public.handle USING btree (resource_legacy_id, resource_type_id);


--
-- Name: harvested_collection_collection; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX harvested_collection_collection ON public.harvested_collection USING btree (collection_id);


--
-- Name: harvested_item_item; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX harvested_item_item ON public.harvested_item USING btree (item_id);


--
-- Name: item2bundle_bundle; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX item2bundle_bundle ON public.item2bundle USING btree (bundle_id);


--
-- Name: item2bundle_item; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX item2bundle_item ON public.item2bundle USING btree (item_id);


--
-- Name: item_collection; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX item_collection ON public.item USING btree (owning_collection);


--
-- Name: item_id_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX item_id_idx ON public.item USING btree (item_id);


--
-- Name: item_submitter; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX item_submitter ON public.item USING btree (submitter_id);


--
-- Name: item_uuid_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX item_uuid_idx ON public.qaevent_processed USING btree (item_uuid);


--
-- Name: metadatafield_schema_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX metadatafield_schema_idx ON public.metadatafieldregistry USING btree (metadata_schema_id);


--
-- Name: metadatafieldregistry_idx_element_qualifier; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX metadatafieldregistry_idx_element_qualifier ON public.metadatafieldregistry USING btree (element, qualifier);


--
-- Name: metadataschemaregistry_unique_idx_short_id; Type: INDEX; Schema: public; Owner: dspace
--

CREATE UNIQUE INDEX metadataschemaregistry_unique_idx_short_id ON public.metadataschemaregistry USING btree (short_id);


--
-- Name: metadatavalue_field_fk_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX metadatavalue_field_fk_idx ON public.metadatavalue USING btree (metadata_field_id);


--
-- Name: metadatavalue_field_object; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX metadatavalue_field_object ON public.metadatavalue USING btree (metadata_field_id, dspace_object_id);


--
-- Name: metadatavalue_object; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX metadatavalue_object ON public.metadatavalue USING btree (dspace_object_id);


--
-- Name: most_recent_checksum_bitstream; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX most_recent_checksum_bitstream ON public.most_recent_checksum USING btree (bitstream_id);


--
-- Name: mrc_result_fk_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX mrc_result_fk_idx ON public.most_recent_checksum USING btree (result);


--
-- Name: notifypatterns_to_trigger_item_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX notifypatterns_to_trigger_item_idx ON public.notifypatterns_to_trigger USING btree (item_id);


--
-- Name: notifypatterns_to_trigger_service_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX notifypatterns_to_trigger_service_idx ON public.notifypatterns_to_trigger USING btree (service_id);


--
-- Name: notifyservice_inbound_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX notifyservice_inbound_idx ON public.notifyservice_inbound_pattern USING btree (service_id);


--
-- Name: orcid_history_owner_id_index; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX orcid_history_owner_id_index ON public.orcid_history USING btree (owner_id);


--
-- Name: orcid_queue_owner_id_index; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX orcid_queue_owner_id_index ON public.orcid_queue USING btree (owner_id);


--
-- Name: process_name_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX process_name_idx ON public.process USING btree (script);


--
-- Name: process_start_time_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX process_start_time_idx ON public.process USING btree (start_time);


--
-- Name: process_status_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX process_status_idx ON public.process USING btree (status);


--
-- Name: process_user_id_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX process_user_id_idx ON public.process USING btree (user_id);


--
-- Name: relationship_by_left_id_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX relationship_by_left_id_idx ON public.relationship USING btree (left_id);


--
-- Name: relationship_by_right_id_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX relationship_by_right_id_idx ON public.relationship USING btree (right_id);


--
-- Name: relationship_type_by_left_label_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX relationship_type_by_left_label_idx ON public.relationship_type USING btree (leftward_type);


--
-- Name: relationship_type_by_left_type_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX relationship_type_by_left_type_idx ON public.relationship_type USING btree (left_type);


--
-- Name: relationship_type_by_right_label_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX relationship_type_by_right_label_idx ON public.relationship_type USING btree (rightward_type);


--
-- Name: relationship_type_by_right_type_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX relationship_type_by_right_type_idx ON public.relationship_type USING btree (right_type);


--
-- Name: requestitem_bitstream; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX requestitem_bitstream ON public.requestitem USING btree (bitstream_id);


--
-- Name: requestitem_item; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX requestitem_item ON public.requestitem USING btree (item_id);


--
-- Name: resourcepolicy_action_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX resourcepolicy_action_idx ON public.resourcepolicy USING btree (action_id);


--
-- Name: resourcepolicy_group; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX resourcepolicy_group ON public.resourcepolicy USING btree (epersongroup_id);


--
-- Name: resourcepolicy_idx_rptype; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX resourcepolicy_idx_rptype ON public.resourcepolicy USING btree (rptype);


--
-- Name: resourcepolicy_object; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX resourcepolicy_object ON public.resourcepolicy USING btree (dspace_object);


--
-- Name: resourcepolicy_person; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX resourcepolicy_person ON public.resourcepolicy USING btree (eperson_id);


--
-- Name: resourcepolicy_type_id_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX resourcepolicy_type_id_idx ON public.resourcepolicy USING btree (resource_type_id, resource_id);


--
-- Name: schema_version_s_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX schema_version_s_idx ON public.schema_version USING btree (success);


--
-- Name: subscription_person; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX subscription_person ON public.subscription USING btree (eperson_id);


--
-- Name: versionitem_item; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX versionitem_item ON public.versionitem USING btree (item_id);


--
-- Name: versionitem_person; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX versionitem_person ON public.versionitem USING btree (eperson_id);


--
-- Name: workspaceitem_coll; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX workspaceitem_coll ON public.workspaceitem USING btree (collection_id);


--
-- Name: workspaceitem_item; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX workspaceitem_item ON public.workspaceitem USING btree (item_id);


--
-- Name: bitstream bitstream_bitstream_format_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bitstream
    ADD CONSTRAINT bitstream_bitstream_format_id_fkey FOREIGN KEY (bitstream_format_id) REFERENCES public.bitstreamformatregistry(bitstream_format_id);


--
-- Name: bitstream bitstream_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bitstream
    ADD CONSTRAINT bitstream_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: bundle2bitstream bundle2bitstream_bitstream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bundle2bitstream
    ADD CONSTRAINT bundle2bitstream_bitstream_id_fkey FOREIGN KEY (bitstream_id) REFERENCES public.bitstream(uuid);


--
-- Name: bundle2bitstream bundle2bitstream_bundle_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bundle2bitstream
    ADD CONSTRAINT bundle2bitstream_bundle_id_fkey FOREIGN KEY (bundle_id) REFERENCES public.bundle(uuid);


--
-- Name: bundle bundle_primary_bitstream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bundle
    ADD CONSTRAINT bundle_primary_bitstream_id_fkey FOREIGN KEY (primary_bitstream_id) REFERENCES public.bitstream(uuid);


--
-- Name: bundle bundle_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bundle
    ADD CONSTRAINT bundle_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: checksum_history checksum_history_bitstream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.checksum_history
    ADD CONSTRAINT checksum_history_bitstream_id_fkey FOREIGN KEY (bitstream_id) REFERENCES public.bitstream(uuid);


--
-- Name: checksum_history checksum_history_result_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.checksum_history
    ADD CONSTRAINT checksum_history_result_fkey FOREIGN KEY (result) REFERENCES public.checksum_results(result_code);


--
-- Name: collection2item collection2item_collection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.collection2item
    ADD CONSTRAINT collection2item_collection_id_fkey FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: collection2item collection2item_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.collection2item
    ADD CONSTRAINT collection2item_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- Name: collection collection_admin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_admin_fkey FOREIGN KEY (admin) REFERENCES public.epersongroup(uuid);


--
-- Name: collection collection_submitter_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_submitter_fkey FOREIGN KEY (submitter) REFERENCES public.epersongroup(uuid);


--
-- Name: collection collection_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: community2collection community2collection_collection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community2collection
    ADD CONSTRAINT community2collection_collection_id_fkey FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: community2collection community2collection_community_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community2collection
    ADD CONSTRAINT community2collection_community_id_fkey FOREIGN KEY (community_id) REFERENCES public.community(uuid);


--
-- Name: community2community community2community_child_comm_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community2community
    ADD CONSTRAINT community2community_child_comm_id_fkey FOREIGN KEY (child_comm_id) REFERENCES public.community(uuid);


--
-- Name: community2community community2community_parent_comm_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community2community
    ADD CONSTRAINT community2community_parent_comm_id_fkey FOREIGN KEY (parent_comm_id) REFERENCES public.community(uuid);


--
-- Name: community community_admin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community
    ADD CONSTRAINT community_admin_fkey FOREIGN KEY (admin) REFERENCES public.epersongroup(uuid);


--
-- Name: community community_logo_bitstream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community
    ADD CONSTRAINT community_logo_bitstream_id_fkey FOREIGN KEY (logo_bitstream_id) REFERENCES public.bitstream(uuid);


--
-- Name: community community_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community
    ADD CONSTRAINT community_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: cwf_claimtask cwf_claimtask_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.cwf_claimtask
    ADD CONSTRAINT cwf_claimtask_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.eperson(uuid);


--
-- Name: cwf_claimtask cwf_claimtask_workflowitem_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.cwf_claimtask
    ADD CONSTRAINT cwf_claimtask_workflowitem_id_fkey FOREIGN KEY (workflowitem_id) REFERENCES public.cwf_workflowitem(workflowitem_id);


--
-- Name: cwf_collectionrole cwf_collectionrole_collection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.cwf_collectionrole
    ADD CONSTRAINT cwf_collectionrole_collection_id_fkey FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: cwf_collectionrole cwf_collectionrole_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.cwf_collectionrole
    ADD CONSTRAINT cwf_collectionrole_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.epersongroup(uuid);


--
-- Name: cwf_in_progress_user cwf_in_progress_user_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.cwf_in_progress_user
    ADD CONSTRAINT cwf_in_progress_user_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.eperson(uuid);


--
-- Name: cwf_in_progress_user cwf_in_progress_user_workflowitem_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.cwf_in_progress_user
    ADD CONSTRAINT cwf_in_progress_user_workflowitem_id_fkey FOREIGN KEY (workflowitem_id) REFERENCES public.cwf_workflowitem(workflowitem_id);


--
-- Name: cwf_pooltask cwf_pooltask_eperson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.cwf_pooltask
    ADD CONSTRAINT cwf_pooltask_eperson_id_fkey FOREIGN KEY (eperson_id) REFERENCES public.eperson(uuid);


--
-- Name: cwf_pooltask cwf_pooltask_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.cwf_pooltask
    ADD CONSTRAINT cwf_pooltask_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.epersongroup(uuid);


--
-- Name: cwf_pooltask cwf_pooltask_workflowitem_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.cwf_pooltask
    ADD CONSTRAINT cwf_pooltask_workflowitem_id_fkey FOREIGN KEY (workflowitem_id) REFERENCES public.cwf_workflowitem(workflowitem_id);


--
-- Name: cwf_workflowitem cwf_workflowitem_collection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.cwf_workflowitem
    ADD CONSTRAINT cwf_workflowitem_collection_id_fkey FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: cwf_workflowitem cwf_workflowitem_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.cwf_workflowitem
    ADD CONSTRAINT cwf_workflowitem_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- Name: cwf_workflowitemrole cwf_workflowitemrole_eperson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.cwf_workflowitemrole
    ADD CONSTRAINT cwf_workflowitemrole_eperson_id_fkey FOREIGN KEY (eperson_id) REFERENCES public.eperson(uuid);


--
-- Name: cwf_workflowitemrole cwf_workflowitemrole_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.cwf_workflowitemrole
    ADD CONSTRAINT cwf_workflowitemrole_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.epersongroup(uuid);


--
-- Name: cwf_workflowitemrole cwf_workflowitemrole_workflowitem_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.cwf_workflowitemrole
    ADD CONSTRAINT cwf_workflowitemrole_workflowitem_id_fkey FOREIGN KEY (workflowitem_id) REFERENCES public.cwf_workflowitem(workflowitem_id);


--
-- Name: doi doi_dspace_object_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.doi
    ADD CONSTRAINT doi_dspace_object_fkey FOREIGN KEY (dspace_object) REFERENCES public.dspaceobject(uuid);


--
-- Name: eperson eperson_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.eperson
    ADD CONSTRAINT eperson_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: qaevent_processed eperson_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.qaevent_processed
    ADD CONSTRAINT eperson_uuid_fkey FOREIGN KEY (eperson_uuid) REFERENCES public.eperson(uuid);


--
-- Name: epersongroup2eperson epersongroup2eperson_eperson_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.epersongroup2eperson
    ADD CONSTRAINT epersongroup2eperson_eperson_group_id_fkey FOREIGN KEY (eperson_group_id) REFERENCES public.epersongroup(uuid);


--
-- Name: epersongroup2eperson epersongroup2eperson_eperson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.epersongroup2eperson
    ADD CONSTRAINT epersongroup2eperson_eperson_id_fkey FOREIGN KEY (eperson_id) REFERENCES public.eperson(uuid);


--
-- Name: epersongroup epersongroup_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.epersongroup
    ADD CONSTRAINT epersongroup_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: fileextension fileextension_bitstream_format_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.fileextension
    ADD CONSTRAINT fileextension_bitstream_format_id_fkey FOREIGN KEY (bitstream_format_id) REFERENCES public.bitstreamformatregistry(bitstream_format_id);


--
-- Name: group2group group2group_child_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.group2group
    ADD CONSTRAINT group2group_child_id_fkey FOREIGN KEY (child_id) REFERENCES public.epersongroup(uuid);


--
-- Name: group2group group2group_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.group2group
    ADD CONSTRAINT group2group_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.epersongroup(uuid);


--
-- Name: group2groupcache group2groupcache_child_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.group2groupcache
    ADD CONSTRAINT group2groupcache_child_id_fkey FOREIGN KEY (child_id) REFERENCES public.epersongroup(uuid);


--
-- Name: group2groupcache group2groupcache_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.group2groupcache
    ADD CONSTRAINT group2groupcache_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.epersongroup(uuid);


--
-- Name: handle handle_resource_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.handle
    ADD CONSTRAINT handle_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES public.dspaceobject(uuid);


--
-- Name: harvested_collection harvested_collection_collection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.harvested_collection
    ADD CONSTRAINT harvested_collection_collection_id_fkey FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: harvested_item harvested_item_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.harvested_item
    ADD CONSTRAINT harvested_item_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- Name: item2bundle item2bundle_bundle_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.item2bundle
    ADD CONSTRAINT item2bundle_bundle_id_fkey FOREIGN KEY (bundle_id) REFERENCES public.bundle(uuid);


--
-- Name: item2bundle item2bundle_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.item2bundle
    ADD CONSTRAINT item2bundle_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- Name: item item_owning_collection_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_owning_collection_fkey FOREIGN KEY (owning_collection) REFERENCES public.collection(uuid);


--
-- Name: item item_submitter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_submitter_id_fkey FOREIGN KEY (submitter_id) REFERENCES public.eperson(uuid);


--
-- Name: item item_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: qaevent_processed item_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.qaevent_processed
    ADD CONSTRAINT item_uuid_fkey FOREIGN KEY (item_uuid) REFERENCES public.item(uuid);


--
-- Name: ldn_message ldn_message_context_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.ldn_message
    ADD CONSTRAINT ldn_message_context_fkey FOREIGN KEY (context) REFERENCES public.dspaceobject(uuid) ON DELETE SET NULL;


--
-- Name: ldn_message ldn_message_inreplyto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.ldn_message
    ADD CONSTRAINT ldn_message_inreplyto_fkey FOREIGN KEY (inreplyto) REFERENCES public.ldn_message(id) ON DELETE SET NULL;


--
-- Name: ldn_message ldn_message_object_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.ldn_message
    ADD CONSTRAINT ldn_message_object_fkey FOREIGN KEY (object) REFERENCES public.dspaceobject(uuid) ON DELETE SET NULL;


--
-- Name: ldn_message ldn_message_origin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.ldn_message
    ADD CONSTRAINT ldn_message_origin_fkey FOREIGN KEY (origin) REFERENCES public.notifyservice(id) ON DELETE SET NULL;


--
-- Name: ldn_message ldn_message_target_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.ldn_message
    ADD CONSTRAINT ldn_message_target_fkey FOREIGN KEY (target) REFERENCES public.notifyservice(id) ON DELETE SET NULL;


--
-- Name: metadatafieldregistry metadatafieldregistry_metadata_schema_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.metadatafieldregistry
    ADD CONSTRAINT metadatafieldregistry_metadata_schema_id_fkey FOREIGN KEY (metadata_schema_id) REFERENCES public.metadataschemaregistry(metadata_schema_id);


--
-- Name: metadatavalue metadatavalue_dspace_object_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.metadatavalue
    ADD CONSTRAINT metadatavalue_dspace_object_id_fkey FOREIGN KEY (dspace_object_id) REFERENCES public.dspaceobject(uuid) ON DELETE CASCADE;


--
-- Name: metadatavalue metadatavalue_metadata_field_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.metadatavalue
    ADD CONSTRAINT metadatavalue_metadata_field_id_fkey FOREIGN KEY (metadata_field_id) REFERENCES public.metadatafieldregistry(metadata_field_id);


--
-- Name: most_recent_checksum most_recent_checksum_bitstream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.most_recent_checksum
    ADD CONSTRAINT most_recent_checksum_bitstream_id_fkey FOREIGN KEY (bitstream_id) REFERENCES public.bitstream(uuid);


--
-- Name: most_recent_checksum most_recent_checksum_result_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.most_recent_checksum
    ADD CONSTRAINT most_recent_checksum_result_fkey FOREIGN KEY (result) REFERENCES public.checksum_results(result_code);


--
-- Name: notifypatterns_to_trigger notifypatterns_to_trigger_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.notifypatterns_to_trigger
    ADD CONSTRAINT notifypatterns_to_trigger_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid) ON DELETE CASCADE;


--
-- Name: notifypatterns_to_trigger notifypatterns_to_trigger_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.notifypatterns_to_trigger
    ADD CONSTRAINT notifypatterns_to_trigger_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.notifyservice(id) ON DELETE CASCADE;


--
-- Name: notifyservice_inbound_pattern notifyservice_inbound_pattern_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.notifyservice_inbound_pattern
    ADD CONSTRAINT notifyservice_inbound_pattern_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.notifyservice(id) ON DELETE CASCADE;


--
-- Name: orcid_history orcid_history_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.orcid_history
    ADD CONSTRAINT orcid_history_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES public.item(uuid);


--
-- Name: orcid_history orcid_history_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.orcid_history
    ADD CONSTRAINT orcid_history_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.item(uuid);


--
-- Name: orcid_queue orcid_queue_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.orcid_queue
    ADD CONSTRAINT orcid_queue_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES public.item(uuid);


--
-- Name: orcid_queue orcid_queue_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.orcid_queue
    ADD CONSTRAINT orcid_queue_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.item(uuid);


--
-- Name: orcid_token orcid_token_eperson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.orcid_token
    ADD CONSTRAINT orcid_token_eperson_id_fkey FOREIGN KEY (eperson_id) REFERENCES public.eperson(uuid);


--
-- Name: orcid_token orcid_token_profile_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.orcid_token
    ADD CONSTRAINT orcid_token_profile_item_id_fkey FOREIGN KEY (profile_item_id) REFERENCES public.item(uuid);


--
-- Name: process2bitstream process2bitstream_bitstream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.process2bitstream
    ADD CONSTRAINT process2bitstream_bitstream_id_fkey FOREIGN KEY (bitstream_id) REFERENCES public.bitstream(uuid);


--
-- Name: process2bitstream process2bitstream_process_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.process2bitstream
    ADD CONSTRAINT process2bitstream_process_id_fkey FOREIGN KEY (process_id) REFERENCES public.process(process_id);


--
-- Name: process2group process2group_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.process2group
    ADD CONSTRAINT process2group_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.epersongroup(uuid) ON DELETE CASCADE;


--
-- Name: process2group process2group_process_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.process2group
    ADD CONSTRAINT process2group_process_id_fkey FOREIGN KEY (process_id) REFERENCES public.process(process_id);


--
-- Name: process process_eperson; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.process
    ADD CONSTRAINT process_eperson FOREIGN KEY (user_id) REFERENCES public.eperson(uuid) ON DELETE SET NULL;


--
-- Name: relationship relationship_left_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.relationship
    ADD CONSTRAINT relationship_left_id_fkey FOREIGN KEY (left_id) REFERENCES public.item(uuid);


--
-- Name: relationship relationship_right_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.relationship
    ADD CONSTRAINT relationship_right_id_fkey FOREIGN KEY (right_id) REFERENCES public.item(uuid);


--
-- Name: relationship relationship_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.relationship
    ADD CONSTRAINT relationship_type_id_fkey FOREIGN KEY (type_id) REFERENCES public.relationship_type(id);


--
-- Name: relationship_type relationship_type_left_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.relationship_type
    ADD CONSTRAINT relationship_type_left_type_fkey FOREIGN KEY (left_type) REFERENCES public.entity_type(id);


--
-- Name: relationship_type relationship_type_right_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.relationship_type
    ADD CONSTRAINT relationship_type_right_type_fkey FOREIGN KEY (right_type) REFERENCES public.entity_type(id);


--
-- Name: requestitem requestitem_bitstream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.requestitem
    ADD CONSTRAINT requestitem_bitstream_id_fkey FOREIGN KEY (bitstream_id) REFERENCES public.bitstream(uuid);


--
-- Name: requestitem requestitem_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.requestitem
    ADD CONSTRAINT requestitem_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- Name: resourcepolicy resourcepolicy_dspace_object_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.resourcepolicy
    ADD CONSTRAINT resourcepolicy_dspace_object_fkey FOREIGN KEY (dspace_object) REFERENCES public.dspaceobject(uuid) ON DELETE CASCADE;


--
-- Name: resourcepolicy resourcepolicy_eperson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.resourcepolicy
    ADD CONSTRAINT resourcepolicy_eperson_id_fkey FOREIGN KEY (eperson_id) REFERENCES public.eperson(uuid);


--
-- Name: resourcepolicy resourcepolicy_epersongroup_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.resourcepolicy
    ADD CONSTRAINT resourcepolicy_epersongroup_id_fkey FOREIGN KEY (epersongroup_id) REFERENCES public.epersongroup(uuid);


--
-- Name: site site_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.site
    ADD CONSTRAINT site_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: subscription subscription_dspaceobject_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.subscription
    ADD CONSTRAINT subscription_dspaceobject_fkey FOREIGN KEY (dspace_object_id) REFERENCES public.dspaceobject(uuid);


--
-- Name: subscription subscription_eperson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.subscription
    ADD CONSTRAINT subscription_eperson_id_fkey FOREIGN KEY (eperson_id) REFERENCES public.eperson(uuid);


--
-- Name: subscription_parameter subscription_parameter_subscription_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.subscription_parameter
    ADD CONSTRAINT subscription_parameter_subscription_fkey FOREIGN KEY (subscription_id) REFERENCES public.subscription(subscription_id) ON DELETE CASCADE;


--
-- Name: supervision_orders supervision_orders_eperson_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.supervision_orders
    ADD CONSTRAINT supervision_orders_eperson_group_id_fkey FOREIGN KEY (eperson_group_id) REFERENCES public.epersongroup(uuid) ON DELETE CASCADE;


--
-- Name: supervision_orders supervision_orders_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.supervision_orders
    ADD CONSTRAINT supervision_orders_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid) ON DELETE CASCADE;


--
-- Name: versionitem versionitem_eperson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.versionitem
    ADD CONSTRAINT versionitem_eperson_id_fkey FOREIGN KEY (eperson_id) REFERENCES public.eperson(uuid);


--
-- Name: versionitem versionitem_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.versionitem
    ADD CONSTRAINT versionitem_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- Name: versionitem versionitem_versionhistory_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.versionitem
    ADD CONSTRAINT versionitem_versionhistory_id_fkey FOREIGN KEY (versionhistory_id) REFERENCES public.versionhistory(versionhistory_id);


--
-- Name: workspaceitem workspaceitem_collection_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.workspaceitem
    ADD CONSTRAINT workspaceitem_collection_id_fk FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: workspaceitem workspaceitem_collection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.workspaceitem
    ADD CONSTRAINT workspaceitem_collection_id_fkey FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: workspaceitem workspaceitem_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.workspaceitem
    ADD CONSTRAINT workspaceitem_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- PostgreSQL database dump complete
--


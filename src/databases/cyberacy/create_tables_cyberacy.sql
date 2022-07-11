create table color
(
    clr_id      serial                 not null,
    clr_name    varchar(25)            not null,
    clr_red     decimal                not null,
    clr_green   decimal                not null,
    clr_blue    decimal                not null,
    clr_opacity decimal default (1.00) not null,
    constraint pk_color primary key (clr_id)
);

create table document
(
    doc_id            serial       not null,
    doc_original_name varchar(100) not null,
    doc_filename      varchar(150) not null,
    doc_path          varchar(250) not null,
    doc_mime_type     varchar(50)  not null,
    doc_size          int          not null,
    constraint pk_document primary key (doc_id)
);

create table political_edge
(
    poe_id   int         not null,
    poe_name varchar(25) not null,
    constraint pk_politicaledge primary key (poe_id)
);

create table role
(
    rle_id          int                 not null,
    rle_title       varchar(50)         not null,
    rle_description varchar(500) null,
    rle_code        varchar(100) unique not null,
    constraint pk_role primary key (rle_id)
);

create table type_vote
(
    tvo_id   int         not null,
    tvo_name varchar(25) not null,
    constraint pk_typevote primary key (tvo_id)
);

create table profile
(
    prf_id          int                       not null,
    prf_name        varchar(75)               not null,
    prf_description varchar(250) null,
    prf_date_create timestamp default (now()) not null,
    prf_is_delete   boolean   default (false) not null,
    prf_can_deleted boolean   default (true)  not null,
    prf_date_delete timestamp null,
    constraint pk_profile primary key (prf_id)
);

create table link_role_profile
(
    rle_id int not null,
    prf_id int not null,
    constraint pk_linkroleprofile primary key (rle_id, prf_id),
    constraint fk_linkroleprofile_role foreign key (rle_id) references role (rle_id),
    constraint fk_linkroleprofile_profile foreign key (prf_id) references profile (prf_id)
);

create table region
(
    reg_code_insee varchar(15) not null,
    reg_name       varchar(50) not null,
    clr_id         int null,
    constraint pk_region primary key (reg_code_insee),
    constraint fk_region_color foreign key (clr_id) references color (clr_id)
);

create table department
(
    dpt_code       varchar(5)  not null,
    dpt_name       varchar(25) not null,
    reg_code_insee varchar(15) not null,
    clr_id         int null,
    constraint pk_department primary key (dpt_code),
    constraint fk_department_region foreign key (reg_code_insee) references region (reg_code_insee),
    constraint fk_department_color foreign key (clr_id) references color (clr_id)
);

create table town
(
    twn_code_insee  varchar(15)     not null,
    twn_name        varchar(50)     not null,
    twn_zip_code    varchar(10) null,
    twn_nb_resident int default (0) not null,
    dpt_code        varchar(5)      not null,
    constraint pk_town primary key (twn_code_insee),
    constraint fk_town_department foreign key (dpt_code) references department (dpt_code)
);

create table sex
(
    sex_id   int         not null,
    sex_name varchar(25) not null,
    constraint pk_sex primary key (sex_id)
);

create table person
(
    prs_nir            varchar(20) not null,
    prs_firstname      varchar(50) not null,
    prs_lastname       varchar(50) not null,
    prs_email          varchar(50) null,
    prs_password       varchar(250) null,
    prs_birthday       date null,
    prs_address_street varchar(250) null,
    twn_code_insee     varchar(15) not null,
    sex_id             int         not null,
    prf_id             int null,
    constraint pk_person primary key (prs_nir),
    constraint fk_person_town foreign key (twn_code_insee) references town (twn_code_insee),
    constraint fk_person_sex foreign key (sex_id) references sex (sex_id),
    constraint fk_person_profile foreign key (prf_id) references profile (prf_id)
);

create table manifestation
(
    man_id                   serial                    not null,
    man_name                 varchar(50)               not null,
    man_object               varchar(50)               not null,
    man_security_description varchar(250) null,
    man_nb_person_estimate   int null,
    man_url_document_signed  varchar(100) null,
    man_reason_aborted       varchar(250) null,
    man_date_start           timestamp                 not null,
    man_date_end             timestamp                 not null,
    man_is_aborted           boolean   default (false) not null,
    man_date_aborted         timestamp null,
    man_date_create          timestamp default now()   not null,
    constraint pk_manifestation primary key (man_id)
);

create table organiser
(
    prs_nir varchar(20) not null,
    man_id  int         not null,
    constraint pk_organiser primary key (prs_nir, man_id),
    constraint fk_organiser_person foreign key (prs_nir) references person (prs_nir),
    constraint fk_organiser_manifestation foreign key (man_id) references manifestation (man_id)
);

create table option_manifestation
(
    omn_id          serial                  not null,
    omn_name        varchar(50)             not null,
    omn_description varchar(250) null,
    omn_is_delete   boolean default (false) not null,
    man_id          int                     not null,
    constraint pk_optionmanifestation primary key (omn_id),
    constraint fk_optionmanifestation_manifestation foreign key (man_id) references manifestation (man_id)
);

create table type_step
(
    tst_id   int         not null,
    tst_name varchar(25) not null,
    constraint pk_typestep primary key (tst_id)
);

create table step
(
    stp_id             serial                  not null,
    stp_address_street varchar(250)            not null,
    stp_date_arrived   timestamp               not null,
    stp_is_delete      boolean default (false) not null,
    stp_latitude       decimal,
    stp_longitude      decimal,
    twn_code_insee     varchar(15)             not null,
    tst_id             int                     not null,
    man_id             int                     not null,
    constraint pk_step primary key (stp_id),
    constraint fk_step_town foreign key (twn_code_insee) references town (twn_code_insee),
    constraint fk_step_typestep foreign key (tst_id) references type_step (tst_id),
    constraint fk_step_manifestation foreign key (man_id) references manifestation (man_id)
);

create table manifestant
(
    man_id   int         not null,
    prs_nir  varchar(20) not null,
    mnf_date timestamp   not null,
    constraint pk_manifestant primary key (man_id, prs_nir),
    constraint fk_manifestant_person foreign key (prs_nir) references person (prs_nir),
    constraint fk_manifestant_manifestation foreign key (man_id) references manifestation (man_id)
);

create table political_party
(
    pop_id               serial                    not null,
    pop_name             varchar(50)               not null,
    pop_url_logo         varchar(100)              not null,
    pop_date_create      timestamp default (now()) not null,
    pop_description      varchar(250) null,
    pop_is_delete        boolean   default (false) not null,
    pop_date_delete      timestamp null,
    pop_object           varchar(50)               not null,
    pop_address_street   varchar(250)              not null,
    pop_siren            varchar(25) unique        not null,
    pop_chart            varchar(1000) null,
    pop_iban             varchar(30) null,
    pop_url_bank_details varchar(100) null,
    pop_url_chart        varchar(100) null,
    poe_id               int                       not null,
    prs_nir              varchar(20)               not null,
    twn_code_insee       varchar(15)               not null,
    doc_id_logo          int null,
    doc_id_chart         int null,
    doc_id_bank_details  int null,
    clr_id               int null,
    constraint pk_politicalparty primary key (pop_id),
    constraint fk_politicalparty_person foreign key (prs_nir) references person (prs_nir),
    constraint fk_politicalparty_politicaledge foreign key (poe_id) references political_edge (poe_id),
    constraint fk_politicalparty_town foreign key (twn_code_insee) references town (twn_code_insee),
    constraint fk_politicalparty_documentlogo foreign key (doc_id_logo) references document (doc_id),
    constraint fk_politicalparty_documentchart foreign key (doc_id_chart) references document (doc_id),
    constraint fk_politicalparty_documentbankdetails foreign key (doc_id_bank_details) references document (doc_id),
    constraint fk_politicalparty_color foreign key (clr_id) references color (clr_id)
);

create table annual_fee
(
    afe_year int     not null,
    pop_id   int     not null,
    afe_fee  decimal not null,
    constraint pk_annualfee primary key (afe_year, pop_id),
    constraint fk_annualfee_politicalparty foreign key (pop_id) references political_party (pop_id)
);

create table meeting
(
    mee_id             serial                  not null,
    mee_name           varchar(50)             not null,
    mee_object         varchar(50)             not null,
    mee_description    varchar(250) null,
    mee_date_start     timestamp               not null,
    mee_nb_time        decimal                 not null,
    mee_is_aborted     boolean default (false) not null,
    mee_reason_aborted varchar(250) null,
    mee_date_aborted   timestamp,
    mee_nb_place       int null,
    mee_address_street varchar(250) null,
    mee_link_twitch    varchar(150) null,
    mee_link_youtube   varchar(150) null,
    mee_price_excl     decimal default (0.00)  not null,
    mee_vta_rate       decimal default (20.00) not null,
    mee_lat            decimal null,
    mee_lng            decimal null,
    mee_uuid           uuid default(gen_random_uuid()) unique not null,
    pop_id             int                     not null,
    twn_code_insee     varchar(15) null,
    constraint pk_meeting primary key (mee_id),
    constraint fk_meeting_politicalparty foreign key (pop_id) references political_party (pop_id),
    constraint fk_meeting_town foreign key (twn_code_insee) references town (twn_code_insee)
);

create table participant
(
    mee_id             int                       not null,
    prs_nir            varchar(15)               not null,
    ptc_date_joined    timestamp default (now()) not null,
    ptc_is_aborted     boolean   default (false) not null,
    ptc_date_aborted   timestamp null,
    ptc_reason_aborted varchar(250) null,
    constraint pk_participant primary key (mee_id, prs_nir),
    constraint fk_participant_meeting foreign key (mee_id) references meeting (mee_id),
    constraint fk_participant_person foreign key (prs_nir) references person (prs_nir)
);

create table adherent
(
    adh_id        serial                  not null,
    adh_date_join date                    not null,
    adh_date_left date null,
    adh_is_left   boolean default (false) not null,
    pop_id        int                     not null,
    prf_id        int null,
    prs_nir       varchar(20)             not null,
    constraint pk_adherent primary key (adh_id),
    constraint fk_adherent_person foreign key (prs_nir) references person (prs_nir),
    constraint fk_adherent_politiclparty foreign key (pop_id) references political_party (pop_id),
    constraint fk_adherent_profile foreign key (prf_id) references profile (prf_id)
);

create table thread
(
    thr_id          serial                    not null,
    thr_main        boolean   default (false) not null,
    thr_name        varchar(50)               not null,
    thr_description varchar(250) null,
    thr_date_create timestamp default (now()) not null,
    thr_is_delete   boolean   default (false) not null,
    thr_date_delete timestamp null,
    thr_is_private  boolean   default (false) not null,
    thr_url_logo    varchar(150) null,
    thr_fcm_topic   varchar(50) null,
    pop_id          int                       not null,
    constraint pk_thread primary key (thr_id),
    constraint fk_thread_politicalparty foreign key (pop_id) references political_party (pop_id)
);

create table member
(
    mem_id          serial                    not null,
    mem_date_join   timestamp default (now()) not null,
    mem_date_left   timestamp,
    mem_is_left     boolean   default (false) not null,
    mem_mute_thread boolean   default (false) not null,
    thr_id          int                       not null,
    adh_id          int                       not null,
    constraint pk_member primary key (mem_id),
    constraint fk_member_thread foreign key (thr_id) references thread (thr_id),
    constraint fk_member_adherent foreign key (adh_id) references adherent (adh_id)
);

create table message
(
    msg_id             serial                    not null,
    msg_message        varchar(1000)             not null,
    msg_date_published timestamp default (now()) not null,
    thr_id             int                       not null,
    mem_id             int                       not null,
    constraint pk_message primary key (msg_id),
    constraint fk_message_member foreign key (mem_id) references member (mem_id),
    constraint fk_message_thread foreign key (thr_id) references thread (thr_id)
);

create table election
(
    elc_id         serial      not null,
    elc_name       varchar(50) not null,
    elc_date_start timestamp   not null,
    elc_date_end   timestamp   not null,
    tvo_id         int         not null,
    constraint pk_election primary key (elc_id),
    constraint fk_election_typevote foreign key (tvo_id) references type_vote (tvo_id)
);

create table vote
(
    vte_id         serial       not null,
    vte_name       varchar(200) not null,
    vte_nb_voter   int          not null,
    elc_id         int          not null,
    twn_code_insee varchar(15) null,
    dpt_code       varchar(5) null,
    pop_id         int null,
    reg_code_insee varchar(15) null,
    constraint pk_vote primary key (vte_id),
    constraint fk_vote_town foreign key (twn_code_insee) references town (twn_code_insee),
    constraint fk_vote_department foreign key (dpt_code) references department (dpt_code),
    constraint fk_vote_region foreign key (reg_code_insee) references region (reg_code_insee),
    constraint fk_vote_politicalparty foreign key (pop_id) references political_party (pop_id),
    constraint fk_vote_election foreign key (elc_id) references election (elc_id)
);

create table round
(
    rnd_num        int         not null,
    rnd_name       varchar(50) not null,
    rnd_date_start timestamp   not null,
    rnd_date_end   timestamp   not null,
    vte_id         int         not null,
    constraint pk_round primary key (rnd_num, vte_id),
    constraint fk_round_vote foreign key (vte_id) references vote (vte_id)
);

create table choice
(
    cho_id          serial          not null,
    cho_name        varchar(50)     not null,
    cho_order       int             not null,
    cho_nb_vote     int default (0) not null,
    rnd_num         int             not null,
    vte_id          int             not null,
    cho_description varchar(250) null,
    prs_nir         varchar(20) null,
    constraint pk_choice primary key (cho_id),
    constraint fk_choice_vote foreign key (rnd_num, vte_id) references round (rnd_num, vte_id),
    constraint fk_choice_person foreign key (prs_nir) references person (prs_nir)
);


create table link_person_round
(
    rnd_num       int                       not null,
    vte_id        int                       not null,
    prs_nir       varchar(15)               not null,
    lpv_date_vote timestamp default (now()) not null,
    constraint pk_linkpersonround primary key (vte_id, prs_nir, rnd_num),
    constraint fk_linkpersonround_round foreign key (vte_id, rnd_num) references round (vte_id, rnd_num),
    constraint fk_linkpersonround_person foreign key (prs_nir) references person (prs_nir)
);

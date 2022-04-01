create table political_edge (
    poe_id      int not null,
    poe_name    varchar(25) not null,
    constraint  pk_politicaledge    primary key (poe_id)
);

create table role (
    rle_id          int not null,
    rle_title       varchar(25) not null,
    rle_description varchar(250) null,
    rle_code        varchar(20) unique not null,
    constraint  pk_role primary key (rle_id)
);

create table type_vote (
    tvo_id      int not null,
    tvo_name    varchar(25) not null,
    constraint  pk_typevote primary key (tvo_id)
);

create table profile (
    prf_id          serial not null,
    prf_name        varchar(25) not null,
    prf_description varchar(250) null,
    prf_date_create timestamp not null,
    prf_is_delete   boolean default(false) not null,
    prf_date_delete timestamp null,
    constraint  pk_profile  primary key (prf_id)
);

create table link_role_profile (
    rle_id  int not null,
    prf_id  int not null,
    constraint  pk_linkroleprofile          primary key (rle_id, prf_id),
    constraint  fk_linkroleprofile_role     foreign key (rle_id)    references role(rle_id),
    constraint  fk_linkroleprofile_profile  foreign key (prf_id)    references profile(prf_id)
);

create table region (
    reg_code_insee  varchar(15) not null,
    reg_name        varchar(25) not null,
    constraint  pk_region   primary key (reg_code_insee)
);

create table department (
    dpt_code        varchar(5) not null,
    dpt_name        varchar(25) not null,
    reg_code_insee  varchar(15) not null,
    constraint  pk_department          primary key (dpt_code),
    constraint  fk_department_region   foreign key (reg_code_insee)    references region(reg_code_insee)
);

create table town (
    twn_code_insee  varchar(15) not null,
    twn_name        varchar(50) not null,
    twn_zip_code    varchar(10) null,
    twn_nb_resident int default(0) not null,
    dpt_code        varchar(5) not null,
    constraint  pk_town             primary key (twn_code_insee),
    constraint  fk_town_department foreign key (dpt_code) references department(dpt_code)
);

create table sex (
    sex_id      int not null,
    sex_name    varchar(25) not null,
    constraint  pk_sex  primary key (sex_id)
);

create table person (
    prs_nir             varchar(20) not null,
    prs_firstname       varchar(50) not null,
    prs_lastname        varchar(50) not null,
    prs_email           varchar(50) null,
    prs_password        varchar(250) null,
    prs_birthday        date null,
    prs_address_street  varchar(250) null,
    twn_code_insee      varchar(15) not null,
    sex_id              int not null,
    prf_id              int null,
    constraint  pk_person           primary key (prs_nir),
    constraint  fk_person_town      foreign key (twn_code_insee)    references town(twn_code_insee),
    constraint  fk_person_sex       foreign key (sex_id)            references sex(sex_id),
    constraint  fk_person_profile   foreign key (prf_id)            references profile(prf_id)
);

create table vote (
    vte_id          serial not null,
    vte_name        varchar(50) not null,
    vte_date_start  timestamp not null,
    vte_date_end    timestamp not null,
    vte_num_round   int default(1) not null,
    tvo_id          int not null,
    twn_code_insee  varchar(15) null,
    dpt_code        varchar(5) null,
    reg_code_insee  varchar(15) null,
    constraint  pk_vote             primary key (vte_id),
    constraint  fk_vote_town        foreign key (twn_code_insee)    references town(twn_code_insee),
    constraint  fk_vote_department  foreign key (dpt_code)          references department(dpt_code),
    constraint  fk_vote_region      foreign key (reg_code_insee)    references region(reg_code_insee),
    constraint  fk_vote_typevote    foreign key (tvo_id)            references type_vote(tvo_id)
);

create table choice (
    cho_order       int not null,
    vte_id          int not null,
    cho_name        varchar(50) not null,
    cho_nb_vote     int default(0) not null,
    cho_description varchar(250) null,
    prs_nir         varchar(20) null,
    constraint  pk_choice           primary key (cho_order, vte_id),
    constraint  fk_choice_vote      foreign key (vte_id)    references vote(vte_id),
    constraint  fk_choice_person    foreign key (prs_nir)   references person(prs_nir)
);

create table link_person_vote (
    vte_id          int not null,
    prs_nir         int not null,
    lpv_date_vote   timestamp not null,
    constraint  pk_linkpersonvote           primary key (vte_id, prs_nir),
    constraint  fk_linkpersonvote_vote      foreign key (vte_id)    references vote(vte_id),
    constraint  fk_linkpersonvote_person    foreign key (prs_nir)   references person(prs_nir)
);

create table manifestation (
    man_id              serial not null,
    man_name            varchar(50) not null,
    man_address_street  varchar(250) null,
    man_date_start      timestamp not null,
    man_date_end        timestamp not null,
    man_is_delete       boolean default(false) not null,
    man_date_delete     timestamp null,
    man_date_create     timestamp not null,
    prs_nir             varchar(20) not null,
    constraint  pk_manifestation        primary key (man_id),
    constraint  fk_manifestation_person foreign key (prs_nir)    references person(prs_nir)
);

create table link_person_manifestation (
    man_id      int not null,
    prs_nir     varchar(20) not null,
    lpm_date    timestamp not null,
    constraint  pk_linkpersonmanifestation                  primary key (man_id, prs_nir),
    constraint  fk_linkpersonmanifestation_person           foreign key (prs_nir)   references person(prs_nir),
    constraint  fk_linkpersonmanifestation_manifestation    foreign key (man_id)    references manifestation(man_id)
);

create table petition (
    pet_id          serial not null,
    pet_name        varchar(50) not null,
    pet_description varchar(250) null,
    pet_date_start  timestamp not null,
    pet_date_end    timestamp not null,
    pet_is_delete   boolean default(false) not null,
    pet_date_delete timestamp null,
    pet_date_create timestamp not null,
    prs_nir         varchar(20) not null,
    constraint  pk_petition         primary key (pet_id),
    constraint  fk_petition_person  foreign key (prs_nir)   references person(prs_nir)
);

create table link_person_petition (
    prs_nir     varchar(20) not null,
    pet_id      int not null,
    lpp_date    timestamp not null,
    constraint  pk_linkpersonpetition           primary key (prs_nir, pet_id),
    constraint  fk_linkpersonpetition_person    foreign key (prs_nir)   references person(prs_nir),
    constraint  fk_linkpersonpetition_petition  foreign key (pet_id)    references petition(pet_id)
);

create table political_party (
    pop_id          serial not null,
    pop_name        varchar(50) not null,
    pop_url_logo    varchar(100) not null,
    pop_date_create timestamp not null,
    pop_description varchar(250) null,
    pop_is_delete   boolean default(false) not null,
    pop_date_delete timestamp null,
    poe_id          int not null,
    prs_nir         varchar(20) not null,
    constraint  pk_politicalparty               primary key (pop_id),
    constraint  fk_politicalparty_person        foreign key (prs_nir)   references person(prs_nir),
    constraint  fk_politicalparty_politicaledge foreign key (poe_id)    references political_edge(poe_id)
);

create table history_political_party (
    hpp_id          serial not null,
    hpp_date_join   date not null,
    hpp_date_left   date null,
    hpp_is_left     boolean default(false) not null,
    pop_id          int not null,
    prs_nir         varchar(20) not null,
    constraint  pk_historypoliticalparty                primary key (hpp_id),
    constraint  fk_historypoliticalparty_person         foreign key (prs_nir)   references person(prs_nir),
    constraint  fk_historypoliticalparty_politiclparty  foreign key (pop_id)    references political_party(pop_id)
);

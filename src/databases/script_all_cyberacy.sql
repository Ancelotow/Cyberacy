-- =================================================================================================================
-- ================================================= CREATION DES TABLES ===========================================
-- =================================================================================================================

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
    rle_description varchar(500)        null,
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
    prf_id          serial                    not null,
    prf_name        varchar(75)               not null,
    prf_description varchar(250)              null,
    prf_date_create timestamp default (now()) not null,
    prf_is_delete   boolean   default (false) not null,
    prf_can_deleted boolean   default (true)  not null,
    prf_date_delete timestamp                 null,
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
    clr_id         int         null,
    constraint pk_region primary key (reg_code_insee),
    constraint fk_region_color foreign key (clr_id) references color (clr_id)
);

create table department
(
    dpt_code       varchar(5)  not null,
    dpt_name       varchar(25) not null,
    reg_code_insee varchar(15) not null,
    clr_id         int         null,
    constraint pk_department primary key (dpt_code),
    constraint fk_department_region foreign key (reg_code_insee) references region (reg_code_insee),
    constraint fk_department_color foreign key (clr_id) references color (clr_id)
);

create table town
(
    twn_code_insee  varchar(15)     not null,
    twn_name        varchar(50)     not null,
    twn_zip_code    varchar(10)     null,
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
    prs_nir            varchar(20)  not null,
    prs_firstname      varchar(50)  not null,
    prs_lastname       varchar(50)  not null,
    prs_email          varchar(50)  null,
    prs_password       bytea        null,
    prs_birthday       date         null,
    prs_address_street varchar(250) null,
    twn_code_insee     varchar(15)  not null,
    sex_id             int          not null,
    prf_id             int          null,
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
    man_security_description varchar(250)              null,
    man_nb_person_estimate   int                       null,
    man_url_document_signed  varchar(100)              null,
    man_reason_aborted       varchar(250)              null,
    man_date_start           timestamp                 not null,
    man_date_end             timestamp                 not null,
    man_is_aborted           boolean   default (false) not null,
    man_date_aborted         timestamp                 null,
    man_date_create          timestamp default now()   not null,
    man_fcm_topic            varchar(75)               null,
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
    omn_description varchar(250)            null,
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
    pop_name             varchar(100)              not null,
    pop_url_logo         varchar(100)              not null,
    pop_date_create      timestamp default (now()) not null,
    pop_description      varchar(250)              null,
    pop_is_delete        boolean   default (false) not null,
    pop_date_delete      timestamp                 null,
    pop_object           varchar(50)               not null,
    pop_address_street   varchar(250)              not null,
    pop_siren            varchar(25) unique        not null,
    pop_chart            varchar(1000)             null,
    pop_iban             varchar(30)               null,
    pop_url_bank_details varchar(100)              null,
    pop_url_chart        varchar(100)              null,
    poe_id               int                       not null,
    prs_nir              varchar(20)               not null,
    twn_code_insee       varchar(15)               not null,
    doc_id_logo          int                       null,
    doc_id_chart         int                       null,
    doc_id_bank_details  int                       null,
    clr_id               int                       null,
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
    mee_id             serial                                     not null,
    mee_name           varchar(50)                                not null,
    mee_object         varchar(50)                                not null,
    mee_description    varchar(250)                               null,
    mee_date_start     timestamp                                  not null,
    mee_nb_time        decimal                                    not null,
    mee_is_aborted     boolean default (false)                    not null,
    mee_reason_aborted varchar(250)                               null,
    mee_date_aborted   timestamp,
    mee_nb_place       int                                        null,
    mee_address_street varchar(250)                               null,
    mee_link_twitch    varchar(150)                               null,
    mee_link_youtube   varchar(150)                               null,
    mee_price_excl     decimal default (0.00)                     not null,
    mee_vta_rate       decimal default (20.00)                    not null,
    mee_lat            decimal                                    null,
    mee_lng            decimal                                    null,
    mee_uuid           uuid    default (gen_random_uuid()) unique not null,
    pop_id             int                                        not null,
    twn_code_insee     varchar(15)                                null,
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
    ptc_date_aborted   timestamp                 null,
    ptc_reason_aborted varchar(250)              null,
    constraint pk_participant primary key (mee_id, prs_nir),
    constraint fk_participant_meeting foreign key (mee_id) references meeting (mee_id),
    constraint fk_participant_person foreign key (prs_nir) references person (prs_nir)
);

create table adherent
(
    adh_id        serial                  not null,
    adh_date_join date                    not null,
    adh_date_left date                    null,
    adh_is_left   boolean default (false) not null,
    pop_id        int                     not null,
    prf_id        int                     null,
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
    thr_name        varchar(100)              not null,
    thr_description varchar(250)              null,
    thr_date_create timestamp default (now()) not null,
    thr_is_delete   boolean   default (false) not null,
    thr_date_delete timestamp                 null,
    thr_is_private  boolean   default (false) not null,
    thr_url_logo    varchar(150)              null,
    thr_fcm_topic   varchar(50)               null,
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
    twn_code_insee varchar(15)  null,
    dpt_code       varchar(5)   null,
    pop_id         int          null,
    reg_code_insee varchar(15)  null,
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
    cho_id          serial       not null,
    cho_name        varchar(50)  not null,
    cho_description varchar(250) null,
    vte_id          int          not null,
    prs_nir         varchar(20)  null,
    clr_id          int          null,
    constraint pk_choice primary key (cho_id),
    constraint fk_choice_vote foreign key (vte_id) references vote (vte_id),
    constraint fk_choice_color foreign key (clr_id) references color (clr_id),
    constraint fk_choice_person foreign key (prs_nir) references person (prs_nir)
);

create table link_round_choice
(
    cho_id      int             not null,
    vte_id      int             not null,
    rnd_num     int             not null,
    lrc_nb_vote int default (0) not null,
    constraint pk_linkroundchoice primary key (cho_id, vte_id, rnd_num),
    constraint fk_linkroundchoice_round foreign key (vte_id, rnd_num) references round (vte_id, rnd_num),
    constraint fk_linkroundchoice_choice foreign key (cho_id) references choice (cho_id)
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


-- =================================================================================================================
-- =============================================== CREATION DES TRIGGERS ===========================================
-- =================================================================================================================

-- Trigger AFTER INSERT pour la table "political_party"
create or replace function add_main_thread()
    returns trigger
as
$trigger$
begin
    insert into thread(thr_main, thr_name, thr_description, thr_is_private, thr_url_logo, pop_id)
    values (true, new.pop_name, 'Messagerie principale du parti.', false, new.pop_url_logo, new.pop_id);
end
$trigger$
    language plpgsql;

create trigger trg_insert_political_party
    after insert
    on political_party
    for each row
execute procedure add_main_thread();


-- Trigger AFTER UPDATE pour la table "adherent"
create or replace function left_thread()
    returns trigger
as
$trigger$
begin
    if new.adh_is_left = true then
        update member
        set mem_date_left = now(),
            mem_is_left   = true
        where adh_id = new.adh_id
          and mem_is_left = false;
    end if;

    return new;
end
$trigger$
    language plpgsql;

create trigger trg_left_political_party
    after insert
    on adherent
    for each row
execute procedure left_thread();


-- Trigger AFTER INSERT pour la table "adherent"
create or replace function join_main_thread()
    returns trigger
as
$trigger$
begin
    insert into member(thr_id, adh_id)
    select thr_id, new.adh_id
    from thread
    where pop_id = new.pop_id
      and thr_is_delete = false
      and thr_main = true;

    return new;
end
$trigger$
    language plpgsql;

create trigger trg_join_political_party
    after insert
    on adherent
    for each row
execute procedure join_main_thread();


-- Trigger BEFORE INSERT pour la table "message"
create or replace function add_message()
    returns trigger
as
$trigger$
begin
    if not exists(select *
                  from member
                  where mem_id = new.mem_id
                    and mem_is_left = false) then
        raise 'The member % not existed or is left', new.mem_id using errcode = '23503';
    end if;
    return new;
end
$trigger$
    language plpgsql;

create trigger trg_add_message
    before insert
    on message
    for each row
execute procedure add_message();


-- Trigger BEFORE INSERT pour la table "round"
create or replace function add_round()
    returns trigger
as
$trigger$
declare
    num int;
begin
    if new.rnd_num is null then
        select rnd_num
        into num
        from round
        where vte_id = new.vte_id
        order by rnd_num desc
        limit 1;

        if num is null then
            new.rnd_num := 1;
        else
            new.rnd_num := num + 1;
        end if;
    end if;
    return new;
end
$trigger$
    language plpgsql;

create trigger trg_add_round
    before insert
    on round
    for each row
execute procedure add_round();


-- Trigger AFTER INSERT pour la table "vote"
create or replace function add_first_round()
    returns trigger
as
$trigger$
begin
    insert into round(rnd_num, rnd_name, rnd_date_start, rnd_date_end, vte_id)
    select 1, 'Premier Tour', elc_date_start, elc_date_start + interval '12' HOUR, new.vte_id
    from election
    where elc_id = new.elc_id;

    insert into choice(cho_name, cho_description, vte_id)
    values ('Vote blanc', 'Vous pouvez voter blanc si aucune des propositions ne vous conviens.', new.vte_id);


    return new;
end
$trigger$
    language plpgsql;

create trigger trg_add_first_round
    after insert
    on vote
    for each row
execute procedure add_first_round();


-- Trigger BEFORE INSERT pour la table "choice"
create or replace function add_choice()
    returns trigger
as
$trigger$
declare
    date_election timestamp;
begin
    select elc_date_start
    into date_election
    from vote vte
             join election elc on elc.elc_id = vte.elc_id
    where vte.vte_id = new.vte_id;


    if date_election <= now() then
        raise 'You cannot add a new choice when election has started.' using errcode = '23503';
    end if;

    return new;
end
$trigger$
    language plpgsql;

create trigger trg_add_choice
    before insert
    on choice
    for each row
execute procedure add_choice();


-- Trigger BEFORE INSERT pour la table "choice"
create or replace function add_choice_into_first_round()
    returns trigger
as
$trigger$
begin

    if exists(select * from round where vte_id = new.vte_id and rnd_num = 1) then
        insert into link_round_choice(cho_id, vte_id, rnd_num, lrc_nb_vote)
        values(new.cho_id, new.vte_id, 1, 0);
    end if;

    return new;
end
$trigger$
    language plpgsql;

create trigger trg_add_choice_into_first_round
    after insert
    on choice
    for each row
execute procedure add_choice_into_first_round();



-- Trigger BEFORE UPDATE pour la table "choice"
create or replace function add_vote_for_choice()
    returns trigger
as
$trigger$
declare
    date_vote_started timestamp;
    date_vote_ended   timestamp;
begin
    select rnd_date_start, rnd_date_end
    into date_vote_started, date_vote_ended
    from round
    where rnd_num = new.rnd_num
      and vte_id = new.vte_id;

    if date_vote_started > now() or date_vote_ended < now() then
        raise 'You cannot vote before or after the vote.' using errcode = '23503';
    end if;

    return new;
end
$trigger$
    language plpgsql;

create trigger trg_add_add_vote_for_choice
    before update
    on link_round_choice
    for each row
execute procedure add_vote_for_choice();


-- Trigger AFTER INSERT pour la table "election"
create or replace function add_election()
    returns trigger
as
$trigger$
begin

    -- Pr??sidentielle / Sondage / R??f??rendum
    if new.tvo_id in (1, 8, 6) then
        insert into vote (vte_name, elc_id, vte_nb_voter)
        select new.elc_name, new.elc_id, sum(twn_nb_resident)
        from town
        group by new.elc_name, new.elc_id;

        -- R??gionale
    elsif new.tvo_id = 2 then
        insert into vote (vte_name, elc_id, vte_nb_voter, reg_code_insee)
        select concat(new.elc_name, ' : ', reg_name), new.elc_id, sum(twn_nb_resident), reg.reg_code_insee
        from region reg
                 join department dpt on reg.reg_code_insee = dpt.reg_code_insee
                 join town twn on dpt.dpt_code = twn.dpt_code
        group by reg_name, new.elc_name, new.elc_id, reg.reg_code_insee;

        -- D??partementale
    elsif new.tvo_id = 3 then
        insert into vote (vte_name, elc_id, vte_nb_voter, dpt_code)
        select concat(new.elc_name, ' : ', dpt_name), new.elc_id, sum(twn_nb_resident), dpt.dpt_code
        from department dpt
                 join town twn on dpt.dpt_code = twn.dpt_code
        group by dpt_name, new.elc_name, new.elc_id, dpt.dpt_code;

        -- Municipale
    elsif new.tvo_id = 4 then
        insert into vote (vte_name, elc_id, vte_nb_voter, twn_code_insee)
        select concat(new.elc_name, ' : ', twn_name), new.elc_id, twn_nb_resident, twn_code_insee
        from town twn;
    end if;

    return new;
end
$trigger$
    language plpgsql;

create trigger trg_add_election
    after insert
    on election
    for each row
execute procedure add_election();

-- Trigger AFTER INSERT pour la table "thread"
create or replace function add_thread()
    returns trigger
as
$trigger$
begin
    update thread
    set thr_fcm_topic = concat('thread_', new.thr_id)
    where thr_id = new.thr_id;

    return new;
end
$trigger$
    language plpgsql;

create trigger trg_insert_thread
    after insert
    on thread
    for each row
execute procedure add_thread();


-- Trigger AFTER INSERT pour la table "manifestation"
create or replace function add_manifestation()
    returns trigger
as
$trigger$
begin
    update manifestation
    set man_fcm_topic = concat('manifestation_', new.man_id)
    where man_id = new.man_id;

    return new;
end
$trigger$
    language plpgsql;

create trigger trg_insert_manifestation
    after insert
    on manifestation
    for each row
execute procedure add_manifestation();


-- Trigger BEFORE DELETE pour la table "choice"
create or replace function remove_choice()
    returns trigger
as
$trigger$
declare
    date_election timestamp;
begin
    select elc_date_start
    into date_election
    from vote vte
             join election elc on elc.elc_id = vte.elc_id
    where vte.vte_id = old.vte_id;


    if date_election <= now() then
        raise 'You cannot delete a choice when election has started.' using errcode = '23503';
    end if;

    delete from link_round_choice
    where cho_id = old.cho_id;

    return old;
end
$trigger$
    language plpgsql;

create trigger trg_remove_choice
    before delete
    on choice
    for each row
execute procedure remove_choice();


-- =================================================================================================================
-- ================================================ CREATION DES FONCTIONS =========================================
-- =================================================================================================================

-- Nombre de place libre pour un meeting
create or replace function get_nb_place_vacant(id meeting.mee_id%type)
    returns int
as
$body$
declare
    nb_place int;
begin

    select mee_nb_place - get_nb_participant(mee_id)
    into nb_place
    from meeting
    where mee_id = id;

    return nb_place;

end;
$body$
    language plpgsql;

-- Nombre de participant pour un meeting
create or replace function get_nb_participant(id meeting.mee_id%type)
    returns int
as
$body$
declare
    nb_participant int;
begin

    select count(*)
    into nb_participant
    from participant
    where mee_id = id
      and ptc_is_aborted = false;

    if nb_participant is null then
        nb_participant := 0;
    end if;

    return nb_participant;

end;
$body$
    language plpgsql;

-- V??rifie s'il ?? les droits pour un role donn??
create or replace function is_granted(nir person.prs_nir%type, code role.rle_code%type)
    returns boolean
as
$body$
begin

    return exists(select *
                  from role rle
                           join link_role_profile lrp on rle.rle_id = lrp.rle_id
                           join profile prf on lrp.prf_id = prf.prf_id and prf_is_delete = false
                           join person prs on lrp.prf_id = prs.prf_id and prs.prs_nir = nir
                  where rle.rle_code = code);

end;
$body$
    language plpgsql;


-- R??cup??re l'ID d'un membre par son NIR
create or replace function get_id_member_by_nir(nir person.prs_nir%type, id_thread member.thr_id%type)
    returns int
as
$body$
declare
    id int;
begin

    select mem.mem_id
    into id
    from member mem
             join adherent adh on adh.adh_id = mem.adh_id and adh.prs_nir = nir
    where thr_id = id_thread
      and mem_is_left = false;

    return nullif(id, -1);

end;
$body$
    language plpgsql;

-- R??cup??re l'ID d'un adh??rent par son NIR
create or replace function get_id_adherent_by_nir(nir person.prs_nir%type, id_thread thread.thr_id%type)
    returns int
as
$body$
declare
    id int;
begin

    select adh.adh_id
    into id
    from adherent adh
             join political_party pop on pop.pop_id = adh.pop_id
             join thread thr on pop.pop_id = thr.pop_id and thr.thr_id = id_thread
    where adh.prs_nir = nir
      and adh.adh_is_left = false;

    return nullif(id, -1);

end;
$body$
    language plpgsql;

-- Ajoute un nouveau votant sur un choix
create or replace function add_vote_to_choice(nir person.prs_nir%type, id_choice choice.cho_id%type,
                                              _rnd_num link_person_round.rnd_num%type,
                                              _vte_id link_person_round.vte_id%type)
    returns void
as
$body$
declare
    nb_vote int;
begin

    select lrc_nb_vote
    into nb_vote
    from link_round_choice
    where cho_id = id_choice
      and vte_id = _vte_id
      and rnd_num = _rnd_num;

    if nb_vote is null then
        raise 'This choice not existed in this round.' using errcode = '23503';
    end if;

    nb_vote := nb_vote + 1;

    insert into link_person_round (rnd_num, vte_id, prs_nir) values (_rnd_num, _vte_id, nir);

    update link_round_choice
    set lrc_nb_vote = nb_vote
    where cho_id = id_choice
      and vte_id = _vte_id
      and rnd_num = _rnd_num;

end;
$body$
    language plpgsql;


-- R??cup??re le nombre d'adh??rent par mois sur un an
create or replace function get_nb_adherent(month int, year int, _pop_id int)
    returns int
as
$body$
declare
    date_compare timestamp;
    last_day     int;
    count        int;
begin

    select extract(day from (date_trunc('MONTH', make_date(year, month, 01)) + interval '1 MONTH - 1 day')::date)
    into last_day;

    date_compare := make_date(year, month, last_day);

    select count(*)
    into count
    from adherent
    where (adh_date_join <= date_compare
        or (extract(month from adh_date_join) = month
            and extract(year from adh_date_join) = year))
      and (adh_date_left > date_compare
        or adh_date_left is null
        or (extract(month from adh_date_left) = month
            and extract(year from adh_date_left) = year))
      and month <= extract(month from now())
      and year <= extract(year from now())
      and pop_id = _pop_id;

    return count;

end;
$body$
    language plpgsql;


-- R??cup??re le nombre de meeting par mois sur un an
create or replace function get_nb_meeting(month int, year int, _pop_id int)
    returns int
as
$body$
declare
    count int;
begin

    select count(*)
    into count
    from meeting
    where extract(month from mee_date_start) = month
      and extract(year from mee_date_start) = year
      and mee_is_aborted = false
      and pop_id = _pop_id;

    return count;

end;
$body$
    language plpgsql;


-- R??cup??re le nombre de meeting par mois sur un an
create or replace function get_nb_participant_total(month int, year int, _pop_id int)
    returns int
as
$body$
declare
    count int;
begin

    select sum(get_nb_participant(mee_id))
    into count
    from meeting
    where extract(year from mee_date_start) = year
      and extract(month from mee_date_start) = month
      and mee_is_aborted = false
      and pop_id = _pop_id;

    if count is null then
        count := 0;
    end if;

    return count;

end;
$body$
    language plpgsql;


-- R??cup??re le nombre de message par heure sur un thread et sur un jour donn??
create or replace function get_nb_message_by_hour(_date date, hour int, _thr_id message.thr_id%type)
    returns int
as
$body$
declare
    count int;
begin

    select count(*)
    into count
    from message
    where thr_id = _thr_id
      and msg_date_published::date = _date
      and extract(hour from msg_date_published) = hour;

    if count is null then
        count := 0;
    end if;

    return count;

end;
$body$
    language plpgsql;


-- R??cup??re le nombre de message par jour sur un thread et sur une semaine donn??
create or replace function get_nb_message_by_week(year int, week int, _thr_id message.thr_id%type)
    returns int
as
$body$
declare
    count int;
begin

    select count(*)
    into count
    from message
    where thr_id = _thr_id
      and extract(week from '2022-05-09'::date) = week
      and extract(year from '2022-05-09'::date) = year;

    if count is null then
        count := 0;
    end if;

    return count;

end;
$body$
    language plpgsql;


-- R??cup??re le nombre de votant pour un tour donn??
create or replace function get_nb_voter_to_vote(_elc_id election.elc_id%type, _rnd_num round.rnd_num%type)
    returns int
as
$body$
declare
    count int;
begin
    select count(*)
    into count
    from link_person_round lpr
    where lpr.vte_id in (select vte.vte_id
                         from vote vte
                         where vte.elc_id = _elc_id)
      and lpr.rnd_num = _rnd_num;

    if count is null then
        count := 0;
    end if;

    return count;
end;
$body$
    language plpgsql;

-- R??cup??re le nombre de votant pour un tour donn??
create or replace function get_nb_voter(_elc_id election.elc_id%type)
    returns int
as
$body$
declare
    count int;
begin
    select sum(vte_nb_voter)
    into count
    from vote
    where elc_id = _elc_id;

    if count is null then
        count := 0;
    end if;

    return count;
end;
$body$
    language plpgsql;


-- R??cup??re le nombre de votant pour un tour donn??
create or replace function get_nb_voter_to_one_vote(_vte_id vote.vte_id%type, _rnd_num round.rnd_num%type)
    returns int
as
$body$
declare
    count int;
begin
    select count(*)
    into count
    from link_person_round lpr
    where lpr.vte_id = _vte_id
      and lpr.rnd_num = _rnd_num;

    if count is null then
        count := 0;
    end if;

    return count;
end;
$body$
    language plpgsql;


-- R??cup??re si un adh??rent appartient d??j?? ?? un thread ou non
create or replace function is_member_of_thread(_adh_id adherent.adh_id%type, _thr_id thread.thr_id%type)
    returns boolean
as
$body$
declare
    count int;
begin
    select count(*)
    into count
    from member
    where mem_is_left = false
      and adh_id = _adh_id
      and thr_id = _thr_id;

    if count is null then
        count := 0;
    end if;

    if count = 0 then
        return false;
    else
        return true;
    end if;
end;
$body$
    language plpgsql;


-- Cr???? un second tour de vote automatiquement
create or replace function create_second_round(_vte_id round.vte_id%type)
    returns void
as
$body$
declare
    date_election_end timestamp;
begin

    if not exists(select *
                  from vote_get_results(_vte_id, 1)
                  where perc_without_abstention > 50) and  not exists(select *
                                                                      from round where rnd_num = 2 and vte_id = _vte_id) then
        select elc_date_end
        into date_election_end
        from vote vte
                 join election e on e.elc_id = vte.elc_id
        where vte_id = _vte_id;

        insert into round(rnd_num, rnd_name, rnd_date_start, rnd_date_end, vte_id)
        values (2, 'Second tour', date_election_end - interval '12' HOUR, date_election_end, _vte_id);

        insert into link_round_choice(cho_id, vte_id, rnd_num)
        select id_choice, _vte_id, 2
        from vote_get_results(_vte_id, 1)
        order by perc_without_abstention desc
        limit 2;
    end if;

end;
$body$
    language plpgsql;


-- =================================================================================================================
-- ========================================= CREATION DES FONCTIONS DE TABLES ======================================
-- =================================================================================================================


-- Filtre pour la table political_party
create or replace function filter_political_party(_nir adherent.prs_nir%type default null,
                                                  _siren political_party.pop_siren%type default null,
                                                  _id political_party.pop_id%type default null,
                                                  _include_left boolean default false)
    returns table
            (
                id                political_party.pop_id%type,
                name              political_party.pop_name%type,
                url_logo          political_party.pop_url_logo%type,
                date_create       political_party.pop_date_create%type,
                description       political_party.pop_description%type,
                is_delete         political_party.pop_is_delete%type,
                object            political_party.pop_object%type,
                siren             political_party.pop_siren%type,
                url_chart         political_party.pop_url_chart%type,
                id_political_edge political_party.poe_id%type,
                edge_name         political_edge.poe_name%type,
                nir               political_party.prs_nir%type
            )
as
$filter$
begin
    return query
        select distinct pop.pop_id      as id,
                        pop_name        as name,
                        pop_url_logo    as url_logo,
                        pop_date_create as date_create,
                        pop_description as description,
                        pop_is_delete   as is_delete,
                        pop_object      as object,
                        pop_siren       as siren,
                        pop_url_chart   as url_chart,
                        poe.poe_id      as id_political_edge,
                        poe_name        as edge_name,
                        pop.prs_nir     as nir
        from political_party pop
                 left join adherent adh on pop.pop_id = adh.pop_id
                 join political_edge poe on pop.poe_id = poe.poe_id
        where (_nir is null or adh.prs_nir = _nir)
          and (pop_siren = _siren or _siren is null)
          and (pop.pop_id = _id or _id is null)
          and ((adh_is_left = false and _include_left = false) or _include_left = true)
        order by pop_name;
end;
$filter$
    language plpgsql;


-- Filtre pour la table manifestation
create or replace function filter_manifestation(_nir adherent.prs_nir%type default null,
                                                _include_aborted boolean default false,
                                                _id manifestation.man_id%type default null)
    returns table
            (
                id                   manifestation.man_id%type,
                name                 manifestation.man_name%type,
                date_start           manifestation.man_date_start%type,
                date_end             manifestation.man_date_end%type,
                is_aborted           manifestation.man_is_aborted%type,
                date_aborted         manifestation.man_date_aborted%type,
                date_create          manifestation.man_date_create%type,
                object               manifestation.man_object%type,
                security_description manifestation.man_security_description%type,
                nb_person_estimate   manifestation.man_nb_person_estimate%type,
                url_document_signed  manifestation.man_url_document_signed%type,
                reason_aborted       manifestation.man_reason_aborted%type,
                fcm_topic            manifestation.man_fcm_topic%type
            )
as
$filter$
begin
    return query
        select man.man_id               as id,
               man_name                 as name,
               man_date_start           as date_start,
               man_date_end             as date_end,
               man_is_aborted           as is_aborted,
               man_date_aborted         as date_aborted,
               man_date_create          as date_create,
               man_object               as object,
               man_security_description as security_description,
               man_nb_person_estimate   as nb_person_estimate,
               man_url_document_signed  as url_document_signed,
               man_reason_aborted       as reason_aborted,
               man_fcm_topic            as fcm_topic
        from manifestation man
                 left join manifestant mnf on man.man_id = mnf.man_id
        where (_nir is null or mnf.prs_nir = _nir)
          and (_include_aborted = true or man_is_aborted = false)
          and (_id is null or man.man_id = _id)
        order by man_date_start desc;
end;
$filter$
    language plpgsql;


-- Filtre pour la table Adh??rent
create or replace function filter_adherent(_nir adherent.prs_nir%type default null,
                                           _id political_party.pop_id%type default null,
                                           _include_left boolean default false)
    returns table
            (
                id                 adherent.adh_id%type,
                date_join          adherent.adh_date_join%type,
                date_left          adherent.adh_date_left%type,
                is_left            adherent.adh_is_left%type,
                id_political_party adherent.pop_id%type,
                nir                adherent.prs_nir%type
            )
as
$filter$
begin
    return query
        select adh_id        as id,
               adh_date_join as date_join,
               adh_date_left as date_left,
               adh_is_left   as is_left,
               pop_id        as id_political_party,
               prs_nir       as nir
        from adherent adh
        where (_nir is null or prs_nir = _nir)
          and (_id is null or pop_id = _id)
          and (_include_left = true or adh_is_left = false)
        order by date_join;
end;
$filter$
    language plpgsql;


-- Filtre pour la table annual_fee
create or replace function filter_annual_fee(_year annual_fee.afe_year%type default null,
                                             _pop_id annual_fee.pop_id%type default null)
    returns table
            (
                year               annual_fee.afe_year%type,
                id_political_party annual_fee.pop_id%type,
                fee                annual_fee.afe_fee%type
            )
as
$filter$
begin
    return query
        select afe_year as year,
               pop_id   as id_political_party,
               afe_fee  as fee
        from annual_fee
        where (_year is null or afe_year = _year)
          and (_pop_id is null or pop_id = _pop_id);
end;
$filter$
    language plpgsql;


-- Filtre pour la table meeting
create or replace function filter_meeting(_nir person.prs_nir%type,
                                          _town meeting.twn_code_insee%type default null,
                                          _pop_id meeting.pop_id%type default null,
                                          _include_aborted meeting.mee_is_aborted%type default false,
                                          _include_completed boolean default true,
                                          _include_finished boolean default false,
                                          _id meeting.mee_id%type default null,
                                          _only_mine boolean default false)
    returns table
            (
                id                 meeting.mee_id%type,
                name               meeting.mee_name%type,
                date_start         meeting.mee_date_start%type,
                nb_time            meeting.mee_nb_time%type,
                is_aborted         meeting.mee_is_aborted%type,
                nb_place_vacant    int,
                address_street     meeting.mee_address_street%type,
                id_political_party meeting.pop_id%type,
                town_code_insee    meeting.twn_code_insee%type,
                vta_rate           meeting.mee_vta_rate%type,
                price_excl         meeting.mee_price_excl%type,
                town_name          town.twn_name%type,
                is_participate     boolean
            )
as
$filter$
begin
    return query
        select distinct mee.mee_id                      as id,
                        mee_name                        as name,
                        mee_date_start                  as date_start,
                        mee_nb_time                     as nb_time,
                        mee_is_aborted                  as is_aborted,
                        get_nb_place_vacant(mee.mee_id) as nb_place_vacant,
                        mee_address_street              as address_street,
                        mee.pop_id                      as id_political_party,
                        mee.twn_code_insee              as town_code_insee,
                        mee_vta_rate                    as vta_rate,
                        mee_price_excl                  as price_excl,
                        twn_name                        as town_name,
                        case
                            when ptcMine.prs_nir is not null then true
                            else false
                            end                         as is_participate
        from meeting mee
                 left join participant ptc on mee.mee_id = ptc.mee_id
                 left join participant ptcMine on mee.mee_id = ptcMine.mee_id and ptcMine.prs_nir = _nir
                 left join town t on t.twn_code_insee = mee.twn_code_insee
        where (_include_aborted = true or mee_is_aborted = false)
          and (_pop_id is null or mee.pop_id = _pop_id)
          and (_town is null or mee.twn_code_insee = _town)
          and (_include_completed = true or nb_place_vacant > 0)
          and (_include_finished = true or mee_date_start > now())
          and (_id is null or mee.mee_id = _id)
          and (_only_mine = false or ptcMine.prs_nir is not null)
        order by mee_date_start, mee_name;

end;
$filter$
    language plpgsql;


-- Filtre pour la table participant
create or replace function filter_participant(_id participant.mee_id%type,
                                              _include_aborted participant.ptc_is_aborted%type default false)
    returns table
            (
                id_meeting     participant.mee_id%type,
                nir            participant.prs_nir%type,
                date_joined    participant.ptc_date_joined%type,
                is_aborted     participant.ptc_is_aborted%type,
                date_aborted   participant.ptc_date_aborted%type,
                reason_aborted participant.ptc_reason_aborted%type
            )
as
$filter$
begin
    return query
        select mee_id             as id_meeting,
               prs_nir            as nir,
               ptc_date_joined    as date_joined,
               ptc_is_aborted     as is_aborted,
               ptc_date_aborted   as date_aborted,
               ptc_reason_aborted as reason_aborted
        from participant
        where mee_id = _id
          and (_include_aborted = true or ptc_is_aborted = false)
        order by ptc_date_joined desc;
end;
$filter$
    language plpgsql;


-- Filtre pour la table person
create or replace function filter_person(_nir person.prs_nir%type default null)
    returns table
            (
                nir            person.prs_nir%type,
                firstname      person.prs_firstname%type,
                lastname       person.prs_lastname%type,
                email          person.prs_email%type,
                birthday       person.prs_birthday%type,
                address_street person.prs_address_street%type,
                town           person.twn_code_insee%type,
                sex            person.sex_id%type,
                profile        person.prf_id%type
            )
as
$filter$
begin
    return query
        select prs_nir            as nir,
               prs_firstname      as firstname,
               prs_lastname       as lastname,
               prs_email          as email,
               prs_birthday       as birthday,
               prs_address_street as address_street,
               twn_code_insee     as town,
               sex_id             as sex,
               prf_id             as profile
        from person
        where (_nir is null or prs_nir = _nir);
end;
$filter$
    language plpgsql;


-- Filtre pour la table thread
create or replace function filter_thread(_nir person.prs_nir%type, _only_mine boolean default true)
    returns table
            (
                id                 thread.thr_id%type,
                name               thread.thr_name%type,
                main               thread.thr_main%type,
                description        thread.thr_description%type,
                date_create        thread.thr_date_create%type,
                is_delete          thread.thr_is_delete%type,
                date_delete        thread.thr_date_delete%type,
                is_private         thread.thr_is_private%type,
                url_logo           thread.thr_url_logo%type,
                id_political_party thread.pop_id%type,
                fcm_topic          thread.thr_fcm_topic%type
            )
as
$filter$
declare
    is_granted     boolean := is_granted(_nir, 'THREAD#READ');
    is_granted_all boolean := is_granted(_nir, 'THREAD#READ_ALL');
begin
    return query
        select distinct thr.thr_id      as id,
                        thr_name        as name,
                        thr_main        as main,
                        thr_description as description,
                        thr_date_create as date_create,
                        thr_is_delete   as is_delete,
                        thr_date_delete as date_delete,
                        thr_is_private  as is_private,
                        thr_url_logo    as url_logo,
                        thr.pop_id      as id_political_party,
                        thr_fcm_topic   as fcm_topic
        from thread thr
                 join adherent adh on thr.pop_id = adh.pop_id and adh.prs_nir = _nir and adh.adh_is_left = false
                 left join member mem on thr.thr_id = mem.thr_id and adh.adh_id = mem.adh_id
        where (
                (_only_mine = false and is_member_of_thread(adh.adh_id, thr.thr_id) = false and
                 (is_granted_all = true or thr_is_private = false)) or
                (_only_mine = true and mem.mem_id is not null and mem.mem_is_left = false)
            )
          and thr_is_delete = false
          and (is_granted_all = true or is_granted = true)
        order by name;
end;
$filter$
    language plpgsql;


-- Filtre pour la table message
create or replace function filter_message(_nir person.prs_nir%type, _thr_id message.thr_id%type)
    returns table
            (
                id             message.msg_id%type,
                firstname      person.prs_firstname%type,
                lastname       person.prs_lastname%type,
                message        message.msg_message%type,
                date_published message.msg_date_published%type,
                id_thread      message.thr_id%type,
                id_member      message.mem_id%type,
                mine           boolean
            )
as
$filter$
declare
    is_granted boolean := is_granted(_nir, 'MESSAGE#READ');
begin
    return query
        select distinct msg.msg_id         as id,
                        prs_firstname      as firstname,
                        prs_lastname       as lastname,
                        msg_message        as type,
                        msg_date_published as date_published,
                        msg.thr_id         as id_thread,
                        msg.mem_id         as id_member,
                        case
                            when adhSender.prs_nir = _nir then true
                            else false
                            end            as mine
        from message msg
                 join thread thr on msg.thr_id = thr.thr_id and thr.thr_id = _thr_id
                 join member memSender on msg.mem_id = memSender.mem_id
                 join adherent adhSender on memSender.adh_id = adhSender.adh_id
                 join person prs on adhSender.prs_nir = prs.prs_nir
                 join member mem on mem.thr_id = thr.thr_id and mem.mem_is_left = false
                 join adherent adh on mem.adh_id = adh.adh_id and adh.prs_nir = _nir and adh.adh_is_left = false
        where is_granted = true
        order by msg_date_published desc
        limit 200;
end;
$filter$
    language plpgsql;


-- Filtre pour la table membre
create or replace function filter_membres(_nir person.prs_nir%type, _thr_id message.thr_id%type)
    returns table
            (
                id          member.mem_id%type,
                firstname   person.prs_firstname%type,
                lastname    person.prs_lastname%type,
                date_left   member.mem_date_left%type,
                is_left     member.mem_is_left%type,
                mute_thread member.mem_mute_thread%type,
                id_thread   member.thr_id%type,
                id_adherent member.adh_id%type
            )
as
$filter$
declare
    is_granted boolean := is_granted(_nir, 'MEMBER#READ');
begin
    return query
        select mem.mem_id      as id,
               prs_firstname   as firstname,
               prs_lastname    as lastname,
               mem_date_left   as date_left,
               mem_is_left     as is_left,
               mem_mute_thread as mute_thread,
               mem.thr_id      as id_thread,
               mem.adh_id      as id_adherent
        from member mem
                 join adherent adh on mem.adh_id = adh.adh_id and adh.prs_nir = _nir
                 join person prs on adh.prs_nir = prs.prs_nir
                 join filter_thread(_nir, false) thr on thr.id = mem.thr_id
        where is_granted = true
          and mem.thr_id = thr_id
        order by lastname, firstname;
end;
$filter$
    language plpgsql;


-- Filtre pour la table vote
create or replace function filter_vote(_nir person.prs_nir%type, _elc_id vote.elc_id%type,
                                       _include_finish boolean default false, _include_future boolean default true)
    returns table
            (
                id                 vote.vte_id%type,
                name               vote.vte_name%type,
                nb_voter           vote.vte_nb_voter%type,
                town_code_insee    vote.twn_code_insee%type,
                department_code    vote.dpt_code%type,
                reg_code_insee     vote.reg_code_insee%type,
                id_political_party vote.pop_id%type,
                id_election        vote.elc_id%type,
                id_type            election.tvo_id%type
            )
as
$filter$
declare
    is_granted     boolean   := is_granted(_nir, 'VOTE#READ');
    is_granted_all boolean   := is_granted(_nir, 'VOTE#READ_ALL');
    today          timestamp := now();
begin
    return query
        select distinct vte.vte_id         as id,
                        vte_name           as name,
                        vte.vte_nb_voter   as nb_voter,
                        vte.twn_code_insee as town_code_insee,
                        vte.dpt_code       as department_code,
                        vte.reg_code_insee as reg_code_insee,
                        vte.pop_id         as id_political_party,
                        vte.elc_id         as id_election,
                        e.tvo_id           as id_type
        from vote vte
                 join election e on e.elc_id = vte.elc_id
                 left join round rnd on vte.vte_id = rnd.vte_id
                 left join adherent adh on vte.pop_id = adh.pop_id and adh_is_left = false and adh.prs_nir = _nir
        where (is_granted = true or is_granted_all = true)
          and vte.elc_id = _elc_id
          and ((_include_finish = false and rnd.rnd_date_end >= today) or _include_finish = true)
          and ((_include_future = false and rnd.rnd_date_start <= today) or _include_future = true)
          --order by rnd_date_start desc
        limit 500;
end;
$filter$
    language plpgsql;


-- Filtre pour la table round
create or replace function filter_round(_nir person.prs_nir%type, _vte_id round.vte_id%type)
    returns table
            (
                num        round.rnd_num%type,
                name       round.rnd_name%type,
                date_start round.rnd_date_start%type,
                date_end   round.rnd_date_end%type,
                id_vote    round.vte_id%type,
                is_voted   boolean
            )
as
$filter$
begin
    return query
        select rnd.rnd_num    as num,
               rnd_name       as name,
               rnd_date_start as date_start,
               rnd_date_end   as date_end,
               rnd.vte_id     as id_vote,
               case
                   when lpr.vte_id is null then false
                   else true
                   end        as is_voted
        from round rnd
                 left join link_person_round lpr
                           on rnd.vte_id = lpr.vte_id and rnd.rnd_num = lpr.rnd_num and lpr.prs_nir = _nir
        where rnd.vte_id = _vte_id
        order by rnd_date_start, num;
end;
$filter$
    language plpgsql;


-- Filtre pour la table choice
create or replace function filter_choice(_nir person.prs_nir%type, _vte_id round.vte_id%type,
                                         _rnd_num round.rnd_num%type default null)
    returns table
            (
                id           choice.cho_id%type,
                name         choice.cho_name%type,
                id_vote      choice.vte_id%type,
                description  choice.cho_description%type,
                candidat_nir choice.prs_nir%type,
                candidat     varchar,
                id_color     choice.clr_id%type
            )
as
$filter$
begin
    return query
        select distinct cho.cho_id                                        as id,
                        cho_name                                          as name,
                        cho.vte_id                                        as id_vote,
                        cho_description                                   as description,
                        cho.prs_nir                                       as candidat_nir,
                        concat(prs_lastname, ' ', prs_firstname)::varchar as candidat,
                        cho.clr_id                                        as id_color
        from choice cho
                 left join link_round_choice lrc on cho.cho_id = lrc.cho_id
                 left join filter_round(_nir, _vte_id) rnd
                           on rnd.num = lrc.rnd_num and rnd.id_vote = lrc.vte_id
                 left join person prs on cho.prs_nir = prs.prs_nir
        where cho.vte_id = _vte_id
          and (rnd.num = _rnd_num or _rnd_num is null)
        order by cho_name;
end;
$filter$
    language plpgsql;


-- Statistiques pour les parties politiques (nb adherents)
create or replace function stats_adherent_from_party(_nir adherent.prs_nir%type,
                                                     _year int default extract(year from now()))
    returns table
            (
                id_political_party adherent.pop_id%type,
                party_name         political_party.pop_name%type,
                month              int,
                year               int,
                nb_adherent        int
            )
as
$filter$
begin
    return query
        select distinct adh.pop_id                   as id_political_party,
                        pop.pop_name                 as party_name,
                        extract(month from dte)::int as month,
                        extract(year from dte)::int  as year,
                        get_nb_adherent(extract(month from dte)::int, extract(year from dte)::int,
                                        adh.pop_id)  as nb_adherent
        from generate_series(make_date(_year, 01, 01), make_date(_year, 12, 01), '1 month') dte,
             adherent adh
                 join political_party pop on adh.pop_id = pop.pop_id
        where adh.prs_nir = _nir
          and adh.adh_is_left = false
        order by year, month;
end;
$filter$
    language plpgsql;


-- Statistiques pour les parties politiques (nb meeting)
create or replace function stats_meeting_from_party(_nir adherent.prs_nir%type,
                                                    _year int default extract(year from now()),
                                                    _pop_id political_party.pop_id%type default null)
    returns table
            (
                id_political_party adherent.pop_id%type,
                party_name         political_party.pop_name%type,
                month              int,
                year               int,
                nb_meeting         int,
                nb_participant     int
            )
as
$filter$
begin
    return query
        select distinct mee.pop_id                           as id_political_party,
                        pop.pop_name                         as party_name,
                        extract(month from dte)::int         as month,
                        extract(year from dte)::int          as year,
                        get_nb_meeting(extract(month from dte)::int, extract(year from dte)::int,
                                       mee.pop_id)           as nb_meeting,
                        get_nb_participant_total(extract(month from dte)::int, extract(year from dte)::int,
                                                 mee.pop_id) as nb_participant
        from generate_series(make_date(_year, 01, 01), make_date(_year, 12, 01), '1 month') dte,
             meeting mee
                 join political_party pop on mee.pop_id = pop.pop_id
                 join adherent adh on pop.pop_id = adh.pop_id and adh.prs_nir = _nir and adh.adh_is_left = false
        where (_pop_id is null or pop.pop_id = _pop_id)
        order by year, month;
end;
$filter$
    language plpgsql;


-- Statistiques pour les parties politiques (cotisation annuelles)
create or replace function stats_fee_from_party(_nir adherent.prs_nir%type)
    returns table
            (
                id_political_party adherent.pop_id%type,
                party_name         political_party.pop_name%type,
                total_fee          decimal,
                annual_fee         decimal,
                year               int
            )
as
$filter$
begin
    return query
        select distinct afe.pop_id                                                             as id_political_party,
                        pop.pop_name                                                           as party_name,
                        (select sum(sta.nb_adherent)
                         from stats_adherent_from_party(_nir, afe.afe_year) sta) * afe.afe_fee as total_fee,
                        afe.afe_fee                                                            as annual_fee,
                        afe.afe_year                                                           as year
        from annual_fee afe
                 join political_party pop on afe.pop_id = pop.pop_id
                 join adherent adh on pop.pop_id = adh.pop_id and adh.prs_nir = _nir and adh.adh_is_left = false
        order by year;
end;
$filter$
    language plpgsql;


-- Statistiques pour les parties politiques (messages / heure)
create or replace function stats_messages_from_party_by_date(_nir adherent.prs_nir%type, _date date)
    returns table
            (
                id_political_party adherent.pop_id%type,
                party_name         political_party.pop_name%type,
                thread_name        thread.thr_name%type,
                id_thread          thread.thr_id%type,
                nb_message         int,
                hour               int
            )
as
$filter$
declare
    date_start timestamp := make_timestamp(2000, 01, 01, 00, 00, 00);
    date_end   timestamp := make_timestamp(2000, 01, 01, 23, 59, 00);
begin
    return query
        select pop.pop_id                                                             as id_political_party,
               pop_name                                                               as party_name,
               thr_name                                                               as thread_name,
               thr.thr_id                                                             as id_thread,
               get_nb_message_by_hour(_date, extract(hour from dte)::int, thr.thr_id) as nb_message,
               extract(hour from dte)::int                                            as hour
        from generate_series(date_start, date_end, '1 hour') dte,
             adherent adh
                 join member mem on adh.adh_id = mem.adh_id and mem_is_left = false
                 join thread thr on mem.thr_id = thr.thr_id
                 join political_party pop on pop.pop_id = adh.pop_id
        where adh.prs_nir = _nir
          and adh_is_left = false
        group by party_name, thread_name, hour, nb_message, id_political_party, id_thread
        order by hour;
end;
$filter$
    language plpgsql;


-- Statistiques pour les parties politiques (messages / weeks)
create or replace function stats_messages_from_party_by_week(_nir adherent.prs_nir%type, year int)
    returns table
            (
                id_political_party adherent.pop_id%type,
                party_name         political_party.pop_name%type,
                thread_name        thread.thr_name%type,
                id_thread          thread.thr_id%type,
                nb_message         int,
                week               int
            )
as
$filter$
declare
    date_start timestamp := make_date(year, 01, 01);
    date_end   timestamp := make_date(year, 12, 31);
begin
    return query
        select pop.pop_id                                                            as id_political_party,
               pop_name                                                              as party_name,
               thr_name                                                              as thread_name,
               thr.thr_id                                                            as id_thread,
               get_nb_message_by_week(year, extract(week from dte)::int, thr.thr_id) as nb_message,
               extract(week from dte)::int                                           as week
        from generate_series(date_start, date_end, '1 week') dte,
             adherent adh
                 join member mem on adh.adh_id = mem.adh_id and mem_is_left = false
                 join thread thr on mem.thr_id = thr.thr_id
                 join political_party pop on pop.pop_id = adh.pop_id
        where adh.prs_nir = _nir
          and adh_is_left = false
        group by party_name, thread_name, week, nb_message, id_political_party, id_thread
        order by week;

end;
$filter$
    language plpgsql;


-- Statistiques pour les absentions par vote
create or replace function vote_get_absention(_num_round round.rnd_num%type, _tvo_id type_vote.tvo_id%type default null)
    returns table
            (
                nb_abstention   int,
                perc_abstention decimal,
                date_start      election.elc_date_start%type,
                id_election     election.elc_id%type,
                name_election   election.elc_name%type,
                id_type_vote    election.tvo_id%type,
                name_type_vote  type_vote.tvo_name%type
            )
as
$filter$
begin
    return query
        select get_nb_voter(elc.elc_id) - get_nb_voter_to_vote(elc.elc_id, _num_round) as nb_abstention,
               ((get_nb_voter(elc.elc_id) - get_nb_voter_to_vote(elc.elc_id, _num_round))::decimal /
                get_nb_voter(elc.elc_id)) *
               100                                                                     as perc_abstention,
               elc_date_start                                                          as date_start,
               elc_id                                                                  as id_election,
               elc_name                                                                as name_election,
               elc.tvo_id                                                              as id_type_vote,
               tvo_name                                                                as name_type_vote
        from election elc
                 join type_vote tvo on elc.tvo_id = tvo.tvo_id
        where elc.tvo_id = _tvo_id
           or _tvo_id is null
        order by elc_date_start desc;
end;
$filter$
    language plpgsql;


-- Statistiques pour les participations par vote
create or replace function vote_get_participation(_num_round round.rnd_num%type,
                                                  _tvo_id type_vote.tvo_id%type default null)
    returns table
            (
                nb_participation   int,
                perc_participation decimal,
                date_start         election.elc_date_start%type,
                id_election        election.elc_id%type,
                name_election      election.elc_name%type,
                id_type_vote       election.tvo_id%type,
                name_type_vote     type_vote.tvo_name%type
            )
as
$filter$
begin
    return query
        select get_nb_voter_to_vote(elc.elc_id, _num_round) as nb_participation,
               (get_nb_voter_to_vote(elc.elc_id, _num_round)::decimal / get_nb_voter(elc.elc_id)) *
               100                                          as perc_participation,
               elc_date_start                               as date_start,
               elc_id                                       as id_election,
               elc_name                                     as name_election,
               elc.tvo_id                                   as id_type_vote,
               tvo_name                                     as name_type_vote
        from election elc
                 join type_vote tvo on elc.tvo_id = tvo.tvo_id
        where elc.tvo_id = _tvo_id
           or _tvo_id is null
        order by elc_date_start desc;
end;
$filter$
    language plpgsql;


-- R??sultats de vote
create or replace function vote_get_results(_vte_id vote.vte_id%type, _rnd_num round.rnd_num%type)
    returns table
            (
                id_choice               choice.cho_id%type,
                libelle_choice          choice.cho_name%type,
                nb_voice                link_round_choice.lrc_nb_vote%type,
                perc_with_abstention    decimal,
                perc_without_abstention decimal,
                id_vote                 vote.vte_id%type,
                name_vote               vote.vte_name%type,
                num_round               round.rnd_num%type,
                name_round              round.rnd_name%type,
                id_color                choice.clr_id%type
            )
as
$filter$
begin
    return query
        select lrc.cho_id                                  as id_choice,
               cho_name                                    as libelle_choice,
               lrc_nb_vote                                 as nb_voice,
               (lrc_nb_vote::decimal / vte_nb_voter) * 100 as perc_with_abstention,
               case
                   when get_nb_voter_to_one_vote(rnd.vte_id, rnd.rnd_num) = 0 then 0
                   else (lrc_nb_vote::decimal / get_nb_voter_to_one_vote(rnd.vte_id, rnd.rnd_num)) *
                        100
                   end                                     as perc_without_abstention,

               rnd.vte_id                                  as id_vote,
               vte_name                                    as name_vote,
               rnd.rnd_num                                 as num_round,
               rnd_name                                    as name_round,
               cho.clr_id                                  as id_color
        from link_round_choice lrc
                 join choice cho on lrc.cho_id = cho.cho_id
                 join round rnd on lrc.rnd_num = rnd.rnd_num and lrc.vte_id = rnd.vte_id
                 join vote vte on rnd.vte_id = vte.vte_id
        where lrc.vte_id = _vte_id
          and lrc.rnd_num = _rnd_num
          and rnd.rnd_date_end < now()
        order by perc_without_abstention desc;
end;
$filter$
    language plpgsql;


-- Filtre pour la table step
create or replace function filter_step(_man_id step.man_id%type default null)
    returns table
            (
                id               step.stp_id%type,
                address_street   step.stp_address_street%type,
                town_code_insee  step.twn_code_insee%type,
                town_zip_code    town.twn_zip_code%type,
                town_name        town.twn_name%type,
                id_manifestation step.man_id%type,
                longitude        step.stp_longitude%type,
                latitude         step.stp_latitude%type,
                id_step_type     step.tst_id%type,
                date_arrived     step.stp_date_arrived%type
            )
as
$filter$
begin
    return query
        select stp.stp_id             as id,
               stp.stp_address_street as address_street,
               stp.twn_code_insee     as town_code_insee,
               twn.twn_zip_code       as town_zip_code,
               twn.twn_name           as town_name,
               stp.man_id             as id_manifestation,
               stp.stp_longitude      as longitude,
               stp.stp_latitude       as latitude,
               stp.tst_id             as id_step_type,
               stp.stp_date_arrived   as date_arrived
        from step stp
                 left join town twn on stp.twn_code_insee = twn.twn_code_insee
        where (man_id = _man_id or _man_id is null)
          and stp.stp_is_delete = false
        order by date_arrived;
end;
$filter$
    language plpgsql;


-- Filtre pour la table profile
create or replace function filter_profile(_nir person.prs_nir%type default null)
    returns table
            (
                id          profile.prf_id%type,
                name        profile.prf_name%type,
                description profile.prf_description%type,
                date_create profile.prf_date_create%type
            )
as
$filter$
begin
    return query
        select prf_id          as id,
               prf_name        as name,
               prf_description as description,
               prf_date_create as date_create
        from profile
        where prf_is_delete = false;
end;
$filter$
    language plpgsql;


-- Filtre pour la table role
create or replace function filter_role(_nir person.prs_nir%type default null, _prf_id profile.prf_id%type default null)
    returns table
            (
                id          role.rle_id%type,
                title       role.rle_title%type,
                description role.rle_description%type,
                code        role.rle_code%type
            )
as
$filter$
begin
    return query
        select rle.rle_id      as id,
               rle_title       as title,
               rle_description as description,
               rle_code        as code
        from role rle
                 left join link_role_profile lrp on rle.rle_id = lrp.rle_id
        where _prf_id is null
           or lrp.prf_id = _prf_id;
end;
$filter$
    language plpgsql;


-- Filtre pour la table d??partement
create or replace function filter_department(_code_insee department.reg_code_insee%type default null,
                                             _code department.dpt_code%type default null)
    returns table
            (
                code              department.dpt_code%type,
                name              department.dpt_name%type,
                region_code_insee department.reg_code_insee%type,
                id_color          department.clr_id%type
            )
as
$filter$
begin
    return query
        select dpt_code       as code,
               dpt_name       as name,
               reg_code_insee as region_code_insee,
               clr_id         as id_color
        from department
        where (_code_insee is null or reg_code_insee = _code_insee)
          and (_code is null or dpt_code = _code)
        order by code;
end;
$filter$
    language plpgsql;


-- Filtre pour la table town
create or replace function filter_town(_code_insee town.twn_code_insee%type default null,
                                       _code town.dpt_code%type default null)
    returns table
            (
                code_insee      town.twn_code_insee%type,
                name            town.twn_name%type,
                zip_code        town.twn_zip_code%type,
                nb_resident     town.twn_nb_resident%type,
                department_code town.dpt_code%type
            )
as
$filter$
begin
    return query
        select twn_code_insee  as code_insee,
               twn_name        as name,
               twn_zip_code    as zip_code,
               twn_nb_resident as nb_resident,
               dpt_code        as department_code
        from town
        where (_code_insee is null or twn_code_insee = _code_insee)
          and (_code is null or dpt_code = _code)
        order by name;
end;
$filter$
    language plpgsql;


-- Filtre pour la table r??gion
create or replace function filter_region(_code_insee region.reg_code_insee%type default null)
    returns table
            (
                code_insee region.reg_code_insee%type,
                name       region.reg_name%type,
                id_color   region.clr_id%type
            )
as
$filter$
begin
    return query
        select reg_code_insee as code_insee,
               reg_name       as name,
               clr_id         as id_color
        from region
        where reg_code_insee = _code_insee
           or _code_insee is null
        order by name;
end;
$filter$
    language plpgsql;


-- Filtre pour la table color
create or replace function filter_color(_id color.clr_id%type default null)
    returns table
            (
                id      color.clr_id%type,
                name    color.clr_name%type,
                red     color.clr_red%type,
                green   color.clr_green%type,
                blue    color.clr_blue%type,
                opacity color.clr_opacity%type
            )
as
$filter$
begin
    return query
        select clr_id      as id,
               clr_name    as name,
               clr_red     as red,
               clr_green   as green,
               clr_blue    as blue,
               clr_opacity as opacity
        from color
        where clr_id = _id
           or _id is null
        order by clr_name;
end;
$filter$
    language plpgsql;


-- Filtre pour la table ??lection
create or replace function filter_election(_nir person.prs_nir%type, _elc_id election.elc_id%type default null,
                                           _include_finish boolean default false, _include_future boolean default true)
    returns table
            (
                id           election.elc_id%type,
                name         election.elc_name%type,
                date_start   election.elc_date_start%type,
                date_end     election.elc_date_end%type,
                id_type_vote election.tvo_id%type
            )
as
$filter$
declare
    today timestamp := now();
begin
    return query
        select elc.elc_id     as id,
               elc_name       as name,
               elc_date_start as date_start,
               elc_date_end   as date_end,
               elc.tvo_id     as id_type_vote
        from election elc
        where (elc.elc_id = _elc_id or _elc_id is null)
          and ((_include_finish = false and elc_date_end >= today) or _include_finish = true)
          and ((_include_future = false and elc_date_start <= today) or _include_future = true)
        order by elc_date_start desc;
end;
$filter$
    language plpgsql;

-- Filtre pour la table options
create or replace function filter_options(_id option_manifestation.man_id%type)
    returns table
            (
                id               option_manifestation.omn_id%type,
                name             option_manifestation.omn_name%type,
                description      option_manifestation.omn_description%type,
                is_delete        option_manifestation.omn_is_delete%type,
                id_manifestation option_manifestation.man_id%type
            )
as
$filter$
begin
    return query
        select omn_id          as id,
               omn_name        as name,
               omn_description as description,
               omn_is_delete   as is_delete,
               man_id          as id_manifestation
        from option_manifestation
        where man_id = _id
          and omn_is_delete = false
        order by omn_name;
end;
$filter$
    language plpgsql;

-- R??cup??re la liste des votes "en cours" d'un utilisateur
create or replace function get_in_progress_vote(_nir person.prs_nir%type)
    returns table
            (
                id                 vote.vte_id%type,
                name               vote.vte_name%type,
                nb_voter           vote.vte_nb_voter%type,
                town_code_insee    vote.twn_code_insee%type,
                department_code    vote.dpt_code%type,
                reg_code_insee     vote.reg_code_insee%type,
                id_political_party vote.pop_id%type,
                id_election        vote.elc_id%type,
                id_type            election.tvo_id%type,
                name_type          type_vote.tvo_name%type
            )
as
$filter$
declare
    today    timestamp := now();
    mine_dpt department.dpt_code%type;
    mine_twn town.twn_code_insee%type;
    mine_reg region.reg_code_insee%type;
begin
    select twn.twn_code_insee, dpt.dpt_code, dpt.reg_code_insee
    into mine_twn, mine_dpt, mine_reg
    from person prs
             join town twn on prs.twn_code_insee = twn.twn_code_insee
             join department dpt on twn.dpt_code = dpt.dpt_code
    where prs_nir = _nir;

    return query
        select vte.vte_id         as id,
               vte_name           as name,
               vte.vte_nb_voter   as nb_voter,
               vte.twn_code_insee as town_code_insee,
               vte.dpt_code       as department_code,
               vte.reg_code_insee as reg_code_insee,
               vte.pop_id         as id_political_party,
               vte.elc_id         as id_election,
               e.tvo_id           as id_type,
               tv.tvo_name        as name_type
        from vote vte
                 join election e on e.elc_id = vte.elc_id
                 join type_vote tv on e.tvo_id = tv.tvo_id
        where elc_date_start <= today
          and elc_date_end >= today
          and (vte.twn_code_insee = mine_twn or vte.twn_code_insee is null)
          and (vte.dpt_code = mine_dpt or vte.dpt_code is null)
          and (vte.reg_code_insee = mine_reg or vte.reg_code_insee is null);
end ;
$filter$
    language plpgsql;


-- =================================================================================================================
-- ============================================== INSERTIONS DES REFERENCES ========================================
-- =================================================================================================================


do
$sex$
    begin
        if not exists(select * from sex where sex_id = 1) then
            insert into sex(sex_id, sex_name) values (1, 'Homme');
        end if;

        if not exists(select * from sex where sex_id = 2) then
            insert into sex(sex_id, sex_name) values (2, 'Femme');
        end if;
    end;
$sex$;

do
$type_vote$
    begin
        if not exists(select * from type_vote where tvo_id = 1) then
            insert into type_vote(tvo_id, tvo_name) values (1, 'Pr??sidentiel');
        end if;

        if not exists(select * from type_vote where tvo_id = 2) then
            insert into type_vote(tvo_id, tvo_name) values (2, 'R??gional');
        end if;

        if not exists(select * from type_vote where tvo_id = 3) then
            insert into type_vote(tvo_id, tvo_name) values (3, 'D??partemental');
        end if;

        if not exists(select * from type_vote where tvo_id = 4) then
            insert into type_vote(tvo_id, tvo_name) values (4, 'Municipal');
        end if;

        if not exists(select * from type_vote where tvo_id = 5) then
            insert into type_vote(tvo_id, tvo_name) values (5, 'L??gislative');
        end if;

        if not exists(select * from type_vote where tvo_id = 6) then
            insert into type_vote(tvo_id, tvo_name) values (6, 'R??f??rundum');
        end if;

        if not exists(select * from type_vote where tvo_id = 7) then
            insert into type_vote(tvo_id, tvo_name) values (7, 'Sondage priv??');
        end if;

        if not exists(select * from type_vote where tvo_id = 8) then
            insert into type_vote(tvo_id, tvo_name) values (8, 'Sondage public');
        end if;
    end;
$type_vote$;

do
$type_step$
    begin
        if not exists(select * from type_step where tst_id = 1) then
            insert into type_step(tst_id, tst_name) values (1, 'D??part');
        end if;

        if not exists(select * from type_step where tst_id = 2) then
            insert into type_step(tst_id, tst_name) values (2, 'Etape');
        end if;

        if not exists(select * from type_step where tst_id = 3) then
            insert into type_step(tst_id, tst_name) values (3, 'Arriv??e');
        end if;
    end;
$type_step$;

do
$role$
    begin
        if not exists(select * from role where rle_id = 1) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (1, 'Connexion app Android', 'Connexion ?? l''application Android', 'APP_ANDROID#CONNECTION');
        end if;
        if not exists(select * from role where rle_id = 2) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (2, 'Connexion app IOS', 'Connexion ?? l''application IOS', 'APP_IOS#CONNECTION');
        end if;
        if not exists(select * from role where rle_id = 3) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (3, 'Connexion Back-Office', 'Connexion au Back-Office web', 'BO#CONNECTION');
        end if;
        if not exists(select * from role where rle_id = 4) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (4, 'Acc??s au module "Manifestation"', 'Acc??der au module "Manifestaion"',
                    'MODULE_MANIFESTAION#ACCESS');
        end if;
        if not exists(select * from role where rle_id = 5) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (5, 'Acc??s au module "Parti politique"', 'Acc??der au module "Parti politique"',
                    'MODULE_POLITICAL_PARTY#ACCESS');
        end if;
        if not exists(select * from role where rle_id = 6) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (6, 'Acc??s au module "Vote"', 'Acc??der au module "Vote"', 'MODULE_VOTE#ACCESS');
        end if;
        if not exists(select * from role where rle_id = 7) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (7, 'THREAD : Lecture', 'Voir la liste des threads', 'THREAD#READ');
        end if;
        if not exists(select * from role where rle_id = 8) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (8, 'THREAD : Lecture tout', 'Voir la liste de tout les threads', 'THREAD#READ_ALL');
        end if;
        if not exists(select * from role where rle_id = 9) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (9, 'MESSAGE : Publier', 'Pouvoir ajouter un message', 'MESSAGE#PUBLISH');
        end if;
        if not exists(select * from role where rle_id = 10) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (10, 'MESSAGE : Lecture', 'Lire les messages d''un thread', 'MESSAGE#READ');
        end if;
        if not exists(select * from role where rle_id = 11) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (11, 'MEMBRES : Lecture', 'Voir les membres d''un thread', 'MEMBER#READ');
        end if;
        if not exists(select * from role where rle_id = 12) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (12, 'THREAD : Join', 'Pouvoir rejoindre un thread', 'THREAD#JOIN');
        end if;
        if not exists(select * from role where rle_id = 13) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (13, 'VOTE : Lecture', 'Pouvoir voir les votes (sondage priv?? exclus)', 'VOTE#READ');
        end if;
        if not exists(select * from role where rle_id = 14) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (14, 'VOTE : Lecture tout', 'Pouvoir voir les votes (sondage priv?? inclus)', 'VOTE#READ_ALL');
        end if;
        if not exists(select * from role where rle_id = 15) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (15, 'PARTI POLITIQUE : Cr??er un thread', 'Pouvoir cr??er un thread dans un parti politique',
                    'THREAD$$$CREATE');
        end if;
        if not exists(select * from role where rle_id = 16) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (16, 'PARTI POLITIQUE : Supprimer un thread', 'Pouvoir supprimer un thread', 'THREAD$$$DELETE');
        end if;
        if not exists(select * from role where rle_id = 17) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (17, 'PARTI POLITIQUE : Inviter dans un thread', 'Pouvoir inviter une personne dans un thread',
                    'THREAD$$$INVITED');
        end if;
        if not exists(select * from role where rle_id = 18) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (18, 'PERSONNES : Lecture', 'Pouvoir voir la liste des personnes', 'PERSON$$$READ');
        end if;
        if not exists(select * from role where rle_id = 19) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (19, 'Acc??s au module UTILISATEUR', 'Acc??der au module UTILISATEUR sur le Back-Office', 'USER$$$ACCESS');
        end if;
        if not exists(select * from role where rle_id = 20) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (20, 'PROFILE : Lecture', 'Pouvoir voir la liste des profiles', 'PROFIL$$$READ');
        end if;
        if not exists(select * from role where rle_id = 21) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (21, 'Acc??s au module PROFILE', 'Acc??der au module PROFILE sur le Back-Office', 'PROFIL$$$ACCESS');
        end if;
        if not exists(select * from role where rle_id = 22) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (22, 'DROITS : Lecture', 'Pouvoir voir la liste des droits', 'ROLE$$$READ');
        end if;
    end;
$role$;

do
$profile$
    begin
        if not exists(select * from profile where prf_id = 1) then
            insert into profile(prf_id, prf_name, prf_can_deleted) values (1, 'Super Administrateur', false);
        end if;

        if not exists(select * from profile where prf_id = 2) then
            insert into profile(prf_id, prf_name, prf_can_deleted) values (2, 'Administrateur', false);
        end if;

        if not exists(select * from profile where prf_id = 3) then
            insert into profile(prf_id, prf_name, prf_can_deleted)
            values (3, 'Administrateur (Parti politique)', false);
        end if;

        if not exists(select * from profile where prf_id = 4) then
            insert into profile(prf_id, prf_name, prf_can_deleted) values (4, 'Utilisateur', false);
        end if;
    end;
$profile$;


do
$profile$
    begin
        delete
        from link_role_profile
        where prf_id in (select prf_id
                         from profile
                         where prf_can_deleted = false);

        -- Super Administrateur
        insert into link_role_profile(rle_id, prf_id)
        select rle_id, 1
        from role;

        -- Administrateur
        insert into link_role_profile(rle_id, prf_id)
        select rle_id, 2
        from role
        where rle_code not in (
            'THREAD$$$DELETE'
            );

        -- Administrateur (Parti Politique)
        insert into link_role_profile(rle_id, prf_id)
        select rle_id, 3
        from role
        where rle_code in (
                           'THREAD$$$INVITED', 'THREAD$$$DELETE', 'THREAD$$$CREATE', 'THREAD#READ_ALL', 'THREAD#READ',
                           'MESSAGE#READ', 'MEMBER#READ'
            );
    end;
$profile$;


-- =================================================================================================================
-- ================================================= CREATION DU CRON ==============================================
-- =================================================================================================================

-- Cr??ation d'un CRON pour cr??er tout les second tour toutes les 15 minutes
select cron.schedule('create-second-round', '*/15 * * * *', $$select create_second_round(v.vte_id)
from round rnd
    join vote v on rnd.vte_id = v.vte_id
    join election e on v.elc_id = e.elc_id
where elc_date_start < now()
and elc_date_end > now()
and rnd.rnd_date_end < now()$$);

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
                date_delete       political_party.pop_date_delete%type,
                object            political_party.pop_object%type,
                address_street    political_party.pop_address_street%type,
                siren             political_party.pop_siren%type,
                chart             political_party.pop_chart%type,
                iban              political_party.pop_iban%type,
                url_bank_details  political_party.pop_url_bank_details%type,
                url_chart         political_party.pop_url_chart%type,
                id_political_edge political_party.poe_id%type,
                nir               political_party.prs_nir%type,
                town_code_insee   political_party.twn_code_insee%type
            )
as
$filter$
begin
    return query
        select distinct pop.pop_id           as id,
                        pop_name             as name,
                        pop_url_logo         as url_logo,
                        pop_date_create      as date_create,
                        pop_description      as description,
                        pop_is_delete        as is_delete,
                        pop_date_delete      as date_delete,
                        pop_object           as object,
                        pop_address_street   as address_street,
                        pop_siren            as siren,
                        pop_chart            as chart,
                        pop_iban             as iban,
                        pop_url_bank_details as url_bank_details,
                        pop_url_chart        as url_chart,
                        poe_id               as id_political_edge,
                        pop.prs_nir          as nir,
                        twn_code_insee       as town_code_insee
        from political_party pop
                 left join adherent adh on pop.pop_id = adh.pop_id
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
                reason_aborted       manifestation.man_reason_aborted%type
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
               man_reason_aborted       as reason_aborted
        from manifestation man
                 left join manifestant mnf on man.man_id = mnf.man_id
        where (_nir is null or mnf.prs_nir = _nir)
          and (_include_aborted = true or man_is_aborted = false)
          and (_id is null or man.man_id = _id)
        order by man_date_start desc;
end;
$filter$
    language plpgsql;


-- Filtre pour la table Adhérent
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
create or replace function filter_meeting(_town meeting.twn_code_insee%type default null,
                                          _pop_id meeting.pop_id%type default null,
                                          _nir person.prs_nir%type default null,
                                          _include_aborted meeting.mee_is_aborted%type default false,
                                          _include_completed meeting.mee_is_aborted%type default true)
    returns table
            (
                id                 meeting.mee_id%type,
                name               meeting.mee_name%type,
                object             meeting.mee_object%type,
                description        meeting.mee_description%type,
                date_start         meeting.mee_date_start%type,
                nb_time            meeting.mee_nb_time%type,
                is_aborted         meeting.mee_is_aborted%type,
                reason_aborted     meeting.mee_reason_aborted%type,
                nb_place           meeting.mee_nb_place%type,
                nb_place_vacant    int,
                address_street     meeting.mee_address_street%type,
                link_twitch        meeting.mee_link_twitch%type,
                id_political_party meeting.pop_id%type,
                town_code_insee    meeting.twn_code_insee%type
            )
as
$filter$
begin
    return query
        select mee.mee_id                      as id,
               mee_name                        as name,
               mee_object                      as object,
               mee_description                 as description,
               mee_date_start                  as date_start,
               mee_nb_time                     as nb_time,
               mee_is_aborted                  as is_aborted,
               mee_reason_aborted              as reason_aborted,
               mee_nb_place                    as nb_place,
               get_nb_place_vacant(mee.mee_id) as nb_place_vacant,
               mee_address_street              as address_street,
               mee_link_twitch                 as link_twitch,
               mee.pop_id                      as id_political_party,
               mee.twn_code_insee              as town_code_insee
        from meeting mee
                 left join participant ptc on mee.mee_id = ptc.mee_id
        where (_include_aborted = true or mee_is_aborted = false)
          and (_nir is null or ptc.prs_nir = _nir)
          and (_pop_id is null or mee.pop_id = _pop_id)
          and (_town is null or mee.twn_code_insee = _town)
          and (_include_completed = true or nb_place_vacant > 0)
        order by mee_date_start, mee_name desc;

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
                id_political_party thread.pop_id%type
            )
as
$filter$
declare
    is_granted     boolean := is_granted(_nir, 'THREAD#READ');
    is_granted_all boolean := is_granted(_nir, 'THREAD#READ_ALL');
begin
    return query
        select thr.thr_id      as id,
               thr_name        as name,
               thr_main        as main,
               thr_description as description,
               thr_date_create as date_create,
               thr_is_delete   as is_delete,
               thr_date_delete as date_delete,
               thr_is_private  as is_private,
               thr_url_logo    as url_logo,
               thr.pop_id      as id_political_party
        from thread thr
                 left join member mem on thr.thr_id = mem.thr_id and mem.mem_is_left = false
                 left join adherent adh on mem.adh_id = adh.adh_id and adh.prs_nir = _nir
        where ((_only_mine = false and
                (is_granted_all = true or (thr.pop_id = adh.pop_id and thr_is_private = false))) or
               (is_granted = true and adh.adh_id is not null))
          and thr_is_delete = false
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
                id_member      message.mem_id%type
            )
as
$filter$
declare
    is_granted boolean := is_granted(_nir, 'MESSAGE#READ');
begin
    return query
        select msg.msg_id         as id,
               prs_firstname      as firstname,
               prs_lastname       as lastname,
               msg_message        as type,
               msg_date_published as date_published,
               msg.thr_id         as id_thread,
               msg.mem_id         as id_member
        from message msg
                 join thread thr on msg.thr_id = thr.thr_id and thr.thr_id = _thr_id
                 join member mem on msg.mem_id = mem.mem_id and mem.mem_is_left = false
                 join adherent adh on mem.adh_id = adh.adh_id and adh.prs_nir = _nir
                 join person prs on adh.prs_nir = prs.prs_nir
        where is_granted = true
        order by msg_date_published;
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
create or replace function filter_vote(_nir person.prs_nir%type, _include_finish boolean default false,
                                       _include_future boolean default true, _tvo_id vote.tvo_id%type default null)
    returns table
            (
                id                 vote.vte_id%type,
                name               vote.vte_name%type,
                id_type_vote       vote.tvo_id%type,
                town_code_insee    vote.twn_code_insee%type,
                department_code    vote.dpt_code%type,
                reg_code_insee     vote.reg_code_insee%type,
                id_political_party vote.pop_id%type
            )
as
$filter$
declare
    is_granted     boolean   := is_granted(_nir, 'VOTE#READ');
    is_granted_all boolean   := is_granted(_nir, 'VOTE#READ_ALL');
    today          timestamp := now();
begin
    return query
        select vte.vte_id         as id,
               vte_name           as name,
               vte.tvo_id         as id_type_vote,
               vte.twn_code_insee as town_code_insee,
               vte.dpt_code       as department_code,
               vte.reg_code_insee as reg_code_insee,
               vte.pop_id         as id_political_party
        from vote vte
                 left join round rnd on vte.vte_id = rnd.vte_id
                 left join adherent adh on vte.pop_id = adh.pop_id and adh_is_left = false and adh.prs_nir = _nir
        where (is_granted = true or is_granted_all = true)
          and (_tvo_id is null or vte.tvo_id = _tvo_id)
          and ((vte.tvo_id = 7 and (is_granted_all = true or adh.adh_id is not null)) or vte.tvo_id <> 7)
          and ((_include_finish = false and rnd.rnd_date_end >= today) or _include_finish = true)
          and ((_include_future = false and rnd.rnd_date_start <= today) or _include_future = true)
        order by rnd_date_start;
end;
$filter$
    language plpgsql;


-- Filtre pour la table round
create or replace function filter_round(_nir person.prs_nir%type, _include_finish boolean default false,
                                        _include_future boolean default true, _tvo_id vote.tvo_id%type default null,
                                        _vte_id round.vte_id%type default null)
    returns table
            (
                num        round.rnd_num%type,
                name       round.rnd_name%type,
                date_start round.rnd_date_start%type,
                date_end   round.rnd_date_end%type,
                nb_voter   round.rnd_nb_voter%type,
                id_vote    round.vte_id%type
            )
as
$filter$
begin
    return query
        select rnd_num        as num,
               rnd_name       as name,
               rnd_date_start as date_start,
               rnd_date_end   as date_end,
               rnd_nb_voter   as nb_voter,
               vte_id         as id_vote
        from round rnd
                 join filter_vote(_nir, _include_finish, _include_future, _tvo_id) vte on rnd.vte_id = vte.id
        where (_vte_id is null or rnd.vte_id = _vte_id)
        order by rnd_date_start, rnd_num;
end;
$filter$
    language plpgsql;


-- Filtre pour la table choice
create or replace function filter_choice(_nir person.prs_nir%type, _vte_id round.vte_id%type,
                                         _rnd_num round.rnd_num%type)
    returns table
            (
                id           choice.cho_id%type,
                name         choice.cho_name%type,
                choice_order choice.cho_order%type,
                nb_vote      choice.cho_nb_vote%type,
                num_round    choice.rnd_num%type,
                id_vote      choice.vte_id%type,
                description  choice.cho_description%type,
                candidat_nir choice.prs_nir%type,
                candidat     varchar(150)
            )
as
$filter$
begin
    return query
        select cho.cho_id                               as id,
               cho_name                                 as name,
               cho_order                                as choice_order,
               cho_nb_vote                              as nb_vote,
               cho.rnd_num                              as num_round,
               cho.vte_id                               as id_vote,
               cho_description                          as description,
               cho.prs_nir                              as candidat_nir,
               concat(prs_lastname, ' ', prs_firstname) as candidat
        from choice cho
                 join filter_round(_nir, true, true, null, _vte_id) rnd on rnd.num = _rnd_num
                 left join person prs on cho.prs_nir = prs.prs_nir
        order by cho_order, cho_name;
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
                                                    _year int default extract(year from now()))
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
create or replace function vote_get_absention(_tvo_id type_vote.tvo_id%type default null)
    returns table
            (
                nb_abstention   int,
                perc_abstention decimal,
                id_vote         vote.vte_id%type,
                name_vote       vote.vte_name%type,
                num_round       round.rnd_num%type,
                name_round      round.rnd_name%type,
                id_type_vote    vote.tvo_id%type,
                name_type_vote  type_vote.tvo_name%type
            )
as
$filter$
begin
    return query
        select rnd_nb_voter - get_nb_voter(rnd.vte_id, rnd_num)                                   as nb_abstention,
               ((rnd_nb_voter - get_nb_voter(rnd.vte_id, rnd_num))::decimal / rnd_nb_voter) * 100 as perc_abstention,
               rnd.vte_id                                                                         as id_vote,
               vte_name                                                                           as name_vote,
               rnd_num                                                                            as num_round,
               rnd_name                                                                           as name_round,
               vte.tvo_id                                                                         as id_type_vote,
               tvo_name                                                                           as name_type_vote
        from round rnd
                 left join vote vte on rnd.vte_id = vte.vte_id
                 left join type_vote tvo on tvo.tvo_id = vte.tvo_id
        where vte.tvo_id = _tvo_id
           or _tvo_id is null
        order by rnd_date_start desc;
end;
$filter$
    language plpgsql;


-- Statistiques pour les participations par vote
create or replace function vote_get_participation(_tvo_id type_vote.tvo_id%type default null)
    returns table
            (
                nb_participation   int,
                perc_participation decimal,
                id_vote            vote.vte_id%type,
                name_vote          vote.vte_name%type,
                num_round          round.rnd_num%type,
                name_round         round.rnd_name%type,
                id_type_vote       vote.tvo_id%type,
                name_type_vote     type_vote.tvo_name%type
            )
as
$filter$
begin
    return query
        select get_nb_voter(vte.vte_id, rnd_num)                                 as nb_participation,
               (get_nb_voter(vte.vte_id, rnd_num)::decimal / rnd_nb_voter) * 100 as perc_participation,
               rnd.vte_id                                                        as id_vote,
               vte_name                                                          as name_vote,
               rnd_num                                                           as num_round,
               rnd_name                                                          as name_round,
               vte.tvo_id                                                        as id_type_vote,
               tvo_name                                                          as name_type_vote
        from round rnd
                 left join vote vte on rnd.vte_id = vte.vte_id
                 left join type_vote tvo on tvo.tvo_id = vte.tvo_id
        where vte.tvo_id = _tvo_id
           or _tvo_id is null
        order by rnd_date_start desc;
end;
$filter$
    language plpgsql;


-- Résultats de vote
create or replace function vote_get_results(_tvo_id type_vote.tvo_id%type default null,
                                            _tve_id vote.vte_id%type default null)
    returns table
            (
                id_choice               choice.cho_id%type,
                libelle_choice          choice.cho_name%type,
                nb_voice                choice.cho_nb_vote%type,
                perc_with_abstention    decimal,
                perc_without_abstention decimal,
                id_vote                 vote.vte_id%type,
                name_vote               vote.vte_name%type,
                num_round               round.rnd_num%type,
                name_round              round.rnd_name%type,
                id_type_vote            vote.tvo_id%type,
                name_type_vote          type_vote.tvo_name%type
            )
as
$filter$
begin
    return query
        select cho_id                                                               as id_choice,
               cho_name                                                             as libelle_choice,
               cho_nb_vote                                                          as nb_voice,
               (cho_nb_vote::decimal / rnd_nb_voter) * 100                          as perc_with_abstention,
               (cho_nb_vote::decimal / get_nb_voter(rnd.vte_id, rnd.rnd_num)) * 100 as perc_without_abstention,
               rnd.vte_id                                                           as id_vote,
               vte_name                                                             as name_vote,
               rnd.rnd_num                                                          as num_round,
               rnd_name                                                             as name_round,
               vte.tvo_id                                                           as id_type_vote,
               tvo_name                                                             as name_type_vote
        from choice cho
                 join round rnd on cho.rnd_num = rnd.rnd_num
                 join vote vte on rnd.vte_id = vte.vte_id
                 join type_vote tvo on tvo.tvo_id = vte.tvo_id
        where (rnd.vte_id = _tve_id or _tve_id is null)
          and (vte.tvo_id = _tvo_id or _tvo_id is null)
        order by rnd_date_start desc, perc_without_abstention desc;
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


-- Filtre pour la table département
create or replace function filter_department(_code_insee department.reg_code_insee%type default null,
                                             _code department.dpt_code%type default null)
    returns table
            (
                code              department.dpt_code%type,
                name              department.dpt_name%type,
                region_code_insee department.reg_code_insee%type
            )
as
$filter$
begin
    return query
        select dpt_code       as code,
               dpt_name       as name,
               reg_code_insee as region_code_insee
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


-- Filtre pour la table région
create or replace function filter_region(_code_insee region.reg_code_insee%type default null)
    returns table
            (
                code_insee region.reg_code_insee%type,
                name       region.reg_name%type
            )
as
$filter$
begin
    return query
        select reg_code_insee as code_insee,
               reg_name       as name
        from region
        where reg_code_insee = _code_insee
           or _code_insee is null
        order by name;
end;
$filter$
    language plpgsql;

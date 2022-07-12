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

-- Vérifie s'il à les droits pour un role donné
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


-- Récupère l'ID d'un membre par son NIR
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

-- Récupère l'ID d'un adhérent par son NIR
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


-- Récupère le nombre d'adhérent par mois sur un an
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


-- Récupère le nombre de meeting par mois sur un an
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


-- Récupère le nombre de meeting par mois sur un an
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


-- Récupère le nombre de message par heure sur un thread et sur un jour donné
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


-- Récupère le nombre de message par jour sur un thread et sur une semaine donné
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


-- Récupère le nombre de votant pour un tour donné
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

-- Récupère le nombre de votant pour un tour donné
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


-- Récupère le nombre de votant pour un tour donné
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


-- Récupère si un adhérent appartient déjà à un thread ou non
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

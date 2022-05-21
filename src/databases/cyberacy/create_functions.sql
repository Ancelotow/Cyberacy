-- Nombre de place libre pour un meeting
create or replace function get_nb_place_vacant(id meeting.mee_id%type)
    returns int
as
$body$
declare
    nb_participant int;
    nb_place       int;
begin

    select count(*)
    into nb_participant
    from participant
    where mee_id = id
      and ptc_is_aborted = false;

    select mee_nb_place
    into nb_place
    from meeting
    where mee_id = id;

    return (nb_place - nb_participant);

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

    select cho_nb_vote
    into nb_vote
    from choice
    where cho_id = id_choice
      and vte_id = _vte_id
      and rnd_num = _rnd_num;

    if nb_vote is null then
        raise 'This choice not existed in this round.' using errcode = '23503';
    end if;

    nb_vote := nb_vote + 1;

    insert into link_person_round (rnd_num, vte_id, prs_nir) values (_rnd_num, _vte_id, nir);

    update choice
    set cho_nb_vote = nb_vote
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

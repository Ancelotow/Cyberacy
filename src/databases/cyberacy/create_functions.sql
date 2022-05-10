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

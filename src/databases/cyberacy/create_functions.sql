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
                  where rle.rle_code = rle_code);

end;
$body$
    language plpgsql;

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

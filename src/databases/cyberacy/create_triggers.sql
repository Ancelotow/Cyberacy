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

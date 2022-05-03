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

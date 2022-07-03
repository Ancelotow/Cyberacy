-- Trigger AFTER INSERT pour la table "political_party"
create or replace function add_main_thread()
    returns trigger
as
$trigger$
begin
    insert into thread(thr_main, thr_name, thr_description, thr_is_private, thr_url_logo, pop_id)
    values (true, new.pop_name, 'Messagerie principale du parti.', false, new.pop_url_logo, new.pop_id);

    return new;
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

-- Trigger AFTER INSERT pour la table "round"
create or replace function add_choice_blank()
    returns trigger
as
$trigger$
begin
    insert into choice(cho_name, cho_order, cho_description, rnd_num, vte_id)
    values ('vote blanc', 1, 'Vous pouvez voter blanc si aucune des proposition ne vous conviens.', new.rnd_num,
            new.vte_id);

    return new;
end
$trigger$
    language plpgsql;

create trigger trg_add_choice_blank
    after insert
    on round
    for each row
execute procedure add_choice_blank();


-- Trigger BEFORE INSERT pour la table "choice"
create or replace function add_choice()
    returns trigger
as
$trigger$
declare
    date_vote timestamp;
begin
    select rnd_date_start
    into date_vote
    from round
    where rnd_num = new.rnd_num
      and vte_id = new.vte_id;

    if date_vote <= now() then
        raise 'You cannot add a new choice when vote has started.' using errcode = '23503';
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

    if date_vote_started <= now() or date_vote_ended >= now() then
        raise 'You cannot vote before or after the vote.' using errcode = '23503';
    end if;

    return new;
end
$trigger$
    language plpgsql;

create trigger trg_add_add_vote_for_choice
    before update
    on choice
    for each row
execute procedure add_vote_for_choice();


-- Trigger AFTER INSERT pour la table "election"
create or replace function add_election()
    returns trigger
as
$trigger$
begin

    -- Présidentielle / Sondage / Référendum
    if new.tvo_id in (1, 8, 6) then
        insert into vote (vte_name, elc_id, vte_nb_voter)
        select new.elc_name, new.elc_id, sum(twn_nb_resident)
        from town
        group by new.elc_name, new.elc_id;

    -- Régionale
    elsif new.tvo_id = 2 then
        insert into vote (vte_name, elc_id, vte_nb_voter, reg_code_insee)
        select concat(new.elc_name, ' : ', reg_name), new.elc_id, sum(twn_nb_resident), reg.reg_code_insee
        from region reg
                 join department dpt on reg.reg_code_insee = dpt.reg_code_insee
                 join town twn on dpt.dpt_code = twn.dpt_code
        group by reg_name, new.elc_name, new.elc_id, reg.reg_code_insee;

    -- Départementale
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


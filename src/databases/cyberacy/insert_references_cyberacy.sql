do
$sex$
begin
    if not exists (select * from sex where sex_id = 1) then
        insert into sex(sex_id, sex_name) values (1, 'Homme');
    end if;

    if not exists (select * from sex where sex_id = 2) then
        insert into sex(sex_id, sex_name) values (2, 'Femme');
    end if;
end;
$sex$;

do
$type_vote$
begin
    if not exists (select * from type_vote where tvo_id = 1) then
        insert into type_vote(tvo_id, tvo_name) values (1, 'Présidentiel');
    end if;

    if not exists (select * from type_vote where tvo_id = 2) then
        insert into type_vote(tvo_id, tvo_name) values (2, 'Régional');
    end if;

    if not exists (select * from type_vote where tvo_id = 3) then
        insert into type_vote(tvo_id, tvo_name) values (3, 'Départemental');
    end if;

    if not exists (select * from type_vote where tvo_id = 4) then
        insert into type_vote(tvo_id, tvo_name) values (4, 'Municipal');
    end if;

    if not exists (select * from type_vote where tvo_id = 5) then
        insert into type_vote(tvo_id, tvo_name) values (5, 'Législative');
    end if;

    if not exists (select * from type_vote where tvo_id = 6) then
        insert into type_vote(tvo_id, tvo_name) values (6, 'Référundum');
    end if;
end;
$type_vote$;

do
$type_step$
begin
    if not exists (select * from type_step where tst_id = 1) then
        insert into type_step(tst_id, tst_name) values (1, 'Départ');
    end if;

    if not exists (select * from type_step where tst_id = 2) then
        insert into type_step(tst_id, tst_name) values (2, 'Etape');
    end if;

    if not exists (select * from type_step where tst_id = 3) then
        insert into type_step(tst_id, tst_name) values (3, 'Arrivée');
    end if;
end;
$type_step$;

do
$type_step$
    begin
        if not exists (select * from political_edge where poe_id = 1) then
            insert into political_edge(poe_id, poe_name) values (1, 'Extrême gauche');
        end if;

        if not exists (select * from political_edge where poe_id = 2) then
            insert into political_edge(poe_id, poe_name) values (2, 'Gauche');
        end if;

        if not exists (select * from political_edge where poe_id = 3) then
            insert into political_edge(poe_id, poe_name) values (3, 'Centre gauche');
        end if;

        if not exists (select * from political_edge where poe_id = 4) then
            insert into political_edge(poe_id, poe_name) values (4, 'Centre droite');
        end if;

        if not exists (select * from political_edge where poe_id = 5) then
            insert into political_edge(poe_id, poe_name) values (5, 'Droite');
        end if;

        if not exists (select * from political_edge where poe_id = 6) then
            insert into political_edge(poe_id, poe_name) values (6, 'Extrême droite');
        end if;
    end;
$type_step$;




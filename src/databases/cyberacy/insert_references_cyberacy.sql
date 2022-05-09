do
$sex$
    begin
        if not exists(select * from sex where sex_id = 1) then
            insert into sex(sex_id, sex_name) values (1, 'Homme');
        end if;

        if not exists(select * from sex where sex_id = 2) then
            insert into sex(sex_id, sex_name) values (2, 'Femme');
        end if;
    end;
$sex$;

do
$type_vote$
    begin
        if not exists(select * from type_vote where tvo_id = 1) then
            insert into type_vote(tvo_id, tvo_name) values (1, 'Présidentiel');
        end if;

        if not exists(select * from type_vote where tvo_id = 2) then
            insert into type_vote(tvo_id, tvo_name) values (2, 'Régional');
        end if;

        if not exists(select * from type_vote where tvo_id = 3) then
            insert into type_vote(tvo_id, tvo_name) values (3, 'Départemental');
        end if;

        if not exists(select * from type_vote where tvo_id = 4) then
            insert into type_vote(tvo_id, tvo_name) values (4, 'Municipal');
        end if;

        if not exists(select * from type_vote where tvo_id = 5) then
            insert into type_vote(tvo_id, tvo_name) values (5, 'Législative');
        end if;

        if not exists(select * from type_vote where tvo_id = 6) then
            insert into type_vote(tvo_id, tvo_name) values (6, 'Référundum');
        end if;
    end;
$type_vote$;

do
$type_step$
    begin
        if not exists(select * from type_step where tst_id = 1) then
            insert into type_step(tst_id, tst_name) values (1, 'Départ');
        end if;

        if not exists(select * from type_step where tst_id = 2) then
            insert into type_step(tst_id, tst_name) values (2, 'Etape');
        end if;

        if not exists(select * from type_step where tst_id = 3) then
            insert into type_step(tst_id, tst_name) values (3, 'Arrivée');
        end if;
    end;
$type_step$;

do
$role$
    begin
        if not exists(select * from role where rle_id = 1) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (1, 'Connexion app Android', 'Connexion à l''application Android', 'APP_ANDROID#CONNECTION');
        end if;
        if not exists(select * from role where rle_id = 2) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (2, 'Connexion app IOS', 'Connexion à l''application IOS', 'APP_IOS#CONNECTION');
        end if;
        if not exists(select * from role where rle_id = 3) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (3, 'Connexion Back-Office', 'Connexion au Back-Office web', 'BO#CONNECTION');
        end if;
        if not exists(select * from role where rle_id = 4) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (4, 'Accès au module "Manifestation"', 'Accéder au module "Manifestaion"', 'MODULE_MANIFESTAION#ACCESS');
        end if;
        if not exists(select * from role where rle_id = 5) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (5, 'Accès au module "Parti politique"', 'Accéder au module "Parti politique"', 'MODULE_POLITICAL_PARTY#ACCESS');
        end if;
        if not exists(select * from role where rle_id = 6) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (6, 'Accès au module "Vote"', 'Accéder au module "Vote"', 'MODULE_VOTE#ACCESS');
        end if;
        if not exists(select * from role where rle_id = 7) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (7, 'THREAD : Lecture', 'Voir la liste des threads', 'THREAD#READ');
        end if;
        if not exists(select * from role where rle_id = 8) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (8, 'THREAD : Lecture tout', 'Voir la liste de tout les threads', 'THREAD#READ_ALL');
        end if;
        if not exists(select * from role where rle_id = 9) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (9, 'MESSAGE : Publier', 'Pouvoir ajouter un message', 'MESSAGE#PUBLISH');
        end if;
        if not exists(select * from role where rle_id = 10) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (10, 'MESSAGE : Lecture', 'Lire les message', 'MESSAGE#READ');
        end if;
    end;
$role$;




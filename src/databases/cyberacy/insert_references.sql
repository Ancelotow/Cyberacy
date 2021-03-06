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

        if not exists(select * from type_vote where tvo_id = 7) then
            insert into type_vote(tvo_id, tvo_name) values (7, 'Sondage privé');
        end if;

        if not exists(select * from type_vote where tvo_id = 8) then
            insert into type_vote(tvo_id, tvo_name) values (8, 'Sondage public');
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
            values (4, 'Accès au module "Manifestation"', 'Accéder au module "Manifestaion"',
                    'MODULE_MANIFESTAION#ACCESS');
        end if;
        if not exists(select * from role where rle_id = 5) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (5, 'Accès au module "Parti politique"', 'Accéder au module "Parti politique"',
                    'MODULE_POLITICAL_PARTY#ACCESS');
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
            values (10, 'MESSAGE : Lecture', 'Lire les messages d''un thread', 'MESSAGE#READ');
        end if;
        if not exists(select * from role where rle_id = 11) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (11, 'MEMBRES : Lecture', 'Voir les membres d''un thread', 'MEMBER#READ');
        end if;
        if not exists(select * from role where rle_id = 12) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (12, 'THREAD : Join', 'Pouvoir rejoindre un thread', 'THREAD#JOIN');
        end if;
        if not exists(select * from role where rle_id = 13) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (13, 'VOTE : Lecture', 'Pouvoir voir les votes (sondage privé exclus)', 'VOTE#READ');
        end if;
        if not exists(select * from role where rle_id = 14) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (14, 'VOTE : Lecture tout', 'Pouvoir voir les votes (sondage privé inclus)', 'VOTE#READ_ALL');
        end if;
        if not exists(select * from role where rle_id = 15) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (15, 'PARTI POLITIQUE : Créer un thread', 'Pouvoir créer un thread dans un parti politique',
                    'THREAD$$$CREATE');
        end if;
        if not exists(select * from role where rle_id = 16) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (16, 'PARTI POLITIQUE : Supprimer un thread', 'Pouvoir supprimer un thread', 'THREAD$$$DELETE');
        end if;
        if not exists(select * from role where rle_id = 17) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (17, 'PARTI POLITIQUE : Inviter dans un thread', 'Pouvoir inviter une personne dans un thread',
                    'THREAD$$$INVITED');
        end if;
        if not exists(select * from role where rle_id = 18) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (18, 'PERSONNES : Lecture', 'Pouvoir voir la liste des personnes', 'PERSON$$$READ');
        end if;
        if not exists(select * from role where rle_id = 19) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (19, 'Accès au module UTILISATEUR', 'Accéder au module UTILISATEUR sur le Back-Office', 'USER$$$ACCESS');
        end if;
        if not exists(select * from role where rle_id = 20) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (20, 'PROFILE : Lecture', 'Pouvoir voir la liste des profiles', 'PROFIL$$$READ');
        end if;
        if not exists(select * from role where rle_id = 21) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (21, 'Accès au module PROFILE', 'Accéder au module PROFILE sur le Back-Office', 'PROFIL$$$ACCESS');
        end if;
        if not exists(select * from role where rle_id = 22) then
            insert into role(rle_id, rle_title, rle_description, rle_code)
            values (22, 'DROITS : Lecture', 'Pouvoir voir la liste des droits', 'ROLE$$$READ');
        end if;
    end;
$role$;

do
$profile$
    begin
        if not exists(select * from profile where prf_id = 1) then
            insert into profile(prf_id, prf_name, prf_can_deleted) values (1, 'Super Administrateur', false);
        end if;

        if not exists(select * from profile where prf_id = 2) then
            insert into profile(prf_id, prf_name, prf_can_deleted) values (2, 'Administrateur', false);
        end if;

        if not exists(select * from profile where prf_id = 3) then
            insert into profile(prf_id, prf_name, prf_can_deleted)
            values (3, 'Administrateur (Parti politique)', false);
        end if;

        if not exists(select * from profile where prf_id = 4) then
            insert into profile(prf_id, prf_name, prf_can_deleted) values (4, 'Utilisateur', false);
        end if;
    end;
$profile$;


do
$profile$
    begin
        delete
        from link_role_profile
        where prf_id in (select prf_id
                         from profile
                         where prf_can_deleted = false);

        -- Super Administrateur
        insert into link_role_profile(rle_id, prf_id)
        select rle_id, 1
        from role;

        -- Administrateur
        insert into link_role_profile(rle_id, prf_id)
        select rle_id, 2
        from role
        where rle_code not in (
            'THREAD$$$DELETE'
            );

        -- Administrateur (Parti Politique)
        insert into link_role_profile(rle_id, prf_id)
        select rle_id, 3
        from role
        where rle_code in (
                           'THREAD$$$INVITED', 'THREAD$$$DELETE', 'THREAD$$$CREATE', 'THREAD#READ_ALL', 'THREAD#READ',
                           'MESSAGE#READ', 'MEMBER#READ'
            );
    end;
$profile$;
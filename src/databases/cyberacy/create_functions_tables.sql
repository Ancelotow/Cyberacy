-- Filtre pour la table political_party
create or replace function filter_political_party(_nir adherent.prs_nir%type default null,
                                                  _siren political_party.pop_siren%type default null,
                                                  _id political_party.pop_id%type default null,
                                                  _include_left boolean default false)
    returns table
            (
                id                political_party.pop_id%type,
                name              political_party.pop_name%type,
                url_logo          political_party.pop_url_logo%type,
                date_create       political_party.pop_date_create%type,
                description       political_party.pop_description%type,
                is_delete         political_party.pop_is_delete%type,
                date_delete       political_party.pop_date_delete%type,
                object            political_party.pop_object%type,
                address_street    political_party.pop_address_street%type,
                siren             political_party.pop_siren%type,
                chart             political_party.pop_chart%type,
                iban              political_party.pop_iban%type,
                url_bank_details  political_party.pop_url_bank_details%type,
                url_chart         political_party.pop_url_chart%type,
                id_political_edge political_party.poe_id%type,
                nir               political_party.prs_nir%type,
                town_code_insee   political_party.twn_code_insee%type
            )
as
$filter$
begin
    return query
        select distinct pop.pop_id           as id,
                        pop_name             as name,
                        pop_url_logo         as url_logo,
                        pop_date_create      as date_create,
                        pop_description      as description,
                        pop_is_delete        as is_delete,
                        pop_date_delete      as date_delete,
                        pop_object           as object,
                        pop_address_street   as address_street,
                        pop_siren            as siren,
                        pop_chart            as chart,
                        pop_iban             as iban,
                        pop_url_bank_details as url_bank_details,
                        pop_url_chart        as url_chart,
                        poe_id               as id_political_edge,
                        pop.prs_nir          as nir,
                        twn_code_insee       as town_code_insee
        from political_party pop
                 left join adherent adh on pop.pop_id = adh.pop_id
        where (_nir is null or adh.prs_nir = _nir)
          and (pop_siren = _siren or _siren is null)
          and (pop.pop_id = _id or _id is null)
          and ((adh_is_left = false and _include_left = false) or _include_left = true)
        order by pop_name;
end;
$filter$
    language plpgsql;

-- Filtre pour la table manifestation
create or replace function filter_manifestation(_nir adherent.prs_nir%type default null,
                                                _include_aborted boolean default false,
                                                _id manifestation.man_id%type default null)
    returns table
            (
                id                   manifestation.man_id%type,
                name                 manifestation.man_name%type,
                date_start           manifestation.man_date_start%type,
                date_end             manifestation.man_date_end%type,
                is_aborted           manifestation.man_is_aborted%type,
                date_aborted         manifestation.man_date_aborted%type,
                date_create          manifestation.man_date_create%type,
                object               manifestation.man_object%type,
                security_description manifestation.man_security_description%type,
                nb_person_estimate   manifestation.man_nb_person_estimate%type,
                url_document_signed  manifestation.man_url_document_signed%type,
                reason_aborted       manifestation.man_reason_aborted%type
            )
as
$filter$
begin
    return query
        select man.man_id               as id,
               man_name                 as name,
               man_date_start           as date_start,
               man_date_end             as date_end,
               man_is_aborted           as is_aborted,
               man_date_aborted         as date_aborted,
               man_date_create          as date_create,
               man_object               as object,
               man_security_description as security_description,
               man_nb_person_estimate   as nb_person_estimate,
               man_url_document_signed  as url_document_signed,
               man_reason_aborted       as reason_aborted
        from manifestation man
                 left join manifestant mnf on man.man_id = mnf.man_id
        where (_nir is null or mnf.prs_nir = _nir)
          and (_include_aborted = true or man_is_aborted = false)
          and (_id is null or man.man_id = _id)
        order by man_date_start desc;
end;
$filter$
    language plpgsql;

-- Filtre pour la table Adhérent
create or replace function filter_adherent(_nir adherent.prs_nir%type default null,
                                           _id political_party.pop_id%type default null,
                                           _include_left boolean default false)
    returns table
            (
                id                   adherent.adh_id%type,
                date_join            adherent.adh_date_join%type,
                date_left            adherent.adh_date_left%type,
                is_left              adherent.adh_is_left%type,
                id_political_party   adherent.pop_id%type,
                nir                  adherent.prs_nir%type
            )
as
$filter$
begin
    return query
        select adh_id        as id,
               adh_date_join as date_join,
               adh_date_left as date_left,
               adh_is_left   as is_left,
               pop_id        as id_political_party,
               prs_nir       as nir
        from adherent adh
        where (_nir is null or prs_nir = _nir)
        and (_id is null or pop_id = _id)
        and (_include_left = true or adh_is_left = false)
        order by date_join;
end;
$filter$
    language plpgsql;

-- Filtre pour la table annual_fee
create or replace function filter_annual_fee(_year annual_fee.afe_year%type default null,
                                            _pop_id annual_fee.pop_id%type default null)
    returns table
            (
                afe_year            annual_fee.afe_year%type,
                id_political_party  annual_fee.pop_id%type,
                fee                 annual_fee.afe_fee%type
            )
as
$filter$
begin
    return query
        select afe_year as year,
               pop_id   as id_political_party,
               afe_fee  as fee
        from annual_fee
        where (_year is null or afe_year = _year)
          and (_pop_id is null or pop_id = _pop_id);
end;
$filter$
    language plpgsql;

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
          and ((adh_is_left = false and _include_left = false) or _include_left = true);
end;
$filter$
    language plpgsql;

-- Création d'un CRON pour créer tout les second tour toutes les 15 minutes
select cron.schedule('create-second-round', '*/15 * * * *', $$select create_second_round(v.vte_id)
from round rnd
    join vote v on rnd.vte_id = v.vte_id
    join election e on v.elc_id = e.elc_id
where elc_date_start < now()
and elc_date_end > now()
and rnd.rnd_date_end < now()$$);

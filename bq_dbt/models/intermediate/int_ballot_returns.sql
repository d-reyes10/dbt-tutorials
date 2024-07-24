select v.*, b.early_ballot_method
from {{ref('stg_ga_targetsmart_voter_base')}} v
left join {{ref('stg_ga_distances_ga_early_ballot_returns')}} b on v.voterbase_id = b.voterbase_id
{{ config(materialized='view') }}

with base as (
    select vb.*
    from {{ source('ga_targetsmart', 'voter_base') }} as vb
    left join {{ source('ga_distances', 'ga_early_ballot_returns') }} as eballot on vb.voterbase_id=eballot.voterbase_id
)

select *
from base
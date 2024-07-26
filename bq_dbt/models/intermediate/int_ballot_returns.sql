with voterfile as (
    select * from {{ ref('stg_ga_targetsmart_voter_base')}}
) 
, ballot_returns as (
    select * from {{ ref('stg_ga_distances_ga_early_ballot_returns')}}
)
, final as (
    select 
        b.voterbase_id,
        b.aug_primary_voted_date,
        b.early_ballot_method,
        v.vb_vf_cd
    from ballot_returns b 
    left join voterfile v on v.voterbase_id = b.voterbase_id
)

select * from final
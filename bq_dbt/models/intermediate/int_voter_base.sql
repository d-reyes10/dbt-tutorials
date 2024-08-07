with voterfile as (
    select * from {{ ref('stg_ga_targetsmart_voter_base')}}
) 
, ballot_returns as (
    select * from {{ ref('stg_ga_distances_ga_early_ballot_returns')}}
)
, final as (
    select 
        v.voterbase_id,
        b.aug_primary_voted_date,
        b.early_ballot_method,
        v.vb_vf_cd,
        v.vb_tsmart_cd,
        v.vb_reg_latitude,
        v.vb_reg_longitude,
        v.vb_tsmart_latitude,
        v.vb_tsmart_longitude,
        v.vb_tsmart_midterm_general_turnout_score,
        v.vb_tsmart_partisan_score
    from voterfile v 
    left join ballot_returns b on v.voterbase_id = b.voterbase_id
)

select * from final
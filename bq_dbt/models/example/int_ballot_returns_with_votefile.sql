with votefile as (
    select * from {{ ref('stg_ga_targetsmart_voter_base') }}
)

, ballot_returns as (
    select * from {{ ref('stg_ga_distances_ga_early_ballot_returns') }}
)

, joined as (
    select
        ballot_returns.voterbase_id
        , ballot_returns.aug_primary_voted_date
        , voterfile.vb_vf_cd
    from ballot_returns
    left join voterfile using (voterbase_id)
)

select * from joined 
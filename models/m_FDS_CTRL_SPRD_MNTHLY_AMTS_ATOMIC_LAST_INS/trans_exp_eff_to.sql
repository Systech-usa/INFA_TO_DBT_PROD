{{ config(materialized='table', tags=['m_FDS_CTRL_SPRD_MNTHLY_AMTS_ATOMIC_LAST_INS']) }}

-- trans_exp_eff_to.sql
with sq_ctrl_sprd_mnthly_amts_temp1 as (
    select * from {{ ref('stg_sq_ctrl_sprd_mnthly_amts_temp1') }}
),

trans_exp_eff_to as (
    select
        sq.eff_to_tistmp as eff_to_tistmp,
        sq.eff_fm_tistmp as eff_fm_tistmp,
        iff(sq.eff_to_tistmp = sq.eff_fm_tistmp OR TO_CHAR(sq.eff_to_tistmp, 'YYYY-MM-DD HH24:MI:SS') = '1900-01-01 00:00:00' OR TO_CHAR(sq.eff_to_tistmp, 'YYYY-MM-DD HH24:MI:SS') = 
'2999-12-31 00:00:00'  , sq.eff_to_tistmp,dateadd(day, -1, sq.eff_to_tistmp)) as out_eff_to_tistmp
    from sq_ctrl_sprd_mnthly_amts_temp1 sq
)

select * from trans_exp_eff_to

--End-DBShift
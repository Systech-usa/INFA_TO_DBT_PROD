-- trans_exp_eff_to
{{ config(
    materialized='table',
    tags=['m_fds_ctrl_sprd_mnthly_amts_atomic_last_ins']
) }}

with stg_sq_ctrl_sprd_mnthly_amts_temp1 as (
    select 
        eff_to_tistmp as in_eff_to_tistmp,
        eff_fm_tistmp as eff_fm_tistmp
    from {{ ref('stg_sq_ctrl_sprd_mnthly_amts_temp1') }}
),

trans_exp_eff_to as (
    select 
        IFF(
            in_eff_to_tistmp = eff_fm_tistmp 
            OR TO_VARCHAR(in_eff_to_tistmp, 'YYYY-MM-DD HH24:MI:SS') = '1900-01-01 00:00:00' 
            OR TO_VARCHAR(in_eff_to_tistmp, 'YYYY-MM-DD HH24:MI:SS') = '2999-12-31 00:00:00', 
            in_eff_to_tistmp,
            DATEADD(day, -1, in_eff_to_tistmp)
        ) as out_eff_to_tistmp
    from stg_sq_ctrl_sprd_mnthly_amts_temp1
)

select 
    out_eff_to_tistmp 
from trans_exp_eff_to
--End-DBShift
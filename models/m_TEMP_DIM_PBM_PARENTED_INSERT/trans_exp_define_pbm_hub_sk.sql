{{ config(materialized='table', tags=['m_TEMP_DIM_PBM_PARENTED_INSERT']) }}

-- trans_exp_define_pbm_hub_sk.sql
with sq_gnp2_lib_ods_abforce_pbm as (
    select * from {{ ref('stg_sq_gnp2_lib_ods_abforce_pbm') }}
),

trans_exp_define_pbm_hub_sk as (
    select
        sq.batch_id as batch_id,
        sq.batch_row_id as batch_row_id,
        iff(sq.pbm_lgcy_sfdc_id is null,sq.pbm_cd_hk,sq.pbm_lgcy_cd_hk) as o_pbm_hub_hk,
        iff(sq.pbm_lgcy_sfdc_id is null,sq.pbm_cd,sq.pbm_lgcy_sfdc_id) as o_pbm_cd
    from sq_gnp2_lib_ods_abforce_pbm sq
)

select * from trans_exp_define_pbm_hub_sk

--End-DBShift
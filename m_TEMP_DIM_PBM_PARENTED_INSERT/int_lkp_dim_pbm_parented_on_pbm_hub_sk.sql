{{ config(materialized='table', tags=["m_TEMP_DIM_PBM_PARENTED_INSERT"]) }}

with dim_pbm_parented_lkp as (
    select
        pbm_hub_sk, src_sys_pbm_id, pbm_nm, pbm_leg_nm, crt_batch_id, crt_batch_row_id, crt_tmsp
    from {{ source('GNP2DATA', 'DIM_PBM_PARENTED') }}
),

sq_gnp2_lib_ods_abforce_pbm as (
    select * from {{ ref('stg_sq_gnp2_lib_ods_abforce_pbm') }}
),

exp_define_pbm_hub_sk as (
    select * from {{ ref('trans_exp_define_pbm_hub_sk') }}
),

int_lkp_dim_pbm_parented_on_pbm_hub_sk as (
    select
        a.batch_id as ods_batch_id,
        a.batch_row_id as ods_batch_row_id,
        a.crt_tmsp as ods_crt_tmsp,
        a.pbm_cd_hk as ods_pbm_cd_hk,
        a.pbm_nm as ods_pbm_nm,
        a.pbm_cd as ods_pbm_cd,
        a.pbm_leg_nm as ods_pbm_leg_nm,
        a.pbm_lgcy_sfdc_id as pbm_lgcy_sfdc_id,
        a.pbm_lgcy_cd_hk as pbm_lgcy_cd_hk,
        a.pbm_hub_hk as pbm_hub_hk,
        a.o_pbm_cd as o_pbm_cd,
        b.pbm_hub_sk,
        b.src_sys_pbm_id,
        b.pbm_nm,
        b.pbm_leg_nm,
        b.crt_batch_id,
        b.crt_batch_row_id,
        b.crt_tmsp
    from sq_gnp2_lib_ods_abforce_pbm a
    left join exp_define_pbm_hub_sk c
        on a.batch_id = c.batch_id and a.batch_row_id = c.batch_row_id
    left join dim_pbm_parented_lkp b
        on b.pbm_hub_sk = c.o_pbm_hub_hk
)

select * from int_lkp_dim_pbm_parented_on_pbm_hub_sk

--End-DBShift
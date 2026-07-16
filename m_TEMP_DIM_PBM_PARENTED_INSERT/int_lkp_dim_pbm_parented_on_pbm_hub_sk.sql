-- int_lkp_dim_pbm_parented_on_pbm_hub_sk.sql
{{ config(materialized='table', tags=["m_TEMP_DIM_PBM_PARENTED_INSERT"]) }}

with dim_pbm_parented as (
    select
        pbm_hub_sk,
        src_sys_pbm_id,
        pbm_nm,
        pbm_leg_nm,
        crt_batch_id,
        crt_batch_row_id,
        crt_tmsp
    from {{ source('GNP2ODS', 'GNP2DATA.DIM_PBM_PARENTED') }}
),

stg_sq_gnp2_lib_ods_abforce_pbm as (
    select * from {{ ref('stg_sq_gnp2_lib_ods_abforce_pbm') }}
),

trans_exp_define_pbm_hub_sk as (
    select * from {{ ref('trans_exp_define_pbm_hub_sk') }}
),

int_lkp_dim_pbm_parented_on_pbm_hub_sk as (
    select
        b.pbm_hub_sk,
        b.src_sys_pbm_id,
        b.pbm_nm,
        b.pbm_leg_nm,
        b.crt_batch_id,
        b.crt_batch_row_id,
        b.crt_tmsp,
        a.batch_id as ods_batch_id,
        a.batch_row_id as ods_batch_row_id,
        a.crt_tmsp as ods_crt_tmsp,
        a.pbm_cd_hk as ods_pbm_cd_hk,
        a.pbm_nm as ods_pbm_nm,
        a.pbm_cd as ods_pbm_cd,
        a.pbm_leg_nm as ods_pbm_leg_nm,
        a.pbm_lgcy_sfdc_id as pbm_lgcy_sfdc_id,
        a.pbm_lgcy_cd_hk as pbm_lgcy_cd_hk,
        c.o_pbm_hub_hk as pbm_hub_hk,
        c.o_pbm_cd as o_pbm_cd
    from stg_sq_gnp2_lib_ods_abforce_pbm a
    left join trans_exp_define_pbm_hub_sk c
        on coalesce(a.pbm_cd_hk, -999999999) = coalesce(c.i_pbm_cd_hk, -999999999)
        and coalesce(a.pbm_cd, '^^') = coalesce(c.i_pbm_cd, '^^')
        and coalesce(a.pbm_lgcy_sfdc_id, '^^') = coalesce(c.i_pbm_lgcy_sfdc_id, '^^')
        and coalesce(a.pbm_lgcy_cd_hk, -999999999) = coalesce(c.i_pbm_lgcy_cd_hk, -999999999)
    left join dim_pbm_parented b
        on c.o_pbm_hub_hk = b.pbm_hub_sk
)

select
    pbm_hub_sk,
    src_sys_pbm_id,
    pbm_nm,
    pbm_leg_nm,
    crt_batch_id,
    crt_batch_row_id,
    crt_tmsp,
    ods_batch_id,
    ods_batch_row_id,
    ods_crt_tmsp,
    ods_pbm_cd_hk,
    ods_pbm_nm,
    ods_pbm_cd,
    ods_pbm_leg_nm,
    pbm_lgcy_sfdc_id,
    pbm_lgcy_cd_hk,
    pbm_hub_hk,
    o_pbm_cd
from int_lkp_dim_pbm_parented_on_pbm_hub_sk

--End-DBShift
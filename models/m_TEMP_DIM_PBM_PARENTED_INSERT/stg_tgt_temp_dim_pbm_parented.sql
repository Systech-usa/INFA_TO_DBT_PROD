{{ config(
    materialized='incremental',
    tags=['m_TEMP_DIM_PBM_PARENTED_INSERT']
) }}

-- target: TEMP_DIM_PBM_PARENTED
with fltr_transformation as (
    select * from {{ ref('int_fltr_transformation') }}
),

stg_tgt_temp_dim_pbm_parented as (
    select
        fltr_transformation.o_pbm_hub_hk as pbm_hub_sk,
        fltr_transformation.ods_pbm_cd as src_sys_pbm_id,
        fltr_transformation.ods_pbm_nm as pbm_nm,
        fltr_transformation.ods_pbm_leg_nm as pbm_leg_nm,
        fltr_transformation.o_crt_batchid as crt_batch_id,
        fltr_transformation.o_crt_batch_row_id as crt_batch_row_id,
        fltr_transformation.o_crt_tmsp as crt_tmsp,
        fltr_transformation.o_upd_user as upd_user,
        fltr_transformation.o_pbm_cd as pbm_cd
    from fltr_transformation
)

select * from stg_tgt_temp_dim_pbm_parented
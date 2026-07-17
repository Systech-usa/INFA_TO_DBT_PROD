{{ config(materialized='table', tags=['m_FDS_UUBVI_ELIM_WORK_INIT_GPNG_FINC_INS_WRK']) }}

-- trans_r_exp_set_audit_cols_pdo.sql
with sq_ctrl_uubvi_elim_work_init_gpng_finc_ins as (
    select * from {{ ref('stg_sq_ctrl_uubvi_elim_work_init_gpng_finc_ins') }}
),

trans_r_exp_set_audit_cols_pdo as (
    select
        sq.acc_expo_yr_mm as acc_expo_yr_mm,
        sq.out_eff_to_tistmp as out_eff_to_tistmp,
        sq.out_eff_fm_tistmp as out_eff_fm_tistmp,
        $$BATCH_ID as out_batch_id,
        $$POP_INFO_ID as out_pop_info_id
    from sq_ctrl_uubvi_elim_work_init_gpng_finc_ins sq
)

select * from trans_r_exp_set_audit_cols_pdo

--End-DBShift
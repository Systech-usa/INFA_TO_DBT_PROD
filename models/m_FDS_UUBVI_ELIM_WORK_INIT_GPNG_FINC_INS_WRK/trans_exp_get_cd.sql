{{ config(materialized='table', tags=['m_FDS_UUBVI_ELIM_WORK_INIT_GPNG_FINC_INS_WRK']) }}

-- trans_exp_get_cd.sql
with shortcut_to_mplt_valdt_curr_cd as (
    select * from {{ ref('int_shortcut_to_mplt_valdt_curr_cd') }}
),

trans_exp_get_cd as (
    select
        sq.out_valdt_curr_cd as out_valdt_curr_cd
    from shortcut_to_mplt_valdt_curr_cd sq
)

select * from trans_exp_get_cd

--End-DBShift
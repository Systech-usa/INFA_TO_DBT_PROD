{{ config(materialized='view', tags=["m_FDS_CTRL_SPRD_MNTHLY_AMTS_ATOMIC_LAST_INS"]) }}

with int_union_all_recs as (
    select * from {{ ref('int_union_all_recs') }}
),

srt_dates as (
    select 
        prtclr_mony_provsn_id,
        etl_sys_nm,
        monthly_date,
        agmt_anchr_id,
        base_amt,
        daily_amt,
        prem_amt,
        eff_md_yr_mo,
        pop_info_id,
        batch_id,
        mnth_yr_part_eff_to,
        mnth_yr_part_last_day,
        covg_cmpnt_agmt_anchr_id,
        out_comm_amt,
        out_der_comm_amt,
        out_tran_prem_amt,
        tran_comm_amt,
        out_der_tran_prem_amt,
        out_der_tran_comm_amt,
        out_contr_prem_amt,
        out_der_contr_prem_amt,
        src_ln_of_busn_cd as src_ln_of_busn_cd41,
        out_contr_comm_amt as out_contr_comm_amt41,
        out_der_contr_comm_amt as out_der_contr_comm_amt41,
        crcy_cd,
        tran_crcy_cd,
        contr_crcy_cd
    from int_union_all_recs
    order by 
        prtclr_mony_provsn_id asc,
        etl_sys_nm asc,
        monthly_date asc
)

select * from srt_dates
--End-DBShift
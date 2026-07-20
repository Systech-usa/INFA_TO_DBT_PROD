-- SRT_TRL_SPRD_2YR_DATES
{{ config(materialized='view', tags=["m_FDS_CTRL_SPRD_MNTHLY_AMTS_ATOMIC_LAST_INS"]) }}

with int_filtr_trl_sprd_2yr_term_recs as (
    select * from {{ ref('int_filtr_trl_sprd_2yr_term_recs') }}
),

srt_trl_sprd_2yr_dates as (
    select
        prtclr_mony_provsn_id as prtclr_mony_provsn_id,
        etl_sys_nm as etl_sys_nm,
        monthly_date as monthly_date,
        agmt_anchr_id as agmt_anchr_id,
        base_amt as base_amt,
        daily_amt as daily_amt,
        out_trl_sprd_ind as trl_sprd_ind,
        out_mnth_yr_part_trl_sprd_2yr_last_day as mnth_yr_part_trl_sprd_2yr_last_day,
        out_trl_sprd_2yr_base_amt as trl_sprd_2yr_base_amt,
        out_trl_sprd_2yr_last_mnth_rem_days as trl_sprd_2yr_last_mnth_rem_days,
        out_trl_sprd_rem_term_dly_amt as trl_sprd_rem_term_dly_amt,
        prem_amt as prem_amt,
        eff_md_yr_mo as eff_md_yr_mo,
        pop_info_id as pop_info_id,
        batch_id as batch_id,
        mnth_yr_part_eff_to as mnth_yr_part_eff_to,
        mnth_yr_part_last_day as mnth_yr_part_last_day,
        covg_cmpnt_agmt_anchr_id as covg_cmpnt_agmt_anchr_id,
        out_comm_amt as out_comm_amt,
        out_trl_sprd_2yr_comm_amt as trl_sprd_2yr_comm_amt,
        out_trl_sprd_rem_term_comm_dly_amt as trl_sprd_rem_term_comm_dly_amt,
        out_der_comm_amt as out_der_comm_amt,
        out_tran_prem_amt as out_tran_prem_amt,
        tran_comm_amt as tran_comm_amt,
        out_trl_sprd_2yr_tran_prem_amt as trl_sprd_2yr_tran_prem_amt,
        out_trl_sprd_rem_term_tran_prem_dly_amt as trl_sprd_rem_term_tran_prem_dly_amt,
        out_der_tran_prem_amt as out_der_tran_prem_amt,
        out_trl_sprd_2yr_tran_comm_amt as out_trl_sprd_2yr_tran_comm_amt,
        out_trl_sprd_rem_term_tran_comm_dly_amt as trl_sprd_rem_term_tran_comm_dly_amt,
        out_der_tran_comm_amt as out_der_tran_comm_amt,
        out_contr_prem_amt as out_contr_prem_amt,
        out_trl_sprd_2yr_contr_prem_amt as out_trl_sprd_2yr_contr_prem_amt,
        out_trl_sprd_rem_term_contr_prem_dly_amt as out_trl_sprd_rem_term_contr_prem_dly_amt,
        out_der_contr_prem_amt as out_der_contr_prem_amt,
        src_ln_of_busn_cd as src_ln_of_busn_cd41,
        out_contr_comm_amt as out_contr_comm_amt41,
        out_trl_sprd_2yr_contr_comm_amt as out_trl_sprd_2yr_contr_comm_amt41,
        out_trl_sprd_rem_term_contr_comm_dly_amt as out_trl_sprd_rem_term_contr_comm_dly_amt41,
        out_der_contr_comm_amt as out_der_contr_comm_amt41,
        crcy_cd as crcy_cd,
        tran_crcy_cd as tran_crcy_cd,
        contr_crcy_cd as contr_crcy_cd
    from int_filtr_trl_sprd_2yr_term_recs
    order by 
        prtclr_mony_provsn_id asc, 
        etl_sys_nm asc, 
        monthly_date asc
)

select * from srt_trl_sprd_2yr_dates
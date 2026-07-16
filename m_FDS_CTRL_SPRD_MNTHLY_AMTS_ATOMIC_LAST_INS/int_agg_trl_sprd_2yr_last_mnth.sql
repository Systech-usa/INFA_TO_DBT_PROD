-- int_agg_trl_sprd_2yr_last_mnth.sql
{{ config(materialized='table', tags=["m_FDS_CTRL_SPRD_MNTHLY_AMTS_ATOMIC_LAST_INS"]) }}

with int_srt_trl_sprd_2yr_dates as (
    select * from {{ ref('int_srt_trl_sprd_2yr_dates') }}
),

int_agg_trl_sprd_2yr_last_mnth as (
    select 
        prtclr_mony_provsn_id,
        etl_sys_nm,
        max(monthly_date) as out_monthly_date,
        max(agmt_anchr_id) as agmt_anchr_id,
        max(base_amt) as base_amt,
        max(daily_amt) as daily_amt,
        max(mnth_yr_part_trl_sprd_2yr_last_day) as mnth_yr_part_trl_sprd_2yr_last_day,
        max(trl_sprd_2yr_base_amt) as trl_sprd_2yr_base_amt,
        max(trl_sprd_2yr_last_mnth_rem_days) as trl_sprd_2yr_last_mnth_rem_days,
        max(trl_sprd_rem_term_dly_amt) as trl_sprd_rem_term_dly_amt,
        max(prem_amt) as prem_amt,
        sum(case when mnth_yr_part_trl_sprd_2yr_last_day != mnth_yr_part_last_day then prem_amt else 0 end) as out_prem_added_amt,
        max(eff_md_yr_mo) as eff_md_yr_mo,
        max(pop_info_id) as pop_info_id,
        max(batch_id) as batch_id,
        max(mnth_yr_part_eff_to) as mnth_yr_part_eff_to,
        max(mnth_yr_part_last_day) as mnth_yr_part_last_day,
        max(covg_cmpnt_agmt_anchr_id) as covg_cmpnt_agmt_anchr_id,
        max(out_comm_amt) as out_comm_amt,
        max(trl_sprd_2yr_comm_amt) as trl_sprd_2yr_comm_amt,
        max(trl_sprd_rem_term_comm_dly_amt) as trl_sprd_rem_term_comm_dly_amt,
        max(out_der_comm_amt) as der_comm_amt,
        sum(case when mnth_yr_part_trl_sprd_2yr_last_day != mnth_yr_part_last_day then out_der_comm_amt else 0 end) as out_der_comm_added_amt,
        max(out_tran_prem_amt) as tran_prem_amt,
        max(tran_comm_amt) as tran_comm_amt,
        max(trl_sprd_2yr_tran_prem_amt) as trl_sprd_2yr_tran_prem_amt,
        max(trl_sprd_rem_term_tran_prem_dly_amt) as trl_sprd_rem_term_tran_prem_dly_amt,
        max(out_der_tran_prem_amt) as der_tran_prem_amt,
        sum(case when mnth_yr_part_trl_sprd_2yr_last_day != mnth_yr_part_last_day then out_der_tran_prem_amt else 0 end) as out_der_tran_prem_added_amt,
        max(out_trl_sprd_2yr_tran_comm_amt) as out_trl_sprd_2yr_tran_comm_amt,
        max(trl_sprd_rem_term_tran_comm_dly_amt) as trl_sprd_rem_term_tran_comm_dly_amt,
        max(out_der_tran_comm_amt) as der_tran_comm_amt,
        sum(case when mnth_yr_part_trl_sprd_2yr_last_day != mnth_yr_part_last_day then out_der_tran_comm_amt else 0 end) as out_der_tran_comm_added_amt,
        max(out_contr_prem_amt) as contr_prem_amt,
        max(out_trl_sprd_2yr_contr_prem_amt) as trl_sprd_2yr_contr_prem_amt,
        max(out_trl_sprd_rem_term_contr_prem_dly_amt) as trl_sprd_rem_term_contr_prem_dly_amt,
        max(out_der_contr_prem_amt) as der_contr_prem_amt,
        sum(case when mnth_yr_part_trl_sprd_2yr_last_day != mnth_yr_part_last_day then out_der_contr_prem_amt else 0 end) as out_der_contr_prem_added_amt,
        max(src_ln_of_busn_cd41) as src_ln_of_busn_cd,
        max(out_contr_comm_amt41) as contr_comm_amt,
        max(out_trl_sprd_2yr_contr_comm_amt41) as trl_sprd_2yr_contr_comm_amt,
        max(out_trl_sprd_rem_term_contr_comm_dly_amt41) as trl_sprd_rem_term_contr_comm_dly_amt,
        max(out_der_contr_comm_amt41) as der_contr_comm_amt,
        sum(case when mnth_yr_part_trl_sprd_2yr_last_day != mnth_yr_part_last_day then out_der_contr_comm_amt41 else 0 end) as out_der_contr_comm_added_amt,
        max(crcy_cd) as crcy_cd,
        max(tran_crcy_cd) as tran_crcy_cd,
        max(contr_crcy_cd) as contr_crcy_cd
    from int_srt_trl_sprd_2yr_dates
    group by 
        prtclr_mony_provsn_id,
        etl_sys_nm
)

select * from int_agg_trl_sprd_2yr_last_mnth

--End-DBShift
-- int_agg_last_mnth.sql
{{ config(materialized='table', tags=['m_FDS_CTRL_SPRD_MNTHLY_AMTS_ATOMIC_LAST_INS']) }}

with int_srt_dates as (
    select * from {{ ref('int_srt_dates') }}
),

int_agg_last_mnth as (
    select
        prtclr_mony_provsn_id,
        etl_sys_nm,
        max(agmt_anchr_id) as agmt_anchr_id1,
        max(base_amt) as base_amt1,
        max(daily_amt) as daily_amt,
        max(prem_amt) as prem_amt1,
        max(eff_md_yr_mo) as eff_md_yr_mo1,
        max(pop_info_id) as pop_info_id1,
        max(batch_id) as batch_id1,
        max(agmt_anchr_id) as agmt_anchr_id,
        max(base_amt) as base_amt,
        max(covg_cmpnt_agmt_anchr_id) as covg_cmpnt_agmt_anchr_id1,
        max(out_comm_amt) as out_comm_amt,
        max(out_der_comm_amt) as out_der_comm_amt,
        max(out_tran_prem_amt) as out_tran_prem_amt,
        max(tran_comm_amt) as tran_comm_amt1,
        max(prem_amt) as prem_amt,
        max(out_contr_prem_amt) as out_contr_prem_amt,
        sum(case when mnth_yr_part_eff_to != mnth_yr_part_last_day then prem_amt else 0 end) as out_added_amt,
        max(eff_md_yr_mo) as eff_md_yr_mo,
        max(pop_info_id) as pop_info_id,
        max(batch_id) as batch_id,
        max(monthly_date) as out_monthly_date,
        max(covg_cmpnt_agmt_anchr_id) as covg_cmpnt_agmt_anchr_id,
        max(out_comm_amt) as comm_amt,
        max(out_der_comm_amt) as der_comm_amt,
        sum(case when mnth_yr_part_eff_to != mnth_yr_part_last_day then out_der_comm_amt else 0 end) as out_comm_added_amt,
        max(out_tran_prem_amt) as tran_prem_amt,
        max(tran_comm_amt) as tran_comm_amt,
        sum(case when mnth_yr_part_eff_to != mnth_yr_part_last_day then out_der_tran_prem_amt else 0 end) as tran_prem_added_amt,
        sum(case when mnth_yr_part_eff_to != mnth_yr_part_last_day then out_der_tran_comm_amt else 0 end) as tran_comm_added_amt,
        max(out_contr_prem_amt) as contr_prem_amt,
        sum(case when mnth_yr_part_eff_to != mnth_yr_part_last_day then out_der_contr_prem_amt else 0 end) as contr_prem_added_amt,
        max(src_ln_of_busn_cd41) as src_ln_of_busn_cd41,
        max(out_contr_comm_amt41) as contr_comm_amt41,
        sum(case when mnth_yr_part_eff_to != mnth_yr_part_last_day then out_der_contr_comm_amt41 else 0 end) as contr_comm_added_amt,
        max(crcy_cd) as crcy_cd,
        max(tran_crcy_cd) as tran_crcy_cd,
        max(contr_crcy_cd) as contr_crcy_cd,
        max(src_ln_of_busn_cd41) as src_ln_of_busn_cd411,
        max(out_contr_comm_amt41) as out_contr_comm_amt41,
        max(crcy_cd) as crcy_cd1,
        max(tran_crcy_cd) as tran_crcy_cd1,
        max(contr_crcy_cd) as contr_crcy_cd1
    from int_srt_dates
    group by 
        prtclr_mony_provsn_id,
        etl_sys_nm
)

select * from int_agg_last_mnth

--End-DBShift
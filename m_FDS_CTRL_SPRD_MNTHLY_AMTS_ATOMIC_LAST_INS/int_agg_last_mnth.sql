{{ config(
    materialized='table',
    tags=["m_FDS_CTRL_SPRD_MNTHLY_AMTS_ATOMIC_LAST_INS"]
) }}

with int_srt_dates as (
    select 
        -- Mapping upstream connector fields to this transformation's expected input fields
        prtclr_mony_provsn_id,
        etl_sys_nm,
        monthly_date,
        mnth_yr_part_eff_to,
        mnth_yr_part_last_day,
        out_der_tran_prem_amt as der_tran_prem_amt,
        out_der_tran_comm_amt as der_tran_comm_amt,
        out_der_contr_prem_amt as der_contr_prem_amt,
        out_der_contr_comm_amt41 as der_contr_comm_amt41,
        agmt_anchr_id as agmt_anchr_id1,
        base_amt as base_amt1,
        daily_amt,
        prem_amt as prem_amt1,
        eff_md_yr_mo as eff_md_yr_mo1,
        pop_info_id as pop_info_id1,
        batch_id as batch_id1,
        covg_cmpnt_agmt_anchr_id as covg_cmpnt_agmt_anchr_id1,
        out_comm_amt,
        out_der_comm_amt,
        out_tran_prem_amt,
        tran_comm_amt as tran_comm_amt1,
        out_contr_prem_amt,
        src_ln_of_busn_cd41 as src_ln_of_busn_cd411,
        out_contr_comm_amt41,
        crcy_cd as crcy_cd1,
        tran_crcy_cd as tran_crcy_cd1,
        contr_crcy_cd as contr_crcy_cd1
    from {{ ref('int_srt_dates') }}
),

int_agg_last_mnth as (
    select 
        prtclr_mony_provsn_id,
        etl_sys_nm,
        MAX(monthly_date) as monthly_date,
        MAX(agmt_anchr_id1) as agmt_anchr_id1,
        MAX(base_amt1) as base_amt1,
        MAX(daily_amt) as daily_amt,
        MAX(prem_amt1) as prem_amt1,
        MAX(eff_md_yr_mo1) as eff_md_yr_mo1,
        MAX(pop_info_id1) as pop_info_id1,
        MAX(batch_id1) as batch_id1,
        MAX(agmt_anchr_id1) as agmt_anchr_id,
        MAX(base_amt1) as base_amt,
        MAX(covg_cmpnt_agmt_anchr_id1) as covg_cmpnt_agmt_anchr_id1,
        MAX(out_comm_amt) as out_comm_amt,
        MAX(out_der_comm_amt) as out_der_comm_amt,
        MAX(out_tran_prem_amt) as out_tran_prem_amt,
        MAX(tran_comm_amt1) as tran_comm_amt1,
        MAX(prem_amt1) as prem_amt,
        MAX(out_contr_prem_amt) as out_contr_prem_amt,
        SUM(CASE WHEN mnth_yr_part_eff_to != mnth_yr_part_last_day THEN prem_amt1 ELSE 0 END) as out_added_amt,
        MAX(eff_md_yr_mo1) as eff_md_yr_mo,
        MAX(pop_info_id1) as pop_info_id,
        MAX(batch_id1) as batch_id,
        MAX(mnth_yr_part_eff_to) as mnth_yr_part_eff_to,
        MAX(mnth_yr_part_last_day) as mnth_yr_part_last_day,
        MAX(monthly_date) as out_monthly_date,
        MAX(covg_cmpnt_agmt_anchr_id1) as covg_cmpnt_agmt_anchr_id,
        MAX(out_comm_amt) as comm_amt,
        MAX(out_der_comm_amt) as der_comm_amt,
        SUM(CASE WHEN mnth_yr_part_eff_to != mnth_yr_part_last_day THEN out_der_comm_amt ELSE 0 END) as out_comm_added_amt,
        MAX(out_tran_prem_amt) as tran_prem_amt,
        MAX(tran_comm_amt1) as tran_comm_amt,
        MAX(der_tran_prem_amt) as der_tran_prem_amt,
        MAX(der_tran_comm_amt) as der_tran_comm_amt,
        SUM(CASE WHEN mnth_yr_part_eff_to != mnth_yr_part_last_day THEN der_tran_prem_amt ELSE 0 END) as tran_prem_added_amt,
        SUM(CASE WHEN mnth_yr_part_eff_to != mnth_yr_part_last_day THEN der_tran_comm_amt ELSE 0 END) as tran_comm_added_amt,
        MAX(out_contr_prem_amt) as contr_prem_amt,
        MAX(der_contr_prem_amt) as der_contr_prem_amt,
        SUM(CASE WHEN mnth_yr_part_eff_to != mnth_yr_part_last_day THEN der_contr_prem_amt ELSE 0 END) as contr_prem_added_amt,
        MAX(src_ln_of_busn_cd411) as src_ln_of_busn_cd41,
        MAX(out_contr_comm_amt41) as contr_comm_amt41,
        MAX(der_contr_comm_amt41) as der_contr_comm_amt41,
        SUM(CASE WHEN mnth_yr_part_eff_to != mnth_yr_part_last_day THEN der_contr_comm_amt41 ELSE 0 END) as contr_comm_added_amt,
        MAX(crcy_cd1) as crcy_cd,
        MAX(tran_crcy_cd1) as tran_crcy_cd,
        MAX(contr_crcy_cd1) as contr_crcy_cd,
        MAX(src_ln_of_busn_cd411) as src_ln_of_busn_cd411,
        MAX(out_contr_comm_amt41) as out_contr_comm_amt41,
        MAX(crcy_cd1) as crcy_cd1,
        MAX(tran_crcy_cd1) as tran_crcy_cd1,
        MAX(contr_crcy_cd1) as contr_crcy_cd1
    from int_srt_dates
    group by 
        prtclr_mony_provsn_id,
        etl_sys_nm
)

select * from int_agg_last_mnth

--End-DBShift
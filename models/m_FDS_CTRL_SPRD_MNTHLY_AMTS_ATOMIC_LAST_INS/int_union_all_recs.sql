-- 
{{ config(materialized='view', tags=["m_FDS_CTRL_SPRD_MNTHLY_AMTS_ATOMIC_LAST_INS"]) }}

with filt_not_trl_sprd_2yr_last_mnth as (
    select * from {{ ref('int_filt_not_trl_sprd_2yr_last_mnth') }}
),

exp_trl_sprd_2yr_last_mnth as (
    select * from {{ ref('trans_exp_trl_sprd_2yr_last_mnth') }}
),

not_trl_sprd_2yr_last_mnth as (
    select
        prtclr_mony_provsn_id as prtclr_mony_provsn_id,
        etl_sys_nm as etl_sys_nm,
        agmt_anchr_id as agmt_anchr_id,
        base_amt as base_amt,
        monthly_date as monthly_date,
        daily_amt as daily_amt,
        prem_amt as prem_amt,
        eff_md_yr_mo as eff_md_yr_mo,
        pop_info_id as pop_info_id,
        batch_id as batch_id,
        mnth_yr_part_eff_to as mnth_yr_part_eff_to,
        mnth_yr_part_last_day as mnth_yr_part_last_day,
        covg_cmpnt_agmt_anchr_id as covg_cmpnt_agmt_anchr_id,
        out_comm_amt as out_comm_amt,
        out_der_comm_amt as out_der_comm_amt,
        out_tran_prem_amt as out_tran_prem_amt,
        tran_comm_amt as tran_comm_amt,
        out_der_tran_prem_amt as out_der_tran_prem_amt,
        out_der_tran_comm_amt as out_der_tran_comm_amt,
        out_trl_sprd_ind as out_trl_sprd_ind,
        out_mnth_yr_part_trl_sprd_2yr_last_day as out_mnth_yr_part_trl_sprd_2yr_last_day,
        out_contr_prem_amt as out_contr_prem_amt,
        out_der_contr_prem_amt as out_der_contr_prem_amt,
        src_ln_of_busn_cd as src_ln_of_busn_cd,
        out_contr_comm_amt as out_contr_comm_amt,
        out_der_contr_comm_amt as out_der_contr_comm_amt,
        crcy_cd as crcy_cd,
        tran_crcy_cd as tran_crcy_cd,
        contr_crcy_cd as contr_crcy_cd
    from filt_not_trl_sprd_2yr_last_mnth
),

trl_sprd_2yr_last_mnth as (
    select
        prtclr_mony_provsn_id as prtclr_mony_provsn_id,
        etl_sys_nm as etl_sys_nm,
        agmt_anchr_id as agmt_anchr_id,
        base_amt as base_amt,
        monthly_date as monthly_date,
        daily_amt as daily_amt,
        out_prem_amt as prem_amt,
        eff_md_yr_mo as eff_md_yr_mo,
        pop_info_id as pop_info_id,
        batch_id as batch_id,
        mnth_yr_part_eff_to as mnth_yr_part_eff_to,
        mnth_yr_part_last_day as mnth_yr_part_last_day,
        covg_cmpnt_agmt_anchr_id as covg_cmpnt_agmt_anchr_id,
        out_comm_amt as out_comm_amt,
        out_der_comm_amt as out_der_comm_amt,
        tran_prem_amt as out_tran_prem_amt,
        tran_comm_amt as tran_comm_amt,
        out_der_tran_prem_amt as out_der_tran_prem_amt,
        out_der_tran_comm_amt as out_der_tran_comm_amt,
        cast(null as int) as out_trl_sprd_ind,
        cast(null as numeric(6,0)) as out_mnth_yr_part_trl_sprd_2yr_last_day,
        contr_prem_amt as out_contr_prem_amt,
        out_der_contr_prem_amt as out_der_contr_prem_amt,
        src_ln_of_busn_cd as src_ln_of_busn_cd,
        contr_comm_amt as out_contr_comm_amt,
        out_der_contr_comm_amt as out_der_contr_comm_amt,
        crcy_cd as crcy_cd,
        tran_crcy_cd as tran_crcy_cd,
        contr_crcy_cd as contr_crcy_cd
    from exp_trl_sprd_2yr_last_mnth
),

union_all_recs as (
    select * from not_trl_sprd_2yr_last_mnth
    union all
    select * from trl_sprd_2yr_last_mnth
)

select * from union_all_recs
--End-DBShift
{{ config(materialized='table', tags=["m_FDS_CTRL_SPRD_MNTHLY_AMTS_ATOMIC_LAST_INS"]) }}

with exp_sprd_mnthly_prem_amt_calc as (
    select * from {{ ref('trans_exp_sprd_mnthly_prem_amt_calc') }}
),

sq_ctrl_sprd_mnthly_amts_temp1 as (
    select * from {{ ref('stg_sq_ctrl_sprd_mnthly_amts_temp1') }}
),

joined_data as (
    select
        exp.prtclr_mony_provsn_id as prtclr_mony_provsn_id,
        sq.etl_sys_nm as etl_sys_nm,
        exp.agmt_anchr_id as agmt_anchr_id,
        exp.eff_fm_tistmp as eff_fm_tistmp,
        exp.eff_to_tistmp as eff_to_tistmp,
        sq.out_base_amt as base_amt,
        sq.out_monthly_date as monthly_date,
        exp.daily_amt as daily_amt,
        exp.out_prem_amt as prem_amt,
        sq.out_eff_md_yr_mo as eff_md_yr_mo,
        sq.out_pop_info_id as pop_info_id,
        sq.out_batch_id as batch_id,
        sq.out_mnth_yr_part_eff_to as mnth_yr_part_eff_to,
        sq.out_mnth_yr_part_last_day as mnth_yr_part_last_day,
        sq.covg_cmpnt_agmt_anchr_id as covg_cmpnt_agmt_anchr_id,
        sq.out_eff_md_yr_mo_dflt as out_eff_md_yr_mo_dflt,
        sq.in_comm_amt as out_comm_amt,
        exp.out_der_comm_amt as out_der_comm_amt,
        sq.in_tran_prem_amt as out_tran_prem_amt,
        sq.in_tran_comm_amt as tran_comm_amt,
        exp.out_der_tran_prem_amt as out_der_tran_prem_amt,
        exp.out_der_tran_comm_amt as out_der_tran_comm_amt,
        exp.v_trl_sprd_ind as out_trl_sprd_ind,
        exp.v_mnth_yr_part_trl_sprd_2yr_last_day as out_mnth_yr_part_trl_sprd_2yr_last_day,
        sq.out_trl_sprd_2yr_base_amt as out_trl_sprd_2yr_base_amt,
        sq.out_trl_sprd_2yr_last_mnth_rem_days as out_trl_sprd_2yr_last_mnth_rem_days,
        exp.v_trl_sprd_rem_term_dly_amt as out_trl_sprd_rem_term_dly_amt,
        sq.out_trl_sprd_2yr_comm_amt as out_trl_sprd_2yr_comm_amt,
        exp.v_trl_sprd_rem_term_comm_dly_amt as out_trl_sprd_rem_term_comm_dly_amt,
        sq.out_trl_sprd_2yr_tran_prem_amt as out_trl_sprd_2yr_tran_prem_amt,
        exp.v_trl_sprd_rem_term_tran_prem_dly_amt as out_trl_sprd_rem_term_tran_prem_dly_amt,
        sq.out_trl_sprd_2yr_tran_comm_amt as out_trl_sprd_2yr_tran_comm_amt,
        exp.v_trl_sprd_rem_term_tran_comm_dly_amt as out_trl_sprd_rem_term_tran_comm_dly_amt,
        sq.out_contr_prem_amt as out_contr_prem_amt,
        sq.out_trl_sprd_2yr_contr_prem_amt as out_trl_sprd_2yr_contr_prem_amt,
        exp.v_trl_sprd_rem_term_contr_prem_dly_amt as out_trl_sprd_rem_term_contr_prem_dly_amt,
        exp.out_der_contr_prem_amt as out_der_contr_prem_amt,
        exp.src_ln_of_busn_cd as src_ln_of_busn_cd,
        exp.in_contr_comm_amt as out_contr_comm_amt,
        sq.out_trl_sprd_2yr_contr_comm_amt as out_trl_sprd_2yr_contr_comm_amt,
        exp.v_trl_sprd_rem_term_contr_comm_dly_amt as out_trl_sprd_rem_term_contr_comm_dly_amt,
        exp.out_der_contr_comm_amt as out_der_contr_comm_amt,
        exp.crcy_cd as crcy_cd,
        exp.tran_crcy_cd as tran_crcy_cd,
        exp.contr_crcy_cd as contr_crcy_cd,
        exp.v_exp_date_diff as v_exp_date_diff
    from exp_sprd_mnthly_prem_amt_calc exp
    left join sq_ctrl_sprd_mnthly_amts_temp1 sq
        on exp.prtclr_mony_provsn_id = sq.prtclr_mony_provsn_id and exp.agmt_anchr_id = sq.agmt_anchr_id and exp.eff_fm_tistmp = sq.eff_fm_tistmp
),

int_filtr_trl_sprd_2yr_term_recs as (
    select *
    from joined_data
    where out_trl_sprd_ind = 1 and mnth_yr_part_last_day <= out_mnth_yr_part_trl_sprd_2yr_last_day
)

select * from int_filtr_trl_sprd_2yr_term_recs
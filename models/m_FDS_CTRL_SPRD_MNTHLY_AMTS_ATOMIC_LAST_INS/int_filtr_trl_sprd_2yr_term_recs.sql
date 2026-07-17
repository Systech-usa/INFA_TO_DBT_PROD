-- int_filtr_trl_sprd_2yr_term_recs.sql
{{ config(materialized='table', tags=["m_FDS_CTRL_SPRD_MNTHLY_AMTS_ATOMIC_LAST_INS"]) }}

with trans_exp_sprd_mnthly_prem_amt_calc as (
    select * from {{ ref('trans_exp_sprd_mnthly_prem_amt_calc') }}
),

stg_sq_ctrl_sprd_mnthly_amts_temp1 as (
    select * from {{ ref('stg_sq_ctrl_sprd_mnthly_amts_temp1') }}
),

int_filtr_trl_sprd_2yr_term_recs as (
    select 
        trans_exp_sprd_mnthly_prem_amt_calc.prtclr_mony_provsn_id as prtclr_mony_provsn_id,
        stg_sq_ctrl_sprd_mnthly_amts_temp1.etl_sys_nm as etl_sys_nm,
        trans_exp_sprd_mnthly_prem_amt_calc.agmt_anchr_id as agmt_anchr_id,
        trans_exp_sprd_mnthly_prem_amt_calc.eff_fm_tistmp as eff_fm_tistmp,
        trans_exp_sprd_mnthly_prem_amt_calc.eff_to_tistmp as eff_to_tistmp,
        stg_sq_ctrl_sprd_mnthly_amts_temp1.out_base_amt as base_amt,
        stg_sq_ctrl_sprd_mnthly_amts_temp1.out_monthly_date as monthly_date,
        trans_exp_sprd_mnthly_prem_amt_calc.daily_amt as daily_amt,
        trans_exp_sprd_mnthly_prem_amt_calc.out_prem_amt as prem_amt,
        stg_sq_ctrl_sprd_mnthly_amts_temp1.out_eff_md_yr_mo as eff_md_yr_mo,
        stg_sq_ctrl_sprd_mnthly_amts_temp1.out_pop_info_id as pop_info_id,
        stg_sq_ctrl_sprd_mnthly_amts_temp1.out_batch_id as batch_id,
        stg_sq_ctrl_sprd_mnthly_amts_temp1.out_mnth_yr_part_eff_to as mnth_yr_part_eff_to,
        stg_sq_ctrl_sprd_mnthly_amts_temp1.out_mnth_yr_part_last_day as mnth_yr_part_last_day,
        stg_sq_ctrl_sprd_mnthly_amts_temp1.covg_cmpnt_agmt_anchr_id as covg_cmpnt_agmt_anchr_id,
        stg_sq_ctrl_sprd_mnthly_amts_temp1.out_eff_md_yr_mo_dflt as out_eff_md_yr_mo_dflt,
        stg_sq_ctrl_sprd_mnthly_amts_temp1.in_comm_amt as out_comm_amt,
        trans_exp_sprd_mnthly_prem_amt_calc.out_der_comm_amt as out_der_comm_amt,
        stg_sq_ctrl_sprd_mnthly_amts_temp1.in_tran_prem_amt as out_tran_prem_amt,
        stg_sq_ctrl_sprd_mnthly_amts_temp1.in_tran_comm_amt as tran_comm_amt,
        trans_exp_sprd_mnthly_prem_amt_calc.out_der_tran_prem_amt as out_der_tran_prem_amt,
        trans_exp_sprd_mnthly_prem_amt_calc.out_der_tran_comm_amt as out_der_tran_comm_amt,
        trans_exp_sprd_mnthly_prem_amt_calc.v_trl_sprd_ind as out_trl_sprd_ind,
        trans_exp_sprd_mnthly_prem_amt_calc.v_mnth_yr_part_trl_sprd_2yr_last_day as out_mnth_yr_part_trl_sprd_2yr_last_day,
        stg_sq_ctrl_sprd_mnthly_amts_temp1.out_trl_sprd_2yr_base_amt as out_trl_sprd_2yr_base_amt,
        stg_sq_ctrl_sprd_mnthly_amts_temp1.out_trl_sprd_2yr_last_mnth_rem_days as out_trl_sprd_2yr_last_mnth_rem_days,
        trans_exp_sprd_mnthly_prem_amt_calc.v_trl_sprd_rem_term_dly_amt as out_trl_sprd_rem_term_dly_amt,
        stg_sq_ctrl_sprd_mnthly_amts_temp1.out_trl_sprd_2yr_comm_amt as out_trl_sprd_2yr_comm_amt,
        trans_exp_sprd_mnthly_prem_amt_calc.v_trl_sprd_rem_term_comm_dly_amt as out_trl_sprd_rem_term_comm_dly_amt,
        stg_sq_ctrl_sprd_mnthly_amts_temp1.out_trl_sprd_2yr_tran_prem_amt as out_trl_sprd_2yr_tran_prem_amt,
        trans_exp_sprd_mnthly_prem_amt_calc.v_trl_sprd_rem_term_tran_prem_dly_amt as out_trl_sprd_rem_term_tran_prem_dly_amt,
        stg_sq_ctrl_sprd_mnthly_amts_temp1.out_trl_sprd_2yr_tran_comm_amt as out_trl_sprd_2yr_tran_comm_amt,
        trans_exp_sprd_mnthly_prem_amt_calc.v_trl_sprd_rem_term_tran_comm_dly_amt as out_trl_sprd_rem_term_tran_comm_dly_amt,
        stg_sq_ctrl_sprd_mnthly_amts_temp1.out_contr_prem_amt as out_contr_prem_amt,
        stg_sq_ctrl_sprd_mnthly_amts_temp1.out_trl_sprd_2yr_contr_prem_amt as out_trl_sprd_2yr_contr_prem_amt,
        trans_exp_sprd_mnthly_prem_amt_calc.v_trl_sprd_rem_term_contr_prem_dly_amt as out_trl_sprd_rem_term_contr_prem_dly_amt,
        trans_exp_sprd_mnthly_prem_amt_calc.out_der_contr_prem_amt as out_der_contr_prem_amt,
        trans_exp_sprd_mnthly_prem_amt_calc.src_ln_of_busn_cd as src_ln_of_busn_cd,
        trans_exp_sprd_mnthly_prem_amt_calc.in_contr_comm_amt as out_contr_comm_amt,
        stg_sq_ctrl_sprd_mnthly_amts_temp1.out_trl_sprd_2yr_contr_comm_amt as out_trl_sprd_2yr_contr_comm_amt,
        trans_exp_sprd_mnthly_prem_amt_calc.v_trl_sprd_rem_term_contr_comm_dly_amt as out_trl_sprd_rem_term_contr_comm_dly_amt,
        trans_exp_sprd_mnthly_prem_amt_calc.out_der_contr_comm_amt as out_der_contr_comm_amt,
        trans_exp_sprd_mnthly_prem_amt_calc.crcy_cd as crcy_cd,
        trans_exp_sprd_mnthly_prem_amt_calc.tran_crcy_cd as tran_crcy_cd,
        trans_exp_sprd_mnthly_prem_amt_calc.contr_crcy_cd as contr_crcy_cd,
        trans_exp_sprd_mnthly_prem_amt_calc.v_exp_date_diff as v_exp_date_diff
    from trans_exp_sprd_mnthly_prem_amt_calc
    left join stg_sq_ctrl_sprd_mnthly_amts_temp1
        on trans_exp_sprd_mnthly_prem_amt_calc.prtclr_mony_provsn_id = stg_sq_ctrl_sprd_mnthly_amts_temp1.prtclr_mony_provsn_id
       and trans_exp_sprd_mnthly_prem_amt_calc.agmt_anchr_id = stg_sq_ctrl_sprd_mnthly_amts_temp1.agmt_anchr_id
       and trans_exp_sprd_mnthly_prem_amt_calc.eff_fm_tistmp = stg_sq_ctrl_sprd_mnthly_amts_temp1.eff_fm_tistmp
    where trans_exp_sprd_mnthly_prem_amt_calc.v_trl_sprd_ind = 1 
      and stg_sq_ctrl_sprd_mnthly_amts_temp1.out_mnth_yr_part_last_day <= trans_exp_sprd_mnthly_prem_amt_calc.v_mnth_yr_part_trl_sprd_2yr_last_day
)

select * from int_filtr_trl_sprd_2yr_term_recs
--End-DBShift
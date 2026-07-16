-- int_filtr_trl_sprd_2yr_term_recs.sql
{{ config(materialized='table', tags=["m_FDS_CTRL_SPRD_MNTHLY_AMTS_ATOMIC_LAST_INS"]) }}

with trans_exp_sprd_mnthly_prem_amt_calc as (
    select * 
    from {{ ref('trans_exp_sprd_mnthly_prem_amt_calc') }}
),

int_filtr_trl_sprd_2yr_term_recs as (
    select 
        prtclr_mony_provsn_id,
        etl_sys_nm,
        agmt_anchr_id,
        eff_fm_tistmp,
        eff_to_tistmp,
        base_amt,
        monthly_date,
        daily_amt,
        prem_amt,
        eff_md_yr_mo,
        pop_info_id,
        batch_id,
        mnth_yr_part_eff_to,
        mnth_yr_part_last_day,
        covg_cmpnt_agmt_anchr_id,
        out_eff_md_yr_mo_dflt,
        out_comm_amt,
        out_der_comm_amt,
        out_tran_prem_amt,
        tran_comm_amt,
        out_der_tran_prem_amt,
        out_der_tran_comm_amt,
        out_trl_sprd_ind,
        out_mnth_yr_part_trl_sprd_2yr_last_day,
        out_trl_sprd_2yr_base_amt,
        out_trl_sprd_2yr_last_mnth_rem_days,
        out_trl_sprd_rem_term_dly_amt,
        out_trl_sprd_2yr_comm_amt,
        out_trl_sprd_rem_term_comm_dly_amt,
        out_trl_sprd_2yr_tran_prem_amt,
        out_trl_sprd_rem_term_tran_prem_dly_amt,
        out_trl_sprd_2yr_tran_comm_amt,
        out_trl_sprd_rem_term_tran_comm_dly_amt,
        out_contr_prem_amt,
        out_trl_sprd_2yr_contr_prem_amt,
        out_trl_sprd_rem_term_contr_prem_dly_amt,
        out_der_contr_prem_amt,
        src_ln_of_busn_cd,
        out_contr_comm_amt,
        out_trl_sprd_2yr_contr_comm_amt,
        out_trl_sprd_rem_term_contr_comm_dly_amt,
        out_der_contr_comm_amt,
        crcy_cd,
        tran_crcy_cd,
        contr_crcy_cd,
        v_exp_date_diff
    from trans_exp_sprd_mnthly_prem_amt_calc
    where out_trl_sprd_ind = 1 
      and mnth_yr_part_last_day <= out_mnth_yr_part_trl_sprd_2yr_last_day
)

select * 
from int_filtr_trl_sprd_2yr_term_recs

--End-DBShift
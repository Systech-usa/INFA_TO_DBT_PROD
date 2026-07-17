{{ config(
    materialized='incremental',
    tags=['m_FDS_CTRL_SPRD_MNTHLY_AMTS_ATOMIC_LAST_INS']
) }}

-- target: ctrl_sprd_mnthly_amts
with exp_cal_lst_mnth as (
    select * from {{ ref('trans_exp_cal_lst_mnth') }}
),

stg_tgt_ctrl_sprd_mnthly_amts as (
    select
        exp_cal_lst_mnth.agmt_anchr_id as agmt_anchr_id,
        exp_cal_lst_mnth.eff_md_yr_mo as eff_md_yr_mo,
        exp_cal_lst_mnth.base_amt as base_amt,
        exp_cal_lst_mnth.out_prem_amt as prem_amt,
        exp_cal_lst_mnth.pop_info_id as updt_pop_info_id,
        exp_cal_lst_mnth.pop_info_id as pop_info_id,
        exp_cal_lst_mnth.batch_id as bat_id,
        exp_cal_lst_mnth.covg_cmpnt_agmt_anchr_id as covg_cmpnt_agmt_anchr_id,
        exp_cal_lst_mnth.prtclr_mony_provsn_id as prtclr_mony_provsn_id,
        exp_cal_lst_mnth.etl_sys_nm as etl_sys_nm,
        exp_cal_lst_mnth.comm_amt as comm_amt,
        exp_cal_lst_mnth.out_der_comm_amt as der_comm_amt,
        exp_cal_lst_mnth.tran_comm_amt as tran_comm_amt,
        exp_cal_lst_mnth.tran_prem_amt as tran_prem_amt,
        exp_cal_lst_mnth.out_der_tran_comm_amt as der_tran_comm_amt,
        exp_cal_lst_mnth.out_der_tran_prem_amt as der_tran_prem_amt,
        exp_cal_lst_mnth.contr_prem_amt as contr_prem_amt,
        exp_cal_lst_mnth.out_der_contr_prem_amt as der_contr_prem_amt,
        exp_cal_lst_mnth.src_ln_of_busn_cd41 as src_ln_of_busn_cd,
        exp_cal_lst_mnth.contr_comm_amt41 as contr_comm_amt,
        exp_cal_lst_mnth.out_der_contr_comm_amt as der_contr_comm_amt,
        exp_cal_lst_mnth.crcy_cd as crcy_cd,
        exp_cal_lst_mnth.tran_crcy_cd as tran_crcy_cd,
        exp_cal_lst_mnth.contr_crcy_cd as contr_crcy_cd
    from exp_cal_lst_mnth
)

select * from stg_tgt_ctrl_sprd_mnthly_amts

--End-DBShift
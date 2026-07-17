-- int_union_all_recs
{{ config(materialized='view', tags=["m_FDS_CTRL_SPRD_MNTHLY_AMTS_ATOMIC_LAST_INS"]) }}

with not_trl_sprd_2yr_last_mnth as (
    select 
        prtclr_mony_provsn_id,
        etl_sys_nm,
        agmt_anchr_id,
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
        out_comm_amt,
        out_der_comm_amt,
        out_tran_prem_amt,
        tran_comm_amt,
        out_der_tran_prem_amt,
        out_der_tran_comm_amt,
        out_trl_sprd_ind,
        out_mnth_yr_part_trl_sprd_2yr_last_day,
        out_contr_prem_amt,
        out_der_contr_prem_amt,
        src_ln_of_busn_cd,
        out_contr_comm_amt,
        out_der_contr_comm_amt,
        crcy_cd,
        tran_crcy_cd,
        contr_crcy_cd
    from {{ ref('int_filt_not_trl_sprd_2yr_last_mnth') }}
),

trl_sprd_2yr_last_mnth as (
    select 
        prtclr_mony_provsn_id,
        etl_sys_nm,
        agmt_anchr_id,
        base_amt,
        monthly_date,
        daily_amt,
        out_prem_amt as prem_amt,
        eff_md_yr_mo,
        pop_info_id,
        batch_id,
        mnth_yr_part_eff_to,
        mnth_yr_part_last_day,
        covg_cmpnt_agmt_anchr_id,
        out_comm_amt,
        out_der_comm_amt,
        tran_prem_amt as out_tran_prem_amt,
        tran_comm_amt,
        out_der_tran_prem_amt,
        out_der_tran_comm_amt,
        cast(null as integer) as out_trl_sprd_ind,
        cast(null as numeric) as out_mnth_yr_part_trl_sprd_2yr_last_day,
        contr_prem_amt as out_contr_prem_amt,
        out_der_contr_prem_amt,
        src_ln_of_busn_cd,
        contr_comm_amt as out_contr_comm_amt,
        out_der_contr_comm_amt,
        crcy_cd,
        tran_crcy_cd,
        contr_crcy_cd
    from {{ ref('trans_exp_trl_sprd_2yr_last_mnth') }}
),

union_all_recs as (
    select * from not_trl_sprd_2yr_last_mnth
    union all
    select * from trl_sprd_2yr_last_mnth
)

select * from union_all_recs
--End-DBShift
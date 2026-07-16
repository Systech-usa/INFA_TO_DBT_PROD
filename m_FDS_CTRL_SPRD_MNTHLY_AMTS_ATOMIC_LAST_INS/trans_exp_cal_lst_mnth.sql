-- trans_exp_cal_lst_mnth
{{ config(materialized='table', tags=['m_fds_ctrl_sprd_mnthly_amts_atomic_last_ins']) }}

with int_agg_last_mnth as (
    -- source: upstream transformation
    select
        prtclr_mony_provsn_id,
        etl_sys_nm,
        out_monthly_date as monthly_date,
        agmt_anchr_id,
        base_amt,
        prem_amt,
        out_added_amt as added_amt,
        eff_md_yr_mo,
        pop_info_id,
        batch_id,
        covg_cmpnt_agmt_anchr_id,
        out_comm_added_amt as in_comm_added_amt,
        comm_amt,
        der_comm_amt,
        tran_prem_amt,
        tran_comm_amt,
        tran_prem_added_amt as in_tran_prem_added_amt,
        tran_comm_added_amt as in_tran_comm_added_amt,
        contr_prem_amt,
        contr_prem_added_amt as in_contr_prem_added_amt,
        src_ln_of_busn_cd41,
        contr_comm_amt41,
        contr_comm_added_amt as in_contr_comm_added_amt,
        crcy_cd,
        tran_crcy_cd,
        contr_crcy_cd
    from {{ ref('int_agg_last_mnth') }}
),

trans_exp_cal_lst_mnth as (
    select 
        prtclr_mony_provsn_id,
        etl_sys_nm,
        monthly_date,
        agmt_anchr_id,
        base_amt,
        prem_amt,
        added_amt,
        round(base_amt - iff(added_amt is null, 0, added_amt), 2) as out_prem_amt,
        eff_md_yr_mo,
        pop_info_id,
        batch_id,
        covg_cmpnt_agmt_anchr_id,
        comm_amt,
        der_comm_amt,
        round(comm_amt - iff(in_comm_added_amt is null, 0, in_comm_added_amt), 2) as out_der_comm_amt,
        tran_prem_amt,
        tran_comm_amt,
        round(tran_prem_amt - iff(in_tran_prem_added_amt is null, 0, in_tran_prem_added_amt), 2) as out_der_tran_prem_amt,
        round(tran_comm_amt - iff(in_tran_comm_added_amt is null, 0, in_tran_comm_added_amt), 2) as out_der_tran_comm_amt,
        contr_prem_amt,
        round(contr_prem_amt - iff(in_contr_prem_added_amt is null, 0, in_contr_prem_added_amt), 2) as out_der_contr_prem_amt,
        src_ln_of_busn_cd41,
        contr_comm_amt41,
        round(contr_comm_amt41 - iff(in_contr_comm_added_amt is null, 0, in_contr_comm_added_amt), 2) as out_der_contr_comm_amt,
        crcy_cd,
        tran_crcy_cd,
        contr_crcy_cd
    from int_agg_last_mnth
)

select * from trans_exp_cal_lst_mnth
--End-DBShift
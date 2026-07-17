{{ config(materialized='view', tags=["m_FDS_CTRL_SPRD_MNTHLY_AMTS_ATOMIC_LAST_INS"]) }}

-- SQ_ctrl_sprd_mnthly_amts_temp
with raw_source as (
    select * from {{ source('PostgreSQL35W', 'ctrl_sprd_mnthly_amts_temp_1') }} ctrl_sprd_mnthly_amts_temp_1
),

source_data as (
    select
        src.*,
        src.v_trl_sprd_rem_term_comm_dly_amt as v_trl_sprd_rem_term_comm_dly_amt_1,
        src.v_trl_sprd_2yr_tran_prem_dly_amt as v_trl_sprd_2yr_tran_prem_dly_amt_1,
        src.v_trl_sprd_rem_term_tran_prem_dly_amt as v_trl_sprd_rem_term_tran_prem_dly_amt_1,
        src.v_trl_sprd_2yr_tran_comm_dly_amt as v_trl_sprd_2yr_tran_comm_dly_amt_1,
        src.v_trl_sprd_rem_term_tran_comm_dly_amt as v_trl_sprd_rem_term_tran_comm_dly_amt_1,
        src.v_trl_sprd_2yr_contr_prem_dly_amt as v_trl_sprd_2yr_contr_prem_dly_amt_1,
        src.v_trl_sprd_rem_term_contr_prem_dly_amt as v_trl_sprd_rem_term_contr_prem_dly_amt_1,
        src.v_trl_sprd_2yr_contr_comm_dly_amt as v_trl_sprd_2yr_contr_comm_dly_amt_1,
        src.v_trl_sprd_rem_term_contr_comm_dly_amt as v_trl_sprd_rem_term_contr_comm_dly_amt_1,
        src.out_der_comm_amt as in_tran_prem_amt,
        src.out_der_tran_prem_amt as in_contr_prem_amt,
        src.out_der_tran_comm_amt as in_dly_contr_prem_amt,
        src.in_contr_prem_amt as out_contr_prem_amt,
        src.in_dly_contr_prem_amt as out_trl_sprd_2yr_contr_prem_amt
    from raw_source src
)

select * from source_data

--End-DBShift
{{ config(materialized='table', tags=['m_FDS_CTRL_SPRD_MNTHLY_AMTS_ATOMIC_LAST_INS']) }}

-- int_agg_last_mnth.sql
with srt_dates as (
    select
        PRTCLR_MONY_PROVSN_ID,
        ETL_SYS_NM,
        MONTHLY_DATE,
        MNTH_YR_PART_EFF_TO,
        MNTH_YR_PART_LAST_DAY,
        out_DER_TRAN_PREM_AMT as DER_TRAN_PREM_AMT,
        out_DER_TRAN_COMM_AMT as DER_TRAN_COMM_AMT,
        out_DER_CONTR_PREM_AMT as DER_CONTR_PREM_AMT,
        out_DER_CONTR_COMM_AMT41 as DER_CONTR_COMM_AMT41,
        AGMT_ANCHR_ID as AGMT_ANCHR_ID1,
        BASE_AMT as BASE_AMT1,
        DAILY_AMT,
        PREM_AMT as PREM_AMT1,
        EFF_MD_YR_MO as EFF_MD_YR_MO1,
        POP_INFO_ID as POP_INFO_ID1,
        BATCH_ID as BATCH_ID1,
        COVG_CMPNT_AGMT_ANCHR_ID as COVG_CMPNT_AGMT_ANCHR_ID1,
        out_COMM_AMT,
        out_DER_COMM_AMT,
        out_TRAN_PREM_AMT,
        TRAN_COMM_AMT as TRAN_COMM_AMT1,
        out_CONTR_PREM_AMT,
        SRC_LN_OF_BUSN_CD41 as SRC_LN_OF_BUSN_CD411,
        out_CONTR_COMM_AMT41,
        CRCY_CD as CRCY_CD1,
        TRAN_CRCY_CD as TRAN_CRCY_CD1,
        CONTR_CRCY_CD as CONTR_CRCY_CD1
    from {{ ref('int_srt_dates') }}
),

int_agg_last_mnth as (
    select
        prtclr_mony_provsn_id,
        etl_sys_nm,
        max(agmt_anchr_id1) as agmt_anchr_id1,
        max(base_amt1) as base_amt1,
        max(daily_amt) as daily_amt,
        max(prem_amt1) as prem_amt1,
        max(eff_md_yr_mo1) as eff_md_yr_mo1,
        max(pop_info_id1) as pop_info_id1,
        max(batch_id1) as batch_id1,
        max(agmt_anchr_id1) as agmt_anchr_id,
        max(base_amt1) as base_amt,
        max(covg_cmpnt_agmt_anchr_id1) as covg_cmpnt_agmt_anchr_id1,
        max(out_comm_amt) as out_comm_amt,
        max(out_der_comm_amt) as out_der_comm_amt,
        max(out_tran_prem_amt) as out_tran_prem_amt,
        max(tran_comm_amt1) as tran_comm_amt1,
        max(prem_amt1) as prem_amt,
        max(out_contr_prem_amt) as out_contr_prem_amt,
        sum(iff(mnth_yr_part_eff_to != mnth_yr_part_last_day,prem_amt1,0)) as out_added_amt,
        max(eff_md_yr_mo1) as eff_md_yr_mo,
        max(pop_info_id1) as pop_info_id,
        max(batch_id1) as batch_id,
        max(monthly_date) as out_monthly_date,
        max(covg_cmpnt_agmt_anchr_id1) as covg_cmpnt_agmt_anchr_id,
        max(out_comm_amt) as comm_amt,
        max(out_der_comm_amt) as der_comm_amt,
        sum (iff(mnth_yr_part_eff_to != mnth_yr_part_last_day,out_der_comm_amt,0)) as out_comm_added_amt,
        max(out_tran_prem_amt) as tran_prem_amt,
        max(tran_comm_amt1) as tran_comm_amt,
        sum (iff(mnth_yr_part_eff_to != mnth_yr_part_last_day,der_tran_prem_amt,0)) as tran_prem_added_amt,
        sum (iff(mnth_yr_part_eff_to != mnth_yr_part_last_day,der_tran_comm_amt,0)) as tran_comm_added_amt,
        max(out_contr_prem_amt) as contr_prem_amt,
        sum (iff(mnth_yr_part_eff_to != mnth_yr_part_last_day,der_contr_prem_amt,0)) as contr_prem_added_amt,
        max(src_ln_of_busn_cd411) as src_ln_of_busn_cd41,
        max(out_contr_comm_amt41) as contr_comm_amt41,
        sum (iff(mnth_yr_part_eff_to != mnth_yr_part_last_day,der_contr_comm_amt41,0)) as contr_comm_added_amt,
        max(crcy_cd1) as crcy_cd,
        max(tran_crcy_cd1) as tran_crcy_cd,
        max(contr_crcy_cd1) as contr_crcy_cd,
        max(src_ln_of_busn_cd411) as src_ln_of_busn_cd411,
        max(out_contr_comm_amt41) as out_contr_comm_amt41,
        max(crcy_cd1) as crcy_cd1,
        max(tran_crcy_cd1) as tran_crcy_cd1,
        max(contr_crcy_cd1) as contr_crcy_cd1
    from srt_dates
    group by
        prtclr_mony_provsn_id,
        etl_sys_nm
)

select * from int_agg_last_mnth
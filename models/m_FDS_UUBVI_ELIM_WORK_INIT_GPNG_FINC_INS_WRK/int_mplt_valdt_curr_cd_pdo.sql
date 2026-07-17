-- int_mplt_valdt_curr_cd_pdo.sql
{{ config(materialized='table', tags=["m_FDS_UUBVI_ELIM_WORK_INIT_GPNG_FINC_INS_WRK"]) }}

with trans_exp_lkp_trans_curr_cd as (
    -- Reference to upstream transformation feeding into the Mapplet
    select 
        out_COMPANY_NBR as in_cmpny_nbr,
        in_curr_cd as in_curr_cd,
        in_cmpny_nbr_role_plyr_anchr_id as in_cmpny_nbr_role_plyr_anchr_id,
        out_CTRY_CD as CTRY_CD,
        out_POL_PURP_TYP_CD as In_POL_PURP_TYP_ID,
        out_DLR_NBR as In_DLR_NBR,
        out_CONTR_TYP_CD as In_CONTR_TYP_CD,
        ROL_PLYR_ANCHR_ID1 as ROL_PLYR_ANCHR_ID,
        change_rec_flag1 as change_rec_flag
    from {{ ref('trans_exp_lkp_trans_curr_cd') }}
),

lkp_cd_curr_abbr_nbr_src as (
    -- Lookup Transformation: LKP_CD_CURR_ABBR_NBR
    select 
        TRIM(CD.CD_VAL) as CD_VAL, 
        TRIM(CD.CD_SCM) as CD_SCM,
        case 
            when TRIM(CD.CD_SCM) = 'CURRENCY_ABBREVIATION' then TRIM(CD.CD_VAL) 
            else TRIM(CD.DESCRIPTION) 
        end as CURR_ABBR 
    from {{ source('dbaall', 'CD') }} CD 
    where CD.ACTV_REC_IND = 'Y' 
      and CD.CD_SCM = 'CURRENCY_ABBREVIATION'
),

lkp_cd_curr_abbr_nbr as (
    select
        CD_VAL,
        max(CURR_ABBR) as CURR_ABBR
    from lkp_cd_curr_abbr_nbr_src
    group by CD_VAL
),

lkp_get_company_number_src as (
    -- Lookup Transformation: LKP_GET_COMPANY_NUMBER
    select 
        ROL_PLYR_ANCHR_ID as ROL_PLYR_ANCHR_ID,
        TRIM(OPERT_CO_CD) as COMPANY_NUMBER
    from {{ source('dbaall', 'EXTL_ORG') }}
    where ACTV_REC_IND = 'Y'
      and TYP_ID = (select TYP_ID from {{ source('dbaall', 'TYP') }} where NM = 'COMPANY')
),

lkp_get_company_number as (
    select
        ROL_PLYR_ANCHR_ID,
        max(COMPANY_NUMBER) as COMPANY_NUMBER
    from lkp_get_company_number_src
    group by ROL_PLYR_ANCHR_ID
),

lkp_curr_code_src as (
    -- Lookup Transformation: LKP_CURR_CODE
    select  
        TRIM(OPERT_CO_CD) as COMPANY_NUMBER,
        LOC_CRCY_CD as CURR_CODE
    from {{ source('dbaall', 'EXTL_ORG') }}
    where ACTV_REC_IND = 'Y'
      and TYP_ID = (select TYP_ID from {{ source('dbaall', 'TYP') }} where NM = 'COMPANY')
),

lkp_curr_code as (
    select
        COMPANY_NUMBER,
        max(CURR_CODE) as CURR_CODE
    from lkp_curr_code_src
    group by COMPANY_NUMBER
),

trans_exp_mapplet_logic as (
    -- Consolidating logic for EXP_CURR_ABBR and EXPTRANS
    select
        src.in_cmpny_nbr as out_cmpny_nbr,
        src.in_curr_cd as out_curr_cd,
        
        -- out_VALDT_CURR_CD logic (IIF(ISNULL(v_LKP_CURR_ABBR) OR v_LKP_CURR_ABBR='' OR v_LKP_CURR_ABBR='null', v_CURR_CD, v_LKP_CURR_ABBR))
        -- v_CURR_CD evaluates strictly to 'USD' since v_CURR_CODE port remains unconnected/null in EXP_CURR_ABBR mapping logic.
        case 
            when l1.CURR_ABBR is null or l1.CURR_ABBR = '' or l1.CURR_ABBR = 'null' then 'USD'
            else l1.CURR_ABBR
        end as out_VALDT_CURR_CD,
        
        -- out_ValidFlag logic (IIF(ISNULL(v_LKP_CURR_ABBR), 'Y', 'N'))
        case 
            when l1.CURR_ABBR is null then 'Y'
            else 'N'
        end as out_ValidFlag,
        
        src.CTRY_CD as out_CTRY_CD,
        src.In_POL_PURP_TYP_ID as out_POL_PURP_TYP_ID,
        src.In_DLR_NBR as out_DLR_NBR,
        src.In_CONTR_TYP_CD as out_CONTR_TYP_CD,
        src.ROL_PLYR_ANCHR_ID as ROL_PLYR_ANCHR_ID1,
        src.change_rec_flag as change_rec_flag1
        
    from trans_exp_lkp_trans_curr_cd src
    left join lkp_cd_curr_abbr_nbr l1
        on src.in_curr_cd = l1.CD_VAL
    left join lkp_get_company_number l2
        on src.in_cmpny_nbr_role_plyr_anchr_id = l2.ROL_PLYR_ANCHR_ID
    left join lkp_curr_code l3
        on (case when src.in_cmpny_nbr_role_plyr_anchr_id is null then src.in_cmpny_nbr else l2.COMPANY_NUMBER end) = l3.COMPANY_NUMBER
),

int_mplt_valdt_curr_cd_pdo as (
    select 
        out_cmpny_nbr,
        out_curr_cd,
        out_VALDT_CURR_CD,
        out_ValidFlag,
        out_CTRY_CD,
        out_POL_PURP_TYP_ID,
        out_DLR_NBR,
        out_CONTR_TYP_CD,
        ROL_PLYR_ANCHR_ID1,
        change_rec_flag1          
    from trans_exp_mapplet_logic
)

select * from int_mplt_valdt_curr_cd_pdo

--End-DBShift
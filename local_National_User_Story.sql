-- Query1: To filter the Large Group/National, under 65 records from WORK_BNCHMRK_BASIC.(User_Story_Point_2)
create TABLE ts_pcaciirph_nogbd_r001_wh.WORK_BNCHMRK_NATIONAL_lOCAL_Q1 as
(select * from WORK_BNCHMRK_BASIC where bnchmrk_subctgry='Under 65 Population');

-- Query2: To Set Flag for Local/National based on the (User_Story_Point_4)
create TABLE ts_pcaciirph_nogbd_r001_wh.WORK_BNCHMRK_NATIONAL_lOCAL_Q2 as
SELECT *
CASE when 
MBU_LVL_2_DESC IN('HOME','LUMENOS','NATIONAL')
Then SET FLAG ='N'  //National benchmark
Else SET FLAG ='L'  //Local benchmark
END AS FLAG
from WORK_BNCHMRK_NATIONAL_lOCAL_Q1;

-- Query3: Based on the CPRI criteria, MBU_CF_CD column is queried to find National data.(User_Story_Point_4). XYZ is an assumption table.

create TABLE ts_pcaciirph_nogbd_r001_wh.WORK_BNCHMRK_NATIONAL_lOCAL_Q3 as
SELECT *,MBU_CF_CD from XYZ where substr(MBU_CF_CD,0,1) IN ('NC','NL','NN','NS','NT');

-- Query4: Based on the CII criteria, MBU_LVL_2_DESC column is queried to find National data.(User_Story_Point_4).  XYZ is an assumption table.

create TABLE ts_pcaciirph_nogbd_r001_wh.WORK_BNCHMRK_NATIONAL_lOCAL_Q3 as
select *,MBU_LVL_2_DESC,FLAG AS 'NATIONAL' from XYZ where MBU_LVL_2_DESC IN  ('HOME','LUMENOS','NATIONAL');

-- Query5: To identify the Local benchmark records.(User_Story_Point_5,6)
select *,FLAG AS 'LOCAL' from WORK_BNCHMRK_NATIONAL_lOCAL_Q2 where FLAG <> 'NATIONAL';

-- Query8: To set the LCL_NATL_BUS_CD column to N based on the condition(User_Story_Point_8)

select * from CASE WHEN MBU_LVL_2_DESC IN ('HOME','LUMENOS','NATIONAL', 'BLUE CARD/NASCO PAR') 
THEN SET LCL_NATL_BUS_CD = 'N' from SCD_ORG;

-- Note: User_Story_Point_3,7 are covered in the previous user story.
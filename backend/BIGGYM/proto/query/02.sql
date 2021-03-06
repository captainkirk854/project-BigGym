use BIGGYM;

select 
		plan.*,
        def.*,
        ex.*
from 
		vwPersonProfilePlan plan,
        TRAINING_PLAN_DEFINITION def,
        EXERCISE ex
where
		def.PLANid = plan.PLANid
  and
		def.EXERCISEid = ex.ID
	;
        


select 
      vwPePrPl.*,
      vwPlPr.*
  from 
      vwPersonProfilePlan vwPePrPl,
      vwPlanProgress vwPlPr
 where
       vwPePrPl.PLANid = vwPlPr.PLANid
     ;


select 
      vwPePrPl.FIRST_NAME,
      vwPePrPl.LAST_NAME,
      vwPePrPl.AGE,
      vwPePrPl.PROFILE_NAME,
      vwPePrPl.PLAN_NAME,
      vwPlPr.SET_DATE,
      vwPlPr.EXERCISE_WEEK,
      vwPlPr.EXERCISE_DAY,
      vwPlPr.EXERCISE_ORDINALITY,
      vwPlPr.EXERCISE_NAME,
      vwPlPr.BODY_PART,
      vwPlPr.SET_ORDINALITY,
      concat(vwPlPr.SET_WEIGHT, ' x', vwPlPr.SET_REPS) LIFTS
  from 
      vwPersonProfilePlan vwPePrPl,
      vwPlanProgress vwPlPr
 where
	  vwPePrPl.PLANid = vwPlPr.PLANid
order by
      vwPePrPl.PERSONid,
      vwPePrPl.PLAN_NAME,
	  vwPlPr.SET_DATE,
      vwPlPr.EXERCISEid,
      vwPlPr.SET_ORDINALITY
     ;
/*
Name       : vwPlanDefinition
Object Type: VIEW
Dependency : TRAINING_PLAN(TABLE), TRAINING_PLAN_DEFINITION(TABLE), EXERCISE(TABLE)
*/

use BIGGYM;

create or replace view vwPlanDefinition as
select 
    def.ID DEFINITIONid,
    def.PLANid,
    def.exerciseId,
    plan.PROFILEid PLANPROFILEid,
    plan.NAME PLAN_NAME,
    plan.objective,
    def.C_CREATE DEFINITION_REGISTRATION,
    round(datediff(curdate(), def.C_LASTMOD), 1) DEFINITION_AGE,
    def.EXERCISE_WEEK,
    def.EXERCISE_DAY,
    def.EXERCISE_ORDINALITY,
    exc.NAME EXERCISE_NAME,
    exc.BODY_PART
  from
    TRAINING_PLAN plan,
    TRAINING_PLAN_DEFINITION def,
    EXERCISE exc
 where
    plan.ID = def.PLANid
   and
    def.exerciseId = exc.ID
     ;
     
select * from vwPlanDefinition limit 10;

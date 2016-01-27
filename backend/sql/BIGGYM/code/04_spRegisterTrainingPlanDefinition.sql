/*
Name       : RegisterTrainingPlanDefinition
Object Type: STORED PROCEDURE
Dependency : 
            TABLE:
                - TRAINING_PLAN_DEFINITION
                - TRAINING_PLAN
                - PROFILE
                - PERSON
            
            STORED PROCEDURE :
                - spDebugLogger 
                - spErrorHandler
                - spRegisterTrainingPlan
*/

use BIGGYM;

drop procedure if exists RegisterTrainingPlanDefinition;
delimiter $$
create procedure RegisterTrainingPlanDefinition(in vExerciseName varchar(128),
                                                in vBodyPartName varchar(128),   
                                                in vTrainingPlanName varchar(128),
                                                in vProfileName varchar(32),
                                                in vFirstName varchar(32),
                                                in vLastName varchar(32),
                                                in vBirthDate date,
                                               out ObjectId smallint,
                                               out ReturnCode int,
                                               out ErrorCode int,
                                               out ErrorMsg varchar(512))
begin

    declare vExerciseId smallint default NULL;
    declare vPlanId smallint default NULL;
    
    -- -------------------------------------------------------------------------
    -- Error Handling -- 
    -- -------------------------------------------------------------------------
     declare CONTINUE handler for SQLEXCEPTION
        begin
          set @objectName = 'TRAINING_PLAN_DEFINITION';
          call spErrorHandler (ReturnCode, ErrorCode, ErrorMsg);
          call spDebugLogger (database(), @objectName, ReturnCode, ErrorCode, ErrorMsg);
        end;
 
    -- Variable Initialisation ..
    set ReturnCode = 0;
    set ErrorCode = 0;
    set ErrorMsg = '-';
    -- -------------------------------------------------------------------------
    -- Error Handling --
    -- -------------------------------------------------------------------------

    -- Attempt pre-emptive exercise-bodypart registration ..
    call spRegisterExercise (vExerciseName, 
                             vBodyPartName, 
                             vExerciseId, 
                             returnCode, 
                             errorCode, 
                             errorMsg);

    -- Attempt pre-emptive profile registration ..
    call spRegisterTrainingPlan (vTrainingPlanName, 
                                 vProfileName, 
                                 vFirstName, 
                                 vLastName, 
                                 vBirthDate, 
                                 vPlanId, 
                                 returnCode, 
                                 errorCode, 
                                 errorMsg);
 
    -- Attempt TrainingPlanDefinition registration ..
    if (vPlanId is NOT NULL and vExerciseId is NOT NULL) then
        insert into 
                TRAINING_PLAN_DEFINITION
                (
                 PLANId,
                 EXERCISEid
                )
                values
                (
                 vPlanId,
                 vExerciseId
                );
    end if;
    
    -- Get ID ..
    set ObjectId = NULL;
    
    select 
        ID
      into
        ObjectId
      from 
        TRAINING_PLAN_DEFINITION 
     where 
        PLANId = vPlanId 
       and 
        EXERCISEid = vExerciseId 
   limit 1;   
    
    -- If ID found, reset ReturnCode to 0 ..
    if (ObjectId is NOT NULL and ReturnCode != 0) then
        set ReturnCode = 0;
    end if;   

end$$
delimiter ;


/*
Sample Usage:
call RegisterTrainingPlanDefinition ('Curls','Arms', 'Get Bigger Workout', 'Faceman', 'Dirk', 'Benedict', '1945-03-01', @id, @returnCode, @errorCode, @errorMsg);
select @id, @returnCode, @errorCode, @errorMsg;
call RegisterTrainingPlanDefinition ('Curls','Arms', 'Get Bigger Workout', 'Mr.T', 'Lawrence', 'Tureaud', '1945-03-01', @id, @returnCode, @errorCode, @errorMsg);
select @id, @returnCode, @errorCode, @errorMsg;
select * from TRAINING_PLAN_DEFINITION order by DATE_REGISTERED asc;
*/

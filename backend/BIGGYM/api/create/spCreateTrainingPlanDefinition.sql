/*
Name       : spCreateTrainingPlanDefinition
Object Type: STORED PROCEDURE
Dependency : 
            TABLE:
                - TRAINING_PLAN_DEFINITION
                - TRAINING_PLAN
                - PROFILE
                - PERSON
            
            STORED PROCEDURE :
                - spActionOnException
                - spActionOnStart
                - spActionOnEnd
                - spGetIdForTrainingPlanDefinition
                - spGetIdForExerciseFromTrainingPlanDefinitionId
*/

use BIGGYM;

drop procedure if exists spCreateTrainingPlanDefinition;
delimiter $$
create procedure spCreateTrainingPlanDefinition(in vPlanId mediumint unsigned,
                                                in vExerciseId mediumint unsigned,
                                                in vNew_ExerciseWeek tinyint unsigned,
                                                in vNew_ExerciseDay tinyint unsigned,
                                                in vNew_ExerciseOrdinality tinyint unsigned,
                                               out ObjectId mediumint unsigned,
                                               out ReturnCode int,
                                               out ErrorCode int,
                                               out ErrorState int,
                                               out ErrorMsg varchar(512))
begin

    -- Declare ..
    declare ObjectName varchar(128) default 'TRAINING_PLAN_DEFINITION';
    declare SpName varchar(128) default 'spCreateTrainingPlanDefinition';
    declare SignificantFields varchar(512) default concat('EXERCISE_WEEK=', saynull(vNew_ExerciseWeek), 
                                                          ',EXERCISE_DAY=', saynull(vNew_ExerciseDay),
                                                          ',EXERCISE_ORDINALITY=', saynull(vNew_ExerciseOrdinality));
    declare ReferenceFields varchar(512) default concat('PLANid=', saynull(vPlanId), 
                                                        ',EXERCISEid=', saynull(vExerciseId));
    declare TransactionType varchar(16) default 'insert';

    declare SpComment varchar(1024);
    declare tStatus varchar(64) default '-';
    
    declare EXIT handler for SQLEXCEPTION
    begin
      set @severity = 1;
      call spActionOnException (ObjectName, SpName, @severity, SpComment, ReturnCode, ErrorCode, ErrorState, ErrorMsg);
    end;
 
    -- Initialise ..
    set ReturnCode = 0;
    set ErrorCode = 0;
    set ErrorState = 0;
    set ErrorMsg = '-';
    call spActionOnStart (TransactionType, ObjectName, SignificantFields, ReferenceFields, SpComment);

    -- Attempt create ..
    call spGetIdForTrainingPlanDefinition (vPlanId, vNew_ExerciseWeek, vNew_ExerciseDay, vNew_ExerciseOrdinality, ObjectId, ReturnCode);
    if (ObjectId is NULL) then    
        insert into 
                TRAINING_PLAN_DEFINITION
                (
                 EXERCISE_WEEK,
                 EXERCISE_DAY,
                 EXERCISE_ORDINALITY,
                 PLANId,
                 exerciseId
                )
                values
                (
                 vNew_ExerciseWeek,
                 vNew_ExerciseDay,
                 vNew_ExerciseOrdinality,
                 vPlanId,
                 vExerciseId
                );
        -- success ..
        set tStatus = 0;
        call spGetIdForTrainingPlanDefinition (vPlanId, vNew_ExerciseWeek, vNew_ExerciseDay, vNew_ExerciseOrdinality, ObjectId, ReturnCode);
    else
        -- already exists ..
        set tStatus = 1;
        
        -- verify input exerciseId matches Reference Id value for EXERCISE already present ..
        call spGetIdForExerciseFromTrainingPlanDefinitionId (vExerciseId, ObjectId, ReturnCode);
        if (ObjectId is NULL) then
            -- conflicting Id for EXERCISE present - transaction aborted
            set tStatus = -8;
        end if;
        
    end if;
    
    -- Log ..
    set ReturnCode = tStatus;
    call spActionOnEnd (ObjectName, SpName, ObjectId, tStatus, SpComment, ReturnCode, ErrorCode, ErrorState, ErrorMsg);

end$$
delimiter ;
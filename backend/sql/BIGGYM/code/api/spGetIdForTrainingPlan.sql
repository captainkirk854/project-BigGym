/*
Name       : spGetIdForTrainingPlan
Object Type: STORED PROCEDURE
Dependency : 
            TABLE:
                - TRAINING_PLAN
            
            STORED PROCEDURE :
                - spGetObjectId
*/

use BIGGYM;

drop procedure if exists spGetIdForTrainingPlan;
delimiter $$
create procedure spGetIdForTrainingPlan(in vTrainingPlanName varchar(128),
                                        in vProfileId smallint,
                                       out ObjectId smallint,
                                       out ReturnCode int)
begin

    -- Declare ..
       declare ObjectName varchar(128) default 'TRAINING_PLAN';
        
    -- Get Plan Id ..                                 
       set @getIdWhereClause = concat('NAME = ''', vTrainingPlanName,  ''' and PROFILEid = ', vProfileId);
       call spGetObjectId (ObjectName, @getIdWhereClause, ObjectId,  ReturnCode); 
    
end$$
delimiter ;


/*
Sample Usage:

call spGetIdForTrainingPlan ('Get Bigger Scam Workout', 11, @id, @returnCode);
select @id, @returnCode;
*/

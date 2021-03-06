/*
Name       : spCreateProgressEntry
Object Type: STORED PROCEDURE
Dependency : 
            TABLE:
                - PROGRESS
            
            STORED PROCEDURE :
                - spActionOnException
                - spActionOnStart
                - spActionOnEnd
*/

use BIGGYM;

drop procedure if exists spCreateProgressEntry;
delimiter $$
create procedure spCreateProgressEntry(in vNew_SetOrdinality tinyint unsigned,
                                       in vNew_SetReps tinyint unsigned,
                                       in vNew_SetWeight double,
                                       in vNew_SetDatestamp datetime,
                                       in vNew_SetComment varchar(256),
                                       in vNew_BodyWeight double,
                                       in vPlanDefinitionId mediumint unsigned,
                                      out ObjectId mediumint unsigned,
                                      out ReturnCode int,
                                      out ErrorCode int,
                                      out ErrorState int,
                                      out ErrorMsg varchar(512))
begin

    -- Declare ..
    declare ObjectName varchar(128) default 'PROGRESS';
    declare SpName varchar(128) default 'spCreateProgressEntry';
    declare SignificantFields varchar(512) default concat('SET_ORDINALITY=', saynull(vNew_SetOrdinality), 
                                                          ',SET_REPS=', saynull(vNew_SetReps), 
                                                          ',SET_WEIGHT=', saynull(vNew_SetWeight), 
                                                          ',SET_DATE=', saynull(vNew_SetDatestamp),
                                                          ',SET_COMMENT=', saynull(vNew_SetComment),
                                                          ',BODY_WEIGHT=', saynull(vNew_BodyWeight));
    declare ReferenceFields varchar(512) default concat('DEFINITIONid=', saynull(vPlanDefinitionId));
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

    -- Check if date uses valid format (YY-mm-dd) ..
    if (date(vNew_SetDatestamp) is NOT NULL and (vNew_SetDatestamp != '0000-00-00')) then

        -- Attempt create ..
        call spGetIdForProgressEntry (vNew_SetOrdinality, vNew_SetReps, vNew_SetWeight, vNew_SetDatestamp, vPlanDefinitionId, ObjectId, ReturnCode);
        if (ObjectId is NULL) then
            insert into 
                    PROGRESS
                    ( 
                     SET_ORDINALITY, 
                     SET_REPS, 
                     SET_WEIGHT, 
                     SET_DATE,
                     set_comment,
                     body_weight,
                     DEFINITIONid
                    )
                    values
                    (
                     vNew_SetOrdinality,
                     vNew_SetReps,
                     vNew_SetWeight,
                     vNew_SetDatestamp,
                     vNew_SetComment,
                     vNew_BodyWeight,
                     vPlanDefinitionId
                    );

            -- success ..
            set tStatus = 0;
            call spGetIdForProgressEntry (vNew_SetOrdinality, vNew_SetReps, vNew_SetWeight, vNew_SetDatestamp, vPlanDefinitionId, ObjectId, ReturnCode);

        else
            -- already exists ..
            set tStatus = 1;
        end if;

    else
        -- invalid date format used ..
        set tStatus = -6;  
    end if;
    
    -- Log ..
    set ReturnCode = tStatus;
    call spActionOnEnd (ObjectName, SpName, ObjectId, tStatus, SpComment, ReturnCode, ErrorCode, ErrorState, ErrorMsg);

end$$
delimiter ;

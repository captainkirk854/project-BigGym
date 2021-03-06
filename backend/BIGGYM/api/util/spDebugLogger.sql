/*
Name       : spDebugLogger
Object Type: STORED PROCEDURE
Dependency :
            TABLE:
                - DEBUG_LOG

            FUNCTION :
                - strcln

            STORED PROCEDURE :
                - spExecuteSQL
*/

use BIGGYM;

drop procedure if exists spDebugLogger;
delimiter $$
create procedure spDebugLogger(in DebugLoggingDatabase varchar(128),
                               in ObjectName varchar(128),
                               in SprocName varchar(128),
                               in SprocComment varchar(1024),
                               in SprocReturnCode int,
                               in SqlErrorCode int,
                               in SqlStateCode int,
                               in SqlErrorMsg varchar(512))
begin

    -- Initialise ..
    declare DebugLoggingTable varchar(128) default 'DEBUG_LOG';
    declare dash char(1) default '-';

    -- Use existence of logging table to trigger logging ..
    if (select 1 from INFORMATION_SCHEMA.TABLES where TABLE_TYPE = 'BASE TABLE' and TABLE_SCHEMA = DebugLoggingDatabase and TABLE_NAME = DebugLoggingTable) then

        set @dml = concat('insert into ', 
                                        DebugLoggingDatabase, '.',  DebugLoggingTable, 
                                      ' (',
                                            'OBJECT_NAME,',
                                            'SPROC_NAME,',
                                            'SPROC_COMMENT,',
                                            'SPROC_RETURN_CODE,',
                                            'SQL_ERROR_CODE,',
                                            'SQL_STATE_CODE,',
                                            'SQL_ERROR_MESSAGE'
                                      ' )',
                              ' values ', 
                                      ' (', 
                                            '''',strcln(ifNull(ObjectName, dash), 'show'),'''', ',',
                                            '''',strcln(ifNull(SprocName, dash), 'show'),'''', ',',
                                            '''',strcln(ifNull(SprocComment, dash), 'show'),'''', ',',
                                                 SprocReturnCode, ',',
                                                 SqlErrorCode, ',',
                                                 SqlStateCode, ',',
                                            '''',strcln(ifNull(SqlErrorMsg, dash), 'show'),'''', 
                                      ' )'
                         );
                     
        call spExecuteSQL (@dml, NULL, NULL, NULL, NULL);
        
    end if;

end$$
delimiter ;


/*
Sample Usage:

set @objectName='MYTABLE';
set @sprocName='sproc1';
set @sprocComment='my first sproc of the day';
set @returnCode=-1;
set @errorCode=-999;
set @stateCode=1234;
set @errorMsg='We have some problems';
call spDebugLogger (database(), @objectName, @sprocName, @sprocComment, @returnCode, @errorCode, @stateCode, @errorMsg);

call spDebugLogger (database(), 'ANOTHER_TABLE', 'my best sproc', 'it is super!', -1, 1223, 133, 'OH DEAR .. OH DEAR OH DEAR');
*/

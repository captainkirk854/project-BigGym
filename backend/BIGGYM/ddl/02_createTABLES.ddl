use BIGGYM;

drop table if exists EXERCISE;
create table if not exists EXERCISE
 (
  ID mediumint unsigned not null auto_increment,
  NAME varchar(128) not null,
  BODY_PART varchar(128) not null,
  C_CREATE datetime(3) default current_timestamp(3) not null,
  C_LASTMOD datetime(3) default current_timestamp(3) not null,
  primary key (ID)
 );

drop table if exists PERSON;
create table if not exists PERSON
 (
  ID mediumint unsigned not null auto_increment,
  FIRST_NAME varchar(32) not null,
  LAST_NAME varchar(32) not null,
  BIRTH_DATE date not null,
  gender enum('M','F','-') null default '-',
  body_height double null default 0,
  C_CREATE datetime(3) default current_timestamp(3) not null,
  C_LASTMOD datetime(3) default current_timestamp(3) not null,
  primary key (ID)
 );

drop table if exists PROFILE;
create table if not exists PROFILE
 (
  ID mediumint unsigned not null auto_increment,
  NAME varchar(32) not null default 'UNDEFINED CHAMPION',
  PERSONid mediumint unsigned not null,
  C_CREATE datetime(3) default current_timestamp(3) not null,
  C_LASTMOD datetime(3) default current_timestamp(3) not null,
  primary key (ID)
 );

drop table if exists TRAINING_PLAN;
create table if not exists TRAINING_PLAN
 (
  ID mediumint unsigned not null auto_increment,
  NAME varchar(128) not null,
  objective enum('Gain Muscle', 'Lose Weight', 'General Fitness', 'Toning', 'Other') null default 'Other',
  private enum('Y','N') null default 'N',
  PROFILEid mediumint unsigned not null,
  C_CREATE datetime(3) default current_timestamp(3) not null,
  C_LASTMOD datetime(3) default current_timestamp(3) not null,
  primary key (ID)
 );

drop table if exists TRAINING_PLAN_DEFINITION;
create table if not exists TRAINING_PLAN_DEFINITION
 (
  ID mediumint unsigned not null auto_increment,
  EXERCISE_WEEK tinyint unsigned default 1 null,
  EXERCISE_DAY enum('1','2','3','4','5','6','7') null,
  EXERCISE_ORDINALITY tinyint unsigned null,
  PLANid mediumint unsigned not null,
  exerciseId mediumint unsigned not null,
  C_CREATE datetime(3) default current_timestamp(3) not null,
  C_LASTMOD datetime(3) default current_timestamp(3) not null,
  primary key (ID)
 );

drop table if exists PROGRESS;
create table if not exists PROGRESS
 (
  ID mediumint unsigned  not null auto_increment,
  SET_ORDINALITY tinyint unsigned default 1 null,
  SET_REPS tinyint unsigned default 0 not null,
  SET_WEIGHT double default 0 not null,
  SET_DATE datetime not null,
  set_comment varchar(256) null default '-',
  body_weight double null default 0,
  DEFINITIONid mediumint unsigned not null,
  C_CREATE datetime(3) default current_timestamp(3) not null,
  C_LASTMOD datetime(3) default current_timestamp(3) not null,
  primary key (ID)
 );

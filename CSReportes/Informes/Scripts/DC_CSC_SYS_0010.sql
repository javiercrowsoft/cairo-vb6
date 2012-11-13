/*---------------------------------------------------------------------
Nombre: Bloqueos por Usuario
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_SYS_0010]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_SYS_0010]

/*

 select * from TmpStringToTable

 DC_CSC_SYS_0010 1

*/

go
create procedure DC_CSC_SYS_0010 (

  @@us_id          int

)as 
begin
set nocount on

  create table #t_lock (spid int, dbid int, ObjId int, IndId int, Type varchar(255), Resource varchar(255),
                        Mode varchar(255), Status varchar(255))
  insert into #t_lock exec sp_lock


  create table #t_who (
                      spid        int,
                      ecid        int,
                      status      varchar(255),                   
                      loginame    varchar(255),                                                                                                                     
                      hostname    varchar(255),                                                                                                                     
                      blk         int,
                      dbname      varchar(255),                                                                                                                     
                      cmd         varchar(255)     
                      )

  insert into #t_who exec sp_who

  select 1, hostname as Computadora, count(l.spid) as Bloqueos 
  from  #t_lock l inner join #t_who w on l.spid=w.spid
  group by hostname
  order by 3 desc

end
go
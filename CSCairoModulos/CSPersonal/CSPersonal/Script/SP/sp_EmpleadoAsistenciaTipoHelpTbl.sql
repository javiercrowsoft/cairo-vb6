if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_EmpleadoAsistenciaTipoHelpTbl]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_EmpleadoAsistenciaTipoHelpTbl]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*

sp_EmpleadoAsistenciaTipoHelp 0,1,0,'',0,0,''

*/
create procedure sp_EmpleadoAsistenciaTipoHelpTbl 

as

	begin

	set nocount on
  
	insert into #t_horas (east_id, east_nombre, east_codigo, east_codigo2)
								values (-1000,'01 hora', '1',1)
	insert into #t_horas (east_id, east_nombre, east_codigo, east_codigo2)
								values (-1001,'01.5 hora', '1.5',1.5)
	insert into #t_horas (east_id, east_nombre, east_codigo, east_codigo2)
								values (-1002,'02 hs', '2',2)
	insert into #t_horas (east_id, east_nombre, east_codigo, east_codigo2)
								values (-1003,'02.5 hs', '2.5',2.5)
	insert into #t_horas (east_id, east_nombre, east_codigo, east_codigo2)
								values (-1004,'03 hs', '3',3)
	insert into #t_horas (east_id, east_nombre, east_codigo, east_codigo2)
								values (-1005,'03.5 hs', '3.5',3.5)
	insert into #t_horas (east_id, east_nombre, east_codigo, east_codigo2)
								values (-1006,'04 hs', '4',4)
	insert into #t_horas (east_id, east_nombre, east_codigo, east_codigo2)
								values (-1007,'04.5 hs', '4.5',4.5)
	insert into #t_horas (east_id, east_nombre, east_codigo, east_codigo2)
								values (-1008,'05 hs', '5',5)
	insert into #t_horas (east_id, east_nombre, east_codigo, east_codigo2)
								values (-1009,'05.5 hs', '5.5',5.5)
	insert into #t_horas (east_id, east_nombre, east_codigo, east_codigo2)
								values (-1010,'06 hs', '6',6)
	insert into #t_horas (east_id, east_nombre, east_codigo, east_codigo2)
								values (-1011,'06.5 hs', '6.5',6.5)
	insert into #t_horas (east_id, east_nombre, east_codigo, east_codigo2)
								values (-1012,'07 hs', '7',7)
	insert into #t_horas (east_id, east_nombre, east_codigo, east_codigo2)
								values (-1013,'07.5 hs', '7.5',7.5)
	insert into #t_horas (east_id, east_nombre, east_codigo, east_codigo2)
								values (-1014,'08 hs', '8',8)
	insert into #t_horas (east_id, east_nombre, east_codigo, east_codigo2)
								values (-1015,'08.5 hs', '8.5',8.5)
	insert into #t_horas (east_id, east_nombre, east_codigo, east_codigo2)
								values (-1016,'09 hs', '9',9)
	insert into #t_horas (east_id, east_nombre, east_codigo, east_codigo2)
								values (-1017,'09.5 hs', '9.5',9.5)
	insert into #t_horas (east_id, east_nombre, east_codigo, east_codigo2)
								values (-1018,'10 hs', '10',10)
	insert into #t_horas (east_id, east_nombre, east_codigo, east_codigo2)
								values (-1019,'10.5 hs', '10.5',10.5)
	insert into #t_horas (east_id, east_nombre, east_codigo, east_codigo2)
								values (-1020,'11 hs', '11',11)
	insert into #t_horas (east_id, east_nombre, east_codigo, east_codigo2)
								values (-1021,'11.5 hs', '11.5',11.5)
	insert into #t_horas (east_id, east_nombre, east_codigo, east_codigo2)
								values (-1022,'12 hs', '12',12)
	insert into #t_horas (east_id, east_nombre, east_codigo, east_codigo2)
								values (-1023,'12.5 hs', '12.5',12.5)
	insert into #t_horas (east_id, east_nombre, east_codigo, east_codigo2)
								values (-1024,'13 hs', '13',13)
	insert into #t_horas (east_id, east_nombre, east_codigo, east_codigo2)
								values (-1025,'13.5 hs', '13.5',13.5)
	insert into #t_horas (east_id, east_nombre, east_codigo, east_codigo2)
								values (-1026,'14 hs', '14',14)
	insert into #t_horas (east_id, east_nombre, east_codigo, east_codigo2)
								values (-1027,'14.5 hs', '14.5',14.5)
	insert into #t_horas (east_id, east_nombre, east_codigo, east_codigo2)
								values (-1028,'15 hs', '15',15)
	insert into #t_horas (east_id, east_nombre, east_codigo, east_codigo2)
								values (-1029,'15.5 hs', '15.5',15.5)
	insert into #t_horas (east_id, east_nombre, east_codigo, east_codigo2)
								values (-1030,'16 hs', '16',16)
	insert into #t_horas (east_id, east_nombre, east_codigo, east_codigo2)
								values (-1031,'16.5 hs', '16.5',16.5)
	insert into #t_horas (east_id, east_nombre, east_codigo, east_codigo2)
								values (-1032,'17 hs', '17',17)
	insert into #t_horas (east_id, east_nombre, east_codigo, east_codigo2)
								values (-1033,'17.5 hs', '17.5',17.5)
	insert into #t_horas (east_id, east_nombre, east_codigo, east_codigo2)
								values (-1034,'18 hs', '18',18)
	insert into #t_horas (east_id, east_nombre, east_codigo, east_codigo2)
								values (-1035,'18.5 hs', '18.5',18.5)

end
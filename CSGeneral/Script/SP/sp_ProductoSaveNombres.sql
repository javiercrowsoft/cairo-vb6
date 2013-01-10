if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ProductoSaveNombres]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ProductoSaveNombres]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_ProductoSaveNombres 1,135

-- select rpt_id_nombrecompra,* from producto where rpt_id_nombrecompra is not null

-- DC_CSC_VEN_9700 1,135,1,'prefjio',0,0,0,0,0,1,2,3,4,3,'s1',4,'s2',1,'s3',2,'s4',6,'s5',7,'s6',9,'s7',5,'s8',8,'s9',10,'s10'
-- DC_CSC_VEN_9700 1,135,0,'prefjio',0,0,0,0,0,1,2,3,4,3,'s1',4,'s2',1,'s3',2,'s4',6,'s5',7,'s6',9,'s7',5,'s8',8,'s9',10,'s10'
-- DC_CSC_VEN_9700 1,135,0,'prefjio',0,0,0,0,0,1,2,3,4,3,'s1',4,'s2',1,'s3',2,'s4',6,'s5',7,'s6',9,'s7',5,'s8',8,'s9',10,'s10'
-- Cartucho HP Negro Carga Completa Orignial Toner Laser

create procedure sp_ProductoSaveNombres (
  @@us_id int,
  @@pr_id  int
)
as

set nocount on

begin

  exec sp_ProductoSaveNombresCliente @@us_id, @@pr_id

  exec sp_ProductoSaveWebPadre @@us_id, @@pr_id

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go




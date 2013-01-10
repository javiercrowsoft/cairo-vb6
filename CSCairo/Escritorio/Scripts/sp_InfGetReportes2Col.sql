if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_InfGetReportes2Col]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_InfGetReportes2Col]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/*

 sp_columns informe

 sp_InfGetReportes2Col 1,2

*/

create procedure sp_InfGetReportes2Col (
  @@us_id     int,
  @@inf_tipo   int =1
)
as
begin
  set nocount on

create table #Rpts(
  id   int,
  rpt1 varchar(255),
  rpt2 varchar(255),
  rptid1 int,
  rptid2 int,
  rtpmodulo1   varchar(1000),
  rtpmodulo2   varchar(1000),
  rptdesc1     varchar(1000),
  rptdesc2     varchar(1000)
)

  declare @n int
  declare @id int
  declare @rpt varchar(255)
  declare @rptid int
  declare @rptdesc      varchar(1000)
  declare @modulo      varchar(1000)
  declare @lastmodulo  varchar(1000)

  create table #Informes (
                          per_id int,
                          pre_id int
                          )

  insert into #Informes exec SP_SecGetPermisosXUsuario @@us_id, 1

  declare c_rpt insensitive cursor for

    select distinct

        rpt_id,
        rpt_nombre,
        inf_modulo,
        rpt_descrip

    from reporte r inner join informe i    on r.inf_id = i.inf_id
                   inner join #Informes i2 on i.pre_id = i2.pre_id

    where (us_id = @@us_id or @@us_id = 0) and i.activo <> 0 and i.inf_tipo = @@inf_tipo -- Informe

    order by inf_modulo, rpt_nombre
  
  set @n = 1
  set @id = 0
  
  open c_rpt
  fetch next from c_rpt into @rptid, @rpt, @modulo, @rptdesc
  while @@fetch_status = 0 begin

    if @n=1 begin
      set @id = @id + 1
      insert into #rpts (id,rpt1,rptid1,rptdesc1,rtpmodulo1) values(@id,@rpt,@rptid,@rptdesc, @modulo)
      set @lastmodulo = @modulo 
      set @n = 2
     end 
    else begin
      if @lastmodulo <> @modulo begin
        set @id = @id + 1
        insert into #rpts (id,rpt1,rptid1,rptdesc1,rtpmodulo1) values(@id,@rpt,@rptid,@rptdesc, @modulo)
        set @lastmodulo = @modulo 
        set @n = 2
      end else begin
        update #rpts set rpt2 = @rpt, rptid2 = @rptid, rptdesc2 = @rptdesc, rtpmodulo2 = @modulo where id = @id
        set @n = 1
      end
    end
  
    fetch next from c_rpt into @rptid, @rpt, @modulo, @rptdesc
  end
  close c_rpt
  deallocate c_rpt
  
  select * from #rpts
  
end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_productoNumeroSerieGetDetalle]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_productoNumeroSerieGetDetalle]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*

sp_productoNumeroSerieGetDetalle 6

*/
create procedure sp_productoNumeroSerieGetDetalle (
  @@prns_id int
)
as
begin

  set nocount on

  select  
          'Cliente:      '     + isnull(cli_nombre,'')   + char(13)+char(10)+
          'Contacto:   '       + isnull(cont_nombre,'')  + char(13)+char(10)+
          'OS:            '   + isnull(os_nrodoc,'')    + char(13)+char(10)+
          'OT:            '   + prns_codigo2            + char(13)+char(10)+
          'Codigo3:    '      + prns_codigo3

                as Detalle 

  from (ProductoNumeroSerie prns 
        inner join OrdenServicio os 
           on prns_id              = @@prns_id 
          and prns.doct_id_ingreso = 42
          and prns.doc_id_ingreso  = os.os_id
        )
        inner join Cliente cli    on os.cli_id     = cli.cli_id
        left  join Contacto cont on os.cont_id     = cont.cont_id
        left  join Tarea tar     on prns.tar_id   = tar.tar_id
        left  join Usuario us    on tar.us_id_responsable = us.us_id
        left  join producto pr   on prns.pr_id     = pr.pr_id
end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


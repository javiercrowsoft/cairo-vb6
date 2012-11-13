if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_productoNumeroSerieGetData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_productoNumeroSerieGetData]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*


*/
create procedure sp_productoNumeroSerieGetData (
	@@prns_id int
)
as
begin

	set nocount on

	select  cli.cli_id, 
					cli_nombre, 
					cont.cont_id, 
					cont_nombre,
					prns_codigo2,
					prns_codigo3, 
					us.us_id, 
					us_nombre,
					pr_nombrecompra 
					+ ' - OS: '  + os_nrodoc 
					+ ' - OT: '  + prns_codigo2 
					+ ' - C3: ' + prns_codigo3

								as serie_descrip 

	from (ProductoNumeroSerie prns 
				inner join OrdenServicio os 
					 on prns_id 						 = @@prns_id 
					and prns.doct_id_ingreso = 42
					and prns.doc_id_ingreso  = os.os_id
				)
				inner join Cliente cli 	 on os.cli_id 		= cli.cli_id
				left  join Contacto cont on os.cont_id 		= cont.cont_id
				left  join Tarea tar     on prns.tar_id 	= tar.tar_id
				left  join Usuario us    on tar.us_id_responsable = us.us_id
			  left  join producto pr   on prns.pr_id 		= pr.pr_id
end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


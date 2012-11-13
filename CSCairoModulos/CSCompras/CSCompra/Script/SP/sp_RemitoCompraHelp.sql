if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_RemitoCompraHelp]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_RemitoCompraHelp]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*
 sp_remitocomprahelp 1,1,0,0, 'X-0001-00000001 Epson America, Inc.',-1,0
*/
create procedure sp_RemitoCompraHelp (
	@@emp_id          int,
  @@us_id           int,
	@@bForAbm         tinyint,
	@@bFilterType     tinyint,
	@@filter 					varchar(255)  = '',
  @@check  					smallint 			= 0,
  @@rc_id           int           = 0,
	@@filter2         varchar(255)  = ''
)
as
begin

	set nocount on

--/////////////////////////////////////////////////////////////////////////////////////

	declare @filter varchar(255)
	set @filter = @@filter
	exec sp_HelpGetFilter @@bFilterType, @filter out

--/////////////////////////////////////////////////////////////////////////////////////
  
	if @@check <> 0 begin
	
		select 	rc_id,
						rc_nrodoc	+ ' ' + prov_nombre	as [Nombre]
	
		from RemitoCompra rc inner join Proveedor prov on rc.prov_id = prov.prov_id
	
		where (rc_nrodoc = @@filter or rc_nrodoc	+ ' ' + prov_nombre = @@filter)
			and (rc_id = @@rc_id or @@rc_id=0)
	
	end else begin
	
		select top 50
					 rc_id,
	         rc_nrodoc	+ ' ' + prov_nombre	as Documento,
	         rc_fecha   as Fecha,
					 rc_total   as Total,
					 doc_nombre as Documento
	
		from RemitoCompra rc inner join Proveedor prov on rc.prov_id = prov.prov_id
										 	   inner join Documento doc on rc.doc_id = doc.doc_id
	
		where (		 rc_nrodoc like @filter 
						or prov_nombre like @filter
	          or @@filter = ''
					)	
	end		

end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_ListaPrecioConfigAddProductos]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ListaPrecioConfigAddProductos]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*

sp_ListaPrecioConfigAddProductos '0',0

*/
create procedure sp_ListaPrecioConfigAddProductos (
	@@pr_id  varchar(255),
	@@lp_id  int
)
as
begin

	set nocount on

	----------------------------------------------------------------------------------------

	declare @pr_id int
	declare @ram_id_Producto int
	
	declare @clienteID int
	declare @IsRaiz    tinyint
	
	exec sp_ArbConvertId @@pr_id, 			@pr_id out, 			@ram_id_Producto out
	
	exec sp_GetRptId @clienteID out

	if @ram_id_Producto <> 0 begin
	
		-- exec sp_ArbGetGroups @ram_id_Producto, @clienteID, @@us_id
	
		exec sp_ArbIsRaiz @ram_id_Producto, @IsRaiz out
	  if @IsRaiz = 0 begin
			exec sp_ArbGetAllHojas @ram_id_Producto, @clienteID 
		end else 
			set @ram_id_Producto = 0
	end

	----------------------------------------------------------------------------------------


	----------------------------------------------------------------------------------------

	select 	pr.pr_id,
					pr_nombrecompra,
					lpc.lpc_id,
					lpc.lp_id,
					lp_nombre,
					lpc_orden

	from Producto pr left join ListaPrecioConfig lpc on pr.pr_id = lpc.pr_id
								   left join ListaPrecio lp on lpc.lp_id = lp.lp_id

	where (pr.pr_id = @pr_id or @pr_id = 0)
		and (
						(exists(select rptarb_hojaid 
	                  from rptArbolRamaHoja 
	                  where
	                       rptarb_cliente = @clienteID
	                  and  tbl_id = 30
	                  and  rptarb_hojaid = pr.pr_id
								   ) 
	           )
	        or 
						 (@ram_id_Producto = 0)
				 )

		and (@@lp_id = 0 or exists(select * from ListaPrecioConfig where lp_id = @@lp_id and pr_id = pr.pr_id))

	order by pr_nombrecompra

end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


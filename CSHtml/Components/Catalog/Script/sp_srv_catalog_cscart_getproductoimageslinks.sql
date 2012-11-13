if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_srv_catalog_cscart_getproductoimageslinks]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_srv_catalog_cscart_getproductoimageslinks]

go
/*
	update producto set modificado = getdate()

	exec sp_srv_catalog_cscart_getproductoimageslinks 1
*/

create procedure sp_srv_catalog_cscart_getproductoimageslinks (
	@@catw_id int
)

as

begin

	set nocount on

	create table #t_catalog_image(prwi_id int not null)

	declare @desde datetime

  set @desde = '19000101'

	declare @cfg_clave varchar(255)
	declare @cfg_valor varchar(5000) 

	set @cfg_clave = 'Ultima Ejecucion - Productos - ImgLk_'+ convert(varchar,@@catw_id)

	exec sp_Cfg_GetValor  'Catalogo Web',
											  @cfg_clave,
											  @cfg_valor out,
											  0

	if isdate(@cfg_valor)<>0 begin

		set @desde = @cfg_valor
	end

	set @cfg_valor = convert(varchar,getdate(),121)
	exec sp_Cfg_SetValor 'Catalogo Web',
											 @cfg_clave, 
											 @cfg_valor

	insert into CatalogoWebProductoImageLink (catw_id, prwi_id)
					select distinct @@catw_id, prwi_id
					from Producto pr inner join CatalogoWebItem catwi on 		pr.pr_id = catwi.pr_id
																															and catwi.catw_id = @@catw_id

													 inner join ProductoWebImage prwi on pr.pr_id = prwi.pr_id
					where pr.modificado > @desde
						and pr_sevende <> 0 
						and not exists( select * 
													  from CatalogoWebProductoImageLink 
													  where catw_id = @@catw_id 
															and prwi_id = prwi.prwi_id 
													)

	insert into #t_catalog_image
	select 	top 100 
					prwi.prwi_id

	from ProductoWebImage prwi inner join CatalogoWebProductoImageLink t 
					 on prwi.prwi_id = t.prwi_id 
					and t.catw_id = @@catw_id

	select  
					prwi.pr_id,
			    pr_nombreventa 			as pr_nombre,
					prwi.prwi_alt,
					prwi.prwi_archivo,
					case prwi.prwi_tipo
						when 1 then 'M'--csE_PrWebImageThumbnail = 1
						when 2 then 'T'--csE_PrWebImageMedium = 2
						when 3 then 'B'--csE_PrWebImageBig = 3
					end as type,
					prwi.prwi_posicion		as position,
					0											as detailed_id,
					prwi.prwi_archivo,
					case when catw_folderimage <> '' then  catw_folderimage + '\'
					else                                   ''
					end 
					+
					case when pr_webimagefolder <> '' then pr_webimagefolder + '\'
					else                                   ''
					end 
					+ prwi.prwi_archivo as imageFile

	from ProductoWebImage prwi inner join #t_catalog_image t on prwi.prwi_id = t.prwi_id
														 inner join catalogoweb on catw_id = @@catw_id
														 inner join producto pr on prwi.pr_id = pr.pr_id

	delete CatalogoWebProductoImageLink 
	where exists( select * from #t_catalog_image t 
								where t.prwi_id = CatalogoWebProductoImageLink.prwi_id 
							)
		and catw_id = @@catw_id
end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


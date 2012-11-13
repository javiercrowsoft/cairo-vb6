if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_srv_catalog_cscart_getproductoCategorylinks]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_srv_catalog_cscart_getproductoCategorylinks]

go
/*
	update producto set modificado = getdate() where exists (select * from CatalogoWebItem where pr_id = producto.pr_id and catw_id = 3)

	exec sp_srv_catalog_cscart_getproductoCategorylinks 1
*/

create procedure sp_srv_catalog_cscart_getproductoCategorylinks (
	@@catw_id int
)

as

begin

	set nocount on

	create table #t_catalog_category(catwci_id int not null)

	declare @desde datetime

  set @desde = '19000101'

	declare @cfg_clave varchar(255)
	declare @cfg_valor varchar(5000) 

	set @cfg_clave = 'Ultima Ejecucion - Productos - CatLk_'+ convert(varchar,@@catw_id)

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

	insert into CatalogoWebCategoriaItemLink (catw_id, catwci_id)
					select @@catw_id, catwci_id
					from Producto pr inner join CatalogoWebItem catwi on 		pr.pr_id = catwi.pr_id
																															and catwi.catw_id = @@catw_id

													 inner join CatalogoWebCategoriaItem catwci on pr.pr_id = catwci.pr_id
					where pr.modificado > @desde
						and pr_sevende <> 0 
						and not exists(select * from CatalogoWebCategoriaItemLink where catw_id = @@catw_id and catwci_id = catwci.catwci_id)

	insert into #t_catalog_category
	select 	top 100 
					catwci.catwci_id

	from CatalogoWebCategoriaItem catwci inner join CatalogoWebCategoriaItemLink t 
					 on catwci.catwci_id = t.catwci_id 
					and t.catw_id = @@catw_id

	select  
					catwci.pr_id,
			    pr_nombreventa 					as pr_nombre,
					catwc.catwc_codigo			as category_id,
					catwci.catwci_posicion	as position,
					'M'											as link_type

	from CatalogoWebCategoriaItem catwci inner join #t_catalog_category t on catwci.catwci_id = t.catwci_id
														 inner join CatalogoWeb on catw_id = @@catw_id
														 inner join CatalogoWebCategoria catwc on catwci.catwc_id = catwc.catwc_id
														 inner join producto pr on catwci.pr_id = pr.pr_id

	delete CatalogoWebCategoriaItemLink 
	where exists( select * from #t_catalog_category t 
								where t.catwci_id = CatalogoWebCategoriaItemLink.catwci_id 
							)
		and catw_id = @@catw_id
end
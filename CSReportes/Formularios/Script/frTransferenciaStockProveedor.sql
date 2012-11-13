if exists (select * from sysobjects where id = object_id(N'[dbo].[frTransferenciaStockProveedor]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[frTransferenciaStockProveedor]
go

/*

sp_col productonumeroserie
select top 10 * from stockitem where prns_id is not null

exec frTransferenciaStockProveedor 3564
select * from stockitem where st_id = 3564 order by stik_id

frTransferenciaStockProveedor 2

*/

create procedure frTransferenciaStockProveedor (

	@@stprov_id	int

)as 

begin

set nocount on

------------------------------------------------------------------------------------------------------------------

declare @@st_id int
select @@st_id = st_id from StockProveedor where stprov_id = @@stprov_id

------------------------------------------------------------------------------------------------------------------
-- Numeros de serie

	declare c_nroseries insensitive cursor for 

		-------------------------------------------------------------------------------------------------------

						------------------------------------------------------------------------------------------------------------------
						-- Nros de serie de No Kits
						
						select 
						
							sti_grupo,
						  prns_codigo
						
						from
						
						  stockItem sti inner join ProductoNumeroSerie prns on sti.prns_id= prns.prns_id
						
						where 
						          sti_ingreso   <> 0 
						      and sti.st_id     =	 @@st_id
						      and sti.pr_id_kit is null
						      and sti.prns_id   is not null
						
						union all
						
						------------------------------------------------------------------------------------------------------------------
						-- Nros de serie de Kits
						
						select 
						
							sti_grupo,
						  prns_codigo
						
						from
						
							stockItem sti inner join ProductoNumeroSerie prns on sti.prns_id  = prns.prns_id
						
						where 
						          sti_ingreso   <> 0 
						      and sti.st_id     =	 @@st_id
						      and sti.pr_id_kit is not null
						      and sti.prns_id   is not null
						
						order by sti_grupo

		-------------------------------------------------------------------------------------------------------

	create table #t_series (sti_grupo 	int, 
                          prns_codigo varchar(7000)
													)

	declare @lst_series varchar(5000)
	set @lst_series = ''

	declare @prns_codigo 			varchar(100) 
	declare @sti_grupo   			int
	declare @last_sti_grupo 	int
	set @last_sti_grupo = 0

	open c_nroseries

	fetch next from c_nroseries into @sti_grupo,@prns_codigo
	while @@fetch_status=0
	begin		

		if @last_sti_grupo <> @sti_grupo begin

			if @last_sti_grupo <> 0 begin

				if @lst_series <> '' set @lst_series = left(@lst_series,len(@lst_series)-1)

				insert into #t_series (sti_grupo, prns_codigo)
											values	(@last_sti_grupo, @lst_series)


			end

			set @last_sti_grupo = @sti_grupo
			set @lst_series = ''		

		end

		set @lst_series = @lst_series + @prns_codigo + ', ' 

		fetch next from c_nroseries into @sti_grupo,@prns_codigo
	end

	close c_nroseries
	deallocate c_nroseries

	if @lst_series <> '' set @lst_series = left(@lst_series,len(@lst_series)-1)

	if @last_sti_grupo <> 0 begin
		insert into #t_series (sti_grupo, prns_codigo)
									values	(@last_sti_grupo, @lst_series)
	end

------------------------------------------------------------------------------------------------------------------
-- No Kits

select 
  s.st_id,
  do.depl_nombre as Origen,
  dfo.depf_dir   as DirOrigen,
  dfo.depf_tel   as TelOrigen,
  dd.depl_nombre as Destino,
  dfd.depf_dir   as DirDestino,
  dfd.depf_tel   as TelDestino,
  doc.doc_nombre,
  st_fecha,
  st_descrip,
  st_nrodoc,
  st_doc_cliente,
  st_numero,
  suc_nombre,
  pr.pr_nombreCompra,
  null              as pr_id_kit,
  sum(sti_ingreso)  as Cantidad, 
  t.prns_codigo     as prns_codigo,
  case 
    when s.doct_id_cliente = 1 or s.doct_id_cliente = 7 then (select doc_nombre 
                                          from FacturaVenta fv inner join Documento doc on fv.doc_id = doc.doc_id
                                          where fv.fv_id = s.id_cliente)

    when s.doct_id_cliente = 2 or s.doct_id_cliente = 8 then (select doc_nombre 
                                          from FacturaCompra fc inner join Documento doc on fc.doc_id = doc.doc_id
                                          where fc.fc_id = s.id_cliente)

    when s.doct_id_cliente = 4                  then (select doc_nombre 
                                          from RemitoCompra rc inner join Documento doc on rc.doc_id = doc.doc_id
                                          where rc.rc_id = s.id_cliente)

    when s.doct_id_cliente = 3                  then (select doc_nombre 
                                          from RemitoVenta rv inner join Documento doc on rv.doc_id = doc.doc_id
                                          where rv.rv_id = s.id_cliente)

    when s.doct_id_cliente = 28                 then (select doc_nombre 
                                          from RecuentoStock rs inner join Documento doc on rs.doc_id = doc.doc_id
                                          where rs.rs_id = s.id_cliente)

    when s.doct_id_cliente = 30                 then (select doc_nombre 
                                          from ParteProdKit ppk inner join Documento doc on ppk.doc_id = doc.doc_id
                                          where ppk.ppk_id = s.id_cliente)
  end as DocGenerador,
  sti.sti_grupo,
  min(sti_orden) as sti_orden,
	stl_codigo,
	stl_nrolote,
  1 as tipo
  
from
  stock s inner join depositoLogico do   on s.depl_id_origen  = do.depl_id
          inner join depositoLogico dd   on s.depl_id_destino = dd.depl_id
          inner join depositoFisico dfo  on dd.depf_id        = dfo.depf_id
          inner join depositoFisico dfd  on do.depf_id        = dfd.depf_id
          inner join sucursal suc        on s.suc_id          = suc.suc_id 
          inner join documento doc       on s.doc_id          = doc.doc_id

          inner join stockItem sti            on s.st_id      = sti.st_id
          inner join Producto pr              on sti.pr_id    = pr.pr_id

          left  join StockLote        stl     on sti.stl_id   = stl.stl_id  

					left  join #t_series t              on sti.sti_grupo = t.sti_grupo

where 
          sti_ingreso   <> 0 
      and s.st_id       =	 @@st_id
      and sti.pr_id_kit is null

group by
  s.st_id,
  do.depl_nombre,
  dfo.depf_dir,
  dfo.depf_tel,
  dd.depl_nombre,
  dfd.depf_dir,
  dfd.depf_tel,
  doc.doc_nombre,
  st_fecha,
  st_descrip,
  st_nrodoc,
  st_doc_cliente,
  st_numero,
  suc.suc_nombre,
  sti.pr_id,
  pr.pr_nombreCompra,
  sti.sti_grupo,
  s.doct_id_cliente,
  s.id_cliente,
	stl_codigo,
	stl_nrolote,
	t.prns_codigo

------------------------------------------------------------------------------------------------------------------
-- Kits

union

select 
  s.st_id,
  do.depl_nombre as Origen,
  dfo.depf_dir   as DirOrigen,
  dfo.depf_tel   as TelOrigen,
  dd.depl_nombre as Destino,
  dfd.depf_dir   as DirDestino,
  dfd.depf_tel   as TelDestino,
  doc.doc_nombre,
  st_fecha,
  st_descrip,
  st_nrodoc,
  st_doc_cliente,
  st_numero,
  suc.suc_nombre,
  prk.pr_nombreCompra,
  sti.pr_id_kit,
  sum(sti_ingreso) / pr_kitItems as Cantidad,
  t.prns_codigo as prns_codigo,
  case 
    when s.doct_id_cliente = 1 or s.doct_id_cliente = 7 then (select doc_nombre 
                                          from FacturaVenta fv inner join Documento doc on fv.doc_id = doc.doc_id
                                          where fv.fv_id = s.id_cliente)

    when s.doct_id_cliente = 2 or s.doct_id_cliente = 8 then (select doc_nombre 
                                          from FacturaCompra fc inner join Documento doc on fc.doc_id = doc.doc_id
                                          where fc.fc_id = s.id_cliente)

    when s.doct_id_cliente = 4                  then (select doc_nombre 
                                          from RemitoCompra rc inner join Documento doc on rc.doc_id = doc.doc_id
                                          where rc.rc_id = s.id_cliente)

    when s.doct_id_cliente = 3                  then (select doc_nombre 
                                          from RemitoVenta rv inner join Documento doc on rv.doc_id = doc.doc_id
                                          where rv.rv_id = s.id_cliente)

    when s.doct_id_cliente = 28                 then (select doc_nombre 
                                          from RecuentoStock rs inner join Documento doc on rs.doc_id = doc.doc_id
                                          where rs.rs_id = s.id_cliente)

    when s.doct_id_cliente = 30                 then (select doc_nombre 
                                          from ParteProdKit ppk inner join Documento doc on ppk.doc_id = doc.doc_id
                                          where ppk.ppk_id = s.id_cliente)
  end as DocGenerador,
  stik_id as sti_grupo,
  min(sti_orden) as sti_orden,
	'' as stl_codigo,
	'' as stl_nrolote,
  1 as tipo

from
  stock s inner join depositoLogico do  on s.depl_id_origen  = do.depl_id
          inner join depositoLogico dd  on s.depl_id_destino = dd.depl_id
          inner join depositoFisico dfo on dd.depf_id        = dfo.depf_id
          inner join depositoFisico dfd on do.depf_id        = dfd.depf_id

          inner join sucursal suc      on s.suc_id      = suc.suc_id
          inner join documento doc     on s.doc_id      = doc.doc_id

          inner join stockItem sti     on s.st_id       = sti.st_id
          inner join Producto prk      on sti.pr_id_kit = prk.pr_id
        	left  join StockLote    stl  on sti.stl_id    = stl.stl_id  

					left  join #t_series t       on sti.sti_grupo = t.sti_grupo


where 
          sti_ingreso   <> 0 
      and s.st_id       =	 @@st_id
      and sti.pr_id_kit is not null

group by

  s.st_id,
  do.depl_nombre,
  dfo.depf_dir,
  dfo.depf_tel,
  dd.depl_nombre,
  dfd.depf_dir,
  dfd.depf_tel,
  doc.doc_nombre,
  st_fecha,
  st_descrip,
  st_nrodoc,
  st_doc_cliente,
  st_numero,
  suc.suc_nombre,
  sti.pr_id_kit,
  stik_id,
  prk.pr_nombreCompra,
  prk.pr_kititems,
  s.doct_id_cliente,
  s.id_cliente,
	t.prns_codigo

end
go


-- /*
-- 
-- drop table #t_series
-- go
-- 
-- declare @@st_id int set @@st_id = 415
-- 
-- 
-- 	declare c_nroseries insensitive cursor for 
-- 
-- 		-------------------------------------------------------------------------------------------------------
-- 
-- 						------------------------------------------------------------------------------------------------------------------
-- 						-- Nros de serie de No Kits
-- 						
-- 						select 
-- 						
-- 							sti_grupo,
-- 						  prns_codigo
-- 						
-- 						from
-- 						
-- 						  stockItem sti inner join ProductoNumeroSerie prns on sti.prns_id= prns.prns_id
-- 						
-- 						where 
-- 						          sti_ingreso   <> 0 
-- 						      and sti.st_id     =	 @@st_id
-- 						      and sti.pr_id_kit is null
-- 						      and sti.prns_id   is not null
-- 						
-- 						union all
-- 						
-- 						------------------------------------------------------------------------------------------------------------------
-- 						-- Nros de serie de Kits
-- 						
-- 						select 
-- 						
-- 							sti_grupo,
-- 						  prns_codigo
-- 						
-- 						from
-- 						
-- 							stockItem sti inner join ProductoNumeroSerie prns on sti.prns_id  = prns.prns_id
-- 						
-- 						where 
-- 						          sti_ingreso   <> 0 
-- 						      and sti.st_id     =	 @@st_id
-- 						      and sti.pr_id_kit is not null
-- 						      and sti.prns_id   is not null
-- 						
-- 						order by sti_grupo
-- 
-- 		-------------------------------------------------------------------------------------------------------
-- 
-- 	create table #t_series (sti_grupo 	int, 
--                           prns_codigo varchar(7000)
-- 													)
-- 
-- 	declare @lst_series varchar(5000)
-- 	set @lst_series = ''
-- 
-- 	declare @prns_codigo varchar(100) 
-- 	declare @sti_grupo   int
-- 
-- 	open c_nroseries
-- 
-- 	fetch next from c_nroseries into @sti_grupo,@prns_codigo
-- 	while @@fetch_status=0
-- 	begin		
-- 		 
-- 		set @lst_series = @lst_series + @prns_codigo + ', ' 
-- 
-- 		fetch next from c_nroseries into @sti_grupo,@prns_codigo
-- 	end
-- 
-- 	close c_nroseries
-- 	deallocate c_nroseries
-- 
-- 	if @lst_series <> '' set @lst_series = left(@lst_series,len(@lst_series)-1)
-- 
-- 
-- select @lst_series
-- 
-- */
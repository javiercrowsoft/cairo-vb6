/*

frRemitoVentaExpreso 3

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[frRemitoVentaExpreso]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[frRemitoVentaExpreso]

-- frRemitoVentaExpreso 2084

go
create procedure frRemitoVentaExpreso (

	@@rv_id			int

)as 

begin

  set nocount on

  -----------------------------------------------------------------------------------------
  -- Numeros de serie
  --
  create table #nroserie(rvi_id int, codigo varchar(5000))
  declare @codigo  varchar(100)
  declare @codigo2 varchar(5000)
  declare @rvi_id int
  declare @last_rvi_id int

  set @last_rvi_id=0

  declare c_nroserie insensitive cursor for
	select 
					  			rvi_id,
									prns_codigo

	from ProductoNumeroSerie prns inner join StockItem sti 						on prns.prns_id   = sti.prns_id
																inner join RemitoVentaItem rvi 			on sti.sti_grupo  = rvi.rvi_id
																inner join RemitoVenta rv          	on rvi.rv_id      = rv.rv_id
                                inner join Producto p               on prns.pr_id     = p.pr_id
	where rvi.rv_id = @@rv_id and sti.st_id = rv.st_id

	group by
					prns.prns_id,
          prns.pr_id,
          pr_nombrecompra,
					prns_codigo,
					prns_descrip,
					prns_fechavto,
	  			rvi_id
	order by
					rvi_id

  open c_nroserie
  fetch next from c_nroserie into @rvi_id, @codigo
  while @@fetch_status=0
  begin
    
    if @rvi_id <> @last_rvi_id begin

      if @last_rvi_id <> 0 begin
        set @codigo2 = substring(@codigo2,1,len(@codigo2)-1)
        insert into #nroserie(rvi_id,codigo)values(@last_rvi_id,@codigo2)
      end

      set @last_rvi_id = @rvi_id
      set @codigo2 = 'ns: '
    end
    set @codigo2 = @codigo2 + @codigo +', '
    fetch next from c_nroserie into @rvi_id, @codigo
  end
  close c_nroserie
  deallocate c_nroserie  

  if @last_rvi_id <> 0 begin
    set @codigo2 = substring(@codigo2,1,len(@codigo2)-1)
    insert into #nroserie(rvi_id,codigo)values(@last_rvi_id,@codigo2)
  end

  -----------------------------------------------------------------------------------------
	select
	       0                                        as rv_id,
				cli_nombre        												as Cliente,
	      rv_nrodoc                                 as [NroRemito],
				rv_fecha                                  as Fecha,
				cli_calle + ' ' +
				cli_callenumero + ' ' +
				cli_piso + ' ' +
				cli_depto + ' (' +
				cli_codpostal + ')'				                as Direccion,
	      cli_localidad                             as Localidad,

				cli_calle + ' ' +
				cli_callenumero + ' ' +
				cli_piso + ' ' +
				cli_depto + ' (' +
				cli_codpostal + ') '+
	      cli_localidad                             as DirCompleta,

	      cli_tel                                   as Telefono,
				cli_cuit																	as cuit,	 			
				cpg_nombre																as CondicionPago,
				suc_nombre          							        as Sucursal,
	 			depl_nombre          							        as [Desposito origen],
	 			rv_descrip                       	        as Descrip,
	 			pr_nombreventa                  	        as Articulo,
				rvi_cantidad                							as Cantidad,
				rvi_precio/2                              as Precio,
				rvi_ivari/2                               as IVA,
				rvi_neto/2                                as Neto,
				rvi_importe/2                  					  as Importe,
				rv_neto/2                     					  as [Neto total],
				rv_total/2                    					  as Total,	
	  		rv_ivari/2                    					  as [Total IVA],
				
					case 
						when cli_catfiscal=1 or cli_catfiscal=11 then 'X'
		        else ''
					end as inscripto,
		
					case cli_catfiscal
						when 6 then 'X'
		        else ''
					end as monotributo,
		
					case cli_catfiscal
						when 4 then 'X'
		        else ''
					end as consumidorFinal,

					case cli_catfiscal
						when 1 then 'Inscripto'
						when 2 then 'Exento'
						when 3 then 'No inscripto'
						when 4 then 'Consumidor Final'
						when 5 then 'Extranjero'
						when 6 then 'Mono Tributo'
						when 7 then 'Extranjero Iva'
						when 8 then 'No responsable'
						when 9 then 'No Responsable exento'
						when 10 then 'No categorizado'
						when 11 then 'Inscripto M'
		        else 'Sin categorizar'
					end as cat_fiscal,

        codigo as nro_serie	

  from RemitoVenta rv inner join RemitoVentaItem rvi on rv.rv_id   = rvi.rv_id
	                    inner join Producto p          on rvi.pr_id  = p.pr_id
	                    inner join Cliente c           on rv.cli_id  = c.cli_id
											inner join Sucursal s          on rv.suc_id  = s.suc_id
	                    inner join Stock st            on rv.st_id   = st.st_id
	                    left  join DepositoLogico d    on st.depl_id_origen = d.depl_id
											left 	join CondicionPago cp		 on rv.cpg_id  = cp.cpg_id
                      left  join #nroserie ns        on rvi.rvi_id = ns.rvi_id

	where rv.rv_id = @@rv_id
end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


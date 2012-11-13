/*---------------------------------------------------------------------
Nombre: Listado de Cuentas agrupado por Carpeta
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[lsCuenta2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[lsCuenta2]

go

/*  

lsCuenta2 '0'

*/

create procedure lsCuenta2 (

	@@cue_id			varchar(255)

)as 

begin
set nocount on

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cue_id       	int

declare @ram_id_cuenta  int

declare @clienteID 			int
declare @clienteIDccosi int

declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cue_id, @cue_id  out, @ram_id_cuenta out

exec sp_GetRptId @clienteID out
exec sp_GetRptId @clienteIDccosi out

create table #lsCuenta2_cuentas (
																				nodo_id int,
																				nodo_2 int,
																				nodo_3 int,
																				nodo_4 int,
																				nodo_5 int,
																				nodo_6 int,
																				nodo_7 int,
																				nodo_8 int,
																				nodo_9 int
																			)

declare @arb_id int

if @ram_id_cuenta <> 0 select @arb_id = arb_id from rama where ram_id = @ram_id_cuenta 

set @arb_id = isnull(@arb_id,0)

if @arb_id = 0	select @arb_id = min(arb_id) from arbol where tbl_id = 17 -- cuenta

declare @arb_nombre varchar(255) 	select @arb_nombre = arb_nombre from arbol where arb_id = @arb_id
declare @n 					int 					set @n = 2
declare @raiz 			int

while exists(select * from rama r
						 where  arb_id = @arb_id
								and not exists (select * from #lsCuenta2_cuentas where nodo_2 = r.ram_id)
								and not exists (select * from #lsCuenta2_cuentas where nodo_3 = r.ram_id)
								and not exists (select * from #lsCuenta2_cuentas where nodo_4 = r.ram_id)
								and not exists (select * from #lsCuenta2_cuentas where nodo_5 = r.ram_id)
								and not exists (select * from #lsCuenta2_cuentas where nodo_6 = r.ram_id)
								and not exists (select * from #lsCuenta2_cuentas where nodo_7 = r.ram_id)
								and not exists (select * from #lsCuenta2_cuentas where nodo_8 = r.ram_id)
								and not exists (select * from #lsCuenta2_cuentas where nodo_9 = r.ram_id)

								and @n <= 9
						)
begin

	if @n = 2 begin

		select @raiz = ram_id from rama where arb_id = @arb_id and ram_id_padre = 0
		insert #lsCuenta2_cuentas (nodo_id, nodo_2) 
		select ram_id, ram_id from rama where ram_id_padre = @raiz

	end else begin if @n = 3 begin

		insert #lsCuenta2_cuentas (nodo_id, nodo_2, nodo_3) 
		select ram_id, nodo_2, ram_id 
		from rama r inner join #lsCuenta2_cuentas n on r.ram_id_padre = n.nodo_2

	end else begin if @n = 4 begin

		insert #lsCuenta2_cuentas (nodo_id, nodo_2, nodo_3, nodo_4) 
		select ram_id, nodo_2, nodo_3, ram_id
		from rama r inner join #lsCuenta2_cuentas n on r.ram_id_padre = n.nodo_3

	end else begin if @n = 5 begin

		insert #lsCuenta2_cuentas (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5) 
		select ram_id, nodo_2, nodo_3, nodo_4, ram_id
		from rama r inner join #lsCuenta2_cuentas n on r.ram_id_padre = n.nodo_4

	end else begin if @n = 6 begin

		insert #lsCuenta2_cuentas (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6) 
		select ram_id, nodo_2, nodo_3, nodo_4, nodo_5, ram_id
		from rama r inner join #lsCuenta2_cuentas n on r.ram_id_padre = n.nodo_5

	end else begin if @n = 7 begin

		insert #lsCuenta2_cuentas (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7) 
		select ram_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, ram_id
		from rama r inner join #lsCuenta2_cuentas n on r.ram_id_padre = n.nodo_6

	end else begin if @n = 8 begin

		insert #lsCuenta2_cuentas (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7, nodo_8) 
		select ram_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7, ram_id
		from rama r inner join #lsCuenta2_cuentas n on r.ram_id_padre = n.nodo_7

	end else begin if @n = 9 begin

		insert #lsCuenta2_cuentas (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7, nodo_8, nodo_9) 
		select ram_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7, nodo_8, ram_id
		from rama r inner join #lsCuenta2_cuentas n on r.ram_id_padre = n.nodo_8

	end
	end
	end
	end
	end
	end
	end
	end

	set @n = @n + 1

end

if @ram_id_cuenta <> 0 begin

--	exec sp_ArbGetGroups @ram_id_cuenta, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_cuenta, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_cuenta, @clienteID 
	end else 
		set @ram_id_cuenta = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

select  
				cue.cue_id,
				@arb_nombre     as Nivel_1,

				nodo_2.ram_nombre		as Nivel_2,
				nodo_3.ram_nombre		as Nivel_3,
				nodo_4.ram_nombre		as Nivel_4,
				nodo_5.ram_nombre		as Nivel_5,
				nodo_6.ram_nombre		as Nivel_6,
				nodo_7.ram_nombre		as Nivel_7,
				nodo_8.ram_nombre		as Nivel_8,
				nodo_9.ram_nombre		as Nivel_9,

				convert(varchar,nodo_2.ram_orden)+'@'+ nodo_2.ram_nombre		as Nivelg_2,
				convert(varchar,nodo_3.ram_orden)+'@'+ nodo_3.ram_nombre		as Nivelg_3,
				convert(varchar,nodo_4.ram_orden)+'@'+ nodo_4.ram_nombre		as Nivelg_4,
				convert(varchar,nodo_5.ram_orden)+'@'+ nodo_5.ram_nombre		as Nivelg_5,
				convert(varchar,nodo_6.ram_orden)+'@'+ nodo_6.ram_nombre		as Nivelg_6,
				convert(varchar,nodo_7.ram_orden)+'@'+ nodo_7.ram_nombre		as Nivelg_7,
				convert(varchar,nodo_8.ram_orden)+'@'+ nodo_8.ram_nombre		as Nivelg_8,
				convert(varchar,nodo_9.ram_orden)+'@'+ nodo_9.ram_nombre		as Nivelg_9,

				cue_nombre								as Cuenta,
				cue_codigo		  					as Codigo,
				cue_identificacionExterna as [Codigo Contable],
				mon_nombre                as Moneda,
				emp_nombre      					as Empresa,
			  cuec_nombre     					as Categoria


from

	cuenta cue inner join CuentaCategoria cuec on cue.cuec_id = cuec.cuec_id

						 left  join empresa emp on cue.emp_id  = emp.emp_id
						 left  join moneda  mon on cue.mon_id  = mon.mon_id

						 left  join hoja h    on     cue.cue_id = h.id 
                                     and h.arb_id = @arb_id

																		 -- Esto descarta la raiz
																		 --
												             and not exists(select * from rama 
                                                    where ram_id = ram_id_padre 
                                                      and arb_id = @arb_id 
                                                      and ram_id = h.ram_id)

															 -- Esto descarta hojas secundarias
															 --
															 and not exists(select * from hoja h2 inner join rama r on h2.ram_id = r.ram_id
																							where h2.arb_id = @arb_id
																								and h2.ram_id < h.ram_id
																								and h2.ram_id <> r.ram_id_padre 
																								and h2.id = h.id)

						 left  join #lsCuenta2_cuentas nodo on h.ram_id = nodo.nodo_id

             left  join rama nodo_2		on nodo.nodo_2 = nodo_2.ram_id
             left  join rama nodo_3		on nodo.nodo_3 = nodo_3.ram_id
             left  join rama nodo_4		on nodo.nodo_4 = nodo_4.ram_id
             left  join rama nodo_5		on nodo.nodo_5 = nodo_5.ram_id
             left  join rama nodo_6		on nodo.nodo_6 = nodo_6.ram_id
             left  join rama nodo_7		on nodo.nodo_7 = nodo_7.ram_id
             left  join rama nodo_8		on nodo.nodo_8 = nodo_8.ram_id
             left  join rama nodo_9		on nodo.nodo_9 = nodo_9.ram_id

where 


/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

			(cue.cue_id 	= @cue_id 	or @cue_id	=0)

-- Arboles

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 17 
                  and  rptarb_hojaid = cue.cue_id
							   ) 
           )
        or 
					 (@ram_id_cuenta = 0)
			 )

order by 
					Nivel_1, 
					Nivelg_2, 
					Nivelg_3, 
					Nivelg_4, 
					Nivelg_5, 
					Nivelg_6, 
					Nivelg_7, 
					Nivelg_8, 
					Nivelg_9, 
					cue_identificacionexterna,
					cue_codigo, 
					Empresa
end

go


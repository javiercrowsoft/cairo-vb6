/*---------------------------------------------------------------------
Nombre: Stock por Artículo Valorizado Agrupado por Rubro
(Método de valorización última Compra  o lista de precios)
(Con valorizacion por Lote de Stock - Algoritmo Despacho de Importacion*)
(* Esto es busco un remito cuyo nrodoc = stl_codigo)
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_SYS_0130]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_SYS_0130]

GO

/*
DC_CSC_SYS_0130 
											1,
											'20061001',
											'0',
											1
				
select * from rama where ram_nombre like '%dvd%'
select pre_id,pre_nombrecompra from prestacion where pre_nombrecompra like '%lumen%'
select * from tabla where tbl_nombrefisico like '%produ%'
*/

create procedure DC_CSC_SYS_0130 (

  @@us_id    int,

	@@pre_id 				varchar(255),
	@@arb_id        int = 0
)as 

set nocount on

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @pre_id int

declare @ram_id_prestacion int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@pre_id, @pre_id out, @ram_id_prestacion out

exec sp_GetRptId @clienteID out

create table #DC_CSC_SYS_0130_prestacion (
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

if @@arb_id = 0	select @@arb_id = min(arb_id) from arbol where tbl_id = 1 -- prestacion

declare @arb_nombre varchar(255) 	select @arb_nombre = arb_nombre from arbol where arb_id = @@arb_id
declare @n 					int 					set @n = 2
declare @raiz 			int

while exists(select * from rama r
						 where  arb_id = @@arb_id
								and not exists (select * from #DC_CSC_SYS_0130_prestacion where nodo_2 = r.ram_id)
								and not exists (select * from #DC_CSC_SYS_0130_prestacion where nodo_3 = r.ram_id)
								and not exists (select * from #DC_CSC_SYS_0130_prestacion where nodo_4 = r.ram_id)
								and not exists (select * from #DC_CSC_SYS_0130_prestacion where nodo_5 = r.ram_id)
								and not exists (select * from #DC_CSC_SYS_0130_prestacion where nodo_6 = r.ram_id)
								and not exists (select * from #DC_CSC_SYS_0130_prestacion where nodo_7 = r.ram_id)
								and not exists (select * from #DC_CSC_SYS_0130_prestacion where nodo_8 = r.ram_id)
								and not exists (select * from #DC_CSC_SYS_0130_prestacion where nodo_9 = r.ram_id)

								and @n <= 9
						)
begin

	if @n = 2 begin

		select @raiz = ram_id from rama where arb_id = @@arb_id and ram_id_padre = 0
		insert #DC_CSC_SYS_0130_prestacion (nodo_id, nodo_2) 
		select ram_id, ram_id from rama where ram_id_padre = @raiz

	end else begin if @n = 3 begin

		insert #DC_CSC_SYS_0130_prestacion (nodo_id, nodo_2, nodo_3) 
		select ram_id, nodo_2, ram_id 
		from rama r inner join #DC_CSC_SYS_0130_prestacion n on r.ram_id_padre = n.nodo_2

	end else begin if @n = 4 begin

		insert #DC_CSC_SYS_0130_prestacion (nodo_id, nodo_2, nodo_3, nodo_4) 
		select ram_id, nodo_2, nodo_3, ram_id
		from rama r inner join #DC_CSC_SYS_0130_prestacion n on r.ram_id_padre = n.nodo_3

	end else begin if @n = 5 begin

		insert #DC_CSC_SYS_0130_prestacion (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5) 
		select ram_id, nodo_2, nodo_3, nodo_4, ram_id
		from rama r inner join #DC_CSC_SYS_0130_prestacion n on r.ram_id_padre = n.nodo_4

	end else begin if @n = 6 begin

		insert #DC_CSC_SYS_0130_prestacion (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6) 
		select ram_id, nodo_2, nodo_3, nodo_4, nodo_5, ram_id
		from rama r inner join #DC_CSC_SYS_0130_prestacion n on r.ram_id_padre = n.nodo_5

	end else begin if @n = 7 begin

		insert #DC_CSC_SYS_0130_prestacion (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7) 
		select ram_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, ram_id
		from rama r inner join #DC_CSC_SYS_0130_prestacion n on r.ram_id_padre = n.nodo_6

	end else begin if @n = 8 begin

		insert #DC_CSC_SYS_0130_prestacion (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7, nodo_8) 
		select ram_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7, ram_id
		from rama r inner join #DC_CSC_SYS_0130_prestacion n on r.ram_id_padre = n.nodo_7

	end else begin if @n = 9 begin

		insert #DC_CSC_SYS_0130_prestacion (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7, nodo_8, nodo_9) 
		select ram_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7, nodo_8, ram_id
		from rama r inner join #DC_CSC_SYS_0130_prestacion n on r.ram_id_padre = n.nodo_8

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

if @ram_id_prestacion <> 0 begin

--	exec sp_ArbGetGroups @ram_id_prestacion, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_prestacion, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_prestacion, @clienteID 
	end else 
		set @ram_id_prestacion = 0
end


/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

select 
				pre_id,

				@arb_nombre     as Nivel_1,
		
				isnull(nodo_2.ram_nombre,'Sin Clasificar')		
														as Nivel_2,
				nodo_3.ram_nombre		as Nivel_3,
				nodo_4.ram_nombre		as Nivel_4,
				nodo_5.ram_nombre		as Nivel_5,
				nodo_6.ram_nombre		as Nivel_6,
				nodo_7.ram_nombre		as Nivel_7,
				nodo_8.ram_nombre		as Nivel_8,
				nodo_9.ram_nombre		as Nivel_9,

				pre_nombre          as Prestacion
		
from

	prestacion pre               

					left join hoja h    on     pre.pre_id = h.id 
					                     and h.arb_id = @@arb_id

															 -- Esto descarta la raiz
															 --
									             and not exists(select * from rama 
                                              where ram_id = ram_id_padre 
                                                and arb_id = @@arb_id 
                                                and ram_id = h.ram_id)

															 -- Esto descarta hojas secundarias
															 --
															 and not exists(select * from hoja h2 inner join rama r on h2.ram_id = r.ram_id
																							where h2.arb_id = @@arb_id
																								and h2.ram_id < h.ram_id
																								and h2.ram_id <> r.ram_id_padre 
																								and h2.id = h.id)
					
					left  join #DC_CSC_SYS_0130_prestacion nodo on h.ram_id = nodo.nodo_id
					
					left  join rama nodo_2		on nodo.nodo_2 = nodo_2.ram_id
					left  join rama nodo_3		on nodo.nodo_3 = nodo_3.ram_id
					left  join rama nodo_4		on nodo.nodo_4 = nodo_4.ram_id
					left  join rama nodo_5		on nodo.nodo_5 = nodo_5.ram_id
					left  join rama nodo_6		on nodo.nodo_6 = nodo_6.ram_id
					left  join rama nodo_7		on nodo.nodo_7 = nodo_7.ram_id
					left  join rama nodo_8		on nodo.nodo_8 = nodo_8.ram_id
					left  join rama nodo_9		on nodo.nodo_9 = nodo_9.ram_id


where

   (pre_id = @pre_id or @pre_id=0) 

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1
                  and  rptarb_hojaid = pre_id
							   ) 
           )
        or 
					 (@ram_id_prestacion = 0)
			 )

order by 

				Nivel_2,
				Nivel_3,
				Nivel_4,
				Nivel_5,
				Nivel_6,
				Nivel_7,
				Nivel_8,
				Nivel_9,

				pre_nombre

GO
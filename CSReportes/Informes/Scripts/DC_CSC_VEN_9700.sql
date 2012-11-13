/*

[DC_CSC_VEN_9700] 79,'N82953',3.000000,'Insumos para',-1,-1,0,-1,0,20.000000,30.000000,10.000000,0,0,'',0,'',0,'',0,'',0,'',0,'',0,'',0,'',0,'',0,''


*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_9700]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_9700]

go
create procedure DC_CSC_VEN_9700 (

@@us_id         			int,
@@pr_id								varchar(255),
@@Campo								smallint,
@@Prefijo							varchar(255),
@@Codigo							smallint,
@@Alias								smallint,
@@MarcaNombre					smallint,
@@MarcaCodigo					smallint,
@@Rubro								smallint,
@@OrdenCodigo					smallint,
@@OrdenAlias					smallint,
@@OrdenMarca					smallint,
@@OrdenRubro					smallint,
@@Codigo1							smallint,
@@SalvoCodigo1				varchar(255),
@@Codigo2							smallint,
@@SalvoCodigo2				varchar(255),
@@Codigo3							smallint,
@@SalvoCodigo3				varchar(255),
@@Codigo4							smallint,
@@SalvoCodigo4				varchar(255),
@@Codigo5							smallint,
@@SalvoCodigo5				varchar(255),
@@Codigo6							smallint,
@@SalvoCodigo6				varchar(255),
@@Codigo7							smallint,
@@SalvoCodigo7				varchar(255),
@@Codigo8							smallint,
@@SalvoCodigo8				varchar(255),
@@Codigo9							smallint,
@@SalvoCodigo9				varchar(255),
@@Codigo10						smallint,
@@SalvoCodigo10				varchar(255)

)as 
begin

--select 1/0 return

	declare @bNoSelect int

	set @bNoSelect = 0

	if @@us_id < 0 begin

		set @@us_id = @@us_id *-1

		set @bNoSelect = 1

	end

  set nocount on

	if @@Prefijo <> '' set @@Prefijo = @@Prefijo + ' '

--/////////////////////////////////////////////////////////////////////////////////
-- Arboles
--/////////////////////////////////////////////////////////////////////////////////

	declare @timeCode datetime
	set @timeCode = getdate()

	create table #t_nombre_producto (orden smallint, valor varchar(255))

	create table #t_salvo01 (valor varchar(255))
	create table #t_salvo02 (valor varchar(255))
	create table #t_salvo03 (valor varchar(255))
	create table #t_salvo04 (valor varchar(255))
	create table #t_salvo05 (valor varchar(255))
	create table #t_salvo06 (valor varchar(255))
	create table #t_salvo07 (valor varchar(255))
	create table #t_salvo08 (valor varchar(255))
	create table #t_salvo09 (valor varchar(255))
	create table #t_salvo10 (valor varchar(255))

--// 1
	exec sp_strStringToTable @timeCode, @@SalvoCodigo1, '|'

	insert into #t_salvo01
		select tmpstr2tbl_campo 
		from TmpStringToTable
		where tmpstr2tbl_id = @timeCode
	delete TmpStringToTable	where tmpstr2tbl_id = @timeCode

--// 2
	exec sp_strStringToTable @timeCode, @@SalvoCodigo2, '|'

	insert into #t_salvo02
		select tmpstr2tbl_campo 
		from TmpStringToTable
		where tmpstr2tbl_id = @timeCode
	delete TmpStringToTable	where tmpstr2tbl_id = @timeCode

--// 3
	exec sp_strStringToTable @timeCode, @@SalvoCodigo3, '|'

	insert into #t_salvo03
		select tmpstr2tbl_campo 
		from TmpStringToTable
		where tmpstr2tbl_id = @timeCode
	delete TmpStringToTable	where tmpstr2tbl_id = @timeCode

--// 4
	exec sp_strStringToTable @timeCode, @@SalvoCodigo4, '|'

	insert into #t_salvo04
		select tmpstr2tbl_campo 
		from TmpStringToTable
		where tmpstr2tbl_id = @timeCode
	delete TmpStringToTable	where tmpstr2tbl_id = @timeCode

--// 5
	exec sp_strStringToTable @timeCode, @@SalvoCodigo5, '|'

	insert into #t_salvo05
		select tmpstr2tbl_campo 
		from TmpStringToTable
		where tmpstr2tbl_id = @timeCode
	delete TmpStringToTable	where tmpstr2tbl_id = @timeCode

--// 6
	exec sp_strStringToTable @timeCode, @@SalvoCodigo6, '|'

	insert into #t_salvo06
		select tmpstr2tbl_campo 
		from TmpStringToTable
		where tmpstr2tbl_id = @timeCode
	delete TmpStringToTable	where tmpstr2tbl_id = @timeCode

--// 7
	exec sp_strStringToTable @timeCode, @@SalvoCodigo7, '|'

	insert into #t_salvo07
		select tmpstr2tbl_campo 
		from TmpStringToTable
		where tmpstr2tbl_id = @timeCode
	delete TmpStringToTable	where tmpstr2tbl_id = @timeCode

--// 8
	exec sp_strStringToTable @timeCode, @@SalvoCodigo8, '|'

	insert into #t_salvo08
		select tmpstr2tbl_campo 
		from TmpStringToTable
		where tmpstr2tbl_id = @timeCode
	delete TmpStringToTable	where tmpstr2tbl_id = @timeCode

--// 9
	exec sp_strStringToTable @timeCode, @@SalvoCodigo9, '|'

	insert into #t_salvo09
		select tmpstr2tbl_campo 
		from TmpStringToTable
		where tmpstr2tbl_id = @timeCode
	delete TmpStringToTable	where tmpstr2tbl_id = @timeCode

--// 10
	exec sp_strStringToTable @timeCode, @@SalvoCodigo10, '|'

	insert into #t_salvo10
		select tmpstr2tbl_campo 
		from TmpStringToTable
		where tmpstr2tbl_id = @timeCode
	delete TmpStringToTable	where tmpstr2tbl_id = @timeCode

  declare @pr_id int

	declare @pr_id_param 		int
	declare @ram_id_Producto int
	
	declare @clienteID 	int
	declare @IsRaiz 		tinyint

	exec sp_ArbConvertId @@pr_id, @pr_id_param out, @ram_id_Producto out
	
	exec sp_GetRptId @clienteID out

	if @ram_id_Producto <> 0 begin
	
	--	exec sp_ArbGetGroups @ram_id_Producto, @clienteID, @@us_id
	
		exec sp_ArbIsRaiz @ram_id_Producto, @IsRaiz out
	  if @IsRaiz = 0 begin
			exec sp_ArbGetAllHojas @ram_id_Producto, @clienteID 
		end else 
			set @ram_id_Producto = 0
	end

	declare @nombre  varchar(255)
	declare @valor   varchar(255)
	declare @rubt01  varchar(255)
	declare @rubt02  varchar(255)
	declare @rubt03  varchar(255)
	declare @rubt04  varchar(255)
	declare @rubt05  varchar(255)
	declare @rubt06  varchar(255)
	declare @rubt07  varchar(255)
	declare @rubt08  varchar(255)
	declare @rubt09  varchar(255)
	declare @rubt10  varchar(255)

	declare @Codigo				varchar(255)
	declare @Alias				varchar(255)
	declare @MarcaNombre	varchar(255)
	declare @MarcaCodigo	varchar(255)
	declare @Rubro				varchar(255)
	
  declare c_items insensitive cursor for 
		select pr_id from Producto 
			where (			
								      (pr_id = @pr_id_param or @pr_id_param=0)
								
								-- Arboles
								and   (
													(exists(select rptarb_hojaid 
								                  from rptArbolRamaHoja 
								                  where
								                       rptarb_cliente = @clienteID
								                  and  tbl_id = 30 
								                  and  rptarb_hojaid = pr_id
															   ) 
								           )
								        or 
													 (@ram_id_Producto = 0)
											 )
						)

  open c_items

  fetch next from c_items into @pr_id
  while @@fetch_status=0 
  begin

		set @nombre = ''
		delete #t_nombre_producto

		select 	@Codigo 			= pr_codigo,
						@Alias				= pr_aliasweb,
						@MarcaNombre	= isnull(marc_nombre,''),
						@MarcaCodigo	= isnull(marc_codigo,''),
						@Rubro				= isnull(rub_nombre,''),

						@rubt01       = isnull(rubti01.rubti_nombre,''),
						@rubt02       = isnull(rubti02.rubti_nombre,''),
						@rubt03       = isnull(rubti03.rubti_nombre,''),
						@rubt04       = isnull(rubti04.rubti_nombre,''),
						@rubt05       = isnull(rubti05.rubti_nombre,''),
						@rubt06       = isnull(rubti06.rubti_nombre,''),
						@rubt07       = isnull(rubti07.rubti_nombre,''),
						@rubt08       = isnull(rubti08.rubti_nombre,''),
						@rubt09       = isnull(rubti09.rubti_nombre,''),
						@rubt10       = isnull(rubti10.rubti_nombre,'')

		from Producto pr left join Marca marc on pr.marc_id = marc.marc_id
										 left join Rubro rub  on pr.rub_id  = rub.rub_id

										 left join RubroTablaItem rubti01  on pr.rubti_id1  = rubti01.rubti_id
										 left join RubroTablaItem rubti02  on pr.rubti_id2  = rubti02.rubti_id
										 left join RubroTablaItem rubti03  on pr.rubti_id3  = rubti03.rubti_id
										 left join RubroTablaItem rubti04  on pr.rubti_id4  = rubti04.rubti_id
										 left join RubroTablaItem rubti05  on pr.rubti_id5  = rubti05.rubti_id
										 left join RubroTablaItem rubti06  on pr.rubti_id6  = rubti06.rubti_id
										 left join RubroTablaItem rubti07  on pr.rubti_id7  = rubti07.rubti_id
										 left join RubroTablaItem rubti08  on pr.rubti_id8  = rubti08.rubti_id
										 left join RubroTablaItem rubti09  on pr.rubti_id9  = rubti09.rubti_id
										 left join RubroTablaItem rubti10  on pr.rubti_id10 = rubti10.rubti_id
		where pr_id = @pr_id

		-- insertamos en la tabla los atributos
		if @@Codigo <> 0 begin
			insert into #t_nombre_producto (orden, valor)
															values (@@OrdenCodigo, @codigo)
		end

		if @@Alias <> 0 begin
			insert into #t_nombre_producto (orden, valor)
															values (@@OrdenAlias, @alias)
		end

		if @@MarcaNombre <> 0 begin
			insert into #t_nombre_producto (orden, valor)
															values (@@OrdenMarca, @MarcaNombre)
		end

		if @@MarcaCodigo <> 0 begin
			insert into #t_nombre_producto (orden, valor)
															values (@@OrdenMarca, @MarcaCodigo)
		end

		if @@Rubro <> 0 begin
			insert into #t_nombre_producto (orden, valor)
															values (@@OrdenRubro, @Rubro)
		end

		if @@Codigo1 <> 0 begin
			if not exists(select * from #t_salvo01 where valor = @rubt01)
			insert into #t_nombre_producto (orden, valor)
															values (@@Codigo1, @rubt01)
		end

		if @@Codigo2 <> 0 begin
			if not exists(select * from #t_salvo02 where valor = @rubt02)
			insert into #t_nombre_producto (orden, valor)
															values (@@Codigo2, @rubt02)
		end

		if @@Codigo3 <> 0 begin
			if not exists(select * from #t_salvo03 where valor = @rubt03)
			insert into #t_nombre_producto (orden, valor)
															values (@@Codigo3, @rubt03)
		end

		if @@Codigo4 <> 0 begin
			if not exists(select * from #t_salvo04 where valor = @rubt04)
			insert into #t_nombre_producto (orden, valor)
															values (@@Codigo4, @rubt04)
		end

		if @@Codigo5 <> 0 begin
			if not exists(select * from #t_salvo05 where valor = @rubt05)
			insert into #t_nombre_producto (orden, valor)
															values (@@Codigo5, @rubt05)
		end

		if @@Codigo6 <> 0 begin
			if not exists(select * from #t_salvo06 where valor = @rubt06)
			insert into #t_nombre_producto (orden, valor)
															values (@@Codigo6, @rubt06)
		end

		if @@Codigo7 <> 0 begin
			if not exists(select * from #t_salvo07 where valor = @rubt07)
			insert into #t_nombre_producto (orden, valor)
															values (@@Codigo7, @rubt07)
		end

		if @@Codigo8 <> 0 begin
			if not exists(select * from #t_salvo08 where valor = @rubt08)
			insert into #t_nombre_producto (orden, valor)
															values (@@Codigo8, @rubt08)
		end

		if @@Codigo9 <> 0 begin
			if not exists(select * from #t_salvo09 where valor = @rubt09)
			insert into #t_nombre_producto (orden, valor)
															values (@@Codigo9, @rubt09)
		end

		if @@Codigo10 <> 0 begin
			if not exists(select * from #t_salvo10 where valor = @rubt10)
			insert into #t_nombre_producto (orden, valor)
															values (@@Codigo10, @rubt10)
		end

		set @nombre = @@Prefijo + @nombre 

		declare c_pr_nombre insensitive cursor for select valor from #t_nombre_producto order by orden
		open c_pr_nombre
		fetch next from c_pr_nombre into @valor
		while @@fetch_status=0
		begin

			if @valor <> '' set @nombre = @nombre + ' ' + @valor

			fetch next from c_pr_nombre into @valor
		end

		close c_pr_nombre
		deallocate c_pr_nombre

		set @nombre = rtrim(ltrim(@nombre))

		if @@campo = 1 
			update producto set pr_nombrecompra  = @nombre where pr_id = @pr_id
		if @@campo = 2
			update producto set pr_nombreventa   = @nombre where pr_id = @pr_id
		if @@campo = 3
			update producto set pr_nombrefactura = @nombre where pr_id = @pr_id
		if @@campo = 4
			update producto set pr_nombreweb     = @nombre where pr_id = @pr_id

		declare @prwi_id int

		if @@campo = 5 begin
			select @prwi_id = max(prwi_id) from ProductoWebImage where pr_id = @pr_id
			if @prwi_id is null begin

				exec sp_dbgetnewid 'ProductoWebImage','prwi_id',@prwi_id out, 0
				insert into ProductoWebImage (prwi_id, pr_id, prwi_tipo, prwi_archivo)
													values(@prwi_id, @pr_id, 1, '')
			end
			update productowebimage set prwi_archivo = @nombre + '.jpg' where prwi_id = @prwi_id
		end

		if @@campo = 6 begin

			select @prwi_id = max(prwi_id) from ProductoWebImage where pr_id = @pr_id
			if @prwi_id is null begin

				exec sp_dbgetnewid 'ProductoWebImage','prwi_id',@prwi_id out, 0
				insert into ProductoWebImage (prwi_id, pr_id, prwi_tipo, prwi_archivo)
													values(@prwi_id, @pr_id, 1, '')
			end
			update productowebimage set prwi_alt = @nombre where prwi_id = @prwi_id

		end

    fetch next from c_items into @pr_id
  end

  close c_items
  deallocate c_items

	if @bNoSelect = 0 begin
	
		select  pr.pr_id,
						pr_codigo      		as Codigo,
						pr_nombreweb 	    as [Nombre Web],
						pr_nombrecompra 	as [Nombre Compra],
						pr_nombreventa  	as [Nombre Venta],
						pr_nombrefactura 	as [Nombre Factura],
						' '								as aux
						
		from Producto pr
		where pr_id in (
										select pr_id from Producto 
											where (			
																      (pr_id = @pr_id_param or @pr_id_param=0)
																
																-- Arboles
																and   (
																					(exists(select rptarb_hojaid 
																                  from rptArbolRamaHoja 
																                  where
																                       rptarb_cliente = @clienteID
																                  and  tbl_id = 30 
																                  and  rptarb_hojaid = pr_id
																							   ) 
																           )
																        or 
																					 (@ram_id_Producto = 0)
																			 )
														)
								)
	
	end

end
go
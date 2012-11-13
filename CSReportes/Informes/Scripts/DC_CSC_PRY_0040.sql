-- TODO:EMPRESA
/*---------------------------------------------------------------------
Nombre: Lista de tareas entre fechas
---------------------------------------------------------------------*/
/*

dc_csc_pry_0040 2,'20070928','20070928',2

select * from usuario
*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_PRY_0040]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_PRY_0040]

go
create procedure DC_CSC_PRY_0040 (

  @@us_id    int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime,

	@@us_id_agenda				varchar(255)

)as 

begin

set nocount on

/*- ///////////////////////////////////////////////////////////////////////

SEGURIDAD SOBRE USUARIOS EXTERNOS

/////////////////////////////////////////////////////////////////////// */

declare @us_empresaEx tinyint
select @us_empresaEx = us_empresaEx from usuario where us_id = @@us_id

/* -///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @us_id_agenda int

declare @ram_id_usuarioAgenda int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@us_id_agenda, @us_id_agenda out, @ram_id_usuarioAgenda out

exec sp_GetRptId @clienteID out

if @ram_id_usuarioAgenda <> 0 begin

	-- exec sp_ArbGetGroups @ram_id_usuarioAgenda, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_usuarioAgenda, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_usuarioAgenda, @clienteID 
	end else 
		set @ram_id_usuarioAgenda = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */




--////////////////////////////////////////////////////////////////////////////////////////////////////////
--
--
--
--	ARMADO DEL CALENDARIO
--
--
--
--////////////////////////////////////////////////////////////////////////////////////////////////////////

	declare @ptd_id					int
	declare	@numero					int
	declare	@titulo					varchar(7000)
	declare	@descrip				varchar(7000)
	declare	@fechaini				datetime
	declare	@fechafin				datetime
	declare @horaini				datetime
	declare @horafin        datetime
	declare	@us_id   				int
	declare @ptd_cumplida   smallint

declare @last_us_id int
declare @last_fini datetime

declare @fecha1 	datetime
declare @descrip1 varchar(7000)
declare @fecha2 	datetime
declare @descrip2 varchar(7000)
declare @fecha3 	datetime
declare @descrip3 varchar(7000)
declare @fecha4 	datetime
declare @descrip4 varchar(7000)
declare @fecha5 	datetime
declare @descrip5 varchar(7000)
declare @fecha6 	datetime
declare @descrip6 varchar(7000)
declare @fecha7 	datetime
declare @descrip7	varchar(7000)

declare @tarea  varchar(7000)
declare @desde  varchar(10)
declare @hasta  varchar(10)
declare @sep    varchar(10)
declare @font_b varchar(50)
declare @font_e varchar(10)

declare @wd int
declare @bFirstRecord tinyint
set @bFirstRecord = 1


declare @id int
set @id = 0

-- Esto define que el primer dia de la semana es el lunes
--
set datefirst 1

	-- Las fechas desde y hasta deben ser un lunes y un domingo respectivamente
	--
	set @wd = datepart(dw, @@Fini)			
	set @@Fini = dateadd(d,1-@wd,@@Fini)

	set @wd = datepart(dw, @@Ffin)			
	set @@Ffin = dateadd(d,7-@wd,@@Ffin)

	-- select @@Fini, @@Ffin
	
	create table #t_dc_csc_pry_0040_1 (us_id int null,
																		id int, 
																		fecha1 datetime not null, 
																		descrip1 varchar(7000) not null)

	create table #t_dc_csc_pry_0040_2 (id int,
																		fecha2 datetime not null, 
																		descrip2 varchar(7000) not null)

	create table #t_dc_csc_pry_0040_3 (id int,
																		fecha3 datetime not null, 
																		descrip3 varchar(7000) not null)

	create table #t_dc_csc_pry_0040_4 (id int,
																		fecha4 datetime not null, 
																		descrip4 varchar(7000) not null)

	create table #t_dc_csc_pry_0040_5 (id int,
																		fecha5 datetime not null, 
																		descrip5 varchar(7000) not null)

	create table #t_dc_csc_pry_0040_6 (id int,
																		fecha6 datetime not null, 
																		descrip6 varchar(7000) not null)

	create table #t_dc_csc_pry_0040_7 (id int,
																		fecha7 datetime not null, 
																		descrip7 varchar(7000) not null)

	
	declare c_ptd insensitive cursor for 
	
			select 
					ptd_id,
					ptd_numero,
					ptd_titulo,
					ptd_descrip,
					ptd_fechaini,
					ptd_fechafin,
			    ptd_horaini,
			    ptd_horafin,
					us_id_responsable,
					ptd_cumplida
			
			from 
			
					partediario ptd
			
			where 
			
					-- Filtros
				  ptd_fechaini between @@Fini and @@Ffin
			
			-- Arboles
			and   (ptd.us_id_responsable = @us_id_agenda or @us_id_agenda=0)
			and   (		 (exists(select rptarb_hojaid 
												 from rptArbolRamaHoja 
												 where rptarb_cliente = @clienteID 
													and  tbl_id = 3 
													and  rptarb_hojaid = ptd.us_id_responsable)) 
							or (@ram_id_usuarioAgenda = 0))

			order by ptd_fechaini, ptd_horaini

	open c_ptd
	
	fetch next from c_ptd into  @ptd_id,
															@numero,
															@titulo,
															@descrip,
															@fechaini,
															@fechafin,
															@horaini,
															@horafin,
															@us_id,
															@ptd_cumplida
	
	while @@fetch_status=0
	begin

		if isnull(@last_us_id,0) <> isnull(@us_id,0) begin
			set @last_fini  = '18000101'
			set @last_us_id = @us_id
		end

		-- Si nos pasamos de la semana
		--
		if datediff(d,@last_fini,@fechaini)>6 begin

			if @bFirstRecord <> 0 begin

				set @bFirstRecord = 0

			end else begin

				set @id = @id +1

				-- Inserto la semana
				--
				insert into #t_dc_csc_pry_0040_1 ( us_id,id,fecha1,descrip1) values (@last_us_id,@id,@fecha1,@descrip1)
				insert into #t_dc_csc_pry_0040_2 ( id,fecha2,descrip2) values (@id,@fecha2,@descrip2) 
				insert into #t_dc_csc_pry_0040_3 ( id,fecha3,descrip3) values (@id,@fecha3,@descrip3)
				insert into #t_dc_csc_pry_0040_4 ( id,fecha4,descrip4) values (@id,@fecha4,@descrip4)
				insert into #t_dc_csc_pry_0040_5 ( id,fecha5,descrip5) values (@id,@fecha5,@descrip5)
				insert into #t_dc_csc_pry_0040_6 ( id,fecha6,descrip6) values (@id,@fecha6,@descrip6)
				insert into #t_dc_csc_pry_0040_7 ( id,fecha7,descrip7) values (@id,@fecha7,@descrip7)
			end

			-- Obtenemos el lunes de la fecha en la que estamos
			--
			set @wd = datepart(dw, @fechaini)			

			set @fecha1 = dateadd(d,1-@wd,@fechaini)
			set @last_fini  = @fecha1 

			set @descrip1		= ''
			set @fecha2 		= dateadd(d,1,@fecha1)
			set @descrip2		= '' 
			set @fecha3 		= dateadd(d,2,@fecha1)
			set @descrip3		= ''
			set @fecha4 		= dateadd(d,3,@fecha1)
			set @descrip4		= ''
			set @fecha5 		= dateadd(d,4,@fecha1)
			set @descrip5		= ''
			set @fecha6 		= dateadd(d,5,@fecha1)
			set @descrip6		= ''
			set @fecha7 		= dateadd(d,6,@fecha1)
			set @descrip7		= ''

		end

		set @desde = case when @horaini <> '18001230' 
												and convert(varchar(5), @horaini,14) <> '00:00' 
											then 
														convert(varchar(5), @horaini,14)
											else 	'' 
									end

		set @hasta = case when @horafin <> '18001230' 
												and convert(varchar(5), @horafin,14) <> '00:00'
											then 
														convert(varchar(5), @horafin,14)
											else 	'' 
									end

		if @desde <> '' and @hasta <> ''  set @sep = ' - '
		else								 							set @sep = ''

		set @tarea = @desde + @sep + @hasta

		if @tarea <> '' set @tarea = @tarea + '<br>'

		set @tarea = @tarea
								+ case when @titulo <> '' then substring(@titulo,1,255) else substring(@descrip,1,255) end

		if dateadd(d,1,@fechaini) < getdate() and @ptd_cumplida <> 3 begin

			set @font_b = '<font color="red">' 
			set @font_e = '</font>' 

		end else begin

			set @font_b = ''
			set @font_e = ''

		end

		set @tarea = '<a href="JavaScript:OnEditClicked(' + convert(varchar,@ptd_id) + ')">' + @font_b + @tarea + @font_e + '</a><hr size="1">'


		if 			@fechaini = @fecha1 set @descrip1 = @descrip1 + @tarea + char(10)+ char(10)
		else if	@fechaini = @fecha2 set @descrip2 = @descrip2 + @tarea + char(10)+ char(10)
		else if	@fechaini = @fecha3 set @descrip3 = @descrip3 + @tarea + char(10)+ char(10)
		else if	@fechaini = @fecha4 set @descrip4 = @descrip4 + @tarea + char(10)+ char(10)
		else if	@fechaini = @fecha5 set @descrip5 = @descrip5 + @tarea + char(10)+ char(10)
		else if	@fechaini = @fecha6 set @descrip6 = @descrip6 + @tarea + char(10)+ char(10)
		else if	@fechaini = @fecha7 set @descrip7 = @descrip7 + @tarea + char(10)+ char(10)
	
		fetch next from c_ptd into 	@ptd_id,
																@numero,
																@titulo,
																@descrip,
																@fechaini,
																@fechafin,
																@horaini,
																@horafin,
																@us_id,
																@ptd_cumplida
	end
	
	close c_ptd
	deallocate c_ptd

	-- Solo si encontro algo
	--
	if @bFirstRecord = 0 begin

		set @id = @id +1

		-- Inserto la semana
		--
		insert into #t_dc_csc_pry_0040_1 ( us_id,id,fecha1,descrip1) values (@last_us_id,@id,@fecha1,@descrip1)
		insert into #t_dc_csc_pry_0040_2 ( id,fecha2,descrip2) values (@id,@fecha2,@descrip2) 
		insert into #t_dc_csc_pry_0040_3 ( id,fecha3,descrip3) values (@id,@fecha3,@descrip3)
		insert into #t_dc_csc_pry_0040_4 ( id,fecha4,descrip4) values (@id,@fecha4,@descrip4)
		insert into #t_dc_csc_pry_0040_5 ( id,fecha5,descrip5) values (@id,@fecha5,@descrip5)
		insert into #t_dc_csc_pry_0040_6 ( id,fecha6,descrip6) values (@id,@fecha6,@descrip6)
		insert into #t_dc_csc_pry_0040_7 ( id,fecha7,descrip7) values (@id,@fecha7,@descrip7)

	end

	-- Si esta vacio devolvemos una semana vacia
	--
	if not exists(select * from #t_dc_csc_pry_0040_1) begin

		-- Obtenemos el lunes de la fecha en la que estamos
		--
		set @wd = datepart(dw, @@Fini)			

		set @fecha1 = dateadd(d,1-@wd,@@Fini)
		set @last_fini  = @fecha1 

		set @descrip1		= ''
		set @fecha2 		= dateadd(d,1,@fecha1)
		set @descrip2		= '' 
		set @fecha3 		= dateadd(d,2,@fecha1)
		set @descrip3		= ''
		set @fecha4 		= dateadd(d,3,@fecha1)
		set @descrip4		= ''
		set @fecha5 		= dateadd(d,4,@fecha1)
		set @descrip5		= ''
		set @fecha6 		= dateadd(d,5,@fecha1)
		set @descrip6		= ''
		set @fecha7 		= dateadd(d,6,@fecha1)
		set @descrip7		= ''

		-- Inserto la semana
		--
		insert into #t_dc_csc_pry_0040_1 ( us_id,id,fecha1,descrip1) values (@last_us_id,@id,@fecha1,@descrip1)
		insert into #t_dc_csc_pry_0040_2 ( id,fecha2,descrip2) values (@id,@fecha2,@descrip2) 
		insert into #t_dc_csc_pry_0040_3 ( id,fecha3,descrip3) values (@id,@fecha3,@descrip3)
		insert into #t_dc_csc_pry_0040_4 ( id,fecha4,descrip4) values (@id,@fecha4,@descrip4)
		insert into #t_dc_csc_pry_0040_5 ( id,fecha5,descrip5) values (@id,@fecha5,@descrip5)
		insert into #t_dc_csc_pry_0040_6 ( id,fecha6,descrip6) values (@id,@fecha6,@descrip6)
		insert into #t_dc_csc_pry_0040_7 ( id,fecha7,descrip7) values (@id,@fecha7,@descrip7)

	end

--////////////////////////////////////////////////////////////////////////////////////////////////////////
--
--
--
--	SELECT FINAL
--
--
--
--////////////////////////////////////////////////////////////////////////////////////////////////////////

	select 

			t1.us_id,
			fecha1, 
			descrip1,
			fecha2,
			descrip2,
			fecha3,
			descrip3,
			fecha4,
			descrip4,
			fecha5,
			descrip5,
			fecha6,
			descrip6,
			fecha7,
			descrip7,

			us_nombre         as Usuario,
			prs_apellido 
			+ ' ' 
			+ prs_nombre      as Persona
	
	from #t_dc_csc_pry_0040_1 t1 	inner join #t_dc_csc_pry_0040_2 t2 on t1.id = t2.id
																inner join #t_dc_csc_pry_0040_3 t3 on t1.id = t3.id
																inner join #t_dc_csc_pry_0040_4 t4 on t1.id = t4.id
																inner join #t_dc_csc_pry_0040_5 t5 on t1.id = t5.id
																inner join #t_dc_csc_pry_0040_6 t6 on t1.id = t6.id
																inner join #t_dc_csc_pry_0040_7 t7 on t1.id = t7.id


														 	left join usuario us on t1.us_id = us.us_id
															left join persona prs on us.prs_id = prs.prs_id
	
	

end
go
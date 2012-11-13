if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocGetFecha2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocGetFecha2]

go

/*
select * from clearing
select cle_id, * from cheque

declare @fecha datetime
exec sp_DocGetFecha2 '20061208',@fecha out, 0, null
select @fecha

*/

create procedure sp_DocGetFecha2 (
	@@fecha				datetime,
  @@fecha2    	datetime out,
	@@bBanco      tinyint,
	@@cle_id			int
)
as

begin

  set nocount on

	declare @fecha2 			datetime
	declare @oldDateFirst int
	declare @dayweek      tinyint

	-- Me guardo el DATEFIRST original
	--
	set @oldDateFirst = @@DATEFIRST 
	set datefirst 1 

	-- Obtengo el numero de dia de la 
	-- fecha que me pasaron
	--	
	set @dayweek = datepart(dw,@@fecha)
	set datefirst @oldDateFirst

	set @fecha2 = case @dayweek 
									when 6 /*sabado*/  then dateadd(d,2,@@fecha)
									when 7 /*domingo*/ then dateadd(d,1,@@fecha)
									else                    @@fecha
								end

	-- Si es para un cheque
	--	
	if @@bBanco <> 0 begin

		-- Si la fecha es un feriado
		--
		while exists(select fei.fe_id 
								 from FeriadoItem fei inner join Feriado fe 
														on  fei.fe_id = fe.fe_id 
														and fe_banco <> 0
														and fe_local = 0
								 where fei_fecha = @fecha2 
								)
			set @fecha2=dateadd(d,1,@fecha2)

		-- Obtengo el dia despues de moverme por feriados
		--
		set datefirst 1 
		set @dayweek 	= datepart(dw,@fecha2)
		set datefirst @oldDateFirst

		-- Si he caido en un fin de semana
		--
		while @dayweek in (6,7) begin

			-- Si estoy en un fin de semana
			--
			set @fecha2 = case @dayweek 
											when 6 /*sabado*/  then dateadd(d,2,@fecha2)
											when 7 /*domingo*/ then dateadd(d,1,@fecha2)
											else                    @fecha2
										end
	
			-- Compruebo nuevamente que no sea un feriado
			--
			while exists(select fei.fe_id 
									 from FeriadoItem fei inner join Feriado fe 
															on  fei.fe_id = fe.fe_id 
															and fe_banco <> 0
															and fe_local = 0
									 where fei_fecha = @fecha2 
									)
				set @fecha2=dateadd(d,1,@fecha2)

				-- Obtengo el dia despues moverme por feriados
				--
				set datefirst 1 
				set @dayweek 	= datepart(dw,@fecha2)
				set datefirst @oldDateFirst
		end

		-- Dias a desplazarme por clearing
		--
		declare @dias         tinyint
		declare @n            tinyint
		
		-- Obtengo el clearing
		--
		select @dias = cle_dias from Clearing where cle_id = @@cle_id
		set @n = 1

		-- Voy consumiendo los dias del clearing
		--
		while @n <= @dias begin

			-- Agrego un dia
			--
			set @fecha2=dateadd(d,1,@fecha2)

			set datefirst 1 
			set @dayweek 	= datepart(dw,@fecha2)
			set datefirst @oldDateFirst
			set @n = @n+1

			-- Si es fin de semana
			--		
			if @dayweek in (6,7) /*sabado*/
			begin

				set @fecha2 = case @dayweek
												when 6 /*sabado*/  then dateadd(d,2,@fecha2)
												when 7 /*domingo*/ then dateadd(d,1,@fecha2)
												else										@fecha2
											end

			end

			-- Si es feriado
			--
			while exists(select fei.fe_id 
									 from FeriadoItem fei inner join Feriado fe 
															on  fei.fe_id = fe.fe_id 
															and fe_banco <> 0
															and fe_local = 0
									 where fei_fecha = @fecha2 
									)
			begin

				set @fecha2=dateadd(d,1,@fecha2)

				set datefirst 1 
				set @dayweek 	= datepart(dw,@fecha2)
				set datefirst @oldDateFirst

				-- Si es fin de semana
				--
				if @dayweek in (6,7) /*sabado*/
				begin
	
					set @fecha2 = case @dayweek
													when 6 /*sabado*/  then dateadd(d,2,@fecha2)
													when 7 /*domingo*/ then dateadd(d,1,@fecha2)
													else										@fecha2
												end
	
				end

			end
		end

	end else begin

		while exists(select fei.fe_id 
								 from FeriadoItem fei inner join Feriado fe 
														on  fei.fe_id = fe.fe_id 
														and fe_laboral <> 0
														and fe_local = 0
								 where fei_fecha = @fecha2 
								) 
		begin

			set @fecha2=dateadd(d,1,@fecha2)

			set datefirst 1 
			set @dayweek 	= datepart(dw,@fecha2)
			set datefirst @oldDateFirst

			-- Si es fin de semana
			--
			set @fecha2 = case @dayweek
											when 6 /*sabado*/  then dateadd(d,2,@fecha2)
											when 7 /*domingo*/ then dateadd(d,1,@fecha2)
											else										@fecha2
										end

		end

	end

	set @@fecha2 = @fecha2
end
GO
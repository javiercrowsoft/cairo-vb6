if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocAsientoValidate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocAsientoValidate]

/*
 
*/

go
create procedure sp_DocAsientoValidate (
	@@as_id 				int,
  @@bError        tinyint out,
	@@MsgError      varchar(5000)= '' out
)
as

begin

	set nocount on

	--////////////////////////////////////////////////////////////
	--
	-- Decimales para importes
	--
	declare @cfg_valor varchar(5000) 

	exec sp_Cfg_GetValor  'General',
											  'Decimales Importe',
											  @cfg_valor out,
											  0

	set @cfg_valor = isnull(@cfg_valor,'0')
	if isnumeric(@cfg_valor)=0 set @cfg_valor = '0'

	declare @decimales_importe decimal(18,6)
	set @decimales_importe = convert(int,@cfg_valor)

	--////////////////////////////////////////////////////////////	

	declare @debe  decimal(18,6)
	declare @haber decimal(18,6)

	declare @strDebe  varchar(255)
	declare @strHaber varchar(255)

	declare @min_dif decimal(18,6)

	if @decimales_importe >=0 			set @min_dif = 0.01		-- Caso Argentina
	else 														set @min_dif = 1			-- Caso Chile

	select @debe = sum(asi_debe), @haber = sum(asi_haber) from AsientoItem where as_id = @@as_id

	set @debe  = round(isnull(@debe,0),@decimales_importe)
	set @haber = round(isnull(@haber,0),@decimales_importe)

	if abs(@debe-@haber) > @min_dif begin

		set @strDebe  = convert(varchar,@debe,1)
		set @strHaber = convert(varchar,@haber,1)

		set @strDebe = substring(@strDebe, 1, len(@strDebe)-4)
		set @strHaber = substring(@strHaber, 1, len(@strHaber)-4)

		set @@bError = 1
		set @@MsgError = '@@ERROR_SP:El asiento no balancea:;;  Debe : ' + @strDebe + ';  Haber: ' + @strHaber + ';;'

	end else begin

		declare @asi_id int
		declare @dif    decimal(18,6)

		update asientoitem set asi_debe = round(asi_debe,@decimales_importe), 
													 asi_haber = round(asi_haber,@decimales_importe) 
		where as_id = @@as_id

		select @dif = sum(asi_debe) - sum(asi_haber) 
		from asiento ast inner join asientoitem asi on ast.as_id = asi.as_id
		where ast.as_id = @@as_id
		group by ast.as_id

		if @dif <> 0 begin

			if @dif < 0 
				select @asi_id = min(asi_id) from asientoitem where as_id = @@as_id and asi_debe <> 0
			else
				select @asi_id = min(asi_id) from asientoitem where as_id = @@as_id and asi_haber <> 0
		
		
			if @asi_id is not null begin
				if @dif < 0 
					update asientoitem set asi_debe = asi_debe + abs(@dif) where asi_id = @asi_id
				else
					update asientoitem set asi_haber = asi_haber + abs(@dif) where asi_id = @asi_id
			end
		end

		delete asientoitem where asi_debe = 0 and asi_haber = 0 and as_id = @@as_id

		update asientoitem set asi_debe = abs(asi_haber), asi_haber = 0 
		where asi_haber < 0 and asi_debe = 0 and as_id = @@as_id
		
		update asientoitem set asi_haber = abs(asi_debe), asi_debe = 0 
		where asi_debe < 0 and asi_haber = 0 and as_id = @@as_id

		set @@bError = 0

	end

end
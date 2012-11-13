
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_EjercicioGetAux]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_EjercicioGetAux]

go
create procedure sp_EjercicioGetAux (

	@@emp_id 			varchar(50),
	@@cico_id 		varchar(50)

)as 
begin

set nocount on

	--//////////////////////////////////////////////////////////////////////////////////////

	declare @emp_id 			int
	declare @cico_id			int

	declare @ram_id_empresa          int
	declare @ram_id_circuitocontable int

	declare @clienteID 				int	
	declare @IsRaiz    				tinyint

	exec sp_GetRptId @clienteID out

	exec sp_ArbConvertId @@emp_id,  		 @emp_id  out,  			@ram_id_empresa out
	exec sp_ArbConvertId @@cico_id, 		 @cico_id out, 				@ram_id_circuitocontable out

	if @ram_id_empresa <> 0 begin
	
	--	exec sp_ArbGetGroups @ram_id_empresa, @clienteID, @@us_id
	
		exec sp_ArbIsRaiz @ram_id_empresa, @IsRaiz out
	  if @IsRaiz = 0 begin
			exec sp_ArbGetAllHojas @ram_id_empresa, @clienteID 
		end else 
			set @ram_id_empresa = 0
	end
	
	if @ram_id_circuitocontable <> 0 begin
	
	--	exec sp_ArbGetGroups @ram_id_circuitocontable, @clienteID, @@us_id
	
		exec sp_ArbIsRaiz @ram_id_circuitocontable, @IsRaiz out
	  if @IsRaiz = 0 begin
			exec sp_ArbGetAllHojas @ram_id_circuitocontable, @clienteID 
		end else 
			set @ram_id_circuitocontable = 0
	end

	create table #t_empresas  (emp_id int)
	create table #t_circuitos (cico_id int)

	insert into #t_empresas (emp_id) 
		select rptarb_hojaid 
		from rptArbolRamaHoja 
		where rptarb_cliente = @clienteID 
			and tbl_id = 1018

	insert into #t_circuitos (cico_id) 
		select rptarb_hojaid 
		from rptArbolRamaHoja 
		where rptarb_cliente = @clienteID 
			and tbl_id = 1016

	----------------------------------------------------------------------
	declare @empresas  varchar(1000)
	declare @circuitos varchar(1000)

	set @empresas  = ''
	set @circuitos = ''

	if @ram_id_empresa <> 0 begin

		declare c_emp insensitive cursor for select emp_id from #t_empresas
		open c_emp
		fetch next from c_emp into @emp_id
		while @@fetch_status = 0
		begin
			set @empresas = @empresas + convert(varchar,@emp_id) +','
			fetch next from c_emp into @emp_id
		end
		close c_emp
		deallocate c_emp
	
		if len(@empresas)>1 set @empresas = left(@empresas,len(@empresas)-1)

	end else set @empresas = @emp_id

	if @ram_id_circuitocontable <> 0 begin

		declare c_cico insensitive cursor for select cico_id from #t_circuitos
		open c_cico
		fetch next from c_cico into @cico_id
		while @@fetch_status = 0
		begin
			set @circuitos = @circuitos + convert(varchar,@cico_id) +','
			fetch next from c_cico into @cico_id
		end
		close c_cico
		deallocate c_cico
	
		if len(@circuitos)>1 set @circuitos = left(@circuitos,len(@circuitos)-1)

	end else set @circuitos = @cico_id

	set @circuitos = case when @circuitos = '0' then '' else @circuitos end

	----------------------------------------------------------------------

	declare @empresas2  varchar(1000)
	declare @circuitos2 varchar(1000)

	set @empresas2  = ''
	set @circuitos2 = ''

	declare c_ejercicios insensitive cursor for select ejc_id from EjercicioContable

	open c_ejercicios

	declare @ejc_id int

	fetch next from c_ejercicios into @ejc_id
	while @@fetch_status = 0
	begin

		---------------------------------------------------------------------
			set @empresas2  = ''
			set @circuitos2 = ''
		
			declare c_emp insensitive cursor for 
				select emp_id from EjercicioContableEmpresa where ejc_id = @ejc_id
			open c_emp
			fetch next from c_emp into @emp_id
			while @@fetch_status = 0
			begin
				set @empresas2 = @empresas2 + convert(varchar,@emp_id) +','
				fetch next from c_emp into @emp_id
			end
			close c_emp
			deallocate c_emp
		
			if len(@empresas2)>1 set @empresas2 = left(@empresas2,len(@empresas2)-1)
		
			declare c_cico insensitive cursor for 
				select cico_id from EjercicioContableCircuitoContable where ejc_id = @ejc_id
			open c_cico
			fetch next from c_cico into @cico_id
			while @@fetch_status = 0
			begin
				set @circuitos2 = @circuitos2 + convert(varchar,@cico_id) +','
				fetch next from c_cico into @cico_id
			end
			close c_cico
			deallocate c_cico
		
			if len(@circuitos2)>1 set @circuitos2 = left(@circuitos2,len(@circuitos2)-1)
		---------------------------------------------------------------------

			if @empresas = @empresas2 and @circuitos = @circuitos2 begin

				insert into #t_ejercicios (ejc_id) values (@ejc_id)
		
			end

		fetch next from c_ejercicios into @ejc_id
	end
	close c_ejercicios
	deallocate c_ejercicios

	--//////////////////////////////////////////////////////////////////////////////////////

end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


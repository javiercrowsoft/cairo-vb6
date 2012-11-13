/*---------------------------------------------------------------------
Nombre: Ingresos y Egresos 12 meses
---------------------------------------------------------------------*/
/*

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_TSR_0220_aux3]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_TSR_0220_aux3]

/*

*/

go
create procedure DC_CSC_TSR_0220_aux3 (

	@@Fini 		 datetime,
	@@Ffin 		 datetime,

	@@tipo     int

)as 

begin

set nocount on

declare @cue_id 	int
declare @pr_id 		int
declare @mes     	varchar(7)
declare @importe 	decimal(18,6)

		-- Cargo la tabla de resultados
		-- 
		
			-- Esto es para todos:
			--
			--		Por cada fila necesito crear tantos meses como existan entre Fini y Ffin
			--
			--			Para esto tengo el sp DC_CSC_TSR_0220_aux que recibe concepto_id, concepto, Fini y Ffin
			--      y me llena la tabla #t_meses
			--
		
		set @cue_id = null
		set @pr_id  = null
		
			declare c_costos insensitive cursor for
		
				select distinct t.pr_id, t.cue_id
				from #t_costos t
		
			open c_costos
			
			fetch next from c_costos into @pr_id, @cue_id
			while @@fetch_status=0
			begin
		
				exec DC_CSC_TSR_0220_aux @@Fini, @@Ffin, @pr_id, @cue_id, @@tipo
		
				fetch next from c_costos into @pr_id, @cue_id
			end
		
			close c_costos
			deallocate c_costos
		
			declare c_costos insensitive cursor for
		
				select pr_id, cue_id, importe, mes
				from #t_costos
		
			open c_costos
			fetch next from c_costos into @pr_id, @cue_id, @importe, @mes
			while @@fetch_status=0
			begin
		
				exec DC_CSC_TSR_0220_aux2 @pr_id, 
																	@cue_id,
																	@@tipo,
																	@mes,
																	@importe
		
				fetch next from c_costos into @pr_id, @cue_id, @importe, @mes
			end
		
			close c_costos
			deallocate c_costos

end

GO
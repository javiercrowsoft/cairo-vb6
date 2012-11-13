if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocResolucionCuponAsientosSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocResolucionCuponAsientosSave]

/*

	delete ResolucionCuponAsiento

	insert into ResolucionCuponAsiento (rcup_id,rcup_fecha) select rcup_id,'20040304' from ResolucionCupon 
where rcup_grabarAsiento <> 0 

  sp_DocResolucionCuponAsientosSave 

	select * from asiento
  select rcup_id,as_id from ResolucionCupon
  update ResolucionCupon set as_id = null

	sp_monedaGetCotizacion 3,'20040304'

*/

go
create procedure sp_DocResolucionCuponAsientosSave 
as

begin

	set nocount on

	declare @rcup_id 	int
	declare @est_id   int
	declare @as_id    int
	declare @bError 	smallint
  declare @MsgError varchar(5000)

	declare c_DepBcoAsientos insensitive cursor for
		select rcup.rcup_id, est_id, as_id 
		from ResolucionCuponAsiento rcupa inner join ResolucionCupon rcup on rcupa.rcup_id = rcup.rcup_id 
		order by rcupa.rcup_fecha

	open c_DepBcoAsientos
	fetch next from c_DepBcoAsientos into @rcup_id, @est_id, @as_id

	while @@fetch_status=0 begin

		if @est_id = 7 begin

			update ResolucionCupon set as_id = null where rcup_id = @rcup_id
			exec sp_DocAsientoDelete @as_id,0,0,1 -- No check access
			delete ResolucionCuponAsiento where rcup_id = @rcup_id

		end else begin

			exec sp_DocResolucionCuponAsientoSave @rcup_id,0,@bError out, @MsgError out
		  if @bError <> 0 begin
				raiserror ('Ha ocurrido un error el asiento de la resolucion de cupones. sp_DocResolucionCuponAsientosSave.', 16, 1)
			end else begin
	      delete ResolucionCuponAsiento where rcup_id = @rcup_id
	    end

		end

		fetch next from c_DepBcoAsientos into @rcup_id, @est_id, @as_id
  end

	close c_DepBcoAsientos
	deallocate c_DepBcoAsientos

end
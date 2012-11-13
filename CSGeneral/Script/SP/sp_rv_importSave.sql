if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_rv_importSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_rv_importSave]

/*

begin transaction

exec sp_rv_importSave 14136, -1

rollback transaction

*/

go
create procedure sp_rv_importSave (
	@@rvTMP_ID 				int,
	@@bTest    				smallint,
	@@impid_id    		int,
	@@impid_descrip		varchar(5000)
)
as

begin

	set nocount on

	declare @rv_nrodoc varchar(255)
	declare @MsgError  varchar(255)

	-- Controlo duplicados si asi lo indica la configuracion
	--
	declare @cfg_valor varchar(5000) 
	declare @cfg_clave varchar(255) 
	set @cfg_clave = 'Controlar códigos duplicados en importación de remitos'

	set @cfg_valor = 0
	exec sp_Cfg_GetValor  'Ventas-General',
											  @cfg_clave,
											  @cfg_valor out,
											  0
	if @@error <> 0 begin

		raiserror ('No se pudo leer la configuración general', 16, 1)
		return
	end

  set @cfg_valor = IsNull(@cfg_valor,0)

	if @@bTest <> 0 begin

		if exists(select * from RemitoVentaItemTMP rvit
							where rvTMP_id = @@rvTMP_ID 
								and exists(select * from RemitoVentaItem rvi where rvi.rvi_importCodigo = rvit.rvi_importCodigo)
								and rtrim(ltrim(rvi_importCodigo)) <> ''
								and convert(int,@cfg_valor) <> 0
							)
		begin

			declare @codigo_dup  varchar(5000)
			declare @codigo_dups varchar(5000) set @codigo_dups = ''

			declare c_codigo_dup insensitive cursor for

				select rvit.rvi_importCodigo from RemitoVentaItemTMP rvit
							where rvTMP_id = @@rvTMP_ID 
								and exists(select * from RemitoVentaItem rvi where rvi.rvi_importCodigo = rvit.rvi_importCodigo)
								and rtrim(ltrim(rvi_importCodigo)) <> ''

			open c_codigo_dup

			fetch next from c_codigo_dup into @codigo_dup
			while @@fetch_status=0
			begin

				set @codigo_dups = @codigo_dups + @codigo_dup + ', '

				fetch next from c_codigo_dup into @codigo_dup
			end

			close c_codigo_dup
			deallocate c_codigo_dup

			if len(@codigo_dups)>2 set @codigo_dups = substring(@codigo_dups,1,len(@codigo_dups)-1)

			select @rv_nrodoc = Max(rv_nrodoc) 
			from RemitoVenta rv inner join RemitoVentaItem rvi on rv.rv_id = rvi.rv_id
			where rvi_importCodigo in (

							select rvi_importCodigo from RemitoVentaItemTMP rvit
							where rvTMP_id = @@rvTMP_ID 
								and exists(select * from RemitoVentaItem rvi where rvi.rvi_importCodigo = rvit.rvi_importCodigo)
								
																)		
				and rtrim(ltrim(rvi_importCodigo)) <> ''
			
			set @MsgError = '@@ERROR_SP:Este código de importación ya ha sido importado ' + IsNull(@rv_nrodoc,'') + ' (codigos: '+ @codigo_dups+')'
			raiserror (@MsgError, 16, 1)

		end else begin

			delete PedidoRemitoVentaTMP where rvTMP_ID = @@rvTMP_ID
		  delete RemitoVentaItemSerieTMP where rvTMP_id = @@rvTMP_ID
			delete RemitoVentaItemTMP where rvTMP_ID = @@rvTMP_ID
			delete RemitoVentaTMP where rvTMP_ID = @@rvTMP_ID

			select -1

		end


	end else begin

		if not exists(select * from ImportacionID where impid_id = @@impid_id)
		begin

			declare @us_id int
			select @us_id = modifico from RemitoVentaTMP where rvTMP_id = @@rvTMP_id

			insert into ImportacionID (impid_id, impidt_id, us_id, impid_descrip) values(@@impid_id, 1, @us_id, @@impid_descrip)
		end

		-- Llamo a las particularidades del cliente
		--
		declare @bSuccess  tinyint
		declare @MsgError2 varchar(255)

		exec sp_rv_importSaveCliente @@rvTMP_id, @bSuccess out, @MsgError2 out

		if @bSuccess = 0 begin

			set @MsgError = '@@ERROR_SP:Este remito fue rechazado por las validaciones particulares del cliente ' + IsNull(@rv_nrodoc,'') + '. ' + isnull(@MsgError2,'')
			raiserror (@MsgError, 16, 1)
		
			return
		end 

		declare @doc_id int
		declare @rv_id  int

		select @doc_id = doc_id from RemitoVentaTMP where rvTMP_id = @@rvTMP_ID

		begin transaction

		exec sp_DocRemitoVentaSave @@rvTMP_ID, @rv_id out 

		update RemitoVenta set impid_id = @@impid_id where rv_id = @rv_id

		begin

			-- Controlo que no existan repeticiones en el campo codigo
			--
			if exists(select rvi_importCodigo 
		            from RemitoVentaItem rvi inner join RemitoVenta rv on rvi.rv_id = rv.rv_id
		            where rtrim(ltrim(rvi_importCodigo)) <> '' and doc_id = @doc_id 
									and (exists(select * from RemitoVentaItem rvi2 
															where rvi2.rvi_importCodigo = rvi.rvi_importCodigo
																and rvi2.rv_id = @rv_id
															)
											)
									and convert(int,@cfg_valor) <> 0
		            group by rvi_importCodigo having count(rvi_importCodigo) > 1)
			begin
		
				select @rv_nrodoc = Max(rv_nrodoc) 
				from RemitoVenta rv inner join RemitoVentaItem rvi on rv.rv_id = rvi.rv_id
				where rvi_importCodigo in (
		
								select rvi_importCodigo
		            from RemitoVentaItem rvi inner join RemitoVenta rv on rvi.rv_id = rv.rv_id
		            where rvi_importCodigo <> '' and doc_id = @doc_id 
									and (exists(select * from RemitoVentaItem rvi2 
															where rvi2.rvi_importCodigo = rvi.rvi_importCodigo
																and rvi2.rv_id = @rv_id
															))
		            group by rvi_importCodigo having count(rvi_importCodigo) > 1
					)
					and rtrim(ltrim(rvi_importCodigo)) <> ''
		
				set @MsgError = '@@ERROR_SP:Este código de importación ya ha sido importado ' + IsNull(@rv_nrodoc,'')
				raiserror (@MsgError, 16, 1)
			
				rollback transaction
		
			end
			else
				commit transaction
		end

	end

end
go
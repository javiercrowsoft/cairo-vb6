if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPackingListGetManifiestoItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPackingListGetManifiestoItems]

go

/*

select * from ManifiestoCargaitem where mfc_id = 8
exec sp_DocPackingListGetManifiestoItems '1,2,3,4,5,6'

*/

create procedure sp_DocPackingListGetManifiestoItems (
	@@strIds 					  varchar(5000)
)
as

begin

	declare @timeCode datetime
	set @timeCode = getdate()
	exec sp_strStringToTable @timeCode, @@strIds, ','

	select 
				mfci_id,
				mfc.mfc_id,
				mfc_numero,
        mfc_nrodoc,
        pr_codigo + ' - ' + pr_nombreventa as pr_nombreventa,
				pr_pesoneto,
        pr_pesototal,
        un_nombre,
        mfci.pr_id,
				mfci_cantidad,
        mfci_pendiente,
        mfci_descrip,
        mfci.ccos_id,
				tiri.ti_porcentaje  as ivariporc,
				tirni.ti_porcentaje as ivarniporc,
        e.embl_nombre,
        e.embl_id,
        e.embl_capacidad,
        e.embl_tara

  from ManifiestoCarga mfc inner join ManifiestoCargaItem mfci 	on mfci.mfc_id  = mfc.mfc_id
													 inner join TmpStringToTable					on mfc.mfc_id   = convert(int,TmpStringToTable.tmpstr2tbl_campo)
    		                   inner join Producto p           			on mfci.pr_id   = p.pr_id
                           left  join Embalaje e                on p.embl_id    = e.embl_id
        		               left  join Unidad               			on p.un_id_peso = unidad.un_id
													 inner join TasaImpositiva tiri  			on tiri.ti_id   = p.ti_id_ivariventa
													 inner join TasaImpositiva tirni  		on tirni.ti_id  = p.ti_id_ivarniventa
	where 
          mfci_pendiente > 0
		and   tmpstr2tbl_id =  @timeCode

	order by 

				mfc_nrodoc,
				mfc_fecha
end
go
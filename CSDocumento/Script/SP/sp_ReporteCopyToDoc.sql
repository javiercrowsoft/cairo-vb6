if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_ReporteCopyToDoc]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ReporteCopyToDoc]
GO

/*
select * from reporteformulario where  rptf_csrfile like '%factura%'
select * from reporteformulario where rptf_id >= 155
sp_ReporteCopyToDoc 155

*/

create procedure sp_ReporteCopyToDoc (
  @@rptf_id int
)
as
set nocount on 

begin

  declare @doc_id   int
  declare @doct_id   int
  declare @rptf_id   int
  declare @rptf_csrfile  varchar(255)
  
  select @doc_id = doc_id, @rptf_csrfile = rptf_csrfile  from reporteformulario where rptf_id = @@rptf_id
  select @doct_id = doct_id from documento where doc_id = @doc_id
  
  declare c_rpt insensitive cursor for
  
  select doc_id from documento doc
  
  where doc_id <> @doc_id 
    and (
             (@doct_id in (1,7,9) and doct_id in (1,7,9))
          or
             (@doct_id = doct_id)
        )

    and not exists(select * from reporteformulario 
                    where doc_id = doc.doc_id 
                      and rptf_csrfile = @rptf_csrfile
                  )
  
  open c_rpt

  fetch next from c_rpt into @doc_id
  while @@fetch_status=0
  begin

    exec sp_dbgetnewid 'ReporteFormulario','rptf_id',@rptf_id out, 0
  
    ---------------------------------------------
      insert into ReporteFormulario (

                    rptf_id,
                    rptf_nombre,
                    rptf_csrfile,
                    rptf_tipo,
                    rptf_sugerido,
                    rptf_copias,
                    rptf_docImprimirEnAlta,
                    rptf_object,
                    tbl_id,
                    doc_id,
                    creado,
                    modificado,
                    modifico,
                    activo,
                    rptf_sugeridoemail
              )

        select
      
            @rptf_id,
            rptf_nombre,
            rptf_csrfile,
            rptf_tipo,
            rptf_sugerido,
            rptf_copias,
            rptf_docImprimirEnAlta,
            rptf_object,
            tbl_id,
            @doc_id,
            creado,
            modificado,
            modifico,
            activo,
            rptf_sugeridoemail
            
            from reporteformulario 
            where rptf_id = @@rptf_id
      
    ---------------------------------------------

    fetch next from c_rpt into @doc_id
  end

  close c_rpt
  deallocate c_rpt

end
GO

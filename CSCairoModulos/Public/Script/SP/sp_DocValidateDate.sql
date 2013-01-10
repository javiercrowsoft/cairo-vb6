if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocValidateDate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocValidateDate]

go

/*
  select * from documento
  sp_DocValidateDate 13,'20050430 20:00:00'
*/

create procedure sp_DocValidateDate (
  @@doc_id  int,
  @@fecha   datetime
)
as

set nocount on

begin

  if exists(select fca.fca_id 
            from fechaControlAcceso fca inner join documento doc on fca.fca_id = doc.fca_id 
            where doc_id = @@doc_id
              and @@fecha between fca_fechadesde and fca_fechahasta)
          select 1, ''
  else begin
          declare @rango varchar(255)
          select @rango = 'Desde el ' + convert(varchar,fca_fechadesde,103) + ' hasta el ' + convert(varchar,fca_fechahasta,103) + ' inclusive.'
          from fechaControlAcceso fca inner join documento doc on fca.fca_id = doc.fca_id 
          where doc_id = @@doc_id
          select 0, @rango
  end
end

go

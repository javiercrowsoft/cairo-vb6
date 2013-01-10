if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_proveedorGetTalonario]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_proveedorGetTalonario]

/*

select * from documento where doc_id = 17

 sp_proveedorGetTalonario 6,14

*/

go
create procedure sp_proveedorGetTalonario (
  @@prov_id int,
  @@doc_id int
)
as

begin

  set nocount on

  declare @prov_catfiscal           smallint
  declare @doct_id                 int
  declare @doct_id_facturavta      int set @doct_id_facturavta      = 1
  declare @doct_id_facturacpra     int set @doct_id_facturacpra      = 2
  declare @doct_id_notadebitovta   int set @doct_id_notadebitovta    = 9
  declare @doct_id_notacreditovta  int set @doct_id_notacreditovta  = 7
  declare @doct_id_notadebitocpra  int set @doct_id_notadebitocpra  = 10
  declare @doct_id_notacreditocpra int set @doct_id_notacreditocpra = 8

  select @doct_id = doct_id from documento where doc_id = @@doc_id

  if @doct_id in( @doct_id_facturavta,
                  @doct_id_facturacpra,     
                  @doct_id_notadebitovta,   
                  @doct_id_notacreditovta,  
                  @doct_id_notadebitocpra,  
                  @doct_id_notacreditocpra) begin
     
  
    select
           @prov_catfiscal   = prov_catfiscal
    from Proveedor
    where prov_id = @@prov_id
  
    select
           case @prov_catfiscal
              when 1  then ta_id_inscripto   --'Inscripto'
              when 2  then ta_id_final       --'Exento'
              when 3  then ta_id_final       --'No inscripto'
              when 4  then ta_id_final       --'Consumidor Final'
              when 5  then ta_id_externo     --'Extranjero'
              when 6  then ta_id_final       --'Mono Tributo'
              when 7  then ta_id_externo     --'Extranjero Iva'
              when 8  then ta_id_final       --'No responsable'
              when 9  then ta_id_final       --'No Responsable exento'
              when 10 then ta_id_final       --'No categorizado'
              when 11 then ta_id_inscriptom  --'Inscripto M'
              else         -1                --'Sin categorizar'
           end as ta_id
    from Documento 
    where doc_id = @@doc_id

  end else begin

    select ta_id from documento where doc_id = @@doc_id

  end
end

go
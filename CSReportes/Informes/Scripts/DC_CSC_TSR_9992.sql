/*---------------------------------------------------------------------
Nombre: Proceso para regenerar asientos de movimientos de fondos
---------------------------------------------------------------------*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_TSR_9992]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_TSR_9992]


go
create procedure DC_CSC_TSR_9992 (

  @@us_id        int,

  @@Fini        datetime,
  @@Ffin        datetime,

  @@doc_id          varchar(255),
  @@emp_id           varchar(255),
  @@cue_id          varchar(255)  

)as 
begin

  set nocount on

declare @emp_id        int
declare @doc_id       int
declare @cue_id       int

declare @ram_id_empresa        int
declare @ram_id_documento     int
declare @ram_id_cuenta        int

declare @IsRaiz    tinyint
declare @clienteID int

exec sp_ArbConvertId @@emp_id,       @emp_id out,       @ram_id_empresa   out
exec sp_ArbConvertId @@doc_id,       @doc_id out,        @ram_id_documento out
exec sp_ArbConvertId @@cue_id,       @cue_id out,        @ram_id_cuenta     out
  
exec sp_GetRptId @clienteID out

if @ram_id_documento <> 0 begin

--  exec sp_ArbGetGroups @ram_id_documento, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_documento, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_documento, @clienteID 
  end else 
    set @ram_id_documento = 0
end

if @ram_id_empresa <> 0 begin

--  exec sp_ArbGetGroups @ram_id_empresa, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_empresa, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_empresa, @clienteID 
  end else 
    set @ram_id_empresa = 0
end

if @ram_id_cuenta <> 0 begin

--  exec sp_ArbGetGroups @ram_id_cuenta, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_cuenta, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_cuenta, @clienteID 
  end else 
    set @ram_id_cuenta = 0
end

  update MovimientoFondo set mf_grabarAsiento = 1
  from Documento doc
  where 
        mf_fecha between @@Fini and @@Ffin

     and MovimientoFondo.doc_id = doc.doc_id

     and (doc.emp_id = @emp_id or @emp_id = 0)
     and (
            (exists(select rptarb_hojaid 
                    from rptArbolRamaHoja 
                    where
                         rptarb_cliente = @clienteID
                    and  tbl_id = 1018 
                    and  rptarb_hojaid = doc.emp_id
                   ) 
             )
          or 
             (@ram_id_empresa = 0)
         )

      and (     (@cue_id = 0 or @ram_id_cuenta = 0)
            and  exists(select * from AsientoItem 
                       where as_id = MovimientoFondo.as_id 
                        and (      (cue_id = @cue_id or @cue_id = 0) 
                              and (  (exists(select rptarb_hojaid 
                                            from rptArbolRamaHoja 
                                            where rptarb_cliente = @clienteID 
                                              and tbl_id = 17
                                              and rptarb_hojaid = cue_id)
                                            ) 
                                 or (@ram_id_empresa = 0)
                                  )
                            )
                      )
          )

  delete MovimientoFondoAsiento

   insert into MovimientoFondoAsiento (mf_id,mf_fecha) 
  select mf_id,'20040304' from MovimientoFondo 
  where mf_grabarAsiento <> 0 

  exec sp_DocMovimientoFondoAsientosSave 

  select 1 as aux_id, 'El proceso se ejecuto con éxito, los asientos han sido actualizados' as Info

end
go
 
/*---------------------------------------------------------------------
Nombre: Libro Diario
---------------------------------------------------------------------*/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_9999]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_9999]
GO

/*  

Para testear:

DC_CSC_CON_9999 1, 
                '20000101',
                '20100120',
                '0',
                '0',
                '0',
                '0'
*/

create procedure DC_CSC_CON_9999 (

  @@us_id        int,
  @@Fini          datetime,
  @@Ffin          datetime,
  @@cue_id      varchar(255),
  @@cico_id     varchar(255),
  @@doc_id       varchar(255),
  @@emp_id       varchar(255)

)as 

begin

set nocount on

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */


declare @cue_id       int
declare @emp_id       int
declare @cico_id       int
declare @doc_id        int

declare @ram_id_cuenta           int
declare @ram_id_empresa          int
declare @ram_id_circuitocontable int
declare @ram_id_documento        int


declare @clienteID       int
declare @clienteIDccosi int

declare @IsRaiz    tinyint

exec sp_ArbConvertId @@emp_id,       @emp_id  out,        @ram_id_empresa out
exec sp_ArbConvertId @@cue_id,       @cue_id  out,         @ram_id_cuenta out
exec sp_ArbConvertId @@cico_id,      @cico_id out,         @ram_id_circuitocontable out
exec sp_ArbConvertId @@doc_id,        @doc_id  out,         @ram_id_Documento out

exec sp_GetRptId @clienteID out
exec sp_GetRptId @clienteIDccosi out

if @ram_id_cuenta <> 0 begin

--  exec sp_ArbGetGroups @ram_id_cuenta, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_cuenta, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_cuenta, @clienteID 
  end else 
    set @ram_id_cuenta = 0
end

if @ram_id_empresa <> 0 begin

--  exec sp_ArbGetGroups @ram_id_empresa, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_empresa, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_empresa, @clienteID 
  end else 
    set @ram_id_empresa = 0
end

if @ram_id_circuitocontable <> 0 begin

--  exec sp_ArbGetGroups @ram_id_circuitocontable, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_circuitocontable, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_circuitocontable, @clienteID 
  end else 
    set @ram_id_circuitocontable = 0
end

if @ram_id_documento <> 0 begin

--  exec sp_ArbGetGroups @ram_id_circuitocontable, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_documento, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_documento, @clienteID 
  end else 
    set @ram_id_documento = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

    declare c_asiento insensitive cursor for
      
      select distinct ast.as_id

      from 
      
            asiento ast
      
                    inner join documento  doc    on ast.doc_id         = doc.doc_id
                    left  join documento   doccl on ast.doc_id_cliente = doccl.doc_id
      
                    inner join asientoItem asi  on ast.as_id    = asi.as_id
                    inner join cuenta      cue  on asi.cue_id   = cue.cue_id
      
      where 
                as_fecha >= @@Fini
            and  as_fecha <= @@Ffin 
      
      -- Validar usuario - empresa
            and (
                  exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
                )
      
      /* -///////////////////////////////////////////////////////////////////////
      
      INICIO SEGUNDA PARTE DE ARBOLES
      
      /////////////////////////////////////////////////////////////////////// */
      
      and   (  @cue_id = 0
             or
               exists(select as_id from AsientoItem 
                      where as_id = ast.as_id 
                        and asi.cue_id = @cue_id
                      )       
            )
      
      
      and   (doc.emp_id   = @emp_id   or @emp_id  =0)
      
      and   (IsNull(doccl.cico_id,doc.cico_id) = @cico_id or @cico_id  =0)
      
      and   (ast.doc_id   = @doc_id   or @doc_id  =0)
      
      -- Arboles
      
      and   (
                (exists(select as_id from AsientoItem
                        where as_id = ast.as_id
                          and (
                                exists(select rptarb_hojaid 
                                       from rptArbolRamaHoja 
                                       where rptarb_cliente = @clienteID
                                         and tbl_id = 17 
                                         and rptarb_hojaid = cue_id
                                       ) 
                              )
                        )
                 )
              or 
                 (@ram_id_cuenta = 0)
             )
      
      and   (
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
      and   (
                (exists(select rptarb_hojaid 
                        from rptArbolRamaHoja 
                        where
                             rptarb_cliente = @clienteID
                        and  tbl_id = 1016 
                        and  rptarb_hojaid = IsNull(doccl.cico_id,doc.cico_id)
                       ) 
                 )
              or 
                 (@ram_id_circuitocontable = 0)
             )
      
      and   (
                (exists(select rptarb_hojaid 
                        from rptArbolRamaHoja 
                        where
                             rptarb_cliente = @clienteID
                        and  tbl_id = 4001
                        and  rptarb_hojaid = ast.doc_id
                       ) 
                 )
              or 
                 (@ram_id_documento = 0)
             )

    open c_asiento      

    declare @as_id int

    fetch next from c_asiento into @as_id
    while @@fetch_status=0
    begin

      exec sp_DocAsientoValidate @as_id, 0

      fetch next from c_asiento into @as_id
    end

    close c_asiento
    deallocate c_asiento

  select 1, 'El proceso se ejecuto con éxito.' as Info

end
GO
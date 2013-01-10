
/*---------------------------------------------------------------------
Nombre: Cheques emitidos
---------------------------------------------------------------------*/
/*
DC_CSC_TSR_0030 7,'20000101','20041231','0','0','0'
select * from rama where ram_nombre like 'el nombre de alguna rama de algun arbol de la tabla a listar'
*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_TSR_0030]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_TSR_0030]

go
create procedure DC_CSC_TSR_0030 (

  @@us_id      int,
  @@Fini        datetime,
  @@Ffin        datetime,

@@cue_id      varchar(255),
@@bco_id      varchar(255),
@@prov_id      varchar(255), 
@@emp_id      varchar(255),
@@tipoFecha    smallint

)as 

begin

  /*- ///////////////////////////////////////////////////////////////////////
  
  INICIO PRIMERA PARTE DE ARBOLES
  
  /////////////////////////////////////////////////////////////////////// */
  
  declare @cue_id  int
  declare @bco_id  int
  declare @prov_id int
  declare @emp_id  int  --TODO:EMPRESA
  
  declare @ram_id_cuenta    int
  declare @ram_id_banco     int
  declare @ram_id_proveedor int
  declare @ram_id_Empresa   int 
  
  declare @clienteID int
  declare @IsRaiz    tinyint
  
  exec sp_ArbConvertId @@cue_id,  @cue_id out,  @ram_id_cuenta out
  exec sp_ArbConvertId @@bco_id,  @bco_id out,  @ram_id_banco out
  exec sp_ArbConvertId @@prov_id, @prov_id out, @ram_id_proveedor out
  exec sp_ArbConvertId @@emp_id,  @emp_id out,  @ram_id_Empresa out 
  
  exec sp_GetRptId @clienteID out
  
  if @ram_id_cuenta <> 0 begin
  
  --  exec sp_ArbGetGroups @ram_id_cuenta, @clienteID, @@us_id
  
    exec sp_ArbIsRaiz @ram_id_cuenta, @IsRaiz out
    if @IsRaiz = 0 begin
      exec sp_ArbGetAllHojas @ram_id_cuenta, @clienteID 
    end else 
      set @ram_id_cuenta = 0
  end
  
  if @ram_id_banco <> 0 begin
  
  --  exec sp_ArbGetGroups @ram_id_banco, @clienteID, @@us_id
  
    exec sp_ArbIsRaiz @ram_id_banco, @IsRaiz out
    if @IsRaiz = 0 begin
      exec sp_ArbGetAllHojas @ram_id_banco, @clienteID 
    end else 
      set @ram_id_banco = 0
  end
  
  if @ram_id_proveedor <> 0 begin
  
  --  exec sp_ArbGetGroups @ram_id_proveedor, @clienteID, @@us_id
  
    exec sp_ArbIsRaiz @ram_id_proveedor, @IsRaiz out
    if @IsRaiz = 0 begin
      exec sp_ArbGetAllHojas @ram_id_proveedor, @clienteID 
    end else 
      set @ram_id_proveedor = 0
  end
  
  
  if @ram_id_Empresa <> 0 begin
  
  --  exec sp_ArbGetGroups @ram_id_Empresa, @clienteID, @@us_id
  
    exec sp_ArbIsRaiz @ram_id_Empresa, @IsRaiz out
    if @IsRaiz = 0 begin
      exec sp_ArbGetAllHojas @ram_id_Empresa, @clienteID 
    end else 
      set @ram_id_Empresa = 0
  end
  /*- ///////////////////////////////////////////////////////////////////////
  
  FIN PRIMERA PARTE DE ARBOLES
  
  /////////////////////////////////////////////////////////////////////// */
  
  
  select 
  
              cheq_id,
              emp_nombre        as [Empresa], 
              bco_nombre        as [Banco],
              bco_nombre + ' - ' + cue_nombre        
                                as [Cuenta],
              mon_nombre        as [Moneda],
              chq_codigo        as [Chequera],
              cheq_numero        as [Numero],
              cheq_numerodoc    as [Comprobante],
              cheq_fechacobro   as [Fecha Pago],
              cheq_fecha2        as [Fecha Acreditacion],
              cheq_fechaVto      as [Fecha Vto.],
              case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as [Legajo],
              doc_nombre        as [Documento],
              isnull(opg_nrodoc,isnull(mf_nrodoc,dbco_nrodoc))
                                as [Orden Pago],
              isnull(opg_numero,isnull(mf_numero,dbco_numero))        
                                as [Orden Pago Numero],
              isnull(opg_fecha,isnull(mf_fecha,dbco_fecha))         
                                as [Orden Fecha],
              prov_nombre       as [Proveedor],
              cheq_importe      as [Importe],
              cheq_descrip      as [Observaciones]
  
  from 
  
        Cheque cheq inner join Chequera chq         on cheq.chq_id    = chq.chq_id
                    inner join Clearing cle         on cheq.cle_id    = cle.cle_id
                    inner join Cuenta c             on chq.cue_id     = c.cue_id
                    inner join Banco  b             on c.bco_id        = b.bco_id
                    inner join Moneda m             on c.mon_id       = m.mon_id

                    left  join OrdenPago opg          on cheq.opg_id    = opg.opg_id
                    left  join MovimientoFondo mf     on cheq.mf_id     = mf.mf_id
                    left  join DepositoBanco dbco     on cheq.dbco_id   = dbco.dbco_id

                    left  join Documento d          on     opg.doc_id     = d.doc_id
                                                      or   mf.doc_id      = d.doc_id
                                                      or  dbco.doc_id    = d.doc_id

                    left  join Empresa              on d.emp_id       = Empresa.emp_id 
                    left  join Proveedor p          on opg.prov_id    = p.prov_id
                    left  join Legajo l             on opg.lgj_id     = l.lgj_id
  
  where 
        (
          (
                  @@Fini <= isnull(opg_fecha,isnull(mf_fecha,dbco_fecha))
              and  @@Ffin >= isnull(opg_fecha,isnull(mf_fecha,dbco_fecha))
              and @@tipoFecha = 1
          )
          or
          (
                  @@Fini <= cheq_fechacobro
              and  @@Ffin >= cheq_fechacobro
              and @@tipoFecha = 2
          )
          or
          (
                  @@Fini <= cheq_fecha2
              and  @@Ffin >= cheq_fecha2
              and @@tipoFecha = 3
          )
          or
          (
                  @@Fini <= cheq_fechavto
              and  @@Ffin >= cheq_fechavto
              and @@tipoFecha = 4
          )
        )
        and (
              exists(select * from EmpresaUsuario where emp_id = d.emp_id and us_id = @@us_id) or (@@us_id = 1)
            )
  
  /* -///////////////////////////////////////////////////////////////////////
  
  INICIO SEGUNDA PARTE DE ARBOLES
  
  /////////////////////////////////////////////////////////////////////// */
  
  and   (c.cue_id  = @cue_id  or @cue_id=0)
  and   (b.bco_id  = @bco_id  or @bco_id=0)
  and   (p.prov_id = @prov_id or @prov_id=0)
  and   (d.emp_id  = @emp_id  or @emp_id=0) 
  
  -- Arboles
  and   (
            (exists(select rptarb_hojaid 
                    from rptArbolRamaHoja 
                    where
                         rptarb_cliente = @clienteID
                    and  tbl_id = 17 
                    and  rptarb_hojaid = c.cue_id
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
                    and  tbl_id = 13 
                    and  rptarb_hojaid = b.bco_id
                   ) 
             )
          or 
             (@ram_id_banco = 0)
         )
  
  and   (
            (exists(select rptarb_hojaid 
                    from rptArbolRamaHoja 
                    where
                         rptarb_cliente = @clienteID
                    and  tbl_id = 29 
                    and  rptarb_hojaid = p.prov_id
                   ) 
             )
          or 
             (@ram_id_proveedor = 0)
         )
  
  and   (
            (exists(select rptarb_hojaid 
                    from rptArbolRamaHoja 
                    where
                         rptarb_cliente = @clienteID
                    and  tbl_id = 1018
                    and  rptarb_hojaid = d.emp_id
                   ) 
             )
          or 
             (@ram_id_Empresa = 0)
         )
  
  order by Cuenta, Chequera, Proveedor

end
go
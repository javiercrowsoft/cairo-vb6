/*

select * from rama where ram_nombre like 'el nombre de alguna rama de algun arbol de la tabla a listar'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_ProductoSeriesCairo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_ProductoSeriesCairo]
go

/*
select * from Stock

sp_docStockget 47

sp_lsdoc_ProductoSeriesCairo

  1,0,1,
  '20030101',
  '20050101',
    '0',
    '0',
    '17',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0',
    0,
    0
*/

create procedure sp_lsdoc_ProductoSeriesCairo (

  @@us_id    int,

  @@FiltrarFecha smallint,
  @@SinAsignar   smallint,

  @@Fini      datetime,
  @@Ffin      datetime,

  @@prns_id           varchar(255),
  @@rub_id            varchar(255),
  @@pr_id               varchar(255),
  @@depl_id           varchar(255),

  @@cli_id             varchar(255),
  @@suc_id            varchar(255),

  @@us_id_responsable varchar(255),
  @@us_id_asignador   varchar(255),
  @@cont_id            varchar(255),
  @@tarest_id          varchar(255),
  @@prio_id            varchar(255),
  @@proy_id            varchar(255),

  @@soloEnEmpresa     smallint,

  @@emp_id  varchar(255)

)as 

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */
declare @proy_id               int
declare @us_id_responsable     int
declare @us_id_asignador       int
declare @cont_id              int
declare @tarest_id            int
declare @prio_id              int

declare @ram_id_proyecto       int
declare @ram_id_responsable   int
declare @ram_id_asignador     int
declare @ram_id_contacto      int
declare @ram_id_estado        int
declare @ram_id_prioridad     int

declare @cli_id int
declare @suc_id int
declare @emp_id int

declare @ram_id_Cliente  int
declare @ram_id_Sucursal int
declare @ram_id_empresa  int 

declare @prns_id       int
declare @pr_id        int
declare @rub_id        int
declare @depl_id       int

declare @ram_id_productoserie     int
declare @ram_id_producto           int
declare @ram_id_rubro              int
declare @ram_id_DepositoLogico     int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cli_id, @cli_id out, @ram_id_Cliente out
exec sp_ArbConvertId @@suc_id, @suc_id out, @ram_id_Sucursal out
exec sp_ArbConvertId @@emp_id, @emp_id out, @ram_id_empresa out

exec sp_ArbConvertId @@proy_id,           @proy_id out,           @ram_id_proyecto out
exec sp_ArbConvertId @@us_id_responsable, @us_id_responsable out, @ram_id_responsable out
exec sp_ArbConvertId @@us_id_asignador,   @us_id_asignador out,   @ram_id_asignador out

exec sp_ArbConvertId @@cont_id,     @cont_id out,     @ram_id_contacto out
exec sp_ArbConvertId @@tarest_id,   @tarest_id out,   @ram_id_estado out
exec sp_ArbConvertId @@prio_id,     @prio_id out,     @ram_id_prioridad out

exec sp_ArbConvertId @@prns_id,     @prns_id out, @ram_id_productoserie out
exec sp_ArbConvertId @@pr_id,       @pr_id out,    @ram_id_producto out
exec sp_ArbConvertId @@rub_id,       @rub_id out,  @ram_id_rubro out
exec sp_ArbConvertId @@depl_id,     @depl_id out, @ram_id_DepositoLogico out

exec sp_GetRptId @clienteID out

if @ram_id_Cliente <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Cliente, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Cliente, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Cliente, @clienteID 
  end else 
    set @ram_id_Cliente = 0
end

if @ram_id_Sucursal <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Sucursal, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Sucursal, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Sucursal, @clienteID 
  end else 
    set @ram_id_Sucursal = 0
end

if @ram_id_empresa <> 0 begin

--  exec sp_ArbGetGroups @ram_id_empresa, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_empresa, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_empresa, @clienteID 
  end else 
    set @ram_id_empresa = 0
end

if @ram_id_proyecto <> 0 begin

  -- exec sp_ArbGetGroups @ram_id_proyecto, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_proyecto, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_proyecto, @clienteID 
  end else 
    set @ram_id_proyecto = 0
end

if @ram_id_responsable <> 0 begin

  -- exec sp_ArbGetGroups @ram_id_responsable, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_responsable, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_responsable, @clienteID 
  end else 
    set @ram_id_responsable = 0
end

if @ram_id_asignador <> 0 begin

  -- exec sp_ArbGetGroups @ram_id_asignador, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_asignador, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_asignador, @clienteID 
  end else 
    set @ram_id_asignador = 0
end

if @ram_id_contacto <> 0 begin

  -- exec sp_ArbGetGroups @ram_id_contacto, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_contacto, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_contacto, @clienteID 
  end else 
    set @ram_id_contacto = 0
end

if @ram_id_prioridad <> 0 begin

  -- exec sp_ArbGetGroups @ram_id_prioridad, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_prioridad, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_prioridad, @clienteID 
  end else 
    set @ram_id_prioridad = 0
end

if @ram_id_estado <> 0 begin

  -- exec sp_ArbGetGroups @ram_id_estado, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_estado, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_estado, @clienteID 
  end else 
    set @ram_id_estado = 0
end

if @ram_id_productoserie <> 0 begin

--  exec sp_ArbGetGroups @ram_id_productoserie, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_productoserie, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_productoserie, @clienteID 
  end else 
    set @ram_id_productoserie = 0
end

if @ram_id_producto <> 0 begin

--  exec sp_ArbGetGroups @ram_id_producto, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_producto, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_producto, @clienteID 
  end else 
    set @ram_id_producto = 0
end

if @ram_id_rubro <> 0 begin

--  exec sp_ArbGetGroups @ram_id_rubro, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_rubro, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_rubro, @clienteID 
  end else 
    set @ram_id_rubro = 0
end

if @ram_id_DepositoLogico <> 0 begin

--  exec sp_ArbGetGroups @ram_id_DepositoLogico, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_DepositoLogico, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_DepositoLogico, @clienteID 
  end else 
    set @ram_id_DepositoLogico = 0
end


if       @@FiltrarFecha = 0 
    and @@prns_id = '0' 
    and @@rub_id = '0' 
    and @@pr_id = '0' 
    and @@depl_id = '0' 
    and @@cli_id = '0'
    and @@suc_id = '0'
    and @@us_id_responsable = '0'
    and @@us_id_asignador = '0'
    and @@proy_id = '0'
    and @@prio_id = '0'
    and @@cont_id = '0'
    and @@tarest_id = '0'
begin

  select 1,'Debe indicar al menos un filtro' as Info  
  return

end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */
-- sp_columns Stock

select top 10000

    prns.prns_id,
    ''                  as [TypeTask],

    prns_codigo          as [Numero Serie],
    prns_codigo2        as [OT],

    cli_nombre          as Cliente,
    isnull(
    isnull(
    isnull(t.tar_fechaini,
           os.os_fecha),
           rc.rc_fecha),
           fc.fc_fecha)
                        as [Ingreso],
    depl_nombre         as Deposito,
    doc_nombre          as Documento,
    isnull(isnull(isnull(isnull(isnull(
           rc_nrodoc,fc_nrodoc),rs_nrodoc),ppk_nrodoc),impt_nrodoc),os_nrodoc)
                        as Comprobante,
    pr_nombrecompra      as Equipo,

    t.tar_fechafin      as [Fecha Limite],
    rub_nombre          as Rubro,

    usr.us_nombre        as Responable,
    usa.us_nombre        as Asigno,
    prov_nombre         as Proveedor,
    prns_descrip        as Observaciones

from 
      ProductoNumeroSerie prns

                      inner join Producto pr   on prns.pr_id   = pr.pr_id
                                            and   (prns.pr_id   = @pr_id    or @pr_id=0)
                                            and   (
                                                      (exists(select rptarb_hojaid 
                                                              from rptArbolRamaHoja 
                                                              where
                                                                   rptarb_cliente = @clienteID
                                                              and  tbl_id = 30 
                                                              and  rptarb_hojaid = prns.pr_id
                                                             ) 
                                                       )
                                                    or 
                                                       (@ram_id_producto = 0)
                                                   )

                                            and   (prns.prns_id = @prns_id or @prns_id=0)
                                            and   (
                                                      (exists(select rptarb_hojaid 
                                                              from rptArbolRamaHoja 
                                                              where
                                                                   rptarb_cliente = @clienteID
                                                              and  tbl_id = 1017 
                                                              and  rptarb_hojaid = prns.prns_id
                                                             ) 
                                                       )
                                                    or 
                                                       (@ram_id_productoserie = 0)
                                                   )


                      left join tarea t               on prns.tar_id = t.tar_id
                      left join proyecto proy         on t.proy_id   = proy.proy_id


                      left join remitocompra     rc    on prns.doct_id_ingreso = 4     and prns.doc_id_ingreso = rc.rc_id
                      left join facturacompra   fc    on prns.doct_id_ingreso = 2     and prns.doc_id_ingreso = fc.fc_id
                      left join recuentostock   rs    on prns.doct_id_ingreso = 28    and prns.doc_id_ingreso = rs.rs_id
                      left join parteprodkit    ppk   on prns.doct_id_ingreso = 30    and prns.doc_id_ingreso = ppk.ppk_id
                      left join importaciontemp impt  on prns.doct_id_ingreso = 29    and prns.doc_id_ingreso = impt.impt_id
                      left join ordenservicio   os    on prns.doct_id_ingreso = 42    and prns.doc_id_ingreso = os.os_id

                      left  join documento doc on     rc.doc_id    = doc.doc_id 
                                                  or  fc.doc_id    = doc.doc_id 
                                                  or  rs.doc_id    = doc.doc_id 
                                                  or  ppk.doc_id  = doc.doc_id 
                                                  or  impt.doc_id  = doc.doc_id 
                                                  or  os.doc_id    = doc.doc_id 

                      left  join empresa emp   on doc.emp_id      = emp.emp_id
                      left  join sucursal suc  on     rc.suc_id    = suc.suc_id 
                                                  or  fc.suc_id    = suc.suc_id 
                                                  or  rs.suc_id    = suc.suc_id 
                                                  or  ppk.suc_id  = suc.suc_id 
                                                  or  impt.suc_id  = suc.suc_id 
                                                  or  os.suc_id    = suc.suc_id 

                      left  join usuario usr   on t.us_id_responsable   = usr.us_id
                      left  join usuario usa   on t.us_id_asignador     = usa.us_id

                      left  join depositologico depl  on prns.depl_id   = depl.depl_id

                      left  join rubro rub         on pr.rub_id     = rub.rub_id
                      left  join cliente cli       on prns.cli_id   = cli.cli_id
                      left  join proveedor prov   on prns.prov_id = prov.prov_id

where 

      (      t.tar_fechafin between @@Fini and @@Ffin
        or  isnull(isnull(isnull(
                   t.tar_fechaini,
                   os.os_fecha),
                   rc.rc_fecha),
                   fc.fc_fecha) between @@Fini and @@Ffin
        or @@FiltrarFecha = 0
      )

      and (      prns.depl_id not in (-2,-3)
            or  @@soloEnEmpresa = 0
          )

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (prns.cli_id = @cli_id  or @cli_id=0)

and   (suc.suc_id = @suc_id   or @suc_id=0)
and   (emp.emp_id = @emp_id   or @emp_id=0)

and   (t.proy_id           = @proy_id            or @proy_id=0)
and   (t.us_id_responsable = @us_id_responsable  or @us_id_responsable=0 
        or (t.us_id_responsable is null and @@SinAsignar <> 0)
      )
and   (t.us_id_asignador   = @us_id_asignador    or @us_id_asignador=0)

and   (t.tarest_id  = @tarest_id    or @tarest_id=0)
and   (t.prio_id    = @prio_id      or @prio_id=0)
and   (t.cont_id    = @cont_id      or @cont_id=0)

and   (pr.rub_id    = @rub_id  or @rub_id=0)
and   (prns.depl_id = @depl_id or @depl_id=0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 28 
                  and  rptarb_hojaid = prns.cli_id
                 ) 
           )
        or 
           (@ram_id_Cliente = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1007 
                  and  rptarb_hojaid = suc.suc_id
                 ) 
           )
        or 
           (@ram_id_Sucursal = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1018 
                  and  rptarb_hojaid = emp.emp_id
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
                  and  tbl_id = 2005 
                  and  rptarb_hojaid = proy.proy_id
                 ) 
           )
        or 
           (@ram_id_proyecto = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 3 
                  and  rptarb_hojaid = t.us_id_responsable
                 ) 
           )
        or 
           (    @ram_id_responsable = 0         
            or (t.us_id_responsable is null and @@SinAsignar <> 0)
            )
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 3 
                  and  rptarb_hojaid = t.us_id_asignador
                 ) 
           )
        or 
           (@ram_id_asignador = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 2004
                  and  rptarb_hojaid = t.tarest_id
                 ) 
           )
        or 
           (@ram_id_estado = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 2003
                  and  rptarb_hojaid = t.prio_id
                 ) 
           )
        or 
           (@ram_id_prioridad = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 2001 
                  and  rptarb_hojaid = t.cont_id
                 ) 
           )
        or 
           (@ram_id_contacto = 0)
       )

and    (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 5 
                  and  rptarb_hojaid = pr.rub_id
                 ) 
           )
        or 
           (@ram_id_rubro = 0)
      )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 11 
                  and  rptarb_hojaid = prns.depl_id
                 ) 
           )
        or 
           (@ram_id_DepositoLogico = 0)
       )

  order by Ingreso
go
/*---------------------------------------------------------------------
Nombre: Muestra los articulos asociados a las cuentas que figuran en
        estos asientos
---------------------------------------------------------------------*/

/*


[DC_CSC_CON_0266] 1,'20060101','20070301','0','0','0'


*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_0266]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_0266]


go
create procedure DC_CSC_CON_0266 (

  @@us_id        int,

  @@Fini        datetime,
  @@Ffin        datetime,

  @@prov_id         varchar(255),
  @@doc_id          varchar(255),
  @@emp_id           varchar(255) 

)as 
begin

  set nocount on

declare @emp_id        int
declare @prov_id       int
declare @doc_id       int

declare @ram_id_empresa        int
declare @ram_id_proveedor     int
declare @ram_id_documento     int

declare @IsRaiz     tinyint
declare @clienteID   int

exec sp_ArbConvertId @@emp_id,       @emp_id out,       @ram_id_empresa out
exec sp_ArbConvertId @@prov_id,       @prov_id out,      @ram_id_proveedor out
exec sp_ArbConvertId @@doc_id,       @doc_id out,        @ram_id_documento out
  
exec sp_GetRptId @clienteID out

if @ram_id_proveedor <> 0 begin

--  exec sp_ArbGetGroups @ram_id_proveedor, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_proveedor, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_proveedor, @clienteID 
  end else 
    set @ram_id_proveedor = 0
end

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

--////////////////////////////////////////////////////////////////////////////

  declare @cue_acreedoresXvta int 
  set @cue_acreedoresXvta = 8

  create table #t_cuentas (as_id int, cue_id int)
  create table #t_productos (cue_id int, pr_id int)

  declare @as_id int
  declare @cue_id int

  insert into #t_cuentas

  select   asi.as_id, asi.cue_id

  from AsientoItem asi inner join Cuenta cue on asi.cue_id = cue.cue_id
  where 
          cue.cuec_id <> @cue_acreedoresXvta -- No tiene que ser la cuenta del acreedor
      and as_id in (

              select as_id
              from FacturaCompra fc inner join Documento doc on fc.doc_id = doc.doc_id
              where 
                    fc_fecha between @@Fini and @@Ffin
            
                and   (prov_id = @prov_id or @prov_id = 0)
                and   (
                        (exists(select rptarb_hojaid 
                                from rptArbolRamaHoja 
                                where
                                     rptarb_cliente = @clienteID
                                and  tbl_id = 29 
                                and  rptarb_hojaid = prov_id
                               ) 
                         )
                      or 
                         (@ram_id_proveedor = 0)
                     )                  
            
                 and fc.doc_id = doc.doc_id
            
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
            
            
                  and  (doc.doc_id = @doc_id or @doc_id = 0)
                  and (
                          (exists(select rptarb_hojaid 
                                  from rptArbolRamaHoja 
                                  where
                                       rptarb_cliente = @clienteID
                                  and  tbl_id = 4001 
                                  and  rptarb_hojaid = doc.doc_id
                                 ) 
                           )
                        or 
                           (@ram_id_documento = 0)
                       )
            
        )

  group by
           asi.as_id, asi.cue_id


  declare c_cue insensitive cursor for select as_id, cue_id from #t_cuentas

  open c_cue

  fetch next from c_cue into @as_id, @cue_id
  while @@fetch_status = 0
  begin

    insert into #t_productos(pr_id, cue_id)

    select pr.pr_id, @cue_id
    from FacturaCompra fc inner join FacturaCompraitem fci on fc.fc_id = fci.fc_id
                         inner join Producto pr on fci.pr_id = pr.pr_id
                         inner join CuentaGrupo cueg on pr.cueg_id_Compra = cueg.cueg_id
                         left  join ProveedorCuentaGrupo provcueg on   fc.prov_id = provcueg.prov_id
                                                                and cueg.cueg_id = provcueg.cueg_id

    where fc.as_id = @as_id
      and (cueg.cue_id = @cue_id or isnull(provcueg.cue_id,0) = @cue_id)

    fetch next from c_cue into @as_id, @cue_id
  end

  close c_cue
  deallocate c_cue

  select distinct 
                    t.cue_id,
                    t.pr_id,
                    cue_codigo      as [Cuenta Codigo],
                    cue_nombre      as Cuenta,
                    pr_codigo       as [Producto Codigo],
                    pr_nombreCompra  as Producto,
                    ''              as dummycol

  from #t_productos t inner join Producto pr on t.pr_id = pr.pr_id
                      inner join Cuenta cue on t.cue_id = cue.cue_id      

  order by cue_codigo, cue_nombre, pr_codigo

end
go
 
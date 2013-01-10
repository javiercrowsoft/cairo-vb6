/*---------------------------------------------------------------------
Nombre: Facturas a Pagar
---------------------------------------------------------------------*/

/*
Para testear:

DC_CSC_VEN_0710 
                    1,
                    '20080101',
                    '20091231',
                    '0',
                    '0',
                    '0',
                    '0'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_0710]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_0710]

go
create procedure DC_CSC_VEN_0710 (

  @@us_id    int,
  @@Fini      datetime,
  @@Ffin      datetime,

  @@cli_id        varchar(255),
  @@suc_id         varchar(255),
  @@cico_id        varchar(255),
  @@emp_id         varchar(255)

)as 

begin

set nocount on

  /*- ///////////////////////////////////////////////////////////////////////

  TABLA DE MESES

  /////////////////////////////////////////////////////////////////////// */
  create table #t_meses(
                        anio      int, 
                        mes        int, 
                        neto      decimal(18,6), 
                        impuestos decimal(18,6), 
                        total      decimal(18,6),

                        desde     datetime,
                        hasta      datetime
                      )

  declare @fecha datetime
  declare @n int
  declare @i int

  set @i=1

  set @fecha = @@Fini
  set @fecha = dateadd(d,-day(@fecha)+1,@fecha)
  set @n = datediff(m,@@Fini,@@Ffin)+1

  while @i <= @n
  begin

    insert into #t_meses(anio, mes, neto, impuestos, total, desde, hasta)

    select year(@fecha), month(@fecha), 0, 0, 0, @fecha, dateadd(d,-1,dateadd(m,1,@fecha))
    set @fecha = dateadd(m,1,@fecha)

    set @i=@i+1

  end

  /*- ///////////////////////////////////////////////////////////////////////

  INICIO PRIMERA PARTE DE ARBOLES

  /////////////////////////////////////////////////////////////////////// */

  declare @cli_id   int
  declare @suc_id   int
  declare @cico_id  int
  declare @emp_id   int 

  declare @ram_id_Cliente   int
  declare @ram_id_Sucursal   int
  declare @ram_id_circuitocontable int
  declare @ram_id_Empresa   int 

  declare @clienteID int
  declare @IsRaiz    tinyint

  exec sp_ArbConvertId @@cli_id,  @cli_id out,  @ram_id_Cliente out
  exec sp_ArbConvertId @@suc_id,  @suc_id out,  @ram_id_Sucursal out
  exec sp_ArbConvertId @@cico_id, @cico_id out, @ram_id_circuitocontable out
  exec sp_ArbConvertId @@emp_id,  @emp_id out,  @ram_id_Empresa out 

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

  if @ram_id_circuitocontable <> 0 begin

  --  exec sp_ArbGetGroups @ram_id_circuitocontable, @clienteID, @@us_id

    exec sp_ArbIsRaiz @ram_id_circuitocontable, @IsRaiz out
    if @IsRaiz = 0 begin
      exec sp_ArbGetAllHojas @ram_id_circuitocontable, @clienteID 
    end else 
      set @ram_id_circuitocontable = 0
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

  /*- ///////////////////////////////////////////////////////////////////////

  CURSOR SOBRE MESES

  /////////////////////////////////////////////////////////////////////// */

  declare c_meses insensitive cursor for select desde, hasta from #t_meses

  open c_meses

  declare @desde datetime
  declare @hasta datetime

  declare @neto        decimal(18,6)
  declare @impuestos  decimal(18,6) 
  declare @total      decimal(18,6)

  fetch next from c_meses into @desde, @hasta
  while @@fetch_status=0
  begin

    set @neto        =0
    set @impuestos  =0
    set @total      =0

    -- Venta del mes

          select 

              @neto        = sum(case fv.doct_id when 7 then -fv_neto else fv_neto end),
              @impuestos  = sum(case fv.doct_id when 7 then -fv_ivari+fv_totalpercepciones else fv_ivari+fv_totalpercepciones end),
              @total      = sum(case fv.doct_id when 7 then -fv_total else fv_total end)

          from 

            FacturaVenta fv inner join Documento doc on fv.doc_id = doc.doc_id
                            
          where 
                  fv_fecha between @desde and @hasta

              and fv.est_id <> 7

              and (
                    exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
                  )

              and   (fv.cli_id     = @cli_id   or @cli_id  =0)
              and   (fv.suc_id     = @suc_id   or @suc_id  =0)
              and   (doc.cico_id  = @cico_id  or @cico_id =0)
              and   (doc.emp_id   = @emp_id   or @emp_id  =0) 

              -- Arboles
              and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 28 and  rptarb_hojaid = fv.cli_id) ) or (@ram_id_Cliente = 0))
              and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 1007 and  rptarb_hojaid = fv.suc_id) ) or (@ram_id_Sucursal = 0))
              and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 1016 and  rptarb_hojaid = doc.cico_id) ) or (@ram_id_circuitocontable = 0))
              and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 1018 and  rptarb_hojaid = doc.emp_id) ) or (@ram_id_Empresa = 0))

    --

    update #t_meses set

                        neto        =@neto,
                        impuestos    =@impuestos,
                        total        =@total

    where desde = @desde and hasta = @hasta

    fetch next from c_meses into @desde, @hasta
  end

  close c_meses
  deallocate c_meses

  /*- ///////////////////////////////////////////////////////////////////////

  SELECT DE RETORNO

  /////////////////////////////////////////////////////////////////////// */

  select 
          convert(varchar,anio)+'-'+right('00'+convert(varchar,mes),2) as desde,
          neto,
          impuestos,
          total

  from #t_meses order by desde

end
go
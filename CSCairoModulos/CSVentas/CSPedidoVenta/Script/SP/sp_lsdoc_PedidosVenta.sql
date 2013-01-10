if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_PedidosVenta]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_PedidosVenta]
go

/*
select * from pedidoventa

sp_docpedidoventaget 47

sp_lsdoc_PedidosVenta

  7,
  '20030101',
  '20500101',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0'

*/

create procedure sp_lsdoc_PedidosVenta (

  @@us_id    int,
  @@Fini      datetime,
  @@Ffin      datetime,

@@cli_id  varchar(255),
@@est_id  varchar(255),
@@ccos_id  varchar(255),
@@suc_id  varchar(255),
@@ven_id  varchar(255),
@@doc_id  varchar(255),
@@cpg_id  varchar(255),
@@emp_id  varchar(255)
)as 

begin

  set nocount on

  /*- ///////////////////////////////////////////////////////////////////////
  
  INICIO PRIMERA PARTE DE ARBOLES
  
  /////////////////////////////////////////////////////////////////////// */
  
  declare @cli_id int
  declare @ccos_id int
  declare @suc_id int
  declare @est_id int
  declare @ven_id int
  declare @doc_id int
  declare @cpg_id int
  declare @emp_id int
  
  declare @ram_id_Cliente int
  declare @ram_id_CentroCosto int
  declare @ram_id_Sucursal int
  declare @ram_id_Estado int
  declare @ram_id_Vendedor int
  declare @ram_id_Documento int
  declare @ram_id_CondicionPago int 
  declare @ram_id_Empresa int 
  
  declare @clienteID int
  declare @IsRaiz    tinyint
  
  exec sp_ArbConvertId @@cli_id, @cli_id out, @ram_id_Cliente out
  exec sp_ArbConvertId @@ccos_id, @ccos_id out, @ram_id_CentroCosto out
  exec sp_ArbConvertId @@suc_id, @suc_id out, @ram_id_Sucursal out
  exec sp_ArbConvertId @@est_id, @est_id out, @ram_id_Estado out
  exec sp_ArbConvertId @@ven_id, @ven_id out, @ram_id_Vendedor out
  exec sp_ArbConvertId @@doc_id, @doc_id out, @ram_id_Documento out
  exec sp_ArbConvertId @@cpg_id, @cpg_id out, @ram_id_CondicionPago out 
  exec sp_ArbConvertId @@emp_id, @emp_id out, @ram_id_Empresa out 
  
  exec sp_GetRptId @clienteID out
  
  if @ram_id_Cliente <> 0 begin
  
  --  exec sp_ArbGetGroups @ram_id_Cliente, @clienteID, @@us_id
  
    exec sp_ArbIsRaiz @ram_id_Cliente, @IsRaiz out
    if @IsRaiz = 0 begin
      exec sp_ArbGetAllHojas @ram_id_Cliente, @clienteID 
    end else 
      set @ram_id_Cliente = 0
  end
  
  if @ram_id_CentroCosto <> 0 begin
  
  --  exec sp_ArbGetGroups @ram_id_CentroCosto, @clienteID, @@us_id
  
    exec sp_ArbIsRaiz @ram_id_CentroCosto, @IsRaiz out
    if @IsRaiz = 0 begin
      exec sp_ArbGetAllHojas @ram_id_CentroCosto, @clienteID 
    end else 
      set @ram_id_CentroCosto = 0
  end
  
  if @ram_id_Estado <> 0 begin
  
  --  exec sp_ArbGetGroups @ram_id_Estado, @clienteID, @@us_id
  
    exec sp_ArbIsRaiz @ram_id_Estado, @IsRaiz out
    if @IsRaiz = 0 begin
      exec sp_ArbGetAllHojas @ram_id_Estado, @clienteID 
    end else 
      set @ram_id_Estado = 0
  end
  
  if @ram_id_Sucursal <> 0 begin
  
  --  exec sp_ArbGetGroups @ram_id_Sucursal, @clienteID, @@us_id
  
    exec sp_ArbIsRaiz @ram_id_Sucursal, @IsRaiz out
    if @IsRaiz = 0 begin
      exec sp_ArbGetAllHojas @ram_id_Sucursal, @clienteID 
    end else 
      set @ram_id_Sucursal = 0
  end
  
  if @ram_id_Vendedor <> 0 begin
  
  --  exec sp_ArbGetGroups @ram_id_Vendedor, @clienteID, @@us_id
  
    exec sp_ArbIsRaiz @ram_id_Vendedor, @IsRaiz out
    if @IsRaiz = 0 begin
      exec sp_ArbGetAllHojas @ram_id_Vendedor, @clienteID 
    end else 
      set @ram_id_Vendedor = 0
  end
  
  if @ram_id_Documento <> 0 begin
  
  --  exec sp_ArbGetGroups @ram_id_Documento, @clienteID, @@us_id
  
    exec sp_ArbIsRaiz @ram_id_Documento, @IsRaiz out
    if @IsRaiz = 0 begin
      exec sp_ArbGetAllHojas @ram_id_Documento, @clienteID 
    end else 
      set @ram_id_Documento = 0
  end
  
  if @ram_id_CondicionPago <> 0 begin
  
  --  exec sp_ArbGetGroups @ram_id_CondicionPago, @clienteID, @@us_id
  
    exec sp_ArbIsRaiz @ram_id_CondicionPago, @IsRaiz out
    if @IsRaiz = 0 begin
      exec sp_ArbGetAllHojas @ram_id_CondicionPago, @clienteID 
    end else 
      set @ram_id_CondicionPago = 0
  end
  
  if @ram_id_empresa <> 0 begin
  
  --  exec sp_ArbGetGroups @ram_id_empresa, @clienteID, @@us_id
  
    exec sp_ArbIsRaiz @ram_id_empresa, @IsRaiz out
    if @IsRaiz = 0 begin
      exec sp_ArbGetAllHojas @ram_id_empresa, @clienteID 
    end else 
      set @ram_id_empresa = 0
  end
  
  /*- ///////////////////////////////////////////////////////////////////////
  
  FIN PRIMERA PARTE DE ARBOLES
  
  /////////////////////////////////////////////////////////////////////// */
  
  
  --/////////////////////////////////////////////////////////////////////////
  --
  -- Preguntas de comunidad
  --
  
    create table #t_pedidos (pv_id int)
  
    insert into #t_pedidos
    select pv_id
    from PedidoVenta pv
    where 
    
              @@Fini <= pv_fecha
          and  @@Ffin >= pv_fecha     
    
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (pv.cli_id = @cli_id or @cli_id=0)
    and   (pv.est_id = @est_id or @est_id=0)
    and   (pv.suc_id = @suc_id or @suc_id=0)
    and   (pv.doc_id = @doc_id or @doc_id=0)
    and   (pv.cpg_id = @cpg_id or @cpg_id=0) 
    and   (pv.ccos_id = @ccos_id or @ccos_id=0)
    and   (pv.ven_id = @ven_id or @ven_id=0)
    and   (pv.emp_id = @emp_id or @emp_id=0)
    
    -- Arboles
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 28 
                      and  rptarb_hojaid = pv.cli_id
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
                      and  tbl_id = 21 
                      and  rptarb_hojaid = pv.ccos_id
                     ) 
               )
            or 
               (@ram_id_CentroCosto = 0)
           )
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 4005 
                      and  rptarb_hojaid = pv.est_id
                     ) 
               )
            or 
               (@ram_id_Estado = 0)
           )
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 1007 
                      and  rptarb_hojaid = pv.suc_id
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
                      and  tbl_id = 15 
                      and  rptarb_hojaid = pv.ven_id
                     ) 
               )
            or 
               (@ram_id_Vendedor = 0)
           )
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 4001 
                      and  rptarb_hojaid = pv.doc_id
                     ) 
               )
            or 
               (@ram_id_Documento = 0)
           )
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 1005 
                      and  rptarb_hojaid = pv.cpg_id
                     ) 
               )
            or 
               (@ram_id_CondicionPago = 0)
           )
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 1018 
                      and  rptarb_hojaid = pv.emp_id
                     ) 
               )
            or 
               (@ram_id_empresa = 0)
           )
    
    
    create table #t_preguntas (pv_id int, preguntas varchar(7000) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL)
    
    declare c_preguntas insensitive cursor for 
    
      select pv.pv_id, cmip_pregunta, cmip_respuesta   
      from #t_pedidos pv  inner join PedidoVenta pvc on pv.pv_id = pvc.pv_id 
                          inner join Cliente cli on pvc.cli_id = cli.cli_id 
                          inner join ComunidadInternetPregunta cmip 
                          on replace(cli_codigocomunidad,'(ML)#','') = cmip_nick
      where pvc.creado >= cmip_fecha
      order by pv.pv_id
    
    open c_preguntas
    
    declare @pv_id      int
    declare @last_pv_id int
    declare @pregunta    varchar(4000)
    declare @respuesta  varchar(4000)
    declare @preguntas  varchar(7000)
    
    set @last_pv_id = 0
    fetch next from c_preguntas into @pv_id, @pregunta, @respuesta
    while @@fetch_status=0
    begin
  
      if @last_pv_id <> @pv_id begin
  
        if @last_pv_id <> 0 begin
          insert into #t_preguntas (pv_id, preguntas) values (@pv_id, char(10)+char(13)+@preguntas)
        end
        
        set @preguntas = ''
        set @last_pv_id = @pv_id
  
      end
  
      set @preguntas = @preguntas + @pregunta + char(10)+char(13)
  
      if @respuesta <> '' set set @preguntas = @preguntas + 'Respuesta: ' + @respuesta + char(10)+char(13)
    
      fetch next from c_preguntas into @pv_id, @pregunta, @respuesta
    end
    
    close c_preguntas
    deallocate c_preguntas
  
    if @last_pv_id <> 0 begin
      insert into #t_preguntas (pv_id, preguntas) values (@pv_id, char(10)+char(13)+@preguntas)
    end
  
  
  --/////////////////////////////////////////////////////////////////////////
  
  select 
        pedidoventa.pv_id,
        ''                    as [TypeTask],
        pv_numero             as [Número],
        pv_nrodoc              as [Comprobante],
        cli_nombre            as [Cliente],
        cli_codigo            as [Codigo],
        cli_codigocomunidad   as [Codigo Com.],
        cli_email             as [Mail],
        doc_nombre            as [Documento],
        est_nombre            as [Estado],
        case pv_cvxi_calificado when 0 then 'No' else 'Si' end as Calificado,
        pv_fecha              as [Fecha],
        pv_fechaentrega        as [Fecha de entrega],
        case impreso
          when 0 then 'No'
          else        'Si'
        end                    as [Impreso],
        pv_neto                as [Neto],
        pv_ivari              as [IVA RI],
        pv_ivarni              as [IVA RNI],
        pv_subtotal            as [Subtotal],
        pv_total              as [Total],
        pv_pendiente          as [Pendiente],
        case pv_firmado
          when 0 then 'No'
          else        'Si'
        end                    as [Firmado],
        
        pv_descuento1          as [% Desc. 1],
        pv_descuento2          as [% Desc. 2],
        pv_importedesc1        as [Desc. 1],
        pv_importedesc2        as [Desc. 2],
  
        lp_nombre              as [Lista de Precios],
        ld_nombre              as [Lista de descuentos],
        cpg_nombre            as [Condicion de Pago],
        ccos_nombre            as [Centro de costo],
        suc_nombre            as [Sucursal],
        emp_nombre            as [Empresa],
  
        PedidoVenta.Creado,
        PedidoVenta.Modificado,
        us_nombre             as [Modifico],
        pv_descrip + isnull(preguntas,'')
                              as [Observaciones]
  from 
        pedidoventa inner join documento     on pedidoventa.doc_id   = documento.doc_id
                    inner join empresa       on documento.emp_id     = empresa.emp_id
                    inner join condicionpago on pedidoventa.cpg_id   = condicionpago.cpg_id
                    inner join estado        on pedidoventa.est_id   = estado.est_id
                    inner join sucursal      on pedidoventa.suc_id   = sucursal.suc_id
                    inner join cliente       on pedidoventa.cli_id   = cliente.cli_id
                    inner join usuario       on pedidoventa.modifico = usuario.us_id
                    left join vendedor       on pedidoventa.ven_id   = vendedor.ven_id
                    left join centrocosto    on pedidoventa.ccos_id  = centrocosto.ccos_id
                    left join listaprecio    on pedidoventa.lp_id    = listaprecio.lp_id
                    left join listadescuento on pedidoventa.ld_id    = listadescuento.ld_id
                    left join #t_preguntas t on pedidoventa.pv_id    = t.pv_id
  
    where pedidoventa.pv_id in (select pv_id from #t_pedidos)
  
    order by pv_fecha
  
end
GO

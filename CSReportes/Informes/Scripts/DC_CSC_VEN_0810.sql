/*---------------------------------------------------------------------
Nombre: Ventas por Cliente y Numero
---------------------------------------------------------------------*/
/*

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_0810]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_0810]


-- exec [DC_CSC_VEN_0810] 1,'20080101 00:00:00','20090601 00:00:00','0','0','0','0','0',0
-- exec [DC_CSC_VEN_0810] 1,'20110101 00:00:00','20111231 00:00:00','0','0','0','0','0','0',0


go
create procedure DC_CSC_VEN_0810 (

  @@us_id    int,
  @@Fini      datetime,
  @@Ffin      datetime,

  @@cli_id          varchar(255),
  @@ccos_id         varchar(255),
  @@cico_id          varchar(255),
  @@est_id          varchar(255),
  @@emp_id          varchar(255),
  @@ccos_id_exc     varchar(255),

  @@resumido        smallint

)as 

begin

set nocount on

declare @cli_id        int
declare @ccos_id       int
declare @cico_id       int
declare @est_id        int
declare @emp_id        int 
declare @ccos_id_exc  int

declare @ram_id_cliente            int
declare @ram_id_centrocosto       int
declare @ram_id_circuitocontable   int
declare @ram_id_Estado             int
declare @ram_id_Empresa            int 
declare @ram_id_centrocosto_exc   int

declare @clienteID     int
declare @clienteID2   int
declare @IsRaiz        tinyint

exec sp_ArbConvertId @@cli_id,        @cli_id out,      @ram_id_cliente out
exec sp_ArbConvertId @@ccos_id,       @ccos_id out,     @ram_id_centrocosto out
exec sp_ArbConvertId @@cico_id,       @cico_id out,     @ram_id_circuitocontable out
exec sp_ArbConvertId @@est_id,        @est_id out,      @ram_id_Estado out
exec sp_ArbConvertId @@emp_id,         @emp_id out,       @ram_id_Empresa out 
exec sp_ArbConvertId @@ccos_id_exc,    @ccos_id_exc out, @ram_id_centrocosto_exc out

exec sp_GetRptId @clienteID out
exec sp_GetRptId @clienteID2 out

if @ram_id_cliente <> 0 begin

--  exec sp_ArbGetGroups @ram_id_cliente, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_cliente, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_cliente, @clienteID 
  end else 
    set @ram_id_cliente = 0
end

if @ram_id_centrocosto <> 0 begin

--  exec sp_ArbGetGroups @ram_id_centrocosto, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_centrocosto, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_centrocosto, @clienteID 
  end else 
    set @ram_id_centrocosto = 0
end

if @ram_id_circuitocontable <> 0 begin

--  exec sp_ArbGetGroups @ram_id_circuitocontable, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_circuitocontable, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_circuitocontable, @clienteID 
  end else 
    set @ram_id_circuitocontable = 0
end

if @ram_id_Estado <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Estado, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Estado, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Estado, @clienteID 
  end else 
    set @ram_id_Estado = 0
end

if @ram_id_centrocosto_exc <> 0 begin

--  exec sp_ArbGetGroups @ram_id_centrocosto_exc, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_centrocosto_exc, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_centrocosto_exc, @clienteID2 
  end else 
    set @ram_id_centrocosto_exc = 0
end

if @ram_id_Empresa <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Empresa, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Empresa, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Empresa, @clienteID 
  end else 
    set @ram_id_Empresa = 0
end

/*

1- Debemos crear una tabla con doce columnas para meses (por que en la hoja solo entran 12)
    
2- Obtengo todas las ventas por cliente

3- Presento la info

*/


/*- ///////////////////////////////////////////////////////////////////////

SEGURIDAD SOBRE USUARIOS EXTERNOS

/////////////////////////////////////////////////////////////////////// */

declare @us_empresaEx tinyint
select @us_empresaEx = us_empresaEx from usuario where us_id = @@us_id  

/*- ///////////////////////////////////////////////////////////////////////

CODIGO DEL REPORTE

/////////////////////////////////////////////////////////////////////// */

-- Debemos crear una tabla con doce columnas para meses (por que en la hoja solo entran 12)

create table #t_meses(

                        cli_id    int,

                        mes1            varchar(50),
                        mes2            varchar(50),
                        mes3            varchar(50),
                        mes4            varchar(50),
                        mes5            varchar(50),
                        mes6            varchar(50),
                        mes7            varchar(50),
                        mes8            varchar(50),
                        mes9            varchar(50),
                        mes10            varchar(50),
                        mes11            varchar(50),
                        mes12            varchar(50),

                        imes1            decimal(18,6) not null default(0),
                        imes2            decimal(18,6) not null default(0),
                        imes3            decimal(18,6) not null default(0),
                        imes4            decimal(18,6) not null default(0),
                        imes5            decimal(18,6) not null default(0),
                        imes6            decimal(18,6) not null default(0),
                        imes7            decimal(18,6) not null default(0),
                        imes8            decimal(18,6) not null default(0),
                        imes9            decimal(18,6) not null default(0),
                        imes10          decimal(18,6) not null default(0),
                        imes11          decimal(18,6) not null default(0),
                        imes12          decimal(18,6) not null default(0),

                        Total           decimal(18,6) not null default(0)                        
                      )


declare @mes       varchar(7)
declare @importe   decimal(18,6)

create table #t_ventas (cli_id int, importe decimal(18,6), mes varchar(10))

/*- ///////////////////////////////////////////////////////////////////////

      OBTENTO LAS VENTAS

/////////////////////////////////////////////////////////////////////// */

    insert into #t_ventas(cli_id, importe, mes)
    
      select   fv.cli_id, 
              sum(case fv.doct_id when 7 then -fv_neto else fv_neto end),
              convert(varchar(7),fv_fecha,111)
    
      from FacturaVenta fv inner join Documento doc on fv.doc_id = doc.doc_id
      where fv_fecha between @@Fini and @@Ffin

        and est_id <> 7
    
        and (fv.cli_id     = @cli_id     or @cli_id  =0)
        and (fv.ccos_id   = @ccos_id     or @ccos_id  =0)
        and (doc.cico_id   = @cico_id     or @cico_id  =0)
        and (fv.est_id     = @est_id     or @est_id  =0)
        and (fv.emp_id     = @emp_id     or @emp_id  =0)
        and (isnull(fv.ccos_id,0)  <> @ccos_id_exc or @ccos_id_exc  =0) 
      
        -- Arboles

        and   (
                  (exists(select rptarb_hojaid 
                          from rptArbolRamaHoja 
                          where
                               rptarb_cliente = @clienteID
                          and  tbl_id = 28 
                          and  rptarb_hojaid = fv.cli_id
                         ) 
                   )
                or 
                   (@ram_id_cliente = 0)
               )
        
        and   (
                  (exists(select rptarb_hojaid 
                          from rptArbolRamaHoja 
                          where
                               rptarb_cliente = @clienteID
                          and  tbl_id = 21 
                          and  rptarb_hojaid = fv.ccos_id
                         ) 
                   )
                or 
                   (@ram_id_centrocosto = 0)
               )
        
        and   (
                  (exists(select rptarb_hojaid 
                          from rptArbolRamaHoja 
                          where
                               rptarb_cliente = @clienteID
                          and  tbl_id = 1016 
                          and  rptarb_hojaid = doc.cico_id
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
                          and  tbl_id = 4005
                          and  rptarb_hojaid = fv.est_id
                         ) 
                   )
                or 
                   (@ram_id_Estado = 0)
               )
    
        and   (
                  (exists(select rptarb_hojaid 
                          from rptArbolRamaHoja 
                          where
                               rptarb_cliente = @clienteID2
                          and  tbl_id = 1018 
                          and  rptarb_hojaid = fv.emp_id
                         ) 
                   )
                or 
                   (@ram_id_Empresa = 0)
               )

        -------------------------------------------------------
        -- a Excluir
        and   (
                  (not exists(select rptarb_hojaid 
                          from rptArbolRamaHoja 
                          where
                               rptarb_cliente = @clienteID
                          and  tbl_id = 21
                          and  rptarb_hojaid = fv.ccos_id
                         ) 
                   )
                or 
                   (@ram_id_centrocosto = 0)
               )

    
      group by fv.cli_id, convert(varchar(7),fv_fecha,111)
        
    /*- ///////////////////////////////////////////////////////////////////////
    
          TABLA DE RESULTADOS
    
    /////////////////////////////////////////////////////////////////////// */
    
        -- Cargo la tabla de resultados
        -- 
        
          -- Esto es para todos:
          --
          --    Por cada fila necesito crear tantos meses como existan entre Fini y Ffin
          --
        
        set @cli_id  = null
        
          declare c_ventas insensitive cursor for
        
            select distinct t.cli_id
            from #t_ventas t
        
          open c_ventas
          
          fetch next from c_ventas into @cli_id
          while @@fetch_status=0
          begin
        
            exec DC_CSC_VEN_0810_aux @@Fini, @@Ffin, @cli_id
        
            fetch next from c_ventas into @cli_id
          end
        
          close c_ventas
          deallocate c_ventas
        
          declare c_ventas insensitive cursor for
        
            select cli_id, importe, mes
            from #t_ventas
            order by cli_id
        
          open c_ventas
          fetch next from c_ventas into @cli_id, @importe, @mes
          while @@fetch_status=0
          begin
        
            exec DC_CSC_VEN_0810_aux2 @cli_id, 
                                      @mes,
                                      @importe
        
            fetch next from c_ventas into @cli_id, @importe, @mes
          end
        
          close c_ventas
          deallocate c_ventas

-- Actualizo la columna de totales por fila
--
  update #t_meses set total = imes1+
                              imes2+
                              imes3+
                              imes4+
                              imes5+
                              imes6+
                              imes7+
                              imes8+
                              imes9+
                              imes10+
                              imes11+
                              imes12
    
/*- ///////////////////////////////////////////////////////////////////////

      SELECT DE RETORNO

/////////////////////////////////////////////////////////////////////// */

    --3- Presento la info
    --
    
    select t.*,
           cli_nombre
    
    from #t_meses t 
    
        left join Cliente cli on t.cli_id = cli.cli_id
    
    order by mes1, cli_nombre

end

GO
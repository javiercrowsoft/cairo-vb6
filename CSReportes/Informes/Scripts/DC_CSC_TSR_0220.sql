/*---------------------------------------------------------------------
Nombre: Ingresos y Egresos 12 meses
---------------------------------------------------------------------*/
/*

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_TSR_0220]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_TSR_0220]


-- exec [DC_CSC_TSR_0220] 3,'20080101 00:00:00','20090601 00:00:00',0,'N82547','0','0','N82550','N82557',0

go
create procedure DC_CSC_TSR_0220 (

  @@us_id    int,
  @@Fini      datetime,
  @@Ffin      datetime,

  @@rub_id_inversiones   int,
  @@cue_id                varchar(255),
  @@pr_id_cmp            varchar(255),
  @@pr_id_inc           varchar(255),
  @@pr_id_exc           varchar(255),
  @@pr_id_exc_vta       varchar(255),
  @@ccos_id_exc          varchar(255),
  @@resumido            smallint

)as 

begin

set nocount on

declare @cue_id           int
declare @pr_id_cmp        int
declare @pr_id_inc        int
declare @pr_id_exc        int
declare @pr_id_exc_vta    int
declare @ccos_id_exc      int

declare @ram_id_cuenta             int
declare @ram_id_producto_cmp      int
declare @ram_id_producto_inc      int
declare @ram_id_producto_exc      int
declare @ram_id_producto_exc_vta  int
declare @ram_id_centrocosto_exc    int

declare @clienteID     int
declare @clienteID2   int
declare @clienteID3   int
declare @clienteID4   int
declare @IsRaiz        tinyint

exec sp_ArbConvertId @@cue_id,         @cue_id out,          @ram_id_cuenta out
exec sp_ArbConvertId @@pr_id_cmp,      @pr_id_cmp out,        @ram_id_producto_cmp out
exec sp_ArbConvertId @@pr_id_inc,      @pr_id_inc out,        @ram_id_producto_inc out
exec sp_ArbConvertId @@pr_id_exc,      @pr_id_exc out,        @ram_id_producto_exc out
exec sp_ArbConvertId @@pr_id_exc_vta, @pr_id_exc_vta out,    @ram_id_producto_exc_vta out
exec sp_ArbConvertId @@ccos_id_exc,   @ccos_id_exc out,     @ram_id_centrocosto_exc out

exec sp_GetRptId @clienteID out
exec sp_GetRptId @clienteID2 out
exec sp_GetRptId @clienteID3 out
exec sp_GetRptId @clienteID4 out

if @ram_id_cuenta <> 0 begin

--  exec sp_ArbGetGroups @ram_id_cuenta, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_cuenta, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_cuenta, @clienteID 
  end else 
    set @ram_id_cuenta = 0
end

if @ram_id_producto_cmp <> 0 begin

--  exec sp_ArbGetGroups @ram_id_producto_cmp, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_producto_cmp, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_producto_cmp, @clienteID3 
  end else 
    set @ram_id_producto_cmp = 0
end

if @ram_id_producto_inc <> 0 begin

--  exec sp_ArbGetGroups @ram_id_producto_inc, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_producto_inc, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_producto_inc, @clienteID 
  end else 
    set @ram_id_producto_inc = 0
end

if @ram_id_producto_exc <> 0 begin

--  exec sp_ArbGetGroups @ram_id_producto_exc, @clienteID2, @@us_id

  exec sp_ArbIsRaiz @ram_id_producto_exc, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_producto_exc, @clienteID2 
  end else 
    set @ram_id_producto_exc = 0
end

if @ram_id_producto_exc_vta <> 0 begin

--  exec sp_ArbGetGroups @ram_id_producto_vta, @clienteID2, @@us_id

  exec sp_ArbIsRaiz @ram_id_producto_exc_vta, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_producto_exc_vta, @clienteID4 
  end else 
    set @ram_id_producto_exc_vta = 0
end

if @ram_id_centrocosto_exc <> 0 begin

--  exec sp_ArbGetGroups @ram_id_centrocosto_exc, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_centrocosto_exc, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_centrocosto_exc, @clienteID 
  end else 
    set @ram_id_centrocosto_exc = 0
end

/*

1- Debemos crear una tabla con doce columnas para meses (por que en la hoja solo entran 12)
    
2- Obtengo todos los costos por articulo de venta
  2.1- Cargo la tabla de resultados

3- Obtengo todos los costos por articulo de compra por compras
  3.1- Cargo la tabla de resultados

4- Obtengo todos los costos por articulo de compra por gastos
  4.1- Cargo la tabla de resultados

5- Presento la info

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

                        tipo      int, /*1 Ventas - 2 Compras - 3 Gastos*/

                        pr_id     int,
                        cue_id    int,

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
declare @pr_id     int

create table #t_costos (pr_id int, cue_id int, importe decimal(18,6), mes varchar(10))


/*- ///////////////////////////////////////////////////////////////////////

      VENTAS

/////////////////////////////////////////////////////////////////////// */

  exec DC_CSC_TSR_0220_aux6

                              0,--@pr_id_inc    ,
                              @pr_id_exc_vta    ,
                              @clienteID    ,
                              @clienteID4    ,
                            
                              0,--@ram_id_producto_inc   ,
                              @ram_id_producto_exc_vta,
                              0,--@ram_id_cuenta        ,
                            
                              @@Fini      ,
                              @@Ffin      ,
                            
                              1 /*ventas*/

/*- ///////////////////////////////////////////////////////////////////////

      COMPRAS

/////////////////////////////////////////////////////////////////////// */

  delete #t_costos

  exec DC_CSC_TSR_0220_aux5

                              @pr_id_cmp    ,
                              @pr_id_exc    ,
                              @@pr_id_inc    ,

                              @clienteID3    ,
                              @clienteID2    ,
                              @clienteID    ,
                            
                              @ram_id_producto_cmp   ,
                              @ram_id_producto_exc  ,
                              @ram_id_producto_inc  ,
                              0                      ,
                            
                              @@Fini      ,
                              @@Ffin      ,
                            
                              2 /*compras*/


/*- ///////////////////////////////////////////////////////////////////////

      GASTOS

/////////////////////////////////////////////////////////////////////// */

  delete #t_costos

  exec DC_CSC_TSR_0220_aux4

                              @cue_id        ,
                              @pr_id_inc    ,
                              @pr_id_exc    ,
                              @ccos_id_exc  ,

                              @clienteID    ,
                              @clienteID2    ,
                            
                              @ram_id_producto_inc   ,
                              @ram_id_producto_exc   ,
                              @ram_id_cuenta        ,
                              @ram_id_centrocosto_exc,
                            
                              @@Fini      ,
                              @@Ffin      ,
                            
                              3 /*gastos*/


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

    --4- Presento la info
    --
    
    select t.*,
           case tipo   
                  when 1 then 'Ventas'
                  when 2 then 'Compras'
                  when 3 then 'Gastos'
           end  as tipo_nombre,

           case tipo
              when 1 then  pr_nombreventa
              when 2 then isnull(pr_nombrecompra,cue_nombre) 
              when 3 then 'Gastos'
           end                  as pr_nombrecompra,

           case 
              when t.pr_id is null 
                  and cue_codigorpt = '' then '(sin rubro)'
              when t.pr_id is null        then cue_codigorpt 
              else                             isnull(rub_nombre,'(sin rubro)')
           end                   as rub_nombre,
    
           case 
              when t.pr_id is null 
                  and cue_codigorpt = '' then '(sin rubro)'
              when t.pr_id is null        then cue_codigorpt 
              else                             isnull(rub_nombre,'(sin rubro)')
           end                   as group_id,
    
           isnull(pr.rub_id,0)   as rub_id
    
    from #t_meses t 
    
        left join Producto pr on t.pr_id = pr.pr_id
        left join Cuenta cue on t.cue_id = cue.cue_id
        left join Rubro rub on pr.rub_id = rub.rub_id
    
    order by mes1, tipo, group_id, pr_nombrecompra

end

GO
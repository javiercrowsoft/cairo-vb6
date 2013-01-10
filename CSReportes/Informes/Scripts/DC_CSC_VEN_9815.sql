/*

[DC_CSC_VEN_9815] 79,'102','0',0

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_9815]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_9815]

go
create procedure DC_CSC_VEN_9815 (

@@us_id         int,

@@lp_id          varchar(255),
@@pr_id          varchar(255),
@@bIva          smallint

)as 
begin

  set nocount on

--/////////////////////////////////////////////////////////////////////////////////
-- Arboles
--/////////////////////////////////////////////////////////////////////////////////

  declare @lp_id int
  declare @pr_id int
  declare @Ram_id_ListaPrecio int
  declare @Ram_id_Producto    int
  
  declare @clienteID   int
  declare @IsRaiz     tinyint

  exec sp_ArbConvertId @@lp_id, @lp_id out, @Ram_id_ListaPrecio out
  exec sp_ArbConvertId @@pr_id, @pr_id out, @Ram_id_Producto out
  
  if @Ram_id_ListaPrecio <> 0 or @Ram_id_Producto <> 0 begin

    exec sp_GetRptId @clienteID out

    if @Ram_id_ListaPrecio <> 0 begin  
      exec sp_ArbIsRaiz @Ram_id_ListaPrecio, @IsRaiz out
      if @IsRaiz = 0  exec sp_ArbGetAllHojas @Ram_id_ListaPrecio, @clienteID
      else            set @Ram_id_ListaPrecio = 0
    end

    if @Ram_id_Producto <> 0 begin  
      exec sp_ArbIsRaiz @Ram_id_Producto, @IsRaiz out
      if @IsRaiz = 0  exec sp_ArbGetAllHojas @Ram_id_Producto, @clienteID
      else            set @Ram_id_Producto = 0
    end
  
  end else begin
  
    set @clienteID = 0
  
  end

--/////////////////////////////////////////////////////////////////////////////////
-- Que productos van en que lista
--/////////////////////////////////////////////////////////////////////////////////

  declare @t        int
  declare @lp_id_pr int

  create table #productos(pr_id int, lp_id int)
  create table #lps(lp_id int, t int)

  declare c_listas insensitive cursor for select lp_id from ListaPrecio 
  where 
        (ListaPrecio.lp_id     = @lp_id or @lp_id=0)
  
  -- Arboles
  and   (
            (exists(select rptarb_hojaid 
                    from rptArbolRamaHoja 
                    where
                         rptarb_cliente = @clienteID
                    and  tbl_id = 27 
                    and  rptarb_hojaid = ListaPrecio.lp_id
                   ) 
             )
          or 
             (@Ram_id_ListaPrecio = 0)
         )
  open c_listas

  fetch next from c_listas into @lp_id_pr
  while @@fetch_status=0 
  begin

    delete #lps

    set @t=1

    -- Inserto los productos mencionados por la lista
    -- que no tienen precio definido, osea solo indican 
    -- un porcentaje sobre listas base
    --
    insert into #productos(pr_id,lp_id) 
    select pr_id,@lp_id_pr from ListaPrecioItem where lp_id = @lp_id_pr and lpi_precio = 0
    
    -- Obtengo las litas bases
    --
    insert into #lps(lp_id,t) select lp_id_padre,@t from listaprecio where lp_id = @lp_id_pr and lp_id_padre is not null
    insert into #lps(lp_id,t) select lp_id_padre,@t from listapreciolista where lp_id = @lp_id_pr

    -- Mientras existan listas base sin procesar
    --
    while exists(select * from #lps where t = @t and @t < 20) -- Pongo un tope de 20 por control para evitar un bucle sin fin
    begin

      insert into #productos(pr_id,lp_id) 
      select pr_id,@lp_id_pr from ListaPrecioItem 
      where lp_id in (select lp_id from #lps where t = @t)
        and not exists(select * from #productos 
                        where pr_id = ListaPrecioItem.pr_id
                          and lp_id = @lp_id_pr
                      )
        and   (ListaPrecioItem.pr_id = @pr_id or @pr_id=0)
        and   (
                  (exists(select rptarb_hojaid 
                          from rptArbolRamaHoja 
                          where
                               rptarb_cliente = @clienteID
                          and  tbl_id = 30 
                          and  rptarb_hojaid = ListaPrecioItem.pr_id
                         ) 
                   )
                or 
                   (@Ram_id_Producto = 0)
               )

  
      set @t = @t+1
      -- Obtengo las listas base de las listas base
      --
      insert into #lps(lp_id,t) select lp_id_padre,@t from listaprecio where lp_id in (select lp_id from #lps where t = @t-1)
      insert into #lps(lp_id,t) select lp_id_padre,@t from listapreciolista where lp_id in (select lp_id from #lps where t = @t-1)
    end

    -- Proceso la siguiente lista seleccionada por el usuario
    --
    fetch next from c_listas into @lp_id_pr
  end

  close c_listas
  deallocate c_listas

--/////////////////////////////////////////////////////////////////////////////////
-- Tabla temporal
--/////////////////////////////////////////////////////////////////////////////////
  
  create table #tmpListaPrecio(
    lp_id           int,
    pr_id           int null,
    lpi_precio      decimal(18,6) not null default(0),
    lpi_porcentaje  decimal(18,6) not null default(0)
  )
  
  insert into
  #tmpListaPrecio(
    lp_id,
    pr_id,
    lpi_precio,
    lpi_porcentaje
  )

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Precios propios de cada una de las listas seleccionadas
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  

  select 

  lp.lp_id,
  pr.pr_id,
  isnull(lpi_precio,0),
  isnull(lpi_porcentaje,0)
  
  from 
  
  ListaPrecio lp left join ListaPrecioItem lpi   on lp.lp_id  = lpi.lp_id
                 left join Producto pr           on lpi.pr_id = pr.pr_id
  
  where 
        (lp.lp_id  = @lp_id or @lp_id=0)
  and   (lpi.pr_id = @pr_id or @pr_id=0)

  -- Arboles
  and   (
            (exists(select rptarb_hojaid 
                    from rptArbolRamaHoja 
                    where
                         rptarb_cliente = @clienteID
                    and  tbl_id = 27 
                    and  rptarb_hojaid = lp.lp_id
                   ) 
             )
          or 
             (@Ram_id_ListaPrecio = 0)
         )
  
  and   (
            (exists(select rptarb_hojaid 
                    from rptArbolRamaHoja 
                    where
                         rptarb_cliente = @clienteID
                    and  tbl_id = 30
                    and  rptarb_hojaid = lpi.pr_id
                   ) 
             )
          or 
             (@Ram_id_Producto = 0)
         )

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  union

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Precios de listas bases
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  

  select

  lp.lp_id,
  pr.pr_id,
  0 as lpi_precio,
  0 as lpi_porcentaje
  
  from 
  
  ListaPrecio lp left join #productos pr on lp.lp_id = pr.lp_id 
  
  where 
        (lp.lp_id = @lp_id or @lp_id=0)
  
  -- Arboles
  and   (
            (exists(select rptarb_hojaid 
                    from rptArbolRamaHoja 
                    where
                         rptarb_cliente = @clienteID
                    and  tbl_id = 27 
                    and  rptarb_hojaid = lp.lp_id
                   ) 
             )
          or 
             (@Ram_id_ListaPrecio = 0)
         )
  

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Obtengo los precios de las listas base
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
  
  declare @precio decimal(18,6)
  
  declare c_precio insensitive cursor 
                    for select lp_id, pr_id 
                    from #tmpListaPrecio 
                    where lpi_precio = 0
  
  open c_precio
  
  fetch next from c_precio into @lp_id, @lp_id_pr 
  while @@fetch_status = 0 begin
  
    exec sp_lpGetPrecio @lp_id, @lp_id_pr, @precio out, 0
  
    update #tmpListaPrecio set lpi_precio = @precio where pr_id = @lp_id_pr and lp_id = @lp_id
      
    fetch next from c_precio into @lp_id, @lp_id_pr 
  end
  
  close c_precio
  
  deallocate c_precio

  --///////////////////////////////////////////////////////////////////////////////////////
  --
  --  SELECT DE RETORNO
  --
  
    select 
      pr.pr_id,

      lp.lp_nombre        as [Lista de Precios],
      lp.lp_codigo        as Codigo,

      case lp.lp_tipo 
        when 1 then pr.pr_nombreventa    
        else        pr.pr_nombrecompra  
      end                  as Articulo,

      pr.pr_codigo        as [Art. Codigo],
      pr_aliasweb         as [Alias Web],
      pr_nombreweb        as [Nombre Web],
      pr_nombrefactura    as [Nombre Factura],

      t.lpi_precio         as [Precio sin IVA],

      case @@bIva 
          when 0 then '    No' 
          else         '    Si' 
      end                 as [Iva Incluido],

      case 
        when lp.lp_tipo = 1 and @@bIva <> 0 then t.lpi_precio + t.lpi_precio * (tv.ti_porcentaje /100)
        when lp.lp_tipo = 2 and @@bIva <> 0 then t.lpi_precio + t.lpi_precio * (tc.ti_porcentaje /100)
        when lp.lp_tipo = 3 and @@bIva <> 0 then t.lpi_precio + t.lpi_precio * (tc.ti_porcentaje /100)
        else                                     t.lpi_precio 
      end                 as Precio,


      t.lpi_porcentaje    as Porcentaje,

      isnull(marc_nombre,'')            as Marca,

      isnull(rub.rub_nombre,'')          as Rubro,

      isnull(rubti01.rubti_nombre,'')    as [Atributo 1],
      isnull(rubti02.rubti_nombre,'')    as [Atributo 2],
      isnull(rubti03.rubti_nombre,'')    as [Atributo 3],
      isnull(rubti04.rubti_nombre,'')    as [Atributo 4],
      isnull(rubti05.rubti_nombre,'')    as [Atributo 5],
      isnull(rubti06.rubti_nombre,'')    as [Atributo 6],
      isnull(rubti07.rubti_nombre,'')    as [Atributo 7],
      isnull(rubti08.rubti_nombre,'')    as [Atributo 8],
      isnull(rubti09.rubti_nombre,'')    as [Atributo 9],
      isnull(rubti10.rubti_nombre,'')    as [Atributo 10]

    from #tmpListaPrecio t left join Producto pr           on t.pr_id = pr.pr_id
                           left join ListaPrecio lp        on t.lp_id = lp.lp_id
                           left join TasaImpositiva tc    on pr.ti_id_ivaricompra = tc.ti_id
                           left join TasaImpositiva tv    on pr.ti_id_ivariventa  = tv.ti_id

                            left join Marca marc on pr.marc_id = marc.marc_id
                            left join Rubro rub  on pr.rub_id  = rub.rub_id
                            
                            left join RubroTablaItem rubti01  on pr.rubti_id1  = rubti01.rubti_id
                            left join RubroTablaItem rubti02  on pr.rubti_id2  = rubti02.rubti_id
                            left join RubroTablaItem rubti03  on pr.rubti_id3  = rubti03.rubti_id
                            left join RubroTablaItem rubti04  on pr.rubti_id4  = rubti04.rubti_id
                            left join RubroTablaItem rubti05  on pr.rubti_id5  = rubti05.rubti_id
                            left join RubroTablaItem rubti06  on pr.rubti_id6  = rubti06.rubti_id
                            left join RubroTablaItem rubti07  on pr.rubti_id7  = rubti07.rubti_id
                            left join RubroTablaItem rubti08  on pr.rubti_id8  = rubti08.rubti_id
                            left join RubroTablaItem rubti09  on pr.rubti_id9  = rubti09.rubti_id
                            left join RubroTablaItem rubti10  on pr.rubti_id10 = rubti10.rubti_id

    where 

               (t.pr_id = @pr_id or @pr_id=0)

        and   (
                  (exists(select rptarb_hojaid 
                          from rptArbolRamaHoja 
                          where
                               rptarb_cliente = @clienteID
                          and  tbl_id = 30 
                          and  rptarb_hojaid = t.pr_id
                         ) 
                   )
                or 
                   (@Ram_id_Producto = 0)
               )

end
go
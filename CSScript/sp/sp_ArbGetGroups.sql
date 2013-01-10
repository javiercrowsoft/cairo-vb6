if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ArbGetGroups]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ArbGetGroups]

go
create procedure sp_ArbGetGroups (
  @@clienteId    int,
  @@arbv_id      int,
  @@IsRaiz      tinyint
)
as

set nocount on

begin

  if @@IsRaiz <> 0 begin

      declare @tbl_id int
      select @tbl_id = tbl_id
      from Arbol a inner join ArbolVista av on a.arb_id = av.arb_id
      where av.arbv_id = @@arbv_id

      insert into rptArbolRamaHoja (rptarb_cliente, ram_id, rptarb_hojaid ,tbl_id)
      select @@clienteId, min(r.ram_id), h.id, @tbl_id
      from Rama r inner join ArbolVista a on r.arb_id = a.arb_id
                  inner join Hoja h on r.ram_id = h.ram_id
      where a.arbv_id = @@arbv_id
      group by h.id

  end

  declare @ram_id         int
  declare @ram_id_padre   int
  declare @last_padre     int -- el ultimo padre antes del expandido
  declare @ram_estado     tinyint
  
  declare c_rama_grupos insensitive cursor for
  
    select distinct ram_id from rptArbolRamaHoja where rptarb_cliente = @@clienteId
  
  open c_rama_grupos
  
  fetch next from c_rama_grupos into @ram_id
  while @@fetch_status=0
  begin
  
    if exists(select * from ramavista where ram_id = @ram_id and arbv_id = @@arbv_id and ramv_estado in (0,3) /*colapsada*/) 
    begin
  
      -- Esto es asi por que si el padre esta expandido se tienen que
      -- ver las ramas hijas o sea esta rama que aunque esta colapsada
      -- y por ende no muestra sus hijos, si su padre esta expandido
      -- esta rama si se ve
      --
      set @last_padre = @ram_id
  
      select @ram_id_padre = ram_id_padre from rama where ram_id = @ram_id
      select @ram_estado = ramv_estado from ramavista where ram_id = @ram_id_padre and arbv_id = @@arbv_id
  
      while     @ram_id_padre is not null /*solo cuando ram_id no existe (por que justo borraron la rama)*/
            and @ram_estado not in (1,2) /*expandida*/ 
            and @ram_id_padre <> 0 /*raiz*/
      begin
  
        -- Si el padre no esta expandido voy a su abuelo y asi sigo hasta la raiz
        -- o hasta encontrar una rama expandida
        --
        set @last_padre = @ram_id_padre
        select @ram_id_padre = ram_id_padre from rama where ram_id = @ram_id_padre
        select @ram_estado = ramv_estado from ramavista where ram_id = @ram_id_padre and arbv_id = @@arbv_id
      end
  
      -- Si esta expandida, la rama tiene que quedar en el ultimo padre colapsado
      -- (que puede ser la misma rama o cualquiera de sus ancestros)
      --
      if @ram_estado in (1,2) begin
  
        update rptArbolRamaHoja set ram_id = @last_padre where ram_id = @ram_id 
  
      end else begin
  
        -- Si el padre es la rama 0 (la raiz de todas las ramas)
        -- pongo la raiz de este arbol (es decir @last_padre)
        -- pues significa que la raiz del arbol esta colapsada
        --
        if @ram_id_padre = 0 /*raiz*/ begin
    
          update rptArbolRamaHoja set ram_id = @last_padre where ram_id = @ram_id 
    
        end
  
        -- else @ram_id_padre is null -- no me interesa si la rama fue borrada
  
      end
    end
  
    fetch next from c_rama_grupos into @ram_id
  end
  
  close c_rama_grupos
  deallocate c_rama_grupos

end

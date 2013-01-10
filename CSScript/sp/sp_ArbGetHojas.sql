if exists (select * from sysobjects where id = object_id(N'[dbo].[SP_ArbGetHojas]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SP_ArbGetHojas]

/*

select * from rama where ram_nombre ='clientes'

SP_ArbGetHojas 1945

*/

go
create procedure sp_ArbGetHojas (
  @@ram_id         int,
  @@soloColumnas   int = 0,
  @@aBuscar       varchar(255) ='',
  @@top           int = 3000
)
as

set nocount on

-- 1 Averiguo de que tabla se trata
declare @tabla         varchar(5000)
declare @campoId      varchar(5000)
declare @campoNombre  varchar(255)
declare @campos       varchar(5000)
declare @camposRama    varchar(5000)
declare @tablasRama    varchar(5000)
declare @where        varchar(5000)
declare @prefix        varchar(5000)
declare @sqlstmt      varchar(5000)
declare @sqlstmt2      varchar(5000)
declare @sqlwhere      varchar(5000)
declare @esRaiz        int
declare @arb_id        int


--------------------------------------------------------------------
select   @camposRama  = ramc_valor  from RamaConfig where ram_id = @@ram_id and ramc_aspecto = 'Campos'
select   @tablasRama  = ramc_valor  from RamaConfig where ram_id = @@ram_id and ramc_aspecto = 'Tablas'
select   @prefix      = ramc_valor  from RamaConfig where ram_id = @@ram_id and ramc_aspecto = 'Prefix'
select   @where      = ramc_valor  from RamaConfig where ram_id = @@ram_id and ramc_aspecto = 'where'

if @camposRama is null set @camposRama = ''
if @tablasRama is null set @tablasRama = ''
if @prefix      is null set @prefix = ''
if @where      is null set @where = ''

--------------------------------------------------------------------
select   @tabla             = tbl_nombreFisico,
        @campos           = tbl_camposInView, 
        @campoId          = tbl_campoId,
        @campoNombre      = tbl_campoNombre

  from Arbol,Rama,Tabla 

  where  Arbol.arb_id = Rama.arb_id 
  and   Tabla.tbl_id = Arbol.tbl_id
  and  Rama.ram_id  = @@ram_id

--------------------------------------------------------------------
if ltrim(@camposRama) <> '' set @campos = @camposRama
if ltrim(@prefix) = '' set @prefix = @tabla

--------------------------------------------------------------------

-- armo la sentencia sql
set @sqlstmt = 'select top ' + convert(varchar(20), @@top) + ' hoja_id,' 
set @sqlstmt = @sqlstmt +'ID ='  + @prefix+ '.' + @campoId  +','

if charindex('codigo',@campoNombre,1)<>0
  set @sqlstmt = @sqlstmt +'Codigo = '  + @prefix+ '.' + @campoNombre
else
if charindex('apellido',@campoNombre,1)<>0
  set @sqlstmt = @sqlstmt +'Apellido = '  + @prefix+ '.' + @campoNombre
else
  set @sqlstmt = @sqlstmt +'Nombre = '  + @prefix+ '.' + @campoNombre

exec sp_strSetPrefix @prefix, @campos out

if ltrim(@campos) <> '' set @sqlstmt = @sqlstmt +','+ @campos

set @sqlstmt = @sqlstmt + ' from ' + @tabla + ' ' + @prefix 

if ltrim(@tablasRama) <> '' set @sqlstmt = @sqlstmt +','+ @tablasRama

set @sqlwhere = ' where Hoja.ram_id = ' + convert(varchar(15),@@ram_id) + ' and Hoja.id = ' + @prefix + '.' + @campoId + @where


-- si solo quieren las columnas
if isnull(@@soloColumnas,0) <> 0 
 begin
  set @sqlstmt = @sqlstmt + ', Hoja ' + @sqlwhere
  set @sqlstmt = @sqlstmt + ' and 1=2'
 end
else
 begin
  -- si se trata de la raiz tambien entran los que no estan asignados a ninguna rama
  select @esRaiz = ram_id_padre, @arb_id = arb_id from rama where ram_id = @@ram_id
  if @esRaiz = 0 
   begin
    create table #HojaId (hoja_id int, id int)

    -- Ids de la raiz
    set @sqlstmt2 = ' insert into #HojaId select hoja_id,id from Hoja where ram_id = ' + convert(varchar(15),@@ram_id)
    exec(@sqlstmt2)--print (@sqlstmt2)--

    -- Ids sin asignar
    set @sqlstmt2 =  'insert into #HojaId select ' + @campoId + '*-1,' + @campoId + ' from ' + @tabla + ' where not exists (select hoja_id from Hoja inner join Rama on Hoja.ram_id = Rama.ram_id where Hoja.id = ' + @tabla + '.' + @campoId + ' and Hoja.arb_id = '+ convert(varchar(15),@arb_id) +' and (Rama.ram_id <> ram_id_padre or Rama.ram_id = 0))'
    exec(@sqlstmt2) --print (@sqlstmt2)--

    -- el filtro esta en #HojaId
    set @sqlstmt = @sqlstmt + ', #HojaId where #HojaId.id = ' + @prefix + '.' + @campoId + @where
   end
  else
    set @sqlstmt = @sqlstmt + ', Hoja ' + @sqlwhere
 end
exec (@sqlstmt) 
--print (@sqlstmt)--
go
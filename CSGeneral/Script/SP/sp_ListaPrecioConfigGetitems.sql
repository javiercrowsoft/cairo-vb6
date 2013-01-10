if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_ListaPrecioConfigGetitems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ListaPrecioConfigGetitems]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*

sp_ListaPrecioConfigGetitems '0',3,0

*/
create procedure sp_ListaPrecioConfigGetitems (
  @@pr_id  varchar(255),
  @@lp_id  int,
  @@top    int
)
as
begin

  set nocount on

  ----------------------------------------------------------------------------------------

  declare @pr_id int
  declare @ram_id_Producto int
  
  declare @clienteID int
  declare @IsRaiz    tinyint
  
  exec sp_ArbConvertId @@pr_id,       @pr_id out,       @ram_id_Producto out
  
  exec sp_GetRptId @clienteID out

  if @ram_id_Producto <> 0 begin
  
    -- exec sp_ArbGetGroups @ram_id_Producto, @clienteID, @@us_id
  
    exec sp_ArbIsRaiz @ram_id_Producto, @IsRaiz out
    if @IsRaiz = 0 begin
      exec sp_ArbGetAllHojas @ram_id_Producto, @clienteID 
    end else 
      set @ram_id_Producto = 0
  end

  ----------------------------------------------------------------------------------------


  ----------------------------------------------------------------------------------------

    declare @sqlstmt varchar(5000)

    if @@Top > 0 
      set @sqlstmt = 'select top ' + convert(varchar,@@Top)
    else
      set @sqlstmt = 'select'
  
    set @sqlstmt = @sqlstmt + 
              ' lpc.*, lp_nombre, pr_nombrecompra, ' + 
              ' tiene_precio = (select count(*) from ListaPrecioItem where pr_id = lpc.pr_id and lp_id = lpc.lp_id) ' +
              ' from ListaPrecioConfig lpc' + 
               ' left join ListaPrecio lp on lpc.lp_id = lp.lp_id' + 
               ' left join Producto pr on lpc.pr_id = pr.pr_id'
    
    set @sqlstmt = @sqlstmt + 
               ' where (pr.pr_id = '+convert(varchar,@pr_id)+' or '+convert(varchar,@pr_id)+' = 0)'+
                  'and ('+
                          '(exists(select rptarb_hojaid '+
                                  ' from rptArbolRamaHoja '+
                                  ' where'+
                                       ' rptarb_cliente = '+convert(varchar,@clienteID)+
                                  ' and  tbl_id = 30'+
                                  ' and  rptarb_hojaid = pr.pr_id'+
                                 ') '+
                           ')'+
                        ' or '+
                           '('+convert(varchar,@ram_id_Producto)+' = 0)'+
                       ')'+
              
                  ' and ('+convert(varchar,@@lp_id)+' = 0 or exists(select * from ListaPrecioConfig where lp_id = '+convert(varchar,@@lp_id)+' and pr_id = pr.pr_id))'+
    
               ' order by pr_nombrecompra'

  exec (@sqlstmt)

end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


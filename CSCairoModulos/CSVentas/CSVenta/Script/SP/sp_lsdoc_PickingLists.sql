/*

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_PickingLists]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_PickingLists]


/*

sp_lsdoc_PickingLists 1,'20070101','20071128','','0','0','0'

*/

go
create procedure sp_lsdoc_PickingLists (
  @@us_id    int,

  @@Fini      datetime,
  @@Ffin      datetime,

  @@pkl_nrodoc      varchar(255),
  @@cli_id          varchar(255),
  @@ven_id          varchar(255),
  @@zon_id          varchar(255)

)as 

begin

  set nocount on
  
/* -///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cli_id int
declare @ven_id int
declare @zon_id int

declare @ram_id_Vendedor int
declare @ram_id_Cliente int
declare @ram_id_Zona int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cli_id,       @cli_id out,       @ram_id_Vendedor out
exec sp_ArbConvertId @@ven_id,       @ven_id out,       @ram_id_Cliente out
exec sp_ArbConvertId @@zon_id,       @zon_id out,       @ram_id_Zona out

exec sp_GetRptId @clienteID out

if @ram_id_Vendedor <> 0 begin

  -- exec sp_ArbGetGroups @ram_id_Vendedor, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Vendedor, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Vendedor, @clienteID 
  end else 
    set @ram_id_Vendedor = 0
end

if @ram_id_Cliente <> 0 begin

  -- exec sp_ArbGetGroups @ram_id_Cliente, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Cliente, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Cliente, @clienteID 
  end else 
    set @ram_id_Cliente = 0
end

if @ram_id_Zona <> 0 begin

  -- exec sp_ArbGetGroups @ram_id_Zona, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Zona, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Zona, @clienteID 
  end else 
    set @ram_id_Zona = 0
end

if isnumeric (@@pkl_nrodoc)<> 0 set @@pkl_nrodoc = right('00000000'+@@pkl_nrodoc,8)

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

select 

  pkl_id,
  ''                as TypeTask,
  pkl_fecha          as Fecha,
  pkl_nrodoc        as Numero,
  pkl.creado        as Creado,
  pkl.modificado    as Modificado,
  us.us_nombre      as Modifico,
  case when pkl_cumplido <> 0 then 'Si' else 'No' end as Cumplida,
  pkl_descrip        as [Descripción]

from 

    PickingList pkl  inner join Usuario us    on pkl.modifico = us.us_id
                    

where 
          @@Fini <= pkl_fecha
      and  @@Ffin >= pkl_fecha     
      and (pkl.pkl_nrodoc = @@pkl_nrodoc or @@pkl_nrodoc = '')

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and exists( select * 
            from PickingListPedido pklpv 
                            inner join PedidoVenta pv 
                              on pklpv.pv_id = pv.pv_id
                            left  join Cliente cli  
                              on pv.cli_id   = cli.cli_id

             where pklpv.pkl_id = pkl.pkl_id
              
              and   (pv.cli_id = @cli_id or @cli_id = 0)
              and   (isnull(pv.ven_id,cli.ven_id) = @ven_id or @ven_id = 0)
              and   (cli.zon_id = @zon_id or @zon_id = 0)

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
                         (@ram_id_Vendedor = 0)
                     )
              
              and   (
                        (exists(select rptarb_hojaid 
                                from rptArbolRamaHoja 
                                where
                                     rptarb_cliente = @clienteID
                                and  tbl_id = 15
                                and  rptarb_hojaid = isnull(pv.ven_id,cli.ven_id)
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
                                and  tbl_id = 8
                                and  rptarb_hojaid = cli.zon_id
                               ) 
                         )
                      or 
                         (@ram_id_Cliente = 0)
                     )
        )

  order by pkl_fecha, pkl_nrodoc

end
go
/*---------------------------------------------------------------------
  Nombre: Permisos por prestacion, usuario, departamento y departamento
---------------------------------------------------------------------*/

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DC_CSC_SEG_0090]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_SEG_0090]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


create procedure DC_CSC_SEG_0090 (

  @@us_id    int,

@@us_id_usuario varchar(255),
@@dpto_id       varchar(255)

)as 

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @us_id_usuario  int
declare @dpto_id         int
declare @us_id          int
declare @usdpto_id        int

declare @ram_id_usuario int
declare @ram_id_departamento int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@us_id_usuario, @us_id_usuario out, @ram_id_usuario out
exec sp_ArbConvertId @@dpto_id, @dpto_id out, @ram_id_departamento out

exec sp_GetRptId @clienteID out

if @ram_id_usuario <> 0 begin

--  exec sp_ArbGetGroups @ram_id_usuario, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_usuario, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_usuario, @clienteID 
  end else 
    set @ram_id_usuario = 0
end

if @ram_id_departamento <> 0 begin

--  exec sp_ArbGetGroups @ram_id_departamento, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_departamento, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_departamento, @clienteID 
  end else 
    set @ram_id_departamento = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare c_usemp insensitive cursor for

  select 
  
    u.us_id,
    e.dpto_id
  
  from usuario u, departamento e
  
  where 
  
  /* -///////////////////////////////////////////////////////////////////////
  
  INICIO SEGUNDA PARTE DE ARBOLES
  
  /////////////////////////////////////////////////////////////////////// */
  
        (u.us_id   = @us_id_usuario   or @us_id_usuario=0)
  and   (e.dpto_id = @dpto_id         or @dpto_id=0)
  
  
  -- Arboles
  
  and   (
            (exists(select rptarb_hojaid 
                    from rptArbolRamaHoja 
                    where
                         rptarb_cliente = @clienteID
                    and  tbl_id = 3 
                    and  rptarb_hojaid = u.us_id
                   ) 
             )
          or 
             (@ram_id_usuario = 0)
         )
  
  and   (
            (exists(select rptarb_hojaid 
                    from rptArbolRamaHoja 
                    where
                         rptarb_cliente = @clienteID
                    and  tbl_id = 1015 
                    and  rptarb_hojaid = e.dpto_id
                   ) 
             )
          or 
             (@ram_id_departamento = 0)
         )

  open c_usemp

  fetch next from c_usemp into @us_id, @dpto_id
  while @@fetch_status = 0
  begin

    if not exists (select * from usuariodepartamento where dpto_id = @dpto_id and us_id = @us_id) begin

      exec sp_dbgetnewid 'UsuarioDepartamento', 'usdpto_id', @usdpto_id out, 0

      insert into usuariodepartamento (usdpto_id, dpto_id, us_id, modifico) 
                                 values(@usdpto_id, @dpto_id, @us_id, @@us_id)

    end

    fetch next from c_usemp into @us_id, @dpto_id
  end

  close c_usemp
  deallocate c_usemp

  select 1, 'El proceso termino con éxito' as Info

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


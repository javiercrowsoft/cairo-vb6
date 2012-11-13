if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_9998]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_9998]
GO
/*  

Para testear:

[DC_CSC_CON_9998] 70,'20051001 00:00:00','20060930 00:00:00','0','0','0','0','5'

DC_CSC_CON_9998 1, 
								'20060101',
								'20060120',
								'0', 
								'0',
								'0',
								'0',
								'0'
*/

create procedure DC_CSC_CON_9998 (

  @@us_id    		int,
	@@Fini 		 		datetime,
	@@Ffin 		 		datetime,
	@@cue_id      varchar(255),
  @@cico_id     varchar(255),
  @@doc_id	 		varchar(255),
  @@mon_id	 		varchar(255),
  @@emp_id	 		varchar(255)

)as 

begin
set nocount on
/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cue_id       int
declare @mon_id   		int
declare @emp_id   		int
declare @cico_id 			int
declare @doc_id				int

declare @ram_id_cuenta           int
declare @ram_id_moneda           int
declare @ram_id_empresa          int
declare @ram_id_circuitocontable int
declare @ram_id_documento        int


declare @clienteID 			int
declare @clienteIDccosi int

declare @IsRaiz    tinyint

exec sp_ArbConvertId @@mon_id,  		 @mon_id  out,  			@ram_id_moneda out
exec sp_ArbConvertId @@emp_id,  		 @emp_id  out,  			@ram_id_empresa out
exec sp_ArbConvertId @@cue_id,  		 @cue_id  out, 				@ram_id_cuenta out
exec sp_ArbConvertId @@cico_id, 		 @cico_id out, 				@ram_id_circuitocontable out
exec sp_ArbConvertId @@doc_id, 		   @doc_id  out, 				@ram_id_Documento out

exec sp_GetRptId @clienteID out
exec sp_GetRptId @clienteIDccosi out

if @ram_id_cuenta <> 0 begin

--	exec sp_ArbGetGroups @ram_id_cuenta, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_cuenta, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_cuenta, @clienteID 
	end else 
		set @ram_id_cuenta = 0
end

if @ram_id_moneda <> 0 begin

--	exec sp_ArbGetGroups @ram_id_moneda, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_moneda, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_moneda, @clienteID 
	end else 
		set @ram_id_moneda = 0
end

if @ram_id_empresa <> 0 begin

--	exec sp_ArbGetGroups @ram_id_empresa, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_empresa, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_empresa, @clienteID 
	end else 
		set @ram_id_empresa = 0
end

if @ram_id_circuitocontable <> 0 begin

--	exec sp_ArbGetGroups @ram_id_circuitocontable, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_circuitocontable, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_circuitocontable, @clienteID 
	end else 
		set @ram_id_circuitocontable = 0
end

if @ram_id_documento <> 0 begin

--	exec sp_ArbGetGroups @ram_id_circuitocontable, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_documento, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_documento, @clienteID 
	end else 
		set @ram_id_documento = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */


declare c_renumasiento insensitive cursor for

select distinct

			ast.as_id, 
			as_fecha

from 

			asiento ast

              inner join documento   doc  	on ast.doc_id   = doc.doc_id
							left  join documento   doccl	on ast.doc_id_cliente = doccl.doc_id

              inner join usuario     us   on ast.modifico = us.us_id
							inner join empresa     emp  on doc.emp_id   = emp.emp_id
              inner join asientoItem asi  on ast.as_id    = asi.as_id
              inner join cuenta      cue  on asi.cue_id   = cue.cue_id

where 
				  as_fecha >= @@Fini
			and	as_fecha <= @@Ffin 

-- Validar usuario - empresa
			and (
						exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
					)

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (  @cue_id = 0
       or
         exists(select as_id from AsientoItem 
                where as_id = ast.as_id 
                  and asi.cue_id = @cue_id
                )       
      )


and   (  @mon_id = 0
       or
         exists(select as_id from AsientoItem 
                where as_id = ast.as_id 
                  and asi.mon_id = @mon_id
                )       
      )

and   (doc.emp_id   = @emp_id 	or @emp_id	=0)

and   (isnull(doccl.cico_id, doc.cico_id) 	= @cico_id 	or @cico_id	=0)

and   (ast.doc_id 	= @doc_id 	or @doc_id	=0)

-- Arboles

and   (
					(exists(select as_id from AsientoItem
                  where as_id = ast.as_id
                    and (
                          exists(select rptarb_hojaid 
                                 from rptArbolRamaHoja 
                                 where rptarb_cliente = @clienteID
                                   and tbl_id = 17 
                                   and rptarb_hojaid = cue_id
                  						   ) 
                        )
                  )
           )
        or 
					 (@ram_id_cuenta = 0)
			 )

and   (
					(exists(select as_id from AsientoItem
                  where as_id = as_id
                    and (
                          exists(select rptarb_hojaid 
                                 from rptArbolRamaHoja 
                                 where rptarb_cliente = @clienteID
                                   and tbl_id = 12 
                                   and rptarb_hojaid = mon_id
                  						   ) 
                        )
                  )
           )
        or 
					 (@ram_id_moneda = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1018 
                  and  rptarb_hojaid = doc.emp_id
							   ) 
           )
        or 
					 (@ram_id_empresa = 0)
			 )
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1016 
                  and  rptarb_hojaid = isnull(doccl.cico_id, doc.cico_id)
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
                  and  tbl_id = 4001
                  and  rptarb_hojaid = ast.doc_id
							   ) 
           )
        or 
					 (@ram_id_documento = 0)
			 )

order by as_fecha, ast.as_id

open c_renumasiento

declare @as_id      int
declare @strNroDoc 	varchar(50)
declare @nrodoc 		int
declare @as_fecha   datetime

set @nrodoc = 0

fetch next from c_renumasiento into @as_id, @as_fecha

while @@fetch_status=0
begin

	set @nrodoc = @nrodoc +1

	set @strNroDoc = convert(varchar(50),@nrodoc)

	set @strNroDoc = substring('00000000',1,8-len(@strNroDoc))+@strNroDoc

	update Asiento Set as_nrodoc = @strNroDoc where as_id = @as_id

	fetch next from c_renumasiento into @as_id, @as_fecha
end

close c_renumasiento

deallocate c_renumasiento

select 1,'El proceso concluyo con exito' as Info

end
GO
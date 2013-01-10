if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_ChequeHelp3]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ChequeHelp3]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*

 sp_ChequeHelp3 1,'300%',0,0,596

 sp_ChequeHelp3 3,'',0,0,1 

  select * from usuario where us_nombre like '%ahidal%'

*/
create procedure sp_ChequeHelp3 (
  @@emp_id          int,
  @@us_id           int,
  @@bForAbm         tinyint,
  @@filter           varchar(255)  = '',
  @@check            smallint       = 0,
  @@cheq_id         int           = 0,
  @@filter2         varchar(255)  = ''
)
as
begin

  set nocount on

    if @@check <> 0 begin

      select  cheq_id,
              cheq_numerodoc      as [Nombre]
  
      from Cheque left  join cuenta  on cheque.cue_id = cuenta.cue_id
  
      where (cheq_numerodoc = @@filter)
        and (cheq_id = @@cheq_id or @@cheq_id=0)
        and cheque.emp_id = @@emp_id
        and (cheque.cue_id is null or cuenta.cuec_id = 2 or cuenta.cuec_id = 1)
  
    end else begin

        select top 50
        
          cheq_id,
          cheq_numerodoc          as [Numero],
          cle_nombre              as [Clearing],
          cli_nombre              as [Cliente],
          cheq_importe            as [Importe],
          cheq_fechacobro         as [Para Cobrar el],
          cheq_fechavto           As [Vencimiento],
          cue_nombre              as [Cuenta],
          cobz_nrodoc             as [Cobranza],
          opg_nrodoc              as [Orden Pago],
          mf_nrodoc               as [Movimiento Fondo],
          prov_nombre             as [Proveedor]
        
        from cheque inner join clearing         on cheque.cle_id   = clearing.cle_id
                    left  join cliente          on cheque.cli_id   = cliente.cli_id
                    left  join cobranza         on cheque.cobz_id = cobranza.cobz_id
                    left  join ordenpago        on cheque.opg_id   = ordenpago.opg_id
                    left  join movimientofondo   on cheque.mf_id   = movimientofondo.mf_id
                    left  join proveedor        on cheque.prov_id = proveedor.prov_id
                    left  join cuenta           on cheque.cue_id  = cuenta.cue_id

        where (cheq_numerodoc like '%'+@@filter+'%'
                or @@filter = '')
          and cheque.emp_id = @@emp_id
          and (cheque.cue_id is null or cuenta.cuec_id = 2 or cuenta.cuec_id = 1)

    end
end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


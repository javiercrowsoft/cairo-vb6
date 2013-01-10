
/*---------------------------------------------------------------------
Nombre: Balance
---------------------------------------------------------------------*/

/*
exec DC_CSC_CON_0040 

1,
'20000101',
'20100101',

'0',
'0',
'0',
'1'


*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_0040]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_0040]

go
create procedure DC_CSC_CON_0040 (

  @@us_id      int,
  @@FDesde     datetime,
  @@FHasta     datetime,

  @@cico_id         varchar(255),
  @@ccos_id         varchar(255),
  @@cue_id          varchar(255), 
  @@emp_id          varchar(255),
  @@arb_id          int = 0,
  @@bSaldoAnterior  smallint

)as 

begin

set nocount on

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cico_id int
declare @ccos_id int
declare @cue_id int
declare @emp_id int --TODO:EMPRESA

declare @ram_id_circuito int
declare @ram_id_centrocosto int
declare @ram_id_cuenta int
declare @ram_id_Empresa   int 

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cico_id, @cico_id out, @ram_id_circuito out
exec sp_ArbConvertId @@ccos_id, @ccos_id out, @ram_id_centrocosto out
exec sp_ArbConvertId @@cue_id, @cue_id out, @ram_id_cuenta out
exec sp_ArbConvertId @@emp_id, @emp_id out, @ram_id_Empresa out 

exec sp_GetRptId @clienteID out

create table #dc_csc_con_0040_cuentas (
                                        nodo_id int,
                                        nodo_2 int,
                                        nodo_3 int,
                                        nodo_4 int,
                                        nodo_5 int,
                                        nodo_6 int,
                                        nodo_7 int,
                                        nodo_8 int,
                                        nodo_9 int
                                      )

if @@arb_id = 0  select @@arb_id = min(arb_id) from arbol where tbl_id = 17 -- cuenta

declare @arb_nombre varchar(255)   select @arb_nombre = arb_nombre from arbol where arb_id = @@arb_id
declare @n           int           set @n = 2
declare @raiz       int

while exists(select * from rama r
             where  arb_id = @@arb_id
                and not exists (select * from #dc_csc_con_0040_cuentas where nodo_2 = r.ram_id)
                and not exists (select * from #dc_csc_con_0040_cuentas where nodo_3 = r.ram_id)
                and not exists (select * from #dc_csc_con_0040_cuentas where nodo_4 = r.ram_id)
                and not exists (select * from #dc_csc_con_0040_cuentas where nodo_5 = r.ram_id)
                and not exists (select * from #dc_csc_con_0040_cuentas where nodo_6 = r.ram_id)
                and not exists (select * from #dc_csc_con_0040_cuentas where nodo_7 = r.ram_id)
                and not exists (select * from #dc_csc_con_0040_cuentas where nodo_8 = r.ram_id)
                and not exists (select * from #dc_csc_con_0040_cuentas where nodo_9 = r.ram_id)

                and @n <= 9
            )
begin

  if @n = 2 begin

    select @raiz = ram_id from rama where arb_id = @@arb_id and ram_id_padre = 0
    insert #dc_csc_con_0040_cuentas (nodo_id, nodo_2) 
    select ram_id, ram_id from rama where ram_id_padre = @raiz

  end else begin if @n = 3 begin

    insert #dc_csc_con_0040_cuentas (nodo_id, nodo_2, nodo_3) 
    select ram_id, nodo_2, ram_id 
    from rama r inner join #dc_csc_con_0040_cuentas n on r.ram_id_padre = n.nodo_2

  end else begin if @n = 4 begin

    insert #dc_csc_con_0040_cuentas (nodo_id, nodo_2, nodo_3, nodo_4) 
    select ram_id, nodo_2, nodo_3, ram_id
    from rama r inner join #dc_csc_con_0040_cuentas n on r.ram_id_padre = n.nodo_3

  end else begin if @n = 5 begin

    insert #dc_csc_con_0040_cuentas (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5) 
    select ram_id, nodo_2, nodo_3, nodo_4, ram_id
    from rama r inner join #dc_csc_con_0040_cuentas n on r.ram_id_padre = n.nodo_4

  end else begin if @n = 6 begin

    insert #dc_csc_con_0040_cuentas (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6) 
    select ram_id, nodo_2, nodo_3, nodo_4, nodo_5, ram_id
    from rama r inner join #dc_csc_con_0040_cuentas n on r.ram_id_padre = n.nodo_5

  end else begin if @n = 7 begin

    insert #dc_csc_con_0040_cuentas (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7) 
    select ram_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, ram_id
    from rama r inner join #dc_csc_con_0040_cuentas n on r.ram_id_padre = n.nodo_6

  end else begin if @n = 8 begin

    insert #dc_csc_con_0040_cuentas (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7, nodo_8) 
    select ram_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7, ram_id
    from rama r inner join #dc_csc_con_0040_cuentas n on r.ram_id_padre = n.nodo_7

  end else begin if @n = 9 begin

    insert #dc_csc_con_0040_cuentas (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7, nodo_8, nodo_9) 
    select ram_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7, nodo_8, ram_id
    from rama r inner join #dc_csc_con_0040_cuentas n on r.ram_id_padre = n.nodo_8

  end
  end
  end
  end
  end
  end
  end
  end

  set @n = @n + 1

end

if @ram_id_circuito <> 0 begin

--  exec sp_ArbGetGroups @ram_id_circuito, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_circuito, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_circuito, @clienteID 
  end else 
    set @ram_id_circuito = 0
end

if @ram_id_centrocosto <> 0 begin

--  exec sp_ArbGetGroups @ram_id_centrocosto, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_centrocosto, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_centrocosto, @clienteID 
  end else 
    set @ram_id_centrocosto = 0
end

if @ram_id_cuenta <> 0 begin

--  exec sp_ArbGetGroups @ram_id_cuenta, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_cuenta, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_cuenta, @clienteID 
  end else 
    set @ram_id_cuenta = 0
end


if @ram_id_Empresa <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Empresa, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Empresa, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Empresa, @clienteID 
  end else 
    set @ram_id_Empresa = 0
end
/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

create table #Anterior(
                     cue_id int not null,
                     saldoA decimal (18,6)
                     )

if @@bSaldoAnterior <> 0 begin

  insert #Anterior(cue_id, saldoA)
  
  select 
                cue_id,
                  sum(asi_debe)  
                - sum(asi_haber)
  
  from 
  
              asientoitem ai inner join asiento a          on ai.as_id = a.as_id  
                             inner join documento d        on a.doc_id = d.doc_id
                             inner join Empresa            on d.emp_id = Empresa.emp_id 
                             left  join Documento doccl    on a.doc_id_cliente  = doccl.doc_id
  
  where
  
              as_fecha < @@FDesde  
  
  
        and (
              exists(select * from EmpresaUsuario where emp_id = d.emp_id and us_id = @@us_id) or (@@us_id = 1)
            )
  /* -///////////////////////////////////////////////////////////////////////
  
  INICIO SEGUNDA PARTE DE ARBOLES
  
  /////////////////////////////////////////////////////////////////////// */
  
  and   (IsNull(doccl.cico_id,d.cico_id) = @cico_id or @cico_id=0)
  and   (ai.ccos_id = @ccos_id or @ccos_id=0)
  and   (ai.cue_id = @cue_id or @cue_id=0)
  and   (Empresa.emp_id = @emp_id or @emp_id=0) 
  
  -- Arboles
  and   (
            (exists(select rptarb_hojaid 
                    from rptArbolRamaHoja 
                    where
                         rptarb_cliente = @clienteID
                    and  tbl_id = 1016 
                    and  rptarb_hojaid = IsNull(doccl.cico_id,d.cico_id)
                   ) 
             )
          or 
             (@ram_id_circuito = 0)
         )
  
  and   (
            (exists(select rptarb_hojaid 
                    from rptArbolRamaHoja 
                    where
                         rptarb_cliente = @clienteID
                    and  tbl_id = 21 
                    and  rptarb_hojaid = ai.ccos_id
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
                    and  tbl_id = 17 
                    and  rptarb_hojaid = ai.cue_id
                   ) 
             )
          or 
             (@ram_id_cuenta = 0)
         )
  
  and   (
            (exists(select rptarb_hojaid 
                    from rptArbolRamaHoja 
                    where
                         rptarb_cliente = @clienteID
                    and  tbl_id = 1018 
                    and  rptarb_hojaid = d.emp_id
                   ) 
             )
          or 
             (@ram_id_Empresa = 0)
         )
  
  group by 
              cue_id            

end

-------------------------------------------------------------------------

create table #Periodo(
                     cue_id  int not null,
                     debe    decimal (18,6),
                     haber   decimal (18,6),
                     saldoP  decimal (18,6)
                     )
insert #Periodo (cue_id, debe, haber, saldoP)            

select 
              cue_id,
              sum(asi_debe),
              sum(asi_haber),

                sum(asi_debe)  
              - sum(asi_haber)

from 

            asientoitem ai inner join asiento a          on ai.as_id = a.as_id  
                           inner join documento d        on a.doc_id = d.doc_id
                           inner join Empresa            on d.emp_id = Empresa.emp_id 
                           left  join Documento doccl    on a.doc_id_cliente  = doccl.doc_id

 where
            as_fecha >= @@FDesde  
        and as_fecha <= @@FHasta

      and (
            exists(select * from EmpresaUsuario where emp_id = d.emp_id and us_id = @@us_id) or (@@us_id = 1)
          )

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (IsNull(doccl.cico_id,d.cico_id) = @cico_id or @cico_id=0)
and   (ai.ccos_id = @ccos_id or @ccos_id=0)
and   (ai.cue_id = @cue_id or @cue_id=0)
and   (Empresa.emp_id = @emp_id or @emp_id=0) 

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1016 
                  and  rptarb_hojaid = IsNull(doccl.cico_id,d.cico_id)
                 ) 
           )
        or 
           (@ram_id_circuito = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 21 
                  and  rptarb_hojaid = ai.ccos_id
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
                  and  tbl_id = 17 
                  and  rptarb_hojaid = ai.cue_id
                 ) 
           )
        or 
           (@ram_id_cuenta = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1018 
                  and  rptarb_hojaid = d.emp_id
                 ) 
           )
        or 
           (@ram_id_Empresa = 0)
       )

group by 
            cue_id

-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
select 
              c.cue_id,
              cue_nombre                           as [Cuenta],

              @arb_nombre     as Nivel_1,
      
              nodo_2.ram_nombre    as Nivel_2,
              nodo_3.ram_nombre    as Nivel_3,
              nodo_4.ram_nombre    as Nivel_4,
              nodo_5.ram_nombre    as Nivel_5,
              nodo_6.ram_nombre    as Nivel_6,
              nodo_7.ram_nombre    as Nivel_7,
              nodo_8.ram_nombre    as Nivel_8,
              nodo_9.ram_nombre    as Nivel_9,

              convert(varchar,nodo_2.ram_orden)+'@'+ nodo_2.ram_nombre    as Nivelg_2,
              convert(varchar,nodo_3.ram_orden)+'@'+ nodo_3.ram_nombre    as Nivelg_3,
              convert(varchar,nodo_4.ram_orden)+'@'+ nodo_4.ram_nombre    as Nivelg_4,
              convert(varchar,nodo_5.ram_orden)+'@'+ nodo_5.ram_nombre    as Nivelg_5,
              convert(varchar,nodo_6.ram_orden)+'@'+ nodo_6.ram_nombre    as Nivelg_6,
              convert(varchar,nodo_7.ram_orden)+'@'+ nodo_7.ram_nombre    as Nivelg_7,
              convert(varchar,nodo_8.ram_orden)+'@'+ nodo_8.ram_nombre    as Nivelg_8,
              convert(varchar,nodo_9.ram_orden)+'@'+ nodo_9.ram_nombre    as Nivelg_9,

              IsNull(saldoA,0)                     as [Saldo anterior],
              IsNull(debe,0)                       as [Debe],
              IsNull(haber,0)                      as [Haber],
              IsNull(saldoP,0)                     as [Saldo del periodo],
              IsNull(saldoA,0) + IsNull(saldoP,0)  as [Saldo al cierre]

from 

            cuenta c left join #Periodo   p on c.cue_id = p.cue_id
                     left join #Anterior  a on c.cue_id = a.cue_id

                         left  join hoja h    on     c.cue_id = h.id 
                                                 and h.arb_id = @@arb_id

                                                 -- Esto descarta la raiz
                                                 --
                                                 and not exists(select * from rama 
                                                                where ram_id = ram_id_padre 
                                                                  and arb_id = @@arb_id 
                                                                  and ram_id = h.ram_id)

                                                 -- Esto descarta hojas secundarias
                                                 --
                                                 and not exists(select * from hoja h2 inner join rama r on h2.ram_id = r.ram_id
                                                                where h2.arb_id = @@arb_id
                                                                  and h2.ram_id < h.ram_id
                                                                  and h2.ram_id <> r.ram_id_padre 
                                                                  and h2.id = h.id)

                         left  join #dc_csc_con_0040_cuentas nodo on h.ram_id = nodo.nodo_id

                         left  join rama nodo_2    on nodo.nodo_2 = nodo_2.ram_id
                         left  join rama nodo_3    on nodo.nodo_3 = nodo_3.ram_id
                         left  join rama nodo_4    on nodo.nodo_4 = nodo_4.ram_id
                         left  join rama nodo_5    on nodo.nodo_5 = nodo_5.ram_id
                         left  join rama nodo_6    on nodo.nodo_6 = nodo_6.ram_id
                         left  join rama nodo_7    on nodo.nodo_7 = nodo_7.ram_id
                         left  join rama nodo_8    on nodo.nodo_8 = nodo_8.ram_id
                         left  join rama nodo_9    on nodo.nodo_9 = nodo_9.ram_id

where (saldoA is not null or saldoP is not null)

order by cue_codigo
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
end
go



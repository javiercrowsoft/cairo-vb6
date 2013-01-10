if exists (select * from sysobjects where id = object_id(N'[dbo].[frPackingListTitles]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[frPackingListTitles]

/*

frPackingListTitles 5,1

*/

go
create procedure frPackingListTitles (

  @@pklst_id  int,
  @@idm_id    int

)as 

begin

set nocount on

create table #header(

  titulo01           varchar(100),
  titulo02           varchar(100),
  titulo03           varchar(100),
  UnidadesT          varchar(50),
  CajaNroT           varchar(50),
  CantXCajaT         varchar(50),
  ProductoT          varchar(50),
  GrupoT             varchar(50),
  PartidaT           varchar(50),
  PesoNetoT          varchar(50),
  PesoBrutoT         varchar(50),
  MarcasT            varchar(50),
  VolumenT           varchar(50),
  VolumenTotalT      varchar(50),
  TotalT             varchar(50),
  MedidasT           varchar(150),
  VolumenExtT        varchar(150)
)


insert into #header

  select 

--//////////////////////////////////////////////////////////////////////////////////////////////
          (select MURpklst_texto 
           from MUR_PackingList
           where   pklst_id = @@pklst_id and idm_id = @@idm_id 
              and  MURpklst_codigo = '(pk)Titulo 01'
          )                                               as titulo01,

--//////////////////////////////////////////////////////////////////////////////////////////////
          (select MURpklst_texto 
           from MUR_PackingList
           where   pklst_id = @@pklst_id and idm_id = @@idm_id 
              and  MURpklst_codigo = '(pk)Titulo 02'
          )                                               as titulo02,

--//////////////////////////////////////////////////////////////////////////////////////////////
          (select MURpklst_texto 
           from MUR_PackingList
           where   pklst_id = @@pklst_id and idm_id = @@idm_id 
              and  MURpklst_codigo = '(pk)Titulo 03'
          )                                               as titulo03,


--//////////////////////////////////////////////////////////////////////////////////////////////
          (select MURpklst_texto 
           from MUR_PackingList
           where   pklst_id = @@pklst_id and idm_id = @@idm_id 
              and  MURpklst_codigo = '(pk)Titulo Unidades'
          )                                               as UnidadesT,

--//////////////////////////////////////////////////////////////////////////////////////////////
          (select MURpklst_texto 
           from MUR_PackingList
           where   pklst_id = @@pklst_id and idm_id = @@idm_id 
              and  MURpklst_codigo = '(pk)Titulo CajaNro'
          )                                               as CajaNroT,

--//////////////////////////////////////////////////////////////////////////////////////////////
          (select MURpklst_texto 
           from MUR_PackingList
           where   pklst_id = @@pklst_id and idm_id = @@idm_id 
              and  MURpklst_codigo = '(pk)Titulo Cant. x Caja'
          )                                               as CantXCajaT,

--//////////////////////////////////////////////////////////////////////////////////////////////
          (select MURpklst_texto 
           from MUR_PackingList
           where   pklst_id = @@pklst_id and idm_id = @@idm_id 
              and  MURpklst_codigo = '(pk)Titulo Producto'
          )                                               as Producto,

--//////////////////////////////////////////////////////////////////////////////////////////////
          (select MURpklst_texto 
           from MUR_PackingList
           where   pklst_id = @@pklst_id and idm_id = @@idm_id 
              and  MURpklst_codigo = '(pk)Titulo Grupo'
          )                                               as GrupoT,

--//////////////////////////////////////////////////////////////////////////////////////////////
          (select MURpklst_texto 
           from MUR_PackingList
           where   pklst_id = @@pklst_id and idm_id = @@idm_id 
              and  MURpklst_codigo = '(pk)Titulo Partida'
          )                                               as PartidaT,

--//////////////////////////////////////////////////////////////////////////////////////////////
          (select MURpklst_texto 
           from MUR_PackingList
           where   pklst_id = @@pklst_id and idm_id = @@idm_id 
              and  MURpklst_codigo = '(pk)Titulo Peso Neto'
          )                                               as PesoNetoT,

--//////////////////////////////////////////////////////////////////////////////////////////////
          (select MURpklst_texto 
           from MUR_PackingList
           where   pklst_id = @@pklst_id and idm_id = @@idm_id 
              and  MURpklst_codigo = '(pk)Titulo Peso Bruto'
          )                                               as PesoBrutoT,

--//////////////////////////////////////////////////////////////////////////////////////////////
          (select MURpklst_texto 
           from MUR_PackingList
           where   pklst_id = @@pklst_id and idm_id = @@idm_id 
              and  MURpklst_codigo = '(pk)Titulo Marcas'
          )                                               as MarcasT,

--//////////////////////////////////////////////////////////////////////////////////////////////
          (select MURpklst_texto 
           from MUR_PackingList
           where   pklst_id = @@pklst_id and idm_id = @@idm_id 
              and  MURpklst_codigo = '(pk)Titulo Volumen'
          )                                               as VolumenT,

--//////////////////////////////////////////////////////////////////////////////////////////////
          (select MURpklst_texto 
           from MUR_PackingList
           where   pklst_id = @@pklst_id and idm_id = @@idm_id 
              and  MURpklst_codigo = '(pk)Titulo Volumen Total'
          )                                               as VolumenTotalT,

--//////////////////////////////////////////////////////////////////////////////////////////////
          (select MURpklst_texto 
           from MUR_PackingList
           where   pklst_id = @@pklst_id and idm_id = @@idm_id 
              and  MURpklst_codigo = '(pk)Titulo Total'
          )                                               as TotalT,

--//////////////////////////////////////////////////////////////////////////////////////////////
          (select MURpklst_texto 
           from MUR_PackingList
           where   pklst_id = @@pklst_id and idm_id = @@idm_id 
              and  MURpklst_codigo = '(pk)Titulo Medidas'
          )                                               as MedidasT,

--//////////////////////////////////////////////////////////////////////////////////////////////
          (select MURpklst_texto 
           from MUR_PackingList
           where   pklst_id = @@pklst_id and idm_id = @@idm_id 
              and  MURpklst_codigo = '(pk)Titulo Volumen Exterior'
          )                                               as VolumenExtT

  select * from #header

end
GO
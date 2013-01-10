if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_stockProdutoFormulaKitGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_stockProdutoFormulaKitGet]

/*

 select pr_id,pr_llevanroserie from producto where pr_eskit <> 0
 sp_stockProdutoFormulaKitGet 611

*/

go
create procedure sp_stockProdutoFormulaKitGet (
  @@prfk_id     int,
  @@tipo        tinyint
)
as

begin

  set nocount on

  --//////////////////////////////////////////////////////////////////
  --
  --    ITEMS CON NUMEROS DE SERIE
  --
  --
  if @@tipo = 1 /* c_series */ begin

    select prk.* ,pr_nombrecompra
    from ProductoKit prk inner join Producto pr on prk.pr_id_item = pr.pr_id
    where prfk_id = @@prfk_id 
      and pr_llevanroserie <> 0
    order by pr_nombrecompra


    select prka.*,pr_nombrecompra 
    from ProductoKit prk   inner join ProductoKitItemA prka on prk.prk_id = prka.prk_id
                          inner join Producto pr on prka.pr_id = pr.pr_id
    where prfk_id = @@prfk_id 
      and pr_llevanroserie <> 0
    order by prka.prk_id

  end else begin

  --//////////////////////////////////////////////////////////////////
  --
  --    ITEMS CON NUMEROS DE LOTE
  --
  --
    if @@tipo = 2 /* c_lotes */ begin

      select prk.* ,pr_nombrecompra
      from ProductoKit prk inner join Producto pr on prk.pr_id_item = pr.pr_id
      where prfk_id = @@prfk_id 
        and pr_llevanroserie = 0
        and pr_llevanrolote <> 0
      order by pr_nombrecompra  
  
      select prka.*,pr_nombrecompra 
      from ProductoKit prk   inner join ProductoKitItemA prka on prk.prk_id = prka.prk_id
                            inner join Producto pr on prka.pr_id = pr.pr_id
      where prfk_id = @@prfk_id 
        and pr_llevanroserie = 0
        and pr_llevanrolote <> 0
      order by prka.prk_id

    end else begin


  --//////////////////////////////////////////////////////////////////
  --
  --    ITEMS CON ALTERNATIVAS
  --
  --
      if @@tipo = 3 /* c_alts */ begin

        select prk.* ,pr_nombrecompra
        from ProductoKit prk inner join Producto pr on prk.pr_id_item = pr.pr_id
        where prfk_id = @@prfk_id 
          and pr_llevanroserie = 0
          and pr_llevanrolote = 0
          and exists(select prk_id from ProductoKitItemA where prk_id = prk.prk_id)
        order by pr_nombrecompra    
    
        select prka.*,pr_nombrecompra 
        from ProductoKit prk   inner join ProductoKitItemA prka on prk.prk_id = prka.prk_id
                              inner join Producto pr on prka.pr_id = pr.pr_id
        where prfk_id = @@prfk_id 
          and pr_llevanroserie = 0
          and pr_llevanrolote = 0
        order by prka.prk_id
  
      end else begin


  --//////////////////////////////////////////////////////////////////
  --
  --    ITEMS CON VARIABLES
  --
  --
        if @@tipo = 4 /* c_vars */ begin

          select prk.* ,pr_nombrecompra
          from ProductoKit prk inner join Producto pr on prk.pr_id_item = pr.pr_id
          where prfk_id = @@prfk_id 
            and pr_llevanroserie = 0
            and pr_llevanrolote = 0
            and prk_variable <> 0
            and not exists(select prk_id from ProductoKitItemA where prk_id = prk.prk_id)
          order by pr_nombrecompra

        end
      end
    end
  end

end
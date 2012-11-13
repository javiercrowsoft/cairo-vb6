update productonumeroserie set stl_id = stc.stl_id

from Producto pr , StockCache stc

where productonumeroserie.pr_id = pr.pr_id and (pr_llevanrolote <> 0 or pr_kitLote <> 0)
	and productonumeroserie.prns_id = stc.prns_id
	and productonumeroserie.stl_id is null
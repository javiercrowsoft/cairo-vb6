select mf.mf_id from MovimientoFondo mf left join MovimientoFondoItem mfi on mf.mf_id = mfi.mf_id
group by mf.mf_id,mf_total having isnull(sum(mfi_importe),0)<>mf_total


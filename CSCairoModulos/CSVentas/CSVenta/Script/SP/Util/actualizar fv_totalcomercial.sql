
    update facturaventa 
    set fv_totalcomercial = isnull( (select sum(fvd_importe) 
                                     from facturaventadeuda fvd 
                                     where fv_id = facturaventa.fv_id 
                                    ),0) 
                            +
                            isnull( (select sum(fvp_importe) 
                                     from facturaventapago fvp 
                                     where fv_id = facturaventa.fv_id 
                                    ),0)
GO
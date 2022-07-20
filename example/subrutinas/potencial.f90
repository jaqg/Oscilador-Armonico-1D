! Funcion para el potencial
function V(x) result(potencial)
    COMMON k,hbar,m
    real*8 :: k,hbar,m
    real*8, intent(in) :: x
    real*8 :: potencial

    potencial = k/2. * x**2

    return
end function V

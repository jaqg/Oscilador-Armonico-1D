module otras_funciones
    !
    ! Modulo que contiene otras funciones necesarias para el programa
    !
    implicit none
    contains
        function alpha_OA1D(k,m,hbar) result(alpha)
            !
            ! Parametro alfa del oscilador armonico 1D
            ! Nota: se puede cambiar la definicion de alfa para poder usarlo
            ! como parametro de optimizacion
            !
            implicit none
            real*8, intent(in) :: k,m,hbar
            real*8 :: alpha

            alpha = dsqrt(k*m)/hbar

            return
        end function
        function V(x,k) result(potencial)
            !
            ! Funcion de energia potencial del oscilador armomico 1D
            !
            implicit none
            real*8, intent(in) :: x, k
            real*8 :: potencial

            potencial = k/2.d0 * x**2

            return
        end function
end module

! |------------------------------------|
! | Autor: Jose Antonio Quinonero Gris |
! | Fecha de creacion: 11/03/2022      |
! |____________________________________|
module modulo_OA1D
    !
    ! Modulo para el calculo de las funciones propias del oscilador armonico
    ! unidimensional
    !
    implicit none
    contains
        function E_OA1D(n, hbar, k, m) result(energia)
            !
            ! Funcion para el calculo de las energias propias del oscilador
            ! armonico unidimensional
            !
            implicit none
            integer, intent(in) :: n
            real*8, intent(in) :: hbar, k, m
            real*8 :: omega, energia

            omega = dsqrt(k/m)
            energia = (n*1.d0 + 0.5d0)*hbar*omega

            return
        end function E_OA1D
        recursive function hermp(n, x) result(res_hp)
            !
            ! Funcion para el computo de los polinomios de Hermite haciendo
            ! uso de la relacion de recurrencia
            ! H_n(x) = 2xH_n-1(x) - 2(n-1)H_n-2(x)
            ! Teniendo en cuenta que
            ! H_0(x) = 1
            ! H_1(x) = 2x
            !
            implicit none
            integer, intent(in) :: n
            real*8, intent(in) :: x
            real*8 :: hp1, hp2, res_hp

            if (n==0) then
                res_hp = 1.d0
            elseif (n==1) then
                res_hp = 2.d0*x
            else
                hp1 = 2.d0*x*hermp(n-1,x)
                hp2 = 2.d0*float(n-1)*hermp(n-2,x)
                res_hp = hp1 - hp2
            end if

            return
        end function hermp
        !
        function phi(n,alpha,x) result(res_phi)
            !
            ! Funcion para el computo de la funcion propia phi_n del oscilador
            ! armonico unidimensional
            ! Nota: alpha es un parametro de entrada, para usarlo como
            ! parmetro de optimizacion. Para el oscilador unidimensional:
            ! alpha = (k*m)**0.5/hbar
            !
            implicit none
            real*8 :: Nv
            integer, intent(in) :: n
            real*8, intent(in) :: alpha, x
            real*8 :: res_phi
            real*8 :: PI

            ! Valor de pi
            PI=4.D0*DATAN(1.D0)

            ! Nota: factorial(n) = Gamma(n+1), donde n es real
            Nv = (alpha/pi)**0.25d0/dsqrt(2.**(n*1.d0)*Gamma((n+1)*1.d0))
            ! Funcion propia
            res_phi = Nv*exp(-alpha*x**2.d0/2.d0)*hermp(n,dsqrt(alpha)*x)

            return
        end function phi
end module

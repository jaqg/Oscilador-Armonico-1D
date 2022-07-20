! |------------------------------------|
! | Autor: José Antonio Quiñonero Gris |
! | Fecha de creacion: 11/03/2022      |
! |____________________________________|

! -----------------------------------------------------------------------------
! PROGRAMA PRINCIPAL
! -----------------------------------------------------------------------------
program OA1D_example
    !
    ! Programa para ejemplificar el uso del modulo 'modulo_OA1D.f90'
    !
    use parametros
    use otras_funciones
    use modulo_OA1D
    !
    implicit none
    integer :: i, j
    ! Nivel de energia 'n'
    integer :: n
    ! Nivel de energia maximo para el calculo
    integer :: nmax
    ! Variable para la posicion 'x'
    real*8 :: x, xmin, xmax, dx
    ! Numero de puntos de x
    integer :: steps_x
    ! Valor de la energia del nivel n
    real*8 :: En
    ! Constante de fuerza
    real*8 :: k
    ! Parametro alfa del oscilador
    real*8 :: alpha

    ! Fichero de entrada
    open(unit=1, file="data/in-OA1D_example.dat")
    ! Ficheros de salida
    open(unit=2, file="data/out-potencial.dat")
    open(unit=3, file="data/out-funciones_propias.dat")
    open(unit=4, file="data/out-densidades_probabilidad.dat")
    open(unit=7, file="data/out-energias_propias.dat")

    ! Lee los datos de entrada
    read(1,*)
    read(1,*) k, nmax, xmin, xmax, dx

    ! Escribe la primera fila de los ficheros de salida
    write(2,'(4x, "x", 12x, "V(x)")')
    write(3,'(4x, "x", 13x, "phi_n(x) ...")')
    write(4,'(4x, "x", 13x, "|phi_n(x)|^2 ...")')
    write(7,'(2x, "n", 4x, "E_n (Ha)")')

    ! Calculo de las energias propias
    do i=0, nmax
        n = i
        En = E_OA1D(n, hbar, k, m)
        write(7,'(i3.1, 7x, 100f5.2)') n, En
    end do

    ! Parametro alfa del oscilador armonico unidimensional
    alpha = alpha_OA1D(k,m,hbar)
    ! Calculo del numero de puntos de x
    steps_x = int((xmax - xmin)/dx)
    ! Calculo de la funcion de energia potencial y funciones propias
    do i=0, steps_x
        x = xmin + (dx * i*1.d0)
        write(2,'(f10.3,10000f15.5)') x, V(x,k)
        write(3,'(f10.3,10000f15.5)') x,(phi(n,alpha,x)+E_OA1D(n,hbar,k,m),&
                                            n=0, nmax)
        write(4,'(f10.3,10000f15.5)') x,(phi(n,alpha,x)**2+E_OA1D(n,hbar,k,m),&
                                         n=0, nmax)
    end do

    write(*,*) 'El programa ha finalizado con éxito.'

    ! Cierra los ficheros
    close(1)
    close(2)
    close(3)
    close(4)
    close(7)
    stop
endprogram OA1D_example

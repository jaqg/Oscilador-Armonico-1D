# Oscilador Armónico 1D

Módulo escrito en Fortran para el cómputo de las funciones propias y energías propias del oscilador armónico unidimensional.

El módulo, llamado `modulo_OA1D.f90`, puede usarse en un programa de Fortran, escribiendo
```fortran
use modulo_OA1D
```
antes de la declaración de variables del programa.

## Energías propias ##

En el módulo, defino una función para el cálculo de las energías propias del
oscilador armónico unidimensional, dadas por

$$
    E_n = \left( n + \frac{1}{2} \right) \hbar \omega.
$$

```fortran
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
```
donde toma como variables de entrada:
- `n`: nivel de energía
- `k`: constante de fuerza del oscilador
- `m`: masa de la partícula (o masa reducida del sistema)

## Funciones propias ##

Primero, creo una función para definir los polinomios de Hermite a partir de la
relación de recurrencia

$$
    H_n(x) = 2xH_{n-1}(x) - 2(n-1)H_{n-2}(x),
$$

teniendo en cuenta que

$$
H_0(x) = 1,\\
H_1(x) = 2x.
$$

```Fortran
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
```

Defino las funciones propias según

$$
    \psi_v(x) = N_v e^{-\alpha x^2/2} H_n(\sqrt{\alpha}x),
$$

donde $H_n$ representa el polinomio de Hermite de grado $n$, $N_v$ es una constante de normalización dada por

$$
    N_v = \left(\frac{\alpha}{\pi}\right)^{1/4} \frac{1}{\sqrt{2^n n!}},
$$

y $\alpha$ una constante que tomo como un parámetro de entrada, para poder usarlo como
parámetro de optimización. Para el oscilador armónico unidimensional, se
demuestra que

$$
    \alpha = \frac{(k m)^{1/2}}{\hbar}.
$$

Así, defino las funciones propias como
```fortran
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
```

## Ejemplo ##

En la carpeta [example](https://github.com/jaqg/Oscilador-Armonico-1D/tree/main/example) se encuentra un ejemplo para el cálculo de los valores de la energía, las funciones propias y las densidades de probabilidad posicionales para los 5 primeros niveles. El programa principal es el archivo [OA1D_example.f90](https://github.com/jaqg/Oscilador-Armonico-1D/blob/main/example/OA1D_example.f90), que puede compilarse escribiendo
```shell
$ sh exec.sh
```
Hace uso de los módulos y subrutinas de la carpeta [subrutinas](https://github.com/jaqg/Oscilador-Armonico-1D/tree/main/example/subrutinas) y escribe los resultados a la carpeta [data](https://github.com/jaqg/Oscilador-Armonico-1D/tree/main/example/data), donde se encuentra el fichero [in-OA1D_example.dat](https://github.com/jaqg/Oscilador-Armonico-1D/blob/main/example/data/in-OA1D_example.dat) con los parámetros de entrada:
- `k`: constante de fuerza
- `nmax`: valor de $n$ máximo para el que se realiza el cálculo (nivel de
    energía máximo)
- `xmin` y `xmax`: valores mínimo y máximo de $x$ (en unidades atómicas)
- `dx`: incremento de $x$

que pueden ser cambiados.

Represento los resultados con la libreria matplotlib de python en la carpeta
[grafica](https://github.com/jaqg/Oscilador-Armonico-1D/tree/main/example/grafica).
![Funciones y densidades](https://github.com/jaqg/Oscilador-Armonico-1D/blob/main/example/grafica/funciones_densidades_subplot.png)

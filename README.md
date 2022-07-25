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
![](https://latex.codecogs.com/gif.latex?E_n%20%3D%20%5Cleft%28%20n%20&plus;%20%5Cfrac%7B1%7D%7B2%7D%20%5Cright%29%20%5Chbar%20%5Comega.)
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
![](https://latex.codecogs.com/gif.latex?H_n%28x%29%20%3D%202xH_%7Bn-1%7D%28x%29%20-%202%28n-1%29H_%7Bn-2%7D%28x%29%2C)
teniendo en cuenta que
![](https://latex.codecogs.com/gif.latex?%5Cbegin%7Balign*%7D%20H_0%28x%29%20%26%3D%201%2C%20%5C%5C%20H_1%28x%29%20%26%3D%202x.%20%5Cend%7Balign*%7D)
```fortran
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
![](https://latex.codecogs.com/gif.latex?%5Cpsi_v%28x%29%20%3D%20N_v%20e%5E%7B-%5Calpha%20x%5E2/2%7D%20H_n%28%5Csqrt%7B%5Calpha%7Dx%29%2C)
donde $H_n$ representa el polinomio de Hermite de grado $n$, $N_v$ es una constante de normalización dada por
![](https://latex.codecogs.com/gif.latex?N_v%20%3D%20%5Cleft%28%5Cfrac%7B%5Calpha%7D%7B%5Cpi%7D%5Cright%29%5E%7B1/4%7D%20%5Cfrac%7B1%7D%7B%5Csqrt%7B2%5En%20n%21%7D%7D%2C)
y $\alpha$ una constante que tomo como un parámetro de entrada, para poder usarlo como
parámetro de optimización. Para el oscilador armónico unidimensional, se
demuestra que
![](https://latex.codecogs.com/gif.latex?%5Calpha%20%3D%20%5Cfrac%7B%28k%20m%29%5E%7B1/2%7D%7D%7B%5Chbar%7D.)
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

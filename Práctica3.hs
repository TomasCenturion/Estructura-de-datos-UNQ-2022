data Color = Azul | Rojo deriving Show
data Celda = Bolita Color Celda | CeldaVacia deriving Show

celda0:: Celda 
celda0 = CeldaVacia

celda1 :: Celda 
celda1 = Bolita Azul celda0 

celda2 :: Celda 
celda2 = Bolita Rojo (Bolita Azul (Bolita Rojo (Bolita Azul CeldaVacia)))

nroBolitas :: Color -> Celda -> Int 
nroBolitas c (CeldaVacia)         = 0
nroBolitas c (Bolita color celda) = unoSi(bolitaEsDelMismoColor c color) + nroBolitas c celda

color :: Celda -> Color 
color (Bolita color celda) = color

unoSi:: Bool -> Int 
unoSi True     = 1
unoSi False    = 0

bolitaEsDelMismoColor :: Color -> Color -> Bool 
bolitaEsDelMismoColor  Azul Azul = True 
bolitaEsDelMismoColor  Rojo Rojo = True 
bolitaEsDelMismoColor  _    _    = False

poner :: Color -> Celda -> Celda
poner c  CeldaVacia           = (Bolita c CeldaVacia)
poner c (Bolita color celda)  = (Bolita c(Bolita color celda))

sacar :: Color -> Celda -> Celda 
sacar c CeldaVacia           = CeldaVacia 
sacar c (Bolita color celda) = if bolitaEsDelMismoColor c color 
                               then celda 
                               else (Bolita color (sacar c celda))

ponerN :: Int -> Color -> Celda -> Celda 
ponerN  0 c celda  = celda
ponerN  n c celda  = (Bolita c (ponerN (n-1) c celda))                              

data Objeto = Cacharro | Tesoro deriving Show
data Camino = Fin | Cofre [Objeto] Camino | Nada Camino deriving Show 


camino0 :: Camino 
camino0 = Fin 

camino1 :: Camino 
camino1 = Nada camino0 

camino2 :: Camino 
camino2 = Cofre [Cacharro, Cacharro, Tesoro] camino1 

--- Preguntar sobre las pruebas.
camino3 :: Camino 
camino3 = Cofre [Cacharro, Cacharro] camino2 

hayTesoro :: Camino -> Bool
hayTesoro (Cofre objs camino) = hayTesoroEnCofre objs 
hayTesoro Fin                 = False
hayTesoro (Nada camino)       = False || hayTesoro camino

hayTesoroEnCofre :: [Objeto] -> Bool 
hayTesoroEnCofre []         = False
hayTesoroEnCofre (obj:objs) = esTesoro obj || hayTesoroEnCofre objs

esTesoro :: Objeto -> Bool 
esTesoro  Tesoro = True 
esTesoro  _      = False   

pasosHastaTesoro :: Camino -> Int 
--Precondición: Hay al menos un tesoro
pasosHastaTesoro  Fin           = 0
pasosHastaTesoro (Nada c)       = 1 + pasosHastaTesoro c
pasosHastaTesoro (Cofre objs c) = if hayTesoro c
                                  then 1 + pasosHastaTesoro c
                                  else pasosHastaTesoro c

hayTesoroEn :: Int -> Camino -> Bool 
hayTesoroEn n camino = pasosHastaTesoro camino == n

alMenosNTesoros :: Int -> Camino -> Bool 
alMenosNTesoros n camino = n <= cantidadDeTesoros camino


cantidadDeTesoros :: Camino -> Int 
cantidadDeTesoros Fin                  = 0
cantidadDeTesoros (Nada camino)        = unoSi(hayTesoro camino) + cantidadDeTesoros camino
cantidadDeTesoros (Cofre objs camino)  = cantidadDeTesorosEnCofre objs + cantidadDeTesoros camino

cantidadDeTesorosEnCofre :: [Objeto] -> Int 
cantidadDeTesorosEnCofre  []         = 0
cantidadDeTesorosEnCofre  (obj:objs) = unoSi (esTesoro obj) + cantidadDeTesorosEnCofre objs

data Tree a = EmptyT | NodeT a (Tree a) (Tree a) deriving Show

--Preguntar como se representa un arbol.
ejemploDeArbol :: Tree Integer
ejemploDeArbol = 
      NodeT 1 (NodeT 2 (NodeT 3 EmptyT EmptyT) --- Rama izquierda
                       (NodeT 5 EmptyT EmptyT) --- Rama derecha
              )
              (NodeT 6 (NodeT 7 EmptyT EmptyT) --Rama derecha de la raiz, pero es la rama izquierda del 6.
                       EmptyT 
              )

ejemploDeArbol2 :: Tree Integer
ejemploDeArbol2 = NodeT 1(NodeT 2 (NodeT 3 EmptyT EmptyT) 
                                   (NodeT 5 EmptyT EmptyT)) 
                         (NodeT 4 EmptyT EmptyT)

--raiz 1 
-- hijos 2 4 
-- hoja izq es 3 y la derecha es 5 del hijo 2

                         

{- Ejemplo gráfico de un árbol binario
     1 ---Nivel 0
    /  \
    2   6 Nivel 1
   / \  \
   3  5 7 -- nivel 2
  /\ /\ /\      
-}

sumarT :: Tree Int -> Int 
sumarT EmptyT          = 0
sumarT (NodeT n t1 t2) = n + sumarT t1 + sumarT t2

sizeT :: Tree Int -> Int 
sizeT EmptyT           = 0
sizeT (NodeT n t1 t2)  = 1 + (sizeT t1) + (sizeT t2) 

mapDobleT :: Tree Int -> Tree Int
mapDobleT EmptyT          = EmptyT
mapDobleT (NodeT n t1 t2) = (NodeT (n*2) (mapDobleT t1) (mapDobleT t2))


perteneceT :: Eq a => a -> Tree a -> Bool
perteneceT x EmptyT           = False
perteneceT x (NodeT n t1 t2)  = (x==n) || (perteneceT x t1) || (perteneceT x t2)

aparicionesT :: Eq a => a -> Tree a -> Int
aparicionesT  x EmptyT          = 0
aparicionesT  x (NodeT n t1 t2) = if x == n  
                                  then 1 + (aparicionesT x t1) + (aparicionesT x t2) 
                                  else (aparicionesT x t1) + (aparicionesT x t2) 
leaves :: Tree a -> [a]
leaves EmptyT                  = []
leaves (NodeT x EmptyT EmptyT) = [x] 
leaves (NodeT x ti td)         = leaves ti ++ leaves td

heightT :: Tree a -> Int
heightT EmptyT                  = 0
heightT (NodeT x EmptyT EmptyT) = 1
heightT (NodeT x t1 t2)         = 1 + (heightT t1) + (heightT t2)

mirrorT :: Tree a -> Tree a 
mirrorT EmptyT                  = EmptyT 
mirrorT (NodeT x EmptyT EmptyT) = (NodeT x EmptyT         EmptyT     ) 
mirrorT (NodeT x ti     td    ) = (NodeT x (mirrorT td ) (mirrorT ti))

toList :: Tree a -> [a]
toList EmptyT                  = []
toList (NodeT x EmptyT EmptyT) = [x]
toList (NodeT x ti td        ) = x : (toList ti) ++ (toList td)

levelN :: Int -> Tree a -> [a]
levelN   _  EmptyT          = []
levelN   0  (NodeT x _ _  ) = [x]
levelN   n  (NodeT x ti td) = x : ((levelN (n-1) ti) ++ (levelN (n-1) td))

-- [[1] [2,3] [4,5,6,7]] [[2] [3,4] [4,5,6,7]] 
-- [[1,2] [2,3,3,4] [4,5,6,7,4,5,6,7]] 

listPerLevel :: Tree a -> [[a]]
listPerLevel EmptyT          = []
listPerLevel (NodeT x ti td) = [[x]] ++ (juntarNiveles (listPerLevel ti) (listPerLevel td)) 


juntarNiveles :: [[a]] -> [[a]] -> [[a]]
juntarNiveles []   yss          = yss ---Primero lista vacía y después el caso donde no está vacía.
juntarNiveles xss     []        = xss
juntarNiveles (xs:xss) (ys:yss) = (xs ++ ys)  :  juntarNiveles xss yss


ramaMasLarga :: Tree a -> [a]
ramaMasLarga EmptyT          = []
ramaMasLarga (NodeT x ti td) =  if heightT ti >= heightT td   
                                then x : ramaMasLarga ti 
                                else x : ramaMasLarga td

todosLosCaminos :: Tree a -> [[a]]
todosLosCaminos EmptyT                  = []
todosLosCaminos (NodeT x EmptyT EmptyT) = [[x]]
todosLosCaminos (NodeT x ti td)         = prepend x (todosLosCaminos ti ++ todosLosCaminos td)

prepend :: a -> [[a]] -> [[a]]
prepend element []       = []
prepend element (xs:xss) = (element:xs) : prepend element xss



data ExpA = Valor Int | Sum ExpA ExpA | Prod ExpA ExpA | Neg ExpA deriving Show



eval:: ExpA -> Int 
eval (Valor e    ) = e
eval (Sum   e1 e2) = (eval e1) + (eval e2)
eval (Prod  e1 e2) = (eval e1) * (eval e2)
eval (Neg   e    ) = -(eval e)

simplificar :: ExpA -> ExpA 
simplificar (Valor e    )  = Valor e
simplificar (Sum   e1 e2)  = simplificarSuma (simplificar e1) (simplificar e2) 
simplificar (Prod  e1 e2)  = simplificarProducto (simplificar e1) (simplificar e2) 
simplificar (Neg   e    )  = simplificarNegativo (simplificar e)


simplificarSuma :: ExpA -> ExpA -> ExpA
simplificarSuma (Valor 0) e         = e
simplificarSuma e       (Valor 0 )  = e
simplificarSuma e1       e2         = Sum e1 e2 


simplificarProducto :: ExpA -> ExpA -> ExpA 
simplificarProducto (Valor 0) _         = Valor 0
simplificarProducto _         (Valor 0) = Valor 0
simplificarProducto (Valor 1) e         = e
simplificarProducto e         (Valor 1) = e
simplificarProducto e1        e2        = Prod e1 e2    



simplificarNegativo :: ExpA -> ExpA
simplificarNegativo (Neg x) = x
simplificarNegativo x       = Neg x
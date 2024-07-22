module Root.Exercicios.UnBCare where

import Root.Modelo.ModeloDados

{-
 *** Aluno: Vitor Guedes Frade
 *** Matricula: 221017130
 

██╗░░░██╗███╗░░██╗██████╗░  ░█████╗░░█████╗░██████╗░██████╗
██║░░░██║████╗░██║██╔══██╗  ██╔══██╗██╔══██╗██╔══██╗██╔════╝
██║░░░██║██╔██╗██║██████╦╝  ██║░░╚═╝███████║██████╔╝█████╗░░
██║░░░██║██║╚████║██╔══██╗  ██║░░██╗██╔══██║██╔══██╗██╔══╝░░
╚██████╔╝██║░╚███║██████╦╝  ╚█████╔╝██║░░██║██║░░██║███████╗
░╚═════╝░╚═╝░░╚══╝╚═════╝░  ░╚════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚══════╝

O objetivo desse trabalho é fornecer apoio ao gerenciamento de cuidados a serem prestados a um paciente.
O paciente tem um receituario médico, que indica os medicamentos a serem tomados com seus respectivos horários durante um dia.
Esse receituário é organizado em um plano de medicamentos que estabelece, por horário, quais são os remédios a serem
tomados. Cada medicamento tem um nome e uma quantidade de comprimidos que deve ser ministrada.
Um cuidador de plantão é responsável por ministrar os cuidados ao paciente, seja ministrar medicamento, seja comprar medicamento.
Eventualmente, o cuidador precisará comprar medicamentos para cumprir o plano.
O modelo de dados do problema (definições de tipo) está disponível no arquivo Modelo/ModeloDados.hs
Defina funções que simulem o comportamento descrito acima e que estejam de acordo com o referido
modelo de dados.

-}

{-

   QUESTÃO 1, VALOR: 1,0 ponto

Defina a função "comprarMedicamento", cujo tipo é dado abaixo e que, a partir de um medicamento, uma quantidade e um
estoque inicial de medicamentos, retorne um novo estoque de medicamentos contendo o medicamento adicionado da referida
quantidade. Se o medicamento já existir na lista de medicamentos, então a sua quantidade deve ser atualizada no novo estoque.
Caso o remédio ainda não exista no estoque, o novo estoque a ser retornado deve ter o remédio e sua quantidade como cabeça.

-}

inList :: Medicamento -> EstoqueMedicamentos -> Bool
inList _ [] = False
inList medicamento ((x,y):bs) = medicamento == x || inList medicamento bs 

comprarMedicamento :: Medicamento -> Quantidade -> EstoqueMedicamentos -> EstoqueMedicamentos
comprarMedicamento m q [] = [(m, q)]
comprarMedicamento m q estoque
    | inList m estoque = map (\(med, quant) -> if med == m then (med, quant + q) 
                                                else (med, quant)) estoque
    | otherwise = (m, q) : estoque

{-
   QUESTÃO 2, VALOR: 1,0 ponto

Defina a função "tomarMedicamento", cujo tipo é dado abaixo e que, a partir de um medicamento e de um estoque de medicamentos,
retorna um novo estoque de medicamentos, resultante de 1 comprimido do medicamento ser ministrado ao paciente.
Se o medicamento não existir no estoque, Nothing deve ser retornado. Caso contrário, deve se retornar Just v,
onde v é o novo estoque.

-}

tomarMedicamento :: Medicamento -> EstoqueMedicamentos -> Maybe EstoqueMedicamentos
tomarMedicamento _ [] = Nothing 
tomarMedicamento m ((med, q):as) 
    | not (inList m ((med, q):as)) = Nothing 
    | m == med = Just ((med, q-1):as)
    | otherwise = tomarMedicamento m as

{-
   QUESTÃO 3  VALOR: 1,0 ponto

Defina a função "consultarMedicamento", cujo tipo é dado abaixo e que, a partir de um medicamento e de um estoque de
medicamentos, retorne a quantidade desse medicamento no estoque.
Se o medicamento não existir, retorne 0.

-}

consultarMedicamento :: Medicamento -> EstoqueMedicamentos -> Quantidade
consultarMedicamento _ [] = 0
consultarMedicamento m ((med,q):as) 
        | m == med = q 
        | otherwise = consultarMedicamento m as

{-
   QUESTÃO 4  VALOR: 1,0 ponto

  Defina a função "demandaMedicamentos", cujo tipo é dado abaixo e que computa a demanda de todos os medicamentos
  por um dia a partir do receituario. O retorno é do tipo EstoqueMedicamentos e deve ser ordenado lexicograficamente
  pelo nome do medicamento.

  Dica: Observe que o receituario lista cada remédio e os horários em que ele deve ser tomado no dia.
  Assim, a demanda de cada remédio já está latente no receituario, bastando contar a quantidade de vezes que cada remédio
  é tomado.

-}

insertionSortTuples :: Ord a => [(a, b)] -> [(a, b)]
insertionSortTuples [] = []
insertionSortTuples (x:xs) = insertTuple x (insertionSortTuples xs)

insertTuple :: Ord a => (a, b) -> [(a, b)] -> [(a, b)]
insertTuple x [] = [x]
insertTuple x@(med1, _) (y@(med2, _):ys)
    | med1 <= med2 = x : y : ys
    | otherwise    = y : insertTuple x ys

frequenciaMedicamento :: [Int] -> Int 
frequenciaMedicamento [] = 0
frequenciaMedicamento (a:as) = 1 + frequenciaMedicamento as


demandaMedicamentos :: Receituario -> EstoqueMedicamentos
demandaMedicamentos [] = []
demandaMedicamentos r = insertionSortTuples [ (med, frequenciaMedicamento f) | (med, f) <- r ]

{-
   QUESTÃO 5  VALOR: 1,0 ponto, sendo 0,5 para cada função.

 Um receituário é válido se, e somente se, todo os medicamentos são distintos e estão ordenados lexicograficamente e,
 para cada medicamento, seus horários também estão ordenados e são distintos.

 Inversamente, um plano de medicamentos é válido se, e somente se, todos seus horários também estão ordenados e são distintos,
 e para cada horário, os medicamentos são distintos e são ordenados lexicograficamente.

 Defina as funções "receituarioValido" e "planoValido" que verifiquem as propriedades acima e cujos tipos são dados abaixo:

 -}
 
temRepetidos :: Eq a => [a] -> Bool
temRepetidos [] = False
temRepetidos (x:xs)
    | x `elem` xs = True
    | otherwise   = temRepetidos xs
    
    
isCres :: [Int] -> Bool
isCres [] = True
isCres [a] = True
isCres (a:b:as) = a <= b && isCres (b:as)

horarioValido :: [Int] -> Bool
horarioValido [] = False
horarioValido as = not (temRepetidos as) && isCres as 

isOrderLexicografica :: [String] -> Bool
isOrderLexicografica [] = True
isOrderLexicografica [_] = True
isOrderLexicografica (x:y:xs)
    | x <= y    = isOrderLexicografica (y:xs)
    | otherwise = False
    
    
medicamentosValidos :: [String] -> Bool
medicamentosValidos [] = True
medicamentosValidos as = not (temRepetidos as) && isOrderLexicografica as

receituarioValido :: Receituario -> Bool
receituarioValido [] = True
receituarioValido as = not (temRepetidos [m | (m, _) <- as]) && 
                        isOrderLexicografica [m | (m, _) <- as] &&
                        foldr (&&) True (map horarioValido [h | (_, h) <- as])


planoValido :: PlanoMedicamento -> Bool
planoValido [] = True
planoValido as = not (temRepetidos [h | (h, _) <- as]) && -- se nao tem horario repetido
                isCres [h | (h, _) <- as] &&              -- se os horarios estao ordenados
                foldr (&&) True (map medicamentosValidos [m | (_,m) <- as]) -- se os medicamentos sao diferentes e ordenados

{-

   QUESTÃO 6  VALOR: 1,0 ponto,

 Um plantão é válido se, e somente se, todas as seguintes condições são satisfeitas:

 1. Os horários da lista são distintos e estão em ordem crescente;
 2. Não há, em um mesmo horário, ocorrência de compra e medicagem de um mesmo medicamento (e.g. `[Comprar m1, Medicar m1 x]`);
 3. Para cada horário, as ocorrências de Medicar estão ordenadas lexicograficamente.

 Defina a função "plantaoValido" que verifica as propriedades acima e cujo tipo é dado abaixo:

 -}
 
verificarAcoes :: [Cuidado] -> Bool
verificarAcoes [] = True
verificarAcoes (x:xs) = case x of
    Comprar m q      -> False
    Medicar m      -> verificarAcoes xs 
    
medicamentosCuidado :: [Cuidado] -> [Medicamento]
medicamentosCuidado [] = []
medicamentosCuidado (c:cs) = case c of
        Comprar m _ -> m: medicamentosCuidado cs
        Medicar m   -> m: medicamentosCuidado cs
        
medicamentosMedicar :: [Cuidado] -> [Medicamento]
medicamentosMedicar [] = []
medicamentosMedicar (c:cs) = case c of
        Comprar _ _ -> medicamentosMedicar cs 
        Medicar m   -> m: medicamentosMedicar cs

plantaoValido :: Plantao -> Bool
plantaoValido [] = True
plantaoValido as = horarioValido [x | (x,c) <- as] &&
        not (or (map temRepetidos [medicamentosCuidado c | (x,c) <- as])) && -- verifica se os medicamentos nao repetem
        and (map isOrderLexicografica [medicamentosMedicar c | (x,c) <- as]) -- verifica se os medicamentos estão em ordenado
                   
                   

{-
   QUESTÃO 7  VALOR: 1,0 ponto

  Defina a função "geraPlanoReceituario", cujo tipo é dado abaixo e que, a partir de um receituario válido,
  retorne um plano de medicamento válido.

  Dica: enquanto o receituário lista os horários que cada remédio deve ser tomado, o plano de medicamentos  é uma
  disposição ordenada por horário de todos os remédios que devem ser tomados pelo paciente em um certo horário.

-}

inserirMedicamento :: Medicamento -> [Medicamento] -> [Medicamento]
inserirMedicamento m [] = [m]
inserirMedicamento m (a:as)
    | m <= a    = m : a : as
    | otherwise = a : inserirMedicamento m as
    
concatLists :: [[a]] -> [a]
concatLists [] = []
concatLists (x:xs) = x ++ concatLists xs

removeDuplicates :: Eq a => [a] -> [a]
removeDuplicates [] = []
removeDuplicates (x:xs) = x : removeDuplicates (filter (/= x) xs)

insertionSort :: Ord a => [a] -> [a]
insertionSort [] = []
insertionSort (x:xs) = insert x (insertionSort xs)
  where
    insert x [] = [x]
    insert x (y:ys)
        | x <= y    = x : y : ys
        | otherwise = y : insert x ys

horariosPlano :: Receituario -> [Horario]
horariosPlano r = insertionSort (removeDuplicates (concatLists (map snd r)))

geraPlanoReceituario :: Receituario -> PlanoMedicamento
geraPlanoReceituario r = foldr adicionarMedicamentosPorHorario [] (horariosPlano r)
  where
    adicionarMedicamentosPorHorario :: Horario -> PlanoMedicamento -> PlanoMedicamento
    adicionarMedicamentosPorHorario h plano = (h, medicamentosNoHorario h r) : plano

    medicamentosNoHorario :: Horario -> Receituario -> [Medicamento]
    medicamentosNoHorario h r = foldr (\(m, hs) acc -> if h `elem` hs then inserirMedicamento m acc else acc) [] r

{- QUESTÃO 8  VALOR: 1,0 ponto

 Defina a função "geraReceituarioPlano", cujo tipo é dado abaixo e que retorna um receituário válido a partir de um
 plano de medicamentos válido.
 Dica: Existe alguma relação de simetria entre o receituário e o plano de medicamentos? Caso exista, essa simetria permite
 compararmos a função geraReceituarioPlano com a função geraPlanoReceituario ? Em outras palavras, podemos definir
 geraReceituarioPlano com base em geraPlanoReceituario ?

-}

medicamentosPlano :: PlanoMedicamento -> [Medicamento]
medicamentosPlano p = insertionSort (removeDuplicates (concatLists (map snd p)))

geraReceituarioPlano :: PlanoMedicamento -> Receituario
geraReceituarioPlano p = foldr adicionarHorarioPorMedicamento [] (medicamentosPlano p)
  where
    adicionarHorarioPorMedicamento :: Medicamento -> Receituario -> Receituario
    adicionarHorarioPorMedicamento m receituario = (m, horarioDoMedicamento m p) : receituario

    horarioDoMedicamento :: Medicamento -> PlanoMedicamento -> [Horario]
    horarioDoMedicamento m plano = foldr (\(h, ms) acc -> if m `elem` ms then h : acc else acc) [] plano

{-  QUESTÃO 9 VALOR: 1,0 ponto

Defina a função "executaPlantao", cujo tipo é dado abaixo e que executa um plantão válido a partir de um estoque de medicamentos,
resultando em novo estoque. A execução consiste em desempenhar, sequencialmente, todos os cuidados para cada horário do plantão.
Caso o estoque acabe antes de terminar a execução do plantão, o resultado da função deve ser Nothing. Caso contrário, o resultado
deve ser Just v, onde v é o valor final do estoque de medicamentos

-}

usarRemedioHorario :: [Cuidado] -> Medicamento -> Quantidade -> (Medicamento,Quantidade)
usarRemedioHorario [] m q = (m,q)
usarRemedioHorario (c:cs) m q = case c of 
        Comprar medComprar quant -> if m == medComprar 
                                    then usarRemedioHorario cs m (q + quant)
                                    else usarRemedioHorario cs m q
                                    
        Medicar medMedicar   -> if m == medMedicar
                                then usarRemedioHorario cs m (q - 1)
                                else usarRemedioHorario cs m q

usarRemedio :: Plantao -> (Medicamento, Quantidade) -> (Medicamento, Quantidade)
usarRemedio [] a = a
usarRemedio ((_, cs):hs) (m, q) = usarRemedio hs (usarRemedioHorario cs m q)
        
executaPlantao :: Plantao -> EstoqueMedicamentos -> Maybe EstoqueMedicamentos
executaPlantao _ [] = Just []
executaPlantao [] e = Just e
executaPlantao plantao (m:ms) = case usarRemedio plantao m of
    (med, quant) | quant < 0 -> Nothing
                 | otherwise -> case executaPlantao plantao ms of
                                  Nothing -> Nothing
                                  Just restoEstoque -> Just ((med, quant) : restoEstoque) 

{-
QUESTÃO 10 VALOR: 1,0 ponto

Defina uma função "satisfaz", cujo tipo é dado abaixo e que verifica se um plantão válido satisfaz um plano
de medicamento válido para um certo estoque, ou seja, a função "satisfaz" deve verificar se a execução do plantão
implica terminar com estoque diferente de Nothing e administrar os medicamentos prescritos no plano.
Dica: fazer correspondencia entre os remédios previstos no plano e os ministrados pela execução do plantão.
Note que alguns cuidados podem ser comprar medicamento e que eles podem ocorrer sozinhos em certo horário ou
juntamente com ministrar medicamento.

-}

executarCuidado :: EstoqueMedicamentos -> Cuidado -> EstoqueMedicamentos
executarCuidado [] _ = []
executarCuidado ((m, q):ms) cuidado = case cuidado of
                                  Medicar med -> if m == med
                                    then (m, q - 1) : ms
                                    else (m, q) : executarCuidado ms cuidado
                                  Comprar med quant -> if m == med
                                    then (m, q + quant) : ms
                                    else (m, q) : executarCuidado ms cuidado
                                        
ajustarEstoque :: EstoqueMedicamentos -> Medicamento -> Int -> EstoqueMedicamentos
ajustarEstoque [] med _ = []
ajustarEstoque ((m, quant):ms) med q
  | m == med = (m, quant + q) : ms
  | otherwise = (m, quant) : ajustarEstoque ms med q


medicamentoDisponivel :: Medicamento -> EstoqueMedicamentos -> Bool
medicamentoDisponivel med [] = False
medicamentoDisponivel med ((m, quant):ms)
  | med == m = quant > 0
  | otherwise = medicamentoDisponivel med ms

administrarMeds :: EstoqueMedicamentos -> [Medicamento] -> EstoqueMedicamentos
administrarMeds estoque [] = estoque
administrarMeds estoque (m:meds) = administrarMeds (ajustarEstoque estoque m (-1)) meds


satisfaz :: Plantao -> PlanoMedicamento -> EstoqueMedicamentos -> Bool
satisfaz [] [] estoque = True
satisfaz ((h1, cuidados):plantoes) ((h2, meds):planos) estoque
  | h1 /= h2 = False
  | otherwise = let estoqueAtualizado = foldl (executarCuidado) estoque cuidados
                in if all (`medicamentoDisponivel` estoqueAtualizado) meds
                   then satisfaz plantoes planos (administrarMeds estoqueAtualizado meds)
                   else False



{-

QUESTÃO 11 VALOR: 1,0 ponto

 Defina a função "plantaoCorreto", cujo tipo é dado abaixo e que gera um plantão válido que satisfaz um plano de
 medicamentos válido e um estoque de medicamentos.
 Dica: a execução do plantão deve atender ao plano de medicamentos e ao estoque.

-}

plantaoCorreto :: PlanoMedicamento -> EstoqueMedicamentos -> Plantao
plantaoCorreto = undefined

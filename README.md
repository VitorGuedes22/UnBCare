# UnBCare - Gerenciamento de Cuidados Médicos

Este projeto foi desenvolvido em Haskell e tem como objetivo fornecer suporte ao gerenciamento de cuidados para pacientes, permitindo que cuidadores administrem medicamentos e façam compras de suprimentos quando necessário. A estrutura é baseada em um receituário médico, que estabelece os horários e medicamentos a serem administrados ao longo do dia.

## Objetivo

Simular um sistema de gerenciamento de medicamentos para um paciente, organizando o estoque, planos de medicamentos e ações do cuidador durante seu plantão. O cuidador pode ministrar medicamentos e, se necessário, comprar mais remédios para atender à demanda estabelecida no plano de cuidados.

## Estrutura do Projeto

### Módulos Principais

- **ModeloDados.hs**: Define os tipos de dados principais do projeto, como medicamentos, receituário, plano de medicamentos, plantão, e ações que o cuidador pode realizar (comprar ou administrar medicamentos).
  
- **UnBCare.hs**: Contém a lógica de funcionamento, onde são implementadas as funções que gerenciam o estoque de medicamentos, verificam se o plano de medicamentos é viável e controlam a execução das tarefas do cuidador.

- **Testes.hs**: Módulo de testes que utiliza a biblioteca Hspec para garantir o correto funcionamento das funcionalidades implementadas.

### Funcionalidades Implementadas

- **Estoque de Medicamentos**: Controle sobre a quantidade de cada medicamento disponível. O estoque pode ser atualizado com novas compras ou quando medicamentos são ministrados ao paciente.
  
- **Receituário e Plano de Medicamentos**: O receituário define os medicamentos e horários em que devem ser tomados. Com base nisso, é gerado um plano de medicamentos, organizando por horário quais medicamentos precisam ser ministrados.
  
- **Cuidador em Plantão**: Durante o plantão, o cuidador administra medicamentos de acordo com o plano ou realiza compras quando o estoque é insuficiente para cumprir a demanda.

### Exemplos de Uso

- **Adicionar Medicamentos ao Estoque**: A função `comprarMedicamento` atualiza o estoque de medicamentos com novas compras, permitindo que o plano de cuidados seja executado.
  
- **Administrar Medicamentos**: A função `tomarMedicamento` simula a administração de um medicamento ao paciente, decrementando a quantidade no estoque.

- **Validar Receituário e Plano**: Funções que verificam a validade do receituário e do plano de medicamentos, garantindo que ambos estejam ordenados corretamente por horário e medicamento.

### Testes

Os testes foram implementados utilizando a biblioteca [Hspec](https://hspec.github.io/), e abrangem as funcionalidades principais do sistema:

- Compra e administração de medicamentos.
- Validação de receituários e planos.
- Execução de plantões conforme o estoque disponível.

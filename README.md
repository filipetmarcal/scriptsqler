# Banco de Dados para Oficina Mecânica

## Descrição do Projeto
Este projeto consiste na modelagem e implementação de um banco de dados para gerenciar as operações de uma oficina mecânica. Ele abrange a gestão de clientes, veículos, serviços, ordens de serviço, funcionários, peças e fornecedores. O objetivo é permitir consultas complexas para obtenção de insights sobre a oficina.

## Estrutura do Banco de Dados
O banco de dados foi modelado a partir de um modelo entidade-relacionamento (ER) e convertido para um modelo relacional usando o algoritmo de mapeamento. As principais tabelas incluem:

- **Clientes**: Armazena informações dos clientes.
- **Veículos**: Relacionados aos clientes.
- **Funcionários**: Inclui mecânicos e outros cargos.
- **Serviços**: Representa os tipos de serviços prestados.
- **Ordens de Serviço**: Vincula serviços, veículos e mecânicos.
- **Peças**: Itens utilizados nos reparos.
- **Fornecedores**: Empresas que fornecem peças.

## Scripts SQL
O repositório inclui:
1. **Criação do Banco de Dados** - Arquivo SQL contendo os comandos para criar as tabelas.
2. **Inserção de Dados** - População do banco com dados de teste.
3. **Consultas SQL Complexas** - Queries para responder perguntas relevantes, como:
   - Quais clientes gastaram mais?
   - Quais mecânicos realizaram mais serviços?
   - Quais são os serviços mais lucrativos?

## Como Executar
1. Clone este repositório.
2. Importe o script SQL no seu SGBD (MySQL, PostgreSQL, etc.).
3. Execute as consultas para testar as funcionalidades.

## Contato
Caso tenha dúvidas ou sugestões, entre em contato!

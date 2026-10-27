/**
 * Arquivo: 04_nosql_poc.js
 * Projeto: Omnichannel NoSQL
 * Banco de dados: omnichannel_nosql
 * Coleção: logs_navegacao
 */

// Selecionar o banco de dados
use('omnichannel_nosql');

// Inserir três documentos de navegação
const resultado = db.getCollection('logs_navegacao').insertMany([
    {
        cliente_id: 101,
        data_hora: new Date(),
        evento: "clique",
        pagina_visitada: "/produto/smartphone-galaxy-s23",
        dispositivo: "Mobile"
    },
    {
        cliente_id: 102,
        data_hora: new Date(),
        evento: "visualizacao",
        pagina_visitada: "/carrinho",
        dispositivo: "Desktop"
    },
    {
        cliente_id: 103,
        data_hora: new Date(),
        evento: "pesquisa",
        pagina_visitada: "/busca",
        termo_pesquisa: "fone bluetooth",
        dispositivo: "Tablet"
    }
]);

// Exibir o resultado da inserção
print("Documentos inseridos com sucesso:");
printjson(resultado);

// Consultar todos os registros
print("Logs de navegacao:");
db.getCollection('logs_navegacao').find({}).pretty();

// Contar os documentos existentes
print("Total de documentos na colecao:");
print(db.getCollection('logs_navegacao').countDocuments({}));

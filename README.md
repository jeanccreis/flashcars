# FlashCars API

API simples para gerenciamento de carros usando Sinatra.

## Estrutura do Projeto

```
flashcars/
├── app/
│   ├── controllers/     # Rotas e endpoints da API
│   ├── models/          # Modelos de dados
│   ├── services/        # Lógica de negócio
│   └── helpers/         # Funções auxiliares
├── config/              # Configurações da aplicação
├── db/                  # Banco de dados
│   ├── migrate/         # Migrations
│   └── seeds/           # Seeds
├── lib/                 # Bibliotecas customizadas
├── spec/                # Testes
├── public/              # Arquivos estáticos
├── config.ru            # Configuração Rack
├── Gemfile              # Dependências
└── README.md            # Este arquivo
```

## Instalação

```bash
bundle install
```

## Executar

```bash
bundle exec rackup -p 4567
```

ou

```bash
bundle exec puma config.ru -p 4567
```

## Endpoints

### Health Check
- `GET /health` - Verifica se a API está funcionando

### Cars
- `GET /api/cars` - Lista todos os carros
- `GET /api/cars/:id` - Retorna um carro específico
- `POST /api/cars` - Cria um novo carro
- `PUT /api/cars/:id` - Atualiza um carro
- `DELETE /api/cars/:id` - Remove um carro

## Exemplo de Requisição

```bash
# Listar carros
curl http://localhost:4567/api/cars

# Criar carro
curl -X POST http://localhost:4567/api/cars \
  -H "Content-Type: application/json" \
  -d '{"model":"Civic","brand":"Honda","year":2024}'
```

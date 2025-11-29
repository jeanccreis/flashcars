# API Authentication Guide

## Visão Geral

A API FlashCars é uma **API somente leitura (read-only)** que utiliza autenticação por API Key para proteger os endpoints. Todas as requisições aos endpoints `/api/v1/cars` requerem uma chave de API válida.

**Nota:** Esta API permite apenas consultar carros. Não é possível criar, atualizar ou deletar registros através da API.

## Gerenciamento de API Keys

### 1. Criar uma Nova API Key

```bash
POST /api/v1/api-keys
Content-Type: application/json

{
  "name": "Minha Aplicação"
}
```

**Resposta de Sucesso (201):**
```json
{
  "id": 1,
  "name": "Minha Aplicação",
  "key": "sk_1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef",
  "created_at": "2025-11-28T19:50:00.000Z"
}
```

**IMPORTANTE:** Guarde a chave retornada em local seguro. Ela não será exibida novamente.

### 2. Listar API Keys

```bash
GET /api/v1/api-keys
```

**Resposta:**
```json
{
  "api_keys": [
    {
      "id": 1,
      "name": "Minha Aplicação",
      "key_preview": "sk_12345678...cdef",
      "revoked": false,
      "revoked_at": null,
      "last_used_at": "2025-11-28T20:00:00.000Z",
      "created_at": "2025-11-28T19:50:00.000Z"
    }
  ]
}
```

### 3. Revogar uma API Key

```bash
DELETE /api/v1/api-keys/:id
```

**Resposta:**
```json
{
  "message": "API key revoked successfully"
}
```

## Usando API Keys nas Requisições

Existem duas formas de enviar sua API key:

### Método 1: Header Authorization (Recomendado)

```bash
curl -H "Authorization: Bearer sk_1234567890abcdef..." \
     http://localhost:9292/api/v1/cars
```

### Método 2: Header X-API-Key

```bash
curl -H "X-API-Key: sk_1234567890abcdef..." \
     http://localhost:9292/api/v1/cars
```

## Exemplos de Uso (Somente Leitura)

### Listar Todos os Carros

```bash
curl -H "Authorization: Bearer sk_1234567890abcdef..." \
     http://localhost:9292/api/v1/cars
```

**Resposta:**
```json
{
  "cars": [
    {
      "id": 1,
      "model": "Civic",
      "brand": "Honda",
      "year": 2024,
      "color": "Prata"
    },
    {
      "id": 2,
      "model": "Corolla",
      "brand": "Toyota",
      "year": 2023,
      "color": "Branco"
    }
  ],
  "total": 2
}
```

### Buscar um Carro Específico

```bash
curl -H "Authorization: Bearer sk_1234567890abcdef..." \
     http://localhost:9292/api/v1/cars/1
```

**Resposta:**
```json
{
  "id": 1,
  "model": "Civic",
  "brand": "Honda",
  "year": 2024,
  "color": "Prata"
}
```

## Respostas de Erro

### 401 - API Key Ausente

```json
{
  "error": "API key required"
}
```

### 401 - API Key Inválida ou Revogada

```json
{
  "error": "Invalid or revoked API key"
}
```

## Segurança

- As API keys têm o prefixo `sk_` seguido de 64 caracteres hexadecimais
- Keys revogadas não podem ser reativadas, uma nova deve ser criada
- O timestamp de último uso é atualizado automaticamente a cada requisição
- Mantenha suas API keys em segredo e nunca as compartilhe publicamente
- Use variáveis de ambiente para armazenar suas keys em produção

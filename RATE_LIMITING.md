# Rate Limiting por Plano de Usuário

Este projeto implementa rate limiting baseado no plano do **usuário**, não da API key individual. Isso previne que usuários burlem o limite criando múltiplas API keys.

## Planos Disponíveis

| Plano | Limite de Requisições | Período |
|-------|----------------------|---------|
| Free  | 100 requisições     | 1 hora  |
| Basic | 1,000 requisições   | 1 hora  |
| Pro   | 10,000 requisições  | 1 hora  |

## Como Funciona

O rate limiting é implementado usando a gem `rack-attack` e funciona da seguinte forma:

1. Cada usuário possui um plano associado (`free`, `basic` ou `pro`)
2. Um usuário pode ter **múltiplas API keys**, mas todas compartilham o mesmo limite
3. O Rack::Attack verifica cada requisição e incrementa um contador **por usuário** (user_id)
4. Quando o limite do usuário é atingido, requisições de **todas** as suas API keys retornam erro 429
5. O contador é resetado após o período (1 hora)

### Exemplo

Se João (plano free, limite 100/hora) possui 3 API keys:
- Key A faz 60 requisições
- Key B faz 30 requisições
- Key C faz 10 requisições
- **Total: 100 requisições (limite atingido)**
- Próxima requisição com qualquer uma das 3 keys será bloqueada

## Headers de Resposta

Todas as respostas da API incluem os seguintes headers:

- `X-RateLimit-Limit`: Limite total de requisições para o plano do usuário
- `X-RateLimit-Remaining`: Número de requisições restantes no período atual
- `X-RateLimit-Reset`: Timestamp Unix de quando o contador será resetado
- `X-RateLimit-Plan`: Nome do plano do usuário
- `X-RateLimit-User`: Email do usuário (para debug)

## Exemplo de Uso

```bash
# Fazer uma requisição
curl -X GET http://localhost:9292/api/v1/cars \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -i

# Resposta (headers)
HTTP/1.1 200 OK
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 99
X-RateLimit-Reset: 1764435600
X-RateLimit-Plan: free
X-RateLimit-User: joao@example.com
```

### Demonstrando Rate Limit por Usuário

```bash
# Usuário com 2 API keys diferentes
KEY_1="sk_04f09921ecb561cb108eff4ef6fb8e44d61933b99508b30fd6a70a76c87c4ca9"
KEY_2="sk_a6975e76d70ff65399d8b3b25ab1de523f47a8b00b541c1173f4dc8fad82ffff"

# Requisição com Key 1
curl -X GET http://localhost:9292/api/v1/cars -H "Authorization: Bearer $KEY_1" -i
# X-RateLimit-Remaining: 99
# X-RateLimit-User: joao@example.com

# Requisição com Key 2 (mesmo usuário)
curl -X GET http://localhost:9292/api/v1/cars -H "Authorization: Bearer $KEY_2" -i
# X-RateLimit-Remaining: 98 (contador compartilhado!)
# X-RateLimit-User: joao@example.com
```

## Resposta quando o Limite é Atingido

Quando você excede o limite de requisições, receberá:

```json
{
  "error": "Rate limit exceeded",
  "message": "You have exceeded your rate limit. Please try again in 2847 seconds.",
  "retry_after": 2847
}
```

Status HTTP: `429 Too Many Requests`

Headers adicionais:
- `Retry-After`: Número de segundos até que você possa fazer novas requisições

## Gerenciando Usuários e API Keys

### Criar um novo usuário

```ruby
# No console Ruby (irb -r ./config/environment)
user = User.create!(
  name: "João Silva",
  email: "joao@example.com",
  plan: "free"  # ou 'basic', 'pro'
)
```

### Criar API keys para um usuário

```ruby
# Criar uma API key para o usuário
user = User.find_by(email: "joao@example.com")
api_key = user.api_keys.create!(name: "Minha primeira key")
puts "Key criada: #{api_key.key}"

# Criar múltiplas keys
3.times do |i|
  key = user.api_keys.create!(name: "Key #{i + 1}")
  puts "#{key.name}: #{key.key}"
end
```

### Atualizar o plano de um usuário

```ruby
# IMPORTANTE: O plano é do usuário, não da API key
user = User.find_by(email: "joao@example.com")
user.update(plan: "pro")

# Agora TODAS as API keys deste usuário terão limite de 10000 req/hora
```

### Listar usuários e suas API keys

```ruby
User.all.each do |user|
  puts "\n#{user.name} (#{user.email}) - Plan: #{user.plan}"
  puts "  Limite: #{user.rate_limit} req/hora"
  puts "  API Keys:"
  user.api_keys.each do |key|
    status = key.active? ? "ativa" : "revogada"
    puts "    - #{key.name}: #{key.key[0..20]}... (#{status})"
  end
end
```

### Revogar uma API key específica

```ruby
# Revogar uma key não afeta o rate limit do usuário
# Outras keys do mesmo usuário continuam funcionando
api_key = ApiKey.find_by(key: "sk_...")
api_key.revoke!
```

## Configuração

A configuração do rate limiting está em:
- `config/initializers/rack_attack.rb` - Configuração do Rack::Attack (throttle por user_id)
- `app/models/user.rb` - Definição dos planos e limites
- `app/models/api_key.rb` - Relacionamento com User
- `app/helpers/rate_limit_helper.rb` - Helper para adicionar headers

## Por Que Rate Limit por Usuário?

**Problema:** Se o rate limiting fosse por API key, um usuário poderia:
1. Criar 10 API keys no plano free
2. Fazer 100 requisições com cada key
3. Total: 1000 requisições/hora ao invés de 100

**Solução:** Rate limiting por usuário:
1. Usuário tem 10 API keys no plano free
2. Todas as keys compartilham o limite de 100 req/hora
3. Total: máximo 100 requisições/hora independente de quantas keys o usuário criar

## Nota sobre Escalabilidade

A implementação atual usa `ActiveSupport::Cache::MemoryStore` para desenvolvimento.
Para produção com múltiplos servidores, configure Redis:

```ruby
# config/initializers/rack_attack.rb
Rack::Attack.cache.store = ActiveSupport::Cache::RedisCacheStore.new(url: ENV['REDIS_URL'])
```

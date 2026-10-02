# Atalhos — LazyVim com cara de VSCode

Abra esta tela a qualquer hora: **Ctrl+K Ctrl+S** ou `:Atalhos`.

## Primeiro, o essencial

O Neovim tem **modos**. O que muda em relação ao VSCode:

- **Normal** (o padrão ao abrir): as teclas são comandos, não texto.
- **Inserção**: aperte `i` (ou clique e comece pelo `i`) para digitar. `Esc` volta ao Normal.
- **Seleção**: arraste com o mouse ou use Shift+setas. Digitar substitui o texto, como no VSCode.

Todos os atalhos abaixo funcionam em qualquer modo, então dá para usar como VSCode desde o primeiro dia.
Na parte de baixo tem o caminho para aprender o jeito Vim, se e quando quiser.

## Arquivo e abas

| Atalho              | Faz                               |
|---------------------|-----------------------------------|
| Ctrl+S              | Salvar                            |
| Ctrl+N              | Novo arquivo                      |
| Ctrl+W              | Fechar aba                        |
| Ctrl+Tab            | Próxima aba (Ctrl+Shift+Tab volta)|
| Ctrl+PgDn / PgUp    | Próxima / anterior aba            |
| Ctrl+P              | Abrir arquivo pelo nome           |
| Ctrl+B              | Mostrar/esconder explorador       |
| `:q`  /  `:qa`      | Sair da janela / sair de tudo     |

## Editar

| Atalho              | Faz                                     |
|---------------------|-----------------------------------------|
| Ctrl+C / X / V      | Copiar / recortar / colar (sem seleção: linha inteira) |
| Ctrl+Z              | Desfazer                                |
| Ctrl+Y ou Ctrl+Shift+Z | Refazer                              |
| Ctrl+A              | Selecionar tudo                         |
| Ctrl+/              | Comentar linha ou seleção               |
| Alt+↑ / Alt+↓       | Mover linha                             |
| Shift+Alt+↑ / ↓     | Duplicar linha                          |
| Ctrl+Shift+K        | Apagar linha                            |
| Ctrl+Enter          | Nova linha abaixo (Ctrl+Shift+Enter: acima) |
| Ctrl+Backspace      | Apagar palavra                          |
| Tab / Shift+Tab     | Indentar / desindentar seleção          |
| Shift+Alt+F         | Formatar documento                      |
| Alt+Z               | Liga/desliga quebra de linha            |

## Multicursor

| Atalho              | Faz                                     |
|---------------------|-----------------------------------------|
| Ctrl+D              | Selecionar a próxima ocorrência da palavra |
| Ctrl+Shift+L        | Selecionar todas as ocorrências         |
| Ctrl+K Ctrl+D       | Pular esta ocorrência                   |
| Ctrl+Shift+↑ / ↓    | Adicionar cursor acima / abaixo         |
| Alt+clique          | Adicionar cursor                        |
| Esc                 | Sair do multicursor                     |

Com vários cursores, aperte `i` para digitar em todos.

## Buscar e substituir

| Atalho              | Faz                                     |
|---------------------|-----------------------------------------|
| Ctrl+F              | Buscar no arquivo                       |
| Ctrl+H              | Substituir no arquivo                   |
| Ctrl+Shift+F        | Buscar no projeto                       |
| Ctrl+Shift+H        | Substituir no projeto                   |
| Ctrl+G              | Ir para a linha                         |
| Ctrl+Shift+P ou F1  | Paleta de comandos                      |

## Código

| Atalho              | Faz                                     |
|---------------------|-----------------------------------------|
| F12 ou Ctrl+clique  | Ir para a definição                     |
| Shift+F12           | Ver referências                         |
| F2                  | Renomear símbolo                        |
| Ctrl+.              | Ações rápidas (lâmpada)                 |
| Ctrl+Espaço         | Sugestões de autocompletar              |
| Ctrl+T              | Buscar símbolo no projeto               |
| F8 / Shift+F8       | Próximo / anterior problema             |
| Ctrl+Shift+M        | Painel de problemas                     |

## Painéis

| Atalho              | Faz                                     |
|---------------------|-----------------------------------------|
| Ctrl+' (ou Ctrl+`)  | Abrir/esconder terminal                 |
| Ctrl+Shift+G        | Git (lazygit)                           |
| Ctrl+Shift+E        | Explorador                              |

No explorador: `Enter` abre, `a` cria arquivo (termine com `/` para pasta), `d` apaga, `r` renomeia, `H` mostra ocultos.

## Mouse

Clique posiciona, arrastar seleciona, duplo clique pega a palavra, a rodinha rola,
clique nas abas troca de arquivo, e o **botão direito** abre um menu com copiar/colar,
ir para definição, renomear e comentar.

## A tecla Espaço (líder)

Aperte **Espaço** e espere meio segundo: aparece um menu com tudo que o LazyVim sabe fazer,
agrupado por letra. Os mais úteis:

| Atalho              | Faz                                     |
|---------------------|-----------------------------------------|
| Espaço Espaço       | Abrir arquivo                           |
| Espaço /            | Buscar no projeto                       |
| Espaço e            | Explorador                              |
| Espaço h            | Voltar para a tela inicial              |
| Espaço g g          | Git                                     |
| Espaço s k          | Buscar em **todos** os atalhos          |
| Espaço c m          | Mason: instalar servidores de linguagem |
| Espaço l            | Lazy: plugins (atualizar = `U`)         |
| `:LazyExtras`       | Extras do LazyVim (linguagens etc.)     |
| Espaço q q          | Sair                                    |

## Aprendendo o jeito Vim (opcional, mas vale a pena)

Faça o tutorial interativo: digite `:Tutor` e aperte Enter (uns 30 minutos).
Depois, um passo por semana, no modo Normal:

1. **Andar**: `h j k l` (← ↓ ↑ →), `w` / `b` pula palavra, `0` / `$` início/fim da linha, `gg` / `G` topo/fim.
2. **Entrar para digitar**: `i` antes do cursor, `a` depois, `o` linha nova abaixo, `O` acima, `A` fim da linha.
3. **Operadores**: `d` apaga, `c` troca, `y` copia, `p` cola. Combine com um movimento:
   `dw` apaga palavra, `cw` troca palavra, `dd` apaga linha, `yy` copia linha, `d$` apaga até o fim.
4. **Dentro de**: `ciw` troca a palavra inteira, `ci"` troca o texto entre aspas, `di(` apaga dentro dos parênteses.
5. **Repetir**: `.` repete a última edição. `u` desfaz, `Ctrl+R` refaz.
6. **Pular**: `s` + duas letras pula para qualquer lugar da tela (flash).
7. **Buscar**: `/texto` Enter, depois `n` / `N` para a próxima/anterior.

Alguns atalhos do Vim foram trocados pelos do VSCode (Ctrl+V, Ctrl+A, Ctrl+D, Ctrl+W...).
Para a seleção em bloco do Vim, use **Ctrl+Q**. Para janelas divididas, **Espaço w**.

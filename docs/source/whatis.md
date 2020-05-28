# Introdução

Em termos gerais, blockchain é um sistema de livro-razão com registros imutáveis,
mantido em uma rede distribuída por múltiplos nós pares (_peer nodes_). Esses nós 
mantêm uma cópia do livro-razão contendo as transações que foram validadas por 
um protocolo de consenso e agrupadas em blocos que inclue um hash que liga cada
bloco ao bloco anterior.

A aplicação amplamente reconhecida do blockchain é a criptomoeda 
[Bitcoin](https://en.wikipedia.org/wiki/Bitcoin), embora outras moedas tenham 
seguido seus passos. A Ethereum, uma criptomoeda alternativa, adotou uma abordagem 
diferente, integrando muitas das mesmas características do Bitcoin, mas 
adicionando contratos inteligentes (_smart contracts_) para criar uma plataforma 
para aplicativos distribuídos. Bitcoin e Ethereum se enquadram em uma classe de
blockchain que classificamos como tecnologia de blockchain de permissão pública 
(_public permissionless_). Basicamente, são redes públicas, abertas a qualquer 
pessoa, onde os participantes interagem anonimamente.

À medida que a popularidade do Bitcoin, Ethereum e algumas outras tecnologias 
derivadas aumentavam, o interesse em aplicar as tecnologias subjacentes do blockchain, 
como, registro distribuído e a plataforma de aplicativos distribuídos em casos 
de uso mais inovadores para _empresas_ também crescia. No entanto, muitos casos 
de uso corporativos exigem características de desempenho que as tecnologias blockchain 
sem permissão não conseguem (atualmente) atender. Além disso, em muitos casos de
uso, a identidade dos participantes é um requisito obrigatório, como no caso de 
transações financeiras, onde é obrigatório conhecer o consumidor 
(_Know-Your-Customer - KYC_) e regras antí-lavagem de dinheiro devem ser seguidas 
(_Anti-Money Laundering - AML_).

Para uso corporativo, precisamos considerar os seguintes requisitos:

- Os participantes devem ser identificados/identificáveis
- As redes precisam ser _permissionadas_
- Alta performance nas transações
- Baixa latência na confirmação das transações
- Privacidade e confidencialidade nas transações e nos dados referentes as
transações comerciais

Embora muitas plataformas de blockchain antigas estejam sendo _adaptadas_ para 
uso corporativo, o Hyperledger Fabric foi _projetado_ para uso corporativo 
desde o início. As seções a seguir descrevem como o Hyperledger Fabric 
(Fabric) se diferencia de outras plataformas de blockchain e descreve algumas
das motivações para suas decisões de arquitetura.

## Hyperledger Fabric

O Hyperledger Fabric é uma plataforma de tecnologia de livro-razão 
distribuído (Distributed Ledger Technology - DLT) de nível empresarial e código
aberto, projetada para uso em ambientes empresariais e que fornece alguns
recursos diferenciados importantes em relação a outras plataformas populares de
livro-razão distribuído ou blockchain.

Um ponto chave de diferenciação é que o Hyperledger foi estabelecido sob a Linux 
Foundation, que possui uma história longa e muito bem-sucedida de fomentar 
projetos de código aberto sob **governança aberta** que desenvolvem 
comunidades sustentáveis fortes e ecossistemas prósperos. O Hyperledger é 
governado por um comitê de direção técnica diversificada e o projeto Hyperledger
Fabric por um conjunto diversificado de mantenedores de várias organizações. 
Tem uma comunidade de desenvolvimento que ultrapassa 35 organizações e
quase 200 desenvolvedores desde suas primeiras versões.

A Fabric possui uma arquitetura altamente **modular** e **configurável**,
permitindo inovação, versatilidade e otimização para uma ampla gama de casos de
uso da indústria, incluindo bancos, finanças, seguros, assistência médica,
recursos humanos, cadeia de suprimentos e até distribuição de música digital.

A Fabric, é a primeira plataforma de livro-razão distribuído a suportar 
**contratos inteligentes criados em linguagens de programação de uso geral** 
como Java, Go e Node.js, em vez de linguagens específicas de domínio restrito 
(Domain-specific Languages - DSL). Isso significa que a maioria das empresas já
possui o conjunto de habilidades necessárias para desenvolver contratos 
inteligentes e não é necessário treinamento adicional para aprender um novo 
idioma ou DSL.

A plataforma Fabric também é **permissionada**, o que significa que, 
diferente de uma rede pública, sem identificação, os participantes são 
conhecidos uns pelos outros, em vez de anônimos, e _totalmente_ não 
confiáveis. Isso significa que, embora os participantes não confiem 
plenamente uns nos outros (eles podem, por exemplo, ser concorrentes 
no mesmo mercado), uma rede pode ser operada sob um modelo de 
governança baseada na confiança que _existe_ entre os participantes, 
como um contrato ou modelo para reger divergências.

Um dos diferenciais mais importantes da plataforma é o suporte aos
**protocolos de consenso plugáveis** o que permite que a plataforma 
seja mais customizável e atenda modelos de confiança e casos de uso
específicos. Paro exemplo, quando implantado em uma única empresa ou 
operado por uma autoridade confiável, consenso bizantino tolerante a 
falhas pode ser considerado desnecessário pois impacta na performance
e na taxa de transferência de dados. Em situações assim, um protocolo
de consenso [Tolerante a Falhas e Quebras](https://en.wikipedia.org/wiki/Fault_tolerance) (CFT)
pode ser mais do que adequado, enquanto que, em caso de uso 
descentralizado, um método mais tradicional de consenso com um
protocolo [Bizantino de Tolerância a Falhas](https://en.wikipedia.org/wiki/Byzantine_fault_tolerance)
(BFT) pode ser necessário.

A Fabric pode suportar protocolos de consenso que **não se baseiam em
criptomoeda** para incentivar mineração ou para alimentar a execução
de contratos inteligentes. Evitar uma criptomoeda reduz alguns vetores
significativos de risco/ataque. A ausência de operações de mineração 
criptográfica significa que a plataforma pode ser implementado com 
aproximadamente o mesmo custo operacional que qualquer outro sistema 
distribuído.

A combinação desses recursos de design diferenciados faz da Fabric uma
das **plataformas com melhor desempenho** disponíveis hoje, tanto em
termos de processamento de transações, latência na confirmação da 
transação, além de permitir **privacidade e confidencialidade** nas 
transações e nos contratos inteligentes (o que a Fabric chama 
"chaincode") que os implementa.

Vamos explorar esses recursos diferenciadores em mais detalhes.

## Modularidade

O Hyperledger Fabric foi arquitetado especificamente para ter uma
arquitetura modular. Seja com consenso plugável, gerenciamento de 
identidade conectável protocolos como LDAP ou OpenID Connect, 
protocolos de gerenciamento de chaves ou bibliotecas criptográficas, a 
plataforma foi projetada em seu núcleo para ser configurada para
atender à diversidade de requisitos de casos de uso corporativos.

Em alto nível, o Fabric é composto pelos seguintes componentes modulares:

- Um _serviço de pedidos_ conectável estabelece um consenso na ordem 
das transações e depois transmite blocos aos pares.
- Um _provedor de serviços de associação_ conectável é responsável por
associar entidades na rede com identidades criptográficas.
- Um serviço opcional de _comunicação ponto-a-ponto_ divulga os blocos
produzidos pelo serviço de pedidos aos outros pares.
- Contratos inteligentes ("chaincode") executados isoladamente em um 
ambiente de contêiner (por exemplo, Docker). Eles podem ser escritos
em linguagens de programação padrão, mas não tem acesso direto ao 
do livro-razão.
- O livro-razão pode ser configurado para suportar uma variedade de
SGBDs.
- Ter políticas de reconhecimento e validação conectáveis e que possam
ser configurados independentemente por cada aplicativo.

Existe um acordo justo no setor de que não existe "um blockchain único
para tudo". A Hyperledger Fabric pode ser configurada de várias maneiras
para satisfazer as diversas necessidades para vários casos de uso.

## Blockchains Com Permissão ou Sem Permissão

Em uma blockchain sem permissão, praticamente qualquer um pode
participar e todos os participants são anônimos. Nesse contexto, não
pode haver outra confiança senão o estado da blockchain, que antes de
mais nada, é imutável. Para atenuar essa falta de confiança, 
blockchains sem permissão normalmente empregam uma criptomoeda nativa
"minerada" ou taxa por transação para fornecer incentivo econômico para
compensar os custos extraordinários na participação em uma forma de 
consenso bizantino tolerante a falhas com base na "prova de trabalho"
(PoW).

As blockchains **com permissão**, por outro lado, operam uma blockchain 
em um conjunto de participantes conhecidos, identificados e 
frequentemente controlados, que operam sob um modelo de governança que
gera um certo grau de confiança. Uma blockchain com permissão fornece 
uma maneira de proteger as interações entre um grupo de entidades que 
têm um objetivo em comum, mas que podem não confiar totalmente uma na 
outra. Ao confiar nas identidades dos participantes, uma blockchain
com permissão pode usar protocolos de consenso mais tolerantes a
falhas de falha (CFT) ou tolerantes a falhas bizantinas (BFT) que não
exigem mineração dispendiosa.

Além disso, no contexto com permissão, o risco da introdução 
intencional de um código malicioso por um participante usando um 
contrato inteligente diminui. Primeiro, os participantes se conhecem e
todas as ações, seja enviar transações de aplicativos, modificar a
configuração da rede ou implantar um contrato inteligente, são 
registradas no blockchain, seguindo uma política de endosso que foi 
estabelecida para a rede e o tipo de transação. Por não ser 
completamente anônimo, a parte culpada pode ser facilmente identificada
e o incidente tratado de acordo com os termos do modelo de governança.

## Smart Contracts

Um contrato inteligente, ou o que a Fabric chama de "chaincode",
funciona como um aplicativo distribuído confiável que garante sua 
segurança/confiança do blockchain e do consenso subjacente entre os 
pares. É a lógica de negócios de um aplicativo blockchain.

Existem três pontos principais que se aplicam a contratos inteligentes,
especialmente quando aplicados a uma plataforma:

- many smart contracts run concurrently in the network,
- they may be deployed dynamically (in many cases by anyone), and
- application code should be treated as untrusted, potentially even
malicious.

Most existing smart-contract capable blockchain platforms follow an
**order-execute** architecture in which the consensus protocol:

- validates and orders transactions then propagates them to all peer nodes,
- each peer then executes the transactions sequentially.

The order-execute architecture can be found in virtually all existing blockchain
systems, ranging from public/permissionless platforms such as
[Ethereum](https://ethereum.org/) (with PoW-based consensus) to permissioned
platforms such as [Tendermint](http://tendermint.com/),
[Chain](http://chain.com/), and [Quorum](http://www.jpmorgan.com/global/Quorum).

Smart contracts executing in a blockchain that operates with the order-execute
architecture must be deterministic; otherwise, consensus might never be reached.
To address the non-determinism issue, many platforms require that the smart
contracts be written in a non-standard, or domain-specific language
(such as [Solidity](https://solidity.readthedocs.io/en/v0.4.23/)) so that
non-deterministic operations can be eliminated. This hinders wide-spread
adoption because it requires developers writing smart contracts to learn a new
language and may lead to programming errors.

Further, since all transactions are executed sequentially by all nodes,
performance and scale is limited. The fact that the smart contract code executes
on every node in the system demands that complex measures be taken to protect
the overall system from potentially malicious contracts in order to ensure
resiliency of the overall system.

## A New Approach

Fabric introduces a new architecture for transactions that we call
**execute-order-validate**. It addresses the resiliency, flexibility,
scalability, performance and confidentiality challenges faced by the
order-execute model by separating the transaction flow into three steps:

- _execute_ a transaction and check its correctness, thereby endorsing it,
- _order_ transactions via a (pluggable) consensus protocol, and
- _validate_ transactions against an application-specific endorsement policy
before committing them to the ledger

This design departs radically from the order-execute paradigm in that Fabric
executes transactions before reaching final agreement on their order.

In Fabric, an application-specific endorsement policy specifies which peer
nodes, or how many of them, need to vouch for the correct execution of a given
smart contract. Thus, each transaction need only be executed (endorsed) by the
subset of the peer nodes necessary to satisfy the transaction's endorsement
policy. This allows for parallel execution increasing overall performance and
scale of the system. This first phase also **eliminates any non-determinism**,
as inconsistent results can be filtered out before ordering.

Because we have eliminated non-determinism, Fabric is the first blockchain
technology that **enables use of standard programming languages**.

## Privacy and Confidentiality

As we have discussed, in a public, permissionless blockchain network that
leverages PoW for its consensus model, transactions are executed on every node.
This means that neither can there be confidentiality of the contracts
themselves, nor of the transaction data that they process. Every transaction,
and the code that implements it, is visible to every node in the network. In
this case, we have traded confidentiality of contract and data for byzantine
fault tolerant consensus delivered by PoW.

This lack of confidentiality can be problematic for many business/enterprise use
cases. For example, in a network of supply-chain partners, some consumers might
be given preferred rates as a means of either solidifying a relationship, or
promoting additional sales. If every participant can see every contract and
transaction, it becomes impossible to maintain such business relationships in a
completely transparent network --- everyone will want the preferred rates!

As a second example, consider the securities industry, where a trader building
a position (or disposing of one) would not want her competitors to know of this,
or else they will seek to get in on the game, weakening the trader's gambit.

In order to address the lack of privacy and confidentiality for purposes of
delivering on enterprise use case requirements, blockchain platforms have
adopted a variety of approaches. All have their trade-offs.

Encrypting data is one approach to providing confidentiality; however, in a
permissionless network leveraging PoW for its consensus, the encrypted data is
sitting on every node. Given enough time and computational resource, the
encryption could be broken. For many enterprise use cases, the risk that their
information could become compromised is unacceptable.

Zero knowledge proofs (ZKP) are another area of research being explored to
address this problem, the trade-off here being that, presently, computing a ZKP
requires considerable time and computational resources. Hence, the trade-off in
this case is performance for confidentiality.

In a permissioned context that can leverage alternate forms of consensus, one
might explore approaches that restrict the distribution of confidential
information exclusively to authorized nodes.

Hyperledger Fabric, being a permissioned platform, enables confidentiality
through its channel architecture and [private data](./private-data/private-data.html)
feature. In channels, participants on a Fabric network establish a sub-network
where every member has visibility to a particular set of transactions. Thus, only
those nodes that participate in a channel have access to the smart contract
(chaincode) and data transacted, preserving the privacy and confidentiality of
both. Private data allows collections between members on a channel, allowing
much of the same protection as channels without the maintenance overhead of
creating and maintaining a separate channel.

## Pluggable Consensus

The ordering of transactions is delegated to a modular component for consensus
that is logically decoupled from the peers that execute transactions and
maintain the ledger. Specifically, the ordering service. Since consensus is
modular, its implementation can be tailored to the trust assumption of a
particular deployment or solution. This modular architecture allows the platform
to rely on well-established toolkits for CFT (crash fault-tolerant) or BFT
(byzantine fault-tolerant) ordering.

Fabric currently offers a CFT ordering service implementation
based on the [`etcd` library](https://coreos.com/etcd/) of the [Raft protocol](https://raft.github.io/raft.pdf).
For information about currently available ordering services, check
out our [conceptual documentation about ordering](./orderer/ordering_service.html).

Note also that these are not mutually exclusive. A Fabric network can have
multiple ordering services supporting different applications or application
requirements.

## Performance and Scalability

Performance of a blockchain platform can be affected by many variables such as
transaction size, block size, network size, as well as limits of the hardware,
etc. The Hyperledger Fabric [Performance and Scale working group](https://wiki.hyperledger.org/display/PSWG/Performance+and+Scale+Working+Group)
currently works on a benchmarking framework called [Hyperledger Caliper](https://wiki.hyperledger.org/projects/caliper).

Several research papers have been published studying and testing the performance
capabilities of Hyperledger Fabric. The latest [scaled Fabric to 20,000 transactions per second](https://arxiv.org/abs/1901.00910).

## Conclusion

Any serious evaluation of blockchain platforms should include Hyperledger Fabric
in its short list.

Combined, the differentiating capabilities of Fabric make it a highly scalable
system for permissioned blockchains supporting flexible trust assumptions that
enable the platform to support a wide range of industry use cases ranging from
government, to finance, to supply-chain logistics, to healthcare and so much
more.

Hyperledger Fabric is the most active of the Hyperledger projects. The community
building around the platform is growing steadily, and the innovation delivered
with each successive release far out-paces any of the other enterprise blockchain
platforms.

## Acknowledgement

The preceding is derived from the peer reviewed
["Hyperledger Fabric: A Distributed Operating System for Permissioned Blockchains"](https://dl.acm.org/doi/10.1145/3190508.3190538) - Elli Androulaki, Artem
Barger, Vita Bortnikov, Christian Cachin, Konstantinos Christidis, Angelo De
Caro, David Enyeart, Christopher Ferris, Gennady Laventman, Yacov Manevich,
Srinivasan Muralidharan, Chet Murthy, Binh Nguyen, Manish Sethi, Gari Singh,
Keith Smith, Alessandro Sorniotti, Chrysoula Stathakopoulou, Marko Vukolic,
Sharon Weed Cocco, Jason Yellick
